trigger updateStage on Account(after update){

   Map<Id,Account> mapAccount = new Map<Id,Account>();
   
   for(Account acc:Trigger.New){
      mapAccount.put(acc.id,acc);
   }
   
   List<Opportunity> oppList = [select stageName,accountId from opportunity where accountId=:mapAccount.keySet()];
   
   for(Opportunity opp:oppList){
    
    if(mapAccount.get(opp.accountId).Rating == 'Hot'){
       opp.StageName = 'Close won';
    }
    
   
   }
   update oppList;
}