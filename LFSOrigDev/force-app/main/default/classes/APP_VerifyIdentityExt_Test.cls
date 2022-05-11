@isTest
private class APP_VerifyIdentityExt_Test {

	static testMethod void constructorTest() {
		PageReference pageRef = Page.APP_VerifyIdentity;//ensure that APP_Eligibility page is being tested
        Test.setCurrentPageReference(pageRef);

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        Brand_Content__c testBrandContent = TestDataBuilder.createBrandContent(testBrand.Id);
        testBrandContent.Name = 'APP_VerifyIdentity';
        insert testBrandContent;

		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Test.StartTest();
            APP_VerifyIdentityExt verifyIdentity = new APP_VerifyIdentityExt();
        Test.StopTest();

        System.assertEquals(testBrandContent.Brand__c, testBrand.Id);
        System.assertEquals(verifyIdentity.consentText, testBrandContent.Output_HTML__c);
	}

	static testMethod void constructorWithApplicationTest() {
		PageReference pageRef = Page.APP_VerifyIdentity;//ensure that APP_Eligibility page is being tested
        Test.setCurrentPageReference(pageRef);

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        Brand_Content__c testBrandContent = TestDataBuilder.createBrandContent(testBrand.Id);
        testBrandContent.Name = 'APP_VerifyIdentity';
        testBrandContent.Output_HTML__c = null;
        insert testBrandContent;

		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);
            APP_VerifyIdentityExt verifyIdentity = new APP_VerifyIdentityExt();
        Test.StopTest();

        System.assertEquals(testBrandContent.Brand__c, testBrand.Id);
        System.assertEquals('', verifyIdentity.consentText);
        System.assertEquals(testApplicant.Application__c, testApplication.Id);
	}
}