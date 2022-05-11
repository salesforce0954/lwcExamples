/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 03 March 2013
* @description batch class to perform mass delete of Billing Genesis Records
*/

global class BGenesisDeleteBatch implements Database.batchable<sObject>{ 
   global Database.querylocator start(Database.batchableContext info){ 
       //List<Billing_Genesis__c>bGenesisList = new list<Billing_Genesis__c >([SELECT Id FROM Billing_Genesis__c 
       //                                                                      where LastModifiedDate < LAST_N_DAYS:60]);
       String query;
       if(Test.isRunningTest()) {
           query = ('SELECT  Id ' +
                            'FROM   Billing_Genesis__c');
       } else {
           query = ('SELECT  Id ' +
                            'FROM   Billing_Genesis__c ' +
                            'WHERE  LastModifiedDate < LAST_N_DAYS:60');
       }
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Billing_Genesis__c> scope){ 
       delete scope; 
   }     
   global void finish(Database.batchableContext info){     
   } 
}// End BGenesisDeleteBatch Method