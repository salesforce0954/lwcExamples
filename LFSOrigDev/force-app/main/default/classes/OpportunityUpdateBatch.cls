/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Batch class to perform opportunity exclusion
*/

global class OpportunityUpdateBatch implements Database.batchable<sObject>{ 
   //global List<Opportunity> start(Database.batchableContext info){ 
   global Database.querylocator start(Database.batchableContext info){
      //return new list<Opportunity >([SELECT Id,AccountId,Excluded_Date__c,PostCode_Exclusion__c,Mail_Code__c FROM Opportunity where Excluded_Date__c = null]);
       String query = ('SELECT  AccountId, Excluded_Date__c, PostCode_Exclusion__c, Mail_Code__c, closeDate, Exclusion_Reason__c, Lead_Source_Exclusion__c ' +
                        'FROM   Opportunity ' +
                        'WHERE  Excluded_Date__c = null ' +
                        'AND    Lead_Source_Exclusion__c = \'Not Applicable\''); // Updated by RCADAPAN for TQLQW-489 - Excluding Veda leads for this batch process. Key field (Name: Lead_Source_Exclusion__c) (Type: Formula Text)
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Opportunity> scope){ 
       ExclusionLogicController eLController = new ExclusionLogicController();
       eLController.OpportunityExclusion(scope);
   }     
   global void finish(Database.batchableContext info){     
   } 
}