@isTest
public class APP_ContractAcceptanceExt_INT_Test {
	static testMethod void constructor_Test(){
		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
			testApplicant.Is_Primary_Applicant__c = true;
		insert testApplicant;

		Test.StartTest();
			ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
			APP_ContractAcceptanceExt_INT contract = new APP_ContractAcceptanceExt_INT(standardCon);
		Test.StopTest();

		System.assertEquals(testApplication.Id, testApplicant.Application__c);
		System.assert(testApplicant.Is_Primary_Applicant__c);
	}
}