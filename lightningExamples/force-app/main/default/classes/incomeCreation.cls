public class incomeCreation {

    public incomeCreation(){
     system.debug('Test');
    }

    @AuraEnabled
    public static List<Income__c> createIncomes(List<Income__c> incomeList){ 
      upsert incomeList;
      return incomeList;
    }

    @AuraEnabled
    public static List<Income__c> retrieveIncomes(List<Id> incomeids){
      system.debug('Income entered');
      List<Income__c> incomeList = [select Employment_Type__c,Applicant__c,Total_Income_Amount__c from income__c where Id in :incomeids];
      system.debug('Income List '+incomeList);
      //insert incomeList;
      update incomeList;
      return incomeList;
    }

    @AuraEnabled
    public static List<Applicant__c> insertApplicantForJoint(Id applicationId,string applicantType){
        system.debug('SUneel Hi');
        
       
           List<Applicant__c> applicantList = [select Id,isPrimayApplicant__c,Application__c,First_Name__c,Last_Name__c,Address__c,Phone__c,State__c from Applicant__c where Application__c =:applicationId and Application__r.Applicant_Type__c=:applicantType];
           system.debug('Applicant List Size '+applicantList.size());
           if(applicantList.size() <= 0){
           system.debug('HI Suneel');
            Applicant__c applicant1 = new Applicant__c();
            applicant1.isPrimayApplicant__c = true;
            applicant1.Application__c = applicationId;
            
            Applicant__c applicant2 = new Applicant__c();
            applicant2.isPrimayApplicant__c = false;
            applicant2.Application__c = applicationId;
            
            applicantList.add(applicant1);
            applicantList.add(applicant2);
            
            //upsert applicantList;
            
            
              insert applicantList;
          }else if(applicantList.size() > 0){
             
             
          
          }
          
             
            
              return applicantList;
       
       
    }
}