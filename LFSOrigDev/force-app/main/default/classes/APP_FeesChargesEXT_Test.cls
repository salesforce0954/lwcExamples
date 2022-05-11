@isTest
private class APP_FeesChargesEXT_Test {

	static testMethod void feesChargesTest() {
		//Adjusted interest fee unlocked
		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_FeesChargesEXT fees = new APP_FeesChargesEXT(standardCon);
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(fees.ppsrSearchFee, String.valueOf(testApplication.Offered_PPSR_Search_Fee__c));
        System.assertEquals(fees.ppsrRegistrationFee, String.valueOf(testApplication.Offered_PPSR_Registration_Fee__c));
        System.assertEquals(fees.establishmentFee, String.valueOf(testApplication.Offered_Establishment_Fee_Orig__c));
	}

	static testMethod void feesChargesTest2() {
		//Adjusted interest fee locked
		Application__c testApplication = TestDataBuilder.createApplication();
		testApplication.Adjusted_Interest_Fee_Locked__c = true;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_FeesChargesEXT fees = new APP_FeesChargesEXT(standardCon);
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(fees.ppsrSearchFee, String.valueOf(testApplication.Offered_PPSR_Search_Fee__c));
        System.assertEquals(fees.ppsrRegistrationFee, String.valueOf(testApplication.Offered_PPSR_Registration_Fee__c));
        System.assertEquals(fees.establishmentFee, String.valueOf(testApplication.Offered_Establishment_Fee__c));
	}
}