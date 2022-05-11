/*
Author: Michael Lasala Cloud Sherpas
Created Date: 03/04/13
Description: Test Coverage for OpportunityRelatedListController Class
History:	Mat Isidro 		March 17, 2014		Created/Improved coverage	
*/
@isTest
private class OpportunityRelatedListControllerTest{

    static testMethod void TestCase1() {
        // Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(2);
        campaignList[0].IsActive = false;
        campaignList[1].IsActive = true;
        insert campaignList;
    
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(1);
        insert accList;
    
        List<Opportunity>queueOpp = TestDataBuilder.createOpportunities(3, accList[0].Id);
    
        // Create Test Opportunity that is currently inplay and campaign is inactive
        queueOpp[0].CampaignId = campaignList[0].Id;
        queueOpp[0].InPlay__c = true;
        queueOpp[0].Time_Out__c = null;
        queueOpp[0].StageName = 'New';
        queueOpp[0].PostCode_Exclusion__c = false;
        queueOpp[0].Mail_Code__c = '';
        queueOpp[0].Excluded_Date__c = null;
        queueOpp[0].OwnerId = UserInfo.getUserId();
        
        // Create Test Opportunity that is currently not inplay and campaign is active
        queueOpp[1].CampaignId = campaignList[1].Id;
        queueOpp[1].InPlay__c = false;
        queueOpp[1].Time_Out__c = null;
        queueOpp[1].StageName = 'New';
        queueOpp[1].PostCode_Exclusion__c = false;
        queueOpp[1].Mail_Code__c = '';
        queueOpp[1].Excluded_Date__c = null;
        queueOpp[1].OwnerId = UserInfo.getUserId();
        
        // Create Test Opportunity that is currently inplay at the same time campaign is active
        queueOpp[2].CampaignId = campaignList[1].Id;
        queueOpp[2].InPlay__c = true;
        queueOpp[2].Time_Out__c = null;
        queueOpp[2].StageName = 'New';
        queueOpp[2].PostCode_Exclusion__c = false;
        queueOpp[2].Mail_Code__c = '';
        queueOpp[2].Excluded_Date__c = null;
        queueOpp[2].OwnerId = UserInfo.getUserId();
        insert queueOpp;

	 	test.startTest();
	 	// Case 1
        ApexPages.StandardController stc = new ApexPages.StandardController(accList[0]);
        OpportunityRelatedListController orlc = new OpportunityRelatedListController(stc);

        orlc.getOpps();
        system.debug('@@@orlc: ' + orlc);
        test.stopTest();

        System.assertEquals(accList.get(0).Id, orlc.acc.Id);
	}

}