@isTest(SeeAlldata =true)
Private class ApexJobsMonitorTest {


static testmethod void  testschedule(){

Test.StartTest();

ApexJobsMonitor ajm = new ApexJobsMonitor();

 String sch = '0  00 1 3 * ?';
 system.schedule('Test', sch, ajm);
 
Test.StopTest();
}

}