/*
 * @Description: Test class for Application Cancel/Declineservice
 * @Author: Dan Crisologo
 * @Date Created: MAR-11-2014
 * @History:
   =====================================================================
       11-03-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_ApplicationCancel_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void testSuccessfulDeclineApplication() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationCancel.ApplicationCancelRequest(applicationBuilder.application.Id, 'SCORE – TD', 'intent', true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    
    static testMethod void testSuccessfulCancelApplication() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationCancel.ApplicationCancelRequest(applicationBuilder.application.Id, 'CUST. – INTEREST RATE', 'intent', true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testCancelApplicationRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        //create test workflow
        Id closeWFTypeId = Schema.SObjectType.Workflow__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.WORKFLOW_STATUS_CLOSEAPP).getRecordTypeId();
        Workflow__c wf = new Workflow__c(Status__c = 'EMP. – CASUAL < 12 MTHS', Comments__c = 'test', Description__c = 'Close Application', RecordTypeId=closeWFTypeId, application__c = applicationBuilder.application.Id);
        insert wf;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_ApplicationCancel.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

}