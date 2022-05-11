/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Class to handle LeadEditPageOverride Logic
*/

public with sharing class LeadEditPageOverrideController {
        
        // Variable Declaration
    public List<TaskEventWrapper> tskEventWrapper {get;set;}
    public Opportunity oppVar {get; set;}
    public User usrVar {get; set;}
    public String initStatus;
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Constractor
    * @param 
    */
    
    public LeadEditPageOverrideController(Apexpages.Standardcontroller sc){
        // Call method to set opportunity and activity values
        setPageValues();
    }// End Contractor Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Method to set lead(opportunity) and related activity values
    * @param 
    */
    private void setPageValues(){
        String leadId = ApexPages.currentPage().getParameters().get('Id');
        // Set opportunity for edit
        oppVar = [Select Assigned_to_User__c, OwnerId, Mail_Date__c,Name,InPlay__c,AccountId,CampaignId, 
                         Call_Type__c,StageName, Time_Out__c,Reason__c, Branch_Name__c, Branch_Suburb__c,
                         Branch_ID__c,Branch_PostCode__c, Propensity_Score__c,Live_Propensity_Score__c,Description, 
                         Probability, Application_Number__c, CloseDate,DNS_Type__c from Opportunity where Id = :leadId];                    
        initStatus = oppVar.StageName;
        usrVar = [Select Name from User where Id = :oppVar.OwnerId];
        // Set Activity record related list
        setActivity();
    }// End setPageValues Method
        
        /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Method to initialized Activity Related List values
    * @param 
    */
    private void setActivity(){
            
        List<Task> taskList = [Select Id, Subject, WhatId, IsVisibleInSelfService, ActivityDate, Status,
                    Priority from Task where WhatId =: oppVar.Id];
        List<Event> eventList = [Select Id, Subject, WhatId, IsVisibleInSelfService, ActivityDate 
                     from Event where WhatId =: oppVar.Id];
                     
        tskEventWrapper = new List<TaskEventWrapper>();
        
        for(Task t : taskList){
            tskEventWrapper.add(new TaskEventWrapper(t));
        }// End For
        
        for(Event e : eventList){
            tskEventWrapper.add(new TaskEventWrapper(e));
        }// End For   
    }// End setActivity
    
        
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to perform Lead Save and allocate a new lead to pfr
    * @param
    * @last modified by: Michael Lasala     2/14/2013       Added try-catch to display validation rule errors on VF Page and added creation of Task
    */
    public PageReference populateNextLead(){ 
        try{
         User usrVar = [Select Id from User where Name = 'GE Capital Queue User'];
         oppVar.InPlay__c = false;
         
         if(oppVar.StageName == 'Set Follow-Up Call' && oppVar.Assigned_to_User__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, '\'Assigned to User\' Field is Required.');
            ApexPages.addMessage(myMsg);
            return null;
         }else if(oppVar.StageName == 'Set Follow-Up Call' && oppVar.Assigned_to_User__c != null){
            oppVar.OwnerId = oppVar.Assigned_to_User__c;
         }
         
         // Set propensity score to 0 and owner to GE Capital Queue User if the Stage = (Cancel,Left Message, No Answer, Customer Not Available)
         if(oppVar.StageName == 'Cancel' || 
                oppVar.StageName  == 'Left Message' || 
                oppVar.StageName == 'No Answer' || 
                oppVar.StageName == 'Customer Not Available'){
            
            List<Task> taskList = new List<Task>();
            Task tasks = new Task(
                    whatID = oppVar.ID,
                    Ownerid = oppVar.OwnerId,
                    Subject = oppVar.Call_Type__c,
                    Description = oppVar.Description,
                    Call_Outcome__c = oppVar.StageName
            );
            taskList.add(tasks);
            
            insert taskList;
            
            oppVar.Live_Propensity_Score__c = 0;
            oppVar.OwnerId = usrVar.Id;
         }// End If
            
         /*if(oppVar.StageName  == 'Left Message'){
            oppVar.Time_Out__c = system.today() + 30;
         }// End If*/
         
            update oppVar;
        
        
         LeadManagementController lmController = new LeadManagementController();
         String idVar = lmController.createLeadQueue();
                
         if(idVar!=null){
            return new PageReference('/apex/LeadEditPageOverride?Id=' + idVar).setRedirect(true);
         }else{
                 return Page.LeadManagementHome;
         }// End Else
        
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }// End populateNextLead Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to redirect user to Lead Management Home page
    * @param 
    */
    public PageReference returnLeadManagementHome(){
        Pagereference lhPage = Page.LeadManagementHome;
        return lhPage;
    }// End returnLeadManagementHome Method

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description 
    * @param 
    */
    public class TaskEventWrapper{
        public String oId {get;set;}
        public Id tId {get;set;}
        public String subj {get;set;}
        public String whatId {get;set;}
        public Boolean isVis {get;set;}
        public Date dte {get;set;}
        public String status {get;set;}
        public String prio {get;set;}
        public String assTo {get;set;}
        public TaskEventWrapper (Task t){
            this.oId = t.WhatId;
            this.tId = t.Id;
            this.subj = t.Subject;
            this.isVis = t.IsVisibleInSelfService;
            this.dte = t.ActivityDate;
            this.status = t.Status;
            this.prio = t.Priority;
        }   
        
        public TaskEventWrapper (Event e){
            this.oId = e.WhatId;
            this.subj = e.Subject;
            this.isVis = e.IsVisibleInSelfService;
            this.dte = e.ActivityDate;
        }
    }// End TaskEventWrapper 
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Get prefix for Task Object
    * @param 
    */
    public string getTaskPrefix(){
        // Get Task Prefix
        Schema.DescribeSObjectResult taskSchema = Schema.SObjectType.Task;
                string tPrefix = taskSchema.getKeyPrefix();
                return tPrefix;
    }// End getTaskPrefix Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Get prefix for Event Object
    * @param 
    */
    public string getEventPrefix(){
        // Get Event Prefix
        Schema.DescribeSObjectResult eventSchema = Schema.SObjectType.Event;
                string ePrefix = eventSchema.getKeyPrefix();
        return ePrefix;
    }// End getEventPrefix Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Method to redirect to new task standard page
    * @param 
    */
    public pageReference newTask(){
        Pagereference pageRef = new Pagereference('/' + getTaskPrefix() + '/e?who_id='+oppVar.AccountId + '&what_id='+oppVar.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }// End newTask Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 12 Feb 2013
    * @description Method to redirect to new event standard page
    * @param 
    */
        public pageReference newEvent(){
        Pagereference pageRef = new Pagereference('/' + getEventPrefix() + '/e?who_id='+oppVar.AccountId + '&what_id='+oppVar.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }// End newEvent Method
}// End LeadEditPageOverrideController Class