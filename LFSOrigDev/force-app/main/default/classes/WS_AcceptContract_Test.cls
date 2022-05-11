/*
 * @Description: Test class for Accept Contract service
 * @Author: Dan Crisologo
 * @Date Created: MAR-11-2014
 * @History:
   =====================================================================
       11-03-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_AcceptContract_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }

    static testMethod void testSuccessfulAcceptContract() {

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_AcceptContract.acceptContractRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

    static testMethod void testAcceptContractRetryRequest() {

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;

        Test.startTest();
        List<IS_ValidationError> valErrors = IS_AcceptContract.invokeRetryRequest(applicationBuilder.application.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        //System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }

}