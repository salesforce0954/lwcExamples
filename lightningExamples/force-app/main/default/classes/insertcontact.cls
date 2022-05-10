public class insertcontact{

   public static List<Account> insertcon(List<Account> accList){
   
     system.debug('Trigger is execution '+Trigger.isExecuting);
     
     if(Trigger.isExecuting){
    
         List<Contact> conList = new List<Contact>();
         
         for(Account acc:accList){
            contact c = new contact();
            c.accountId = acc.id;
            c.lastName = acc.name;
            conList.add(c);
         }
         insert conList;
     
     }
     return accList;
   }
   
      public static List<Account> insertconone(List<Account> accList){
           system.debug('Trigger is execution one'+Trigger.isExecuting);
       return null;
      }

}