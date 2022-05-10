public class assignAccountToUsers{

 @AuraEnabled(cacheable=true)
 public static List<Account> fetchAccounts(){
   
    return [select id,name,phone from Account where Active__c = 'Yes'];
 }
 
 @AuraEnabled(cacheable=true)
 public static List<Contact> getContactName(String accId){
     system.debug('Contact List '+accId);
    return [select lastName from contact where accountId =:accId];
 }
}