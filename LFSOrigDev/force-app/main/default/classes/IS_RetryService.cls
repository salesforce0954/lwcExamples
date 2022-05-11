/**
 * @Description: Main Class for Retry of Applications that failed
 * @Author: Dan Crisologo
 * @Date Created: MAR-11-2014
 * @History:
   =====================================================================
        MAR-11 (Mac): Created.
   =====================================================================
 */
global class IS_RetryService {

    /*  Description: Method called by the Custom Button to invoke the web service call
     *  Author: Dan Crisologo
     *  Date Created: MAR-11-2014
     *  Input: exlogId - Id of the exception log record
     *  Return: None
     */
    Webservice static ExceptionLog__c retry(String exlogId){

        ExceptionLog__c exLog = [SELECT  Function_Name__c,  // function name holds the method name
                                         Object_Name__c,   //Object name holds the class name
                                         Webservice_Requested_Name__c, //this will determine the source of application
                                         Webservice_Response_Code__c, //this will determine response code returned by webservice call / ws class
                                         Retry_Attempts__c, //how many previous retries for this?
                                         Parameters__c, // this holds the value for application ID
                                         Retry_Message__c,
                                         Last_Retry_Attempt__c,
                                         Id,
                                         Retry_Status__c,
                                         Exception__c
                                 FROM    ExceptionLog__c 
                                 WHERE   Id = :exLogId
                                  AND    Object_Name__c !=: GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH];     
                  
        
        //Create the interface
        Type t = Type.forName(exLog.Object_Name__c); //object name is the class name
        IS_RetryInterface retryService = (IS_RetryInterface)t.newInstance();
        //invoke the retry using the interface method
        List<IS_ValidationError> errors = retryService.invokeRetryRequest(exLog.Parameters__c, Util.getUser().Mock_Enable__c, exLog.Webservice_Requested_Name__c, exLog.Id);

        //process received pre-validation errors
        if(!errors.isEmpty()) {
            String errMessages = exLog.Exception__c + '** RETRY RESULT: ';
            for(IS_ValidationError ve: errors) {
                errMessages = errMessages + '(Error)' + ve.functionName + ' ' + ve.errorDescription;
            }
            errMessages = errMessages + ' **';
            ErrorHandlerException.updateWebServiceRetryLog(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, errMessages, exLog);
        }
   
        return exLog;
    }   
}