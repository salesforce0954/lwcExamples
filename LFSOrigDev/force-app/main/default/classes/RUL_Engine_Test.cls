@isTest
public class RUL_Engine_Test {
    @TestSetup
    static void createData(){

        List<Inflight_Settings__c> inflightSettingList = new List<Inflight_Settings__c>();

        Inflight_Settings__c iflSet = new Inflight_Settings__c();
        iflSet.Name = 'CHG0033885';
        iflSet.Deployment_Date__c = Date.newInstance(2022, 01, 25);
        inflightSettingList.add(iflSet);

        insert inflightSettingList;
    }

    static testMethod void RuleEngine_Test() {
        //LHS > RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        
         // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end


        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '>';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void Fail_Test() {
        //No application response
        List<Id> appResponseIds = new List<Id>();

        Test.StartTest();
            try{
                RUL_Engine.runOfferEngine(appResponseIds);
            } catch (exception e){
                System.assert(e.getMessage().contains('No IDs have been passed in'), e.getMessage());
            }
        Test.StopTest();
    }

    static testMethod void RuleEngine_Test2() {
        //LHS < RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end


        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.RHS_Object_Name__c = 'Application_Response__c';
        testCondition.RHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.LHS_Object_Name__c = 'Application__c';
        testCondition.LHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '<';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test3() {
        //LHS != RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end


        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.RHS_Object_Name__c = 'Application_Response__c';
        testCondition.RHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.LHS_Object_Name__c = 'Application__c';
        testCondition.LHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '!=';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test4() {
        //LHS <= RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.RHS_Object_Name__c = 'Application_Response__c';
        testCondition.RHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.LHS_Object_Name__c = 'Application__c';
        testCondition.LHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '<=';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test5() {
        //LHS >= RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '>=';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test6() {
        //LHS = RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        testApplicationResponse.Max_Monthly_Capacity__c = testApplication.Total_Loan_Amount__c;
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '=';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test7() {
        //2 conditions AND
        //LHS = RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        testApplicationResponse.Max_Monthly_Capacity__c = testApplication.Total_Loan_Amount__c;
        testApplicationResponse.Min_Collateral_Amount__c = testApplication.Offered_Monthly_Loan_Service_Fee__c;
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '=';
        testCondition.Conjunction_to_Previous__c = 'AND';
        insert testCondition;

        Condition__c testCondition2 = TestDataBuilder.createCondition1(testRule.Id);
        testCondition2.Type__c = 'Field';
        testCondition2.LHS_Object_Name__c = 'Application_Response__c';
        testCondition2.LHS_Field_Name__c = 'Min_Collateral_Amount__c';
        testCondition2.RHS_Object_Name__c = 'Application__c';
        testCondition2.RHS_Field_Name__c = 'Offered_Monthly_Loan_Service_Fee__c';
        testCondition2.Operation__c = '=';
        insert testCondition2;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test8() {
        //2 conditions OR
        //LHS = RHS
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        testApplicationResponse.Max_Monthly_Capacity__c = testApplication.Total_Loan_Amount__c;
        testApplicationResponse.Min_Collateral_Amount__c = testApplication.Offered_Monthly_Loan_Service_Fee__c;
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '=';
        testCondition.Conjunction_to_Previous__c = 'OR';
        insert testCondition;

        Condition__c testCondition2 = TestDataBuilder.createCondition1(testRule.Id);
        testCondition2.Type__c = 'Field';
        testCondition2.LHS_Object_Name__c = 'Application_Response__c';
        testCondition2.LHS_Field_Name__c = 'Min_Collateral_Amount__c';
        testCondition2.RHS_Object_Name__c = 'Application__c';
        testCondition2.RHS_Field_Name__c = 'Offered_Monthly_Loan_Service_Fee__c';
        testCondition2.Operation__c = '=';
        insert testCondition2;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test9() {
        //No rules
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        testApplicationResponse.Max_Monthly_Capacity__c = testApplication.Total_Loan_Amount__c;
        testApplicationResponse.Min_Collateral_Amount__c = testApplication.Offered_Monthly_Loan_Service_Fee__c;
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();
        
        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }

    static testMethod void RuleEngine_Test10() {
        //Unsupported condition
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Field';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '=';
        testCondition.Conjunction_to_Previous__c = 'Test';
        insert testCondition;

        Condition__c testCondition2 = TestDataBuilder.createCondition1(testRule.Id);
        testCondition2.Type__c = 'Field';
        testCondition2.LHS_Object_Name__c = 'Application_Response__c';
        testCondition2.LHS_Field_Name__c = 'Min_Collateral_Amount__c';
        testCondition2.RHS_Object_Name__c = 'Application__c';
        testCondition2.RHS_Field_Name__c = 'Offered_Monthly_Loan_Service_Fee__c';
        testCondition2.Operation__c = '=';
        insert testCondition2;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            try{
                RUL_Engine.runOfferEngine(appResponseIds);
            } catch (exception e){
                System.assert(e.getMessage().contains('Unsupported or missing conjunction'), e.getMessage());
            }
        Test.StopTest();
    }

    static testMethod void RuleEngine_Test11() {
        //Free text
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
           // Added as part of AU APOI
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
         
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        
        List<Insurance_Premium_Calculation_Variables__c> testInsuranceVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert testInsuranceVariables;

        Application_Response__c testApplicationResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testApplicationResponse;

        Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Id newProductOffer = Schema.SObjectType.Offer__c.getRecordTypeInfosByName().get('New Product Offer').getRecordTypeId();
        Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Secured Upsell', newProductOffer);
        insert testOffer;

        Offer_Presented__c testOfferPresented = TestDataBuilder.createOfferPresented(testOffer.Id, testApplicationResponse.Id);
        insert testOfferPresented;

        Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
        insert testRule;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
        testCondition.Type__c = 'Free Text';
        testCondition.LHS_Object_Name__c = 'Application_Response__c';
        testCondition.LHS_Field_Name__c = 'Max_Monthly_Capacity__c';
        testCondition.RHS_Object_Name__c = 'Application__c';
        testCondition.RHS_Field_Name__c = 'Total_Loan_Amount__c';
        testCondition.Operation__c = '=';
        testCondition.Free_Text__c = 'Test';
        insert testCondition;

        List<Id> appResponseIds = new List<Id>();
        appResponseIds.add(testApplicationResponse.Id);

        Test.StartTest();
            RUL_Engine.runOfferEngine(appResponseIds);
        Test.StopTest();

        List<Offer_Presented__c> offersPresentedList = [SELECT Id FROM Offer_Presented__c WHERE Application_Response__c =: testApplicationResponse.Id];
        System.assertEquals(true, !offersPresentedList.isEmpty());
    }
    
    static testMethod void RuleEngine_Test12() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        insert testApplication;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, null, 'Refinance');
        insert testLoanPurpose;
        Id refinanceRTId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PA');
        insert testResponseCodeControl;
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
        testDisbursement.RecordTypeId = refinanceRTId;
        testDisbursement.Amount__c = 100;
        testDisbursement.Interest_Rate__c = 10;
        insert testDisbursement;
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
        rate.Principal_Maximum__c = 4000.00;
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
        testCondition.Free_Text__c = 'PA';
        testCondition.Operation__c = '=';
        insert testCondition;
        List<Id> appIds = new List<Id>();
        appIds.add(testApplication.Id);
        Test.StartTest();
            RUL_Engine.runPricingEngineAsync(appIds);
        Test.StopTest();
        Application__c updatedApplication = [SELECT Offered_Interest_Rate__c FROM Application__c WHERE Id =: testApplication.Id];
    }
    
    static testMethod void RuleEngine_Test12NZ() {
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        insert testApplication;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, null, 'Refinance');
        insert testLoanPurpose;
        Id refinanceRTId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PA');
        insert testResponseCodeControl;
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
        testDisbursement.RecordTypeId = refinanceRTId;
        testDisbursement.Amount__c = 100;
        testDisbursement.Interest_Rate__c = 10;
        insert testDisbursement;
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
        rate.Principal_Maximum__c = 4000.00;
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
        testCondition.Free_Text__c = 'PA';
        testCondition.Operation__c = '=';
        insert testCondition;
        List<Id> appIds = new List<Id>();
        appIds.add(testApplication.Id);
        Test.StartTest();
            RUL_Engine.runPricingEngineAsync(appIds);
        Test.StopTest();
        Application__c updatedApplication = [SELECT Offered_Interest_Rate__c FROM Application__c WHERE Id =: testApplication.Id];
    }

    static testMethod void RuleEngine_Test13() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        testApplication.Offered_Interest_Rate_Orig__c = 10;
        testApplication.Offered_Interest_Rate__c = 10;
        testApplication.Adjusted_Interest_Rate__c = 10;
        insert testApplication;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, null, 'Refinance');
        insert testLoanPurpose;
        Id refinanceRTId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PA');
        insert testResponseCodeControl;
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
        testDisbursement.RecordTypeId = refinanceRTId;
        testDisbursement.Amount__c = 100;
        testDisbursement.Interest_Rate__c = 10;
        insert testDisbursement;
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
        rate.Principal_Maximum__c = 4000.00;
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
        testCondition.Free_Text__c = 'PA';
        testCondition.Operation__c = '=';
        insert testCondition;
        List<Id> appIds = new List<Id>();
        appIds.add(testApplication.Id);
        Test.StartTest();
            RUL_Engine.runPricingEngineAsync(appIds);
        Test.StopTest();
        Application__c updatedApplication = [SELECT Offered_Interest_Rate__c FROM Application__c WHERE Id =: testApplication.Id];
    }


    static testMethod void RuleEngine_Test14() {
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        testApplication.Offered_Interest_Rate_Orig__c = 10;
        testApplication.Offered_Interest_Rate__c = 10;
        testApplication.Adjusted_Interest_Rate__c = 10;
        insert testApplication;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, null, 'Refinance');
        insert testLoanPurpose;
        Id refinanceRTId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PA');
        insert testResponseCodeControl;
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
        testDisbursement.RecordTypeId = refinanceRTId;
        testDisbursement.Amount__c = 100;
        testDisbursement.Interest_Rate__c = 10;
        insert testDisbursement;
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
        rate.Principal_Maximum__c = 4000.00;
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
        testCondition.Free_Text__c = 'PA';
        testCondition.Operation__c = '=';
        insert testCondition;
        List<Id> appIds = new List<Id>();
        appIds.add(testApplication.Id);
        Test.StartTest();
            RUL_Engine.runPricingEngineAsync(appIds);
        Test.StopTest();
        Application__c updatedApplication = [SELECT Offered_Interest_Rate__c FROM Application__c WHERE Id =: testApplication.Id];
    }

    @IsTest
    static void testBlendedRate(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        testApplication.Offered_Interest_Rate_Orig__c = 10;
        testApplication.Offered_Interest_Rate__c = 10;
        testApplication.Adjusted_Interest_Rate__c = 10;
        insert testApplication;        

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;  

        Test.startTest();
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
        RUL_Engine.getBlendedRate(100, 100, 100, new List<Disbursement__c>{testDisbursement});
        Test.stopTest();
    }

    @IsTest
    static void testGetPromoInterest() {
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Credit_Score__c = 'A';
        testApplication.Total_Loan_Amount__c = 8000;
        testApplication.Offered_Interest_Rate_Orig__c = 10;
        testApplication.Offered_Interest_Rate__c = 10;
        testApplication.Adjusted_Interest_Rate__c = 10;
        insert testApplication;        

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;  

        Test.startTest();
        RUL_Engine.getPromoInterest(new List<Application__c>{testApplication});
        Test.stopTest();        
    }

    @IsTest
    static void testHigherSixtyDCRate() {
        RUL_Engine.higherSixtyDCRate(100,100,true);
        RUL_Engine.higherSixtyDCRate(100,100,false);
    }
}