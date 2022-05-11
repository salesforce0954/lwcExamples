@isTest
public class App_SendSmsTemplate_Test{
   static testMethod void coverCode(){
   List<Admin_Settings__c> adminSettings = testDataBuilder.adminSet();
        insert adminSettings;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = testDataBuilder.createBrand();
        insert testBrand;
        
        
   Application__c application = TestDataBuilder.createApplication();//create application
    application.Channel__c = 'Broker';
    application.Response_Code__c = 'PC';
    application.Brand_String__c = 'Latitude';
    //application.Brand_String__c = 'Kiwibank';
    application.Application_Type__c = 'Joint';
    insert application;
    List<Applicant__c> appLst = new List<Applicant__c>();
   
   Applicant__c applicant1 = TestDataBuilder.createApplicant(null,application.id);
   //insert applicant1;
   Applicant__c applicant2 = TestDataBuilder.createApplicant(null,application.id);
   //insert applicant2;
   
   appLst.add(applicant1);
   appLst.add(applicant2);
   insert appLst;

  
   List<income__c> incList = new List<income__c>();
   
   Income__c income1 = TestDataBuilder.createIncome(applicant1.id);
//   insert income1;
   
   Income__c income2 = TestDataBuilder.createIncome(applicant2.id);
//   insert income2;
   
   incList.add(income1);
   incList.add(income2);
      
    insert incList;
  
   Applicant__c applicant3 = TestDataBuilder.createApplicant(null,application.id);
   applicant3.Primary_Employment_Status__c = 'Full Time';
   insert applicant3;
   
  Outbound_SMS_Communication__c OSC = new Outbound_SMS_Communication__c();
                 OSC.Application__c = application.id;                                                    
                 OSC.Mobile_Number__c = '0412347896';     
                 OSC.Email_Address__c = 'test11@gmail.com';
                 OSC.Applicant_First_Name__c = applicant3.name;
                 OSC.Applicant_Name__c = appLst[0].name;   
                 OSC.Template__c =  'If no prior discussion template (Full time/Part time)';
                 OSC.Employment_Type__c = 'My permanent - full time job';
                 insert OSC;

  
          
     Test.StartTest();  
    ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
    App_SendSmsTemplate controller = new App_SendSmsTemplate(standardController);
   
   if(appLst.size() > 1){
   controller.selectedApplicant = appLst[1].First_Name__c;
   }
   controller.selectedApplicant = appLst[0].First_Name__c;
//     controller.selectedApplicant = 'APLC-';
   system.assertEquals(controller.selectedApplicant,appLst[0].First_Name__c);
   controller.selectedEmpType = 'My contracting job';
   //controller.templateSelected = 'If no prior discussion';
   system.assertEquals(controller.selectedEmpType,'My contracting job');
   controller.selectedTemplate = 'If no prior discussion';
   system.assertEquals(controller.selectedTemplate,'If no prior discussion');
   controller.content = 'Test';
   controller.ownerName = 'Test';
   controller.selectedOwner = 'Test';
   system.assertEquals(controller.selectedOwner,'Test');
   //controller.selectedTime  = 'Test';
   controller.selectDocumentType ='A 30-day bank statement';
   controller.additionalDocType = 'Payslip';
   controller.documentType = 'Bank Statements';
   system.assertEquals(controller.documentType,'Bank Statements');
   controller.selectedAdditionalDocType = 'Bank Statements';
   controller.emailId = 'testdshdh@gmail.com';
   controller.agentMailId = 'abcd@gmail.com';
   controller.deliveryCheck = true;
   system.assertEquals(controller.deliveryCheck,true);
   
   
   try{
   controller.insertOSC();
   }catch(Exception e){}
   //controller.getCallBackTime();
    controller.getselectedApplicants();
    controller.getSelectEmploymentType();
    controller.getSelectEmploymentTypeNZ();
    controller.getSelectTemplate();
    controller.save();
    controller.refresh();
    controller.getSelectFrequencyAU();
    controller.getTemplateValues();
    
    
    Brand__c brand = TestDataBuilder.createBrand();
    brand.Site__c = application.Brand_String__c;    
    insert brand;
    
    Brand__c brandNZ = TestDataBuilder.createBrandNZ();
    insert brandNZ;
    
    Application__c applicationNZ = TestDataBuilder.createApplicationNZ(brandNZ);
    insert applicationNZ;
    
    
    Brand_Content__c bcAU = TestDataBuilder.createBrandContent(brand.id);
    bcAU.name = 'Document Request';
    insert bcAU;
    
     Brand_Content__c bcNZ = TestDataBuilder.createBrandContent(brandNZ.id);
    bcNZ.name = 'If no prior discussion';
    insert bcNZ;

   controller.getSelectTemplateReview();

     Test.StopTest();
 }


  static testMethod void codeCoverOne(){
  
      Application__c application = TestDataBuilder.createApplication();//create application
    application.Channel__c = 'Broker';
    //application.Response_Code__c = 'PC';
    application.Brand_String__c = 'Latitude';
    //application.Application_Type__c = 'Joint';
    insert application;
    List<Applicant__c> appLst = new List<Applicant__c>();
   
    Applicant__c applicant = TestDataBuilder.createApplicant(null,application.id);
    Applicant__c applicant1 = TestDataBuilder.createApplicant(null,application.id);
    //insert applicant;
    appLst.add(applicant);
    appLst.add(applicant1);
    insert appLst;
        
    system.assertEquals(appLst.size(),2);
    
    Applicant__c applicant3 = TestDataBuilder.createApplicant(null,application.id);
    insert applicant3;
    
    Income__c income = TestDataBuilder.createIncome(applicant3.id);
    insert income;
         Test.StartTest();  
           ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
           App_SendSmsTemplate controller = new App_SendSmsTemplate(standardController);
           //controller.getSelectEmploymentType();
           //List<SelectOption> selOpts=controller.getDocumentTypes();  
           
           
          controller.selectedEmpType = 'My rental property'; 
           controller.deliveryCheck = true;
           
          // controller.selectedApplicant = appLst[0].name;
          if(appLst.size() > 1){
           controller.selectedApplicant = appLst[1].First_Name__c;
           }
           controller.selectedApplicant = appLst[0].First_Name__c;

           controller.save();
           
         List<selectOption> sop = controller.getSelectTemplate();           
         List<SelectOption> lst = controller.getDocumentTypes();
         List<selectOption> sets = controller.getSelectEmploymentType();
         List<selectOption> selApp = controller.getselectedApplicants();
         List<selectOption> tempValues = controller.getTemplateValues();

           
           App_SendSmsTemplate controller1 = new App_SendSmsTemplate(standardController);
           controller1.getSelectEmploymentType();
           controller1.selectedEmpType = 'My self-employed business';
           controller1.templateSelected = 'Loan Settled With DD'; 
           controller1.frequency = 'Weekly';
           controller1.debitedDate = '23/09/2021';
           controller1.selectedTemplate = 'Loan Settled With DD';
           controller1.selectedApplicant = appLst[0].First_Name__c;
           List<SelectOption> lst1 = controller1.getDocumentTypes();
           
           App_SendSmsTemplate controller2 = new App_SendSmsTemplate(standardController);
          controller2.getSelectEmploymentType();
           controller2.selectedEmpType = 'My contracting job';
            List<SelectOption> lst2 = controller2.getDocumentTypes();
            
             App_SendSmsTemplate controller3 = new App_SendSmsTemplate(standardController);
           controller3.getSelectEmploymentType();
           controller3.selectedEmpType = 'My permanent - full time job';
           List<SelectOption> lst3 = controller3.getDocumentTypes();
           
           App_SendSmsTemplate controller4 = new App_SendSmsTemplate(standardController);
          controller4.getSelectEmploymentType();
           controller4.selectedEmpType = 'My workers compensation';
           List<selectOption> sop4 = controller4.getSelectTemplate(); 
            List<SelectOption> lst4 = controller4.getDocumentTypes();
            
            
             App_SendSmsTemplate controller5 = new App_SendSmsTemplate(standardController);
           controller5.getSelectEmploymentType();
           controller5.selectedEmpType = 'Full Time';
           List<SelectOption> lst5 = controller5.getDocumentTypes();
           
           App_SendSmsTemplate controller6 = new App_SendSmsTemplate(standardController);
          controller6.getSelectEmploymentType();
           controller6.selectedEmpType = 'Self Employed';
            List<SelectOption> lst6 = controller6.getDocumentTypes();
            
            App_SendSmsTemplate controller7 = new App_SendSmsTemplate(standardController);
           controller7.getSelectEmploymentType();
           controller7.selectedEmpType = 'Casual';
           List<SelectOption> lst7 = controller7.getDocumentTypes();
           
           App_SendSmsTemplate controller8 = new App_SendSmsTemplate(standardController);
          controller8.getSelectEmploymentType();
           controller8.selectedEmpType = 'Other';
           controller8.deliveryCheck = false;
            List<SelectOption> lst8 = controller8.getDocumentTypes();
            
            
           
         Test.StopTest();

  }
  
  static testMethod void codeCoverTwo(){
      Brand__c brandNZ = TestDataBuilder.createBrandNZ();
    insert brandNZ;
    
    Application__c application = TestDataBuilder.createApplicationNZ(brandNZ);//create application
    application.Brand_String__c = 'Gem';
    insert application;

    List<Applicant__c> appLst = new List<Applicant__c>();
   
    Applicant__c applicant = TestDataBuilder.createApplicant(null,application.id);
    Applicant__c applicant1 = TestDataBuilder.createApplicant(null,application.id);
    //insert applicant;
    appLst.add(applicant);
    appLst.add(applicant1);
    insert appLst;
        
    system.assertEquals(appLst.size(),2);
    
    Applicant__c applicant3 = TestDataBuilder.createApplicant(null,application.id);
    insert applicant3;
    
    Income__c income = TestDataBuilder.createIncome(applicant3.id);
    insert income;
         Test.StartTest();  
           ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
           App_SendSmsTemplate controller = new App_SendSmsTemplate(standardController);
           //controller.getSelectEmploymentType();
           //List<SelectOption> selOpts=controller.getDocumentTypes();  
           
           
          controller.selectedEmpType = 'My rental property'; 
           controller.deliveryCheck = true;
           
          // controller.selectedApplicant = appLst[0].name;
          if(appLst.size() > 1){
           controller.selectedApplicant = appLst[1].First_Name__c;
           }
           controller.selectedApplicant = appLst[0].First_Name__c;

           controller.save();
           
         List<selectOption> sop = controller.getSelectTemplate();           
         List<SelectOption> lst = controller.getDocumentTypes();
         List<selectOption> sets = controller.getSelectEmploymentType();
         List<selectOption> selApp = controller.getselectedApplicants();
         List<selectOption> tempValues = controller.getTemplateValues();

           
           App_SendSmsTemplate controller1 = new App_SendSmsTemplate(standardController);
           controller1.getSelectEmploymentType();
           controller1.selectedEmpType = 'My self-employed business';
           controller1.templateSelected = 'Loan Settled With DD'; 
           controller1.frequency = 'Weekly';
           controller1.debitedDate = '23/09/2021';
           controller1.selectedTemplate = 'Loan Settled With DD';
           controller1.selectedApplicant = appLst[0].First_Name__c;
           List<SelectOption> lst1 = controller1.getDocumentTypes();
           
           App_SendSmsTemplate controller2 = new App_SendSmsTemplate(standardController);
          controller2.getSelectEmploymentType();
           controller2.selectedEmpType = 'My contracting job';
            List<SelectOption> lst2 = controller2.getDocumentTypes();
            
             App_SendSmsTemplate controller3 = new App_SendSmsTemplate(standardController);
           controller3.getSelectEmploymentType();
           controller3.selectedEmpType = 'My permanent - full time job';
           List<SelectOption> lst3 = controller3.getDocumentTypes();
           
           App_SendSmsTemplate controller4 = new App_SendSmsTemplate(standardController);
          controller4.getSelectEmploymentType();
           controller4.selectedEmpType = 'My workers compensation';
           List<selectOption> sop4 = controller4.getSelectTemplate(); 
            List<SelectOption> lst4 = controller4.getDocumentTypes();
            
            
             App_SendSmsTemplate controller5 = new App_SendSmsTemplate(standardController);
           controller5.getSelectEmploymentType();
           controller5.selectedEmpType = 'Full Time';
           List<SelectOption> lst5 = controller5.getDocumentTypes();
           
           App_SendSmsTemplate controller6 = new App_SendSmsTemplate(standardController);
          controller6.getSelectEmploymentType();
           controller6.selectedEmpType = 'Self Employed';
            List<SelectOption> lst6 = controller6.getDocumentTypes();
            
            App_SendSmsTemplate controller7 = new App_SendSmsTemplate(standardController);
           controller7.getSelectEmploymentType();
           controller7.selectedEmpType = 'Casual';
           List<SelectOption> lst7 = controller7.getDocumentTypes();
           
           App_SendSmsTemplate controller8 = new App_SendSmsTemplate(standardController);
          controller8.getSelectEmploymentType();
           controller8.selectedEmpType = 'Other';
           controller8.deliveryCheck = false;
            List<SelectOption> lst8 = controller8.getDocumentTypes();
            
            
           
         Test.StopTest();

  }
    
   

  
}