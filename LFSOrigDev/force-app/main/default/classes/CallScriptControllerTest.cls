@isTest
/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 18 Feb 2013 
* @description Test class for CallScriptController Class
*/
public without sharing class CallScriptControllerTest {
  	static testMethod void testCallScriptPage(){

		// Create test account
		List<Account>accList = TestDataBuilder.createAccounts(1);
		insert accList;
		// Create test campaign
		List<Campaign>campList = TestDataBuilder.createCampaign(1);
		insert campList;
		
		// Create test opportunity
		List<Opportunity>oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
		oppList[0].CampaignId = campList[0].Id;
		oppList[0].Letter_Stream__c = 'Campaign1';
		insert oppList;
		
		system.debug('oppValue:' + oppList[0]);
		
		// Set oppId url parameter equal to test opportunities Id
		ApexPages.currentPage().getParameters().put('oppId',oppList[0].Id);
		
		// Create CallScriptController Class Instance
        CallScriptController csCntrl = new CallScriptController();
        
        // Test class methods
        Test.startTest();
        
     		csCntrl.setupCampaign();
     		csCntrl.getCampaignAttachments();
     		
     		// Set campVar to null to satisfy 
     		// negative condition in getCampaignAttachments
     		csCntrl.campVar = null;
     		csCntrl.getCampaignAttachments();
     		
        Test.stopTest();

        System.assertEquals(oppList.get(0).Id, csCntrl.oppVar.Id);
        System.assertEquals(campList.size(), csCntrl.campList.size());
    }// End testCallScriptPage
}// End CallScriptControllerTest