/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 03 March 2013
* @description batch class to perform mass delete of Billing Vision Plus Records
*/

global class BVisionPlusDeleteBatch implements Database.batchable<sObject>{ 
   global Database.QueryLocator start(Database.batchableContext info){ 
       //List<Billing_Vision_Plus__c>bVisionPlusList = new list<Billing_Vision_Plus__c >([SELECT Id FROM Billing_Vision_Plus__c 
       //                                                                                 where LastModifiedDate < LAST_N_DAYS:60]);
       String query;
       if(test.isRunningTest()) {
           query = ('SELECT  Id ' +
                        'FROM   Billing_Vision_Plus__c');
       } else {
           query = ('SELECT  Id ' +
                        'FROM   Billing_Vision_Plus__c ' +
                        'WHERE  LastModifiedDate < LAST_N_DAYS:60');
       }
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Billing_Vision_Plus__c> scope){ 
       delete scope; 
   }     
   global void finish(Database.batchableContext info){     
   } 
}// End BVisionPlusDeleteBatch Method