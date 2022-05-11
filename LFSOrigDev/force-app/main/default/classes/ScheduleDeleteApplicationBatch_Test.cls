/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: ScheduleDeleteRecordsBatch test class
History
06/04/15    Michael Lasala      Created
------------------------------------------------------------*/
@isTest
public class ScheduleDeleteApplicationBatch_Test {
    
    static testMethod void schedule_Test(){

        List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
        insert testDataPurgeSettings;
        
        String startTime = '0 0 12 * * ?';
        String startTime2= '0 0 13 * * ?';
        String startTime3 = '0 0 14 * * ?';
        
        Test.StartTest();

        // Schedule the test job for unsubmitted applications
        ScheduleDeleteUnsubmittedApplication scheduler = new ScheduleDeleteUnsubmittedApplication();
        String jobId = System.schedule('Test Job1', '0 0 12 * * ?', scheduler);
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(startTime, ct.CronExpression);
        
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        String currentMonth = (Date.today().month()>=10) ? String.valueOf(Date.today().month()) : '0'+String.valueOf(Date.today().month());
        String currentDate = (Datetime.now().hour()<12) ? String.valueOf(Date.today().day()) : String.valueOf(Date.today().day()+1);
        //System.assertEquals(String.valueOf(Date.today().year())+'-'+currentMonth+'-'+currentDate+' 12:00:00', String.valueOf(ct.NextFireTime));

       
        ScheduleUpdateSubmittedApplication scheduler2 = new ScheduleUpdateSubmittedApplication ();
        String jobId2 = System.schedule('Test Job2', '0 0 13 * * ?', scheduler2);
        
       
        CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId2];
        
       
        System.assertEquals(startTime2, ct2.CronExpression);
        
       
        System.assertEquals(0, ct2.TimesTriggered);
        
    
        String currentMonth2 = (Date.today().month()>=10) ? String.valueOf(Date.today().month()) : '0'+String.valueOf(Date.today().month());
        String currentDate2 = (Datetime.now().hour()<13) ? String.valueOf(Date.today().day()) : String.valueOf(Date.today().day()+1);
       
         // Schedule the test job for deleting other records billing
        ScheduleDeleteBillingRecordsBatch scheduler3 = new ScheduleDeleteBillingRecordsBatch();
        String jobId3 = System.schedule('Test Job3', '0 0 14 * * ?', scheduler3);
        
        
        CronTrigger ct3 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId3];
        
       
        System.assertEquals(startTime3, ct3.CronExpression);
        
       
        System.assertEquals(0, ct3.TimesTriggered);
        
       
        String currentMonth3 = (Date.today().month()>=10) ? String.valueOf(Date.today().month()) : '0'+String.valueOf(Date.today().month());
        String currentDate3 = (Datetime.now().hour()<14) ? String.valueOf(Date.today().day()) : String.valueOf(Date.today().day()+1);
        Test.StopTest();
    }
}