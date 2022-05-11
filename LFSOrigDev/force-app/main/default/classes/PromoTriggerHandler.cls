/* @Description: Promo trigger handler
 * @Author: Mike Lasala
 * @Date Created: 17-AUG-2016
 */
public class PromoTriggerHandler{
    
    public static boolean isBeforeInsertExecuted = false;
    public static boolean isBeforeUpdateExecuted = false;
    public static boolean isBeforeDeleteExecuted = false;
    public static boolean isAfterInsertExecuted = false;
    public static boolean isAfterUpdateExecuted = false;
    public static boolean isAfterDeleteExecuted = false;
    public static boolean isAfterUndeleteExecuted = false;
    
    // public static void clear_execution_flags(){
        // isBeforeInsertExecuted = false;
        // isBeforeUpdateExecuted = false;
        // isBeforeDeleteExecuted = false;
        // isAfterInsertExecuted = false;
        // isAfterUpdateExecuted = false;
        // isAfterDeleteExecuted = false;
        // isAfterUndeleteExecuted = false;
    // }
    
    /* Method name: executeTriggerEvents
     * Purpose: This method checks the trigger events and accordingly execute the methods  along with the trigger context variables and data
     */
    public static void executeTriggerEvents(Boolean isBefore, Boolean isAfter, 
                                            Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
                                            Map<Id, Promo__c> oldMap, List<Promo__c> newList, Map<Id, Promo__c> newMap){
        if(isBefore){
            if(isInsert){
                if(!isBeforeInsertExecuted){
                    validatePromo(newList);
                    isBeforeInsertExecuted = true;
                }
            }
            
            if(isUpdate){
                if(!isBeforeUpdateExecuted){
                    updateRelatedRecords(newMap, oldMap);
                    isBeforeUpdateExecuted = true;
                }
            }
            
            if(isDelete){
                if(!isBeforeDeleteExecuted){
                    deleteRuleSet(oldMap);
                    isBeforeDeleteExecuted = true;
                }
            }
        }
        
        if(isAfter){
            if(isInsert){
                if(!isAfterInsertExecuted){
                    createRelatedRecords(newMap);
                    isAfterInsertExecuted = true;
                }
            }
            
            // if(isUpdate){
            //     if(!isAfterUpdateExecuted){
            //         // (newMap, oldMap);
            //         isAfterUpdateExecuted = true;
            //     }
            // }
            
            // if(isDelete){
            //     if(!isAfterDeleteExecuted){
            //         // (oldMap);
            //         isAfterDeleteExecuted = true;
            //     }
            // }
            
            // if(isUndelete){
            //     if(!isAfterUndeleteExecuted){
            //         // (oldMap);
            //         isAfterUndeleteExecuted = true;
            //     }
            // }
        }
    }
    
    /*  Description: Validate if campaign related to new promo has an existing promo
     *  Author: Mike Lasala
     *  Date Created: 20-SEPT-2016
     *  Input Parameters: List<Promo__c>
     *  Return: Void
     */
    public static void validatePromo(List<Promo__c> promoList){
        System.debug('$$$ PromoTriggerHandler.validatePromo');
        
        Set<Id> promoIds = new Set<Id>();
        
        for(Promo__c p: promoList){
            if(p.Campaign__c != null){
                promoIds.add(p.Campaign__c);
            }
        }
        
        if(!promoIds.isEmpty()){
            Set<Id> existingCampaignPromoIds = new Set<Id>();
            
            //Retrieve promos with the same campaign
            for(Promo__c existingPromos: [SELECT Campaign__c FROM Promo__c WHERE Campaign__c IN: promoIds]){
                existingCampaignPromoIds.add(existingPromos.Campaign__c);
            }
            
            for(Promo__c p: promoList){
                
                //Validate if new promo campaign has an existing promo
                if(existingCampaignPromoIds.contains(p.Campaign__c)){
                    p.addError('Campaign has an existing promo');
                }
            }
        }
    }
    
    /*  Description: Create default data for promo (rule set, rule and conditions)
     *  Author: Mike Lasala
     *  Date Created: 17-AUG-2016
     *  Input Parameters: Map<Id, Promo__c>
     *  Return: Void
     */
    public static void createRelatedRecords(Map<Id, Promo__c> newMap){
        System.debug('$$$ PromoTriggerHandler.createRelatedRecords');
        
        List<Rule_Set__c> ruleSetList = new List<Rule_Set__c>();
        Map<Id, List<Rule__c>> ruleSetMap = new Map<Id, List<Rule__c>>();
        List<Rule__c> ruleList;
        List<Condition__c> conditionList;
        Map<String, List<Condition__c>> ruleConditionMap = new Map<String, List<Condition__c>>();
        
        //Fixed number of rules per promo
        Integer ruleCount = 5;
        
        for(Promo__c p: newMap.values()){
            
            //Create rule set
            Rule_Set__c ruleSet = new Rule_Set__c();
            ruleSet.Rule_Set_Name__c = p.Name;
            ruleSet.Promo__c = p.Id;
            ruleSet.Type__c = 'Promo';
            ruleSetList.add(ruleSet);
            
            //New rules for rule set
            ruleList = new List<Rule__c>();
            
            for(Integer i=1; i<=ruleCount; i++){
                
                //New conditions for each rule
                conditionList = new List<Condition__c>();
                
                //Based on DM field (eligiblity is optional for direct marketing campaigns)
                Boolean isRuleActive = !p.DM__c;
                
                //Create conditions
                if(i == 1){
                    //Loan amount
                    conditionList.add(mapCondition('Application__c', 
                                                   '', 
                                                   '', 
                                                   null, 
                                                   false, 
                                                   1, 
                                                   ''));
                } else if(i == 2){
                    //Loan purpose value
                    conditionList.add(mapCondition('Loan_Purpose__c', 
                                                   'Value__c', 
                                                   '', 
                                                   null, 
                                                   false, 
                                                   1, 
                                                   '='));
                } else if(i == 3){
                    //Credit score
                    conditionList.add(mapCondition('Application__c', 
                                                   'Credit_Score__c', 
                                                   '', 
                                                   null, 
                                                   false, 
                                                   1, 
                                                   '='));
                } else if(i == 4){
                    //Home owner
                    conditionList.add(mapCondition('Applicant__c', 
                                                   'Res_Status__c', 
                                                   'Own a home with a mortgage', 
                                                   null, 
                                                   false, 
                                                   1, 
                                                   '='));
                    
                    conditionList.add(mapCondition('Applicant__c', 
                                                   'Res_Status__c', 
                                                   'Own a home outright', 
                                                   'OR', 
                                                   true, 
                                                   2, 
                                                   '='));
                    //Based on Home Owner field
                    isRuleActive = p.Home_Owner__c;
                    
                } else if(i == 5){
                    //Employment
                    conditionList.add(mapCondition('Income__c', 
                                                   'Years_With_Employer__c', 
                                                   String.valueOf(p.Minimum_Employment_Years__c), 
                                                   null, 
                                                   false, 
                                                   1, 
                                                   '>='));
                    
                    conditionList.add(mapCondition('Income__c', 
                                                   'Months_With_Employer__c', 
                                                   String.valueOf(p.Minimum_Employment_Months__c), 
                                                   'AND', 
                                                   true, 
                                                   2, 
                                                   '>='));
                    //Based on Employment field
                    isRuleActive = p.Employment__c;
                }
                
                //Create rule
                ruleList.add(mapRule('Eligibility '+i, i, isRuleActive));
                
                //Put to map for assigning parent rule
                ruleConditionMap.put('Eligibility '+i, conditionList);
            }
            
            //Put to map for assigning parent rule set
            ruleSetMap.put(p.Id, ruleList);
        }
        // System.debug('$$$ ruleSetMap: '+ruleSetMap);
        // System.debug('$$$ ruleConditionMap: '+ruleConditionMap);
        
        if(!ruleSetList.isEmpty()){
            //Insert rule set
            try{
                insert ruleSetList;
                System.debug('$$$ rule set insert success: '+ruleSetList);
            } catch(DMLException e){
                System.debug('$$$ rule set insert error: '+e.getMessage());
                ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Rule_Set__c', 'Class', null);
            }
            
            if(!ruleList.isEmpty()){
                List<Rule__c> finalRuleList = new List<Rule__c>();
                
                //Iterate over rules per rule set
                for(Rule_Set__c rs: ruleSetList){
                    for(Rule__c r: ruleSetMap.get(rs.Promo__c)){
                        //Assign parent rule set
                        r.Rule_Set__c = rs.Id;
                    }
                }
                
                //Insert rules
                try{
                    insert ruleList;
                    System.debug('$$$ rules insert success: '+ruleList);
                } catch(DMLException e){
                    System.debug('$$$ rules insert error: '+e.getMessage());
                    ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Rule__c', 'Class', null);
                }
                
                if(!conditionList.isEmpty()){
                    List<Condition__c> finalConditionList = new List<Condition__c>();
                    
                    //Iterate over conditions per rule
                    for(Rule__c r: ruleList){
                        for(Condition__c c: ruleConditionMap.get(r.Name)){
                            //Assign parent rule
                            c.Rule__c = r.Id;
                            finalConditionList.add(c);
                        }
                    }
                    
                    //Insert conditions
                    try{
                        insert finalConditionList;
                        System.debug('$$$ conditions insert success: '+finalConditionList);
                    } catch(DMLException e){
                        System.debug('$$$ conditions insert error: '+e.getMessage());
                        ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Condition__c', 'Class', null);
                    }
                }
            }
        }
    }
    
    /*  Description: Activate/deactivate rules based on promo values
     *  Author: Mike Lasala
     *  Date Created: 22-AUG-2016
     *  Input Parameters: Map<Id, Promo__c> (new values)
                          Map<Id, Promo__c> (old values)
     *  Return: Void
     */
    public static void updateRelatedRecords(Map<Id, Promo__c> newMap, Map<Id, Promo__c> oldMap){
        System.debug('$$$ PromoTriggerHandler.updateRelatedRecords');
        
        List<Rule__c> ruleList = new List<Rule__c>();
        List<Condition__c> conditionList = new List<Condition__c>();
        
        //Retrieve related rules and conditions to promo
        for(Rule__c r: [SELECT  Id, 
                                Rule_Set__r.Promo__c, 
                                Order__c, 
                                (SELECT    LHS_Field_Name__c, 
                                           Free_Text__c
                                 FROM      Conditions__r 
                                 ORDER BY  Order__c ASC)
                        FROM    Rule__c 
                        WHERE   Rule_Set__r.Promo__c IN: oldMap.keySet()]){
            
            if(r.Order__c == 4){    //Home owner rule
            
                //Only process rules which changed specific fields
                if((oldMap.get(r.Rule_Set__r.Promo__c).Home_Owner__c != 
                    newMap.get(r.Rule_Set__r.Promo__c).Home_Owner__c)){
                    
                    //Enable/disable rule based on field value
                    r.IsActive__c = newMap.get(r.Rule_Set__r.Promo__c).Home_Owner__c;
                    ruleList.add(r);
                }
            } else if(r.Order__c == 5){     //Employment rule
            
                //Only process rules which changed specific fields
                if((oldMap.get(r.Rule_Set__r.Promo__c).Employment__c != 
                    newMap.get(r.Rule_Set__r.Promo__c).Employment__c)){
                    
                    //Enable/disable rule based on field value
                    r.IsActive__c = newMap.get(r.Rule_Set__r.Promo__c).Employment__c;
                    ruleList.add(r);
                    
                    if(!newMap.get(r.Rule_Set__r.Promo__c).Employment__c){
                        //Flush employment values when false
                        newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Years__c = null;
                        newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Months__c = null;
                    }
                }
                
                //Only process conditions which changed specific fields
                if((oldMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Years__c != 
                    newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Years__c) || 
                
                   (oldMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Months__c != 
                    newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Months__c)){
                     
                    for(Condition__c c: r.Conditions__r){
                        if(c.LHS_Field_Name__c == 'Years_With_Employer__c'){
                            //Update comparative value based on field value
                            c.Free_Text__c = String.valueOf(newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Years__c);
                            
                        } else if(c.LHS_Field_Name__c == 'Months_With_Employer__c'){
                            //Update comparative value based on field value
                            c.Free_Text__c = String.valueOf(newMap.get(r.Rule_Set__r.Promo__c).Minimum_Employment_Months__c);
                        }
                        conditionList.add(c);
                    }
                }
            } else {    //Loan amount, loan purpose value and credit score rules
            
                //Only process rules which changed specific fields
                if(oldMap.get(r.Rule_Set__r.Promo__c).DM__c != 
                   newMap.get(r.Rule_Set__r.Promo__c).DM__c){
                    
                    // if(!newMap.get(r.Rule_Set__r.Promo__c).DM__c){
                        
                    //     //Enable rule when promo is not a direct marketing campaign
                    //     r.IsActive__c = true;
                    // } else {
                        
                        //Check comparative values of conditions because eligiblity is not mandatory for direct marketing campaigns
                        for(Condition__c c: r.Conditions__r){
                            if(c.Free_Text__c != null){
                                r.IsActive__c = true;
                            } else {
                                r.IsActive__c = false;
                            }
                        }
                    // }
                    ruleList.add(r);
                }
            }
        }
        // System.debug('$$$ ruleList: '+ruleList);
        // System.debug('$$$ conditionList: '+conditionList);
    
        //Update rules
        try{
            update ruleList;
            System.debug('$$$ rules update success: '+ruleList);
        } catch(DMLException e){
            System.debug('$$$ rules update error: '+e.getMessage());
            ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Rule__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Promo');
        }
        
        if(!conditionList.isEmpty()){
            //Update conditions
            try{
                update conditionList;
                System.debug('$$$ conditions update success: '+ruleList);
            } catch(DMLException e){
                System.debug('$$$ conditions update error: '+e.getMessage());
                ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Condition__c', 'Class', null);
                Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Promo');
            }
        }
    }
    
    /*  Description: Delete rule set related to promo
     *  Author: Mike Lasala
     *  Date Created: 18-AUG-2016
     *  Input Parameters: Map<Id, Promo__c>
     *  Return: Void
     */
    public static void deleteRuleSet(Map<Id, Promo__c> promoMap){
        System.debug('$$$ PromoTriggerHandler.deleteRuleSet');
        
        //Retrieve related rule sets
        List<Rule_Set__c> ruleSetList = [SELECT Id FROM Rule_Set__c WHERE Promo__c IN: promoMap.keySet()];
        
        if(!ruleSetList.isEmpty()){
            //Delete rule sets
            try{
                delete ruleSetList;
                System.debug('$$$ rule set delete success');
            } catch(DMLException e){
                System.debug('$$$ rule set delete error: '+e.getMessage());
                ErrorHandlerException.recordException(e.getMessage(), 'PromoTriggerHandler', 'Rule_Set__c', 'Class', null);
            }
        }
    }
    
    /*  Description: Map condition fields
     *  Author: Mike Lasala
     *  Date Created: 15-AUG-2016
     *  Input: String (object name)
               String (field name)
               String (free text value)
               String (condition conjuction)
               Boolean (if conjuction exists)
               Integer (order)
               String (operation)
		Return: Condition__c
     */
    public static Condition__c mapCondition(String objectName, 
                                            String fieldName, 
                                            String value, 
                                            String conjuction, 
                                            Boolean isConjuction, 
                                            Integer conditionOrder, 
                                            String operation){
        
        Condition__c condition = new Condition__c();
        condition.LHS_Object_Name__c = objectName;
        condition.LHS_Field_Name__c = fieldName;
        condition.Free_Text__c = value;
        condition.Type__c = 'Free Text';
        condition.Operation__c = operation;
        condition.Order__c = conditionOrder;
        
        if(isConjuction){
            condition.Conjunction_to_Previous__c = conjuction;
        }
        return condition;
    }
    
    /*  Description: Map rule fields
     *  Author: Mike Lasala
     *  Date Created: 17-AUG-2016
     *  Input: Condition__c 
               String (rule name)
               Integer (order)
               Boolean (active)
		Return: Rule__c
     */
    public static Rule__c mapRule(String ruleName, Integer ruleOrder, Boolean isActive){
        Rule__c rule = new Rule__c();
        rule.Name = ruleName;
        rule.Order__c = ruleOrder;
        rule.IsActive__c = isActive;
        return rule;
    }
}