/*
* @Description: APP_RegisterCC test class
* @Author: Jade Serrano
* @Date Created: 07-APR-2014
* @History:
*  =====================================================================
*      Jade - 07-APR-2014
*  =====================================================================
*/
@isTest
private class APP_RegisterCC_Test {

	@isTest static void test_method_one() {

		List<Admin_Settings__c> adminSetting = TestDataBuilder.adminSet();
		insert adminSetting;
		system.assertNotEquals(0,adminSetting.size());//assert inserted Application__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Register;//ensure that APP_Register page is being tested
        pageRef.getParameters().put('id',application.Id);
        Test.setCurrentPageReference(pageRef);

        APP_RegisterCC controller = new APP_RegisterCC(standardController);

        controller.email = 'test@email.com';
        controller.password = 'qwer1234';
        controller.confirmPassword = 'qwer1234';
        controller.birthYear = '1991';
        controller.birthMonth =  '12';
        controller.birthDate = '12';


        controller.registerUser();
		
	}

	@isTest static void Constructor_Test() {

		List<Admin_Settings__c> adminSetting = TestDataBuilder.adminSet();
		insert adminSetting;
		system.assertNotEquals(0,adminSetting.size());//assert inserted Application__c

		Application__c testApplication = TestDataBuilder.createApplication();//create application
		testApplication.Response_Code__c = 'New';
		insert testApplication;
		system.assertNotEquals(null,testApplication.Id);//assert inserted Application__c

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
                testApplicant.Is_Primary_Applicant__c = true;
                insert testApplicant;

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication);

		PageReference pageRef = Page.APP_Register;//ensure that APP_Register page is being tested
        pageRef.getParameters().put('id',testApplication.Id);
        Test.setCurrentPageReference(pageRef);

        APP_RegisterCC controller = new APP_RegisterCC(standardController);

        System.assertEquals(controller.email, String.valueOf(testApplicant.Email_Address__c).toLowerCase());
        System.assertEquals(controller.em, String.valueOf(testApplicant.Email_Address__c).toLowerCase());
        System.assertEquals(controller.dob, testApplicant.Date_of_Birth__c);
	}

	@isTest static void Negative_Test() {

		List<Admin_Settings__c> adminSetting = TestDataBuilder.adminSet();
		insert adminSetting;
		system.assertNotEquals(0,adminSetting.size());//assert inserted Application__c

		Application__c testApplication = TestDataBuilder.createApplication();//create application
		testApplication.Response_Code__c = 'New';
		insert testApplication;
		system.assertNotEquals(null,testApplication.Id);//assert inserted Application__c

		Applicant__c testApplicant = new Applicant__c();
		testApplicant.Application__c = testApplication.Id;
        insert testApplicant;

        Application__c testApplication2 = TestDataBuilder.createApplication();//create application
		insert testApplication2;
		system.assertNotEquals(null,testApplication2.Id);//assert inserted Application__c

		Applicant__c testApplicant2 = new Applicant__c();
		testApplicant2.Application__c = testApplication2.Id;
		testApplicant2.Email_Address__c = 'test2@mail.com';
        insert testApplicant2;

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication);

		PageReference pageRef = Page.APP_Register;//ensure that APP_Register page is being tested
        pageRef.getParameters().put('id',testApplication.Id);
        Test.setCurrentPageReference(pageRef);

        APP_RegisterCC controller = new APP_RegisterCC(standardController);
        controller.email = '';
        controller.birthDate = 'Select';
        controller.birthMonth = 'Select';
        controller.dob = 'ERR8';
        controller.password = '';
        controller.validate();
        controller.email = 'test';
        controller.birthDate = '29';
        controller.birthMonth = '2';
        controller.birthYear = '1981';
        controller.dob = 'ERR6';
        controller.password = 'abcdefgh';
        controller.confirmPassword = 'abcdefgh';        
        controller.validate();
        controller.birthDate = '29';
        controller.birthMonth = '2';
        controller.birthYear = '1900';
        controller.dob = 'ERR7';
        controller.email = 'test2@mail.com';
        controller.em = 'ERR5';
        controller.password = 'test1234';
        controller.confirmPassword = 'test1234';
        controller.validate();
        controller.em = 'test2@mail.com';
        controller.validate();

        //System.assert(!controller.validate);
	}
}