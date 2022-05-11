/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 03 March 2013
* @description batch class to perform mass delete of Billing ICBS Records
*/

global class BIcbsDeleteBatch implements Database.batchable<sObject>{ 
   global Database.QueryLocator start(Database.batchableContext info){ 
       //List<Billing_ICBS__c>bIcbsList = new list<Billing_ICBS__c >([SELECT Id FROM Billing_ICBS__c 
       //                                                             where LastModifiedDate < LAST_N_DAYS:60]);
       String query;
       if(Test.isRunningTest()) {
           query = ('SELECT  Id ' +
                            'FROM   Billing_ICBS__c');
       } else {
           query = ('SELECT  Id ' +
                        'FROM   Billing_ICBS__c ' +
                        'WHERE  LastModifiedDate < LAST_N_DAYS:60');
       }
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Billing_ICBS__c> scope){ 
       delete scope; 
   }     
   global void finish(Database.batchableContext info){     
   } 
}// End BIcbsDeleteBatch Method