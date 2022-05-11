@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/11/13
Description: Test Coverage for validateDueDate Trigger
*/
private class TaskTriggerHandlerTest{
    static testMethod void testupdateCallScore7(){
        List<Task> tasks = testDataBuilder.createTasks(1);

        Test.startTest();
        insert tasks;
        Test.stopTest();
        
        TaskTriggerHandler tth = new TaskTriggerHandler();
        tth.updateCallScore(tasks, 7);
        TaskListInserted(tasks[0].Id, 1);
    }
    
    static testMethod void testupdateCallScore30(){
        List<Task> tasks = testDataBuilder.createTasks(1);
        
        Test.startTest();
        insert tasks;
        Test.stopTest();
        
        TaskTriggerHandler tth = new TaskTriggerHandler();
        tth.updateCallScore(tasks, 30);
        TaskListInserted2(tasks[0].Id, 1);
    }
    
    static testMethod void testupdateCallScoreBulk(){
        List<Task> tasks = testDataBuilder.createTasks(10);
        
        Test.startTest();
        insert tasks;
        Test.stopTest();
        
        TaskTriggerHandler tth = new TaskTriggerHandler();
        tth.updateCallScore(tasks, 7);
        tth.updateCallScore(tasks, 30);
        
        TaskListInserted(tasks, 10);
    }
    
        
    private static void TaskListInserted(Id taskId, Integer result){
        List<Task> taskList = [SELECT WhatId FROM Task WHERE Id =: taskId];
        List<Opportunity> oppList = [SELECT X7DayCallScore__c FROM Opportunity WHERE Id =: taskList[0].Id];
        System.AssertEquals(result, taskList.size());
        for(Opportunity o: oppList){
            System.AssertEquals(result, o.X7DayCallScore__c);
        }
    }
    
    private static void TaskListInserted2(Id taskId, Integer result){
        List<Task> taskList = [SELECT WhatId FROM Task WHERE Id =: taskId];
        List<Opportunity> oppList = [SELECT X30DayCallScore__c FROM Opportunity WHERE Id =: taskList[0].Id];
        System.AssertEquals(result, taskList.size());
        for(Opportunity o: oppList){
            System.AssertEquals(result, o.X30DayCallScore__c);
        }
    }
    
    private static void TaskListInserted(List<Task> taskList, Integer result){
        Set<Id> taskSet = new Set<Id>();
        for(Task tsk: taskList){
             taskSet.add(tsk.Id);
        }
        List<Task> taList = [Select Id from Task where Id in: taskSet];
        System.AssertEquals(result, taList.size());
    }
        
}