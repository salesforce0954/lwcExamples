/* @Description: Called from Process Builder "LeadDefaultAssignment"
*  @Author 	   : Russell Cadapan
*  @Date       : 30-AUG-2016
*  @History	   :
=========================================================================================================
	30-AUG-2016 : Created - Russell Cadapan
=========================================================================================================
*/
public class LeadDefaultAssignmentController {
    @InvocableMethod     
    public static void assignLeadDefaults(List<Id> opportunityIds){
        
        // get all the inserted leads
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities = [SELECT Id, StageName, CampaignId, Promotional_Campaign__c, X3rd_Party_Lead_Source__c, X3rd_Party_Lead_Status__c FROM Opportunity WHERE Id IN: opportunityIds];
        
        // get all campaigns for 3rd party leads
        List<Campaign> campaignList = [SELECT Id, Name FROM Campaign WHERE (Name =: GEN_OriginationsConstants.VEDA_CAMPAIGN_NAME OR Name = :GEN_OriginationsConstants.PICSTARTER_COMPLETED_LEADS_CAMPAIGN OR Name = :GEN_OriginationsConstants.PICSTARTER_INCOMPLETE_LEADS_CAMPAIGN) and isActive = true];
    
        // put all campaign in a map
        Map<String, Campaign> campaignMap = new Map<String, Campaign>();
        for(Campaign c :campaignList){
            if(!campaignMap.containsKey(c.Name)){
                campaignMap.put(c.Name, c);
            }
        }
        
        // for each lead, assign the default primary campaign depending on the lead source and lead status for each source
        for(Opportunity o: opportunities){
            if(o.X3rd_Party_Lead_Source__c == GEN_OriginationsConstants.MIRROR_VEDA_QUOTE && campaignMap.containsKey(GEN_OriginationsConstants.VEDA_CAMPAIGN_NAME)){
                o.CampaignId = campaignMap.get(GEN_OriginationsConstants.VEDA_CAMPAIGN_NAME).Id;
                o.Promotional_Campaign__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
            }else if(o.X3rd_Party_Lead_Source__c == GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER){
                if(o.X3rd_Party_Lead_Status__c == 'Complete' && campaignMap.containsKey(GEN_OriginationsConstants.PICSTARTER_COMPLETED_LEADS_CAMPAIGN)){
                    o.CampaignId = campaignMap.get(GEN_OriginationsConstants.PICSTARTER_COMPLETED_LEADS_CAMPAIGN ).Id;
                }else if(o.X3rd_Party_Lead_Status__c == 'Incomplete' && campaignMap.containsKey(GEN_OriginationsConstants.PICSTARTER_INCOMPLETE_LEADS_CAMPAIGN)){
                    o.CampaignId = campaignMap.get(GEN_OriginationsConstants.PICSTARTER_INCOMPLETE_LEADS_CAMPAIGN ).Id;
                }
            }
        }
        
        update opportunities;

    }
}