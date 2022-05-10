public class Application_Information{
   
   @AuraEnabled(cacheable=true)
   public static List<Applicant__c> getApplicantData(){
    
    return [select First_Name__c,Phone__c,State__c,isDrivingLicense__c from Applicant__c];
   }
}