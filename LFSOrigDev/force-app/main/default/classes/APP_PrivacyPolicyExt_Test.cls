@isTest
private class APP_PrivacyPolicyExt_Test {

	static testMethod void constructorTest() {
		PageReference pageRef = Page.APP_PrivacyPolicy;
        Test.setCurrentPageReference(pageRef);

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        Brand_Content__c testBrandContent = TestDataBuilder.createBrandContent(testBrand.Id);
        testBrandContent.Name = GEN_OriginationsConstants.BRAND_CONTENT_PRIVACY_POLICY;
        insert testBrandContent;

        Test.StartTest();
            APP_PrivacyPolicyExt privacyPolicy = new APP_PrivacyPolicyExt();
        Test.StopTest();

        System.assertEquals(testBrandContent.Brand__c, testBrand.Id);
        System.assertEquals(privacyPolicy.policyText, testBrandContent.Output_HTML__c);
	}

    static testMethod void constructorNoContentTest() {
        PageReference pageRef = Page.APP_PrivacyPolicy;
        Test.setCurrentPageReference(pageRef);

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        Brand_Content__c testBrandContent = TestDataBuilder.createBrandContent(testBrand.Id);
        testBrandContent.Name = GEN_OriginationsConstants.BRAND_CONTENT_PRIVACY_POLICY;
        testBrandContent.Output_HTML__c = null;
        insert testBrandContent;

        Test.StartTest();
            APP_PrivacyPolicyExt privacyPolicy = new APP_PrivacyPolicyExt();
        Test.StopTest();

        System.assertEquals(testBrandContent.Brand__c, testBrand.Id);
        System.assertEquals('', privacyPolicy.policyText);
    }
}