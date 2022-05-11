/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description 
*/

@isTest
public with sharing class ScheduleBIcbsDeleteBatchTest {

	/**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 13 March 2013 
	* @description Test Method to schedule mass delete of Billing ICBS Records
	*/
	public static testMethod void testschedule() {
		// Create test Account
		List<Account>accVar = testDataBuilder.createAccounts(1);
		insert accVar;
		// Create test Billing Icbs Records
		List<Billing_ICBS__c>bIcbsList = testDataBuilder.createBIcbs(1, accVar[0].Id);
		insert bIcbsList;
		
	    Test.StartTest();
	
	        ScheduleBIcbsDeleteBatch sh1 = new ScheduleBIcbsDeleteBatch();
	        String sch = '0 0 23 * * ?';
	        system.schedule('Billing ICBS Mass Delete', sch, sh1);
	            
	    Test.stopTest();
    	
    	System.assert(!accVar.isEmpty());
    	System.assert(!bIcbsList.isEmpty());
    }// End testschedule
}