//EDITED//

/*
 * @Description: Test class for webservice exception logs batch process
 * @Author: Dan Crisologo
 * @Date Created: May-29-2014
 */

@isTest
public class IS_RetryServiceBatch_Test{
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void batchProcessTest(){
        
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);
        ExceptionLog__c exLog = new ExceptionLog__c(Parameters__c = applicationBuilder.application.Id, 
                                                    Retry_Attempts__c = 0,
                                                    Retry_Status__c = 'Pending',
                                                    Webservice_Response_Code__c = '9996',
                                                    Object_Name__c = GEN_OriginationsConstants.WSCLASS_SUBMIT);
        insert exLog;
    
        dateTime expectedDate = [SELECT CreatedDate FROM ExceptionLog__c WHERE id=:exlog.Id LIMIT 1].CreatedDate.addMinutes(1);

        Webservice_Message_Codes__c wmc = new Webservice_Message_Codes__c(Name='9996', Retry__c=true);
        insert wmc;
        
        Test.startTest();
        //need to have Test.isRunningTest() in batch class in order for this to work. Scheduler and createdDate is conflicting :(
        //System.scheduleBatch(new IS_RetryServiceBatch(), 'Retry Service', 1, 1);

        //Cannot assert since batch class is asynchronous call, 
        
        //June 17, 2014
        IS_RetryServiceBatch rsb = new IS_RetryServiceBatch();
        String jobId = System.scheduleBatch(rsb, 'Retry Service Batch', 1, 1);
        


        Test.stopTest();
        
    }
    
}