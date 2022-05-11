/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: September 23, 2013
Description: Class to handle Generic Exceptions that will be logged in the ExceptionLog object
* @History:
   =====================================================================
       09-23-13: Created - Mac   
   =====================================================================
*/
public class ExceptionHandler{
    /**  Description: Method that inserts into the Exception Log object
     *  Author: Jan Mark Domingo
     *  Date Created: 09-23-13
     *  Input Parameters: exceptionMessage - the generic exception error
     *                      functionName   - the class/method name where the error happened
                            objectName     - the related object where the error happened
                            origin         - error happened in page,class, object        
     *  Return: void
     */
    public static ExceptionLog__c recordException(String exceptionMessage, String functionName, String objectName, String origin){
        ExceptionLog__c exLog = new ExceptionLog__c();
        exLog.Exception__c = exceptionMessage;
        exLog.Function_Name__c = functionName;
        exLog.Object_Name__c = objectName;
        exLog.Origin__c = origin;
        insert exLog;
        return exLog;
    }

}