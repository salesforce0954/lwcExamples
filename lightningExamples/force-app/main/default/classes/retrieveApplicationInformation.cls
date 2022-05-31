public class retrieveApplicationInformation{

   @AuraEnabled(cacheable=true)
   public static Map <String,String> getApplication(string id){
    Map < String, String > mapOppAccount = new Map < String, String >();
        for(Opportunity opp : [SELECT ID, Account.Name, Name FROm Opportunity where Id=:id])
            mapOppAccount.put(opp.Name, opp.Account.Name);
        return mapOppAccount;
    }
}