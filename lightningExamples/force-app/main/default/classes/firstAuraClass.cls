public class firstAuraClass{

 @AuraEnabled
 public static string createApplicant(string firstName,String lastName){
   
     Applicant__c app = new Applicant__c();
     app.First_Name__c = firstName;
     app.Last_Name__c = lastName;
     insert app;
     return app.id;
 }

}