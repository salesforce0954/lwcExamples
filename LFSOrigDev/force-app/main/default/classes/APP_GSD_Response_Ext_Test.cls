@isTest
public class APP_GSD_Response_Ext_Test {
    @testSetup static void staticRecords() {
        List<Admin_Settings__c> testAdminSettings = TestDatabuilder.adminSet();
        insert testAdminSettings;

        TestDatabuilder.createResponsePageRiskGradeSettings();
        
        TestDataBuilder.createListInsurancePremiumVars();

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'New');
        insert responseCodeControl;
        system.assertEquals('New', responseCodeControl.Name);//assert inserted Response_Code_Control__c      

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true); 
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
        system.assertEquals(UserInfo.getProfileId(), profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c
    }
    static testMethod void retrieveApplication_AU_Simple_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        APP_GSD_BaseController.ApplicationWrapper testApp;
        Test.StartTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            testApp = APP_GSD_BaseController.retrieveApplication(testApplication.Id);
        Test.StopTest();

        System.assert(testApp.isStraightThrough);
        System.assertEquals(testApp.application.Id, testApplication.Id);
    }
    static testMethod void retrieveApplication_AU_Complex_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Channel__c = 'Online';
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            testLoanPurpose.Value__c = 'Debt consolidation';
        insert testLoanPurpose;
        
        APP_GSD_BaseController.ApplicationWrapper testApp;
        Test.StartTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            testApp = APP_GSD_BaseController.retrieveApplication(testApplication.Id);
        Test.StopTest();

        System.assert(!testApp.isStraightThrough);
        System.assertEquals(testApp.application.Id, testApplication.Id);
    }
    static testMethod void retrieveApplication_NZ_Simple_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            testLoanPurpose.Value__c = 'Auto repairs';
        insert testLoanPurpose;
        
        APP_GSD_BaseController.ApplicationWrapper testApp;
        Test.StartTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            testApp = APP_GSD_BaseController.retrieveApplication(testApplication.Id);
        Test.StopTest();

        System.assert(testApp.isStraightThrough);
        System.assertEquals(testApp.application.Id, testApplication.Id);
    }
    static testMethod void retrieveApplication_NZ_Complex_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Channel__c = 'Online';
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
            testLoanPurpose.Value__c = 'Debt consolidation';
        insert testLoanPurpose;
        
        APP_GSD_BaseController.ApplicationWrapper testApp;
        Test.StartTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            testApp = APP_GSD_BaseController.retrieveApplication(testApplication.Id);
        Test.StopTest();

        System.assert(!testApp.isStraightThrough);
        System.assertEquals(testApp.application.Id, testApplication.Id);
    }
    static testMethod void navigateToMain_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Channel__c = 'Broker';
        testApplication.Response_Code__c = 'New';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PIO';
        insert testApplicant;

        ResponsePageMeta__mdt meta;

        Test.startTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            meta = APP_GSD_BaseController.retrieveResponseMeta(testApplicant.Response_Code__c, testBrand.Country__c);
        Test.stopTest();

        System.assertNotEquals(null, meta);

    }

    static testMethod void validateBrokerApplicationTry_Test(){

        Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Channel__c = 'Broker';
        testApplication.Response_Code__c = 'New';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PIO';
        insert testApplicant;

        Test.startTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            responseExt.validateBrokerApplication();
        Test.stopTest();
    }

    static testMethod void validateBrokerApplicationCatch_Test(){
        Test.startTest();
            APP_GSD_Response_Ext responseExt = new APP_GSD_Response_Ext();
            ApexPages.CurrentPage().getParameters().put('Id', 'a0JN0000005u8V1');
            responseExt.validateBrokerApplication();
            responseExt.applicationNumber = 'test';
            responseExt.eAppsOutcome = 'test';
            responseExt.omnitureURL = 'test';
        Test.stopTest();
    }
}