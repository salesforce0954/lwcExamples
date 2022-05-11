@isTest
public class APP_GEDDSidebarExt_Test {
    
    static testMethod void Sidebar_Test() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //Complete data
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '12345678';
        testApplication.Acceptance_Channel__c = GEN_OriginationsConstants.ONLINE_ACCEPTANCE;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

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

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Joint'+GEN_OriginationsConstants.PAGE_PERSONAL+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
            sidebar.goToUpload();
            sidebar.goToContract();
            sidebar.goToDownload();
        Test.StopTest();

        System.assertEquals('PA', responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.assetButtonClass);
       // System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(null, sidebar.activeTile);
        System.assertEquals(testApplication.Acceptance_Channel__c, sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test2() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //No Data
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '13245678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.First_Name__c = null;
        testApplicant.Last_Name__c = null;
        insert testApplicant;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;


        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Joint'+GEN_OriginationsConstants.PAGE_INCOME1+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals('PA',responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(null, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test3() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;
        
        //No Data but asset and debt exempt
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '13245678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Asset_Exempt__c = true;
        testApplicant.Debts_Exempt__c = true;
        insert testApplicant;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Joint'+GEN_OriginationsConstants.PAGE_ASSET+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals('PA',responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(null, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Tes4() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //Incomplete applicant 2 data
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '12345678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Joint'+GEN_OriginationsConstants.PAGE_EXPENSE+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
            sidebar.goToUpload();
            sidebar.goToContract();
            sidebar.goToDownload();
            sidebar.goToEligibility();
            sidebar.goToPersonal();
            sidebar.goToIncome();
            sidebar.goToExpense();
            sidebar.goToAsset();
            sidebar.goToDebt();
        Test.StopTest();

        System.assertEquals('PA', responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(null, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test5() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //No Data and debts in progress
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '13245678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.First_Name__c = null;
        testApplicant.Last_Name__c = null;
        insert testApplicant;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Joint'+GEN_OriginationsConstants.PAGE_DEBTS+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals('PA',responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INPROGRESS, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(null, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test6() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //No Data and customer ui file upload in progress
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '13245678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.First_Name__c = null;
        testApplicant.Last_Name__c = null;
        insert testApplicant;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_'+GEN_OriginationsConstants.PAGE_CUIFILEUPLOAD+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals('PA',responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(GEN_OriginationsConstants.TILE_UPLOAD, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test7() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PA');
        insert responseCodeControl;

        //No Data and customer ui file upload in progress
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.UID__c = '13245678';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.First_Name__c = null;
        testApplicant.Last_Name__c = null;
        insert testApplicant;

        Insurance_Premium_Calculation_Variables__c testInsuranceVariables = TestDataBuilder.createInsurancePremium();
        insert testInsuranceVariables;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        
        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Test.StartTest();
                    Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_'+GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE+'?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals('PA',responseCodeControl.Name);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals(GEN_OriginationsConstants.TILE_CONTRACT, sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }

    static testMethod void Sidebar_Test8() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        //No Data and null active tile
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.StartTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            PageReference pageRef = new PageReference('/apex/APP_Main?id='+testApplication.Id);
            Test.setCurrentPageReference(pageRef);
            APP_GEDDSidebarExt sidebar = new APP_GEDDSidebarExt();
        Test.StopTest();

        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_COMPLETE, sidebar.personalDetailsButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.incomeButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.assetButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.expenseButtonClass);
        System.assertEquals(GEN_OriginationsConstants.BUTTON_CLASS_INCOMPLETE, sidebar.debtButtonClass);
        System.assertEquals(testApplication.Id, sidebar.applicationId);
        System.assertEquals('', sidebar.activeTile);
        System.assertEquals('', sidebar.acceptanceChannel);
    }
}