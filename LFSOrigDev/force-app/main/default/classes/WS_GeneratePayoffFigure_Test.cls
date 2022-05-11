/*
 * @Description: Test class for Generate Payoff Figure Service
 * @Author: Tony xu
 * @Date Created: 2015-03-10
 * @History:
   =====================================================================
       2015-03-10: Created - Tony xu
   =====================================================================
 */

@isTest

public class WS_GeneratePayoffFigure_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
	
	static testMethod void testSuccessfulRetrievePayoffFigureRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
                                                                                     
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GeneratePayoffFigure.generatePayoffFigureRequest(applicationBuilder.application.Id,'100000', true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
    
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    
    
    static testMethod void testSuccessfulRetrievePayoffFigureRetryRequest() {
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        ExceptionLog__c exLog = new ExceptionLog__c(parameters__c = applicationBuilder.application.Id);
        insert exLog;
        
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_GeneratePayoffFigure.RFinvokeRetryRequest(applicationBuilder.application.Id, '100000', true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, exLog.Id);
    	system.debug('==========TXU DEBUG=========valErrors:' + valErrors);
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    

}