/**
* @author Arshad Mohammed
* @date   21.May.2020
* @description Testclass to cover newInsuranceSystem class.
**/
@isTest
private class newInsuranceSystem_Test{
/**
* @author Arshad Mohammed
* @date   21.May.2020
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
        //testApplicationNZ.Application_type__c = 'Single';
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
            /*try{
            testApplicant.Application__r.final_approved_date__c = date.parse('01/11/2020');
            }catch(Exception e){}*/

           insert testApplicant;
           
           testApplicant.Mobile__c = '0412345643';
           update testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        
        
        List<Applicant_CLV__c> applicantCLVList = new List<Applicant_CLV__c>();
        Applicant_CLV__c apCLV = TestDataBuilder.createApplicantCLV(appSearch.Id, testApplicant.Id);
        applicantCLVList.add(apCLV);
        insert applicantCLVList;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        testLoanPurpose.Application__c = testApplication.Id;
        insert testLoanPurpose;
        
            Test.startTest();
        newInsuranceSystem nis= new newInsuranceSystem();
//        Database.executeBatch(new newInsuranceSystem ());
         Database.executeBatch(nis);
        Test.stopTest();  

  }
/**
* @author Arshad Mohammed
* @date   21.May.2020
* @description Testclass to cover newInsuranceSystem class.
**/
  @isTest static void testnewInsuranceSystemProcessBatch() {
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
        //testApplicationNZ.Application_type__c = 'Single';
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
        testApplication.Application_type__c = 'Joint';
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
        
        
        List<Applicant_CLV__c> applicantCLVList = new List<Applicant_CLV__c>();
        Applicant_CLV__c apCLV = TestDataBuilder.createApplicantCLV(appSearch.Id, testApplicant.Id);
        applicantCLVList.add(apCLV);
        insert applicantCLVList;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        testLoanPurpose.Application__c = testApplication.Id;
        insert testLoanPurpose;
        
            Test.startTest();
        newInsuranceSystem nis= new newInsuranceSystem();
//        Database.executeBatch(new newInsuranceSystem ());
         Database.executeBatch(nis);
        Test.stopTest();  
//    Test.startTest();
//        newInsuranceSystem nis= new newInsuranceSystem ();
//        Database.executeBatch(new newInsuranceSystem ());
//        Test.stopTest();   
  }

/**
* @author Arshad Mohammed
* @date   21.May.2020
* @description Testclass to cover newInsuranceSystem class.
**/
  @isTest static void testnewInsuranceSystemProcess() {
    Test.StartTest();
    ScheduleinsuranceSystemProcess sh1 = new ScheduleinsuranceSystemProcess();
    String sch = '0 0 23 * * ?';
    system.schedule('Test Check', sch, sh1); 
    Test.stopTest(); 
  }  

 
}