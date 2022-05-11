/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description 
*/

@isTest
public with sharing class ScheduleBVisionPlusDeleteBatchTest {

	/**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 13 March 2013 
	* @description Test Method to schedule mass delete of Billing Vision Plus Records
	*/
	public static testMethod void testschedule() {
		// Create test Account
		List<Account>accVar = testDataBuilder.createAccounts(1);
		insert accVar;
		// Create test Billing Vision Plus Records
		List<Billing_Vision_Plus__c>bVisionList = testDataBuilder.createBVision(1, accVar[0].Id);
		insert bVisionList;
		
	    Test.StartTest();
	
	        ScheduleBVisionPlusDeleteBatch sh1 = new ScheduleBVisionPlusDeleteBatch();
	        String sch = '0 0 23 * * ?';
	        system.schedule('Billing Vision Plus Mass Delete', sch, sh1);
	            
	    Test.stopTest();
    	
    	System.assert(!accVar.isEmpty());
    	System.assert(!bVisionList.isEmpty());
    }// End testschedule
}