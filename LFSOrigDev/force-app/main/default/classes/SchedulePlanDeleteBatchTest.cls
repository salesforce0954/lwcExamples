/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

@isTest
public without sharing class SchedulePlanDeleteBatchTest {
	
	/**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 05 Feb 2013 
	* @description Test Method to schedule mass delete of plans
	*/
	public static testMethod void testschedule() {
		// Create Account
		List<Account>testAccount = testDataBuilder.createAccounts(1);
		insert testAccount;
	
		// Create Billing Vision Plus
		List<Billing_Vision_Plus__c>bVisionPlus = testDataBuilder.createBVision(1, testAccount[0].Id);
		insert bVisionPlus;
		
		// Create test plan
		List<Plans__c>planList = testDataBuilder.createPlans(100, bVisionPlus[0].Id);
		insert planList;
		
	    Test.StartTest();

	        SchedulePlanDeleteBatch sh1 = new SchedulePlanDeleteBatch();
	        String sch = '0 0 23 * * ?';
	        system.schedule('Plan Mass Delete', sch, sh1);
	            
	    Test.stopTest();
    
    }// End testschedule testMethod
    
}// End SchedulePlanDeleteBatchTest Class