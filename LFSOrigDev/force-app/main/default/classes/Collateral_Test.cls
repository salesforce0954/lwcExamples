/*
* @Description: APP_CollateralCC_INT, CollateralTriggerHandler, CollateralTrigger test class
* @Author: Jade Serrano
* @Date Created: 04-MAR-2014
* @History:
*  =====================================================================
*      Jade - 04-MAR-2014: Created
*	   Jade - 18-MAR-2014: Added CollateralTriggerHandler and CollateralTrigger test class
*  =====================================================================
*/
@isTest
private class Collateral_Test {
	
	@isTest static void test_method_one() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		system.assertEquals(collateral.Application__c,application.Id);//assert inserted Collateral__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Collateral_INT;//ensure that APP_Collateral_INT page is being tested
        pageRef.getParameters().put('id',collateral.Id);
        Test.setCurrentPageReference(pageRef);

        APP_CollateralCC_INT controller = new APP_CollateralCC_INT(standardController);

        controller.refresh();
        controller.getTotalCollateralValue();

	}
	
	@isTest static void test_method_two() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;				

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;
        
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, String.valueOf(application.Response_Code__c));
		insert responseCodeControl;
		system.assertEquals(String.valueOf(application.Response_Code__c),responseCodeControl.Name);//assert inserted Response_Code_Control__c

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		system.assertEquals(collateral.Application__c,application.Id);//assert inserted Collateral__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Collateral_INT;//ensure that APP_Collateral_INT page is being tested
        pageRef.getParameters().put('id',collateral.Id);
        Test.setCurrentPageReference(pageRef);

        APP_CollateralCC_INT controller = new APP_CollateralCC_INT(standardController);

	}

	@isTest static void test_method_three() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PC');
		insert responseCodeControl;
		system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'PC';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		system.assertEquals(collateral.Application__c,application.Id);//assert inserted Collateral__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Collateral_INT;//ensure that APP_Collateral_INT page is being tested
        pageRef.getParameters().put('id',collateral.Id);
        Test.setCurrentPageReference(pageRef);

        APP_CollateralCC_INT controller = new APP_CollateralCC_INT(standardController);
		
	}

	@isTest static void test_method_four() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;
        
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false,'PC');//false
		insert responseCodeControl;
		system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'PC';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		update collateral;
		system.assertEquals(collateral.Application__c,application.Id);//assert inserted Collateral__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Collateral_INT;//ensure that APP_Collateral_INT page is being tested
        pageRef.getParameters().put('id',collateral.Id);
        Test.setCurrentPageReference(pageRef);

        APP_CollateralCC_INT controller = new APP_CollateralCC_INT(standardController);
		
	}

	@isTest static void test_method_four_b() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false,'PC');//false
		insert responseCodeControl;
		system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'PC';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		delete collateral;
		
	}

	@isTest static void test_method_five() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);
		insert collateral;
		system.assertEquals(collateral.Application__c,application.Id);//assert inserted Collateral__c

		Collateral__c collateral2 = TestDataBuilder.createCollateral(application.Id);//fire collateral validation		
		try{
			insert collateral2;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('You have exceeded the collateral maximum items'), e.getMessage());//assert error message
		}		

	}

	@isTest static void test_method_six() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);//fire collateral validation	
		collateral.Collateral_Val__c = 10;
		try{
			insert collateral;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('Collateral value must be greater than or equal to collateral setting minimum value'), e.getMessage());//assert error message
		}	

	}

	@isTest static void test_method_seven() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);//fire collateral validation	
		collateral.Collateral_Val__c = 130000;
		try{
			insert collateral;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('Collateral value must be less than or equal to collateral setting maximum value'), e.getMessage());//assert error message
		}

	}

	@isTest static void test_method_eight() {
		List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Collateral', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Collateral',objectDefinition.Name);//assert inserted Object_Definition__c

		Insurance_Premium_Calculation_Variables__c counter = TestDataBuilder.createInsurancePremium();
		insert counter;
		system.assertEquals('counter',counter.Name);//assert inserted Insurance_Premium_Calculation_Variables__c

		Collateral_Settings__c collateralSettings = TestDataBuilder.createCollateralSetting();
		insert collateralSettings;
		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
		system.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY,collateralSettings.Name);//assert inserted Collateral_Settings__c

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

		Collateral__c collateral = TestDataBuilder.createCollateral(application.Id);//fire collateral validation	
		collateral.Collateral_Year__c = '1700';
		try{
			insert collateral;
		}catch(DmlException e){
			System.assert(e.getMessage().contains('Collateral year must be less than or equal to collateral setting new age'), e.getMessage());//assert error message
		}

	}

}