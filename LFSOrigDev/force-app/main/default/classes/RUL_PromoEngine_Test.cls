@isTest
public class RUL_PromoEngine_Test{
    
    @testSetup static void staticRecords(){
        List<Meta_ONR__c> loanPurposeValues = TestDataBuilder.createMetaONRLoanPurpose();
        insert loanPurposeValues;
        
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.Interest_Rate__c = 12.34;
        testPromo.Establishment_Fee__c = 234;
        testPromo.Home_Owner__c = true;
        testPromo.Employment__c = true;
        testPromo.Minimum_Employment_Years__c = 1;
        testPromo.Minimum_Employment_Months__c = 1;
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 1){
                    c.LHS_Field_Name__c = 'Total_Loan_Amount_New_Cash_Without_Fees__c';
                    c.Operation__c = '>';
                    c.Free_Text__c = '3000';
                } else if(r.Order__c == 2){
                    c.Free_Text__c = 'Car Loan';
                } else if(r.Order__c == 3){
                    c.Free_Text__c = 'A';
                }
                testConditions.add(c);
            }
        }
        
        update testConditions;
    }
    
    static testMethod void singleNoPromoIdTest(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
                                             
        System.assertEquals(12.34, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(234, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void singleWithPromoIdTest(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_ID__c =  'test1234';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
                                             
        System.assertEquals(12.34, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(234, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void singlePromoIdDoesNotExistTest(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_ID__c =  '1234test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
        
        System.assertEquals(12.34, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(234, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals('Application does not meet promo criteria but will qualify for different promo which has been updated', applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void singlePromoNotEligibleTest(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_ID__c =  '1234test';
        testApplication.Promotional_Campaign__c = 'Special Promotion';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
        
        System.assertNotEquals(12.34, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertNotEquals(234, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertNotEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals('Application does not meet promo criteria and regular lending policies and pricing apply', applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void singlePromoRateReductionTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        testCampaign.get(0).Campaign_ID__c = '1111';
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.Interest_Rate__c = 5;
        testPromo.Establishment_Fee__c = 234;
        testPromo.Margin_Reduction__c = true;
        testPromo.Promo_ID__c = '4321test';
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 1){
                    c.LHS_Field_Name__c = 'Total_Loan_Amount_New_Cash_Without_Fees__c';
                    c.Operation__c = '=';
                    c.Free_Text__c = '3000.00';
                } else if(r.Order__c == 3){
                    c.Free_Text__c = 'A';
                }
                testConditions.add(c);
            }
        }
        
        update testConditions;
        
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 3000.00;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_ID__c =  '4321test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
        
        System.assertEquals(5, applicationMap.get(testApplication.Id).Interest_Reduction__c);
        System.assertEquals(234, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void multiPromoTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        testCampaign.get(0).Campaign_ID__c = '1111';
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.Interest_Rate__c = 9.99;
        testPromo.Establishment_Fee__c = 199;
        testPromo.Promo_ID__c = '4321test';
        testPromo.Promo_Start__c = Date.today()+1;
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 1){
                    c.LHS_Field_Name__c = 'Total_Loan_Amount_New_Cash_Without_Fees__c';
                    c.Operation__c = '!=';
                    c.Free_Text__c = '3000.00';
                } else if(r.Order__c == 3){
                    c.Free_Text__c = 'A;B;C';
                }
                testConditions.add(c);
            }
        }
        
        update testConditions;
        
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 5000.00;
        testApplication.Credit_Score__c = 'A';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
        
        System.assertEquals(9.99, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(199, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void auTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
        
        System.assertEquals(true, applicationMap.keySet().isEmpty());
        System.assertEquals(true, applicationMap.values().isEmpty());
    }
    
    static testMethod void dmPromoTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        testCampaign.get(0).Campaign_ID__c = '1111';
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.Interest_Rate__c = 9.99;
        testPromo.Establishment_Fee__c = 199;
        testPromo.Promo_ID__c = '4321test';
        testPromo.Promo_Start__c = Date.today()+1;
        testPromo.DM__c = true;
        insert testPromo;
        
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_ID__c =  '4321test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
                                             
        System.assertEquals(9.99, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(199, applicationMap.get(testApplication.Id).Offered_Establishment_Fee__c);
        System.assertEquals('Special Promotion', applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
    }
    
    static testMethod void promoIneligibleTest(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;
        testApplication.Initial_Submit_Date__c = Datetime.now();
        testApplication.Total_Loan_Amount__c = 4000;
        testApplication.Credit_Score__c = 'A';
        testApplication.Promo_Ineligible__c = true;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Own a home outright';
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        testLoanPurpose.Value__c = 'Car Loan';
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        
        List<Application__c> applicationList = new List<Application__c>();
        applicationList.add(testApplication);
        
        Test.StartTest();
        Map<Id, Application__c> applicationMap = RUL_PromoEngine.runPromoEngine(applicationList);
        Test.StopTest();
                                             
        System.assertEquals(null, applicationMap.get(testApplication.Id).Offered_Interest_Rate__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_ID__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promotional_Campaign__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Promo_Message__c);
        System.assertEquals(null, applicationMap.get(testApplication.Id).Interest_Reduction__c);
        System.assertEquals(false, applicationMap.get(testApplication.Id).Promo_Blending__c);
    }
}