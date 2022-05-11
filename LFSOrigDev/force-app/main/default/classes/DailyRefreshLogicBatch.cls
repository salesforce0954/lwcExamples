/**
* @author Original: Andre Calimlim Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

global class DailyRefreshLogicBatch implements Database.batchable<SObject>{ 

   //global Iterable<Opportunity> start(Database.batchableContext info){ 
   global Database.QueryLocator start(Database.batchableContext info){
       //return new OppIterableCall(); 
          
       String query = ('SELECT  id, Live_Propensity_Score__c, Propensity_Score__c, StageName, OwnerID, RecordType.Name ' +
                       'FROM   Opportunity WHERE CreatedDate > LAST_QUARTER');
       system.debug('Query String Var:' + query);
       return Database.getQueryLocator(query);
   }    
    
   global void execute(Database.batchableContext info, List<Opportunity> scope){ 
   
       Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task;
       Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
       Id TaskRecordTypeId = TaskRecordTypeInfo.get('Lead Process').getRecordTypeId();
       
       User u = [SELECT Id FROM User WHERE Name = 'GE Capital Queue User'];
       
       List<Opportunity> oppsToUpdate = new List<Opportunity>(); 
       Set<Id> opportunityIDs = new Set<Id>();
       Map<String, Integer> callScore7Days = new Map<String, Integer>();
       Map<Id, Integer> callScore30Days = new Map<Id, Integer>();
       
       for(Opportunity a : scope){ 
           opportunityIDs.add(a.Id);
       }
       
       //query for 7 days
       for(AggregateResult tasks: [SELECT WhatId, COUNT(ID) recordCount FROM Task WHERE WhatId in: opportunityIDs AND RecordTypeId =: TaskRecordTypeId AND CreatedDate >= LAST_N_DAYS:7 GROUP BY WhatId ]){
           callScore7Days.put(String.valueOf(tasks.get('WhatId')), Integer.valueOf(tasks.get('recordCount'))); 
       }
       
       //query for 30 days
       for(AggregateResult tasks: [SELECT WhatId, COUNT(ID) recordCount FROM Task WHERE WhatId in: opportunityIDs AND RecordTypeId =: TaskRecordTypeId AND CreatedDate >= LAST_N_DAYS:30 GROUP BY WhatId ]){
           callScore30Days.put(String.valueOf(tasks.get('WhatId')), Integer.valueOf(tasks.get('recordCount'))); 
       }
       
       for(Opportunity a : scope){ 
           if( (a.StageName == 'New' || 
               a.StageName == 'Customer Not Available' ||
               a.StageName == 'No Answer' ||
               a.StageName == 'Left Message') &&
               a.OwnerId != u.Id &&
               a.RecordType.Name == 'Lead Process') {
                
               a.Call_End_Date_Time__c = NULL;
               a.InPlay__c = FALSE;
               a.Processed__c = FALSE;
               a.Call_Start_Date_Time__c = NULL;
               a.Paused__c = FALSE;
               a.Pause_Date_Time__c = NULL;
               a.Cumulative_Pause_Time__c = NULL;   
               a.OwnerId = u.Id;
           }
           a.Live_Propensity_Score__c = a.Propensity_Score__c;
           if(callScore7Days.containsKey(a.ID)) {
               a.X7DayCallScore__c = callScore7Days.get(a.Id);
           } else {
               a.X7DayCallScore__c = 0;
           }
           if(callScore30Days.containsKey(a.ID)) {
               a.X30DayCallScore__c = callScore30Days.get(a.Id);
           } else {
               a.X30DayCallScore__c = 0;
           }
           oppsToUpdate.add(a); 
       } 
       update oppsToUpdate; 
   } 
       
   global void finish(Database.batchableContext info){     
   } 
   
}