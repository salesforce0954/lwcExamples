/**
 * @Description: Interface used by most webservices for retry framework
 * @Author: Dan Crisologo
 * @Date Created: MAR-11-2014
 * @History:
   =====================================================================
       03-11-14: Created.
   =====================================================================
 */ 
global interface IS_RetryInterface {

    /**  Description: Method that invokes the request call for webservice retry framework
     *  Author: Dan Crisologo
     *  Date Created: 03-11-14
     *  Input Parameters: applicationID - Application ID to retry
                          mockEnable - determine whether or not to use mock service
                          requestedName - origin of the call
                          exceptionLogId - this will determine which exception log the retry had attempted
     *  Return: List<IS_ValidationError>
     */
    List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId);

}