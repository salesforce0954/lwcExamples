public class App_iplCaptainInfo{

  @AuraEnabled(Cacheable=true)
  public static List<IPL_Team_Captain__c> captainInfo(string teamId){
    
     if(String.isEmpty(teamId)){    
           return [select name from IPL_Team_Captain__c];
     }else{   
           return [select name from IPL_Team_Captain__c where IPL_Teams__c =: teamId];  
     }
  }
    @AuraEnabled(Cacheable=true)
  public static List<IPL_Captain_Info__c> captainDetails(string captainId){
    system.debug('Captain id $$ '+captainId);
    if(String.isEmpty(captainId)){
    return [select Batting_Style__c,Born__c,Image__c,Full_Name__c,Playing_Role__c from IPL_Captain_Info__c where IPL_Team_Captain__c =:captainId];
    }else{
    return [select Batting_Style__c,Born__c,Image__c,Full_Name__c,Playing_Role__c from IPL_Captain_Info__c where IPL_Team_Captain__c =:captainId];
    }
  }
}