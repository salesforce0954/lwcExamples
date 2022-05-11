/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: October 29, 2013
Description: Wrapper Class to handle Rule VF Page on Rule Set Related List
* @History:
   =====================================================================
       10-29-13: Created - Mac
       11-13-13: Update - Mac   
       03-18-15: Added rateCards selectOptions method - Mike 
   =====================================================================
*/
public class RUL_RuleSetManagementExt {

    //Value of record to be deleted
    public String deleteId{get; set;}

    //Value of the selected condition Id
    public String selectedCondition {get; set;}

    //Value of the selected rule Id
    public String selectedRule {get; set;}

    //Determines the order up/down
    public String ruleDirection {get; set;}

    //Value of the Rule Order
    public Decimal selectedRuleOrder {get; set;}

    //Value of the selected Condition Order
    public Decimal selectedConditionOrder {get; set;}

    //The current rule set
    public String ruleSetId{get;set;}

    //The value of the total number of rules under the rule set
    public Integer ruleSize {get; set;}

    //Total number of conditions under the rule
    public Integer conditionSize {get; set;}

    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================
    public RUL_RuleSetManagementExt(ApexPages.StandardController controller) {
        sObject mysObject = (sObject)controller.getRecord();
        if(mysObject!=null) {
            ruleSetId = (Id)mysObject.get('Id');
        }    
    }
    

    /*  Description: Updates the Order field of the Condition
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-29-2013
     *  Input: None
     *  Return: null
     */
    public pageReference updateConditionOrder(){
        ruleWrapperList = null;
        String selConjPrev;
        Decimal conditionOrder;
        List<Condition__c> cList = new List<Condition__c>();
        //Gets the selected Condition
        Condition__c selCond = [Select Id, Order__c, Conjunction_to_Previous__c, Rule__c from Condition__c where Id = :selectedCondition and Order__c = :selectedConditionOrder];
        selConjPrev = selCond.Conjunction_to_Previous__c;
        Condition__c c = new Condition__c();

        //Checks if the button clicked is to move up/down
        if(ruleDirection == 'Up'){
                conditionOrder = selCond.Order__c - 1;
                selCond.Conjunction_to_Previous__c = '';               
                selCond.Order__c = conditionOrder;
                cList.add(selCond);
                c = [Select Id, Order__c, Rule__c, Conjunction_to_Previous__c from Condition__c where Order__c = :conditionOrder and Rule__c = :selCond.Rule__c];                    
                c.Order__c = conditionOrder + 1;
                c.Conjunction_to_Previous__c = selConjPrev;                
                cList.add(c) ;
        }
        else{
                conditionOrder = selCond.Order__c + 1;
                selCond.Order__c = conditionOrder;
                cList.add(selCond);
                c = [Select Id, Order__c, Rule__c, Conjunction_to_Previous__c from Condition__c where Order__c = :conditionOrder and Rule__c = :selCond.Rule__c];
                c.Order__c = conditionOrder - 1;
                cList.add(c);
        }
        try{
            update cList;
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Condition__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Condition.');
        }
        
        return null;
    }

    /*  Description: Updates the Order field of the Rule
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-29-2013
     *  Input: None
     *  Return: null
     */
    public pageReference updateRuleOrder(){
        ruleWrapperList = null;
        Decimal ruleOrder;
        List<Rule__c> ruleList = new List<Rule__c>();
        //Gets the selected Rule
        Rule__c selRul = [Select Id, Order__c from Rule__c where Id = :selectedRule and Order__c = :selectedRuleOrder];
        Rule__c rulToUpd = new Rule__c();

        //Checks the direction if moving up/down
        if(ruleDirection == 'Up'){
                ruleOrder = selRul.Order__c - 1;                
                selRul.Order__c = ruleOrder;
                ruleList.add(selRul);
                rulToUpd = [Select Id, Order__c, Rule_Set__c from Rule__c where Order__c = :ruleOrder and Rule_Set__c = :ruleSetId];                    
                rulToUpd.Order__c = ruleOrder + 1;                
                ruleList.add(rulToUpd) ;
        }
        else{
                ruleOrder = selRul.Order__c + 1;
                selRul.Order__c = ruleOrder;
                ruleList.add(selRul);
                rulToUpd = [Select Id, Order__c, Rule_Set__c from Rule__c where Order__c = :ruleOrder and Rule_Set__c = :ruleSetId];
                rulToUpd.Order__c = ruleOrder - 1;
                ruleList.add(rulToUpd);
        }

        try{
            update ruleList;    
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Rule__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while updating a Rule.');
        }
        
        return null;
    }

    /*  Description: Deletes the Rule under the Rule Set
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-29-2013
     *  Input: None
     *  Return: null
     */
    public pageReference deleteRule(){          
        ruleWrapperList = null;
        try{
                Rule__c rul = [Select Id from Rule__c where Id = :selectedRule];
                delete rul;     
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Rule__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error occured while deleting a Rule.');
        }
        return null;            
    }

    /*  Description: Adds a row of condition for a specific rule
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: null
     */
    public pageReference addCondition(){
        ruleWrapperList = null;
        Condition__c c = new Condition__c();
        List<Condition__c> cList = new List<Condition__c>();
        Condition__c con;
        
        if(String.isBlank(selectedCondition) == false){
            c = [Select Id, Rule__c, Order__c from Condition__c where Rule__c = :selectedCondition Limit 1];            
            cList = [Select Id, Rule__c from Condition__c where Rule__c = :c.Rule__c];
            conditionSize = cList.size();
            con = new Condition__c(Conjunction_to_Previous__c = '', Free_Text__c = '', LHS_Field_Name__c='', LHS_Object_Name__c='', Operation__c='', Rule__c = c.Rule__c,
                                            Order__c = conditionSize + 1, RHS_Field_Name__c='', RHS_Object_Name__c='', Type__c='');
        }        
        else{
            //no existing condition yet         
            conditionSize = 0;
            Rule__c r =  new Rule__c();
            if(String.isBlank(selectedRule) == false){
                con = new Condition__c(Conjunction_to_Previous__c = '', Free_Text__c = '', LHS_Field_Name__c='', LHS_Object_Name__c='', Operation__c='',
                                           Rule__c = selectedRule, Order__c = conditionSize + 1, RHS_Field_Name__c='', RHS_Object_Name__c='', Type__c='');
            }           
        }

        try{
                insert con;     
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Condition__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error was encountered while adding a condition.');
        }
        return null;            
    }

    /*  Description: Deletes the selected Condition
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: null
     */
    public pageReference deleteCondition() {
        ruleWrapperList  = null;        
        if(Util.nullCheck(selectedCondition)){      //05.14.15 Mike Lasala: Code Scan fix
            try{
                Condition__c con = [Select Id from Condition__c where Id = : selectedCondition];  
                delete con;          
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Condition__c', 'Class', null);
                Util.addMessage(ApexPages.Severity.ERROR, 'An error was encountered while deleting a condition.');
            }
        }
        return null;
    }

    /*  Description: Adds a Rule for a Rule Set
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-10-2013
     *  Input: None
     *  Return: null
     */
    public pageReference addRule(){
        ruleWrapperList = null;
        //Sets the Rule Set Id
        Rule__c newRule = new Rule__c(Rule_Set__c = ruleSetId, Order__c = ruleSize + 1);
        try{
            insert newRule; 
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Rule__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error was encountered while adding a rule.');
        }
        return null;
    }

    /*  Description: Saves the Rule and related Condition Records
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-11-2013
     *  Input: None
     *  Return: null
     */
    public pageReference saveCondition(){
        List<Condition__c> cList = new List<Condition__c>();
        List<Rule__c> ruleList = new List<Rule__c>();
        Set<Id> rateCardIds = new Set<Id>();
        List<Rate_Card__c> rateCardList = new List<Rate_Card__c>();
        System.debug('#### RULEWRAPPER ' + ruleWrapperList);
        for(RuleWrapper rw : ruleWrapperList){
            Rule__c r = rw.rule;
            cList.addAll(rw.conditionList);
            ruleList.add(r);
            rateCardIds.add(rw.rule.Rate_Card__c);  //Add selected Rate Card Ids to set
        }

        System.debug('$$$ rateCardIds: '+rateCardIds.size());
        if(!rateCardIds.isEmpty()){
            rateCardList = [SELECT Id FROM Rate_Card__c WHERE Id IN: rateCardIds];  //Retrieve Rate Cards
            System.debug('$$$ rateCardList: '+rateCardList.size());
            if(!rateCardList.isEmpty()){
                for(Rate_Card__c rc: rateCardList){
                    rc.Rule_Set_ID__c = ruleSetId;  //Assign Rule Set assocation
                }
            }
        }
        try{
            upsert ruleList;        
            upsert cList;   
            update rateCardList;
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementMDExt', 'Rule__c, Condition__c', 'Class', null);
            Util.addMessage(ApexPages.Severity.ERROR, 'An error was encountered while saving.');
        }
        
        ruleWrapperList = null;
        return null;
    }
    
    /*  Description: Constructs the Rules and Condition displayed
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-4-2013
     *  Input: None
     *  Return: null
     */
    public List<RuleWrapper> ruleWrapperList {
        get {
            if(ruleWrapperList==null) {
                List<Rule__c> rules = [SELECT id, name, rule_set__c, isActive__c, offer__c, order__c, stopOtherRulesIfPass__c, Rate_Card__c, 
                                                (SELECT id, name, rule__c, Order__c, Type__c, Free_Text__c, Operation__c, LHS_Object_Name__c, LHS_Field_Name__c, RHS_Object_Name__c, RHS_Field_Name__c,  Conjunction_to_Previous__c FROM conditions__r order by order__c ASC)
                                       FROM     rule__c
                                       WHERE    rule_set__c =: ruleSetId
                                       ORDER BY     order__c ASC
                                       ];
                ruleWrapperList = new List<RuleWrapper>();
                ruleSize = rules.size();
                for(Rule__c rule : rules) {
                    ruleWRapperList.add(new RuleWrapper(rule, rule.conditions__r));
                }
            }
            return ruleWrapperList;
        }
        set;
    }
    /*  Description: Populates the Rate Card Picklist
     *  Author: Michael Lasala
     *  Date Created: MAR-18-2015
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> rateCards{
        get{            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', 'None'));
            Rule_Set__c ruleSet = [SELECT Product_Version__c FROM Rule_Set__c WHERE Id =: ruleSetId];
            if(ruleSet != null){
                List<Rate_Card__c> rateCardList = [SELECT   Id, 
                                                            Name, 
                                                            Rate_Card_Name__c 
                                                   FROM     Rate_Card__c 
                                                   WHERE    Product_Version__c =: ruleSet.Product_Version__c];
                if(!rateCardList.isEmpty()){
                    for(Rate_Card__c rc: rateCardList){
                        options.add(new SelectOption(rc.Id, rc.Rate_Card_Name__c));
                    }
                }
            }
            return options;
        }
        set;
    }

    /*  Description: Populates the Condition Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionType{
        get{
            list<SelectOption> options = new list<SelectOption>();
          Condition__c c = new Condition__c();
          SObject obj = c;

          String fld = 'Type__c';
          Schema.sObjectType objType = obj.getSObjectType(); 
          
          Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
          
          map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
          
          list<Schema.PicklistEntry> values =
             fieldMap.get(fld).getDescribe().getPickListValues();
          // options.add(new SelectOption('--Please Select--', 'Please Select'));
          for (Schema.PicklistEntry a : values)
          { 
             options.add(new SelectOption(a.getValue(), a.getValue())); 
          }
          return options;   
        }
        set;      
    }

    /*  Description: Populates the Conjunction to Previous Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conjunctionToPrevious{
        get{            
            List<SelectOption> options = new List<SelectOption>();
                    options.add(new SelectOption('AND','AND'));
                    options.add(new SelectOption('OR','OR'));                       
                    return options;
        }
        set;
    }

    /*  Description: Populates the Condition Operation Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionOperation{
        get{
            List<SelectOption> options = new List<SelectOption>();
                    options.add(new SelectOption('=','='));
                    options.add(new SelectOption('>','>'));
                    options.add(new SelectOption('<','<'));
                    options.add(new SelectOption('<=','<='));
                    options.add(new SelectOption('>=','>='));
                    options.add(new SelectOption('!=','!='));
                    return options;
        }
        set;
    }
       
    /*  Description: Populates the RHS Object Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionRHSObject{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Application__c','Application'));
            options.add(new SelectOption('Application_Response__c','Application Response'));
            //options.add(new SelectOption('Liability__c','Liability'));
            return options; 
        }                
        set;
    }

    /*  Description: Populates the LHS Object Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionLHSObject{                     
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Application__c','Application'));
            options.add(new SelectOption('Application_Response__c','Application Response'));
            //options.add(new SelectOption('Liability__c','Liability'));
            return options; 
        }
        set;
    }

    /*  Description: Populates the LHS Field Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionLHSFields {                     
        get{
            List<selectOption> options = new List<selectOption>();
            SObject objApp;
            SObject objAppResp;
            SObject objLiab;
           
            Application__c app = new Application__c();
            objApp = app;
        
            Application_Response__c appRes = new Application_Response__c();
            objAppResp = appRes;

            Schema.sObjectType objTypeApp = objApp.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribeApp = objTypeApp.getDescribe();       

            map<String, Schema.SObjectField> fieldMapApp = objDescribeApp.fields.getMap();   
            // options.add(new SelectOption('--Please Select--', 'Please Select'));
            for(Schema.SObjectField field : fieldMapApp.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }

            Schema.sObjectType objType = objAppResp.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       

            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();               
            for(Schema.SObjectField field : fieldMap.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }

            return options;
        }
        set;
    }

    /*  Description: Populates the RHS Field Picklist
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> conditionRHSFields{
        get{
            List<selectOption> options = new List<selectOption>();
            SObject objApp;
            SObject objAppResp;
            sObject objLiab;
           
            Application__c app = new Application__c();
            objApp = app;
        
            Application_Response__c appRes = new Application_Response__c();
            objAppResp = appRes;

            Liability__c liab = new Liability__c();
            objLiab = liab;
            
            Schema.sObjectType objTypeApp = objApp.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribeApp = objTypeApp.getDescribe();       

            map<String, Schema.SObjectField> fieldMapApp = objDescribeApp.fields.getMap();   
            
            for(Schema.SObjectField field : fieldMapApp.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }    

            Schema.sObjectType objType = objAppResp.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       

            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();               
            for(Schema.SObjectField field : fieldMap.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }
            return options; 
        }                     
        set;
    }
    

    /*  Description: Wrapper Class to get Rule and Related Condition Records
     *  Author: Jan Mark Domingo
     *  Date Created: NOV-12-2013
     *  Input: Rule - the rule records related to the rule set
                ConditionList - the list of condtions related to the rule
     *  Return: None
     */
    public class RuleWrapper {
        public Rule__c rule {get;set;}        
        public List<Condition__c> conditionList {get;set;}
        public Integer conditionSize {get; set;}
        
        public RuleWrapper(Rule__c rule, List<Condition__c> conditionList) {
            this.rule = rule;
            this.conditionList = conditionList;
            this.conditionSize = conditionList.size();                                  
        }
    }

}