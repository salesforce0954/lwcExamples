@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 03/06/13
Description: Test Coverage for OpportunityRefreshController Class
*/
private class OpportunityRefreshControllerTest{
    
    static testMethod void OpportunityRefreshTest(){
    	List<Account> accList = TestDataBuilder.createAccounts(1);
    	Insert accList;
    	
    	List<Campaign> campList = TestDataBuilder.createCampaign(1);
    	Insert campList;
    	
    	List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
    	Insert oppList;
    	
    	Campaign camp = [SELECT Id FROM Campaign WHERE Id =: campList[0].Id];
    	
    	oppList[0].CampaignId = campList[0].Id;
    	update oppList[0];
    	
    	Opportunity oppy = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppList[0].Id];
    	system.assertEquals(oppy.AccountId, oppList[0].AccountId);
    	
	    List<Branch__c> branchList = TestDataBuilder.createBranch(1);
	    insert branchList;
	    
	    Branch__c currentBranch = [SELECT Id FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
        
        Test.startTest();
		ApexPages.StandardController standardController = new ApexPages.StandardController(oppy);
		OpportunityRefreshController Controller = new OpportunityRefreshController(standardController);
		Controller.getBranch();
		Controller.Branches = branchList[0].Id;
		Controller.refreshPropensity();
        Test.stopTest();
    }
    
    static testMethod void OpportunityRefreshError(){
    	List<Account> accList = TestDataBuilder.createAccounts(1);
    	Insert accList;
    	
    	List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
    	Insert oppList;
    	
    	Opportunity oppy = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppList[0].Id];
    	system.assertEquals(oppy.AccountId, oppList[0].AccountId);
    	
	    List<Branch__c> branchList = TestDataBuilder.createBranch(1);
	    insert branchList;
	    
	    Branch__c currentBranch = [SELECT Id FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
        
        Test.startTest();
		ApexPages.StandardController standardController = new ApexPages.StandardController(oppy);
		OpportunityRefreshController Controller = new OpportunityRefreshController(standardController);
		Controller.getBranch();
		Controller.refreshPropensity();
        Test.stopTest();
    }
    
     static testMethod void OpportunityRefreshBulk(){
    	List<Account> accList = TestDataBuilder.createAccounts(1);
    	Insert accList;
    	
    	List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
    	Insert oppList;
    	
    	Opportunity oppy = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppList[0].Id];
    	system.assertEquals(oppy.AccountId, oppList[0].AccountId);
    	
	    List<Branch__c> branchList = TestDataBuilder.createBranch(10);
	    insert branchList;
	    
	    Branch__c currentBranch = [SELECT Id FROM Branch__c WHERE Id=: branchList[5].Id];
        system.assertEquals(10, branchList.size());
        
        Test.startTest();
		ApexPages.StandardController standardController = new ApexPages.StandardController(oppy);
		OpportunityRefreshController Controller = new OpportunityRefreshController(standardController);
		Controller.getBranch();
		Controller.Branches = branchList[5].Id;
		Controller.refreshPropensity();
        Test.stopTest();
    }
}