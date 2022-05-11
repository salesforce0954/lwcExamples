/*
 * @Description: Batch class handler to process webservice exception logs
 * @Author: 
 * @Date Created: MAR-18-2014
 * @History:
   =====================================================================
       03-18-14: Created. 
   =====================================================================
 */ 

global class IS_RetryServiceBatchHandler { 

    global void handleExceptions(List<ExceptionLog__c> exceptionLogs) {
        
        for(ExceptionLog__c exLog: exceptionLogs) {
            Type t = Type.forName(exLog.Object_Name__c);
            IS_RetryInterface retryService = (IS_RetryInterface)t.newInstance();
            
            List<IS_ValidationError> errors = retryService.invokeRetryRequest(exLog.Parameters__c, Util.getUser().Mock_Enable__c, exLog.Webservice_Requested_Name__c, exLog.Id);
            
            if(!errors.isEmpty()) {
                String errMessages = exLog.Exception__c + '** RETRY RESULT: ';
                for(IS_ValidationError ve: errors) {
                    errMessages = errMessages + '(Error)' + ve.functionName + ' ' + ve.errorDescription;
                }
                errMessages = errMessages + ' **';
                ErrorHandlerException.updateWebServiceRetryLog(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, errMessages, exLog);
            }
            
            break; //get out of the loop; execute WS call only one time
        }
        
    }
}