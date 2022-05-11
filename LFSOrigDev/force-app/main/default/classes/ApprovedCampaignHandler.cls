/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: Class that will trigger methods (invoking other classes) depending on Opportunity's Campaign Eligibility
Test Class: ApprovedCampaignHandlerTest
History
11/19/14        Michael Lasala      Created
------------------------------------------------------------*/
global with sharing class ApprovedCampaignHandler{

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Method that will invoke class depending on Opportunity's Campaign Eligibility
    Inputs: Process Name, Opportunity Id
    Returns: Application Id
    History
    11/19/14        Michael Lasala      Created
    ------------------------------------------------------------*/
    webservice static String campaignProcess(String processName, Id recordId){
        String applicationId = '';

        if(recordId != null){

            //Build query string
            String query = 'SELECT ';
			
            //Add fields from field set
            for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.Opportunity_Commons.getFields()) {
                query += f.getFieldPath() + ',';
            }

			query += 'Campaign.Promotional_Campaign__c,';
		
            //Trim last comma
            query = query.subString(0, query.length() - 1);

            //Build object source and filter recordId parameter
            query += ' FROM Opportunity WHERE Id =: recordId';
            
            //Retrieve record
            Opportunity eligibleOpportunity = Database.query(query);
            
            //Retrieve custom setting based on processName parameter 
            Approved_Campaign_Classes__c approvedCampaignSetting = Approved_Campaign_Classes__c.getInstance(processName);

            if(approvedCampaignSetting != null){
                //Retrieve type based on custom setting class name field
                Type classType = Type.forName(approvedCampaignSetting.Class_Name__c);

                //Instantiate interface
                ApprovedCampaignInterface campaignProcess = (ApprovedCampaignInterface)classType.newInstance();

                //Invoke method using interface
                applicationId = campaignProcess.createApplication(eligibleOpportunity);
            }
        }
        return applicationId;
    }
}