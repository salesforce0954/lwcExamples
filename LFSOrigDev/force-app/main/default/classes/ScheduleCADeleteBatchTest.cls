/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

@isTest
public without sharing class ScheduleCADeleteBatchTest {
	
	/**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 05 Feb 2013 
	* @description Test Method to schedule mass delete of campaign assignments
	*/
	public static testMethod void testschedule() {
	
		// Create test campaign assignment 
		
		List<Campaign>campList = testDataBuilder.createCampaign(100);
		insert campList;
		List<Campaign_Assignment__c>campAssList = testDataBuilder.createCampaignAssignment(100, campList, UserInfo.getUserId());
		insert campAssList;
		
	    Test.StartTest();
	
	    	Datetime currentDateTime = system.now();
	        ScheduleCADeleteBatch sh1 = new ScheduleCADeleteBatch();
	        String sch = '0 0 23 * * ?';
	        system.schedule('CA Mass Delete', sch, sh1);
	            
	    Test.stopTest();
    	
    	System.assert(!campList.isEmpty());
    	System.assert(!campAssList.isEmpty());
    }// End testschedule
}// End ScheduleCADeleteBatchTest