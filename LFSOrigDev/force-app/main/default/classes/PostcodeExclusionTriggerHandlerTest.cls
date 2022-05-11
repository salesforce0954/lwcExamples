/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 11 Feb 2013 
* @description Test Class for PostcodeExclusionTriggerHandler Class
*/

@isTest
public with sharing class PostcodeExclusionTriggerHandlerTest {
	public static testMethod void testPostcodeExclusion(){
		
		List<Postcode_Exclusion__c>postExList = testDataBuilder.createPostcodes(1);
		
		List<Account>accList = testDataBuilder.createAccounts(1);
		insert accList;
		List<Opportunity>oppList = testDataBuilder.createOpportunities(2, accList[0].Id);
		oppList[0].Branch_Postcode__c = postExlist[0].Postcode__c;
		insert oppList;
		
		test.startTest();
		
		insert postExList;
		delete postExList;
		
		test.stopTest();

		System.assert(!oppList.get(0).PostCode_Exclusion__c);
	}
}