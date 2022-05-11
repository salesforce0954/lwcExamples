/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: ScheduleDeleteRecordsBatch test class
History
06/04/15    Michael Lasala      Created
------------------------------------------------------------*/
@isTest
public class ScheduleDeleteRecordsBatch_Test {
    
    static testMethod void schedule_Test(){

        List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
        insert testDataPurgeSettings;
        
        String startTime = '0 0 12 * * ?';
        
        Test.StartTest();

        // Schedule the test job
        ScheduleDeleteRecordsBatch scheduler = new ScheduleDeleteRecordsBatch();
        String jobId = System.schedule('Test Job', '0 0 12 * * ?', scheduler);
        
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
        Test.StopTest();
    }
}