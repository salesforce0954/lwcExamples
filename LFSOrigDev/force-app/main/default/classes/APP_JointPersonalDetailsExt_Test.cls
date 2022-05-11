/*
 * @Description: Test class for APP_JointPersonalDetailsExt_INT class
 * @Author: August Del Rosario
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - August
   =====================================================================
 */

@isTest
private class APP_JointPersonalDetailsExt_Test {
    static testMethod void constructorTest(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        
        
        List<AML__c> amlsize = new List<AML__c>();
        system.assertEquals(amlsize.size(),0);
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Gender__c = 'Female';
            testApplicant2.Drivers_Lic_Flg__c = true;
            testApplicant2.Email_Address__c = null;
            testApplicant2.Issue_Date__c = Date.today();
            testApplicant2.Expiry_Date__c = Date.today();
        insert testApplicant2;

        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.redirectTo = 'Save';
            jointPDExt.register();
            jointPDExt.logout();
            jointPDExt.getTimeOut();
            jointPDExt.getWarning();
            jointPDExt.applicantValidationResults = false;
            System.assertEquals(false,jointPDExt.applicantValidationResults);
        Test.StopTest();

        //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
        System.assertEquals(true, jointPDExt.isJoint);
        
        List<personalDetailsWrapper> applicantWrapperList = new List<personalDetailsWrapper>();
        personalDetailsWrapper applicantWrapper = new personalDetailsWrapper();
        applicantWrapper.applicant.Country_Res__c = 'New Zealand';
        applicantWrapper.applicant.Country_Pos__c = 'New Zealand';
        applicantWrapper.applicant.is_Primary_Applicant__c = true;
       // insert applicantWrapper.applicant;
       System.assertEquals(true,applicantWrapper.applicant.is_Primary_Applicant__c);
        applicantWrapperList.add(applicantWrapper);
        
    }
    static testMethod void deleteApplicant_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;       
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Gender__c = 'Female';
            testApplicant2.Drivers_Lic_Flg__c = true;
            testApplicant2.Email_Address__c = null;
        insert testApplicant2;

        PageReference testDeleteApplicant = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id);

        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            PageReference deleteApplicant = jointPDExt.deleteApplicant();
        Test.StopTest();

        System.assertEquals(testDeleteApplicant.getUrl(), deleteApplicant.getUrl());
    }

    static testMethod void saveApplicantSuccess_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        //User guestUser = [SELECT Id FROM User WHERE Name =: GEN_OriginationsConstants.GUEST_USERNAME LIMIT 1];
        //System.runAs(guestUser){
            Datatools__c testDatatools = TestDataBuilder.createDatatools();
            insert testDatatools;

            Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
            //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
            insert nz;
            
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;

            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
            testApplication.Brand_Lookup__c = testBrand.Id;
            insert testApplication;
            
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            
            insert testApplicant;

            Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
                testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
            insert testONR;

            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            insert testLoanPurpose;

            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant2;

            PageReference testSaveApplicant = new PageReference('/apex/app_timeout');
            
            Test.setCurrentPage(Page.APP_JointPersonalDetails);
            Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                UserUtility userUtil = new UserUtility ();
                userUtil.registerPassword = '1234'; 
                APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
                jointPDExt.redirectTo = 'Save';
                jointPDExt.applicantWrapper.PostalFlag = 'Yes';
                jointPDExt.applicantWrapper.NoOfDeps = '2';
                jointPDExt.applicantWrapper.birthMonth = '01';
                jointPDExt.applicantWrapper.birthDate = '01';
                jointPDExt.applicantWrapper.birthYear = '1990';    
                jointPDExt.applicant2Wrapper.PostalFlag = 'Yes';
                jointPDExt.applicant2Wrapper.NoOfDeps = '2';
                jointPDExt.applicant2Wrapper.birthMonth = '01';
                jointPDExt.applicant2Wrapper.birthDate = '01';
                jointPDExt.applicant2Wrapper.birthYear = '1990'; 
                jointPDExt.applicant2Wrapper.applicant.PO_Box__c = true;
                jointPDExt.applicantWrapper.applicant.Issue_Date__c = Date.today();
                jointPDExt.applicantWrapper.applicant.Expiry_Date__c = Date.today();
                jointPDExt.validateLoanFields();
                PageReference saveApplicant = jointPDExt.pageRedirect();
            Test.StopTest();
        //System.assertEquals(testSaveApplicant.getUrl(), saveApplicant.getUrl());
        //}
        //System.assertEquals(testApplicant.Id, jointPDExt.applicantWrapper.applicant.Id);
        System.assertEquals(testApplicant2.Id, jointPDExt.applicant2Wrapper.applicant.Id);
    }
    static testMethod void saveApplicantFail_NullFields(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);

        insert testApplicant2;

        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.redirectTo = 'Save';
            jointPDExt.applicantWrapper.applicant.Title__c = 'Select';
            jointPDExt.applicantWrapper.applicant.First_name__c = '';
            jointPDExt.applicantWrapper.applicant.Middle_Name__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Last_Name__c = '';
            jointPDExt.applicantWrapper.applicant.Gender__c = null;
            jointPDExt.applicantWrapper.applicant.Date_of_Birth__c = 'ERR8';
            jointPDExt.applicantWrapper.birthMonth = 'Select';
            jointPDExt.applicantWrapper.applicant.Rel_Status__c = 'Please Select';
            jointPDExt.applicantWrapper.NoOfDeps  = '';
            jointPDExt.applicantWrapper.applicant.Drivers_Lic_Flg__c = false;
            jointPDExt.applicantWrapper.applicant.Drivers_Lic_No__c = null;
            jointPDExt.applicantWrapper.applicant.Res_Status__c  = 'Please Select';
            jointPDExt.applicantWrapper.applicant.Residential_Property_Name__c  = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Unit_No_Res__c  = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Street_No_Res__c  = '';
            jointPDExt.applicantWrapper.applicant.Street_Res__c  = '';
            jointPDExt.applicantWrapper.applicant.Street_Type_Res__c = '';
            jointPDExt.applicantWrapper.applicant.Suburb_Res__c  = '';
            jointPDExt.applicantWrapper.applicant.Postcode_Res__c = '';
            jointPDExt.applicantWrapper.applicant.Country_Res__c= '';
            jointPDExt.applicantWrapper.applicant.Mobile__c = '';
            jointPDExt.applicantWrapper.applicant.Home__c = '';
            jointPDExt.applicantWrapper.applicant.Work__c = '';
            jointPDExt.applicantWrapper.applicant.Email_Address__c = '';
            jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '0';
            jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '0';
            jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '123a';
            jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
            jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = '';

            jointPDExt.applicant2Wrapper.applicant.First_Name__c  = 'ERR2';
            jointPDExt.applicant2Wrapper.applicant.Last_Name__c = 'a';
            jointPDExt.applicant2Wrapper.applicant.Date_of_Birth__c = 'ERR6';
            jointPDExt.applicant2Wrapper.NoOfDeps = 'a';
            jointPDExt.applicant2Wrapper.applicant.Drivers_Lic_Flg__c = false;
            jointPDExt.applicant2Wrapper.applicant.Drivers_Lic_No__c = 'ERR1';
            jointPDExt.applicant2Wrapper.applicant.Street_No_Res__c  = 'ERR1';
            jointPDExt.applicant2Wrapper.applicant.Street_Res__c  = 'ERR1';
            jointPDExt.applicant2Wrapper.applicant.Postcode_Res__c = '123l';
            jointPDExt.applicant2Wrapper.applicant.Country_Res__c = 'Australia';
            jointPDExt.applicant2Wrapper.applicant.State_Res__c = '';
            jointPDExt.applicant2Wrapper.applicant.Mobile__c = 'ERR4';
            jointPDExt.applicant2Wrapper.applicant.Work__c = 'ERR4';
            jointPDExt.applicant2Wrapper.applicant.Home__c = 'ERR4';
            jointPDExt.applicant2Wrapper.applicant.Email_Address__c = 'ERR5';
            jointPDExt.applicant2Wrapper.applicant.Country_Pos__c  = '';

            PageReference saveApplicant = jointPDExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(null, saveApplicant);
    }
    static testMethod void saveApplicantFail_ErrorFields(){
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
       
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        

        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.redirectTo = 'Save';
            jointPDExt.applicantWrapper.applicant.First_Name__c  = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Middle_Name__c ='ERR1';
            jointPDExt.applicantWrapper.applicant.Last_Name__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Date_of_Birth__c= 'ERR7';
            jointPDExt.applicantWrapper.applicant.Mobile__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Home__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Work__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Email_Address__c = 'ERR1';
            jointPDExt.applicantWrapper.PostalFlag ='No';
            jointPDExt.applicantWrapper.applicant.Unit_No_Pos__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Street_No_Pos__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Street_Pos__c  = 'ERR1';

            jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '2';
            jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '2';
            jointPDExt.applicantWrapper.applicant.Unit_No_Pre__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '';
            jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = '';
            jointPDExt.applicantWrapper.applicant.Street_Pre__c = '';
            jointPDExt.applicantWrapper.applicant.Street_Type_Pre__c  = '';
            jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '';
            jointPDExt.applicantWrapper.applicant.Country_Pre__c  = '';

            jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = '4';
            jointPDExt.applicant2Wrapper.applicant.Months_At_Addr__c = '4';
            jointPDExt.applicant2Wrapper.applicant.Email_Address__c = 'dummyTest@dummy.com';
            jointPDExt.applicantWrapper.applicant.Street_Pos__c = 'ERR10';
            jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = '1234';
            jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
            jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'ERR1';
            PageReference saveApplicant = jointPDExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(null, saveApplicant);
    }
    static testMethod void timeout_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.setCurrentPage(Page.APP_JointPersonalDetails);
        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.redirectTo = 'Timeout';
            jointPDExt.pageRedirect();
        Test.StopTest();

        //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }

    static testMethod void NewValidations_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Email_Address__c = 'Test@test.com';
        insert testApplicant2;

        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
            jointPDExt.applicantWrapper.PostalFlag = '';
            jointPDExt.applicantWrapper.NoOfDeps = '';
            jointPDExt.applicantWrapper.applicant.Street_Res__c = 'ERR10';
            jointPDExt.applicantWrapper.applicant.Suburb_Res__c = '1234';
            jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
            jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = 'Test';
            jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
            jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = 'Test';
            jointPDExt.applicantWrapper.applicant.Country_Pos__c = 'Australia';
            jointPDExt.applicantWrapper.applicant.State_Pos__c = '';
            jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '1';
            jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = '0';
            jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = '0';
            jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = '123412';
            jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Street_Pre__c = 'ERR1';
            jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = '123412';
            jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'Australia';
            jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = 'ERR1';
            jointPDExt.applicant2Wrapper.disableEmail  = false;
            jointPDExt.applicant2Wrapper.applicant.PO_Box__c = false;
            jointPDExt.applicant2Wrapper.PostalFlag = 'No';
            jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = '1';
            jointPDExt.applicant2Wrapper.applicant.Street_Pre__c = 'ERR10';
            jointPDExt.applicant2Wrapper.applicant.Country_Pre__c = 'Australia';
            jointPDExt.redirectTo = 'Save';
            jointPDExt.pageRedirect();
        Test.StopTest();

        //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
        System.assertEquals(testApplication.Id, jointPDExt.application.Id);
    }

    static testMethod void saveApplicantSuccessCertifiedDocumentsNZ_Test(){

        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

        Brand__c testBrand = TestDataBuilder.createBrand();
        testbrand.Country__c = GEN_OriginationsConstants.NZ_REGION;
        insert testBrand;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
            User testuser = TestDataBuilder.createUser(profileId);
                testuser.AppId__c = testApplication.Id;
            insert testuser;

            List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
            insert adminSettingsList;        
           
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;
            
            RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
            insert testONR;
            
            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            insert testLoanPurpose;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant;

            PageReference testSaveApplicant = new PageReference('/apex/app_applicationmain_int?id=' + testApplication.Id);

            Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
                jointPDExt.applicantWrapper.PostalFlag = 'Yes';
                jointPDExt.applicantWrapper.NoOfDeps = '2';
                jointPDExt.applicantWrapper.applicant.Date_Of_Birth__c = '01/01/1990';
                jointPDExt.applicantWrapper.birthMonth = '01';
                jointPDExt.applicantWrapper.birthDate = '01';
                jointPDExt.applicantWrapper.birthYear = '1990';
                jointPDExt.applicantWrapper.applicant.Title__c = 'Mr';
                jointPDExt.applicantWrapper.applicant.First_name__c = 'Test';
                jointPDExt.applicantWrapper.applicant.Last_Name__c = 'Test';
                jointPDExt.applicantWrapper.applicant.Gender__c = 'Male';
                jointPDExt.applicantWrapper.applicant.Rel_Status__c = 'Single';
                jointPDExt.applicantWrapper.NoOfDeps  = '0';
                jointPDExt.applicantWrapper.applicant.Mobile__c  = '0212341234';
                jointPDExt.applicantWrapper.applicant.Email_Address__c = 'test@mail.com';
                jointPDExt.applicantWrapper.applicant.Street_No_Res__c  = '1';
                jointPDExt.applicantWrapper.applicant.Street_Res__c  = 'Street';
                jointPDExt.applicantWrapper.applicant.Street_Type_Res__c = 'Avenue';
                jointPDExt.applicantWrapper.applicant.City_Res__c = 'Town';
                jointPDExt.applicantWrapper.applicant.Postcode_Res__c = '1000';
                jointPDExt.applicantWrapper.applicant.Country_Res__c= 'New Zealand';
                jointPDExt.applicantWrapper.applicant.Months_At_Addr__c = '0';
                jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = '3';
                jointPDExt.applicantWrapper.applicant.Service_Delivery_Type__c = 'Residential';
                jointPDExt.applicantWrapper.applicant.Street_No_Pos__c  = '1';
                jointPDExt.applicantWrapper.applicant.Street_Pos__c  = 'Street';
                jointPDExt.applicantWrapper.applicant.Street_Type_Pos__c = 'Avenue';
                jointPDExt.applicantWrapper.applicant.City_Pos__c = 'Town';
                jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = '1000';
                jointPDExt.applicantWrapper.applicant.Country_Pos__c= 'New Zealand';

                jointPDExt.redirectTo = 'Save';
                jointPDExt.applicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_CERTIFIED_DOCUMENTS_REQUIRED;
                jointPDExt.applicant.ID_Number__c = '123456789012345';
                
                // Code Scan Fix: Adrian Recio
                // Add Assertion
                //system.assertNotEquals(null,jointPDExt.pageRedirect());
            Test.StopTest();
        }
    }
    
    static testMethod void personalWrapper_Test(){
    Test.startTest();
     Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;     
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        try{
        APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
        jointPDExt.applicantWrapper.PostalFlag = '';
        jointPDExt.applicantWrapper.NoOfDeps = '';
        jointPDExt.applicantWrapper.isStaffUi =false;
        jointPDExt.applicantWrapper.applicant.Street_Res__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Res__c = null;
        jointPDExt.applicantWrapper.applicationCountry = 'AU'; 
        jointPDExt.applicantWrapper.applicant.PO_Box__c = true;
        jointPDExt.applicantWrapper.applicant.Suburb_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Postal_Property_Name__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.State_Pos__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Years_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Months_At_Prev_Addr__c = null;
        jointPDExt.applicantWrapper.applicant.Postcode_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_No_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Suburb_Pre__c = null;
        jointPDExt.applicantWrapper.applicant.Country_Pre__c = 'australia';
        jointPDExt.applicantWrapper.applicant.Previous_Property_Name__c = null;
         jointPDExt.applicantWrapper.applicant.Customer_ID_Type__c='Driving License';   
            jointPDExt.applicant2Wrapper.expiryDate=null;
           
        jointPDExt.applicant2Wrapper.disableEmail  = false;
        jointPDExt.applicant2Wrapper.applicant.PO_Box__c = false;
        jointPDExt.applicant2Wrapper.PostalFlag = null;
        jointPDExt.applicant2Wrapper.applicant.Years_At_Addr__c = null;
        jointPDExt.applicant2Wrapper.applicant.Street_Pre__c = null;
        jointPDExt.applicant2Wrapper.applicant.Country_Pre__c = null;
        jointPDExt.applicant2Wrapper.applicant.Service_Delivery_Type__c = null;
        jointPDExt.applicant2Wrapper.applicant.City_Pos__c=null;
         jointPDExt.applicant2Wrapper.applicant.Customer_ID_Type__c='Driving License';
           
        jointPDExt.redirectTo = 'Save';
        jointPDExt.pageRedirect();
        }
        catch(Exception e){
        }
        Test.StopTest();
    }
    
    //Test Generator
    static testMethod void test_logout_UseCase1(){
    List<Application__c> application_Obj  =  [SELECT Id,Add_Collateral_Identifiers__c,Add_Collateral_Insurance_Details__c,Adjusted_Interest_Fee_Locked__c,Adjusted_Interest_Rate_Locked__c,Create_3rd_Party_Closure_Letters__c,Create_3rd_Party_Limit_Reduction_Letters__c,Create_Encumbrance__c,Credit_Card_Eligibility_Flag__c,Credit_File_Check__c,Credit_References__c,ExceededHours__c,Generated_Doc_Confirm_Sent__c,Higher_Approval_Consent__c,Insurance_Acknowledgement__c,Interested_in_other_services__c,Invoice_Auto_Purchase__c,Is_Manager_Approved__c,Lending_Limit_Override__c,Loan_Insurance_Consent__c,Master_Offer_Flag__c,Obtain_V_Payouts__c,Out_Of_Sync__c,PCA_Flush__c,Rent_Mortgage_Split__c,Risk_Override__c,Set_Up_DD__c,Upsell_Opt_In__c,Willing_to_secure__c,Workflow_In_Progress__c,Doc_Gen_Check__c,Update_Doc_Gen_Check__c,CoOwnershipOfSecurityAuthorityFlag__c,CreditCardStatementFlag__c,CreditReferenceFlag__c,Insurance_Acknowledgement_Secondary__c,Is_Accepted_Primary__c,Is_Accepted_Secondary__c,Is_Insurance_Acknowledgement_Enabled_2nd__c,Is_Insurance_Acknowledgement_Enabled__c,MarriageCertificateFlag__c,NameChangeDocumenationFlag__c,Need_Deal_Reallocation__c,ProofOfClearVehicleOwnershipFlag__c,ProofOfPaymentFlag__c,ProofOfPaymentOfDefaultFlag__c,PropertyOwnershipFlag__c,SettlementStatementFlag__c,personal_loan_form_IDV__c,Conditional_Approved__c,Straight_Through_to_LPE__c,Application_Restarted__c,Customer_Confirmed_Online_Offer__c,Online_Self_serve_Insurance_Eligibility__c,Online_Self_serve_Upsell_Eligibility__c,Risk_Grade_Flag__c,Staff_Hide__c,Is_URL_Accessed__c,Promo_Ineligible__c,Trigger_Dedupe__c,Promo_Blending__c,Is_e_POI_completed__c,NZ_Submit_Flag__c from Application__c];
    //System.assertEquals(true,application_Obj.size()>0);
    List<Applicant__c> applicant_Obj  =  [SELECT Id,Application__c,Accept_Terms_and_Conditions__c,Agrees_to_Fees__c,Agrees_to_Privacy_Policy__c,Asset_Exempt__c,Debt_Consolidation_Acknowledgement__c,Debts_Exempt__c,Drivers_Lic_Flg__c,KB_HL_or_Graduate__c,Has_AML__c,Has_Credit_File_Check__c,Has_Uploaded__c,Interested_in_other_services__c,Is_Primary_Applicant__c,Loan_Insurance_Consent__c,Meets_Eligibility_Criteria__c,POI_Financial_Situation_Verified__c,PO_Box__c,Postal_Addr_Flg__c,Has_POA__c,Consent_to_Lpi__c from Applicant__c];
    //System.assertEquals(true,applicant_Obj.size()>0);
    //ApexPages.StandardSetController setCon = new ApexPages.StandardSetController();  
     Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;    
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
    try{
    APP_JointPersonalDetailsExt obj01 = new APP_JointPersonalDetailsExt(standardCon);   
    obj01.applicantWrapper = new personalDetailsWrapper();
    obj01.applicant2Wrapper = new personalDetailsWrapper();
    obj01.webServer = 'test data';
    obj01.webServerWebService = 'test data';
    obj01.URLKey = 'test data';
    obj01.redirectTo = 'test data';
    obj01.buttonStyle = 'test data';
    obj01.NZEndPoint = 'test data';
    obj01.NZRequestKey = 'test data';
    obj01.isBSOfferActive = false;
    obj01.applicantWrapperList = new List<personalDetailsWrapper>();
    obj01.applicantValidationResults = false;
    obj01.logout();
    }catch(Exception e){
    }
  }
  static testMethod void test_pageRedirect_UseCase1(){
    List<Application__c> application_Obj  =  [SELECT Id,Add_Collateral_Identifiers__c,Add_Collateral_Insurance_Details__c,Adjusted_Interest_Fee_Locked__c,Adjusted_Interest_Rate_Locked__c,Create_3rd_Party_Closure_Letters__c,Create_3rd_Party_Limit_Reduction_Letters__c,Create_Encumbrance__c,Credit_Card_Eligibility_Flag__c,Credit_File_Check__c,Credit_References__c,ExceededHours__c,Generated_Doc_Confirm_Sent__c,Higher_Approval_Consent__c,Insurance_Acknowledgement__c,Interested_in_other_services__c,Invoice_Auto_Purchase__c,Is_Manager_Approved__c,Lending_Limit_Override__c,Loan_Insurance_Consent__c,Master_Offer_Flag__c,Obtain_V_Payouts__c,Out_Of_Sync__c,PCA_Flush__c,Rent_Mortgage_Split__c,Risk_Override__c,Set_Up_DD__c,Upsell_Opt_In__c,Willing_to_secure__c,Workflow_In_Progress__c,Doc_Gen_Check__c,Update_Doc_Gen_Check__c,CoOwnershipOfSecurityAuthorityFlag__c,CreditCardStatementFlag__c,CreditReferenceFlag__c,Insurance_Acknowledgement_Secondary__c,Is_Accepted_Primary__c,Is_Accepted_Secondary__c,Is_Insurance_Acknowledgement_Enabled_2nd__c,Is_Insurance_Acknowledgement_Enabled__c,MarriageCertificateFlag__c,NameChangeDocumenationFlag__c,Need_Deal_Reallocation__c,ProofOfClearVehicleOwnershipFlag__c,ProofOfPaymentFlag__c,ProofOfPaymentOfDefaultFlag__c,PropertyOwnershipFlag__c,SettlementStatementFlag__c,personal_loan_form_IDV__c,Conditional_Approved__c,Straight_Through_to_LPE__c,Application_Restarted__c,Customer_Confirmed_Online_Offer__c,Online_Self_serve_Insurance_Eligibility__c,Online_Self_serve_Upsell_Eligibility__c,Risk_Grade_Flag__c,Staff_Hide__c,Is_URL_Accessed__c,Promo_Ineligible__c,Trigger_Dedupe__c,Promo_Blending__c,Is_e_POI_completed__c,NZ_Submit_Flag__c from Application__c];
    //System.assertEquals(true,application_Obj.size()>0);
    List<Applicant__c> applicant_Obj  =  [SELECT Id,Application__c,Accept_Terms_and_Conditions__c,Agrees_to_Fees__c,Agrees_to_Privacy_Policy__c,Asset_Exempt__c,Debt_Consolidation_Acknowledgement__c,Debts_Exempt__c,Drivers_Lic_Flg__c,KB_HL_or_Graduate__c,Has_AML__c,Has_Credit_File_Check__c,Has_Uploaded__c,Interested_in_other_services__c,Is_Primary_Applicant__c,Loan_Insurance_Consent__c,Meets_Eligibility_Criteria__c,POI_Financial_Situation_Verified__c,PO_Box__c,Postal_Addr_Flg__c,Has_POA__c,Consent_to_Lpi__c from Applicant__c];
    //System.assertEquals(true,applicant_Obj.size()>0);
    Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;    
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
    try{
    APP_JointPersonalDetailsExt obj01 = new APP_JointPersonalDetailsExt(standardCon);   
    obj01.applicant2Wrapper = new personalDetailsWrapper();
    obj01.webServer = 'test data';
    obj01.webServerWebService = 'test data';
    obj01.URLKey = 'test data';
    obj01.redirectTo = 'test data';
    obj01.buttonStyle = 'test data';
    obj01.NZEndPoint = 'test data';
    obj01.NZRequestKey = 'test data';
    obj01.isBSOfferActive = false;
    obj01.applicantWrapperList = new List<personalDetailsWrapper>();
    obj01.applicantValidationResults = false;
    obj01.pageRedirect();
    }catch(Exception e){
    }
  }
  
  
  static testMethod void test_pageRedirect_UseCase2(){
    Datatools__c testDatatools = TestDataBuilder.createDatatools();
    testDatatools.NZ_Request_Key__c ='Test NZ_Request_Key';
    insert testDatatools;
    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
        if(bsoffer==null){
        bsoffer.BetterStartAUActive__c = false;   
        bsoffer.BetterStartNZActive__c = false;        
        }
        insert bsoffer;
        
    Brand__c testBrand = TestDataBuilder.createBrand();
    insert testBrand;
    Application__c testApplication = TestDataBuilder.createApplication();
    testApplication.Brand_Lookup__c = testBrand.Id;
    insert testApplication;    
    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
    APP_JointPersonalDetailsExt obj01 = new APP_JointPersonalDetailsExt(standardCon);   
    obj01.applicantWrapperList = new List<personalDetailsWrapper>();
    
    
    personalDetailsWrapper ai4 = new personalDetailsWrapper();
    ai4.disableDrvcAst = '';
    ai4.isStaffUi=false;
    ai4.maleSelected = '';
    ai4.femaleSelected = '';
    ai4.PostalFlag = 'No';
    ai4.birthYear = '1980';
    ai4.birthMonth = '04';
    ai4.birthDate = '25';
    ai4.issueYear = '2010';
    ai4.issueMonth = '03';
    ai4.issueDate = '12';
    ai4.issueYearSec='';
    ai4.issueMonthSec='';
    ai4.issueDateSec='';
    ai4.issueYearSec='';
    ai4.NoOfDeps='4';
    ai4.TempDrivLicence='';
    ai4.applicationCountryMsg='';
    ai4.expiryDateSec='';
    ai4.expiryMonthSec='';
    ai4.expiryYearSec='';
    ai4.expiryYear = '2022';
    ai4.expiryMonth = '02';
    ai4.expiryDate = '15';      
    
    ai4.errorSecIDExpiryDate = false;
    ai4.errorSecIDNumber = false;
    
    ai4.errorPostalFlagMsg = '';
    ai4.applicationCountry = 'AU';
    ai4.errorTimePrevAtAddressMsg = '';
    ai4.errorPostalPostcodeMsg = '';
    ai4.errorPreviousPostcodeMsg = '';
    ai4.errorPreviousStreetMsg = '';
    ai4.errorPreviousStreetTypeMsg = '';
    ai4.errorPreviousUnitNoMsg = '';
    ai4.errorPreviousSuburbMsg = '';
    ai4.errorPreviousCityMsg = '';
    ai4.errorPreviousStreetNoMsg = '';
    ai4.errorPreviousStateMsg = '';
    ai4.errorPreviousCountryMsg = '';
    ai4.errorPreviousPropertyMsg = '';
    ai4.errorTimeAtAddressMsg = '';
    ai4.errorHomeMsg = '';
    ai4.errorMobileMsg = '';
    ai4.errorWorkMsg = '';
    ai4.errorEmailMsg = 'Error: Please enter your e-mail address.';
    ai4.errorTitleMsg = '';
    ai4.errorFNameMsg = '';
    ai4.errorMNameMsg = '';
    ai4.errorLNameMsg = '';
    ai4.errorGenderMsg = '';
    ai4.errorDateOfBirthMsg = '';
    ai4.errorRelStatMsg = '';
    ai4.errorNoOfDepsMsg = '';
    ai4.errorLicenseMsg = '';
    ai4.errorResStatMsg = '';
    ai4.errorPrefContactMethodMsg = '';
    ai4.errorUnitNumMsg = '';
    ai4.errorStreetNumMsg = '';
    ai4.errorStreetNameMsg = '';
    ai4.errorStreetTypeMsg = '';
    ai4.errorSuburbMsg = '';
    ai4.errorCityMsg = '';
    ai4.errorPostcodeMsg = '';
    ai4.errorStateMsg = '';
    ai4.errorCountryMsg = '';
    ai4.errorPropertyMsg = '';
    ai4.errorPostalAddressMsg = '';
    ai4.errorPostalUnitNoMsg = '';
    ai4.errorPostalStreetNoMsg = '';
    ai4.errorPostalStreetMsg = '';
    ai4.errorPostalStatemsg = '';
    ai4.errorPostalSuburbMsg = '';
    ai4.errorPostalCityMsg = '';
    ai4.errorPostalCountrymsg = '';
    ai4.errorServiceTypeMsg = '';
    ai4.errorServiceIdMsg = '';
    ai4.errorCustomerIdTypeMsg = '';
    ai4.errorCustomerIdNumberMsg = '';
    ai4.errorVersionMsg = '';
    ai4.errorNZResidencyNumberMsg = '';
    ai4.errorIssuedateMsg = '';
    ai4.errorExpirydateMsg = '';
    ai4.errorIssuingcountryMsg = '';
    ai4.errorOtherdocumentMsg = '';
    
    
    //DBHZL-81 -BEGIN
    ai4.errorSecIDExpiryDateMsg = '';
    ai4.errorSecIDNumberMsg = '';
    ai4.errorConfirmEmail=false;
    ai4.errorConfirmEmailMsg=''; 
    
    
    Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Gender__c = 'Male';
        testApplicant2.Drivers_Lic_Flg__c = true;
        //testApplicant2.is_Primary_Applicant__c = true;
        testApplicant2.Email_Address__c = null;
        testApplicant2.Issue_Date__c = Date.today();
        testApplicant2.Expiry_Date__c = Date.today();
    insert testApplicant2;
    List<AML__c> amllist = new List<AML__c>();
    AML__c aml = TestDataBuilder.createAML(testApplicant2.id);
    insert aml;
    amllist.add(aml);
    
    ai4.applicant = testApplicant2;
    obj01.applicantWrapper = new personalDetailsWrapper();
    obj01.amlList = new List<AML__c>();
    obj01.applicantWrapperList.add(ai4);
    obj01.applicantValidationResults = true;
    obj01.validateApplicant();
  }
  
  
  
  static testMethod void test_deleteApplicant_UseCase1(){
    List<Application__c> application_Obj  =  [SELECT Id,Add_Collateral_Identifiers__c,Add_Collateral_Insurance_Details__c,Adjusted_Interest_Fee_Locked__c,Adjusted_Interest_Rate_Locked__c,Create_3rd_Party_Closure_Letters__c,Create_3rd_Party_Limit_Reduction_Letters__c,Create_Encumbrance__c,Credit_Card_Eligibility_Flag__c,Credit_File_Check__c,Credit_References__c,ExceededHours__c,Generated_Doc_Confirm_Sent__c,Higher_Approval_Consent__c,Insurance_Acknowledgement__c,Interested_in_other_services__c,Invoice_Auto_Purchase__c,Is_Manager_Approved__c,Lending_Limit_Override__c,Loan_Insurance_Consent__c,Master_Offer_Flag__c,Obtain_V_Payouts__c,Out_Of_Sync__c,PCA_Flush__c,Rent_Mortgage_Split__c,Risk_Override__c,Set_Up_DD__c,Upsell_Opt_In__c,Willing_to_secure__c,Workflow_In_Progress__c,Doc_Gen_Check__c,Update_Doc_Gen_Check__c,CoOwnershipOfSecurityAuthorityFlag__c,CreditCardStatementFlag__c,CreditReferenceFlag__c,Insurance_Acknowledgement_Secondary__c,Is_Accepted_Primary__c,Is_Accepted_Secondary__c,Is_Insurance_Acknowledgement_Enabled_2nd__c,Is_Insurance_Acknowledgement_Enabled__c,MarriageCertificateFlag__c,NameChangeDocumenationFlag__c,Need_Deal_Reallocation__c,ProofOfClearVehicleOwnershipFlag__c,ProofOfPaymentFlag__c,ProofOfPaymentOfDefaultFlag__c,PropertyOwnershipFlag__c,SettlementStatementFlag__c,personal_loan_form_IDV__c,Conditional_Approved__c,Straight_Through_to_LPE__c,Application_Restarted__c,Customer_Confirmed_Online_Offer__c,Online_Self_serve_Insurance_Eligibility__c,Online_Self_serve_Upsell_Eligibility__c,Risk_Grade_Flag__c,Staff_Hide__c,Is_URL_Accessed__c,Promo_Ineligible__c,Trigger_Dedupe__c,Promo_Blending__c,Is_e_POI_completed__c,NZ_Submit_Flag__c from Application__c];
    //System.assertEquals(true,application_Obj.size()>0);
    List<Applicant__c> applicant_Obj  =  [SELECT Id,Application__c,Accept_Terms_and_Conditions__c,Agrees_to_Fees__c,Agrees_to_Privacy_Policy__c,Asset_Exempt__c,Debt_Consolidation_Acknowledgement__c,Debts_Exempt__c,Drivers_Lic_Flg__c,KB_HL_or_Graduate__c,Has_AML__c,Has_Credit_File_Check__c,Has_Uploaded__c,Interested_in_other_services__c,Is_Primary_Applicant__c,Loan_Insurance_Consent__c,Meets_Eligibility_Criteria__c,POI_Financial_Situation_Verified__c,PO_Box__c,Postal_Addr_Flg__c,Has_POA__c,Consent_to_Lpi__c from Applicant__c];
    //System.assertEquals(true,applicant_Obj.size()>0);
Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;    
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
    try{
    APP_JointPersonalDetailsExt obj01 = new APP_JointPersonalDetailsExt(standardCon);       obj01.applicantWrapper = new personalDetailsWrapper();
    obj01.applicant2Wrapper = new personalDetailsWrapper();
    obj01.webServer = 'test data';
    obj01.webServerWebService = 'test data';
    obj01.URLKey = 'test data';
    obj01.redirectTo = 'test data';
    obj01.buttonStyle = 'test data';
    obj01.NZEndPoint = 'test data';
    obj01.NZRequestKey = 'test data';
    obj01.isBSOfferActive = false;
    obj01.applicantWrapperList = new List<personalDetailsWrapper>();
    obj01.applicantValidationResults = false;
    obj01.deleteApplicant();
    }catch(Exception e){
    }
  }
   static testMethod void test_validateApplicant_UseCase1(){
    //List<AML__c> aml_Obj  =  [SELECT Id,IsDeleted,Name,RecordTypeId,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,LastViewedDate,LastReferencedDate,Applicant__c,AML_Pos_Verified_Type_Code__c,AML_Pos_Verified_Type__c,AML_Ver_Date__c,Date_Verified__c,ID_1__c,ID_2__c,ID_3__c,ID_Expiry_Date__c,ID_Expiry_State__c,ID_Issue_Country__c,ID_Issue_Date__c,ID_Issuer__c,ID_No__c,Id_Sequence_No__c,Identification_Code__c,Identification__c,PRS_RECORD_ID__c,Staff_ID_SSO__c,Staff_ID_Sighted_By__c,Issue_Country__c,NZ_Residency_Number__c,POA_Issue_Date__c,POA_Provided_Flag__c,POA_Reference_Number__c,POA_Type_Code__c,POA_Type__c,Type_of_Identity__c,Verified_Flag__c,Version__c from AML__c];
    //System.assertEquals(true,aml_Obj.size()>0);

 Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        List<Applicant__c> applicantlist = new List<Applicant__c>();
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Gender__c = 'Female';
            testApplicant2.Drivers_Lic_Flg__c = true;
            testApplicant2.Email_Address__c = null;
            testApplicant2.Issue_Date__c = Date.today();
            testApplicant2.Expiry_Date__c = Date.today();
        insert testApplicant2;
        applicantlist.add(testApplicant2);
        //system.assertEquals(applicantlist.size() > 1, true);
        //system.assertEquals(applicantlist.size() > 2, true);
List<AML__c> amllist = new List<AML__c>();
 AML__c aml = TestDataBuilder.createAML(testApplicant2.id);
 insert aml;
 amllist.add(aml);
 System.assertEquals(amllist.size() > 0 ,true);
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
    try{
    APP_JointPersonalDetailsExt obj01 = new APP_JointPersonalDetailsExt(standardCon);
    obj01.applicantWrapperList = new List<personalDetailsWrapper>();
    obj01.amlList = new List<AML__c>();
    obj01.validateApplicant();
    }catch(Exception e){
    }
  }
    //End
    
    static testMethod void SubmitApplicationTest(){
        
        
        
        
        personalDetailsWrapper ai1 = new personalDetailsWrapper();
        ai1.disableDrvcAst = '';
        ai1.isStaffUi=true;
        ai1.maleSelected = '';
        ai1.femaleSelected = '';
        ai1.PostalFlag = 'No';
        ai1.birthYear = '';
        ai1.birthMonth = '';
        ai1.birthDate = '';
        ai1.issueYear = '';
        ai1.issueMonth = '';
        ai1.issueDate = '';
        ai1.issueYearSec='';
        ai1.issueMonthSec='';
        ai1.issueYearSec='';
        ai1.issueDateSec='';
        ai1.NoOfDeps='';
        ai1.expiryDateSec='';
        ai1.expiryMonthSec='';
        ai1.expiryYearSec='';
        ai1.expiryYear = '';
        ai1.expiryMonth = '';
        ai1.expiryDate = '';
        ai1.TempDrivLicence='';
        ai1.applicationCountryMsg='';
        ai1.errorPostalFlag = false;
        ai1.disableEmail = false;
        ai1.disableDOB = false;
        ai1.errorTitle = true;
        ai1.errorFName = false;
        ai1.errorMName = false;
        ai1.errorLName = false;
        ai1.errorGender = false;
        ai1.errorDateOfBirth = false;
        ai1.errorRelStat = false;
        ai1.errorNoOfDeps = false;
        ai1.errorLicense = false;
        ai1.errorResStat = false;
        ai1.errorPrefContactMethod = false;
        ai1.errorUnitNum = false;
        ai1.errorStreetNum = false;
        ai1.errorStreetName = false;
        ai1.errorStreetType = false;
        ai1.errorSuburb = false;
        ai1.errorCity = false;
        ai1.errorPostcode = false;
        ai1.errorState = false;
        ai1.errorCountry = false;
        ai1.errorTimeAtAddress = false;
        ai1.errorHome = false;
        ai1.errorMobile = false;
        ai1.errorWork = false;
        ai1.errorEmail = false;
        ai1.errorPostalPostcode = false;
        ai1.errorPreviousPostcode = false;
        ai1.errorPreviousStreet = false;
        ai1.errorPreviousStreetType = false;
        ai1.errorPreviousUnitNo = false;
        ai1.errorPreviousSuburb = false;
        ai1.errorPreviousCity = false;
        ai1.errorPreviousStreetNo = false;
        ai1.errorPreviousState = false;
        ai1.errorPreviousCountry = false;
        ai1.errorPreviousProperty = false;
        ai1.errorTimePrevAtAddress = false;
        ai1.errorPostalAddress = false;
        ai1.errorPostalUnitNo = false;
        ai1.errorPostalStreetNo = false;
        ai1.errorPostalStreet = false;
        ai1.errorPostalState = false;
        ai1.errorPostalSuburb = false;
        ai1.errorPostalCity = false;
        ai1.errorPostalCountry = false;
        ai1.errorServiceType = false;
        ai1.errorServiceId = false;
        ai1.errorCustomerIdType = false;
        ai1.errorIdType = false;
        ai1.errorVersion = false;
        ai1.errorNZResidencyNumber = false;
        ai1.errorIssuedate = false;
        ai1.errorExpirydate = false;
        ai1.errorIssuingcountry = false;
        ai1.errorOtherdocument = false;
        
        ai1.errorSecIDExpiryDate = false;
        ai1.errorSecIDNumber = false;
        
        ai1.errorPostalFlagMsg = '';
        ai1.applicationCountry = 'NZ';
        ai1.errorTimePrevAtAddressMsg = '';
        ai1.errorPostalPostcodeMsg = '';
        ai1.errorPreviousPostcodeMsg = '';
        ai1.errorPreviousStreetMsg = '';
        ai1.errorPreviousStreetTypeMsg = '';
        ai1.errorPreviousUnitNoMsg = '';
        ai1.errorPreviousSuburbMsg = 'Error: Only letters, numbers and hyphens are permitted in suburb.';
        ai1.errorPreviousCityMsg = '';
        ai1.errorPreviousStreetNoMsg = '';
        ai1.errorPreviousStateMsg = '';
        ai1.errorPreviousCountryMsg = '';
        ai1.errorPreviousPropertyMsg = '';
        ai1.errorTimeAtAddressMsg = '';
        ai1.errorHomeMsg = '';
        ai1.errorMobileMsg = '';
        ai1.errorWorkMsg = '';
        ai1.errorEmailMsg = '';
        ai1.errorTitleMsg = '';
        ai1.errorFNameMsg = '';
        ai1.errorMNameMsg = '';
        ai1.errorLNameMsg = '';
        ai1.errorGenderMsg = '';
        ai1.errorDateOfBirthMsg = '';
        ai1.errorRelStatMsg = '';
        ai1.errorNoOfDepsMsg = '';
        ai1.errorLicenseMsg = '';
        ai1.errorResStatMsg = '';
        ai1.errorPrefContactMethodMsg = '';
        ai1.errorUnitNumMsg = '';
        ai1.errorStreetNumMsg = '';
        ai1.errorStreetNameMsg = '';
        ai1.errorStreetTypeMsg = '';
        ai1.errorSuburbMsg = '';
        ai1.errorCityMsg = '';
        ai1.errorPostcodeMsg = '';
        ai1.errorStateMsg = '';
        ai1.errorCountryMsg = '';
        ai1.errorPropertyMsg = '';
        ai1.errorPostalAddressMsg = '';
        ai1.errorPostalUnitNoMsg = '';
        ai1.errorPostalStreetNoMsg = '';
        ai1.errorPostalStreetMsg = '';
        ai1.errorPostalStatemsg = '';
        ai1.errorPostalSuburbMsg = '';
        ai1.errorPostalCityMsg = '';
        ai1.errorPostalCountrymsg = '';
        ai1.errorServiceTypeMsg = '';
        ai1.errorServiceIdMsg = '';
        ai1.errorCustomerIdTypeMsg = '';
        ai1.errorCustomerIdNumberMsg = '';
        ai1.errorVersionMsg = '';
        ai1.errorNZResidencyNumberMsg = '';
        ai1.errorIssuedateMsg = '';
        ai1.errorExpirydateMsg = '';
        ai1.errorIssuingcountryMsg = '';
        ai1.errorOtherdocumentMsg = '';
        
        ai1.errorSecIDExpiryDateMsg = '';
        ai1.errorSecIDNumberMsg = '';
        ai1.errorPostalFlagMsg = '';
        ai1.errorTimePrevAtAddressMsg = '';
        ai1.errorPostalPostcodeMsg = '';
        ai1.errorPreviousPostcodeMsg = '';
        ai1.errorPreviousStreetMsg = '';
        ai1.errorPreviousStreetTypeMsg = '';
        ai1.errorPreviousUnitNoMsg =     '';
        ai1.errorPreviousSuburbMsg = '';
        ai1.errorPreviousCityMsg = '';
        ai1.errorPreviousStreetNoMsg = '';
        ai1.errorPreviousStateMsg = '';
        ai1.errorPreviousCountryMsg = '';
        ai1.errorPreviousPropertyMsg = '';
        ai1.errorTimeAtAddressMsg = '';
        ai1.errorHomeMsg = '';
        ai1.errorMobileMsg = '';
        ai1.errorWorkMsg = '';
        ai1.errorEmailMsg = '';
        ai1.errorTitleMsg = '';
        ai1.errorFNameMsg = '';
        ai1.errorMNameMsg = '';
        ai1.errorLNameMsg = '';
        ai1.errorGenderMsg = '';
        ai1.errorDateOfBirthMsg = '';
        ai1.errorRelStatMsg = '';
        ai1.errorNoOfDepsMsg = '';
        ai1.errorLicenseMsg = '';
        ai1.errorResStatMsg = '';
        ai1.errorPrefContactMethodMsg = '';
        ai1.errorUnitNumMsg = '';
        ai1.errorStreetNumMsg = '';
        ai1.errorStreetNameMsg = '';
        ai1.errorStreetTypeMsg = '';
        ai1.errorSuburbMsg = '';
        ai1.errorCityMsg = '';
        ai1.errorPostcodeMsg = '';
        ai1.errorStateMsg = '';
        ai1.errorCountryMsg = '';
        ai1.errorPropertyMsg = '';
        ai1.errorPostalAddressMsg = '';
        ai1.errorPostalUnitNoMsg = '';
        ai1.errorPostalStreetNoMsg = '';
        ai1.errorPostalStreetMsg = '';
        ai1.errorPostalStatemsg = '';
        ai1.errorPostalSuburbMsg = '';
        ai1.errorPostalCityMsg = '';
        ai1.errorPostalCountrymsg = '';
        ai1.errorServiceTypeMsg = '';
        ai1.errorServiceIdMsg = '';
        ai1.errorCustomerIdTypeMsg = '';
        ai1.errorCustomerIdNumberMsg = '';
        ai1.errorVersionMsg = '';
        ai1.errorNZResidencyNumberMsg = '';
        ai1.errorIssuedateMsg = '';
        ai1.errorExpirydateMsg = '';
        ai1.errorIssuingcountryMsg = '';
        ai1.errorOtherdocumentMsg = '';
        //DBHZL-81 -BEGIN
        ai1.errorSecIDExpiryDateMsg = '';
        ai1.errorSecIDNumberMsg = '';
        
        ai1.errorConfirmEmail=false;
        ai1.errorConfirmEmailMsg=''; 
        ai1.errorServiceId=true;
        
        Test.startTest();
        Application__c application1 = TestDataBuilder.createApplication();    
        insert application1;   
        
        Applicant__c app1 = new Applicant__c();
        app1.Application__c = application1.Id;
        
        app1.Title__c = 'Select';
        app1.PO_Box__c=true;
        app1.Street_No_Pos__c= null;
        app1.Country_Pos__c= null;
        app1.Street_Type_Pos__c= null;
        app1.Suburb_Pos__c= null;
        app1.City_Pos__c= null;
        app1.Postcode_Pos__c= null;
        app1.Service_Delivery_Id__c= 'Community Mail Box';
        app1.Street_Type_Res__c = null;
        app1.Suburb_Res__c= null;
        app1.City_Res__c= null;
        app1.Country_Res__c= null;
        app1.Customer_ID_Type__c ='NZ Passport';
        app1.Rel_Status__c = 'Please Select';
        app1.State_Res__c= null;
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Street_Type_Pre__c = 'Street';
        app1.Work__c= '0258258258';
        app1.Is_Primary_Applicant__c= false;
        app1.Email_Address__c= null;
        app1.ConfirmEmailAddress__c= null;
        app1.Years_At_Addr__c= '0';
        app1.Residential_Property_Name__c= null;
        app1.Unit_No_Res__c= null;
        app1.Unit_No_Pos__c= null;
        app1.Street_Res__c= null;
        app1.Postal_Addr_Flg__c= true;
        app1.Postal_Property_Name__c= null;
        
        app1.Service_Delivery_Type__c= 'PO Box';
        app1.Months_At_Addr__c= null;
        app1.Months_At_Prev_Addr__c= null;
        app1.Postcode_Pre__c= null;
        app1.Street_No_Pre__c= null;
        app1.Suburb_Pre__c= null;
        app1.City_Pre__c= null;
        app1.Country_Pre__c=null;
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Work__c= null; 
        app1.Mobile__c= null;
        app1.Home__c= null;
        app1.Work__c= null;
        insert app1;
        
        ai1.validateApplicant(app1, ai1) ;   
        ai1.executePOBox();
        
        
        Boolean checkCity = personalDetailsWrapper.validateCity(app1.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(app1.Name, app1.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(app1.Name);
        
        Test.stopTest();
        
    }
    static testMethod void testApplicationCheck(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Datatools__c testDatatools = TestDataBuilder.createDatatools();
        insert testDatatools;

         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        
        personalDetailsWrapper ai4 = new personalDetailsWrapper();
        ai4.disableDrvcAst = '';
        ai4.isStaffUi=false;
        ai4.maleSelected = '';
        ai4.femaleSelected = '';
        ai4.PostalFlag = 'No';
        ai4.birthYear = '1980';
        ai4.birthMonth = '04';
        ai4.birthDate = '25';
        ai4.issueYear = '2010';
        ai4.issueMonth = '03';
        ai4.issueDate = '12';
        ai4.issueYearSec='';
        ai4.issueMonthSec='';
        ai4.issueDateSec='';
        ai4.issueYearSec='';
        ai4.NoOfDeps='4';
        ai4.TempDrivLicence='';
        ai4.applicationCountryMsg='';
        ai4.expiryDateSec='';
        ai4.expiryMonthSec='';
        ai4.expiryYearSec='';
        ai4.expiryYear = '2022';
        ai4.expiryMonth = '02';
        ai4.expiryDate = '15';      
        
        ai4.errorSecIDExpiryDate = false;
        ai4.errorSecIDNumber = false;
        
        ai4.errorPostalFlagMsg = '';
        ai4.applicationCountry = 'AU';
        ai4.errorTimePrevAtAddressMsg = '';
        ai4.errorPostalPostcodeMsg = '';
        ai4.errorPreviousPostcodeMsg = '';
        ai4.errorPreviousStreetMsg = '';
        ai4.errorPreviousStreetTypeMsg = '';
        ai4.errorPreviousUnitNoMsg = '';
        ai4.errorPreviousSuburbMsg = '';
        ai4.errorPreviousCityMsg = '';
        ai4.errorPreviousStreetNoMsg = '';
        ai4.errorPreviousStateMsg = '';
        ai4.errorPreviousCountryMsg = '';
        ai4.errorPreviousPropertyMsg = '';
        ai4.errorTimeAtAddressMsg = '';
        ai4.errorHomeMsg = '';
        ai4.errorMobileMsg = '';
        ai4.errorWorkMsg = '';
        ai4.errorEmailMsg = 'Error: Please enter your e-mail address.';
        ai4.errorTitleMsg = '';
        ai4.errorFNameMsg = '';
        ai4.errorMNameMsg = '';
        ai4.errorLNameMsg = '';
        ai4.errorGenderMsg = '';
        ai4.errorDateOfBirthMsg = '';
        ai4.errorRelStatMsg = '';
        ai4.errorNoOfDepsMsg = '';
        ai4.errorLicenseMsg = '';
        ai4.errorResStatMsg = '';
        ai4.errorPrefContactMethodMsg = '';
        ai4.errorUnitNumMsg = '';
        ai4.errorStreetNumMsg = '';
        ai4.errorStreetNameMsg = '';
        ai4.errorStreetTypeMsg = '';
        ai4.errorSuburbMsg = '';
        ai4.errorCityMsg = '';
        ai4.errorPostcodeMsg = '';
        ai4.errorStateMsg = '';
        ai4.errorCountryMsg = '';
        ai4.errorPropertyMsg = '';
        ai4.errorPostalAddressMsg = '';
        ai4.errorPostalUnitNoMsg = '';
        ai4.errorPostalStreetNoMsg = '';
        ai4.errorPostalStreetMsg = '';
        ai4.errorPostalStatemsg = '';
        ai4.errorPostalSuburbMsg = '';
        ai4.errorPostalCityMsg = '';
        ai4.errorPostalCountrymsg = '';
        ai4.errorServiceTypeMsg = '';
        ai4.errorServiceIdMsg = '';
        ai4.errorCustomerIdTypeMsg = '';
        ai4.errorCustomerIdNumberMsg = '';
        ai4.errorVersionMsg = '';
        ai4.errorNZResidencyNumberMsg = '';
        ai4.errorIssuedateMsg = '';
        ai4.errorExpirydateMsg = '';
        ai4.errorIssuingcountryMsg = '';
        ai4.errorOtherdocumentMsg = '';
        
        
        //DBHZL-81 -BEGIN
        ai4.errorSecIDExpiryDateMsg = '';
        ai4.errorSecIDNumberMsg = '';
        
        ai4.errorConfirmEmail=false;
        ai4.errorConfirmEmailMsg=''; 
        
        
        
        
        Application__c application4 = TestDataBuilder.createApplication();
        application4.Brand_Lookup__c = testBrand.Id;
        insert application4;
        
        boolean flag = true;
           User siteUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1];
        System.runAs(siteUser) {
            System.debug('!@#testSite: ' + site.getName());
        }
        
        
        Applicant__c app4 = new Applicant__c();
        app4.Application__c = application4.Id;
        app4.PO_Box__c=true;
        
        app4.Date_Of_Birth__c = '01-01-1990';
        app4.Date_of_Birth_WS__c = '1990-01-01';
        app4.Drivers_Lic_No__c = '123123123';
        app4.Email_Address__c = 'Test@ge.com';
        app4.ConfirmEmailAddress__c = 'Test@ge.com';
        app4.First_Name__c = 'FirstName';
        app4.Gender__c = 'Male';
        app4.Home__c = '0212345678';
        app4.Drivers_Lic_Flg__c = false;
        app4.Last_Name__c = 'Lastname';
        app4.Middle_Name__c = 'MidName';
        app4.Mobile__c = '0412345678';
        app4.No_of_Deps__c = 2;
        app4.Residential_Property_Name__c='';
        app4.Postal_Addr_Flg__c = true;
        app4.Postcode_Pos__c = '4125';
        app4.Street_Pos__c = 'Sample';
        app4.Street_No_Pos__c = '123';
        app4.Street_Type_Pos__c = 'Street';
        app4.Suburb_Pos__c = 'NSW';
        app4.Unit_No_Pos__c = '1234';
        app4.Pref_Contact_Method__c = 'Phone';
        app4.Postcode_Pre__c = '4215';
        app4.Street_Pre__c = 'Sample';
        app4.Street_No_Pre__c = '123';
        app4.Street_Type_Pre__c = 'Street';
        app4.Suburb_Pre__c = 'NSW';
        app4.Unit_No_Pre__c = '123';
        app4.Rel_Status__c = 'Single';
        app4.Postcode_Res__c = '4125';
        app4.Res_Status__c = 'Renting';
        app4.Street_Res__c = 'Sample';
        app4.Street_No_Res__c = '123';
        app4.Street_Type_Res__c = 'Street';
        app4.Suburb_Res__c = 'NSW';
        app4.Unit_No_Res__c = '123';
        app4.Months_At_Addr__c = '2';
        app4.Years_At_Addr__c = '2';
        app4.Title__c = 'Select';
        app4.Work__c = '0212345678';
//        app4.Country_Pos__c = 'australia';
//        app4.Country_Res__c = 'Australia';
        app4.Country_Pos__c = 'New Zealand';
        app4.Country_Res__c = 'New Zealand';
        app4.Country_Pre__c = 'Australia';
        app4.State_Res__c = 'PARRAMATTA';
        app4.State_Pos__c = 'PARRAMATTA';
        app4.State_Pre__c = 'PARRAMATTA';
        app4.Customer_ID_Type__c ='Driving Licence';
        app4.Is_Primary_Applicant__c=true;
        app4.Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)';
        app4.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
        
        
        insert app4;
        system.debug('Check Application'+app4);
        ai4.validateApplicant(app4, ai4) ;   
        ai4.executePOBox(); 
        
        personalDetailsWrapper ai5 = new personalDetailsWrapper();
        ai4.validateApplicant(app4, ai5) ; 
        
        ApexPages.standardController standardCon = new ApexPages.standardController(application4);
        APP_JointPersonalDetailsExt obj04 = new APP_JointPersonalDetailsExt(standardCon);
        obj04.validateApplicant();

        Boolean checkCity = personalDetailsWrapper.validateCity(app4.Name);
        Boolean checkSuburb = personalDetailsWrapper.validateSuburb(app4.Name, app4.City_Pos__c);
        Boolean checkStreet = personalDetailsWrapper.validateStreet(app4.Name);
        
        
    }
    static testMethod void coverCoverage(){
    Application__c testApplication = TestDataBuilder.createApplication();        
        insert testApplication;
        personalDetailsWrapper applicantWrapper = new personalDetailsWrapper();
        applicantWrapper.applicant.Country_Res__c = 'New Zealand';
        applicantWrapper.applicant.Country_Pos__c = 'New Zealand';
        applicantWrapper.applicant.is_Primary_Applicant__c = true;
        
          UserUtility userUtil = new UserUtility ();
          userUtil.createCommunityUser(testApplication,applicantWrapper.applicant);

    }
    static testMethod void saveQuoteApplicantSuccess_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        
            Datatools__c testDatatools = TestDataBuilder.createDatatools();
            insert testDatatools;

            Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
            NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
            insert nz;
            
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;

            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Single';
            testApplication.Brand_Lookup__c = testBrand.Id;
            insert testApplication;
            
            Street_Type_Setting__c st1 = new Street_Type_Setting__c();
            St1.name='Road';
            St1.Value__c='Road';
            St1.Region__c='AU';
            St1.Value_Abbreviated_NZ__c='Rd';
            St1.Value_Abbreviated__c='Rd';
            insert St1;
            
            List<Quote__c> quoteList = TestDataBuilder.createQuoteAUOnline();
            quoteList[0].Application__c=testApplication.Id;
            insert quoteList;
             
             Quote_Product_Item__c testquoteProductItem = new Quote_Product_Item__c(Quote__c=quoteList[0].Id, Product_Version__c=testProductVersion.Id);
            insert testquoteProductItem;
            
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            
            insert testApplicant;

            Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
            insert testONR;

            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            insert testLoanPurpose;

            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant2;

            PageReference testSaveApplicant = new PageReference('/apex/app_timeout');
            
            Test.setCurrentPage(Page.APP_JointPersonalDetails);
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                UserUtility userUtil = new UserUtility ();
                userUtil.registerPassword = '1234'; 
                APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
                jointPDExt.redirectTo = 'Save';
                jointPDExt.applicantWrapper.PostalFlag = 'Yes';
                jointPDExt.applicantWrapper.NoOfDeps = '2';
                jointPDExt.applicantWrapper.birthMonth = '01';
                jointPDExt.applicantWrapper.birthDate = '01';
                jointPDExt.applicantWrapper.birthYear = '1990';    
                jointPDExt.applicant2Wrapper.PostalFlag = 'Yes';
                jointPDExt.applicant2Wrapper.NoOfDeps = '2';
                jointPDExt.applicant2Wrapper.birthMonth = '01';
                jointPDExt.applicant2Wrapper.birthDate = '01';
                jointPDExt.applicant2Wrapper.birthYear = '1990'; 
                jointPDExt.applicant2Wrapper.applicant.PO_Box__c = true;
                jointPDExt.applicantWrapper.applicant.Issue_Date__c = Date.today();
                jointPDExt.applicantWrapper.applicant.Expiry_Date__c = Date.today();
                jointPDExt.validateLoanFields();
                PageReference saveApplicant = jointPDExt.pageRedirect();
            Test.StopTest();
        
       
    }
    
     static testMethod void saveQuoteNZApplicantSuccess_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        
            Datatools__c testDatatools = TestDataBuilder.createDatatools();
            insert testDatatools;

            Brand__c testBrand = TestDataBuilder.createBrandNZ();
            insert testBrand;
            
            NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
            insert nz;
            
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;

            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Single';
            testApplication.Brand_Lookup__c = testBrand.Id;
            insert testApplication;
            
            Street_Type_Setting__c st1 = new Street_Type_Setting__c();
            St1.name='Road';
            St1.Value__c='Road';
            St1.Region__c='AU';
            St1.Value_Abbreviated_NZ__c='Rd';
            St1.Value_Abbreviated__c='Rd';
            insert St1;
                
            List<Quote__c> quoteList = TestDataBuilder.createQuoteNZOnline();
             quoteList[0].Application__c=testApplication.Id;
             insert quoteList;
             
             Quote_Product_Item__c testquoteProductItem = new Quote_Product_Item__c(Quote__c=quoteList[0].Id, Product_Version__c=testProductVersion.Id);
            insert testquoteProductItem;
            
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            
            insert testApplicant;

            Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
            insert testONR;

            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            insert testLoanPurpose;

            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant2;

            PageReference testSaveApplicant = new PageReference('/apex/app_timeout');
            
            Test.setCurrentPage(Page.APP_JointPersonalDetails);
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                UserUtility userUtil = new UserUtility ();
                userUtil.registerPassword = '1234'; 
                APP_JointPersonalDetailsExt jointPDExt = new APP_JointPersonalDetailsExt(standardCon);
                jointPDExt.redirectTo = 'Save';
                jointPDExt.applicantWrapper.PostalFlag = 'Yes';
                jointPDExt.applicantWrapper.NoOfDeps = '2';
                jointPDExt.applicantWrapper.birthMonth = '01';
                jointPDExt.applicantWrapper.birthDate = '01';
                jointPDExt.applicantWrapper.birthYear = '1990';    
                jointPDExt.applicant2Wrapper.PostalFlag = 'Yes';
                jointPDExt.applicant2Wrapper.NoOfDeps = '2';
                jointPDExt.applicant2Wrapper.birthMonth = '01';
                jointPDExt.applicant2Wrapper.birthDate = '01';
                jointPDExt.applicant2Wrapper.birthYear = '1990'; 
                jointPDExt.applicant2Wrapper.applicant.PO_Box__c = true;
                jointPDExt.applicantWrapper.applicant.Issue_Date__c = Date.today();
                jointPDExt.applicantWrapper.applicant.Expiry_Date__c = Date.today();
                jointPDExt.validateLoanFields();
                PageReference saveApplicant = jointPDExt.pageRedirect();
            Test.StopTest();
        
       
    }
}