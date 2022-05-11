/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 12 Feb 2013 
* @description Test Class for LeadEditPageOverrideController Class
*/
@isTest
public with sharing class LeadEditPageOverrideControllerTest {
	
	static testMethod void test1() {

		Test.StartTest();
			//All methods and Stage Name = Set Follow-Up Call and no Assigned to User
			List<Account> testAccList = testDataBuilder.createAccounts(1);
			insert testAccList;
			
			List<Opportunity> testOppList = testDataBuilder.createOpportunities(1, testAccList.get(0).Id);
			testOppList.get(0).OwnerId = UserInfo.getUserId();
			testOppList.get(0).StageName = 'Set Follow-Up Call';
			insert testOppList;

			List<Task> testTaskList = testDataBuilder.createTasks(1, testOppList.get(0));
			insert testTaskList;

			//List<Event> testEventList = testDataBuilder.createEvents(1, testOppList.get(0));
			//insert testEventList;

			ApexPages.CurrentPage().getParameters().put('Id', testOppList.get(0).Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testOppList.get(0));
            LeadEditPageOverrideController lead = new LeadEditPageOverrideController(standardCon);
            lead.returnLeadManagementHome();
            lead.getTaskPrefix();
            lead.getEventPrefix();
            lead.newTask();
            lead.newEvent();
            lead.populateNextLead();
            testOppList.get(0).Assigned_to_User__c = UserInfo.getUserId();
			update testOppList;
        Test.StopTest();

        System.assertEquals(testAccList.get(0).Id, testOppList.get(0).AccountId);
        System.assertEquals(testOppList.get(0).OwnerId, testTaskList.get(0).OwnerId);
        //System.assertEquals(testOppList.get(0).OwnerId, testEventList.get(0).OwnerId);
        System.assertEquals(testOppList.get(0).Id, lead.oppVar.Id);
        System.assertEquals(testOppList.get(0).StageName, lead.initStatus); 
	}

	static testMethod void test2() {

		Test.StartTest();
			//Stage Name = Set Follow-Up Call and with Assigned to User
			List<Account> testAccList = testDataBuilder.createAccounts(1);
			insert testAccList;
			
			List<Opportunity> testOppList = testDataBuilder.createOpportunities(1, testAccList.get(0).Id);
			testOppList.get(0).OwnerId = UserInfo.getUserId();
			testOppList.get(0).StageName = 'Set Follow-Up Call';
			testOppList.get(0).Assigned_to_User__c = UserInfo.getUserId();
			insert testOppList;

			ApexPages.CurrentPage().getParameters().put('Id', testOppList.get(0).Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testOppList.get(0));
            LeadEditPageOverrideController lead = new LeadEditPageOverrideController(standardCon);
            lead.populateNextLead();
        Test.StopTest();

        System.assertEquals(testAccList.get(0).Id, testOppList.get(0).AccountId);
        System.assertEquals(testOppList.get(0).Id, lead.oppVar.Id);
        System.assertEquals(testOppList.get(0).StageName, lead.initStatus); 
	}

	static testMethod void test3() {

		Test.StartTest();
			//Stage Name = Cancel
			List<Account> testAccList = testDataBuilder.createAccounts(1);
			insert testAccList;
			
			List<Opportunity> testOppList = testDataBuilder.createOpportunities(1, testAccList.get(0).Id);
			testOppList.get(0).OwnerId = UserInfo.getUserId();
			testOppList.get(0).StageName = 'Cancel';
			testOppList.get(0).Assigned_to_User__c = UserInfo.getUserId();
			insert testOppList;

			ApexPages.CurrentPage().getParameters().put('Id', testOppList.get(0).Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testOppList.get(0));
            LeadEditPageOverrideController lead = new LeadEditPageOverrideController(standardCon);
            lead.populateNextLead();
        Test.StopTest();

        System.assertEquals(testAccList.get(0).Id, testOppList.get(0).AccountId);
        System.assertEquals(testOppList.get(0).Id, lead.oppVar.Id);
        System.assertEquals(testOppList.get(0).StageName, lead.initStatus); 
	}
}