@isTest
public class CustomInteractionLog_Test {

    static testMethod void InteractionLog_Test() {
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            testUser.Password_Reset_Token__c = '1234';
            insert testUser;
        }

        List<Account> testAccounts = TestDataBuilder.createAccounts(1);
        insert testAccounts;

        Contact testContact = new Contact();
        testContact.OwnerId = testUser.Id;
        testContact.AccountId = testAccounts.get(0).Id;
        testContact.LastName = 'Test';
        insert testContact;

        Case testCase = new Case();
        testCase.OwnerId = testUser.Id;
        testCase.AccountId = testAccounts.get(0).Id;
        testCase.ContactId = testContact.Id;
        testCase.Status = 'New';
        testCase.Origin = 'Web';
        testCase.Merchant_Number__c = 1234567;
        testCase.Customer_Name__c = 'ABCDEF';
        
        insert testCase;

        List<Task> testTaskList = TestDataBuilder.createTasks(1);
        insert testTaskList;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testCase);
            CustomInteractionLog log = new CustomInteractionLog(standardCon);
            ApexPages.currentPage().getParameters().put('Id', testCase.Id);
            log.caseId = testCase.Id;
            log.Task = testTaskList.get(0);
            log.setCallAttachedData();
            log.setCallEndData();
            log.saveAndNew();
        Test.StopTest();
        
        System.assertEquals(testCase.Id, log.caseId);
        System.assertEquals(null, log.task.Id);
    }
}