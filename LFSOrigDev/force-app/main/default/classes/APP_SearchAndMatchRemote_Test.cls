/*
Author: Adrian Recio Cloud Sherpas
Created Date: March 30, 2015
Description: Test class for APP_SearchAndMatchRemote Class
*/

@IsTest
public with sharing class APP_SearchAndMatchRemote_Test {
	static testMethod void testAPP_SearchAndMatchRemote_One(){
		
		// Create Test Application
		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        // Create Test Applicant Search 
        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;
        
        // Create Test Applicant
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        // Create Test Applicant 2
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

		// Create Test Applicant CLV - This call auto creates three applicant CLV
        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id, testApplicant.Id);
        insert testApplicantCLVList;

		test.startTest();
			ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
			// Init constructor
			APP_SearchAndMatchRemote appSearchAndMatchRemoteCntrl = new APP_SearchAndMatchRemote(standardCon);
			
			// Call remote action method
			system.assertEquals(3,APP_SearchAndMatchRemote.checkForResultsNonStreaming(testApplicantSearch.Id));
		test.stopTest();
	}
}