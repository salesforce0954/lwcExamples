/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 6 March 2013 
* @description Test Class for LeadManagementController Class
*/

@isTest
public without sharing class ExclusionLogicControllerTest {
    
    /**
	* @author Original: Adrian Recio Cloud Sherpas
	* @date Original: 6 March 2013 
	* @description test Method for OpportunityExclusion Method
	*/
    static testMethod void OpportunityExclusionTest() {
    	// Set Pfr Settings
    	
    	// Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(1);
        insert campaignList;
               
    	// Create Test Branch
        List<Branch__c>branchList = TestDataBuilder.createBranch(1);
        insert branchList;
		
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(2);
        insert accList;
        	
		List<Opportunity>queueOpp = TestDataBuilder.createOpportunities(3, accList[0].Id);
		
		// Create Test Opportunity that is valid to queue and is currently not inplay
        queueOpp[0].CampaignId = campaignList[0].Id;
        queueOpp[0].Branch_Name__c = branchList[0].Name;
        queueOpp[0].InPlay__c = false;
        queueOpp[0].Time_Out__c = null;
        queueOpp[0].StageName = 'New';
        queueOpp[0].PostCode_Exclusion__c = false;
        queueOpp[0].Mail_Code__c = '';
        queueOpp[0].Excluded_Date__c = null;
        
        // Create Test Opportunity that is valid to queue but fails to satisfy exclusion conditions (Post Code, Mail Only MO)
        queueOpp[1].AccountId = accList[1].Id;
        queueOpp[1].CampaignId = campaignList[0].Id;
        queueOpp[1].Branch_Name__c = branchList[0].Name;
        queueOpp[1].InPlay__c = false;
        queueOpp[1].Time_Out__c = null;
        queueOpp[1].StageName = 'New';
        queueOpp[1].PostCode_Exclusion__c = true;
        queueOpp[1].Mail_Code__c = 'MO';
        queueOpp[1].Excluded_Date__c = null;
        
        // Create Test Opportunity that is valid to queue but fails to satisfy exclusion conditions (Mail Only CO)
        queueOpp[2].AccountId = accList[1].Id;
        queueOpp[2].CampaignId = campaignList[0].Id;
        queueOpp[2].Branch_Name__c = branchList[0].Name;
        queueOpp[2].InPlay__c = false;
        queueOpp[2].Time_Out__c = null;
        queueOpp[2].StageName = 'New';
        queueOpp[2].PostCode_Exclusion__c = true;
        queueOpp[2].Mail_Code__c = 'CO';
        queueOpp[2].Excluded_Date__c = null;
        insert queueOpp;
        
        // Create Billing Vision and Genesis records for DNS and Delinquency Exclusion
        
        List<Billing_Vision_Plus__c> billVisionDNS = TestDataBuilder.createBVision(1, accList[1].Id);
        billVisionDNS[0].CLV_DNS_flag__c='Y';
        insert billVisionDNS;
        
        List<Billing_Genesis__c> billGenesisDeli = TestDataBuilder.createBGenesis(1, accList[1].Id);
        billGenesisDeli[0].Delinquency_arrers_category__c = 'A';
        insert billGenesisDeli;
        
        // Create Billing Vision, Genesis and ICBS records for Block Code Exclusion
        
        List<Billing_Vision_Plus__c> billVisionBC = TestDataBuilder.createBVision(1, accList[1].Id);
		billVisionBC[0].Suspect_Address__c ='Y';
        insert billVisionBC;
        
        List<Billing_Genesis__c> billGenesisBC = TestDataBuilder.createBGenesis(1, accList[1].Id);
		billGenesisBC[0].Account_Status_Risk_Category__c = 'X';
        insert billGenesisBC;
        
        List<Billing_ICBS__c> billIcbsBC = TestDataBuilder.createBIcbs(1, accList[1].Id);
        billIcbsBC[0].Account_Status_Risk_Code__c = 'A';
        insert billIcbsBC;

        test.startTest();
        
        ExclusionLogicController elCntrl = new ExclusionLogicController();
        elCntrl.OpportunityExclusion(queueOpp);
        
        test.stopTest();

        System.assert(!queueOpp.isEmpty());
    }// End OpportunityExclusionTest Method  
}// End ExclusionLogicControllerTest Class