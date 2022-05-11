public class App_iplTeamInformation{

   @AuraEnabled(Cacheable=true)
   public static List<IPL_Teams__c> teamNames(){
   system.debug('IPL Teams');
     return [select name from IPL_Teams__c];
   }
}