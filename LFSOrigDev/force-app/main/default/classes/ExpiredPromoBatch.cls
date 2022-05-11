/* @Description: Batch class to deactivate expired promos
 * @Author: Mike Lasala
 * @Date Created: 10-OCT-2016
 */
global class ExpiredPromoBatch implements Database.batchable<SObject>{
    
    global Database.QueryLocator start(Database.batchableContext info){
        //Retrieve expired promos
        String query = ('SELECT Id FROM Promo__c WHERE Promo_End__c < TODAY');
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.batchableContext info, List<Promo__c > scope){
        for(Promo__c p: scope){
            //Deactivate promos
            p.Active__c = false;
        }
        
        if(!scope.isEmpty()){
            update scope;
        }
    }
    
    global void finish(Database.batchableContext info){
    
    }
}