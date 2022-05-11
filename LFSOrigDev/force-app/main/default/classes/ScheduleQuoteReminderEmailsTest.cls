@isTest
public with sharing class ScheduleQuoteReminderEmailsTest {

  public static testMethod void testSchedule(){
     Test.startTest();
     ScheduleQuoteReminderEmails sqre = new ScheduleQuoteReminderEmails();
     String sch = '0 0 23 * * ?';
     system.schedule('Schedule Insurance System Process', sch, sqre);
     Test.stopTest();
  }
}