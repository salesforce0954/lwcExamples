/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 24, 2014
Description: Test class for ApplicantAccountCustomerTriggerHandler 
*/
@isTest
private class ErrorHandlerException_Test {
    
    @isTest static void testExceptionLogs() {
        String origin = 'testOrigin';
        String functionName = 'testFunctionName';
        String objectName = 'testObjectName';
        String exceptionVar = 'testExceptionVar';
        String status = 'testStatus';
        String params = 'testParams';
        String exceptionMessage = 'testExceptionMessage';
        String stackTrace = 'testStackTrace';
        String msgCode = 'SUS01000';
        Integer retryAttm = 2;

        Id recordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'ExceptionLog__c' AND DeveloperName =: 'General'].Id;

        ExceptionLog__c testExceptionLog = TestDataBuilder.createExceptionLog(origin,functionName,objectName,exceptionVar,status,params,recordTypeId);
        insert testExceptionLog;

        Test.startTest();
            ErrorHandlerException.recordException(origin,functionName,objectName,exceptionVar,null);
            ErrorHandlerException.recordExceptionStack(exceptionMessage,stackTrace,functionName,objectName,origin);
            ErrorHandlerException.recordException(exceptionMessage,functionName,objectName,origin,status,params,retryAttm,recordTypeId);
            ErrorHandlerException.recordException(exceptionMessage,stackTrace,functionName,objectName,origin,status,params,retryAttm,recordTypeId);
            ErrorHandlerException.passwordResetException(exceptionMessage,functionName,objectName,origin,recordTypeId);
            ErrorHandlerException.updateWebServiceRetryLog(msgCode,exceptionMessage,testExceptionLog);
        Test.stopTest();

        List<ExceptionLog__c> exLog = [SELECT Exception__c FROM ExceptionLog__c];
        System.assert(!exLog.isEmpty());
    }
}