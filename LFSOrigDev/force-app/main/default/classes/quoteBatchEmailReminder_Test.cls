/**
* @author Arshad Mohammed
* @date   20.Nov.2020
* @description Testclass to cover quoteBatchEmailReminder class.
**/
@isTest
private class quoteBatchEmailReminder_Test{
/**
* @author Arshad Mohammed
* @date   20.Nov.2020
* @description Testclass to cover newInsuranceSystem class.
**/
  @isTest static void test_CreateTestData() {
     Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id,'Personal Loan','Life Insurance');
        testProduct.Product_Name__c = 'Latitude Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        List<Application__c> lapps = new List<Application__c>();
                
        Application__c testApplicationNZ = TestDataBuilder.createApplicationNZ(testBrand);
        insert testApplicationNZ;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Product_SubType__c = 'Better Start PL';
        testApplication.Offered_Interest_Rate_Orig__c = 13.99;
        testApplication.Loan_Term_Months__c = 24;
        testApplication.Product_SubType__c = 'Standard PL';
        testApplication.Acceptance_Channel__c= 'Internet';
        testApplication.Offered_Interest_Rate__c = 13.99;
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Previous_App_No__c = 'new';
        testApplication.Promo_ID__c = 'old loan';
        testApplication.final_approved_date__c = System.Today() -1;
        testApplication.status__c = 'Accepted';
        testApplication.EMI_with_Service_Fee__c = 1500;
        insert testApplication;

        lapps.add(testApplicationNZ);
        lapps.add(testApplication);
        update lapps;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Application__c = testApplication.Id;
            testApplicant.Date_Of_Birth__c = '01-01-1990';
            testApplicant.Date_of_Birth_WS__c = '1990-01-01';
            testApplicant.Applicant_age__c = 40;
            testApplicant.Drivers_Lic_No__c = '123123123';
            testApplicant.Email_Address__c = 'Test@ge.com';
            testApplicant.First_Name__c = 'FirstName';
            testApplicant.Gender__c = 'Male';
            testApplicant.Home__c = '032345678';
            testApplicant.Drivers_Lic_Flg__c = false;
            testApplicant.Last_Name__c = 'Lastname';
            testApplicant.Middle_Name__c = 'MidName';
            testApplicant.Mobile__c = '0412345678';
            testApplicant.No_of_Deps__c = 2;
            testApplicant.Postal_Addr_Flg__c = true;
            testApplicant.Postcode_Pos__c = '4125';
            testApplicant.Street_Pos__c = 'Sample';
            testApplicant.Street_No_Pos__c = '123';
            testApplicant.Street_Type_Pos__c = 'Street';
            testApplicant.Suburb_Pos__c = 'NSW';
            testApplicant.Unit_No_Pos__c = '1234';
            testApplicant.Pref_Contact_Method__c = 'Phone';
            testApplicant.Postcode_Pre__c = '4215';
            testApplicant.Street_Pre__c = 'Sample';
            testApplicant.Street_No_Pre__c = '123';
            testApplicant.Street_Type_Pre__c = 'Street';
            testApplicant.Suburb_Pre__c = 'NSW';
            testApplicant.Unit_No_Pre__c = '123';
            testApplicant.Rel_Status__c = 'Single';
            testApplicant.Postcode_Res__c = '4125';
            testApplicant.Res_Status__c = 'Renting';
            testApplicant.Street_Res__c = 'Sample';
            testApplicant.Street_No_Res__c = '123';
            testApplicant.Street_Type_Res__c = 'Street';
            testApplicant.Suburb_Res__c = 'NSW';
            testApplicant.Unit_No_Res__c = '123';
            testApplicant.Months_At_Addr__c = '2';
            testApplicant.Years_At_Addr__c = '2';
            testApplicant.Title__c = 'Mr';
            testApplicant.Work__c = '032345678';
            testApplicant.Country_Pos__c = 'Australia';
            testApplicant.Country_Res__c = 'Australia';
            testApplicant.Country_Pre__c = 'Australia';
            testApplicant.State_Res__c = 'VIC';
            testApplicant.State_Pos__c = 'VIC';
            testApplicant.State_Pre__c = 'VIC';
            testApplicant.City_Pos__c = 'VIC';
            testApplicant.City_Pre__c = 'VIC';
            testApplicant.Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)';

           insert testApplicant;
           
           testApplicant.Mobile__c = '0412345643';
           update testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
                                            
                                              List<RecordType> recordTypeConatctList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'APAC_Contact' AND sObjectType = 'Contact'];
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.RecordTypeId = recordTypeConatctList[0].Id;
        insert testBroker;
        
        
        Contact broker = [SELECT Broker_ID__c FROM Contact WHERE Id =: testBroker.Id LIMIT 1];
        
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
         quoteObj.Quote_Privacy_Consent__c= true;
         quoteObj.Quote_Stage__c = 'Initial Submit';
         insert quoteObj;
        
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        testLoanPurpose.Application__c = testApplication.Id;
        insert testLoanPurpose;
        
        Test.startTest();
          ScheduleQuoteReminderEmails nis= new ScheduleQuoteReminderEmails();
         // Database.executeBatch(nis);
        Test.stopTest();  

  }

/**
* @author Arshad Mohammed
* @date   20.Nov.2020
* @description Testclass to cover newInsuranceSystem class.
**/
  @isTest static void quoteBatchEmailReminderProcess() {
    Test.StartTest();
    ScheduleQuoteReminderEmails sh1 = new ScheduleQuoteReminderEmails();
    String sch = '0 0 23 * * ?';
    system.schedule('Test Check', sch, sh1); 
    Test.stopTest(); 
  }  
  

  @isTest static void quoteBatchEmail() {
  
   Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
                                            
                                              
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
         quoteObj.Quote_Privacy_Consent__c= true;
         quoteObj.Quote_Stage__c = 'Initial Submit';
         quoteObj.Monthly_Repayment__c=98.23;
         quoteObj.Quote_Rate__c=12.99;
         quoteObj.Quote_Secured_Rate__c=10.99;
         quoteObj.Quote_Offered_On__c = system.today()-3;
         insert quoteObj;

         List<Quote__c> quoteLstFirst = TestDataBuilder.createQuoteAUOnline();
         quoteLstFirst[0].Quote_Stage__c = 'Initial Submit';
         quoteLstFirst[0].Monthly_Repayment__c=98.23;
         quoteLstFirst[0].Quote_Rate__c=12.99;
         quoteLstFirst[0].Quote_Secured_Rate__c=10.99;
         quoteLstFirst[0].Quote_Offered_On__c = system.today()-1;
         insert quoteLstFirst;

         List<Quote__c> quoteLst = TestDataBuilder.createQuoteAUOnline();
          quoteLst[0].Quote_Stage__c = 'Initial Submit';
         quoteLst[0].Monthly_Repayment__c=98.23;
         quoteLst[0].Quote_Rate__c=12.99;
         quoteLst[0].Quote_Secured_Rate__c=10.99;
         quoteLst[0].Quote_Offered_On__c = system.today()-5;
         insert quoteLst;
         
         List<Quote__c> quoteLstTenth = TestDataBuilder.createQuoteAUOnline();
          quoteLstTenth[0].Quote_Stage__c = 'Initial Submit';
         quoteLstTenth[0].Monthly_Repayment__c=98.23;
         quoteLstTenth[0].Quote_Rate__c=12.99;
         quoteLstTenth[0].Quote_Secured_Rate__c=10.99;
         quoteLstTenth[0].Quote_Offered_On__c = system.today()-10;
         insert quoteLstTenth;

         List<Quote__c> quoteLstThirteen = TestDataBuilder.createQuoteAUOnline();
          quoteLstThirteen[0].Quote_Stage__c = 'Initial Submit';
         quoteLstThirteen[0].Monthly_Repayment__c=98.23;
         quoteLstThirteen[0].Quote_Rate__c=12.99;
         quoteLstTenth[0].Quote_Secured_Rate__c=10.99;
         quoteLstThirteen[0].Quote_Offered_On__c = system.today()-13;
         insert quoteLstThirteen;         

        //Better Start
        Quote__c quoteObjBS = new Quote__c();
        quoteObjBS.RecordTypeId = recordTypeList[0].Id;
        quoteObjBS.Loan_Amount__c = 28000;
        quoteObjBS.Loan_Term__c = '3 Years(+3 Months)';
        quoteObjBS.Loan_Purpose__c = 'Debt Consolidation';
        quoteObjBS.Channel__c = 'Online';
        quoteObjBS.Region__c = 'AU';
        quoteObjBS.Consent_For_Soft_Enquiry__c = true;
        quoteObjBS.Title__c = 'Mr';
        quoteObjBS.First_Name__c = 'Larry';
        quoteObjBS.Middle_Name__c = 'J';
        quoteObjBS.Last_Name__c = 'Smithy';
        quoteObjBS.Date_of_Birth__c = '18/08/1976';
        quoteObjBS.Gender__c = 'Male';
        quoteObjBS.Mobile_Number__c = '0438484484';
        quoteObjBS.Email_ID__c = 'asd@zzz.com';
        quoteObjBS.Driver_s_Licence_Number__c = '65435778';
        quoteObjBS.Residential_Street_Number__c = '110';
        quoteObjBS.Residential_Street_Name__c = 'City Road';
        quoteObjBS.Residential_Street_Type__c = 'Road';
        quoteObjBS.Residential_Suburb__c = 'Southbank';
        quoteObjBS.Residential_State__c = 'VIC';
        quoteObjBS.Residential_Postcode__c = '3006';
        quoteObjBS.Residential_Country__c = 'Australia';
        quoteObjBS.Years_at_Residential_Address__c = 3;
        quoteObjBS.Months_at_Residential_Address__c = 4;
        quoteObjBS.Income_Source__c = 'My permanent - full time job';
        quoteObjBS.Occupation__c = 'Civil Service';
        quoteObjBS.Years_at_Current_Employment__c = 2;
        quoteObjBS.Months_at_Current_Employment__c = 2;
        quoteObjBS.Residential_Status__c = 'Renting';
        quoteObjBS.Product__c='Latitude Personal Loan';
        quoteObjBS.Sub_Type__c='Better Start';
        quoteObjBS.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObjBS.Consent_For_Soft_Enquiry__c = true;
        quoteObjBS.Quote_Privacy_Consent__c= true;
        quoteObjBS.Quote_Stage__c = 'Initial Submit';
        quoteObjBS.Monthly_Repayment__c=98.23;
        quoteObjBS.Quote_Rate__c=12.99;
        quoteObjBS.Quote_Secured_Rate__c=10.99;
        quoteObjBS.Quote_Offered_On__c = system.today()-3;
         insert quoteObjBS;

         List<Quote__c> quoteLstBSFirst = TestDataBuilder.createQuoteAUOnline();
         quoteLstBSFirst[0].Quote_Stage__c = 'Initial Submit';
         quoteLstBSFirst[0].Monthly_Repayment__c=98.23;
         quoteLstBSFirst[0].Quote_Rate__c=12.99;
         quoteLstBSFirst[0].Quote_Secured_Rate__c=10.99;
         quoteLstBSFirst[0].Quote_Offered_On__c = system.today()-1;
         quoteLstBSFirst[0].Sub_Type__c='Better Start';
         quoteLstBSFirst[0].Loan_Term__c='3 Years(+3 Months)';
         quoteLstBSFirst[0].Loan_Amount__c=20000;
         quoteLstBSFirst[0].Loan_Purpose__c='Debt Consolidation';
         insert quoteLstBSFirst;

         List<Quote__c> quoteLstBS = TestDataBuilder.createQuoteAUOnline();
         quoteLstBS[0].Quote_Stage__c = 'Initial Submit';
         quoteLstBS[0].Monthly_Repayment__c=98.23;
         quoteLstBS[0].Quote_Rate__c=12.99;
         quoteLstBS[0].Quote_Secured_Rate__c=10.99;
         quoteLstBS[0].Quote_Offered_On__c = system.today()-5;
         quoteLstBS[0].Sub_Type__c='Better Start';
         quoteLstBS[0].Loan_Term__c='3 Years(+3 Months)';
         quoteLstBS[0].Loan_Amount__c=20000;
         quoteLstBS[0].Loan_Purpose__c='Debt Consolidation';
         insert quoteLstBS;
         
         List<Quote__c> quoteLstTenthBS = TestDataBuilder.createQuoteAUOnline();
         quoteLstTenthBS[0].Quote_Stage__c = 'Initial Submit';
         quoteLstTenthBS[0].Monthly_Repayment__c=98.23;
         quoteLstTenthBS[0].Quote_Rate__c=12.99;
         quoteLstTenthBS[0].Quote_Secured_Rate__c=10.99;
         quoteLstTenthBS[0].Quote_Offered_On__c = system.today()-10;
         quoteLstTenthBS[0].Sub_Type__c='Better Start';
         quoteLstTenthBS[0].Loan_Term__c='3 Years(+3 Months)';
         quoteLstTenthBS[0].Loan_Amount__c=20000;
         quoteLstTenthBS[0].Loan_Purpose__c='Debt Consolidation';         
         insert quoteLstTenthBS;

        //End Better Start

         List<Quote__c> quoteLstGemthree = TestDataBuilder.createQuoteNZOnline();
          quoteLstGemthree[0].Quote_Stage__c = 'Initial Submit';
         quoteLstGemthree[0].Monthly_Repayment__c=98.23;
         quoteLstGemthree[0].Quote_Rate__c=12.99;
         quoteLstGemthree[0].Quote_Secured_Rate__c=10.99;
         quoteLstGemthree[0].Quote_Offered_On__c = system.today()-3;
         insert quoteLstGemthree;
        List<Quote__c> quoteLstGemFifth = TestDataBuilder.createQuoteNZOnline();
          quoteLstGemFifth[0].Quote_Stage__c = 'Initial Submit';
         quoteLstGemFifth[0].Monthly_Repayment__c=98.23;
         quoteLstGemFifth[0].Quote_Rate__c=12.99;
         quoteLstGemFifth[0].Quote_Secured_Rate__c=10.99;
         quoteLstGemFifth[0].Quote_Offered_On__c = system.today()-5;
         insert quoteLstGemFifth;
         List<Quote__c> quoteLstGemtenth = TestDataBuilder.createQuoteNZOnline();
          quoteLstGemtenth[0].Quote_Stage__c = 'Initial Submit';
         quoteLstGemtenth[0].Monthly_Repayment__c=98.23;
         quoteLstGemtenth[0].Quote_Rate__c=12.99;
         quoteLstGemtenth[0].Quote_Secured_Rate__c=10.99;
         quoteLstGemtenth[0].Quote_Offered_On__c = system.today()-10;
         insert quoteLstGemtenth;
        List<Quote__c> quoteLstGemThirteen = TestDataBuilder.createQuoteNZOnline();
          quoteLstGemThirteen[0].Quote_Stage__c = 'Initial Submit';
         quoteLstGemThirteen[0].Monthly_Repayment__c=98.23;
         quoteLstGemThirteen[0].Quote_Rate__c=12.99;
         quoteLstGemThirteen[0].Quote_Secured_Rate__c=10.99;
         quoteLstGemThirteen[0].Quote_Offered_On__c = system.today()-13;
         insert quoteLstGemThirteen;
         quoteObj.Quote_Stage__c ='Quote Offered';
        update quoteObj;
        quoteLstFirst[0].Quote_Stage__c = 'Quote Offered';
        update quoteLstFirst;
        quoteLst[0].Quote_Stage__c ='Quote Offered';
        update quoteLst;
        quoteLstThirteen[0].Quote_Stage__c ='Quote Offered';
        update quoteLstThirteen;
        quoteLstTenth[0].Quote_Stage__c ='Quote Offered';
        update quoteLstTenth;
        //Better Start
        quoteObjBS.Quote_Stage__c ='Quote Offered';
        update quoteObjBS;
        quoteLstBSFirst[0].Quote_Stage__c = 'Quote Offered';
        update quoteLstBSFirst;
        quoteLstBS[0].Quote_Stage__c ='Quote Offered';
        update quoteLstBS;
        quoteLstTenthBS[0].Quote_Stage__c ='Quote Offered';
        update quoteLstTenthBS;

        //End Better Start
        quoteLstGemtenth[0].Quote_Stage__c ='Quote Offered';
        update quoteLstGemtenth;
        quoteLstGemThirteen[0].Quote_Stage__c ='Quote Offered';
        update quoteLstGemThirteen;
        quoteLstGemFifth[0].Quote_Stage__c ='Quote Offered';
        update quoteLstGemFifth;
        quoteLstGemthree[0].Quote_Stage__c ='Quote Offered';
        update quoteLstGemthree;
       List<OrgWideEmailAddress> addresses = [select id, Address, DisplayName from OrgWideEmailAddress where  DisplayName='Latitude Personal Loans' or DisplayName= 'Gem Personal Loans' LIMIT 2];
      // Get the email templates
      List<EmailTemplate> emailTemplates =[select Id,name, Body, htmlvalue, Subject  from EmailTemplate 
                              where 
                             name IN('Soft Quote Day3 Reminder AU','Soft Quote Day5 Reminder AU','Soft Quote Day10 Reminder AU','Soft Quote Day1 Reminder AU',
                             'Soft Quote Day1 Reminder AU Better Start','Soft Quote Day3 Reminder AU Better Start','Soft Quote Day5 Reminder AU Better Start','Soft Quote Day10 Reminder AU Better Start',
                             'GEM Soft Quote Day3 Reminder','GEM Soft Quote Day5 Reminder','GEM Soft Quote Day10 Reminder','GEM Soft Quote Day1 Reminder')];
  
    Test.StartTest();
    quoteBatchEmailReminder batchEmail = new quoteBatchEmailReminder();
    DataBase.executeBatch(batchEmail); 
    Test.stopTest(); 
  }  

 
 
}