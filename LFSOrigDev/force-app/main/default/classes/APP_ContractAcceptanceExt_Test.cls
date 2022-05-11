/*
    Author: Adrian Recio Cloud Sherpas
    Created Date: 18/04/2014
    Description: Test Class for APP_ContractAcceptanceExt
    */
@isTest
private class APP_ContractAcceptanceExt_Test {
 
 	public static testmethod void testClass(){
		// Create Test Person Account
		List<Account> accList = testDataBuilder.createPersonAccounts(1);
		accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accList;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
		
		// Create Test Application
		Application__c appVar = testDataBuilder.createApplication();
		insert appVar;
		
		// Create Applicant 1
		Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
		appliVar1.Is_Primary_Applicant__c = true;
		insert appliVar1;
		
		// Create Requested Document
		Requested_Document__c rdVar = new Requested_Document__c(Application__c = appVar.Id);
		insert rdVar;
   		
   		// Create application response		
   		List<Application_Response__c> listApplicationResponseTest = new List<Application_Response__c>();

        for(Integer i = 0; i < 0; i++){
        	Application_Response__c arVar = TestDataBuilder.createApplicationResponse(appVar.Id);
        	arVar.Response_Code__c = 'PCO';
            listApplicationResponseTest.add(arVar);
        }

        insert listApplicationResponseTest;
   		
		test.startTest();
			//  Satisfy not joint condition
			ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
			APP_ContractAcceptanceExt cAcceptCntrl = new APP_ContractAcceptanceExt(standardCon);
			
			// Create response code custom setting
	   		Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'PCO');
	   		insert rccVar;
	   		
	   		cAcceptCntrl = new APP_ContractAcceptanceExt(standardCon);
   			
   			PageReference postSubmit = new PageReference('/apex/app_main_postsubmit?Id=' + appVar.Id);
			cAcceptCntrl.application.Response_Code__c = null;
			cAcceptCntrl.application.Status__c = null;
			cAcceptCntrl.application.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_SUCCESS;
			system.assertEquals(postSubmit.getUrl(), cAcceptCntrl.validatePostSubmit().getUrl());
			
			pageReference pgRef = Page.APP_Complete;
	   		pgRef.getParameters().put('Id',appVar.Id);
	   		pgRef.setRedirect(true);
			cAcceptCntrl.application.Response_Code__c = 'FIA';
			system.assertEquals(pgRef.getUrl(),cAcceptCntrl.validatePostSubmit().getUrl());
			
			pgRef = Page.APP_Main;
	   		pgRef.getParameters().put('Id',appVar.Id);
	   		pgRef.setRedirect(true);
			cAcceptCntrl.application.Response_Code__c = null;
			cAcceptCntrl.application.Status__c = 'New';
			system.assertEquals(pgRef.getUrl(),cAcceptCntrl.validatePostSubmit().getUrl());
			
			pgRef = Page.APP_Main_PostSubmit;
	   		pgRef.getParameters().put('Id',appVar.Id);
	   		pgRef.setRedirect(true);
			cAcceptCntrl.application.Response_Code__c = 'PIO';
			cAcceptCntrl.application.Status__c = 'Submitted';
			cAcceptCntrl.application.Acceptance_Channel__c = null;
			system.assertEquals(pgRef.getUrl(),cAcceptCntrl.validatePostSubmit().getUrl());
		test.stopTest();
		
	}
}