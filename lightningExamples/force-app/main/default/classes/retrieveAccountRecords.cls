public class retrieveAccountRecords{
  
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts(){
    List<Account> acc = [select id,name from Account where name='DesSekChaSun'];
   return acc;
  }
}