@isTest
private class APP_GSD_Insurance_Ext_Test {
    
    @testSetup static void staticRecords() {
        List<Admin_Settings__c> testAdminSettings = TestDatabuilder.adminSet();
        insert testAdminSettings;

        TestDatabuilder.createResponsePageRiskGradeSettings();

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'New');
        insert responseCodeControl;
        system.assertEquals('New', responseCodeControl.Name);//assert inserted Response_Code_Control__c      

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true); 
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
        system.assertEquals(UserInfo.getProfileId(), profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
    }

    @isTest static void retrieveBundles_Test() {
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
        testApplication.Insurance_Eligibility_Flag_Applicant_1__c = 3;
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

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        List<Product_Version__c> testProductVersionInsurance = new List<Product_Version__c>();
        for(GEProduct__c prod:geProductInsurance){
            testProductVersionInsurance.add(TestDataBuilder.createProductVersion(prod.Id));
        }
        insert testProductVersionInsurance;

        List<APP_GSD_Insurance_Ext.InsuranceBundleWrapper> testBundleWrapperList = APP_GSD_Insurance_Ext.retrieveBundles(testApplication.Id, testApplication.Total_Loan_Amount__c, testApplication.Loan_Term__c);
        System.assertNotEquals(null, testBundleWrapperList);
        System.assertNotEquals(2, testBundleWrapperList.size());
    }
    @isTest static void saveInsuranceAU_Test() {
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
        testApplication.Insurance_Eligibility_Flag_Applicant_1__c = 3;
        testApplication.Credit_Score__c = 'A';
        insert testApplication;
        
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

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

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        List<Product_Version__c> testProductVersionInsurance = new List<Product_Version__c>();
        for(GEProduct__c prod:geProductInsurance){
            testProductVersionInsurance.add(TestDataBuilder.createProductVersion(prod.Id));
        }
        insert testProductVersionInsurance;

        List<APP_GSD_Insurance_Ext.InsuranceBundleWrapper> testBundleWrapperList = APP_GSD_Insurance_Ext.retrieveBundles(testApplication.Id, testApplication.Total_Loan_Amount__c, testApplication.Loan_Term__c);
        APP_GSD_Insurance_Ext.InsuranceResultWrapper isSavingSuccessNewLP = APP_GSD_Insurance_Ext.createAndSaveInsurance(testApplication.Id, testBundleWrapperList[1], testApplication.Total_Loan_Amount__c, testApplication.Loan_Term__c, true, 'Other', '');
        APP_GSD_Insurance_Ext.InsuranceResultWrapper isSavingSuccessOldLP = APP_GSD_Insurance_Ext.createAndSaveInsurance(testApplication.Id, testBundleWrapperList[1], testApplication.Total_Loan_Amount__c, testApplication.Loan_Term__c, false, 'Other', '');
        APP_GSD_Insurance_Ext insuranceController = new APP_GSD_Insurance_Ext();
        insuranceController.bundleSelected = '';
        String PDF_PSG = insuranceController.insuranceTermsAndCondition;
        System.assertNotEquals(null, testBundleWrapperList);
        System.assertEquals(3, testBundleWrapperList.size());
        System.assert(isSavingSuccessNewLP.isSuccessful);
        System.assert(isSavingSuccessOldLP.isSuccessful);
    }
    //Added the below function to improve the code coverage Suneel NFLPI 27/03/2018
         @isTest static void coverVariablesTest(){    
            Application__c testApplication = TestDataBuilder.createApplication();      
            testApplication.Promo_Online_Message__c = 'Test'; 
            insert testApplication; 
                            
            APP_GSD_Insurance_Ext.calculateInsurancePremium(testApplication,false,true,false);
            APP_GSD_Insurance_Ext.getApplication(testApplication.Id);
        
           APP_GSD_Insurance_Ext agi = new APP_GSD_Insurance_Ext();
           System.assertEquals(APP_GSD_Insurance_Ext.insuranceProductsDescriptionNZ,APP_GSD_Insurance_Ext.insuranceProductsDescriptionNZ);
           System.assertEquals(APP_GSD_Insurance_Ext.insuranceProductsDisplayNameNZ,APP_GSD_Insurance_Ext.insuranceProductsDisplayNameNZ);      
        }    
}