/*
* @Description: PersonalReferenceCheckTrigger test class
* @Author: Jade Serrano
* @Date Created: 18-MAR-2014
* @History:
*  =====================================================================
*      Jade - 18-MAR-2014: Created
*  =====================================================================
*/
@isTest private class PersonalReferenceCheckTrigger_Test {
	
	@isTest static void test_method_one() {
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Personal_Reference_Check__c personalReferenceCheck = TestDataBuilder.createPersonalReferenceCheck(application.Id);//create personal reference check
		insert personalReferenceCheck;
		system.assertNotEquals(null,personalReferenceCheck.Id);//assert inserted Personal_Reference_Check__c
	}

	@isTest static void test_method_two() {
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Personal_Reference_Check__c personalReferenceCheck = TestDataBuilder.createPersonalReferenceCheck(application.Id);//fire personal reference check validation
		try{
			insert personalReferenceCheck;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('Item cannot be created at the current Application Status'), e.getMessage());//assert error message
		}
	}

	@isTest static void test_method_three() {
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Personal_Reference_Check__c personalReferenceCheck = TestDataBuilder.createPersonalReferenceCheck(application.Id);//fire personal reference check validation
		Personal_Reference_Check__c personalReferenceCheck2 = TestDataBuilder.createPersonalReferenceCheck(application.Id);//fire personal reference check validation
// 		Personal_Reference_Check__c personalReferenceCheck3 = TestDataBuilder.createPersonalReferenceCheck(application.Id);//fire personal reference check validation
// 		Personal_Reference_Check__c personalReferenceCheck4 = TestDataBuilder.createPersonalReferenceCheck(application.Id);//fire personal reference check validation

		insert personalReferenceCheck;
// 		insert personalReferenceCheck2;
// 		insert personalReferenceCheck3;
		
		try{
// 			insert personalReferenceCheck4;
            insert personalReferenceCheck2;
		}catch(DmlException e){
// 			System.assert(e.getMessage().contains('Application should only have a maximum of 3 Personal References'), e.getMessage());//assert error message
			System.assert(e.getMessage().contains('Personal Reference Check already present'), e.getMessage());//assert error message
		}
	}

}