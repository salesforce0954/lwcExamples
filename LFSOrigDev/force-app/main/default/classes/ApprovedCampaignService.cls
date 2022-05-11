/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: Service for creating a shell Origination Application with Applicant for Opportunities with Conditionally Approved Campaign Eligibility
Test Class: ApprovedCampaignHandlerTest
History
11/19/14        Michael Lasala      Created
------------------------------------------------------------*/
public with sharing class ApprovedCampaignService implements ApprovedCampaignInterface{
    
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Create Originations Application with Applicant and copy the following fields into the Application from the Opportunity:
                 1. Initial Interest Rate
                 2. Promotional Campaign
                 3. Promo Loan Offer Amount
    Inputs: Opportunity Id
    Returns: Application Id
    History
    11/19/14        Michael Lasala      Created
    ------------------------------------------------------------*/
    public String createApplication(Opportunity eligibleOpportunity){
        String applicationId = '';

        if(eligibleOpportunity != null){

            //Instantiate records to be created
            Application__c newApplication = new Application__c();
            //Applicant__c newApplicant = new Applicant__c();
			
			system.debug('Opportunity PC:' + eligibleOpportunity.Campaign.Promotional_Campaign__c);
			
            //Map fields from Opportunity to Application
            newApplication.Status__c = 'New';
            newApplication.Response_Code__c = 'New';
            newApplication.Promotional_Campaign__c = eligibleOpportunity.Campaign.Promotional_Campaign__c;
            newApplication.Promo_Loan_Offer_Amount__c = eligibleOpportunity.Promo_Loan_Offer_Amount__c;
            //TODO: Replace corrects fields and mapping once fields are created on Opportunity
            //newApplication.Offered_Interest_Rate__c = eligibleOpportunity.;
            //newApplication.Offered_Interest_Rate_Orig__c = eligibleOpportunity.;

            //Insert Application
            try{
                insert newApplication;
                applicationId = newApplication.Id;
            } catch(DMLException e){
                //TODO: Proper error handling. Ask Fahad
                System.debug('$$$ newApplication DmlException: '+e);
            }

            //Set Application as parent and Primary Applicant = true
            /*
            newApplicant.Application__c = newApplication.Id;
            newApplicant.Is_Primary_Applicant__c = true;

            //Insert Applicant
            try{
                insert newApplicant;
            } catch(DMLException e){
                //TODO: Proper error handling. Ask Fahad
                System.debug('$$$ newApplicant DmlException: '+e);
            }
            */
        }
        return applicationId;
    }
}