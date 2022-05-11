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
    private class APP_JointPersonalDetailsExt_INT_Test {
        
        static testMethod void saveApplicantSuccess_Test(){
    
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
                Date testDate = Date.today();
                testApplicant.Issue_Date__c = testDate;
                testApplicant.Expiry_Date__c = testDate;
                insert testApplicant;
                
                Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
                testApplicant2.Drivers_Lic_No__c = '0987213213';
                insert testApplicant2;
    
                PageReference testSaveApplicant = new PageReference('/apex/app_applicationmain_int?id=' + testApplication.Id);
    
                Test.startTest();
                    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                    APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
                    jointPDExt.redirectTo = 'Save';
                    jointPDExt.applicantWrapper.PostalFlag = 'Yes';
                    jointPDExt.applicantWrapper.NoOfDeps = '2';
                    
                    jointPDExt.applicantWrapper.applicant.Date_Of_Birth__c = '01/01/1990';
                    jointPDExt.applicant2Wrapper.applicant.Date_Of_Birth__c = '01/01/1990';
                    jointPDExt.applicantWrapper.birthMonth = '01';
                    jointPDExt.applicantWrapper.birthDate = '01';
                    jointPDExt.applicantWrapper.birthYear = '1990';    
                    jointPDExt.applicant2Wrapper.PostalFlag = 'Yes';
                    jointPDExt.applicant2Wrapper.NoOfDeps = '2';
                    jointPDExt.applicant2Wrapper.birthMonth = '01';
                    jointPDExt.applicant2Wrapper.birthDate = '01';
                    jointPDExt.applicant2Wrapper.birthYear = '1990'; 
                    jointPDExt.applicant2Wrapper.applicant.PO_Box__c = false;
                    jointPDExt.applicant2Wrapper.issueYear = '2000';
                    jointPDExt.applicant2Wrapper.issueMonth = '4';
                    jointPDExt.applicant2Wrapper.issueDate = '5';
                    jointPDExt.applicant2Wrapper.expiryYear = '2000';
                    jointPDExt.applicant2Wrapper.expiryMonth = '4';
                    jointPDExt.applicant2Wrapper.expiryDate = '5';
                    PageReference saveApplicant = jointPDExt.pageRedirect();
    
                    jointPDExt.redirectTo = 'Back';
                    PageReference saveApplicantBack = jointPDExt.pageRedirect();
                    jointPDExt.redirectTo = 'Next';
                    PageReference saveApplicantNext = jointPDExt.pageRedirect();
                Test.StopTest();
                Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
                APP_JointPersonalDetail pdComponent = new APP_JointPersonalDetail();
            }
        }
        static testMethod void constructorTest(){
            Datatools__c testDatatools = TestDataBuilder.createDatatools();
            insert testDatatools;
    
            //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
            insert nz;
    
            Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
    
            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
            testApplication.Brand_Lookup__c = testBrand.Id;
            insert testApplication;
     
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
            
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
                testApplicant2.Gender__c = 'Female';
                testApplicant2.Drivers_Lic_Flg__c = true;
                testApplicant2.Email_Address__c = null;
            insert testApplicant2;
    
            Test.startTest();
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
                jointPDExt.redirectTo = 'Save';
            Test.StopTest();
    
           //System.assertEquals(testApplicant.Id, jointPDExt.applicant.Id);
            System.assertEquals(testApplication.Id, jointPDExt.application.Id);
        }
        static testMethod void saveApplicantFail_NullFields(){
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
            
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
    
            insert testApplicant2;
    
            Test.startTest();
                ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
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
            
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
    
            insert testApplicant2;
    
            Id profileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id; 
            Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
            User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
            System.runAs(adminUser) {
                User testUser = TestDataBuilder.createUser(profileId);
                testUser.Email = 'dummyTest@ge.com';
                insert testUser;
    
                Test.startTest();
                    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                    APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
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
                    PageReference saveApplicant = jointPDExt.pageRedirect();
                Test.StopTest();
    
                System.assertEquals(null, saveApplicant);
            }
        }
    
        static testMethod void saveApplicantSuccessDriverLicenseNZ_Test(){
    
            Datatools__c testDatatools = TestDataBuilder.createDatatools();
            insert testDatatools;
    
            Brand__c testBrand = TestDataBuilder.createBrand();
            testbrand.Country__c = GEN_OriginationsConstants.NZ_REGION;
            insert testBrand;
            
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
    
            //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
            insert nz;
            
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
                    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                    APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
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
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE;
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Version__c = 'abcd';
                    jointPDExt.applicant.ID_Number__c = '1-1';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Version__c = 'abc';
                    jointPDExt.applicant.ID_Number__c = 'ab1234567';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Version__c = '123';
                    jointPDExt.applicant.ID_Number__c = 'a123456';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.ID_Number__c = 'ab123456';
                    jointPDExt.pageRedirect();
                Test.StopTest();
            }
        }
    
        static testMethod void saveApplicantSuccessAustraliaPassportNZ_Test(){
    
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
                    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                    APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
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
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_AUSTRALIA_PASSPORT;
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.ID_No__c = '1 -4';
                    jointPDExt.applicant.Issuing_Country__c = 'Australia';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.ID_No__c = '1234';
                    jointPDExt.pageRedirect();
                Test.StopTest();
            }
        }
    
        static testMethod void saveApplicantSuccessOverseasPassportNZ_Test(){
    
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
                    ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
                    APP_JointPersonalDetailsExt_INT jointPDExt = new APP_JointPersonalDetailsExt_INT(standardCon);
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
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_OVERSEAS_PASSPORT;
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.NZ_Residency_Number__c = '12345678901';
                    jointPDExt.applicant.Issuing_Country__c = 'Australia';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.NZ_Residency_Number__c = '123456789-';
                    jointPDExt.pageRedirect();
                    jointPDExt.applicant.ID_Number__c = '123456789012345';
                    jointPDExt.applicant.NZ_Residency_Number__c = '1234567890';
                    jointPDExt.pageRedirect();
                Test.StopTest();
            }
        }
    }