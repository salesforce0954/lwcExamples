@isTest
public class APP_GSD_ContactUSController_Test{
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
    
    static testMethod void aussie_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        testBrand.LPE_Phone_Number__c = '1300138251';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Test.StartTest();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), GEN_OriginationsConstants.CONTACT_US_CALL+testBrand.LPE_Phone_Number__c);
        Test.StopTest();
    }
    
    static testMethod void latitudeReferred_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Inbound_Phone_Number__c = '1800734583';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'SAR';
        insert testApplication;
        
        Test.StartTest();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), GEN_OriginationsConstants.CONTACT_US_CALL+testBrand.Inbound_Phone_Number__c);
        Test.StopTest();
    }
    
    static testMethod void latitudeConditionallyApproved_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.LPE_Phone_Number__c = '1800803051';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Test.StartTest();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), GEN_OriginationsConstants.CONTACT_US_CALL+testBrand.LPE_Phone_Number__c);
        Test.StopTest();
    }

    static testMethod void nz_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testBrand.NZ_Contact_Details__c = 'ds.online@latitudefinancial.com';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Test.StartTest();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), GEN_OriginationsConstants.CONTACT_US_EMAIL+testBrand.NZ_Contact_Details__c);
        Test.StopTest();
    }
     static testMethod void constructorNull_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = 'Test';
        testBrand.NZ_Contact_Details__c = 'ds.online@latitudefinancial.com';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Test.StartTest();
            APP_GSD_ContactUSController contactUs = new APP_GSD_ContactUSController();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), '');
        Test.StopTest();
    }
    static testMethod void broker_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = 'Test';
        testBrand.Inbound_Skilled_Phone_Number__c = '1800803051';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Channel__c = 'Broker';
        insert testApplication;
        
        Test.StartTest();
            APP_GSD_ContactUSController contactUs = new APP_GSD_ContactUSController();
            System.assertEquals(APP_GSD_ContactUSController.getContactDetails(testApplication.Id), GEN_OriginationsConstants.CONTACT_US_CALL + testBrand.Inbound_Skilled_Phone_Number__c);
        Test.StopTest();
    }
}