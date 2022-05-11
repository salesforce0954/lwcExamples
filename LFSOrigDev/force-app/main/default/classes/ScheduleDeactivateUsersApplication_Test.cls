/**
 * @Description: Test class for schedule on deactivating customer portal users 
 * @Author: Davey
 * @Date Created: 29-10-2015
 * @History:
    =====================================================================
       29-10-2014: Created. - Davey
    =====================================================================
**/
@istest
public class ScheduleDeactivateUsersApplication_Test {
    
    static testMethod void schedule_Test(){

        List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
        insert testDataPurgeSettings;
        
        String startTime = '0 0 12 * * ?';
        String startTime2 = '0 0 13 * * ?';
        
        Test.StartTest();

        // Schedule the test job for new applications
        ScheduleDeactivateUsersUnsubmitted scheduler = new ScheduleDeactivateUsersUnsubmitted();
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
        
        // Schedule the test job for submitted applications
        ScheduleDeactivateUsersSubmitted scheduler2 = new ScheduleDeactivateUsersSubmitted ();
        String jobId2 = System.schedule('Test Job2', '0 0 13 * * ?', scheduler2);
        CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId2];
        System.assertEquals(startTime2, ct2.CronExpression);
        System.assertEquals(0, ct2.TimesTriggered);
        String currentMonth2 = (Date.today().month()>=10) ? String.valueOf(Date.today().month()) : '0'+String.valueOf(Date.today().month());
        String currentDate2 = (Datetime.now().hour()<13) ? String.valueOf(Date.today().day()) : String.valueOf(Date.today().day()+1);

        Test.StopTest();
    }
}