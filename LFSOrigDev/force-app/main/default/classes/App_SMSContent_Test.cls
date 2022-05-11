@isTest

public class App_SMSContent_Test{

static testMethod void testSmsContent(){
Application__c application = TestDataBuilder.createApplication();
    application.Channel__c = 'Broker';
    application.Response_Code__c = 'PC';
    application.Brand_String__c = 'GEM';
    insert application;
    
   
 ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
    App_SMSContent controller = new App_SMSContent(standardController);
    
    controller.fullAndPartTime  = true;
  
    List<Applicant__c> appLst = new List<Applicant__c>();
    
    Applicant__c applicant1 = TestDataBuilder.createApplicant(null,application.id);
   
   Applicant__c applicant2 = TestDataBuilder.createApplicant(null,application.id);
   
   appLst.add(applicant1);
   appLst.add(applicant2);
   
   insert appLst;
   
     App_SendSmsTemplate controller1 = new App_SendSmsTemplate(standardController);

   controller1.selectedApplicant = appLst[0].First_Name__c;
   
   controller1.selectedEmpType = 'My casual/temporary job';
   controller1.selectedTemplate = 'If no prior discussion template (Full time/Part time)';
   controller1.content = 'Test';
   controller1.ownerName = 'Test';
   controller1.selectedOwner = 'Test';
   //controller1.selectedTime  = 'Test';
   
   App_SendSmsTemplate controller2 = new App_SendSmsTemplate(standardController);

   controller2.selectedApplicant = appLst[1].First_Name__c;
  
   
   
    
    List<Applicant__c> appList = new List<Applicant__c>();
    
    Applicant__c applicant3 = TestDataBuilder.createApplicant(null,application.id);
    Applicant__c applicant4 = TestDataBuilder.createApplicant(null,application.id);
    
    appList.add(applicant3);
     appList.add(applicant4);
    
    insert appList;
    
  
    
    Brand__c brand = TestDataBuilder.createBrand();
    brand.Site__c = appList[0].application__r.Brand_String__c;
    insert brand;

Brand_Content__c bc = TestDataBuilder.createBrandContent(brand.id);
bc.name = 'If no prior discussion template (Full time/Part time)';
insert bc; 

 Brand__c brand1 = TestDataBuilder.createBrand();
    brand1.Site__c = appList[1].application__r.Brand_String__c;
    insert brand1;

Brand_Content__c bc1 = TestDataBuilder.createBrandContent(brand1.id);
bc1.name = 'If no prior discussion template (Full time/Part time)';
insert bc1; 

    
   // App_SMSContent.getSMSContent(controller1.selectedTemplate,appList,controller1.selectedApplicant,controller1.ownerName,'test','test','test');
    App_SMSContent.getSMSContent(controller1.selectedTemplate,appList,'FirstName',controller1.ownerName,'test','test','test','Weekly','23-09-2021','9th','102901','123445','0412345675');
    }
}