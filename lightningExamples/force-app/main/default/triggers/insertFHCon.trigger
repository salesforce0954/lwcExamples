trigger insertFHCon on Account (after insert) {

  set<id> accountids = new set<id>();
  
  for(Account acc:Trigger.New){
  
    accountIds.add(acc.id);
  
  }
  
  futureHandlerExample.insertContact(accountIds);

}