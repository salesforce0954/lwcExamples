/*
* @Description: CreditRefCheckTrigger test class
* @Author: Jade Serrano
* @Date Created: 18-MAR-2014
* @History:
*  =====================================================================
*      Jade - 18-MAR-2014: Created
*  =====================================================================
*/
@isTest private class CreditRefCheckTrigger_Test {
	
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

		Credit_Ref_Check__c creditRefCheck = TestDataBuilder.createCreditRefCheck(application.Id);//create personal reference check
		insert creditRefCheck;
		system.assertNotEquals(null,creditRefCheck.Id);//assert inserted Credit_Ref_Check__c

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

		Credit_Ref_Check__c creditRefCheck = TestDataBuilder.createCreditRefCheck(application.Id);//fire personal reference check validation
		try{
			insert creditRefCheck;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('Item cannot be created at the current Application Status'), e.getMessage());//assert error message
		}
	}

}