/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: Interface used by Approved Campaign process for creation of Origination Application
Test Class:
History
11/19/14        Michael Lasala      Created
------------------------------------------------------------*/
global interface ApprovedCampaignInterface{

	/*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Method that will invoke class depending on Opportunity's Campaign Eligibility
    Inputs: Opportunity record
    Returns: Application Id
    History
    11/19/14        Michael Lasala      Created
    ------------------------------------------------------------*/
    String createApplication(Opportunity eligibleOpportunity);
}