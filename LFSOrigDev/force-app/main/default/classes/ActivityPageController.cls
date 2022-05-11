/*
Author: Michael Lasala Cloud Sherpas
Created Date: 2/18/2013
Description: Activity Page on GEPlayPage2
Last Modified: Michael Lasala       3/17/2013       Added sorting of query to latest Tasks descending 
*/

public with sharing class ActivityPageController{
    //Variable Declaration
    public List<activityWrapper> actWrap {get; set;}
    public String oppURL = ApexPages.currentPage().getParameters().get('oppid');
    public Boolean showActivityDetail {get; set;}
    public DateTime actionDate{get; set;}
    public DateTime createdDate{get; set;}
    public Task taskVar {get; set;}
    public string taskIdStr {get; set;}
    public String aoHolder{get;set;}
    
    
    public ActivityPageController(){
        showActivityDetail = false;
        actWrap = new List<activityWrapper>();
        
        //Query related Tasks of Opportunity
        for(Task t: [SELECT  Id, 
                             RecordType.Name, 
                             What.Name, 
                             CreatedDate, 
                             ActivityDate, 
                             Owner.Name, 
                             Call_Outcome__c, 
                             Subject, 
                             Description 
                     FROM    Task 
                     WHERE   WhatId =: oppURL 
                       AND   (isArchived = false OR isArchived = true) 
                   ORDER BY  CreatedDate DESC LIMIT 25]){
            actWrap.add(new activityWrapper(t));
        }//End for
        
    }//End Constructor
    
    public class activityWrapper{
        public String Type {get; set;}
        public String relTo {get; set;}
        public Id actId {get; set;}
        public String Subject {get; set;}
        public DateTime dte {get; set;}
        public String Outcome {get; set;}
        public String assTo {get; set;}
        public DateTime createDateVar {get; set;}
        public String holder;
        
        //Display of Tasks on Page
        public activityWrapper(Task t){
            this.Type = t.Subject;
            this.relTo = t.What.Name;
            this.actId = t.Id;
            this.Subject = t.Description;
            
            
            if(t.RecordType.Name == 'Lead Process'){
                // If recordtype is 'Lead Process', show created date as action date on display
                this.dte = t.CreatedDate;
            }
            
            if(t.RecordType.Name == 'Call Back'){
                    // If recordtype is 'Call Back', show duedate(Activity Date) as action date on display
                    this.dte = t.ActivityDate;
            }
            
            if(/*t.Call_Outcome__c == 'Set Follow-Up Call' && */t.RecordType.Name == 'Call Back'){
                this.Outcome = 'Scheduled Call';
            }else{
                this.Outcome = t.Call_Outcome__c;
            }
            if(this.dte!=null) {
                this.dte = DateTime.newInstanceGmt(dte.date(), dte.time());
            }
            this.assTo = t.Owner.Name;
        }
        
    }//End activityWrapper
    
    //Display of Activity Informartion once Info button is clicked
    public void setupActivityDetails(){
        showActivityDetail = true;
        taskVar = [Select Id, RecordType.Name, CreatedDate, ActivityDate, Call_Outcome__c, Owner.Name, What.Name, Description from Task where Id = :taskIdStr];
        
            if(taskVar.RecordType.Name == 'Lead Process'){
                // If recordtype is 'Lead Process', show created date as action date on display
                actionDate = taskVar.CreatedDate;
            }// End If
            
            if(taskVar.RecordType.Name == 'Call Back'){ 
                // If recordtype is 'Call Back', show duedate(Activity Date) as action date on display
                actionDate = taskVar.ActivityDate; 
            }// End If
            if(/*taskVar.Call_Outcome__c == 'Set Follow-Up Call' && */taskVar.RecordType.Name == 'Call Back'){
                aoHolder = 'Scheduled Call';
            }else{
                aoHolder = taskVar.Call_Outcome__c;
            }
            if(actionDate!=null) {
                actionDate = DateTime.newInstanceGmt(actionDate.date(), actionDate.time());
            } 
            createdDate = DateTime.newInstanceGmt(taskVar.createdDate.date(), taskVar.createdDate.time());

    }//End setupActivityDetails
    
}//End ActivityPageController