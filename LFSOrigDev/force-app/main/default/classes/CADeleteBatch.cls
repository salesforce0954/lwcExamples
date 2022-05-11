/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description batch class to perform mass delete of campaign assignments by end of day
*/

global class CADeleteBatch implements Database.batchable<SObject>{ 
   global Database.QueryLocator start(Database.batchableContext info){ 
      // Select all campaign assignments
      //return new list<Campaign_Assignment__c >([SELECT Id FROM Campaign_Assignment__c]);
      String query = ('SELECT  Id ' +
                        'FROM   Campaign_Assignment__c');
      return Database.getQueryLocator(query);
   }     
   global void execute(Database.batchableContext info, List<Campaign_Assignment__c> scope){ 
       delete scope; 
       if(scope.size()>0) {
           Database.emptyRecycleBin( scope );
       }
   }     
   global void finish(Database.batchableContext info){     
   } 
}// End CADeleteBatch