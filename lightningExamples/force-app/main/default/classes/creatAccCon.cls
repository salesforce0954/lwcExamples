public class creatAccCon extends createApplicationRecord{

     public static void createAccount(){
       //Application__c app = createApplicationRecord.createApplication();
       createApplicationRecord car = new createApplicationRecord();
       Application__c app = car.createApplication();
       system.debug('Application Id '+app.id);
       List<Applicant__c> applicantList = createApplicationRecord.createApplicant(app.id);
       
       system.debug('Applicant List Before '+applicantList.size());
       
       Applicant__c app1 = new Applicant__c();
       app1.isPrimayApplicant__c = true;
       app1.Application__c = app.id;
       
       Applicant__c app2 = new Applicant__c();
       app2.isPrimayApplicant__c = false;
       app2.Application__c = app.id;
       
       applicantList.add(app1);
       applicantList.add(app2);
       
        system.debug('Applicant List After '+applicantList.size());
       
       if(applicantList.size() > 0){     
         insert(applicantList);
       }
       
       if(app != null){
           Account acc = new Account();
           acc.name = app.id;
           insert acc;
       }
     }
}