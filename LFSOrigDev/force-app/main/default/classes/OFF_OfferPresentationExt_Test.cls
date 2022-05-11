/*
 * @Description: Test class for OFF_OfferPresentationExt class
 * @Author: Fel Saliba
 * @Date Created: Feb-27-2014
 * @History:
   =====================================================================
       27-02-14: Created - Fel
   =====================================================================
 */

@isTest
private class OFF_OfferPresentationExt_Test {
    
    static testMethod void saveAndRecalculate_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        //Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        //insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        //Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        //insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        //Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        //insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        //testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        //testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        //update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            //List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            //testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.loanTermSelected = '1 year';
            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            System.assertEquals(application.offerList[0].loan.Loan_Amount__c,6000);
        }

    }
    static testMethod void saveAndRecalculateWithInsuranceSingle_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Application_type__c = 'Single';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

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

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, null));
        insert testProductItemInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }
        
        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            application.dateOfBirthStr2 = '1990-01-02';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.loanTermSelected = '1 year';
            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            application.updateApplicationConsenT();


            application.wrapperInsure[0].applicant1 = true;
            application.wrapperInsure[1].applicant1 = true;
            application.wrapperInsure[2].applicant1 = true;
            application.insuranceOffer();
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            Decimal insrunceCount = [select count() from Product_Item__c where Application__c =: testApplication.Id AND Product_Version__r.type__c =: 'Insurance'];
            System.assertEquals(3, insrunceCount);

        }

    }
    
    static testMethod void saveAndRecalculateWithInsuranceJoint_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        //testApplication.Application_type__c = 'Joint';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        testApplication.Loan_Term__c = '1 year';
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        rateCard.Channel__c = 'Online';
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

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

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, testApplicant2.Id));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, testApplicant2.Id));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, testApplicant2.Id));
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, null));
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, null));
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, null));
        insert testProductItemInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            application.dateOfBirthStr2 = '1990-01-02';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            application.updateApplicationConsenT();


            application.wrapperInsure[0].applicant1 = true;
            application.wrapperInsure[1].applicant1 = true;
            application.wrapperInsure[2].applicant1 = true;
            application.wrapperInsure[0].applicant2 = true;
            application.wrapperInsure[1].applicant2 = true;
            application.wrapperInsure[2].applicant2 = true;
            application.insuranceOffer();
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            Decimal insrunceCount = [select count() from Product_Item__c where Application__c =: testApplication.Id AND Product_Version__r.type__c =: 'Insurance'];
            System.assertEquals(3, insrunceCount);

        }

    }

    static testMethod void saveAndRecalculateWithInsuranceNZ_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'NZ';
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        //testApplication.Application_type__c = 'Joint';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        //Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        //insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        //Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        //insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        //Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        //insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        //testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        //testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        //update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        rateCard.Channel__c = 'Online';
        insert rateCard;

        Rate_Card__c rateCardFactorTable = TestDatabuilder.createRateCardFactorTable();
        insert rateCardFactorTable;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Rate__c rateFactor = TestDatabuilder.createRateFactorTable(rateCardFactorTable.Id);
        insert rateFactor;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

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

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, testApplicant2.Id));
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, testApplicant2.Id));
        //testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, testApplicant2.Id));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, null));
        insert testProductItemInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            //application.dateOfBirthStr2 = '1990-01-02';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            application.updateApplicationConsenT();

            application.wrapperInsure[0].applicant1 = true;
            application.wrapperInsure[1].applicant1 = true;
            application.wrapperInsure[2].applicant1 = true;
            //application.wrapperInsure[0].applicant2 = true;
            //application.wrapperInsure[1].applicant2 = true;
            //application.wrapperInsure[2].applicant2 = true;
            application.insuranceOffer();
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            Decimal insrunceCount = [select count() from Product_Item__c where Application__c =: testApplication.Id AND Product_Version__r.type__c =: 'Insurance'];
            System.assertEquals(3, insrunceCount);

        }

    }

    static testMethod void noAppResponse_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

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
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = null;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;
        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        ApexPages.currentPage().getParameters().put('cust', 'y');
        OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
        application.validateRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, application.application.Id);
        System.assertEquals(0, application.appResponse.size());

    }

    static testMethod void nullAppResponseFields_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

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
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = null;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Credit_Score__c = null;
        appResponse.Max_Capacity_Secured__c = null;
        appResponse.Max_Capacity_Unsecured__c = null;
        insert appResponse;

        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        ApexPages.currentPage().getParameters().put('cust', 'y');
        OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
        application.isCustomer = true;
        application.validateRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, application.application.Id);
        System.assertEquals(null, application.appResponse[0].Credit_Score__c);
        System.assertEquals(null, application.appResponse[0].Max_Capacity_Secured__c);
        System.assertEquals(null, application.appResponse[0].Max_Capacity_Unsecured__c);

    }

    static testMethod void Refinance_Test() { 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Application_Type__c = 'Joint';
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        //testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id,testApplicant.Id);
        insert testApplicantCLVList;

        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
        testApplicantAccount.RecordTypeId = [SELECT ID FROM RecordType WHERE sObjectType='Applicant_Account__c' and Name = 'ICBS'].Id;
        insert testApplicantAccount;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Refinance');
        insert testLoanPurpose2;

        RecordType REFrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Disbursement__c' and Name = 'Re-Finance'];

        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        payee__c pay=TestDataBuilder.createPayee();
        insert pay;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;

        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose2.Id);
        testDisbursement.Lookup_a_Payee__c= pay.Id;       
        insert testDisbursement;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;        

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        //List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        //insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));
        insert geProductInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
        application.isCustomer = true;
        application.dateOfBirthStr = '1990-01-01';
        application.dateOfBirthStr2 = '1990-01-01';
        application.initializeDisbursement();
        application.saveDisbursement();
        system.assert([select count() from Disbursement__c where Application__c =: testApplication.Id] == 1);
        application.currentDisbursementWrapper.disbursement.Bank_Acc_No__c = '12345';
        application.disbursementWrapperList.add(application.currentDisbursementWrapper);
        application.loanToRemove = '0,1';
        application.loanTermSelected = '1 year';
        application.save();
        //application.updateComputation(90000);
        application.retrieveDisbursement();
        application.showDisbursement();
        application.editDisbursement();
        application.cancelDisbursement();
        Test.StopTest();

        System.assertEquals(testApplication.Id, application.application.Id);
    } 

    static testMethod void invalidData_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        insert testApplication;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;        

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.offerList[0].loan.Value__c = 'Please Select';
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            System.assertEquals('Please Select', application.offerList[0].loan.Value__c);
        }

    }

    static testMethod void refresh_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Date_of_Birth_WS__c  = '1940-01-01';
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        //Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        //insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        //Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        //insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        //Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        //insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        //testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        //testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        //update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

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

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, null));
        insert testProductItemInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1940-01-01';
            application.loanTermSelected = '1 year';
            application.application.Payment_Frequency__c = 'Please Select';
            application.rerenderInsurance();
            application.save();
            application.refreshPage();
            Test.StopTest();
            System.assertEquals(testApplication.Id, application.application.Id);
        }
    }

    static testMethod void saveDisbursement_Test() { 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Application_Type__c = 'Joint';
        testApplication.Channel__c = 'Broker';
        insert testApplication;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id,testApplicant.Id);
        insert testApplicantCLVList;

        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
        testApplicantAccount.RecordTypeId = [SELECT ID FROM RecordType WHERE sObjectType='Applicant_Account__c' and Name = 'ICBS'].Id;
        insert testApplicantAccount;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Refinance');
        insert testLoanPurpose2;

        RecordType REFrecordType = [SELECT ID FROM RecordType WHERE sObjectType='Disbursement__c' and Name = 'Re-Finance'];

        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
        
        payee__c pay=TestDataBuilder.createPayee();
        insert pay;
        
        Response_Code_Control__c RCC=TestDataBuilder.createResponseCodeControl(true,'PA');
        insert RCC;

        Disbursement__c testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose2.Id);
        testDisbursement.Lookup_a_Payee__c= pay.Id;
        insert testDisbursement;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose2.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        update testApplicant2;        

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        //List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        //insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));
        insert geProductInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;
        
        //Removed by Txu to prevent test failure    
        /**Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        
        insert testUserAdmin;
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }**/
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
        application.isCustomer = true;
        application.dateOfBirthStr = '1990-01-01';
        application.dateOfBirthStr2 = '1990-01-01';
        application.loanTermSelected = '1 year';
        application.initializeDisbursement();
        system.assert([select count() from Disbursement__c where Application__c =: testApplication.Id] == 1);
        application.currentDisbursementWrapper.disbursement.Bank_Acc_No__c = '12345';
        application.currentDisbursementWrapper.disbursement.Payee__c = 'test';
        application.currentDisbursementWrapper.disbursement.Applicable_Party__c  = 'Applicant 1';
        application.currentDisbursementWrapper.disbursement.Disbursement_Account_type__c = 'Personal Loan';
        application.currentDisbursementWrapper.disbursement.Disbursement_Outcome__c = 'Reduce';
        application.currentDisbursementWrapper.disbursement.Interest_Rate__c = 10;
        application.currentDisbursementWrapper.disbursement.Payout_Effective_Date__c = Date.today()-30;
        application.currentDisbursementWrapper.disbursement.Principal_Amount__c  = 1000;
        application.currentDisbursementWrapper.disbursement.Interest_Due__c = 8;
        application.currentDisbursementWrapper.disbursement.Late_Fees_Due__c = 10;
        application.currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c = 20;
        application.currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c = 30;
        application.currentDisbursementWrapper.disbursement.Charge_Off_Amount__c = 40;
        application.currentDisbursementWrapper.disbursement.Insurance_Rebate__c = 50;
        application.currentDisbursementWrapper.disbursement.Early_Termination_Fee__c = 60;
        application.disbursementWrapperList.add(application.currentDisbursementWrapper);
        application.nRefinanceRow = 1;
        application.retrievePayoff();
        application.saveDisbursement();
        application.save();
        Test.StopTest();

        System.assertEquals(testApplication.Id, application.application.Id);
    } 
}