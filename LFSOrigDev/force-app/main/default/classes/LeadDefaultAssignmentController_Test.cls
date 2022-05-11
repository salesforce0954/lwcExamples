@isTest
private class LeadDefaultAssignmentController_Test {

	private static testMethod void assignLeadDefaults_Test() {
	    Debug_Settings__c debugSettings = new Debug_Settings__c();
        debugSettings.name = 'Production';
        debugSettings.debug__c = true;
        
        insert debugSettings;
        
        // Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(3);
        campaignList[0].Name = GEN_OriginationsConstants.VEDA_CAMPAIGN_NAME;
        campaignList[1].Name = GEN_OriginationsConstants.PICSTARTER_COMPLETED_LEADS_CAMPAIGN;
        campaignList[2].Name = GEN_OriginationsConstants.PICSTARTER_INCOMPLETE_LEADS_CAMPAIGN;
        insert campaignList;
        
        // Create Test Campaign Assignment for Pfr
        List<Campaign_Assignment__c> caList = TestDataBuilder.createCampaignAssignment(3, campaignList, userInfo.getUserId());
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
        
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(2);
        insert accList;
        
        List<Opportunity> externalPartyOppList = new List<Opportunity>();
        
        List<Opportunity> queueOpp = TestDataBuilder.createOpportunities(3, accList[0].Id);
        
        for(Opportunity o: queueOpp){
            // Create Test Opportunity that is valid to queue and is currently not inplay
            o.CampaignId = campaignList[0].Id;
            o.Branch_Name__c = branchList[0].Name;
            o.InPlay__c = false;
            o.Time_Out__c = null;
            o.StageName = 'New';
            o.PostCode_Exclusion__c = false;
            o.Mail_Code__c = '';
            o.Excluded_Date__c = null;
            externalPartyOppList.add(o);
        }
        
        externalPartyOppList[0].X3rd_Party_Lead_Source__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
        externalPartyOppList[1].X3rd_Party_Lead_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER;
        externalPartyOppList[2].X3rd_Party_Lead_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER;
        
        externalPartyOppList[1].X3rd_Party_Lead_Status__c = 'Complete';
        externalPartyOppList[2].X3rd_Party_Lead_Status__c = 'Incomplete';
        
        insert externalPartyOppList;
        
        List<Id> oppIds = new List<Id>();
        for(Opportunity o: externalPartyOppList){
            oppIds.add(o.Id);
        }

        Test.StartTest();
            LeadDefaultAssignmentController.assignLeadDefaults(oppIds);
        Test.StopTest();

        List<Opportunity> updatedOpps = new List<Opportunity>();
        updatedOpps = [SELECT Id, CampaignId FROM Opportunity WHERE Id IN: oppIds];

        for(Opportunity o: updatedOpps){
            System.assertNotEquals(null, o.CampaignId);
        }
	}

}