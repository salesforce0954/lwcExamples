@isTest
/*
Author: Cloud Sherpas
Created Date: 
Description: Test Coverage for TaskComponentController

History:	March 10, 2014		Mat Isidro		Modified test class to improve coverage from 40% to 97% 
*/
private class OpportunitySetupControllerTest{
    	
	static testMethod void case1(){

		//Record Type
		RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'Business Account' LIMIT 1];

		//insert Account
		Account account = new Account();
		account.Name = 'Test Account';
		account.RecordTypeId = recordType.Id;
		insert account;
		                
		Account currentAccount = [SELECT Id,Name FROM Account WHERE Id=: account.Id];
		system.assertEquals(account.Id,currentAccount.Id);
		    
		//insert Contact
		Contact contact = new Contact();
		contact.LastName = 'Test Contact';
		contact.Account = account;
		contact.User__c = UserInfo.getUserId();
		insert contact;
		                
		//insert Lead
		                
		Lead lead = new Lead();
		lead.LastName = 'Outbound';
		lead.Company = 'Company';
		insert lead;
		                
		Lead currentLead = [SELECT Id,Name FROM Lead WHERE Id=: lead.Id];
		system.AssertEquals(lead.Id,currentLead.Id);
		                
		//insert campaign
		Campaign campaign = new Campaign();
		campaign.Name = 'Test Campaign';
		campaign.Campaign_ID__C = 'TEST00045';
		campaign.StartDate = Date.today();
		campaign.EndDate = Date.today();
		campaign.IsActive = true;
		campaign.Status = 'In Progress';
		insert campaign;
		                
		Campaign currentCampaign = [SELECT Id,Name FROM Campaign WHERE ID=: campaign.Id];
		system.assertEquals(campaign.Id, currentCampaign.Id);
		                
		//insert Opportunity
		Opportunity opportunity = new Opportunity();
		opportunity.Name = 'Test Opportunity';
		opportunity.Account = account;
		opportunity.StageName = 'No Answer';
		opportunity.Branch_Name__c = 'Test Branch Name';
		opportunity.Branch_ID__c = 'Test Branch ID';
		opportunity.Branch_Suburb__c = 'Test Suburb';
		opportunity.Branch_Postcode__c = 'Test Post';
		opportunity.Propensity_Score__c = 1; 
		opportunity.CampaignId = campaign.Id;
		opportunity.CloseDate = System.today();
		opportunity.Assigned_to_User__c = UserInfo.getUserId();
		opportunity.OwnerId = UserInfo.getUserId();
		insert opportunity;
		                
		Integer MAX = 100;
		List<Task> taskList = new List<Task>();
		for (Integer i = 0; i < MAX; i++) {
			//insert Task
			Task task = new Task();
			task.Subject = 'Call';
			task.ActivityDate = Date.today() + Math.round(i/2);
			task.WhatId = opportunity.Id;
			taskList.add(task);                
		}
		insert taskList;
		                
		Opportunity currentOpportunity = [SELECT ID,Name FROM Opportunity WHERE Id =: opportunity.Id];
		system.assertEquals(opportunity.Id,currentOpportunity.Id);
		                
		OpportunitySetupController osp = new OpportunitySetupController();
		system.assertEquals(true, osp.displayTable);
		system.assertEquals(false, osp.displayErrorMsg);
		system.assert(osp.tempList.size() > 0);
                
	}     
}