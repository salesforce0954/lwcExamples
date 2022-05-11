@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 03/06/13
Description: Test Coverage for CreditCardsPageController Class
*/
private class CreditCardsPageControllerTest{
    
    static testMethod void testCreditCards(){
        ApexPages.currentPage().getParameters().put('oppid', '/home/home.jsp');
        
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        Opportunity currentOpp = [SELECT AccountId FROM Opportunity WHERE Id=: oppList[0].Id];
        system.assertEquals(accList[0].Id, currentOpp.AccountId);
        
        List<Billing_Vision_Plus__c> billVPlusList = TestDataBuilder.createBVision(1, accList[0].Id);
        insert billVPlusList;
        
        Billing_Vision_Plus__c currentbillVPlus = [SELECT Account__c FROM Billing_Vision_Plus__c WHERE Id=: billVPlusList[0].Id];
        system.assertEquals(accList[0].Id, currentbillVPlus.Account__c);
  	   	
        List<Plans__c> planList = TestDataBuilder.createPlans(1, billVPlusList[0].Id);
        insert planList;
        
        Plans__c currentPlan = [SELECT Billing_Vision_Plus__c FROM Plans__c WHERE Id=: planList[0].Id];
        system.assertEquals(billVPlusList[0].Id, currentPlan.Billing_Vision_Plus__c);
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', oppList[0].Id);
        CreditCardsPageController controller = new CreditCardsPageController();
        Test.stopTest();
    }
    
    static testMethod void testCreditCardsRepopulate(){
        ApexPages.currentPage().getParameters().put('oppid', '/home/home.jsp');
        
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        Opportunity currentOpp = [SELECT AccountId FROM Opportunity WHERE Id=: oppList[0].Id];
        system.assertEquals(accList[0].Id, currentOpp.AccountId);
        
        List<Billing_Vision_Plus__c> billVPlusList = TestDataBuilder.createBVision(1, accList[0].Id);
        insert billVPlusList;
        
        Billing_Vision_Plus__c currentbillVPlus = [SELECT Account__c FROM Billing_Vision_Plus__c WHERE Id=: billVPlusList[0].Id];
        system.assertEquals(accList[0].Id, currentbillVPlus.Account__c);
  	   	
        List<Plans__c> planList = TestDataBuilder.createPlans(1, billVPlusList[0].Id);
        insert planList;
        
        Plans__c currentPlan = [SELECT Billing_Vision_Plus__c FROM Plans__c WHERE Id=: planList[0].Id];
        system.assertEquals(billVPlusList[0].Id, currentPlan.Billing_Vision_Plus__c);
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', oppList[0].Id);
        CreditCardsPageController controller = new CreditCardsPageController();
        controller.repopulateChosenCreditCard();
        Test.stopTest();
    }
    
    static testMethod void testCreditCardsPlan(){
        ApexPages.currentPage().getParameters().put('oppid', '/home/home.jsp');
        
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        Opportunity currentOpp = [SELECT AccountId FROM Opportunity WHERE Id=: oppList[0].Id];
        system.assertEquals(accList[0].Id, currentOpp.AccountId);
        
        List<Billing_Vision_Plus__c> billVPlusList = TestDataBuilder.createBVision(1, accList[0].Id);
        insert billVPlusList;
        
        Billing_Vision_Plus__c currentbillVPlus = [SELECT Account__c FROM Billing_Vision_Plus__c WHERE Id=: billVPlusList[0].Id];
        system.assertEquals(accList[0].Id, currentbillVPlus.Account__c);
  	   	
        List<Plans__c> planList = TestDataBuilder.createPlans(1, billVPlusList[0].Id);
        insert planList;
        
        Plans__c currentPlan = [SELECT Billing_Vision_Plus__c FROM Plans__c WHERE Id=: planList[0].Id];
        system.assertEquals(billVPlusList[0].Id, currentPlan.Billing_Vision_Plus__c);
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', oppList[0].Id);
        CreditCardsPageController controller = new CreditCardsPageController();
        controller.chosenCreditCardPlansId = billVPlusList[0].Id;
        controller.Plans();
        Test.stopTest();
    }
    
    static testMethod void testCreditCardsRepopulatePlan(){
        ApexPages.currentPage().getParameters().put('oppid', '/home/home.jsp');
        
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        Opportunity currentOpp = [SELECT AccountId FROM Opportunity WHERE Id=: oppList[0].Id];
        system.assertEquals(accList[0].Id, currentOpp.AccountId);
        
        List<Billing_Vision_Plus__c> billVPlusList = TestDataBuilder.createBVision(1, accList[0].Id);
        insert billVPlusList;
        
        Billing_Vision_Plus__c currentbillVPlus = [SELECT Account__c FROM Billing_Vision_Plus__c WHERE Id=: billVPlusList[0].Id];
        system.assertEquals(accList[0].Id, currentbillVPlus.Account__c);
  	   	
        List<Plans__c> planList = TestDataBuilder.createPlans(1, billVPlusList[0].Id);
        insert planList;
        
        Plans__c currentPlan = [SELECT Billing_Vision_Plus__c FROM Plans__c WHERE Id=: planList[0].Id];
        system.assertEquals(billVPlusList[0].Id, currentPlan.Billing_Vision_Plus__c);
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', oppList[0].Id);
        CreditCardsPageController controller = new CreditCardsPageController();
        controller.repopulateChosenCreditCard();
        controller.chosenCreditCardPlansId = billVPlusList[0].Id;
        controller.Plans();
        Test.stopTest();
    }
    
    static testMethod void testCreditCardsBulk(){
        ApexPages.currentPage().getParameters().put('oppid', '/home/home.jsp');
        
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        Opportunity currentOpp = [SELECT AccountId FROM Opportunity WHERE Id=: oppList[0].Id];
        system.assertEquals(accList[0].Id, currentOpp.AccountId);
        
        List<Billing_Vision_Plus__c> billVPlusList = TestDataBuilder.createBVision(10, accList[0].Id);
        insert billVPlusList;
        
        Billing_Vision_Plus__c currentbillVPlus = [SELECT Account__c FROM Billing_Vision_Plus__c WHERE Id=: billVPlusList[3].Id];
        system.assertEquals(accList[0].Id, currentbillVPlus.Account__c);
  	   	
        List<Plans__c> planList = TestDataBuilder.createPlans(5, billVPlusList[3].Id);
        insert planList;
        
        Plans__c currentPlan = [SELECT Billing_Vision_Plus__c FROM Plans__c WHERE Id=: planList[2].Id];
        system.assertEquals(billVPlusList[3].Id, currentPlan.Billing_Vision_Plus__c);
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', oppList[0].Id);
        CreditCardsPageController controller = new CreditCardsPageController();
        controller.repopulateChosenCreditCard();
        controller.chosenCreditCardPlansId = billVPlusList[3].Id;
        controller.Plans();
        Test.stopTest();
    }
}