/*
 * @Description: Test class for App_MainExt class
 * @Author: Russell Cadapan 
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
public class APP_MainExt_Test {
    static testMethod void constructorTest(){
    Brand__c testBrand = TestDataBuilder.createBrand();
    insert testBrand;
    
    GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
    insert testProduct;
    
    Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
    insert testProductVersion;
    
    Application__c testApplication = TestDataBuilder.createApplication();
    testApplication.Brand_Lookup__c = testBrand.Id;
    insert testApplication;
 
    List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
    insert adminSettingsList;        
   
    Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
    insert testProductItem;
    
    Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

    ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
    insert testONR;
    
    Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
    insert testLoanPurpose;
    
    Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
    insert testLoanPurpose2;

    Account testPersonAccount = TestDataBuilder.createPersonAccount();
    insert testPersonAccount;
    
    Applicant__c testApplicant = TestDataBuilder.createApplicant(testPersonAccount.Id, testApplication.Id);
    insert testApplicant;
    
    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

    Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
    insert testMetaONR;
    
    PageReference testGoToDeclinePage = new PageReference('/apex/declinedresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToApproved = new PageReference('/apex/app_submitresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToReferred = new PageReference('/apex/app_referredresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToConditional = new PageReference('/apex/submitconditionalapproval?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoEligibility = new PageReference('/apex/app_eligibility?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToIncome = new PageReference('/apex/app_income?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToAsset = new PageReference('/apex/app_assets?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToExpense = new PageReference('/apex/app_expenses?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToDebts = new PageReference('/apex/app_debtandliabilities?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToAboutMe = new PageReference('/apex/app_jointpersonaldetails?id='+testApplication.Id);
    PageReference testGoToDirectDebit = new PageReference('/apex/app_directdebitdetails?id='+testApplication.Id+'&aid='+testApplicant.Id);
    List<SelectOption> testloanTermOptions = Util.getPickListValues(testApplication, 'Loan_Term__c');
    List<SelectOption> testloanFrequency = Util.getPickListValues(testApplication, 'Payment_Frequency__c');

    Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
        ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
        ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
        ApexPages.CurrentPage().getParameters().put('type', 'Joint');
        ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
        ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

        APP_MainExt AppMain = new APP_MainExt(standardCon);

        AppMain.removeLoanPurpose();
        AppMain.addLoanPurpose();
        AppMain.removeLoanPurpose();
        AppMain.register();
        AppMain.logout();
        AppMain.getTimeOut();
        AppMain.getWarning();
        List<SelectOption> loanTermOptions = AppMain.getLoanTermOptions();
        List<SelectOption> loanFrequency = AppMain.getloanFrequencyOptions();

    Test.StopTest();

    System.assertEquals(AppMain.Application.Id, testApplication.Id);
    //System.assertEquals(testloanTermOptions.size(), loanTermOptions.size());
    System.assertEquals(testloanFrequency.size() + 1, loanFrequency.size());

    }
    static testMethod void saveSuccess_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        

    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        /*PageReference testPageRefer = new PageReference('/apex/app_referredresponse?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageIncome = new PageReference('/apex/app_jointincome?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageExpense = new PageReference('/apex/app_jointexpenses?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPagePersonalDetails = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageAsset = new PageReference('/apex/app_jointassets?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageDebt = new PageReference('/apex/app_jointdebtandliabilities?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageDebit = new PageReference('/apex/app_directdebitdetails?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageTime = new PageReference('/apex/app_timeout?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageRegister = new PageReference('/apex/app_register?id=' + testApplication.Id + '&prodid=' + testProduct.Id + '&itemId=' + testProductItem.Id);*/

        PageReference testPageRefer = new PageReference('/apex/app_referredresponse?id=' + testApplication.Id);
        PageReference testPageEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        PageReference testPageIncome = new PageReference('/apex/app_jointincome?id=' + testApplication.Id);
        PageReference testPageExpense = new PageReference('/apex/app_jointexpenses?id=' + testApplication.Id);
        PageReference testPagePersonalDetails = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id);
        PageReference testPageAsset = new PageReference('/apex/app_jointassets?id=' + testApplication.Id);
        PageReference testPageDebt = new PageReference('/apex/app_jointdebtandliabilities?id=' + testApplication.Id);
        PageReference testPageDebit = new PageReference('/apex/app_directdebitdetails?id=' + testApplication.Id);
        PageReference testPageTime = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        PageReference testPageRegister = new PageReference('/apex/app_register?id=' + testApplication.Id + '&prodid=' + testProduct.Id + '&itemId=' + testProductItem.Id);

        PageReference testPageLogout = new PageReference('logoutPage');


        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            AppMain.redirectTo = 'Save';
            PageReference pageSave = AppMain.pageRedirect();
            
            AppMain.redirectTo = 'Refer';
            PageReference pageRefer = AppMain.pageRedirect();

            AppMain.redirectTo = 'Eligibility';
            PageReference pageEligibility = AppMain.pageRedirect();

            AppMain.redirectTo = 'Income';
            PageReference pageIncome = AppMain.pageRedirect();

            AppMain.redirectTo = 'Expense';
            PageReference pageExpense = AppMain.pageRedirect();

            AppMain.redirectTo = 'Personal';
            PageReference pagePersonal = AppMain.pageRedirect();

            AppMain.redirectTo = 'Assets';
            PageReference pageAssets = AppMain.pageRedirect();

            AppMain.redirectTo = 'Debt';
            PageReference pageDebt = AppMain.pageRedirect();
            
            AppMain.redirectTo = 'Timeout';
            PageReference pageTimout = AppMain.pageRedirect();

            AppMain.redirectTo = 'createUser';
            PageReference pageRegister = AppMain.pageRedirect();

            AppMain.redirectTo = 'createUserAccount';
            PageReference pageCreateUser = AppMain.pageRedirect();

        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
        System.assertEquals(null, pageSave);

        System.assertEquals(testPageEligibility.getUrl(), pageEligibility.getUrl());
        System.assertEquals(testPageIncome.getUrl(),pageIncome.getUrl());
        System.assertEquals(testPageExpense.getUrl(),pageExpense.getUrl());
        System.assertEquals(testPagePersonalDetails.getUrl(),pagePersonal.getUrl());
        System.assertEquals(testPageAsset.getUrl(),pageAssets.getUrl());
        System.assertEquals(testPageDebt.getUrl(),pageDebt.getUrl());
        System.assertEquals(testPageTime.getUrl(),pageTimout.getUrl());
    }  
    static testMethod void addRemoveApplicant_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;


    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        PageReference testAppMain = new PageReference('/apex/app_main?id=' + testApplication.Id);
        PageReference testEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            PageReference deleteApplicant = AppMain.deleteApplicant();
            PageReference addApplicant = AppMain.addApplicant2();

        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
        System.assertEquals(testAppMain.getUrl(), deleteApplicant.getUrl());
        System.assertEquals(testEligibility.getUrl(), addApplicant.getUrl());
    }
    static testMethod void saveFailure_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        PageReference testAppMain = new PageReference('/apex/app_main?id=' + testApplication.Id);
        PageReference testEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            AppMain.redirectTo = 'Save';
            AppMain.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
    }
}