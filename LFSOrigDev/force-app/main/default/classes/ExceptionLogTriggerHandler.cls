/* @Description: Trigger handler for exception trigger
 * @Author: Dan Crisologo
 * @Date Created: JUNE-16-2014
 * @History:
   =====================================================================
       2014-16-06: Dan Crisologo
   =====================================================================
 */ 
public class ExceptionLogTriggerHandler {
    
     /*  Description: run the retry batch for each retry-able errors found
     *  Author: Dan Crisologo
     *  Date Created: JUNE-16-2014
     *  Input Parameters: List<Exception_Log__c> exLogList coming from trigger.new
     *  Return: N/A
     */
    public static void processRetryBatch(List<ExceptionLog__c> exLogs) {
        
        Boolean runRetryBatch = false;
        
        Set<String> retryAbleErrors = new Set<String>();
        for(Webservice_Message_Codes__c wmc : [Select Name from Webservice_Message_Codes__c where Retry__c = true]) {
            retryAbleErrors.add(wmc.Name);
        }
        
        for(ExceptionLog__c ex: exLogs) {
            for(String errCode: retryAbleErrors) {
                if(ex.Webservice_Response_Code__c == errCode) {
                    runRetryBatch = true;
                    break; // break out of the loop, no need to check for the rest
                }
            }
        }
        
        //run the batch job if at least there is 1 retryable exception found
        if(runRetryBatch) {

            //check first if there is an upcoming retry service that will be running soon. otherwise, re-schedule self after 1 minute.
            List<CronTrigger> cronTriggerList = [SELECT Id,
                                                        NextFireTime
                                                 FROM   CronTrigger
                                                 WHERE  CronJobDetail.Name = 'Retry Service'
                                                  AND   (NextFireTime >: Datetime.now() OR NextFireTime =: null)
                                                 LIMIT  1];
            Boolean scheduleBatch = false;
            if(cronTriggerList.isEmpty()) {
                scheduleBatch = true;
            } else {
                if(cronTriggerList[0].NextFireTime==null) {
                    //abort the existing scheduled job without next fire time and then schedule a new batch
                    System.abortJob(cronTriggerList[0].Id);
                    scheduleBatch = true;
                }
            }
            if(scheduleBatch) {
                //re-schedule self in next minute
                IS_RetryBatchScheduler retryScheduler = new IS_RetryBatchScheduler();
                Datetime dt = Datetime.now().addMinutes(1);
                String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
                Id schedId = System.Schedule('Retry Service',timeForScheduler,retryScheduler);
            }
            
        }
        
    }
    
}