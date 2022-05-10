public class processBuilderExample{

@invocableMethod (label='create contacts')
public static void createContacts(List<id> accountIds){
   
    List<Contact> conList = new List<Contact>();
    
    List<Account> accList = [select id,Name from Account where id=:accountIds];
    
    for(Account a :accList){
      contact c = new contact();
      c.accountId = a.id;
      c.lastName = 'chandra';
      conList.add(c);
    }
    insert conList;

}

}