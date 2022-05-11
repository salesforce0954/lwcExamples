@isTest
public class APP_GSD_Upsell_Ext_Test {
    
    @testSetup static void staticRecords() {
        List<Admin_Settings__c> testAdminSettings = TestDatabuilder.adminSet();
        insert testAdminSettings;

        TestDatabuilder.createResponsePageRiskGradeSettings();
        
        TestDataBuilder.createListInsurancePremiumVars();

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'New');
        insert responseCodeControl;
        system.assertEquals('New', responseCodeControl.Name);//assert inserted Response_Code_Control__c      

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true); 
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
        system.assertEquals(UserInfo.getProfileId(), profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c
    }
    
    static testMethod void retrieveApplicationUpsellTest() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
  		testApplication.EMI_with_Service_Fee__c = 110;
  		testApplication.Loan_Term__c = '2 years';
  		testApplication.Offered_Interest_Rate__c = 29.99;
        testApplication.Total_Loan_Amount__c = 10000;
  		testApplication.Loan_Term_Months__c = 24;
  		testApplication.Max_Capacity_Unsecured__c = 20000;
  		testApplication.Initial_Requested_Amount__c = 10000;
        insert testApplication;
        
        Test.StartTest();
            APP_GSD_Upsell_Ext upsell = new APP_GSD_Upsell_Ext();
            Application__c app = APP_GSD_BaseController.retrieveApplicationUpsell(testApplication.Id);
        Test.StopTest();
        
        System.assertEquals(testApplication.EMI_with_Service_Fee__c, app.EMI_with_Service_Fee__c);
        System.assertEquals(testApplication.Loan_Term__c, app.Loan_Term__c);
        System.assertEquals(testApplication.Offered_Interest_Rate__c, app.Offered_Interest_Rate__c);
        System.assertEquals(testApplication.Total_Loan_Amount__c, app.Total_Loan_Amount__c);
        System.assertEquals(testApplication.Initial_Requested_Amount__c, app.Initial_Requested_Amount__c);
    }
    
    static testMethod void recalculateApplicationTest() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
  		testApplication.EMI_with_Service_Fee__c = 110;
  		testApplication.Loan_Term__c = '2 years';
  		testApplication.Offered_Interest_Rate__c = 29.99;
        testApplication.Total_Loan_Amount__c = 10000;
  		testApplication.Loan_Term_Months__c = 24;
  		testApplication.Max_Capacity_Unsecured__c = 20000;
  		testApplication.Initial_Requested_Amount__c = 10000;
  		testApplication.Online_Self_serve_Upsell_Eligibility__c = true; 
  		testApplication.Online_Self_serve_Insurance_Eligibility__c = true;
  		testApplication.Credit_Score__c = 'A';
        insert testApplication;
        
        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;
		
		Rule_Set__c testRuleSet = TestDataBuilder.createPricingRuleSet(testProductVersion.Id);
		insert testRuleSet;
		
		Rate_Card__c rateCard = new Rate_Card__c();
        rateCard.Product_Version__c = testProductVersion.Id;
        rateCard.Channel__c = 'Broker';
        rateCard.Start_Date__c = Date.today()-1;
        rateCard.End_Date__c = Date.today()+1;
        insert rateCard;
        
        Rate__c rate = new Rate__c();
        rate.Rate_Card__c = rateCard.Id;
        rate.Credit_Score__c = 'A';
        rate.Principal_Minimum__c = 1000.00;
        rate.Principal_Maximum__c = 50000.00;
        rate.Rate__c = 17.99;
        insert rate;
		
		Rule__c testRule = TestDataBuilder.createRule1(null, testRuleSet.Id);
		testRule.Rate_Card__c = rateCard.Id;
		insert testRule;
		
		Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
		insert testProductItem;
		
		Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
		testCondition.Type__c = 'Free Text';
		testCondition.LHS_Object_Name__c = 'Application__c';
		testCondition.LHS_Field_Name__c = 'Response_Code__c';
		testCondition.Free_Text__c = 'Test';
		testCondition.Operation__c = '=';
		insert testCondition;
		
        Test.StartTest();
            APP_GSD_Upsell_Ext upsell = new APP_GSD_Upsell_Ext();
            Application__c app = APP_GSD_BaseController.recalculateApplication(testApplication.Id, 15000, '5 years');
        Test.StopTest();
        
        System.assertEquals(15000, app.Total_Loan_Amount__c);
        System.assertEquals('5 years', app.Loan_Term__c);
        System.assertEquals(60, app.Loan_Term_Months__c);
        System.assertEquals(rate.Rate__c, app.Offered_Interest_Rate__c);
        System.assertNotEquals(testApplication.EMI_with_Service_Fee__c, app.EMI_with_Service_Fee__c);
        System.assertNotEquals(testApplication.Offered_Repayments__c, app.Offered_Repayments__c);
        System.assertNotEquals(testApplication.Offered_Frequency_Repayments__c, app.Offered_Frequency_Repayments__c);
        System.assertEquals(true, app.Out_Of_Sync__c);
    }
    
    static testMethod void goToInsuranceTest() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;
        
        Test.StartTest();
            APP_GSD_Upsell_Ext upsell = new APP_GSD_Upsell_Ext();
            System.assertEquals(false, APP_GSD_BaseController.goToInsurance(testApplication.Id));
        Test.StopTest();
    }
}