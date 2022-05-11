@isTest
public with sharing class ScheduleinsuranceSystemProcessTest {

  public static testMethod void testSchedule(){
     Test.startTest();
     ScheduleinsuranceSystemProcess sisp = new ScheduleinsuranceSystemProcess();
     String sch = '0 0 23 * * ?';
     system.schedule('Schedule Insurance System Process', sch, sisp);
     Test.stopTest();
  }
}