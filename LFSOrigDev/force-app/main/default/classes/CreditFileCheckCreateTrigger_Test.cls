@isTest
public class CreditFileCheckCreateTrigger_Test {
	
	static testMethod void updateApplicant(){
		
		//User testUser = TestDataBuilder.createUser();

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;


        //response code
        Response_Code_Control__c testResponseCodeCtrl = new Response_Code_Control__c();
        testResponseCodeCtrl.Name = 'New';
        testResponseCodeCtrl.Credit_File_Check__c = true;
        insert testResponseCodeCtrl;

        //profile control
        Profile_Control__c testProfileControl = new Profile_Control__c();
        testProfileControl.Name = 'System Administrator';
        testProfileControl.Credit_File_Check__c = true;
        insert testProfileControl;

		Application__c testApplication = TestDataBuilder.createApplication();
		testApplication.Response_Code__c = 'Test';
		insert testApplication;

		System.runAs(new User(Id = UserInfo.getUserId())) {

	        User testUser = TestDataBuilder.createUser(profileId);
	        testUser.UserRoleId = roleId;
	        //testUser.AppId__c = testApplication.Id;
	        insert testUser;

			Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testapplication.Id);
			insert testApplicant;

			Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFilecheck(testApplicant.Id, testApplication.Id);

			Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
			insert testResponseCodeControl;

			//Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
			//insert testProfileControl;

			Test.StartTest();
				
					insert testCreditFileCheck;

			Test.StopTest();

			Applicant__c updatedApplicant = [SELECT Has_Credit_File_Check__c FROM Applicant__c WHERE Id =: testApplicant.Id];
			System.assertEquals(true,updatedApplicant.Has_Credit_File_Check__c);
		}
	}
	
}