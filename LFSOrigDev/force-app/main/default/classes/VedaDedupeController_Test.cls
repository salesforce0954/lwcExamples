@isTest
private class VedaDedupeController_Test {
    private static testMethod void findAndUpdateLeads_Test(){
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
        queueOpp[0].X3rd_Party_Lead_Source__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
        queueOpp[0].X3rd_Party_Lead_Number__c = 'TEST00001';
        
        insert queueOpp;

        Test.startTest();

        VedaDedupeController.findAndUpdateOpportunities(new List<String>{queueOpp[0].X3rd_Party_Lead_Number__c});

        Test.stopTest();

        List<Opportunity> updatedOpp = [SELECT StageName FROM Opportunity WHERE Id =: queueOpp[0].Id];
        System.assertEquals('Unsuitable Lead', updatedOpp[0].StageName);
    }
}