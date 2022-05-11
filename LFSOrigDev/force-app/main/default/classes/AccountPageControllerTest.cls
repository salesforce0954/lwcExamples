/**
* @author Original: Dan Crisologo
* @date Original: 21 Feb 2013 
* @description Test class for AccountPageController
*/

@isTest
public class AccountPageControllerTest{

    static testMethod void TesetCase1(){
        
        //recordtype
                RecordType recordtype = [SELECT Id,Name FROM RecordType WHERE Name = 'Business Account'];
        //create account
                Account account = new Account();
                account.name = 'Test Account';
                account.RecordTypeId = recordtype.Id;
                insert account;
        //create campaign
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
                
         //create Opportunity
                Opportunity opportunity = new Opportunity();
                opportunity.Name = 'Test Opportunity';
                opportunity.Account = account;
                opportunity.AccountId = account.Id;
                opportunity.StageName = 'Test Stage';
                opportunity.Branch_Name__c = 'Test Branch Name';
                opportunity.Branch_ID__c = 'Test Branch ID';
                opportunity.Branch_Suburb__c = 'Test Suburb';
                opportunity.Branch_Postcode__c = 'Test Post';
                opportunity.Propensity_Score__c = 1; 
                opportunity.Campaign = campaign;
                opportunity.CloseDate = System.today();
                opportunity.Assigned_to_User__c = UserInfo.getUserId();
                
                insert opportunity;
                
                Opportunity currentOpportunity = [SELECT ID,Name FROM Opportunity WHERE Id =: opportunity.Id];
                system.assertEquals(opportunity.Id,currentOpportunity.Id);
                
        List<account> lacct = new List<account>();
        List<Opportunity> lOppo = new List<Opportunity>();
        lacct.addall(TestDataBuilder.createAccounts(1));
        String varId;
        Contact c = new Contact();
        For(Account a:lacct){
            c.accountId = a.id;
            varId = a.id;
            c.LastName = 'Test';
            lOppo.addall(TestDataBuilder.createOpportunities(1,a.id));
        }
        For(Opportunity o: lOppo){
            o.Accountid = varId;
        }
        insert lOppo;
        insert c;

        
        //create Billing_Vision_Plus__c
        Billing_Vision_Plus__c bvp = new Billing_Vision_Plus__c();
            bvp.Account_Number__c = '123456';
            bvp.CLV_Customer_ID__c = '123456';
            bvp.account__c = account.Id;
        insert bvp;
        
        Billing_Genesis__c bg = new Billing_Genesis__c();
            bg.Account_Number__c = '123456';
            bg.account__c = account.Id;
        insert bg;
        
        Billing_ICBS__c bi = new Billing_ICBS__c();
            bi.Account_Number__c = '123456';
            bi.account__c = account.Id;
        insert bi;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', opportunity.Id);
        AccountPageController apc = new AccountPageController ();
        apc.repopulateChosenPersonalLoan();
        apc.repopulateChosenAutoLoan();
        Test.stopTest(); 
            
    }
}