/* @Description: Called from Process Builder "Veda Quote Lead De-duping"
*  @Author 	   : Russell Cadapan
*  @Date       : 30-AUG-2016
*  @History	   :
=========================================================================================================
	30-AUG-2016 : Created - Russell Cadapan
=========================================================================================================
*/
public class VedaDedupeController {
    @InvocableMethod     
    public static void findAndUpdateOpportunities(List<String> oppExternalIds){
        if(oppExternalIds != null){
            if(!oppExternalIds.isEmpty()){
                // get all open leads with the unique id of the applications inserted
                List<Opportunity> vedaOpportunities = new List<Opportunity>();
                
                vedaOpportunities = [SELECT Id,
                                            StageName,
                                            X3rd_Party_Lead_Source__c,
                                            X3rd_Party_Lead_Number__c
                                    FROM    Opportunity
                                    WHERE   X3rd_Party_Lead_Number__c IN: oppExternalIds
                                    AND     X3rd_Party_Lead_Number__c != null
                                    AND     X3rd_Party_Lead_Number__c != ''
                                    AND     StageName In ('New', 'Customer Not Available', 'No Answer','Cancel', 'Left Message')
                                    AND     X3rd_Party_Lead_Source__c =: GEN_OriginationsConstants.MIRROR_VEDA_QUOTE];
                
                // for each lead, update the stage name to 'Unsuitable Lead' that indicates that the lead should not be processed
                if(!vedaOpportunities.isEmpty()){
                    for(Opportunity o: vedaOpportunities){
                        o.StageName = 'Unsuitable Lead';
                    }
                    update vedaOpportunities;
                }
            }
        }
    }
}