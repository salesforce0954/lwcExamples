public class futureHandlerExample{

   @future
   public static void insertContact(set<id> accountids){
    system.debug('Future entered');
    List<contact> conList = new List<contact>();
    
    for(Account acc:[select id,name from Account where id=:accountids]){
      contact c = new contact();
      c.accountId = acc.id;
      c.lastname = 'futureHandler';
      conList.add(c);
      system.debug('Contact List '+conList);
    }
    insert conList;
   }
}