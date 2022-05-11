/*
 * @Description: Test class for Verify POI service
 * @Author: Dan Crisologo
 * @Date Created: MAR-17-2014
 * @History:
   =====================================================================
       17-03-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_VerifyPOI_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void testSuccessfulVerifyPOIRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        //mock the has uploaded to true
        applicationBuilder.applicant1.Has_Uploaded__c = true;
        applicationBuilder.applicant2.Has_Uploaded__c = true;
        
        List<Applicant__c> appList = new List<Applicant__c>();
        appList.add(applicationBuilder.applicant1);
        appList.add(applicationBuilder.applicant2);
        
        update appList;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_VerifyPOI.verifyPOIRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.debug('$$$ valErrors: '+valErrors);
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

     static testMethod void testSuccessfulVerifyPOIRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        applicationBuilder.applicant1.Has_Uploaded__c = true;
        applicationBuilder.applicant2.Has_Uploaded__c = true;
        
        List<Applicant__c> appList = new List<Applicant__c>();
        appList.add(applicationBuilder.applicant1);
        appList.add(applicationBuilder.applicant2);
        
        update appList;
        
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_VerifyPOI.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
        
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.debug('$$$ valErrors: '+valErrors);
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testNoApplicantVerifyPOIRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        delete applicationBuilder.applicant1;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_VerifyPOI.verifyPOIRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //There should be a validatior error returned
        System.assertEquals(valErrors.isEmpty(), false);
        Test.stopTest();
    }
   
}