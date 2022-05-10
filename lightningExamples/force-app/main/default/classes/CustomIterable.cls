public class CustomIterable implements iterable<Account> {
   public Iterator<Account> iterator(){
      List<Account> accs =
      [SELECT Id, Name,
       NumberOfEmployees 
       FROM Account
       LIMIT 10];
       system.debug(accs);
      return accs.iterator();
   }
   
   
}