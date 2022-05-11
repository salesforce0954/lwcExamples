public class RUL_AdminRuleSetManagementExt {

    //Sobject parameter to get field names based on object
    private final sObject mysObject;
    //the selected Left Hand Side object
    public String selectedRule {get; set;}
    //the selected Right Hand Side object
    public ApexPages.StandardController stdCtrl {get; set;}
    public String pageURL {get; set;}
    public String selectedCondition {get; set;}
    public Integer index {get; set;}
    public Boolean refreshPage {get; set;}
    String ruleSetId;   
    //public List<RuleSetManagementWrapperFinal> rsWrapList {get; set;}
    
    public List<SelectOption> conditionOperation {get; set;}
    public List<SelectOption> conditionType {get; set;}
   
    public String selRHSObject {get; set;}
    public String selLHSObject {get; set;}
    Condition__c con = new Condition__c();
    Admin_Settings__c rm = new Admin_Settings__c();
    Application__c application = new Application__c();
    Application_Response__c appResponse = new Application_Response__c();

    public String sampleText {get; set;}

    public List<RuleSetManagementWrapperFinal> rsWrapList{
        get{
            System.debug('### RSWRAPLIST: ' + rsWrapList + ' ### ruleSetId  ' + ruleSetId);
            if(rsWrapList == null){
                rsWrapList = new List<RuleSetManagementWrapperFinal>();
                List<Rule__c> ruleList = [Select Id, Name, Offer__c, Offer__r.Name, IsActive__c, Rule_Set__c, stopOtherRulesIfPass__c, Order__c, (Select Conjunction_to_Previous__c,Free_Text__c,Id,LHS_Field_Name__c,LHS_Object_Name__c,Name,Operation__c,Order__c, RHS_Field_Name__c,RHS_Object_Name__c,Rule__c, Type__c from Conditions__r order by order__C ASC) from Rule__c where Rule_Set__c = :ruleSetId Order By Order__c ASC] ;
                Integer ruleCount = 0;
                for(Rule__c r : ruleList){ 
                    ruleCount ++;                      
                    RuleSetManagementWrapperFinal rsm = new RuleSetManagementWrapperFinal(r);                            
                    rsWrapList.add(rsm);                
                }                
            }
            System.debug('### RSWRAPLIST: ' + rsWrapList);
            return rsWrapList;            
        }
        set;
    }

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public RUL_AdminRuleSetManagementExt(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
        stdCtrl = stdController;
        refreshPage = false;
        ruleSetId = (Id)mysObject.get('Id');                
        //rsWrapList = new List<RuleSetManagementWrapperFinal>();               
        conditionOperation = Util.getPicklistvalues(con, 'Operation__c');
        conditionType = Util.getPicklistvalues(con, 'Type__c');        
        //constructRuleSetCondition();
        sampleText = 'Start';
    }

    @TestVisible private void constructRuleSetCondition(){ 
        //rsWrapList = new List<RuleSetManagementWrapperFinal>();                
        //Map<Id, List<Condition__c>> mapRuleCondition = new Map<Id, List<Condition__c>>();
        //Map<Rule__c, List<Condition__c>> mapRuleConditionFinal = new Map<Rule__c, List<Condition__c>>();
        List<Rule__c> ruleList = [Select Id, Name, Offer__c, Offer__r.Name, IsActive__c, Rule_Set__c, stopOtherRulesIfPass__c, Order__c, (Select Conjunction_to_Previous__c,Free_Text__c,Id,LHS_Field_Name__c,LHS_Object_Name__c,Name,Operation__c,Order__c, RHS_Field_Name__c,RHS_Object_Name__c,Rule__c, Type__c from Conditions__r order by order__C ASC) from Rule__c where Rule_Set__c = :ruleSetId Order By Order__c ASC] ;
        Integer ruleCount = 0;
        for(Rule__c r : ruleList){ 
            ruleCount ++;                      
            RuleSetManagementWrapperFinal rsm = new RuleSetManagementWrapperFinal(r);        
            
            rsWrapList.add(rsm);
            //RuleSetManagementWrapper rmw = new RuleSetManagementWrapper(r);
        }        
    }
    
    /**  Description: Constructor to pass value to wrapper
     *  Author: Jan Mark Domingo
     *  Date Created: 10-29-13
     *  Input Parameters: None
     */
    public class RuleSetManagementWrapperFinal{
        public Integer ruleCount {get; set;}
        public Rule__c rule {get; set;}
        public Boolean isAdd {get; set;}     
        List<SelectOption> conditionLHSFields;
        List<SelectOption> conditionRHSFields;

        public List<RuleConditionWrapper> rsconWrapList{
            get{
                System.debug('##### rsconWrapList ' + rsconWrapList + ' Size ' + this.rule.Conditions__r.size());
                if(rsconWrapList == null){
                    rsconWrapList =  new List<RuleConditionWrapper>();
                    for(Condition__c c : this.rule.Conditions__r){
           
                        Application__c application = new Application__c();
                        Application_Response__c appResponse = new Application_Response__c();

                        if(c.RHS_Object_Name__c == 'Application'){
                            conditionRHSFields = Util.getAllFields(application);
                        }          
                        else{
                            conditionRHSFields = Util.getAllFields(appResponse);
                        }

                        if(c.LHS_Object_Name__c == 'Application'){
                            conditionLHSFields = Util.getAllFields(application);
                        }          
                        else{
                            conditionLHSFields = Util.getAllFields(appResponse);
                        }
                        RuleConditionWrapper rcWrap = new RuleConditionWrapper(c.Id, c.Type__c, c.LHS_Object_Name__c, c.LHS_Field_Name__c, c.Operation__c, c.RHS_Object_Name__c, c.RHS_Field_Name__c);                            
                        rsconWrapList.add(rcWrap);                
                    }
                }
                System.debug('##### rsconWrapListFinal ' + rsconWrapList);
                return rsconWrapList;                    
            }
            set;
        }   
        //public List<RuleConditionWrapper> rsconWrapList {get; set;}
        /**  Description: Constructor to pass value to wrapper
         *  Author: Jan Mark Domingo
         *  Date Created: 10-29-13
         *  Input Parameters: rule - the rule related to the rule set
                              clist - the Conditions related to the rule
         */
        public RuleSetManagementWrapperFinal(Rule__c ruleObj){                            
            this.ruleCount = ruleCount;
            this.rule = ruleObj;             
        }
    }

    public void test(){

    }

    public void addCondition(){   
        Rule__c r  = new Rule__c();
       if(selectedRule != null){
        r = [Select Id from Rule__c where Id = : selectedRule];        
        RuleSetManagementWrapperFinal rsFinal;
        rsFinal.isAdd = true;
        rsFinal = new RuleSetManagementWrapperFinal(r);
       }       
       
       
       //RuleConditionWrapper rcw = new RuleConditionWrapper('','', '', '', '', '', '');
       //rsFinal.rsconWrapList.add(new RuleConditionWrapper('','', '', '', '', '', ''));
    }

    public PageReference deleteCondition(){
        rsWrapList = null;
        Rule_Set__c rset = (Rule_Set__c)stdCtrl.getRecord();       
        System.debug('**** selectedCondition ' + selectedCondition + ' ## rst: ' + rset);
        if(Util.nullCheck(selectedCondition)){      //05.14.15 Mike Lasala: Code Scan fix
            try{
                Condition__c con = [Select Id from Condition__c where Id = : selectedCondition];  
                delete con;          
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'RUL_RuleSetManagementExt', 'Condition__c', 'Class', null);
                Util.addMessage(ApexPages.Severity.ERROR, Label.Application_ID_Error);
            }
        }
        sampleText = 'Jan Mark Domingo';
        return null;        
    }

    public class RuleConditionWrapper{
        public String conditionId {get; set;}
        public String conditionType {get; set;}
        public String selLHS {get; set;}
        public String selLHSField {get; set;}
        public String operation {get; set;}
        public String selRHS {get; set;}
        public String selRHSField {get; set;}

        public List<SelectOption> getConditionRHSObject() {                
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('--Please Select--', 'Please Select'));
            for (Admin_Settings__c rm : Admin_Settings__c.getAll().values()){
                options.add(new SelectOption(rm.Value__c, rm.Value__c));
            }
            return options;                                    
        }

        public List<SelectOption> getConditionLHSObject() {                     
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('--Please Select--', 'Please Select'));
            for (Admin_Settings__c rm : Admin_Settings__c.getAll().values()){
                options.add(new SelectOption(rm.Value__c, rm.Value__c));
            }
            return options;
        }

        

        public List<SelectOption> getconditionLHSFields() {                     
            List<selectOption> options = new List<selectOption>();
            SObject obj;

            if(selLHS == 'Application'){
                Application__c app = new Application__c();
                obj = app;
            }        
            else{
                Application_Response__c appRes = new Application_Response__c();
                obj = appRes;
            }
            Schema.sObjectType objType = obj.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       

            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();   
            options.add(new SelectOption('--Please Select--', 'Please Select'));
            for(Schema.SObjectField field : fieldMap.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();                  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }               
            return options;
        }

        public List<SelectOption> getconditionRHSFields() {                     
            List<selectOption> options = new List<selectOption>();
            sObject obj;

            if(selRHS == 'Application'){
                Application__c app = new Application__c();
                obj = app;
            }        
            else{
                Application_Response__c appRes = new Application_Response__c();
                obj = appRes;
            }
            Schema.sObjectType objType = obj.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       

            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();   
            options.add(new SelectOption('--Please Select--', 'Please Select'));
            for(Schema.SObjectField field : fieldMap.values())  
            {  
                Schema.DescribeFieldResult fieldResult = field.getDescribe();  
                if(fieldResult.isAccessible()){  
                    options.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));                
                }  
            }               
            return options;
        }

        public RuleConditionWrapper(String conditionId, String conditionType, String selLHS, String selLHSField, String operation, String selRHS, String selRHSField){
            this.conditionId = conditionId;
            this.conditionType =  conditionType; 
            this.selLHS = selLHS; 
            this.selLHSField = selLHSField;
            this.operation = operation; 
            this.selRHS = selRHS;
            this.selRHSField = selRHSField;
        }
    }
}