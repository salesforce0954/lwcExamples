@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/07/13
Description: Test Coverage for createTask Trigger
Last Modified: Andre Calimlim       02/07/13        Added more test methods
*/
private class OpportunityTriggerHandlercreateTaskTest{
    static testMethod void testTask(){
        List<Account> acc = testDataBuilder.createAccounts(1);
        insert acc;
        List<Opportunity> opp = testDataBuilder.createOpportunities(1, acc[0].id);
        insert opp;
        Test.startTest();
        opp[0].Name = 'Test 1';
        update opp[0];
        Test.stopTest();
        TaskListInserted(opp[0].Id, 1);
    }

    static testMethod void testTaskBulk(){
        List<Account> acc = testDataBuilder.createAccounts(1);
        insert acc;
        List<Opportunity> opp = testDataBuilder.createOpportunities(10, acc[0].id);
        insert opp;
        Test.startTest();
        for(Opportunity o:opp){
            o.Name = 'Test 1';
        }
        update opp;
        Test.stopTest();
        TaskListInserted(opp, 10);
    }

    static testMethod void testTaskInsertOnlyBulk(){
        List<Account> acc = testDataBuilder.createAccounts(1);
        insert acc;
        List<Opportunity> opp = testDataBuilder.createOpportunities(10, acc[0].id);
        Test.startTest();
        insert opp;
        Test.stopTest();
        TaskListInserted(opp, 0);
    }

    private static void TaskListInserted(Id oppId, Integer result){
        List<Task> taList = [Select Subject from Task where WhatId =: oppId];
        for(Task ta: taList){
            System.AssertEquals('Call Back', ta.Subject);
        }
    }
    
    private static void TaskListInserted(List<Opportunity> oppList, Integer result){
        Set<Id> oppSet = new Set<Id>();
        for(Opportunity opp: oppList){
             oppSet.add(opp.Id);
        }
        List<Task> taList = [Select Subject from Task where WhatId in : oppSet];
        for(Task ta: taList){
            System.AssertEquals('Call Back', ta.Subject);
        }
    }
}