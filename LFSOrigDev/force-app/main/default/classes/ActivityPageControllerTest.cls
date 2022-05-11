@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/22/13
Description: Test Coverage for ActivityPageController
*/
private class ActivityPageControllerTest{
    
    static testMethod void testActivityPage(){
        //create task
        
        List<Task> tsk = TestDataBuilder.createTasks(1);
        insert tsk;
        
        Task currentTask = [SELECT Id FROM Task WHERE Id=: tsk[0].Id];
        system.assertEquals(tsk[0].Id, currentTask.Id);
         
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', tsk[0].WhatId); //setting up the opportunity id to the apex page
        ActivityPageController controller = new ActivityPageController(); //calling the controller
        controller.taskIdStr = tsk[0].Id; //setting up the task id to the controller's variable
        controller.setupActivityDetails(); // calling the method after having the taskIdStr
        Test.stopTest();
    }
    
    static testMethod void testActivityPageBulk(){
        //create task
        
        List<Task> tsk = TestDataBuilder.createTasks(10);
        insert tsk;
        
        //Task currentTask = [SELECT Id FROM Task WHERE Id=: Task[0].Id];
        system.assertEquals(10, tsk.size());
         
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppid', tsk[0].WhatId); //setting up the opportunity id to the apex page
        ActivityPageController controller = new ActivityPageController(); //calling the controller
        controller.taskIdStr = tsk[0].Id; //setting up the task id to the controller's variable
        controller.setupActivityDetails(); // calling the method after having the taskIdStr
        Test.stopTest();
    }
}