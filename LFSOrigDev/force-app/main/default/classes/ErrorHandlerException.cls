/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: September 23, 2013
Description: Class to handle Generic Exceptions that will be logged in the ExceptionLog object
* @History:
   =====================================================================
       09-23-13: Created - Mac   
   =====================================================================
*/
public class ErrorHandlerException extends Exception{

    public static final String ORIGIN_CLASS = 'Class';
    public static final String STATUS_FAILED = 'Failed';
    public static final String STATUS_ERROR = 'Error';

    /**  Description: Method that inserts into the Exception Log object
     *  Author: Jan Mark Domingo
     *  Date Created: 09-23-13
     *  Input Parameters: exceptionMessage - the generic exception error
     *                      functionName   - the class/method name where the error happened
                            objectName     - the related object where the error happened
                            origin         - error happened in page,class, object
                            applicationId  - related application id if present
     *  Return: void
     */
    public static ExceptionLog__c recordException(String exceptionMessage, String functionName, String objectName, String origin, String applicationId){
        ExceptionLog__c exLog = new ExceptionLog__c();        
        exLog.Exception__c = exceptionMessage;
        exLog.Function_Name__c = functionName;
        exLog.Object_Name__c = objectName;
        exLog.Origin__c = origin;
        exLog.Application__c = applicationId;
        insert exLog;
    return exLog;
    }

    /**  Description: Method that inserts into the Exception Log object
     *  Author: Jan Mark Domingo
     *  Date Created: 09-23-13
     *  Input Parameters: exceptionMessage - the generic exception error
     *                      functionName   - the class/method name where the error happened
                            objectName     - the related object where the error happened
                            origin         - error happened in page,class, object        
     *  Return: void
     */
    public static ExceptionLog__c recordExceptionStack(String exceptionMessage, String stackTrace, String functionName, String objectName, String origin){
        ExceptionLog__c exLog = new ExceptionLog__c();        
        exLog.Exception__c = exceptionMessage;
        exLog.Function_Name__c = functionName;
        exLog.Object_Name__c = objectName;
        exLog.Origin__c = origin;
        insert exLog;
    return exLog;
    }
    
    /**  Description: Method that inserts into the Exception Log object
     *  Author: Jan Mark Domingo
     *  Date Created: 09-23-13
     *  Input Parameters: exceptionMessage - the generic exception error
     *                      functionName   - the class/method name where the error happened
                            objectName     - the related object where the error happened
                            origin         - error happened in page,class, object        
     *  Return: Exception Log
     */
    public static ExceptionLog__c recordException(String exceptionMessage, String objectName, String functionName, String origin, String status, String params, Integer retryAttm, String recTypeId){
        return recordException(exceptionMessage, null, functionName, null, origin, status, params, retryAttm, recTypeId);
    }

    /**  Description: Method that inserts into the Exception Log object
     *  Author: Jan Mark Domingo
     *  Date Created: 09-23-13
     *  Input Parameters: exceptionMessage - the generic exception error
     *                      functionName   - the class/method name where the error happened
                            objectName     - the related object where the error happened
                            origin         - error happened in page,class, object       
                            stackTrace     - stack Trace of the Exception 
     *  Return: Exception Log
     */
    public static ExceptionLog__c recordException(String exceptionMessage, String stackTrace, String functionName, String objectName, String origin, String status, String params, Integer retryAttm, String recTypeId){
        return recordWebserviceException(  exceptionMessage, 
                                        stackTrace,
                                        objectName,
                                        functionName, 
                                        origin, 
                                        status, 
                                        params, 
                                        retryAttm, 
                                        recTypeId,
                                        null,
                                        null,
                                        null);
    }
    
    /**  Description: Method that inserts into the Exception Log object
     *  Author: Dan Crisologo
     *  Date Created: 03-11-2014
     *  Input Parameters: exceptionMessage - the generic exception error
     *                    functionName     - the class/method name where the error happened
                          objectName       - the related object where the error happened
                          origin           - error happened in page,class, object  
                          status           - cause of exception ex. error, failure
                          params           - contains additional parameter ex. Application ID, applicant ID
                          retryAttm        - initial retry attempt
                          recTypeId        - record type id
                          wsResponseCode   - response code returned by WS Webservice class OR from webservice callout
                          wsRequestedName  - where did the callout was invoked ex. SalesUI, CustomerUI
     *  Return: void
     */
    public static ExceptionLog__c recordWebserviceException(String exceptionMessage, 
                                                 String stackTrace,
                                                 String objectName,
                                                 String functionName, 
                                                 String origin, 
                                                 String status, 
                                                 String params, 
                                                 Integer retryAttm, 
                                                 String recTypeId,
                                                 String wsResponseCode,
                                                 String wsRequestedName,
                                                 String retryStatus){
        
        ExceptionLog__c exLog = new ExceptionLog__c(Exception__c = exceptionMessage,
                                                    Stack_Trace__c = stackTrace,
                                                    Object_Name__c = objectName,
                                                    Function_Name__c = functionName,
                                                    Origin__c = origin,
                                                    Status__c = status,
                                                    Parameters__c = params,
                                                    Retry_Attempts__c = retryAttm,
                                                    Retry_Status__c = retryStatus,
                                                    RecordTypeId = recTypeId,
                                                    Webservice_Response_Code__c = wsResponseCode,
                                                    Webservice_Requested_Name__c = wsRequestedName);

        //attempt to populate the application lookup based on an id we are hoping is the id
        try {
            if(params!=null && Util.isIdTypeOfObject(params, Application__c.sObjectType)) {
                exLog.application__c = params;
            }
        }
        catch(StringException se) {
            system.debug('ErrorHandlerException.cls exception:' + se.getMessage());
        }

        try {
            insert exLog;
        }
        catch(Exception e) {
            system.debug('ErrorHandlerException.cls exception:' + e.getMessage());
        }

        return exLog;

    }
    
    /**  Description: Method that updates exception log with the new message / status
     *  Author: Dan Crisologo
     *  Date Created: 03-11-2014
     *  Input Parameters: msgCode - Response code from WS
                          exceptionMessage - WS message response description + stacktrace
                          exceptionMessage - retry message contains the last retry response code
                          exLog - exception log to update
     *  Return: void
     */
    public static void updateWebServiceRetryLog(String msgCode, String exceptionMessage, ExceptionLog__c exLog){
 
        exLog.Retry_Message__c = 'Retry Message Code: ' + msgCode;
        exLog.Exception__c = exceptionMessage;
        exLog.Last_Retry_Attempt__c = System.now(); 
        exLog.Retry_Attempts__c = exLog.Retry_Attempts__c == null ? 1: exLog.Retry_Attempts__c + 1;
        //retry is success if message code is successful
        if(msgCode==GEN_OriginationsConstants.WSCODE_SUCCESS2) {
            exLog.Retry_Status__c = GEN_OriginationsConstants.RETRY_STATUS_SUCCESS;
        } else if(exLog.Retry_Attempts__c >= Integer.valueOf(Web_Service_Settings__c.getValues('Max Retry').Value__c)) {
            exLog.Retry_Status__c = GEN_OriginationsConstants.RETRY_STATUS_FAILED;
        }

        update exLog;

    }
    
    public static ExceptionLog__c passwordResetException(String exceptionMessage, String functionName, String objectName, String origin, String recTypeId){
        ExceptionLog__c exLog = new ExceptionLog__c();
        exLog.Exception__c = exceptionMessage;
        exLog.Function_Name__c = functionName;
        exLog.Object_Name__c = objectName;
        exLog.Origin__c = origin;
        exLog.RecordTypeId = recTypeId; 
        insert exLog;
    return exLog;
    }
}