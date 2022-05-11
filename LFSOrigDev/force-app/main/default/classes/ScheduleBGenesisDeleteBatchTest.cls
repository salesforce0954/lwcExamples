/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description 
*/

@isTest
public with sharing class ScheduleBGenesisDeleteBatchTest {

	/**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 13 March 2013 
	* @description Test Method to schedule mass delete of Billing Genesis Records
	*/
	public static testMethod void testschedule() {
		// Create test Account
		List<Account>accVar = testDataBuilder.createAccounts(1);
		insert accVar;
		// Create test Billing Genesis Records
		List<Billing_Genesis__c>bGenesisList = testDataBuilder.createBGenesis(1, accVar[0].Id);
		insert bGenesisList;
		
	    Test.StartTest();
	
	        ScheduleBGenesisDeleteBatch sh1 = new ScheduleBGenesisDeleteBatch();
	        String sch = '0 0 23 * * ?';
	        system.schedule('Billing Genesis Mass Delete', sch, sh1);
	            
	    Test.stopTest();
    	
    	System.assert(!accVar.isEmpty());
    	System.assert(!bGenesisList.isEmpty());
    }// End testschedule
}