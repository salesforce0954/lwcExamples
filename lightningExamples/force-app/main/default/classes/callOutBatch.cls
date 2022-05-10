global class callOutBatch implements database.batchable<sObject>,database.stateful,database.allowsCallouts
{
   global callOutBatch(){
   
    UserNamePasswordIntegrationCls unp = new UserNamePasswordIntegrationCls();
    unp.requestAccessToken(); 
     
    
   }
   
   global Database.QueryLocator start(Database.batchableContext bc){
     return null;
   }
   
   global void execute(Database.batchableContext bc,List<Account> scope){
   }
   
   global void finish(Database.batchableContext bc){
   }
}