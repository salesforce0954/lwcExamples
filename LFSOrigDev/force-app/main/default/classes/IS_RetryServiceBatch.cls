/*
 * @Description: Batch class to process webservice exception logs
 * @Author: 
 * @Date Created: MAR-18-2014
 * @History:
   =====================================================================
       03-18-14: Created. 
   =====================================================================
 */ 

global class IS_RetryServiceBatch implements Database.batchable<sObject>, Database.AllowsCallouts{ 

    private Set<String> retryAbleErrors;
    private Integer maxRetry;
    private String retryStatusPending;
    private String isCustomerSearchClass;
    private DateTime oneMinuteEarlier;

    public IS_RetryServiceBatch() {
        this.retryAbleErrors = new Set<String>();
        for(Webservice_Message_Codes__c wmc : [Select Name from Webservice_Message_Codes__c where Retry__c = true]) {
            this.retryAbleErrors.add(wmc.Name);
        }
        this.maxRetry = Integer.valueOf(Web_Service_Settings__c.getValues('Max Retry').Value__c);
        this.retryStatusPending = GEN_OriginationsConstants.RETRY_STATUS_PENDING;
        this.isCustomerSearchClass = GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH;
        this.oneMinuteEarlier = System.now().addMinutes(-1);
    }

    global Database.QueryLocator start(Database.batchableContext info){ 
        //need to declare method variables since class variables are not visible inside this method
        Set<String> retryAbleErrors = this.retryAbleErrors;
        Integer maxRetry = this.maxRetry;
        String retryStatusPending = this.retryStatusPending;
        String isCustomerSearchClass = this.isCustomerSearchClass;
        DateTime oneMinuteEarlier = this.oneMinuteEarlier;
    
        //filter only the exception logs with retry-able errors, with pending status and has retry attempt < max retry attempt
        String query = 'SELECT Id, ' +
                               'Retry_Message__c, ' +
                               'Last_Retry_Attempt__c, ' +
                               'Retry_Attempts__c, ' +
                               'Retry_Status__c, ' +
                               'Object_Name__c, ' +
                               'Parameters__c, ' +
                               'Exception__c, ' +
                               'Webservice_Requested_Name__c ' +
                        'FROM ExceptionLog__c ' +
                        'WHERE Retry_Attempts__c <: maxRetry ' +
                        'AND Retry_Status__c =: retryStatusPending ' +
                        'AND Webservice_Response_Code__c IN: retryAbleErrors ' +
                        'AND Object_Name__c !=: isCustomerSearchClass ' +
                        'AND CreatedDate <=: oneMinuteEarlier ' +
                        'ORDER BY CreatedDate ASC';

        return Database.getQueryLocator(query);
    }     
    global void execute(Database.batchableContext info, List<ExceptionLog__c> scope){ 
    
        for(ExceptionLog__c e: scope) {
            System.debug('sysdbg-e.Id: ' + e.Id);
            System.debug('sysdbg-e.Object_Name__c: ' + e.Object_Name__c);
            System.debug('sysdbg-e.Retry_Status__c: ' + e.Retry_Status__c);
        }
        //process the exception record using the batch handler
        IS_RetryServiceBatchHandler handler = new IS_RetryServiceBatchHandler();
        handler.handleExceptions(scope);
    }
         
    global void finish(Database.batchableContext info){
        //re-run the batch job again if there are new record, process only ONE record at a time
        List<ExceptionLog__c> exLogCheck = [SELECT Id 
                                            FROM   ExceptionLog__c 
                                            WHERE  Retry_Attempts__c <: this.maxRetry
                                             AND   Retry_Status__c =: this.retryStatusPending
                                             AND   Webservice_Response_Code__c IN: this.retryAbleErrors
                                             AND   Object_Name__c !=: this.isCustomerSearchClass
                                            LIMIT  1];
        if(exLogCheck.size()>0) {
            //check if there is a scheduled job that is about to run
            List<CronTrigger> cronTriggerList = [SELECT Id,
                                                        NextFireTime
                                                 FROM   CronTrigger
                                                 WHERE  CronJobDetail.Name = 'Retry Service'
                                                  AND   (NextFireTime >: Datetime.now() OR NextFireTime =: null)
                                                 LIMIT  1];
            
            //if there is no retry service scheduled job that is about to fire, then schedule the batch to run in 1 minute
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