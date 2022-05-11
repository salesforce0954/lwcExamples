@isTest
public class APP_ApplicationExt_INT_Test {

    static testMethod void Application_Test() {
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

        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Ver_Date__c = Date.today();
        testAML.AML_Pos_Verified_Type__c = 'In Branch';
        insert testAML;

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

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationExt_Int application = new APP_ApplicationExt_Int(standardCon);
            application.pageRedirect();
            application.redirectTo = 'applicant';
            application.redirectWho = '1';
            application.pageRedirect();
            application.redirectTo = 'income';
            application.pageRedirect();
            application.redirectTo = 'asset';
            application.pageRedirect();
            application.redirectTo = 'expense';
            application.pageRedirect();
            application.redirectTo = 'debt';
            application.pageRedirect();
            application.redirectTo = 'aml';
            application.pageRedirect();
            application.redirectTo = 'document';
            application.pageRedirect();
            application.redirectTo = 'document';
            application.redirectWho = '2';
            application.pageRedirect();
            application.deleteApplicant();
        Test.StopTest();
        
        System.assertEquals(testBrand.Id, testProduct.Brands__c);
        System.assertEquals(testProduct.Id, testProductVersion.GEProduct__c);
        System.assertEquals(testApplication.Brand_Lookup__c, testBrand.Id);
        System.assertEquals(testProductItem.Product_Version__c, testProductVersion.Id);
        System.assertEquals(ONRrecordType.Id, testONR.RecordTypeId);
        System.assertEquals(ONRrecordType.Id, testONR.RecordTypeId);
        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(testApplication.Id, testApplicant2.Application__c);
        System.assertEquals(testApplication.Total_Loan_Amount__c, testLoanPurpose.Loan_Amount__c);
        System.assertEquals(testApplicant.Total_Income__c, testIncome.Total_Income__c);
        System.assertEquals(testApplicant.Total_Assets__c, testAsset.Total_Assets__c);
        System.assertEquals(testApplicant.Total_Expense__c, testExpense.Total_Exp__c);
        System.assertEquals(testApplicant.Total_Debts__c, testDebt.Total_Debts__c);
        System.assertEquals(testApplicant2.Total_Income__c, testIncome2.Total_Income__c);
        System.assertEquals(testApplicant2.Total_Expense__c, testExpense2.Total_Exp__c);
        System.assertEquals(testApplication.Response_Code__c, responseCodeControl.Name);
        System.assert(!application.editPersonalDetailsButton);
        System.assert(!application.editIncomeButton);
        System.assert(!application.editAssetButton);
        System.assert(!application.editExpenseButton);
        System.assert(!application.editDebtButton);
        System.assert(!application.newEditDocumentButton);
        System.assertEquals(application.app1AboutMe, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Income, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Asset, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Expense, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Debts, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Status, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2AboutMe, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2Income, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2Asset, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2Expense, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2Debts, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app2Status, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.redirectTo, 'document');
        System.assertEquals(application.redirectWho, '2');

    }

    static testMethod void Application_Test2() {
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

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
        insert profileControl;

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationExt_Int application = new APP_ApplicationExt_Int(standardCon);
        Test.StopTest();

        System.assertEquals(testApplication.Response_Code__c, responseCodeControl.Name);
        System.assert(application.editPersonalDetailsButton);
        System.assert(application.editIncomeButton);
        System.assert(application.editAssetButton);
        System.assert(application.editExpenseButton);
        System.assert(application.editDebtButton);
        System.assert(application.newEditDocumentButton);
        System.assert(application.newAMLButton);
        System.assertEquals(application.app1AboutMe, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Income, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Asset, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Expense, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Debts, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Status, GEN_OriginationsConstants.STATUS_CHECK);
    }

    static testMethod void Application_Test3() {
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

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;
        
        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationExt_Int application = new APP_ApplicationExt_Int(standardCon);
            application.redirectTo = 'aml';
            application.redirectWho  = '2';
            application.pageRedirect();
        Test.StopTest();

        System.assert(application.editPersonalDetailsButton);
        System.assert(application.editIncomeButton);
        System.assert(application.editAssetButton);
        System.assert(application.editExpenseButton);
        System.assert(application.editDebtButton);
        System.assert(application.newEditDocumentButton);
        System.assert(application.newAMLButton);
        System.assertEquals(application.app1AboutMe, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Income, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Asset, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Expense, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Debts, GEN_OriginationsConstants.STATUS_CHECK);
        System.assertEquals(application.app1Status, GEN_OriginationsConstants.STATUS_CHECK);
    }
}