trigger accountActiveUpdate on Opportunity (after update) {

   Map<id,opportunity> mapOpp = new Map<id,opportunity>();
   
   for(Opportunity opp:Trigger.New){
     if(opp.accountId != null){
      mapOpp.put(opp.accountId,opp);
     }
   }
   
   List<Account> accList = [select id,Active__c from Account where id=:mapOpp.keySet()];
   
  
   
   if(accList.size() > 0){
       for(Account acc:accList){
       
         
        if(mapOpp.get(acc.id).stageName == 'Closed won'){
          acc.active__c = 'yes';
        }else{
          acc.active__c = 'no';
        }
       
       }
       
       update accList;
   }
}