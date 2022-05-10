trigger updateAccountSICDesc on Contact (after update) {

   set<id> accountids = new set<id>();
   
   for(contact c:Trigger.new){
     accountids.add(c.accountId);
   }
   
    List<Account> accList = [select id,SicDesc from account  where id=:accountids];
    
    Map<Id,contact> mapCon = new Map<Id,contact>();
    
    for(Contact con:Trigger.New){
      mapCon.put(con.accountId,con);
    
    }
    
    for(Account acc:accList){
    
    //acc.SicDesc = trigger.newMap.get(acc.id).email;
    acc.SicDesc = mapCon.get(acc.id).email;
    
    }
    update accList;
   
   
}