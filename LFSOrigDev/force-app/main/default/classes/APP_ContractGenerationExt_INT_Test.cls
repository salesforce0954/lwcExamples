@isTest
public class APP_ContractGenerationExt_INT_Test {
    
    static testMethod void constructor_Test() {
		Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ContractGenerationExt_INT application = new APP_ContractGenerationExt_INT(standardCon);
            //application.pageRedirect();
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, application.application.Id);
        System.assertEquals(0, application.pfrCount);
        System.assertEquals(0, application.bmCount);
	}

	static testMethod void refresh_Test() {
		Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Compliance_Check__c> testComplianceCheckList = new List<Compliance_Check__c>();

        Compliance_Check__c testComplianceCheck = new Compliance_Check__c();
        testComplianceCheck.Application__c = testApplication.Id;
        testComplianceCheck.Pre_Contract_Indicator__c = true;
        testComplianceCheck.PFR_Check__c = 'Yes';
        testComplianceCheck.BM_Check__c = 'Yes';
        testComplianceCheckList.add(testComplianceCheck);

        Compliance_Check__c testComplianceCheck2 = new Compliance_Check__c();
        testComplianceCheck2.Application__c = testApplication.Id;
        testComplianceCheck2.Pre_Settlement_Indicator__c = true;
        testComplianceCheck2.PFR_Check__c = 'Yes';
        testComplianceCheck2.BM_Check__c = 'Yes';
        testComplianceCheckList.add(testComplianceCheck2);
        insert testComplianceCheckList;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ContractGenerationExt_INT application = new APP_ContractGenerationExt_INT(standardCon);
            application.refreshApplication();

        Test.StopTest();
        
        System.assertEquals(testApplication.Id, application.application.Id);
        System.assertEquals(testComplianceCheckList.size(), application.pfrCount);
        System.assertEquals(testComplianceCheckList.size(), application.bmCount);
	}
}