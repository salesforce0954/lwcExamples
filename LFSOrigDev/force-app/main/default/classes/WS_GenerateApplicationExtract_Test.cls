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
public class WS_GenerateApplicationExtract_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }

    static testMethod void testSuccessfulJointAppExtract() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.generateApplicationExtractRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulSingleAppExtract() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.generateApplicationExtractRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testSuccessfulAppExtractRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GenerateApplicationExtract.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //There should be a validatior error returned
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

}