/*
 * @Description: Test class for Application Submit service
 * @Author: Dan Crisologo
 * @Date Created: Feb-18-2014
 * @History:
   =====================================================================
       18-02-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_ApplicationSubmit_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void testSuccessfulJointSubmit() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        // Create Application and assign test branch
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 1' + country_channel_Key);
        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSingleSubmit() {
        TestDataBuilder.IsTestFlag = true;

         // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 2' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSubmitRetryRequest() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.OFFLINE_ACCEPTANCE;

        system.debug('Own Key 3' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSubmitException() {
        TestDataBuilder.IsTestFlag = true;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSingleSubmitCalloutException() {
        TestDataBuilder.IsTestFlag = false;

         // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'AU';
        insert testBrand;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        applicationBuilder.application.Brand_Lookup__c = testBrand.Id;
        update applicationBuilder.application;

        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + testBrand.Country__c + '-'+ GEN_OriginationsConstants.ONLINE_ACCEPTANCE;

        system.debug('Own Key 2' + country_channel_Key);

        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationSubmit.ApplicationSubmitRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
}