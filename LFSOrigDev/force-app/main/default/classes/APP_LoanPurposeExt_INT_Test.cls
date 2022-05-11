/*
 * @Description: Test Class for APP_LoanPurposeExt_INT
 * @Author: Russell Cadapan
 * @Date Created: MAR-07-2014
 * @History:
   =====================================================================
       03.07.2014: Created - Russell
   =====================================================================
 */
@isTest
public class APP_LoanPurposeExt_INT_Test {
    static testMethod void constructorTestWithExistingRecords(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;

        Applicant_CLV__c testApplicantCLV = TestDataBuilder.createApplicantCLV(testApplicantSearch.Id, testApplicant.Id);
        insert testApplicantCLV;

        Id ICBSRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Applicant_Account__c' AND DeveloperName = 'ICBS' LIMIT 1].Id;

        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLV.Id);
        testApplicantAccount.Account_Balance__c = '1000';
        testApplicantAccount.RecordTypeId = ICBSRecordTypeId;
        insert testApplicantAccount;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Response_Code_Control__c responseCode = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCode;

        Id disRefid = Schema.SObjectType.Disbursement__c.RecordTypeInfosByName.get('Re-Finance').RecordTypeId;

        Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(testApplication.Id);
        testDisbursement.Loan_Purpose__c = testLoanPurpose.Id;
        testDisbursement.RecordTypeId = disRefid;
        testDisbursement.Bank_Acc_No__c = testApplicantAccount.Account_Number__c;
        insert testDisbursement;

        //List<SelectOption> testLoanTerms = Util.getPicklistValues(testApplication, 'Loan_Term__c');
        List<SelectOption> testLoanFrequency = Util.getPicklistValues(testApplication, 'Payment_Frequency__c');

        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.selectedRow = 0;
            loanPurpose.removethisLoan();
            loanPurpose.addLoanPurpose();
            loanPurpose.showDisbursement();
            loanPurpose.cancelDisbursement();
            loanPurpose.getloanPurposeSize();
            
            List<SelectOption> loanTerms = loanPurpose.getLoanTermOptions();
            List<SelectOption> loanFrequency = loanPurpose.getloanFrequencyOptions();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        System.assertEquals(null, loanPurpose.loanWrapList[0].loan.Id);
        //System.assertEquals(testLoanTerms.size(), loanTerms.size());
        System.assertEquals(testLoanFrequency.size() + 1, loanFrequency.size());

    }
    static testMethod void constructorTestWithNoExistingRecords(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);

        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        System.assertEquals(null, loanPurpose.loanWrapList[0].loan.Id);
    }
    static testMethod void saveSuccess_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose2;

        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.selectedRow = 1;
            loanPurpose.removethisLoan();
            loanPurpose.loanTermSelected = '2 years';
            loanPurpose.loanFrequencySelected = 'Monthly';
            loanPurpose.redirectTo = 'Save';
            loanPurpose.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        System.assertEquals(true, loanPurpose.loanValidationResults);
    }
    static testMethod void saveFailure_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.loanTermSelected = '';
            loanPurpose.loanFrequencySelected = '';
            loanPurpose.redirectTo = 'Save';
            loanPurpose.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        System.assertEquals(false, loanPurpose.loanValidationResults);
    }
    static testMethod void createDebtConsolidation_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.redirectTo = 'Save';
            loanPurpose.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        for(Integer i = 0; i < loanPurpose.loanWrapList.size(); i++){
            System.assertEquals(null, loanPurpose.loanWrapList[i].loan.Id);
        }
    }
    static testMethod void pageRedirects_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference testPageNext = new PageReference('/apex/app_jointpersonaldetails_int?id=' + testApplication.Id);
        PageReference testPageBack = new PageReference('/apex/app_producteligibility_int?id=' + testApplication.Id);
        Test.StartTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.redirectTo = 'Back';
            PageReference pageBack = loanPurpose.pageRedirect();

            loanPurpose.loanTermSelected = '2 years';
            loanPurpose.loanFrequencySelected = 'Monthly';
            loanPurpose.totAmount = 3000;
            loanPurpose.loanWrapList.get(0).loan.Value__c = 'Test';
            loanPurpose.loanWrapList.get(0).loan.Loan_Amount__c = 3000;
            loanPurpose.redirectTo = 'Next';
            PageReference pageNext = loanPurpose.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);
        System.assertEquals(testPageNext.getUrl(), pageNext.getUrl());
        System.assertEquals(testPageBack.getUrl(), pageBack.getUrl());
    }

    static testMethod void Refinance_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'Loan_Purpose' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        Applicant_CLV__c testApplicantCLV = TestDataBuilder.createApplicantCLV(null, testApplicant.Id);
        insert testApplicantCLV;

        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLV.Id);
        testApplicantAccount.RecordTypeId = Schema.SObjectType.Applicant_Account__c.RecordTypeInfosByName.get('ICBS').RecordTypeId;
        testApplicantAccount.Account_Number__c = '1234';
        testApplicantAccount.Account_Balance__c  = '2500';
        insert testApplicantAccount;

        Test.StartTest();
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_LoanPurposeExt_INT loanPurpose = new APP_LoanPurposeExt_INT(standardCon);
            loanPurpose.loanWrapList.get(0).loan.Value__c = 'Refinance';
            loanPurpose.loanWrapList.get(0).loan.Loan_Amount__c = 5000;
            loanPurpose.redirectTo = 'Save';
            loanPurpose.pageRedirect();
            loanPurpose.loanWrapList.get(0).loan.Value__c = 'Car Purchase';
            loanPurpose.loanWrapList.get(0).loan.Loan_Amount__c = 5000;
            loanPurpose.addLoanPurpose();
            loanPurpose.loanWrapList.get(1).loan.Value__c = 'Refinance';
            loanPurpose.loanWrapList.get(1).loan.Loan_Amount__c = 5000;
            loanPurpose.addLoanPurpose();
            loanPurpose.loanWrapList.get(2).loan.Value__c = 'Refinance';
            loanPurpose.loanWrapList.get(2).loan.Loan_Amount__c = 5000;
            loanPurpose.addLoanPurpose();
            loanPurpose.loanWrapList.get(3).loan.Value__c = 'Refinance';
            loanPurpose.loanWrapList.get(3).loan.Loan_Amount__c = 5000;
            loanPurpose.addLoanPurpose();
            loanPurpose.loanWrapList.get(4).loan.Value__c = 'Refinance';
            loanPurpose.loanWrapList.get(4).loan.Loan_Amount__c = 5000;
            loanPurpose.pageRedirect();
            loanPurpose.selectedRow = 2;
            loanPurpose.removethisLoan();
            loanPurpose.selectedRow = 2;
            loanPurpose.removethisLoan();
            loanPurpose.selectedRow = 2;
            loanPurpose.removethisLoan();
            loanPurpose.selectedRow = 1;
            loanPurpose.editDisbursement();
            loanPurpose.saveDisbursement();
            loanPurpose.currentDisbursementWrapper.disbursement.Applicable_Party__c = 'Both';
            loanPurpose.saveDisbursement();
            loanPurpose.loanTermSelected = '2 years';
            loanPurpose.loanFrequencySelected = 'Weekly';
            loanPurpose.currentDisbursementWrapper.disbursement.Payee__c = 'Test';
            loanPurpose.currentDisbursementWrapper.disbursement.Applicable_Party__c = 'Applicant 1';
            loanPurpose.currentDisbursementWrapper.disbursement.Disbursement_Account_type__c = 'Credit Card';
            loanPurpose.currentDisbursementWrapper.disbursement.Disbursement_Outcome__c = 'Close';
            loanPurpose.currentDisbursementWrapper.disbursement.Bank_Acc_No__c = '1234';
            loanPurpose.currentDisbursementWrapper.disbursement.Interest_Rate__c = 5;
            loanPurpose.currentDisbursementWrapper.disbursement.Payout_Effective_Date__c = Date.today()+1;
            loanPurpose.currentDisbursementWrapper.disbursement.Principal_Amount__c = 5000;
            loanPurpose.currentDisbursementWrapper.disbursement.Interest_Due__c = 2;
            loanPurpose.currentDisbursementWrapper.disbursement.Late_Fees_Due__c = 1000;
            loanPurpose.currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c = 1;
            loanPurpose.currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c = 500;
            loanPurpose.currentDisbursementWrapper.disbursement.Charge_Off_Amount__c = 500;
            loanPurpose.currentDisbursementWrapper.disbursement.Insurance_Rebate__c = 500;
            loanPurpose.currentDisbursementWrapper.disbursement.Early_Termination_Fee__c = 500;
            loanPurpose.saveDisbursement();
            loanPurpose.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, loanPurpose.application.Id);

    }    
}