public class applicantInformation{
   
   @AuraEnabled(cacheable=true)
    public static List<Applicant__c> getAllApplicants(string searchName){
       system.debug('Test Apex '+searchName);
       return [select id,Phone__c,First_Name__c,State__c,isDrivingLicense__c from Applicant__c where First_Name__c =:searchName];
    }
}