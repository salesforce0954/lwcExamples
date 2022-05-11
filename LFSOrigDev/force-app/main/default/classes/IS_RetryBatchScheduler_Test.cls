/*
 * @Description: Test class for webservice exception logs batch scheduler
 * @Author: Dan Crisologo
 * @Date Created: June-18-2014
 */

@isTest
public class IS_RetryBatchScheduler_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    public static testmethod void batchScheduleTest_If(){
       
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.OFFLINE_ACCEPTANCE);


        Test.startTest();
            ExceptionLog__c exLog = new ExceptionLog__c(Parameters__c = applicationBuilder.application.Id, 
                                                    Retry_Attempts__c = 0,
                                                    Retry_Status__c = 'Pending',
                                                    Webservice_Response_Code__c = '9996',
                                                    Object_Name__c = GEN_OriginationsConstants.WSCLASS_SUBMIT);
            insert exLog;

            Webservice_Message_Codes__c wmc = new Webservice_Message_Codes__c(Name='9996', Retry__c=true);
            insert wmc;
           
        Test.stopTest();
        
    }
    
    
}