/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 15 March 2013
* @description batch 
*/
/* last modified by: B.Naveenkumar
   @Modifications  : adding 'where' condition in query and  database.emptyRecyclebin(scope) for clean up recycle bin
   Changes Suggested by: Salesforce.com
   last modified date:28/01/2014.
   Approval taken from :Revelly, Roscoe (GE Capital) <Roscoe.Revelly@ge.com>;   
*/
 
global class PlanDeleteBatch implements Database.batchable<SObject>,Database.Stateful{ 
            

   global Database.QueryLocator start(Database.batchableContext info){ 
       //List<Plans__c>planList = new list<Plans__c >([SELECT Id FROM Plans__c where LastModifiedDate < LAST_N_DAYS:60]);
       //return planList;
      // date t1 = Date.TODAY(); CreatedDate >= Date.TODAY()-2 OR CreatedDate <= Date.TODAY()
       
     String query;
       if(Test.isRunningTest()) {
           query = ('SELECT  Id ' + 'FROM Plans__c WHERE CreatedDate = LAST_N_DAYS:2');
       } else {
           query = ('SELECT  Id FROM   Plans__c WHERE CreatedDate = LAST_N_DAYS:2' );
       }
       
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Plans__c> scope){ 
       delete scope; 
       if(scope.size()>0){
       
                 database.emptyRecyclebin(scope);
       
       }
   }     
   global void finish(Database.batchableContext info){   
    /* if ([SELECT count() FROM Plans__c ] > 0){
    Database.executeBatch(new PlanDeleteBatch_test());
   } */
 }
}// End PlanDeleteBatch Method