/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 18 Feb 2013 
* @description Class to handle RecentCampaignPage Logic
*/

public with sharing class RecentCampaignController {
    
    
    // Method to populate recent campaigns
    public list<campaignWrapper> getRecentCampaign(){
        
        List<CampaignWrapper> cWrapList = new List<CampaignWrapper>();
        
        // Initialize variables
        String oppId = ApexPages.currentPage().getParameters().get('oppid');
        Opportunity oppReference;
        
        //get account id from current opportunity page
        for(Opportunity opp: [SELECT AccountId from Opportunity where Id =: oppId limit 1]) {
            oppReference = opp;
        }
        
        if(oppReference!=null) {
                // Query opportunity details where account Id is equal to current opportunity
            for(Opportunity opp: [SELECT Campaign.Id, Campaign.Name, 
                                                  Campaign.StartDate, Campaign.EndDate, StageName, LastModifiedDate 
                                  FROM Opportunity
                                  WHERE AccountId =: oppReference.accountId
                                  ORDER BY LastModifiedDate DESC
                                  LIMIT 15]){
                
                CampaignWrapper cWrap = new CampaignWrapper();
                cWrap.urlStr = '/' + opp.Campaign.Id;
                cWrap.oppVar = opp;
                cWrapList.add(cWrap);
            }// End For
        }// End If
        return cWrapList;
    }// End setRecentCampaign Method
    
    // Wrapper class for recent campaigns
    public class CampaignWrapper{
        public string urlStr{get; set;}
        public Opportunity oppVar{get; set;}   
    }// End campaignWrapper Class

}// End RecentCampaignController Class