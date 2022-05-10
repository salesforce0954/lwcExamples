trigger updateContactEmail on Account (after update) {
 
  set<Id> accountIds = new set<id>();
  
  for(Account acc:Trigger.new){
    accountIds.add(acc.id);
  }
  
  List<Contact> conList = [select email,accountId from contact where accountId =: accountIds];
  
/**  Map<id,Account> accMap = new Map<Id,Account>();
  
  for(Account a:Trigger.New){
    accMap.put(a.id,a);
  } */
  
  for(Contact c:conList){
  
   // c.email = accMap.get(c.accountId).SicDesc;
   c.email = trigger.newMap.get(c.accountId).SicDesc;
  
  }
  update conList;
}