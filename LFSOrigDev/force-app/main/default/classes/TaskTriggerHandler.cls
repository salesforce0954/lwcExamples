/* 
    Author: Michael Lasala Cloud Sherpas
    Created Date: 02/11/13
    Description: Class for Task Triggers


    @author:Sridhara Vijayappa, on 2014/04/03       
    This Triggerhandler class is used to update Actual completion date and status for
    task type 'Email - Outbound'
            
    @Revision History                                               
    ----------------

*/
public with sharing class TaskTriggerHandler{

static Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task;
static Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
static Id TaskRecordTypeId = TaskRecordTypeInfo.get('Lead Process').getRecordTypeId();
static Id AccreditationRecordTypeId = TaskRecordTypeInfo.get('Accreditations').getRecordTypeId();

    
    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 02/12/13
    Description: Trigger to update count of X30DayCallScore__c and X7DayCallScore__c
    */    
    public void updateCallScore(List<Task> tasks, Integer noOfDays){

        Set<Id> oppID = new Set<Id>();
        for(Task t: tasks){
            if(t.RecordTypeId == TaskRecordTypeId)
                oppID.add(t.WhatId);
        }
        
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        for(Task t: [SELECT WhatId, Id FROM Task WHERE WhatId in: oppID AND RecordTypeId =: TaskRecordTypeId AND CreatedDate >=: System.today()-noOfDays]){
            if(taskMap.containsKey(t.WhatId)){
                taskMap.get(t.WhatId).add(t);
            } else {
                List<Task> tempTask = new List<Task>();
                tempTask.add(t);
                taskMap.put(t.WhatId, tempTask);
            }
        }
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity o: [SELECT Id, X7DayCallScore__c, X30DayCallScore__c, PlayPageSave__c FROM Opportunity WHERE Id in: oppID]){
            if(taskMap.containsKey(o.Id)){
                if(noOfDays == 7)
                    o.X7DayCallScore__c = taskMap.get(o.ID).size();
                if(noOfDays == 30)
                    o.X30DayCallScore__c = taskMap.get(o.ID).size();
                o.PlayPageSave__c = true;
                oppList.add(o);
            }
        }
        
        if(!oppList.isEmpty()){
            update oppList;
        }
    } 

}//End Triggerhandler