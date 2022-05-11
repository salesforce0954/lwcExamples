@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/07/13
Description: Test Coverage for createTask Trigger
Last Modified: Andre Calimlim       02/07/13        Added more test methods
*/
private class OpportunityTriggerHandlerTest{
    static testMethod void testcreateTask(){
        OpportunityTriggerHandler oppHandler = new OpportunityTriggerHandler();

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
                
        User testUserSysAd = TestDataBuilder.createUser(profileId);
        insert testUserSysAd;

        System.runAs(testUserSysAd){
            List<Account> acc = testDataBuilder.createAccounts(1);
            insert acc;
            List<Opportunity> opp = testDataBuilder.createOpportunities(1, acc[0].id);
            insert opp;
            Test.startTest();
            opp[0].OwnerId = testUserSysAd.Id;
            opp[0].StageName = 'Left Message';
            opp[0].Call_Type__c = 'Inbound Call';
            update opp[0];
            oppHandler.createTask(opp);
            Test.stopTest();
            TaskListInserted(opp[0].Id, 1);
        }
    }

    static testMethod void testcreateTaskBulk(){
        OpportunityTriggerHandler oppHandler = new OpportunityTriggerHandler();
        
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
                
        User testUserSysAd = TestDataBuilder.createUser(profileId);
        insert testUserSysAd;

        System.runAs(testUserSysAd){
            List<Account> acc = testDataBuilder.createAccounts(1);
            insert acc;
            List<Opportunity> opp = testDataBuilder.createOpportunities(5, acc[0].id);
            insert opp;
            Test.startTest();
            for(Opportunity o: opp){
                o.OwnerId = testUserSysAd.Id;
                o.StageName = 'Wrong Number';
                o.Call_Type__c = 'Inbound Call';
            }
            update opp;
            oppHandler.createTask(opp);
            Test.stopTest();
            TaskListInserted(opp, 5);
        }
    }

    static testMethod void testcreateTaskInsertOnlyBulk(){
        OpportunityTriggerHandler oppHandler = new OpportunityTriggerHandler();
        
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
                
        User testUserSysAd = TestDataBuilder.createUser(profileId);
        insert testUserSysAd;
        System.runAs(testUserSysAd){
            List<Account> acc = testDataBuilder.createAccounts(1);
            insert acc;
            List<Opportunity> opp = testDataBuilder.createOpportunities(10, acc[0].id);
            for(Opportunity o: opp){
                o.OwnerId = testUserSysAd.Id;
                o.Call_Type__c = 'Inbound Call';
            }
            Test.startTest();
            insert opp;
            oppHandler.createTask(opp);
            Test.stopTest();
            TaskListInserted(opp, 0);
        }
    }

    private static void TaskListInserted(Id oppId, Integer result){
        List<Task> taList = [Select Subject from Task where WhatId =: oppId];
        for(Task ta: taList){
            System.AssertEquals('Inbound Call', ta.Subject);
        }
    }
    
    private static void TaskListInserted(List<Opportunity> oppList, Integer result){
        Set<Id> oppSet = new Set<Id>();
        for(Opportunity opp: oppList){
             oppSet.add(opp.Id);
        }
        List<Task> taList = [Select Subject from Task where WhatId in: oppSet];

        for(Task ta: taList){
            System.AssertEquals('Inbound Call', ta.Subject);
        }
    }
}