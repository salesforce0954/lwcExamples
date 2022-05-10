public class createCommunityUser {

   public static string applicantType {get;set;}
   public static boolean isApplicantEligible {get;set;}
   public static string status {get;set;}
   

   public createCommunityUser(){
   
   }
   
   public static pageReference createApplication(){
   
     Account acc;
     Application__c app;
     Contact con;
     User u;
     
     app = new Application__c();
     app.Applicant_Type__c = applicantType;
     app.is_Applicant_Eligible__c = isApplicantEligible;
     app.Status__c = status;
     insert app;
     
     if(app != null){
     acc = new Account();
     acc.name = app.applicant_type__c;
     insert acc;
     }
     
     if(acc != null){
     system.debug('Contact Entered');
      con = new Contact();
      con.lastName = acc.name;
      con.accountId = acc.id;
      system.debug('Contact lastame '+con.lastName);
      insert con;
     }
     
     Profile p = [SELECT Id, Name FROM Profile where Name='Customer Community Login User Clone'];
     
     if(con != null){
       u = new USer();
       u.contactId = con.Id;
       u.profileId = p.id;
       u.UserName = con.lastName+'@gmail.com';
       u.lastName = con.lastname;
       u.Email = con.lastName+'@gmail.com';
       u.Alias = 'test';
       u.TimeZoneSidKey = 'America/Los_Angeles';
       u.LocaleSidKey = 'en_US';
       u.EmailEncodingKey = 'ISO-8859-1';
       u.LanguageLocaleKey = 'en_US';
       insert u;
     } 
     
     system.debug('Owner Id '+app.OwnerId);
     
     pagereference redirect = new PageReference('/apex/createCommunityUser');
     
     
     return redirect;
   }
   
   public List<SelectOption> getapplicantTypeValues(){
   List<SelectOption> optionList = new List<SelectOption>();
   optionList.add(new selectOption('','None'));
   optionList.add(new selectOption('Single','Single'));
   optionList.add(new selectOption('Joint','Joint'));
     return optionList;
   }
   
   public List<SelectOption> getStatusValues(){
   List<SelectOption> optionList = new List<SelectOption>();
   optionList.add(new selectOption('','None'));
   optionList.add(new selectOption('New','New'));
   optionList.add(new selectOption('In progress','In progress'));
   optionList.add(new selectOption('Received','Received'));
   optionList.add(new selectOption('Failed','Failed'));
     return optionList;
   }
}