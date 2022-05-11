/* @Description: Test Class for APP_RequestedDocumentExt_INT
 * @Author: Adrian Recio
 * @Date Created: 12-03-2014
 * @History:
   =====================================================================
       14-03-14: Created - Adrian
       DEC-15-14(Devendra Babu) : Modified test class to add brand to application - DBHZL-95
   =====================================================================
 */ 
 @IsTest
public with sharing class APP_RequestedDocumentExt_INT_Test {

	public static testmethod void testClass(){
		
		// Create Test Person Account
		List<Account> accList = testDataBuilder.createPersonAccounts(1);
		accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accList;
		
		Brand__c brand= TestDataBuilder.createBrand();
		insert brand;
			
		// Create Test Application
		Application__c appVar = testDataBuilder.createApplication();
		appVar.Brand_Lookup__c=brand.id;
		insert appVar;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
		
		// Create related Primary Applicant 1
		Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		appliVar1.Is_Primary_Applicant__c = true;
		insert appliVar1;
		
		// Create related Applicant 2
		Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		insert appliVar2;
		
		// Create Test Requested Document
		//Requested_Document__c rdVar = TestDataBuilder.createRequestDoc(appVar.Id);
		//insert rdVar;
		test.startTest();
			// Instantiate Class for Testing
			ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
			APP_RequestedDocumentExt_INT cntrl = new APP_RequestedDocumentExt_INT(standardCon);
			
			// Add a new requested document
			cntrl.addMoreRequestDocument();
			// Assert that a new requested document is added in the main list
			system.assertEquals(1, cntrl.getRDCount());
			
			// Set index of requested document for remove
			cntrl.removeIndex = '0';
			// Remove current requested document
			cntrl.removeRequestedDocument();
			// Assert that there's no requested document
			system.assertEquals(0, cntrl.getRDCount());
			
			// Create and save requested document
			cntrl.addMoreRequestDocument();
			cntrl.wrapperRD[0].rd.Document_Type__c = 'Dealer Invoice';
			cntrl.wrapperRD[0].rd.Number_Required__c = '1';
			cntrl.saveToRequested();
			// Validate that requested document is created and saved
			// temporary remove
			/*system.assertEquals(1, [Select Id from Requested_Document__c 
									where Id = :cntrl.rdMainList[0].Id].size());*/
			
			// Update status to complete and set description
			cntrl.removeIndex = '0';
			//temporary remove
			//cntrl.completeDocument();
			cntrl.descriptionValue();
			
			// Validate that requested document status is set to complete
			// Temporary remove
			/*system.assertEquals('Complete', [Select Id, status__c from Requested_Document__c 
									where Id = :cntrl.rdMainList[0].Id].status__c);*/
			
			// Remove and delete requested document
			cntrl.removeIndex = '0'; 
			cntrl.removeRequestedDocument();
			cntrl.saveToRequested();
			// Validate that there's no requested document under current application
			system.assertEquals(0, [Select Id from Requested_Document__c 
									where Application__c = :cntrl.Application.Id].size());
			
			// Satisfy validation errors
			cntrl.addMoreRequestDocument();
			cntrl.saveToRequested();
			// Verify that save did not proceed by mean of Id field
			//system.assertEquals(null, cntrl.rdMainList[0].Id);
			system.assertEquals(null, cntrl.wrapperRD[0].rd.Id);

			// Reset
			cntrl.rdMainList = new List<Requested_Document__c>();
			
			// Satisfy null setter conditions
			system.assertEquals('', cntrl.nullSetter(null));
			system.assertEquals('not null', cntrl.nullSetter('not null'));
			
			// Satisfy applicant option method
			List<SelectOption> appliOptionList = cntrl.getJointApplicant();
			system.assertEquals(3,appliOptionList.size());
			
			// Satisfy applicant option method no name condition
			appliVar1.First_Name__c = null;
			appliVar1.Last_Name__c = null;
			
			update appliVar1;
			
			appliVar2.First_Name__c = null;
			appliVar2.Last_Name__c = null;
			
			update appliVar2;
			
			// Refresh controller
			cntrl = new APP_RequestedDocumentExt_INT(standardCon);
			
			appliOptionList = cntrl.getJointApplicant();
			
			// Satisfy visibility methods
			//cntrl.showEdit();
			//system.assertEquals(false, cntrl.showList);
			
			cntrl.redirectMain();
			//system.assertEquals(true,cntrl.showList);
			
			// Satisfy applicant count method
			//system.assertEquals(2,cntrl.getRDCount());
			
		test.stopTest();
	}

	public static testmethod void testClass2(){
		
		// Create Test Person Account
		List<Account> accList = testDataBuilder.createPersonAccounts(1);
		accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accList;
		
		// Create Test Application
		Application__c appVar = testDataBuilder.createApplication();
		insert appVar;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
		
		// Create related Primary Applicant 1
		Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		appliVar1.Is_Primary_Applicant__c = true;
		insert appliVar1;
		
		// Create related Applicant 2
		//Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		//insert appliVar2;
		
		// Create Test Requested Document
		//Requested_Document__c rdVar = TestDataBuilder.createRequestDoc(appVar.Id);
		//insert rdVar;
		
		test.startTest();
			// Instantiate Class for Testing
			ApexPages.CurrentPage().getParameters().put('requestedDocumentMode','Edit');
			ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
			APP_RequestedDocumentExt_INT cntrl = new APP_RequestedDocumentExt_INT(standardCon);
			cntrl.validateMode();
			cntrl.addMoreRequestDocument();
			cntrl.wrapperRD[0].rd.Document_Type__c = 'Dealer Invoice';
			cntrl.wrapperRD[0].rd.Document_Type__c = null;
			cntrl.wrapperRD[0].rd.Number_Required__c = '1';
			cntrl.removeIndex = '0';
			cntrl.showEdit();
			cntrl.refreshDescription();
		test.stopTest();

		system.assertEquals(1, cntrl.getRDCount());
		system.assertEquals(0, [Select Id from Requested_Document__c where Application__c = :cntrl.Application.Id].size());
		system.assertEquals(null, cntrl.wrapperRD[0].rd.Id);
		system.assertEquals('', cntrl.nullSetter(null));
		system.assertEquals('not null', cntrl.nullSetter('not null'));
	}
}