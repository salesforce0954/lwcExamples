/* @Description: Scheduler class for WS Retry Handler
 * @Author: Dan Crisologo
 * @Date Created: JUNE-16-2014
 * @History:
   =====================================================================
       2014-16-06: Dan Crisologo
   =====================================================================
 */ 
global class IS_RetryBatchScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        //check for running batch limit, run the batch if limit will not be hit
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')] < 5){
            Database.executebatch(new IS_RetryServiceBatch(), 1);
        } else {
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
                    //abort the existing and then schedule a new batch
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