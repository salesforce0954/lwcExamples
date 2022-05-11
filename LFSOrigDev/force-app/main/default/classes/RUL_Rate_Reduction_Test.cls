@isTest
public class RUL_Rate_Reduction_Test {
	static testMethod void RateReduction_Test() {
        //No application response
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

		RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

		Test.StartTest();
			rateReduction.rateReductionWithoutAppResponse(applicationDTO);
		Test.StopTest();

		System.assertEquals(rateReduction.rateReductionWithoutAppResponse(applicationDTO), testApplication.Offered_Interest_Rate__c);
	}

    static testMethod void RateReduction_Test2() {
        //No application response
        //With adjusted interest rate
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        insert testApplication;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithoutAppResponse(applicationDTO);
        Test.StopTest();

        System.assertEquals(rateReduction.rateReductionWithoutAppResponse(applicationDTO), testApplication.Adjusted_Interest_Rate__c);
    }

    static testMethod void RateReduction_Test3() {
        //No application response
        //With adjusted interest rate
        //With offered interest rate less than adjusted interest rate
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate__c = 3;
        insert testApplication;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithoutAppResponse(applicationDTO);
        Test.StopTest();

        System.assertEquals(rateReduction.rateReductionWithoutAppResponse(applicationDTO), testApplication.Offered_Interest_Rate__c);
    }

    static testMethod void RateReduction_Test4() {
        //With application response
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end


        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithAppResponse(applicationDTO);
        Test.StopTest();

        System.assertEquals(rateReduction.rateReductionWithAppResponse(applicationDTO), 0);
    }

    static testMethod void RateReduction_Test5() {
        //With application response
        //With adjusted interest rate == offered interest rate
        //No adjusted interest rate reason
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate__c = 5;
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithAppResponse(applicationDTO);
        Test.StopTest();

        System.assertEquals(rateReduction.rateReductionWithAppResponse(applicationDTO), 0);
    }

    static testMethod void RateReduction_Test6() {
        //With application response
        //With adjusted interest rate == offered interest rate
        //With adjusted interest rate > newOfferedRate
        //With adjusted interest rate reason (set 1)
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate_Orig__c = 5;
        testApplication.Adjusted_Interest_Rate_Reason__c = 'VIP';
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithAppResponse(applicationDTO);
        Test.StopTest();

        //System.assertEquals(rateReduction.rateReductionWithAppResponse(applicationDTO), testApplication.Adjusted_Interest_Rate__c);
        System.assertEquals(5, testApplication.Adjusted_Interest_Rate__c);
    }

    static testMethod void RateReduction_Test7() {
        //With application response
        //With adjusted interest rate == offered interest rate
        //With adjusted interest rate > newOfferedRate
        //With adjusted interest rate reason (set 2)
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate__c = 5;
        testApplication.Adjusted_Interest_Rate_Reason__c = 'Mango % Rule';
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithAppResponse(applicationDTO);
        Test.StopTest();

        System.assertEquals(rateReduction.rateReductionWithAppResponse(applicationDTO), 0);
    }
}