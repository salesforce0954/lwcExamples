/*
Author: August Del Rosario Cloud Sherpas
Created Date: January 21, 2014
Description: Test Coverage for APP_Credit_File_Check_EXT_INT
*/

@isTest
private class APP_Credit_File_Check_EXT_INT_Test {
	
	@isTest static void creditFileCheckMethod() {

		//create application
		Application__c testApplication = TestDataBuilder.createApplication();
		testApplication.Response_Code__c ='Test';
		insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		//create applicant
		Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.id);
		insert testApplicant;

		Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,testApplication.Response_code__c);
        insert testResponseCodeCtrl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

		//Create credit file check
		List<Credit_File_Check__c> testCreditFileCheckList = new List<Credit_File_Check__c>();
		Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFileCheck(testApplicant.id,testApplication.id);
		testCreditFileCheckList.add(testCreditFileCheck);
		insert testCreditFileCheckList;
		
		Test.startTest();
			ApexPages.StandardController creditFileCheck = new ApexPages.StandardController(testApplication);
			APP_Credit_File_Check_EXT_INT appCreditFileCheck = new APP_Credit_File_Check_EXT_INT(creditFileCheck);
			appCreditFileCheck.cfcList = testCreditFileCheckList;
			appCreditFileCheck.refreshCFCList();
		Test.stopTest();

		System.assert(!appCreditFileCheck.cfcList.isEmpty());

	}

	@isTest static void creditFileCheckMethodListNull() {

		//create application
		Application__c testApplication = TestDataBuilder.createApplication();
		testApplication.Response_Code__c ='Test';
		insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		//create applicant
		Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.id);
		insert testApplicant;

		Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,testApplication.Response_code__c);
        insert testResponseCodeCtrl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        List<Credit_File_Check__c> testCreditFileCheckList = new List<Credit_File_Check__c>();
		Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFileCheck(testApplicant.id,testApplication.id);
		testCreditFileCheckList.add(testCreditFileCheck);
		insert testCreditFileCheckList;

		Test.startTest();
			ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);
			ApexPages.StandardController creditFileCheck = new ApexPages.StandardController(testApplication);
			APP_Credit_File_Check_EXT_INT appCreditFileCheck = new APP_Credit_File_Check_EXT_INT(creditFileCheck);
		Test.stopTest();

		System.assert(!appCreditFileCheck.cfcList.isEmpty());
	}

	
}