@isTest
public class HomeControllerTest{
    static testMethod void case1(){
       List<Account> testAccount = new List<Account>();
       List<Campaign> testCampaign = new List<Campaign>();
       List<Task> testTask = new List<Task>();
       
       testAccount.addAll(TestDataBuilder.createAccounts(1));
       testCampaign.addAll(TestDataBuilder.createCampaign(1));
       //insert Opportunity
       Opportunity opportunity = new Opportunity();
       for(Account a: testAccount){
           for(Campaign c: testCampaign){
                    
                opportunity.Name = 'Test Opportunity';
                opportunity.AccountId = a.Id;
                opportunity.StageName = 'Test Stage';
                opportunity.Branch_Name__c = 'Test Branch Name';
                opportunity.Branch_ID__c = 'Test Branch ID';
                opportunity.Branch_Suburb__c = 'Test Suburb';
                opportunity.Branch_Postcode__c = 'Test Post';
                opportunity.Propensity_Score__c = 1;
                opportunity.CampaignId = c.Id;
                opportunity.CloseDate = System.today();
                opportunity.Assigned_to_User__c = UserInfo.getUserId();
                opportunity.OwnerId = UserInfo.getUserId();
                opportunity.Stagename = 'Disconnected';
				opportunity.call_type__c = 'Inbound Call';
                insert opportunity;
                     
                Opportunity currentOpportunity = [SELECT ID,Name FROM Opportunity WHERE Id =: opportunity.Id];
                system.assertEquals(opportunity.Id,currentOpportunity.Id);
            }
        }     

        //insert Task
        Task task = new Task();
        task.WhatId = opportunity.Id;
        task.OwnerId = opportunity.Owner.Id;
        task.Subject = opportunity.Call_Type__c;
        task.Call_Outcome__c = opportunity.StageName;
        task.Status = 'Completed';
        task.OwnerId = UserInfo.getUserId();
        task.ActivityDate = Date.today();
        //task.ReminderDateTime = Date.today();
        insert task;
        
        HomeComponentController HCC = new HomeComponentController();
    }
    static testMethod void case2(){
       List<Account> testAccount = new List<Account>();
       List<Campaign> testCampaign = new List<Campaign>();
       List<Task> testTask = new List<Task>();
       
       testAccount.addAll(TestDataBuilder.createAccounts(1));
       testCampaign.addAll(TestDataBuilder.createCampaign(1));
       //insert Opportunity
       Opportunity opportunity = new Opportunity();
       for(Account a: testAccount){
           for(Campaign c: testCampaign){
                    
                opportunity.Name = 'Test Opportunity';
                opportunity.AccountId = a.Id;
                opportunity.StageName = 'Test Stage';
                opportunity.Branch_Name__c = 'Test Branch Name';
                opportunity.Branch_ID__c = 'Test Branch ID';
                opportunity.Branch_Suburb__c = 'Test Suburb';
                opportunity.Branch_Postcode__c = 'Test Post';
                opportunity.Propensity_Score__c = 1;
                opportunity.CampaignId = c.Id;
                opportunity.CloseDate = System.today();
                opportunity.Assigned_to_User__c = UserInfo.getUserId();
                opportunity.OwnerId = UserInfo.getUserId();
                opportunity.Stagename = 'Set Follow-Up Call';
                insert opportunity;
                     
                Opportunity currentOpportunity = [SELECT ID,Name FROM Opportunity WHERE Id =: opportunity.Id];
                system.assertEquals(opportunity.Id,currentOpportunity.Id);
            }
        }     
        
        //insert Task
        Task task = new Task();
        task.WhatId = opportunity.Id;
        task.OwnerId = opportunity.Owner.Id;
        task.Subject = opportunity.Call_Type__c;
        task.Call_Outcome__c = opportunity.StageName;
        task.Status = 'In Progress';
		task.subject = 'Call';
        task.OwnerId = UserInfo.getUserId();
        task.ActivityDate = Date.today();
        task.ReminderDateTime = Date.today();
        insert task;
        
        HomeComponentController HCC = new HomeComponentController();
    }
}