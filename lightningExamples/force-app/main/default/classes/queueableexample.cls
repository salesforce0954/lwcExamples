public class queueableexample implements queueable{

    
    set<id> accountids = new set<Id>();
       
   public queueableexample(set<id> accountids){
     this.accountids  = accountids;
   }
   public void execute(queueableContext qc){
   
   List<Account> accountList = [select id,name from Account];   
   
   for(Account a:accountList){
      accountIds.add(a.id);
   }
   
       futureHandlerExample.insertContact(accountIds);
   }
}