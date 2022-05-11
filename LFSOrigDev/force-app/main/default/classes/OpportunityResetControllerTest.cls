/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description 
* @history      Mat Isidro      March 3, 2014       Increased test coverage
*/

@isTest
public with sharing class OpportunityResetControllerTest {

        static testMethod void TestCase1() {
            // Create Test Campaign
            List<Campaign>campaignList = TestdataBuilder.createCampaign(2);
            campaignList[0].IsActive = false;
            campaignList[1].IsActive = true;
            insert campaignList;
        
            // Create Test Account
            List<Account>accList = TestDataBuilder.createAccounts(1);
            insert accList;
        
            List<Opportunity>queueOpp = TestDataBuilder.createOpportunities(3, accList[0].Id);
        
            // Create Test Opportunity that is currently inplay and campaign is inactive
            queueOpp[0].CampaignId = campaignList[0].Id;
            queueOpp[0].InPlay__c = true;
            queueOpp[0].Time_Out__c = null;
            queueOpp[0].StageName = 'New';
            queueOpp[0].PostCode_Exclusion__c = false;
            queueOpp[0].Mail_Code__c = '';
            queueOpp[0].Excluded_Date__c = null;
            
            // Create Test Opportunity that is currently not inplay and campaign is active
            queueOpp[1].CampaignId = campaignList[1].Id;
            queueOpp[1].InPlay__c = false;
            queueOpp[1].Time_Out__c = null;
            queueOpp[1].StageName = 'New';
            queueOpp[1].PostCode_Exclusion__c = false;
            queueOpp[1].Mail_Code__c = '';
            queueOpp[1].Excluded_Date__c = null;
            
            // Create Test Opportunity that is currently inplay at the same time campaign is active
            queueOpp[2].CampaignId = campaignList[1].Id;
            queueOpp[2].InPlay__c = true;
            queueOpp[2].Time_Out__c = null;
            queueOpp[2].StageName = 'New';
            queueOpp[2].PostCode_Exclusion__c = false;
            queueOpp[2].Mail_Code__c = '';
            queueOpp[2].Excluded_Date__c = null;
            insert queueOpp;
            
            // Branch Assignment
            Branch_Assignment__c ba = new Branch_Assignment__c();
            ba.User__c = UserInfo.getUserId(); 
            ba.RecordTypeId = [select Id from RecordType where Name = 'Working Location'].Id;
			insert ba;
            
            OpportunityResetController oppRestCntrl = new OpportunityResetController();
            
            test.startTest();
            
            // Satisfy null Condition
            oppRestCntrl.resetOpportunity();
            
            // Satisfy condition for opportunity inplay and campaign is inactive
            ApexPages.currentPage().getParameters().put('oppId', queueOpp[1].Id);
            PageReference pageRef = oppRestCntrl.resetOpportunity();
            system.debug('@@@pageRef: ' + pageRef);
            system.assertEquals('/apex/geplaypage2?oppid=' + String.valueof(queueOpp[1].Id).toLowerCase(), pageRef.getUrl().toLowerCase());
            List<Opportunity> opptyList = [select Id, InPlay__c, PlayPageSave__c from Opportunity where id =: queueOpp[1].Id];
            system.assert(true, opptyList[0].InPlay__c);
            system.assert(true, opptyList[0].PlayPageSave__c);
              
            // Satisfy condition for opportunity not inplay and campaign is active
            ApexPages.currentPage().getParameters().put('oppId', queueOpp[0].Id);
            oppRestCntrl.resetOpportunity();
            PageReference pageRef2 = oppRestCntrl.resetOpportunity();
            system.debug('@@@pageRef2: ' + pageRef2);
            system.assertEquals('/apex/geplaypage2readonly?oppid='+ String.valueof(queueOpp[0].Id).toLowerCase(), pageRef2.getUrl().toLowerCase());
            
            test.stopTest();
        }

}