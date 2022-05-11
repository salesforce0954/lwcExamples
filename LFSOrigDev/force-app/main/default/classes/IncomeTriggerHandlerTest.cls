/*
 *Author: Adrian Recio Cloud Sherpas
 *Created Date: February 19, 2014
 *Description: Test Class for IncomeTriggerHandler Class 
 */
 
 @IsTest
public with sharing class IncomeTriggerHandlerTest {
	public static testMethod void testIncomeCapacityTrigger(){
		
		// Instantiate IncomeTriggerHandler Class
		IncomeTriggerHandler iTrigHandler = new IncomeTriggerHandler();
		List<Income__c>inList = new List<Income__c>();
		Map<Id,Income__c>inMap = new Map<Id,Income__c>();
		
		// Create Test Person Account
		List<Account> accList = testDataBuilder.createPersonAccounts(1);
		accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accList;
		
		// Create Test Application
		Application__c appVar = testDataBuilder.createApplication();
		insert appVar;
		
		// Create Applicant
		Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		insert appliVar;
		
		test.startTest();
		
			// Test Income on insert
			// Create Test Income
			Income__c inVar = testDataBuilder.createIncome(appliVar.Id);
			insert inVar;
			
			Income__c inVar2 = testDataBuilder.createIncome(appliVar.Id);
			insert inVar2;
			
			// Assert that a single income capacity record is created for the newly inserted income
			// since insertIncomeCapacity method is called in after insert of income trigger
			
			Integer icCount = [Select count() from Income_Capacity__c where Income__c = :inVar.Id];
			system.assertEquals(1, icCount);
															
			// Test Income on update
			inVar.Income_Source__c = 'Self Employed';
			update inVar;
			
			// Pull updated capacity details							
			Income_Capacity__c icVarUpdate = [Select Id,Income__c, Employment_Type__c, Frequency_of_Payment__c, 
											  Method_of_Calculation__c, Method_of_Verification__c 
											  from Income_Capacity__c where Income__c = :inVar.Id limit 1];
			
			// Test Individual Class Methods
			inList.add(inVar);	// Create Test Income List	
			inMap.put(inVar.Id,inVar);	// Create Test Income Map	
			
			iTrigHandler.insertIncomeCapacity(inList);
			icCount = [Select count() from Income_Capacity__c where Income__c = :inVar.Id];
			system.assertEquals(2, icCount); // Assert that a second income capacity record is created 
			
			iTrigHandler.updateIncomeCapacity(inList, inMap);
			
			// Pull created income capacity details							
			Income_Capacity__c icVarInsert = [Select Id,Income__c, Employment_Type__c, Frequency_of_Payment__c, 
											  Method_of_Calculation__c, Method_of_Verification__c 
											  from Income_Capacity__c where Income__c = :inVar.Id limit 1];							  
			iTrigHandler.populateIncomeCapacity(inVar, icVarInsert, true);
			
			delete inVar;
		test.stopTest();
	}
	
	public static testMethod void testIncomeCapacityClone(){
		
		// Instantiate IncomeTriggerHandler Class
		IncomeTriggerHandler iTrigHandler = new IncomeTriggerHandler();
		List<Income__c>inList = new List<Income__c>();
		Map<Id,Income__c>inMap = new Map<Id,Income__c>();
		
		// Create Test Person Account
		List<Account> accList = testDataBuilder.createPersonAccounts(1);
		accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accList;
		
		// Create Test Application
		Application__c appVar = testDataBuilder.createApplication();
		insert appVar;
		
		// Create Applicant
		Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		insert appliVar;
		
		test.startTest();
		
			// Test Income on insert
			// Create Test Income
			Income__c inVar = testDataBuilder.createIncome(appliVar.Id);
			inVar.Years_With_Employer__c = 0;
			inVar.Months_With_Employer__c = 1;
			insert inVar;
						
			Integer icCount = [Select count() from Income_Capacity__c where Income__c = :inVar.Id];
			//system.assertEquals(2, icCount);
			system.assertEquals(1, icCount);
			/*iTrigHandler.insertIncomeCapacity(inList);
			icCount = [Select count() from Income_Capacity__c where Income__c = :inVar.Id];
			system.assertEquals(2, icCount); // Assert that a second income capacity record is created*/ 
		test.stopTest();
	}
}