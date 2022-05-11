/**
* @author Original: Andre Calimlim Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

@isTest
public without sharing class SchedulePropensityRunTest{

   public static testMethod void testschedule() {

	List<Account>accList = testDataBuilder.createAccounts(1);
	insert accList;
	List<Opportunity>oppList = testDataBuilder.createOpportunities(100, accList[0].Id);
	insert oppList;
	
    Test.StartTest();
    SchedulePropensityRun sh1 = new SchedulePropensityRun();
            String sch = '0 0 23 * * ?';
            system.schedule('Test Territory Check', sch, sh1);
    Test.stopTest();
    
    System.assert(!accList.isEmpty());
    System.assert(!oppList.isEmpty());
    }
}