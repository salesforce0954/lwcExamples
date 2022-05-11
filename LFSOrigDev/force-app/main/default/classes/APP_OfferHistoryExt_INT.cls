/* @Description: Controller for Offer History page (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: 16-JUN-2016
 * @History:
   =====================================================================
       16-JUN-16: CREATED - MLASALA
   =====================================================================
 */ 
public with sharing class APP_OfferHistoryExt_INT {
    
    transient public List<Debug_Log__c> offerHistoryList {get;set;}
    public Id applicationId;

    public APP_OfferHistoryExt_INT (ApexPages.StandardController applicationController){
        applicationId = applicationController.getRecord().Id;
    }

    /* Description: Populates list of Offer History from Debug_Log__c object
    *  Author: Mike Lasala
    *  Date Created: 16-JUN-16
    *  Input Parameters: None
    *  Return: Void
    */
    public void refresh(){     
    
        offerHistoryList = new List<Debug_Log__c>();
        
        //Retrieve offer debug logs records related to application
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Debug_Log__c.FieldSets.Debug_Log_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        
        String offerName = 'Upsell';
        
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Debug_Log__c WHERE Application__c =: applicationId AND Name =: offerName '
                +'ORDER BY CreatedDate ASC';

        offerHistoryList = Database.query(query);
    }
}