/*
 * @Description: Test class for ExceptionLogTriggerHandler class
 * @Author: Davey Yu
 * @Date Created: May-15-2015
 * @History:
   =====================================================================
       05-15-15: Created - Davey
   =====================================================================
 */
@isTest
private class ExceptionLogTriggerHandlerTest {
	
	static testMethod void test_method_one() {
		String origin = 'testOrigin';
        String functionName = 'testFunctionName';
        String objectName = 'testObjectName';
        String exceptionVar = 'testExceptionVar';
        String status = 'testStatus';
        String params = 'testParams';
        String exceptionMessage = 'testExceptionMessage';
        String stackTrace = 'testStackTrace';
        Integer retryAttm = 2;

        Id recordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'ExceptionLog__c' AND DeveloperName =: 'General'].Id;

        ExceptionLog__c testExceptionLog = TestDataBuilder.createExceptionLog(origin,functionName,objectName,exceptionVar,status,params,recordTypeId);
        testExceptionLog.Webservice_Response_Code__c = '9996';
        insert testExceptionLog;
        List<ExceptionLog__c> logs = [Select id, Webservice_Response_Code__c from ExceptionLog__c where id=: testExceptionLog.id];

        Webservice_Message_Codes__c wmc = new Webservice_Message_Codes__c(Name='9996', Retry__c=true);
   		insert wmc;

   		Web_Service_Settings__c  ws= testDataBuilder.createWebServiceSettings('Max Retry', '1');
   		insert ws;
        
        Test.startTest();
           ExceptionLogTriggerHandler.processRetryBatch(logs);
        Test.stopTest();

        List<ExceptionLog__c> exLog = [SELECT Exception__c FROM ExceptionLog__c];
        System.assert(!exLog.isEmpty());
	}
	
}