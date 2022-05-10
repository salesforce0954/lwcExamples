public class parameterTest{

   public static string createContacts(string accountIds){
    system.debug(1);
    List<Contact> con = new List<Contact>();
    List<Account> accList = [select id,name,phone from Account where id =:accountids];
    
    for(Account a:accList){
       contact c= new contact();
       c.lastName = 'Desiraju';
       c.accountId = a.id;
       con.add(c);
    }
    insert con;
    return accList[0].id;
   }
   public static void testcode(){
     system.debug('Test');
   }
}