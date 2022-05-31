public class deleteApplicant{

  @InvocableMethod(label='Delete Applicant')
  public static List<Id> deleteApplicants(List<Id> appList){
  
     List<Applicant__c> app = [select Id from Applicant__c where Id=:appList];
     
     delete app[0];
      
    return appList;
  }
}