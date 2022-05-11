@isTest
private class LoanPurposeTriggerHandlerTest {
	
	@isTest static void test_method_one() {

		List<Account> acctList = TestDataBuilder.createAccounts(1);
		insert acctList;

		Application__c app = TestDataBuilder.createApplication();
		insert app;

		Id rectypeIdONR = [select id from RecordType where name='Loan Purpose' and SObjectType='ONR__c'].Id;
		ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, rectypeIdONR);
		insert onr;

		Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(app.Id, null, 'Debt consolidation');
		insert lp;

		list<Meta_ONR__c> metaonr = TestDataBuilder.createMetaONRLoanPurpose();
		insert metaonr;

		System.assertEquals(app.Id, lp.Application__c);
	}

	@isTest static void test_method_two() {
		//LoanPurposeTriggerHandlerClass
		List<Account> acctList = TestDataBuilder.createAccounts(1);
		insert acctList;

		Application__c app = TestDataBuilder.createApplication();
		app.Channel__c = 'Broker';
		insert app;

		Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, app.Response_Code__c);
        insert testResponseCodeControl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

		Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(app.Id, null, GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE);
		insert lp;
		
		List<Insurance_Premium_Calculation_Variables__c> lst_InsurancePremiumCalculationVariable = TestDataBuilder.createInsurancePremiumCalculationVariables();
		insert lst_InsurancePremiumCalculationVariable;				

		Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(app.Id, lp.Id);
		insert testDisbursement;

		Test.StartTest();
			lp.Value__c = 'Test';
			update lp;
		Test.StopTest();

		List<Disbursement__c> dList = [SELECT Id FROM Disbursement__c WHERE Loan_Purpose__c =: lp.Id];

		System.assertEquals('Test', lp.Value__c);
		System.assertEquals(0, dList.size());
	}
}