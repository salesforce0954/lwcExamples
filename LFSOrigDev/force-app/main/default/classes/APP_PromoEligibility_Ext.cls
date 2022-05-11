/* @Description: Extension for promo eligibility page
 * @Author: Mike Lasala
 * @Date Created: 10-AUG-2016
 */
public class APP_PromoEligibility_Ext{
    
    public final Promo__c promo  {get; set;}
    public List<Rule__c> ruleList {get; set;}
    public Map<String, List<Condition__c>> ruleConditionMap {get; set;}
    public Boolean displayEligibility {get; set;}
    public List<String> loanValues {get; set;}
    public List<String> riskGrades {get; set;}
    
    public APP_PromoEligibility_Ext(ApexPages.StandardController controller){
        
        if(!Test.isRunningTest()){
            //Add other fields
            controller.addFields(new List<String>{'Name','DM__c'});
        }
 
        //Retrieve promo record
        promo = (Promo__c)controller.getRecord();
        System.debug('$$$ promo: '+promo);
        
        ruleConditionMap = new Map<String, List<Condition__c>>();
        displayEligibility = false;
        
        //Retrieve related rules and conditions from rule set
        ruleList = [SELECT  Name, 
                            Order__c, 
                            IsActive__c, 
                            (SELECT Order__c, 
                                    Free_Text__c, 
                                    Operation__c,
                                    LHS_Field_Name__c
                             FROM   Conditions__r 
                             ORDER BY Order__c ASC)
                    FROM    Rule__c 
                    WHERE   Rule_Set__r.Promo__c =: promo.Id 
                    AND     Order__c < 4
                    ORDER BY Order__c ASC LIMIT 3];
        
        if(!ruleList.isEmpty()){
            for(Rule__c r: ruleList){
                
                //Map conditions for each rule
                ruleConditionMap.put(r.Name, r.Conditions__r);
                
                for(Condition__c c: r.Conditions__r){
                    if(r.Order__c == 1 &&   //Loan amount
                        c.Free_Text__c != null && 
                        promo.DM__c){
                        
                        //Display eligibility when loan amount condition has a value
                        displayEligibility = true;
                        
                    } else if(r.Order__c == 2){    //Loan values
                    
                        loanValues = formatString(c.Free_Text__c);
                        
                    } else if(r.Order__c == 3){     //Risk grades
                    
                        riskGrades = formatString(c.Free_Text__c);
                        
                        if(!riskGrades.isEmpty() && 
                            promo.DM__c){
                            
                            //Display eligibility when risk grade condition has a value
                            displayEligibility = true;
                        }
                    }
                }
            }
        } else {
            Util.addMessage(ApexPages.Severity.ERROR, 'No Eligiblity found');
        }
        System.debug('$$$ ruleList: '+ruleList);
        System.debug('$$$ ruleConditionMap: '+ruleConditionMap);
        
        //Display eligibility section:
        if(!promo.DM__c){  //Promo is a direct marketing campaign
            displayEligibility = true;
        }
    }
    
    /*  Description: Get eligibility 1 drop down list
     *  Author: Mike Lasala
     *  Date Created: 11-AUG-2016
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getEligibility1Options(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Total_Loan_Amount_New_Cash_Without_Fees__c', 'New Cash'));
        options.add(new SelectOption('Total_Loan_Amount_with_Insurance__c', 'NAF'));
        return options; 
    }
    
    /*  Description: Get condition operations
     *  Author: Mike Lasala
     *  Date Created: 11-AUG-2016
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getConditionOperations(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Condition__c.Operation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options; 
    }
    
    /*  Description: Get loan purpose values
     *  Author: Mike Lasala
     *  Date Created: 12-AUG-2016
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getLoanPurposeValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        //Retrieve logged in user country
        User currentUser = [SELECT Country__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        
        List<Meta_ONR__c> metaONRList = [SELECT     Value__c, 
                                                    Region__c 
                                         FROM       Meta_ONR__c 
                                         WHERE      ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                                         AND        Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                                         AND        (Region__c =: currentUser.Country__c
                                         OR          Region__c =: GEN_OriginationsConstants.BOTH)
                                         ORDER BY   Value__c ASC];
        
        for(Meta_ONR__c mo: metaONRList){
            options.add(new SelectOption(mo.Value__c, mo.Value__c));
        }
        return options;
    }
    
    /*  Description: Get credit scores
     *  Author: Mike Lasala
     *  Date Created: 12-AUG-2016
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getCreditScores(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Rate__c.Credit_Score__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
        	if(p.getValue().length() <= 2){
            	options.add(new SelectOption(p.getValue(), p.getValue()));
        	}
        }
        return options;
    }
    
    /*  Description: Validate condition/s
     *  Author: Mike Lasala
     *  Date Created: 12-AUG-2016
     *  Input: None
		Return: Boolean
     */
    public Boolean validateEligibility(){
        Boolean isValid = true;
        Map<String, Boolean> activeRules = new Map<String, Boolean>();
        
        //Iterate over rules
        for(String ruleName: ruleConditionMap.keySet()){
            //Iterate over conditions
            for(Condition__c c: ruleConditionMap.get(ruleName)){
                
                if(ruleName == 'Eligibility 1'){    //Check if loan amount comparative value is null
                    if(c.Free_Text__c == null){
                        
                        //Mandatory for non direct marketing campaigns
                        if(!promo.DM__c){
                            //MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                            //Removed validation for eligibility 1
                            // c.Free_Text__c.addError('You must enter a value');
                            // isValid = false;
                        } else {
                            
                            //Disable rules for direct marketing campaigns
                            activeRules.put(ruleName, false);
                        }
                    } else {
                        if(promo.DM__c){
                            //Enable rules for direct marketing campaigns
                            activeRules.put(ruleName, true);
                        }
                    }
                    
                } /*else if(ruleName == 'Eligibility 3'){     //Check if risk grade comparative value is null
                    
                   if(riskGrades.isEmpty()){
                        //Mandatory for non direct marketing campaigns
                        if(!promo.DM__c){
                            Util.addMessage(ApexPages.Severity.ERROR, 'You must select at least one Credit Score');
                            isValid = false;
                        } else {
                            
                            //Disable rules for direct marketing campaigns
                            activeRules.put(ruleName, false);
                        }
                    } else {
                        if(promo.DM__c){
                            //Enable rules for direct marketing campaigns
                            activeRules.put(ruleName, true);
                        }
                    }
                    
                }*/
                System.debug('$$$ '+ruleName+': '+isValid);
            }
        }
        
        //Enable/disable rules for direct marketing campaigns
        if(promo.DM__c){
            for(Rule__c r: ruleList){
                if(activeRules.containsKey(r.Name)){
                    r.IsActive__c = activeRules.get(r.Name);
                    
                    if(activeRules.get(r.Name)){
                        
                        //Display eligiblity section
                        displayEligibility = activeRules.get(r.Name);
                    }
                }
            }
        }
        return isValid;
    }
    
    /*  Description: Upsert records related to promo (rule set, rules and conditions)
     *  Author: Mike Lasala
     *  Date Created: 10-AUG-2016
     *  Input: None
		Return: Void
     */
    public void saveEligiblity(){
        
        //Validate conditions
        if(validateEligibility()){
            
            if(!ruleList.isEmpty()){
                
                if(!ruleConditionMap.values().isEmpty()){
                    
                    List<Rule__c> rulesForUpdate = new List<Rule__c>();
                    List<Condition__c> conditionList = new List<Condition__c>();
                    
                    //Iterate over rules
                    for(Rule__c r: ruleList){
                        
                        //Iterate over conditions
                        for(Condition__c c: ruleConditionMap.get(r.Name)){
                            if(r.Order__c == 1){
                                
                                if(c.Free_Text__c != null){
                                    c.Free_Text__c = String.valueOf(Decimal.valueOf(c.Free_Text__c).setScale(2));
                                    r.IsActive__c = true;
                                } else {
                                    c.Free_Text__c = null;
                                    r.IsActive__c = false;
                                }
                                
                            } else if(r.Order__c == 2){    //Loan values
                            
                                c.Free_Text__c = formatMultiSelect(loanValues);
                                
                                r.IsActive__c = !loanValues.isEmpty();
                                
                            } else if(r.Order__c == 3){     //Risk grades
                            
                                c.Free_Text__c = formatMultiSelect(riskGrades);
                                
                                r.IsActive__c = !riskGrades.isEmpty();
                            }
                            conditionList.add(c);
                        }
                        rulesForUpdate.add(r);
                    }
                    
                    //Upsert rules
                    try{
                        upsert rulesForUpdate;
                        System.debug('$$$ rules upsert success: '+rulesForUpdate);
                    } catch(DMLException e){
                        System.debug('$$$ rules upsert error: '+e.getMessage());
                        ErrorHandlerException.recordException(e.getMessage(), 'APP_PromoEligibility_Ext', 'Rule__c', 'Class', null);
                        Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Rule');
                    }
                
                    if(!conditionList.isEmpty()){
                        
                        //Upsert conditions
                        try{
                            upsert conditionList;
                            System.debug('$$$ conditions upsert success: '+conditionList);
                        } catch(DMLException e){
                            System.debug('$$$ conditions upsert error: '+e.getMessage());
                            ErrorHandlerException.recordException(e.getMessage(), 'APP_PromoEligibility_Ext', 'Condition__c', 'Class', null);
                            Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Condition');
                        }
                        Util.addMessage(ApexPages.Severity.INFO, 'Save success');
                    }
                }
            }
        }
    }
    
    /*  Description: Show eligibility section when add is clicked on a promo where DM__c = true
     *  Author: Mike Lasala
     *  Date Created: 12-AUG-2016
     *  Input: None
		Return: Void
     */
    public void toggleEligibility(){
        if(displayEligibility){
            displayEligibility = false;
        } else {
            displayEligibility = true;
        }
    }
    
    /*  Description: Format multiselect value from selectList
     *  Author: Mike Lasala
     *  Date Created: 15-AUG-2016
     *  Input: List<String>
		Return: String
     */
    public String formatMultiSelect(List<String> values){
        String multiselectText = '';
        
        if(!values.isEmpty()){
            //Iterate over selected values
            for(String s: values){
                multiselectText += s+';';
            }
            //Trim last comma
            multiselectText = multiselectText.subString(0, multiselectText.length() - 1);
        }
        return multiselectText;
    }
    
    /*  Description: Format string to selectList
     *  Author: Mike Lasala
     *  Date Created: 15-AUG-2016
     *  Input: String
		Return: List<String>
     */
    public List<String> formatString(String values){
        List<String> multiselectText = new List<String>();
        if(values != null){
            multiselectText = values.split(';');
        }
        return multiselectText;
    }
    
    /*  Description: Clear selected loan purpose values
     *  Author: Mike Lasala
     *  Date Created: 23-AUG-2016
     *  Input: None
		Return: Void
     */
    public void clearloanValues(){
        loanValues.clear();
    }
    
    /*  Description: Clear selected risk grade values
     *  Author: Mike Lasala
     *  Date Created: 27-SEPT-2016
     *  Input: None
		Return: Void
     */
    public void clearRiskGrades(){
        riskGrades.clear();
    }
}