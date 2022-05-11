/*
 * @Description: Test class for APP_JointDebtAndLiabilitiesExt class
 * @Author: Russell Cadapan
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
public class APP_JointDebtAndLiabilitiesExt_Test {
    static testMethod void constructorWithExistingRecords_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Liability__c testLiability = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.isCustomer = true;
            debt.register();
            debt.logout();
            debt.getTimeOut();
            debt.getWarning();
            
               
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        System.assertEquals(1, debt.debtAddList.size());
        System.assertEquals(testLiability.Id, debt.debtAddList[0].debt.Id);
    }

    static testMethod void constructorWithNoExistingRecords_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;


        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.isCustomer = true;
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        System.assertEquals(1, debt.debtAddList.size());
        System.assertEquals(null, debt.debtAddList[0].debt.Id);
    }

    static testMethod void removeDebt_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Liability__c testLiability = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability;

        Liability__c testLiability2 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability2;

        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        Test.setCurrentPage(Page.App_JointDebtAndLiabilities);
        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.redirectTo = 'Save';
            debt.isCustomer = true;
            debt.selectedRow = 0;
            debt.validateLoanFields();
            debt.removethisDebt();
            debt.pageRedirect();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        //System.assertEquals(pageRedirect.getUrl(), debt.pageRedirect().getUrl());
    }
    static testMethod void timeOut_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.redirectTo = 'Timeout';
            debt.isCustomer = true;
            debt.pageRedirect();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        //Mike TODO: sprint 10
        //System.assertEquals(pageRedirect.getUrl(), debt.pageRedirect().getUrl());
    }
    static testMethod void saveSuccess_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
            testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        //Mortgage debts in different repayment interval
            Liability__c testLiabilityMortgageMonth = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
                testLiabilityMortgageMonth.Acknowledge_Payout__c = true;
            insert testLiabilityMortgageMonth;

            Liability__c testLiabilityMortgageWeek = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
                testLiabilityMortgageWeek.Acknowledge_Payout__c = true;
                testLiabilityMortgageWeek.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityMortgageWeek;

            Liability__c testLiabilityMortgageFortnight = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
                testLiabilityMortgageFortnight.Acknowledge_Payout__c = true;
                testLiabilityMortgageFortnight.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            insert testLiabilityMortgageFortnight;

        //Loan debts in different repayment interval
            Liability__c testLiabilityLoanWeek = TestDataBuilder.createLoanLiability(testApplicant.Id);
                testLiabilityLoanWeek.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityLoanWeek;

            Liability__c testLiabilityLoanMonth = TestDataBuilder.createLoanLiability(testApplicant.Id);
            insert testLiabilityLoanMonth;

            Liability__c testLiabilityLoanFortnight= TestDataBuilder.createLoanLiability(testApplicant.Id);
                testLiabilityLoanFortnight.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
                testLiabilityLoanFortnight.Acknowledge_Payout__c = true;
            insert testLiabilityLoanFortnight;

        //Card debts in different repayment consolidations
            Liability__c testLiabilityCard = TestDataBuilder.createCardLiability(testApplicant.Id);
            insert testLiabilityCard;

            Liability__c testLiabilityCardConsolidate = TestDataBuilder.createCardLiability(testApplicant.Id);
                testLiabilityCardConsolidate.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            insert testLiabilityCardConsolidate;

            Liability__c testLiabilityCardReduce = TestDataBuilder.createCardLiability(testApplicant.Id);
                testLiabilityCardReduce.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
                testLiabilityCardReduce.Reduced_Credit_Limit__c = 100;
            insert testLiabilityCardReduce;

        //Other debts in different repayment interval
            Liability__c testLiabilityOtherMonth = TestDataBuilder.createOtherLiability(testApplicant.Id);
            insert testLiabilityOtherMonth;

            Liability__c testLiabilityOtherWeek = TestDataBuilder.createOtherLiability(testApplicant.Id);
                testLiabilityOtherWeek.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityOtherWeek;

            Liability__c testLiabilityOtherFortnight = TestDataBuilder.createOtherLiability(testApplicant.Id);
                testLiabilityOtherFortnight.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            insert testLiabilityOtherFortnight;

        //Overdraft debt in different consolidations
            Liability__c testLiabilityOverdraft = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraft.Consolidate_Debt_Reduce_Limit__c = 'Please Select';
                testLiabilityOverdraft.Overdraft_APR__c = null;
            insert testLiabilityOverdraft;

            Liability__c testLiabilityOverdraftConsolidate = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraftConsolidate.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            insert testLiabilityOverdraftConsolidate;

            Liability__c testLiabilityOverdraftReduce = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraftReduce.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
                testLiabilityOverdraftReduce.Reduced_Credit_Limit__c = 100;
            insert testLiabilityOverdraftReduce;

        Test.setCurrentPage(Page.App_JointDebtAndLiabilities);
        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.redirectTo = 'Save';
            debt.isCustomer = true;
            debt.validateLoanFields();
            debt.getTotalDebt();
            debt.pageRedirect();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        //System.assertEquals(pageRedirect.getUrl(), debt.pageRedirect().getUrl());
    }

    static testMethod void saveSuccess_TestNZ(){
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
        
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
        testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        //Mortgage debts in different repayment interval
            Liability__c testLiabilityMortgageMonth = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
            RecordType liabilityRecordType = [SELECT Id FROM RecordType WHERE Name = 'NZ'  AND SObjectType = 'Liability__c' LIMIT 1];
            testLiabilityMortgageMonth.RecordTypeId = liabilityRecordType.Id;
            insert testLiabilityMortgageMonth;

            Liability__c testLiabilityMortgageWeek = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
                testLiabilityMortgageWeek.Acknowledge_Payout__c = true;
                testLiabilityMortgageWeek.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityMortgageWeek;

            Liability__c testLiabilityMortgageFortnight = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
                testLiabilityMortgageFortnight.Acknowledge_Payout__c = true;
                testLiabilityMortgageFortnight.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            insert testLiabilityMortgageFortnight;

        //Loan debts in different repayment interval
            Liability__c testLiabilityLoanWeek = TestDataBuilder.createLoanLiability(testApplicant.Id);
                testLiabilityLoanWeek.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityLoanWeek;

            Liability__c testLiabilityLoanMonth = TestDataBuilder.createLoanLiability(testApplicant.Id);
            insert testLiabilityLoanMonth;

            Liability__c testLiabilityLoanFortnight= TestDataBuilder.createLoanLiability(testApplicant.Id);
                testLiabilityLoanFortnight.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
                testLiabilityLoanFortnight.Acknowledge_Payout__c = true;
            insert testLiabilityLoanFortnight;

        //Card debts in different repayment consolidations
            Liability__c testLiabilityCard = TestDataBuilder.createCardLiability(testApplicant.Id);
            insert testLiabilityCard;

            Liability__c testLiabilityCardConsolidate = TestDataBuilder.createCardLiability(testApplicant.Id);
                testLiabilityCardConsolidate.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            insert testLiabilityCardConsolidate;

            Liability__c testLiabilityCardReduce = TestDataBuilder.createCardLiability(testApplicant.Id);
                testLiabilityCardReduce.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
                testLiabilityCardReduce.Reduced_Credit_Limit__c = 100;
            insert testLiabilityCardReduce;

        //Other debts in different repayment interval
            Liability__c testLiabilityOtherMonth = TestDataBuilder.createOtherLiability(testApplicant.Id);
            insert testLiabilityOtherMonth;

            Liability__c testLiabilityOtherWeek = TestDataBuilder.createOtherLiability(testApplicant.Id);
                testLiabilityOtherWeek.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            insert testLiabilityOtherWeek;

            Liability__c testLiabilityOtherFortnight = TestDataBuilder.createOtherLiability(testApplicant.Id);
                testLiabilityOtherFortnight.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            insert testLiabilityOtherFortnight;

        //Overdraft debt in different consolidations
            Liability__c testLiabilityOverdraft = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraft.Consolidate_Debt_Reduce_Limit__c = 'Please Select';
                testLiabilityOverdraft.Overdraft_APR__c = null;
            insert testLiabilityOverdraft;

            Liability__c testLiabilityOverdraftConsolidate = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraftConsolidate.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            insert testLiabilityOverdraftConsolidate;

            Liability__c testLiabilityOverdraftReduce = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
                testLiabilityOverdraftReduce.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
                testLiabilityOverdraftReduce.Reduced_Credit_Limit__c = 100;
            insert testLiabilityOverdraftReduce;

        Test.setCurrentPage(Page.App_JointDebtAndLiabilities);
        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.redirectTo = 'Save';
            debt.isCustomer = true;
            debt.validateLoanFields();
            debt.getTotalDebt();
            debt.pageRedirect();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        //System.assertEquals(pageRedirect.getUrl(), debt.pageRedirect().getUrl());
    }
    static testMethod void removeAllDebts_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Debts_Exempt__c = true;
        insert testApplicant;

        Liability__c testLiability = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability;

        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.isCustomer = true;
            debt.removeAllDebts();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        System.assertEquals(0,debt.debtAddList.size());
    }
    static testMethod void removeAllDebtsFail_Test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
            testApplicant.Debts_Exempt__c = false;
        insert testApplicant;

        Liability__c testLiability = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability;

        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.isCustomer = true;
            debt.removeAllDebts();
        Test.StopTest();
    
        System.assertEquals(testApplication.Id, debt.application.Id);
        System.assertEquals(2,debt.debtAddList.size());
    }
    static testMethod void removeThisDebt_test(){
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null,testApplication.Id);
            testApplicant.Debts_Exempt__c = false;
        insert testApplicant;

        Liability__c testLiability = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        insert testLiability;

        Test.StartTest();
        
Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer; 
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt debt = new APP_JointDebtAndLiabilitiesExt(standardCon);
            debt.isCustomer = true;
            debt.selectedRow = 0;
            debt.removethisDebt();
        Test.StopTest();

        System.assertEquals(1, debt.debtAddList.size());
        System.assertEquals(null,debt.debtAddList[0].debt.Id);
    }
}