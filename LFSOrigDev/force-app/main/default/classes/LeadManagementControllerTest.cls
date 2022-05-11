/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 11 Feb 2013 
* @description Test Class for LeadManagementControll Class
*/

@isTest
public with sharing class LeadManagementControllerTest {
    
    static testMethod void myTest() {
        // Set Pfr Settings
        
        Debug_Settings__c debugSettings = new Debug_Settings__c();
        debugSettings.name = 'Production';
        debugSettings.debug__c = true;
        
        insert debugSettings;
        
        // Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(1);
        insert campaignList;
        
        // Create Test Campaign Assignment for Pfr
        List<Campaign_Assignment__c> caList = TestDataBuilder.createCampaignAssignment(1, campaignList, userInfo.getUserId());
        insert caList;
        
        // Create Test Branch
        List<Branch__c>branchList = TestDataBuilder.createBranch(1);
        insert branchList;
        
        // Create Test Branch Assignment of type Branch Leads for Pfr
        List<Branch_Assignment__c>blList = TestDataBuilder.createBranchAssignment(1, branchList, userInfo.getUserId(),'Branch Leads');
        insert blList;
        
        // Create Test Branch Assignment of type Working Location for Pfr
        List<Branch_Assignment__c>wlList = TestDataBuilder.createBranchAssignment(1, branchList, userInfo.getUserId(),'Working Location');
        insert wlList;


        // Create Test Lead
        
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(2);
        insert accList;
        
        // Create Test Opportunity which is currently inplay for the pfr
        List<Opportunity>inplayOpp = TestDataBuilder.createOpportunities(1, accList[0].Id);
        inPlayOpp[0].CampaignId = campaignList[0].Id;
        inPlayOpp[0].Branch_Name__c = branchList[0].Name;
        inPlayOpp[0].InPlay__c = true;
        inPlayOpp[0].Time_Out__c = null;
        inPlayOpp[0].StageName = 'New';
        inPlayOpp[0].PostCode_Exclusion__c = false;
        inPlayOpp[0].Mail_Code__c = '';
        inPlayOpp[0].Excluded_Date__c = null;
 
        insert inplayOpp;
    
        List<Opportunity>queueOpp = TestDataBuilder.createOpportunities(1, accList[0].Id);
        
        // Create Test Opportunity that is valid to queue and is currently not inplay
        queueOpp[0].CampaignId = campaignList[0].Id;
        queueOpp[0].Branch_Name__c = branchList[0].Name;
        queueOpp[0].InPlay__c = false;
        queueOpp[0].Time_Out__c = null;
        queueOpp[0].StageName = 'New';
        queueOpp[0].PostCode_Exclusion__c = false;
        queueOpp[0].Mail_Code__c = '';
        queueOpp[0].Excluded_Date__c = null;
        
        insert queueOpp;
        
        Admin_Settings__c vedaWindow = new Admin_Settings__c();
        vedaWindow.Name = GEN_OriginationsConstants.ADMIN_SETTING_VEDA_WINDOW;
        vedaWindow.Value__c = '2';
        insert vedaWindow;
        
        test.startTest();
        
        LeadManagementController lmController = new LeadManagementController();

        // Satisfy Condition with inplay opportunity
        lmController.allocateLeads();
        
        // Satisfy Condition for lead queue logic
        // Delete inplay opportunity to satisfy condition
        Delete inPlayOpp;
        lmController.allocateLeads();
                
        // Satisfy no valid lead condition
        delete queueOpp;
        
        lmController.allocateLeads();
        
        // Satisfy condition for no valid work location
        Delete wlList;
        lmController.allocateLeads();
        
        // Satisfy condition for no valid branch
        Delete blList;
        lmController.allocateLeads();
        
        // Satisfy condition for no valid campaigns
        Delete caList;
        lmController.allocateLeads();

        test.stopTest();

        System.assert(lmController.leadMissing);
    }
    
}// End LeadManagementControllerTest