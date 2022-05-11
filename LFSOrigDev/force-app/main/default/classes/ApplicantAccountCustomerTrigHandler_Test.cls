/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 24, 2014
Description: Test class for ApplicantAccountCustomerTriggerHandler 
*/
@isTest
private class ApplicantAccountCustomerTrigHandler_Test {
	

	@isTest static void testUpdateSelectedICBS() {
		//Insert Application
		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;

		//Insert Applicant 
		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		testApplicant.Application__c = testApplication.Id;
		insert testApplicant;

		//InsertApplicantSearch
		Applicant_Search__c testAppSearch = TestDataBuilder.appSearch();
		insert testAppSearch;

		//Insert Applicant CLV
		List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearch.Id,testApplicant.Id);
		testApplicantCLVList[0].Applicant__c = testApplicant.Id;
		insert testApplicantCLVList;

		//Insert Applicant Account
		Applicant_Account__c testAppAcc = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
		testAppAcc.Applicant_CLV__c = testApplicantCLVList[0].Id;
		insert testAppAcc;

		//Insert Applicant Account Involved Party
		Applicant_Account_Involved_Party__c testAppAccInvolvedParty = TestDataBuilder.createApplicantAccountInvolvedParty(testAppAcc.Id);
		testAppAccInvolvedParty.Applicant_Account__c = testAppAcc.Id;
		insert testAppAccInvolvedParty;

		/*Insert Applicant Account Customer*/
		Applicant_Account_Customer__c testAppAccCust = TestDataBuilder.createApplicantAccountCustomer(testApplicant.Id);
		testAppAccCust.Applicant__c = testApplicant.Id;
		
		Test.startTest();
			insert testAppAccCust;
		Test.stopTest();

		System.assertEquals(testApplication.Id, testApplicant.Application__c);
		System.assertEquals(testApplicant.Id, testApplicantCLVList.get(0).Applicant__c);
		System.assertEquals(testApplicantCLVList.get(0).Id, testAppAcc.Applicant_CLV__c);
		System.assertEquals(testAppAcc.Id, testAppAccInvolvedParty.Applicant_Account__c);
		System.assertEquals(testApplicant.Id, testAppAccCust.Applicant__c);
	}
}