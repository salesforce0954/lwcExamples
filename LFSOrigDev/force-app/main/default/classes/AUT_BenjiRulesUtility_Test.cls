@isTest
public class AUT_BenjiRulesUtility_Test {
	private static final Id RECORDTYPEID_MOTOR_VEHICLE_NZ = Schema.SObjectType.Collateral__c.getRecordTypeInfosByName().get('Motor Vehicle NZ').getRecordTypeId();
	
	@testSetup static void testStaticData(){
		
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
        	testCollateralSettings.Name = 'GEM';
        	testCollateralSettings.Collateral_Minimum_Value__c = 0;
        	testCollateralSettings.Collateral_New_Age__c = 30;
        insert testCollateralSettings;


        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, 'PA');
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

	}

	static testMethod void benjiRulesValidation_Fail_Car_Purchase(){

        Brand__c testBrand = TestDataBuilder.createBrand();
        	testBrand.Name = 'GEM';
        	testBrand.Country__c = 'NZ';
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id, GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN, 'GEM Auto Loan');
        	testProduct.Security_Ratio__c = 0.01;
        	testProduct.Security_Value__c = 1.00;
        	testProduct.Age_of_Car__c = 20;
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
        	testApplication.Last_Webservice_Operation_Invoked__c = 'Update Application';
        	testApplication.Type_of_Product__c = GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN;
        	testApplication.Initial_Submit_Date__c = DateTime.now();
        	testApplication.Brand_String__c = 'GEM';
        insert testApplication;

        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        	testLoanPurpose.Value__c = 'Other';
        insert testLoanPurpose;

		Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
			testCollateral.RecordTypeId = RECORDTYPEID_MOTOR_VEHICLE_NZ;
			testCollateral.Collateral_Make__c = 'HONDA';
			testCollateral.Collateral_Model__c = 'City';
			testCollateral.Collateral_Year__c = String.valueOf(Date.today().Year() - 30);
			testCollateral.Collateral_Body_Type__c = 'SEDAN';
			testCollateral.Collateral_Val__c = 0.1;
			testCollateral.Collateral_Owner__c = 'Applicant 1';
			testCollateral.Collateral_Date_Valued__c = Date.Today();
		insert testCollateral;


		Test.StartTest();
			Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
			insert testAppResponse;
		Test.StopTest();

		Application__c updatedApplication = [SELECT Id, Benji_Rule_Results__c FROM Application__c WHERE Id =: testApplication.Id];
		System.assertEquals(GEN_OriginationsConstants.AUTO_RULE_FAIL_CAR_PURCHASE, updatedApplication.Benji_Rule_Results__c);
	}
}