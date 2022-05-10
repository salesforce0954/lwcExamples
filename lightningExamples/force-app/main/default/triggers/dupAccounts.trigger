trigger dupAccounts on Account (before insert) {

  /** for(Account a:Trigger.new){
   
    List<Account> alist = [select id,name from Account where name =:a.name];
    
    if(alist.size() > 0){
      a.addError('Duplicate found');
    }
   
   } */
   
   set<string> accountIds = new set<string>();
   
   for(Account acc:Trigger.new){
      accountids.add(acc.name);
   }
   
   List<Account> accList = [select name from Account where name=:accountids];
   
  for(Account a:Trigger.new){
   if(accList.size() > 0){
     a.addError('Duplicate record found');
   }
  }
}