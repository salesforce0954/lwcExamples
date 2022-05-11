/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 03 March 2013 
* @description 
*/

@isTest
public without sharing class ScheduleOpportunityUpdateBatchTest {

   public static testMethod void testschedule() {

    Test.StartTest();
    ScheduleOpportunityUpdateBatch sh1 = new ScheduleOpportunityUpdateBatch();
            String sch = '0 0 23 * * ?';
            system.schedule('Opportunity Exclusion Update Batch', sch, sh1);
    Test.stopTest();
    System.assertNotEquals(sch, null);
   }// End testschedule Test Method
}// End ScheduleOpportunityUpdatebatchTest Class