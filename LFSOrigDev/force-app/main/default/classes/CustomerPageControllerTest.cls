@isTest
public class CustomerPageControllerTest{
    static testMethod void case1(){
        //data variables
       List<Campaign> testCampaign = new List<Campaign>();
       List<Task> testTask = new List<Task>();
       Opportunity opportunity = new Opportunity();
       Task task = new Task();
       
       String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        //create account data
            Account testAccount = new Account(
              RecordTypeID=RecTypeId,
              FirstName='fname',
              LastName='lname',
              PersonMailingStreet='street',
              PersonMailingPostalCode='postal',
              PersonMailingCity='city',
              PersonEmail='testmail@yahoo.com',
              PersonHomePhone='homephone',
              PersonMobilePhone='mobilephone',
              PersonMailingState = 'state',
              PersonMailingCountry = 'country',
              CLV_Customer_Id__c = '14344');
            
            insert testAccount;
        //insert Campaign
        
        testCampaign.addAll(TestDatabuilder.createCampaign(1));
       //insert Opportunity
       
           for(Campaign c: testCampaign){
                    
                    opportunity.Name = 'Test Opportunity';
                    opportunity.AccountId = testAccount.Id;
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
        
        //insert Task
        
        task.WhatId = opportunity.Id;
        task.OwnerId = opportunity.Owner.Id;
        task.Subject = opportunity.Call_Type__c;
        task.Call_Outcome__c = opportunity.StageName;
        task.Status = 'In Progress';
		task.subject = 'Call';
        task.OwnerId = UserInfo.getUserId();
        task.ActivityDate = Date.today();
        insert task;
        
        //setting and opportunity id to the apex page parameter

        ApexPages.currentPage().getParameters().put('oppid', opportunity.Id);
        
        //calling of the controller
        CustomerPageController CPC = new CustomerPageController();
        //Display Controller of the customer page on GE Play
    }
}