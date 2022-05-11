@isTest
/*
Author: Cloud Sherpas
Created Date: 
Description: Test Coverage for TaskComponentController

History:	March 10, 2014		Mat Isidro		Modified test class to improve coverage from 50% to 100% 
*/
public class TaskComponentControllerTest{
    static testMethod void case1() {
    	
    	Integer MAX = 100;
    	
    	// Create Opportunity/s
    	List<Opportunity> opptyList = new List<Opportunity>();
    	for (Integer i = 0; i < MAX; i++) {
	    	Opportunity oppty = new Opportunity();
	    	oppty.Name = 'opportunity ' + String.valueof(i);
	    	oppty.OwnerId = UserInfo.getuserId();
	    	oppty.StageName = 'No Answer';
	    	oppty.CloseDate = Date.today().addDays(30);
	    	opptyList.add(oppty);
    	}
    	insert opptyList;
    
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task;
        Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recType = TaskRecordTypeInfo.get('Call Back').getRecordTypeId();

    	// Create Task/s
    	List<Task> taskList = new List<Task>();
    	for (Integer i = 0; i < MAX; i++) {
	        Task task = new Task();
	        task.Subject = 'Call';
	        task.ReminderDateTime = Date.today().addDays(90);
	        task.Call_Outcome__c = 'Set Follow-Up Call';
	        task.RecordTypeId = recType;
	        task.OwnerId = UserInfo.getuserId();
	        task.WhatId = opptyList[i].Id;
	        task.Status = 'In Progress';
	        taskList.add(task);
		}		
		insert taskList;
        
        Test.startTest();
        
        TaskComponentController tcc = new TaskComponentController();
        List<TaskComponentController.TaskWrapper> twList = tcc.getTaskSubject();
        system.assertEquals(5, twList.size());
        
        Test.stopTest();
    }
}