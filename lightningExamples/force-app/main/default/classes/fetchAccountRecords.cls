public class fetchAccountRecords{

  @AuraEnabled(cacheable=true)
  public static List<Account> fetchRecords(){
     return [select id,name,phone from Account where name = 'createdTodayNow' ];
  }
}