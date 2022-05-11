/*
	*@Author:Gio Jeremiah Villaverde Cloud Sherpas (Intern)
	*@Description: Test Class for APP_Notes_EXT_INT.cls
	*@Created Date:2/6/2014
	*@Test Coverage: 100%

*/


@isTest
public with sharing class APP_Notes_EXT_INT_Test {
	
	static testMethod void constructorTestWithExistingRecords(){
		
		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication; 
	        
	    List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
	    insert adminSettingsList;        

		List<Task> testTasks =TestDataBuilder.createTasks(1) ;
		testTasks.get(0).WhatId = testApplication.Id;
		insert testTasks;
     
        test.startTest();
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_Notes_EXT_INT notes = new APP_Notes_EXT_INT(standardCon);
            
            notes.refreshNotesTabTable();
		test.stopTest();

		System.assertEquals(testTasks.size(), notes.taskList.size());
	}

}