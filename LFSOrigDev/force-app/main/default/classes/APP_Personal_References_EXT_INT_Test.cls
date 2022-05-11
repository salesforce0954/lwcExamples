/*
 * @Description: Test class for APP_Personal_References_EXT_INT class
 * @Author: Kristoffer Chuck Martin
 * @Date Created: 02/19/2014
 * @History:
   =====================================================================
       02/19/2014: Created - Chuck
   =====================================================================
 */

@isTest
private class APP_Personal_References_EXT_INT_Test {
	
	
	static testMethod void PersonalReferencesListMethod() {

		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
		testApplicant.Application__c = testApplication.Id;
		insert testApplicant;

		Profile p =[SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

		User testUser = TestDataBuilder.createUser(p.Id);

        Profile_Control__c createProfileControl = TestDataBuilder.createProfileControl(true);
        insert createProfileControl;

		Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
		insert testResponseCodeControl;

		List<Personal_Reference_Check__c> perRefList = new List<Personal_Reference_Check__c>();
		Personal_Reference_Check__c testPersonalReferenceCheck = TestDataBuilder.createPersonalReferenceCheck(testApplication.Id);
		testPersonalReferenceCheck.Application__c = testApplication.Id;
		perRefList.add(testPersonalReferenceCheck);
		insert perRefList;

		Test.startTest();
			ApexPages.StandardController perRefPage = new ApexPages.StandardController(testApplication);
			APP_Personal_References_EXT_INT appPRExtInt = new APP_Personal_References_EXT_INT(perRefPage);
			appPRExtInt.refreshPRCList();
			appPRExtInt.prcList = perRefList;
		Test.stopTest();

		System.assertEquals(perRefList.size(), appPRExtInt.prcList.size());
	}
}