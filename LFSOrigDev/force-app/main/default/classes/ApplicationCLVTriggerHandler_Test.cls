/*
Author: Mac Domingo Cloud Sherpas
Created Date: 12/5/13
Description: Test Coverage for Applicant Search Trigger
*/
@isTest
public class ApplicationCLVTriggerHandler_Test {
	/*
    Author: Mac Domingo Cloud Sherpas
    Created Date: 12/05/2013
    Description: Test Method to test update status field of applicant search
    */
	static testMethod void testUpdate() {

		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;
		
		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		insert testApplicant;

		Applicant_Search__c apSrch = TestDataBuilder.appSearch();
		insert apSrch;
		
		
		Test.startTest();
			List<Applicant_CLV__c> clvList = TestDataBuilder.applicantCLVList(apSrch.Id,testApplicant.Id);
			insert clvList;
		Test.stopTest();
		
		Set<Id> appSeId = new Set<Id>();

		for(Applicant_CLV__c a: clvList){
				appSeId.add(a.Applicant_Search__c);
		}
		
		List<Applicant_Search__c> updatedAppSe = [SELECT Id, Status__c FROM Applicant_Search__c where ID IN: appSeId];

		System.debug('###UpdatedAppSe: ' + updatedAppSe);

		for(Applicant_Search__c a: updatedAppSe){
			System.assertEquals(a.Status__c, 'Response Received');
		}

	}
}