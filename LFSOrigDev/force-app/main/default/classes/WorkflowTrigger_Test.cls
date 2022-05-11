/*
* @Description: WorkflowTrigger test class
* @Author: Jade Serrano
* @Date Created: 24-MAR-2014
* @History:
*  =====================================================================
*      Jade - 24-MAR-2014: Created
*  =====================================================================
*/
@isTest
private class WorkflowTrigger_Test {

	@isTest static void test_method_one() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

    		User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

	        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Risk_Referral'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			insert workflow;

		}

        /*Id roleId2 = [SELECT Id FROM UserRole where DeveloperName = 'CPU' LIMIT 1].Id;

        User user2 = TestDataBuilder.createUser(profileId);
        user2.UserRoleId = roleId2;
        user2.Username = 'Dummy2@cloudsherpas.com';
        user2.CommunityNickname = 'Test Nickname2';
        insert user2;

        System.runAs(user2){
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c
			workflow.Risk_CPU_Decision__c = 'Approve';
			workflow.Assigned_To_2__c = UserInfo.getUserId();
			workflow.Risk_Max_Secured_Amount__c = 1000;
			workflow.Risk_Max_UnSecured_Amount__c = 10000;
			workflow.Max_Term__c = 60;
			workflow.Risk_Collateral__c = 10000;
			update workflow;
		}*/

	}

	@isTest static void test_method_two() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Manager_Approval'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			insert workflow;
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c

		}

	}

	@isTest static void test_method_three() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Rate_Reduction'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			workflow.Adjusted_Interest_Rate__c = 10;
			insert workflow;
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c

		}

	}

	@isTest static void test_method_four() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Close_Application'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			insert workflow;
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c

		}

	}

	@isTest static void test_method_five() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		application.Risk_Override__c = true;
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Lending_Limit_Override'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			insert workflow;
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c

		}

	}

	@isTest static void test_method_six() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fee_Reduction'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			insert workflow;
			system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c

		}

	}

	@isTest static void test_method_seven() {

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false,'New');
		insert responseCodeControl;
		//system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c

		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		//system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        System.runAs(new User(Id = UserInfo.getUserId())) {

	        User user = TestDataBuilder.createUser(profileId);
	        user.UserRoleId = roleId;
	        insert user;

			Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fee_Reduction'].Id;

			Workflow__c workflow = new Workflow__c();//create Workflow__c
			workflow.Application__c = application.Id;
			workflow.RecordTypeId = recordTypeId;
			workflow.Assigned_To_1__c = user.Id;
			
			try{
				insert workflow;
				system.assertNotEquals(null,workflow.Id);//assert inserted Workflow__c
			}catch(DmlException e){
				System.assert(e.getMessage().contains('Item cannot be created at the current Application Status'), e.getMessage());//assert error message
			}

		}

	}

}