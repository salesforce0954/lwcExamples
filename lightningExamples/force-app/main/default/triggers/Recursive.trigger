trigger Recursive on Account(after update)
{

  if(avoidRecursiveTrigger.isRec == true){
         //avoidRecursiveTrigger.isRec = false;

    set<Id> accountId = new set<Id>();
    
    for(Account acc:Trigger.New){
       accountId.add(acc.id);
     }
     
     List<Account> accList = [select id,name from Account where id=:accountId];
     
     for(Account a:accList){
     
        a.name = 'SuneelRecursive';
        
     
     }
     
     update accList;
     
     }
}