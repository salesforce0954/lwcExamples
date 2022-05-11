/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 18 Feb 2013 
* @description Test Class for RecentCampaignController Class
*/

@isTest
private class RecentCampaignControllerTest{
	
    static testMethod void TestRecentCampaignPage(){
    	
    	// Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(1);
        insert campaignList;
        
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(2);
        insert accList;
        
        // Create Test Opportunity which is currently inplay for the pfr
        List<Opportunity>oppVar = TestDataBuilder.createOpportunities(1, accList[0].Id);
        oppVar[0].CampaignId = campaignList[0].Id;
        insert oppVar;
        
        ApexPages.currentPage().getParameters().put('oppid',oppVar[0].Id);
        
        test.startTest();
         	RecentCampaignController recentCampCntrl = new RecentCampaignController();
         	recentCampCntrl.getRecentCampaign();
        test.StopTest();

        System.assert(!campaignList.isEmpty());
    }// End TestRecentCampaignPage Method
}// End RecentCampaignControllerTest Class