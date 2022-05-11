/*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 03/07/2014
    Description: Test Class for APP_LeftSideBarExt
*/
@isTest
public class APP_LeftSideBarExt_Test {
    @testSetup static void staticVariables(){
        List<Admin_Settings__c> testAdminSettings = TestDatabuilder.adminSet();
        insert testAdminSettings;
    }
	static testMethod void constructorTestWithJointApplication(){
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
		Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        	testInsurance.Name = 'lifeInsPremRate';
        insert testInsurance;

        Insurance_Premium_Calculation_Variables__c testInsurance2 = TestDataBuilder.createInsurancePremium();
        insert testInsurance2;

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Type__c = 'Insurance';
        insert testProduct;

        Collateral_Settings__c testCollateralSetting = TestDataBuilder.createCollateralSetting();
        	testCollateralSetting.Name = testBrand.Name;
        insert testCollateralSetting;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
			testApplication.Settlement_Date__c = Date.Today();
			testApplication.Brand_Lookup__c = testBrand.Id;
			testApplication.Brand_String__c = testBrand.Name;
		insert testApplication;

        Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		insert testApplicant;

		Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
			testCollateral.Application__c = testApplication.Id;
		insert testCollateral;

		Test.StartTest();

			ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LeftSideBarExt leftSideBar = new APP_LeftSideBarExt(standardCon);

		Test.StopTest();

        System.assertEquals(testApplication.Id, leftSideBar.application.Id);
	}
	static testMethod void constructorTestWithSingleApplication(){
		Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        	testInsurance.Name = 'lifeInsPremRate';
        insert testInsurance;

        Insurance_Premium_Calculation_Variables__c testInsurance2 = TestDataBuilder.createInsurancePremium();
        insert testInsurance2;

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Collateral_Settings__c testCollateralSetting = TestDataBuilder.createCollateralSetting();
        	testCollateralSetting.Name = testBrand.Name;
        insert testCollateralSetting;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        	testProduct.Type__c = 'Insurance';
        insert testProduct;

        List<Branch__c> testBranch = TestDataBuilder.createBranch(1);
        insert testBranch;
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
			testApplication.Settlement_Date__c = Date.Today().addDays(-5);
			testApplication.Max_Capacity_Secured__c = 100;
			testApplication.Max_Capacity_Unsecured__c = 100;
			testApplication.Total_Loan_Amount__c = null;
			testApplication.Credit_Score__c = 'A';
			testApplication.Max_Monthly_Capacity__c = 100;
			testApplication.Branch__c = testBranch[0].Id;
			testApplication.Application_Type__c = 'Joint';
			testApplication.Settlement_Date__c = null;
			testApplication.Status__c = null;
			testApplication.Workflow_Status__c = null;
		insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		insert testApplicant;

		Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
			testApplicant2.Is_Primary_Applicant__c = false;
		insert testApplicant2;

		Test.StartTest();

			ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LeftSideBarExt leftSideBar = new APP_LeftSideBarExt(standardCon);

		Test.StopTest();

        System.assertEquals(testApplication.Id, leftSideBar.application.Id);
	}
	
	static testMethod void Application_Test(){
	    //No offered interest rate
	    //With loan term
	    //No max monthly capacity
	    //Owner is queue
	    //Settlement date < today
	    //With workflow status
	    //With insurance
	    
	    Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
    	testInsurance.Name = 'lifeInsPremRate';
        insert testInsurance;

        Insurance_Premium_Calculation_Variables__c testInsurance2 = TestDataBuilder.createInsurancePremium();
        insert testInsurance2;

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Collateral_Settings__c testCollateralSetting = TestDataBuilder.createCollateralSetting();
    	testCollateralSetting.Name = testBrand.Name;
        insert testCollateralSetting;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
    	testProduct.Type__c = 'Insurance';
        insert testProduct;

        List<Branch__c> testBranch = TestDataBuilder.createBranch(1);
        insert testBranch;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'AU_Inbound_Queue' LIMIT 1];
		
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Offered_Interest_Rate__c = null;
        testApplication.Loan_Term__c = '2 years';
        testApplication.Max_Monthly_Capacity__c = null;
        testApplication.OwnerId = queue.Id;
        testApplication.Settlement_Date__c = Date.Today().addDays(-5);
        testApplication.Workflow_Status__c = 'test';
        testApplication.Max_Capacity_Secured__c = 1000;
		testApplication.Max_Capacity_Unsecured__c = 100;
		insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		insert testApplicant;

		Test.StartTest();

			ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LeftSideBarExt leftSideBar = new APP_LeftSideBarExt(standardCon);

		Test.StopTest();

        System.assertEquals(testApplication.Id, leftSideBar.application.Id);
	}
}