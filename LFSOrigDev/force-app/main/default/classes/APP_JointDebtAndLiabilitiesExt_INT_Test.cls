@isTest
private class APP_JointDebtAndLiabilitiesExt_INT_Test {
    
    static testMethod void Debt_Test() {
        
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'AU';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Single with existing Debt
        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;

        Application__c app = [SELECT Brand_Lookup__c, Brand_Lookup__r.Name FROM Application__C WHERE ID =: testApplication.id];
        system.debug('test application brand: '+app.Brand_Lookup__c);

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilities deb = new APP_JointDebtAndLiabilities();
            deb.getDebtCategory();
            deb.getConsolidatedDebtCategory();
            deb.getCarPersonalInterval();
            deb.getOtherRepayInterval();
            deb.getMortgageRepayInterval();
            APP_JointDebtAndLiabilitiesExt_INT debtExt = new APP_JointDebtAndLiabilitiesExt_INT(standardCon);
            debtExt.redirectTo = 'Back';
            debtExt.pageRedirect();
            debtExt.redirectTo = 'Cancel';
            debtExt.pageRedirect(); 
            //debtExt.redirectTo = 'Skip';
            //debtExt.pageRedirect();
            debtExt.redirectTo = 'Save';
            debtExt.pageRedirect();
            debtExt.addDebt();
            debtExt.debtAddList.get(0).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT;
            debtExt.debtAddList.get(0).debt.Financier_Name__c = 'Test';
            debtExt.debtAddList.get(0).debt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
            debtExt.addDebt();
            debtExt.debtAddList.get(1).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE;
            debtExt.debtAddList.get(1).debt.Financier_Name__c = 'Test';
            debtExt.addDebt();
            debtExt.debtAddList.get(2).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN;
            debtExt.debtAddList.get(2).debt.Financier_Name__c = 'Test';
            debtExt.addDebt();
            debtExt.debtAddList.get(3).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_OTHER;
            debtExt.debtAddList.get(3).debt.Financier_Name__c = 'Test';
            debtExt.pageRedirect();
            debtExt.debtAddList.get(0).debt.Credit_Limit_Amt__c = 1000;
            debtExt.debtAddList.get(0).debt.Card_Overdraft_Bal_Amt__c = 500;
            debtExt.debtAddList.get(0).debt.Reduced_Credit_Limit__c = 100;
            
            debtExt.debtAddList.get(1).debt.Mortgage_Bal_Amt__c = 500;
            debtExt.debtAddList.get(1).debt.Mortgage_Borrowed_Amt__c = 1000;
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Amt__c = null;
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            debtExt.debtAddList.get(1).debt.Acknowledge_Payout__c = true;
            debtExt.pageRedirect();
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Amt__c = 100;

            debtExt.debtAddList.get(2).debt.Car_Personal_Bal_Amt__c = 500;
            debtExt.debtAddList.get(2).debt.Car_Personal_Repay_Amt__c = 250;
            debtExt.debtAddList.get(2).debt.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            debtExt.debtAddList.get(2).debt.Car_Personal_Borrowed_Amt__c = 1000;
            
            debtExt.debtAddList.get(3).debt.Other_Borrowed_Amt__c = 15000;
            debtExt.debtAddList.get(3).debt.Other_Repay_Amt__c = 500;
            debtExt.debtAddList.get(3).debt.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;

            debtExt.addDebt();
            debtExt.debtAddList.get(4).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT;
            debtExt.debtAddList.get(4).debt.Financier_Name__c = 'Test';
            debtExt.debtAddList.get(4).debt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            debtExt.debtAddList.get(4).debt.Credit_Limit_Amt__c = 1000;
            debtExt.debtAddList.get(4).debt.Card_Overdraft_Bal_Amt__c = 500;
            debtExt.debtAddList.get(4).debt.Reduced_Credit_Limit__c = 100;
            debtExt.pageRedirect();

            debtExt.selectedRow = 5;
            debtExt.removethisDebt();
            debtExt.pageRedirect();
          
        Test.StopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(5, debtExt.debtAddList.size());
        System.assertEquals('Save', debtExt.redirectTo);
        System.assertEquals(1, debtExt.debtListToDel.size());
        System.assert(debtExt.debtValidationResults);
    }
    
    static testMethod void Debt_Test2() {
         Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'NZ';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        //s.Value_Abbreviated_NZ__c
        insert s;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Single with existing Debt
        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Liability__c testDebt = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
        insert testDebt;

        Liability__c testDebt2 = TestDataBuilder.createLoanLiability(testApplicant.Id);
        testDebt2.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        testDebt2.Acknowledge_Payout__c = true;
        insert testDebt2;
        
        Liability__c testDebt3 = TestDataBuilder.createLoanLiability(testApplicant.Id);
        testDebt3.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testDebt3;
        
        Liability__c testDebt4 = TestDataBuilder.createOtherLiability(testApplicant.Id);
        testDebt4.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        insert testDebt4;

        Liability__c testDebt5 = TestDataBuilder.createOtherLiability(testApplicant.Id);
        testDebt5.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testDebt5;

        Liability__c testDebt6 = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt6.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
        insert testDebt6;

        Liability__c testDebt7 = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt7;

        Liability__c testDebt8 = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt8.Overdraft_APR__c = null;
        testDebt8.Consolidate_Debt_Reduce_Limit__c = 'Please Select';
        testDebt8.Reduced_Credit_Limit__c = 333;
        insert testDebt8;

        Liability__c testDebt9 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        testDebt9.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        testDebt9.Acknowledge_Payout__c = true;
        testDebt9.Mortgage_Repayment_Amt__c = 100;
        insert testDebt9;

        Liability__c testDebt10 = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        testDebt10.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
        testDebt10.Acknowledge_Payout__c = true;
        testDebt10.Mortgage_Repayment_Amt__c = 100;
        insert testDebt10;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt_INT debtExt = new APP_JointDebtAndLiabilitiesExt_INT(standardCon);
            debtExt.selectedRow = 9;
            debtExt.removethisDebt();
            debtExt.addDebt();
            system.debug('debt list: '+debtExt.debtAddList.size());
            debtExt.debtAddList.get(9).debt.Financier_Name__c = 'Test';
            debtExt.debtAddList.get(9).debt.Mortgage_Bal_Amt__c = 500;
            debtExt.debtAddList.get(9).debt.Mortgage_Borrowed_Amt__c = 1000;
            debtExt.debtAddList.get(9).debt.Mortgage_Repayment_Amt__c = 100;
            debtExt.debtAddList.get(9).debt.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            debtExt.debtAddList.get(9).debt.Acknowledge_Payout__c = true;
            debtExt.redirectTo = 'Next';
            debtExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(10, debtExt.debtAddList.size());
        System.assertEquals('Next', debtExt.redirectTo);
        System.assertEquals(9, debtExt.selectedRow);
        System.assertEquals(1, debtExt.debtListToDel.size());
        System.assert(!debtExt.debtValidationResults);
    }

    static testMethod void Debt_Test3() {
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'AU';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        //s.Value_Abbreviated_NZ__c
        insert s;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Single with existing Debt
        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Liability__c testDebt = TestDataBuilder.createOverdraftLiability(testApplicant.Id);
        testDebt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
        insert testDebt;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilitiesExt_INT debtExt = new APP_JointDebtAndLiabilitiesExt_INT(standardCon);
            debtExt.selectedRow = 0;
            debtExt.removethisDebt();
        Test.StopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(debtExt.debtListSize, debtExt.debtAddList.size());
        System.assertEquals(0, debtExt.selectedRow);
        //System.assertEquals(1, debtExt.debtListToDel.size());
    }

     static testMethod void Debt_Test4() {
        
        Street_Type_Setting__c s = new Street_Type_Setting__c();
        s.Region__c = 'AU';
        s.Value__c = 'Alley';
        s.Value_Abbreviated__c = 'Ally';
        s.Name = 'Alley';
        insert s;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Single with existing Debt
        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;

        Application__c app = [SELECT Brand_Lookup__c, Brand_Lookup__r.Name FROM Application__C WHERE ID =: testApplication.id];
        system.debug('test application brand: '+app.Brand_Lookup__c);

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Total_Debts__c = 100;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Liability__c testDebt = TestDataBuilder.createLiabilityMortgage(testApplicant.Id);
        testDebt.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        testDebt.Acknowledge_Payout__c = true;
        testDebt.Mortgage_Repayment_Amt__c = 100;
        testDebt.Type_of_Credit_Card__c  = 'Kiwibank';
        insert testDebt;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointDebtAndLiabilities deb = new APP_JointDebtAndLiabilities();
            deb.getDebtCategory();
            deb.getConsolidatedDebtCategory();
            deb.getCarPersonalInterval();
            deb.getOtherRepayInterval();
            deb.getMortgageRepayInterval();
            APP_JointDebtAndLiabilitiesExt_INT debtExt = new APP_JointDebtAndLiabilitiesExt_INT(standardCon);
            debtExt.redirectTo = 'Back';
            debtExt.pageRedirect();
            debtExt.redirectTo = 'Cancel';
            debtExt.pageRedirect(); 
            //debtExt.redirectTo = 'Skip';
            //debtExt.pageRedirect();
            debtExt.redirectTo = 'Save';
            debtExt.pageRedirect();
            debtExt.addDebt();
            debtExt.debtAddList.get(0).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT;
            debtExt.debtAddList.get(0).debt.Financier_Name__c = 'Test';
            debtExt.debtAddList.get(0).debt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_REDUCE_LIMIT;
            debtExt.addDebt();
            debtExt.debtAddList.get(1).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE;
            debtExt.debtAddList.get(1).debt.Financier_Name__c = 'Test';
            debtExt.addDebt();
            debtExt.debtAddList.get(2).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN;
            debtExt.debtAddList.get(2).debt.Financier_Name__c = 'Test';
            debtExt.addDebt();
            debtExt.debtAddList.get(3).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_OTHER;
            debtExt.debtAddList.get(3).debt.Financier_Name__c = 'Test';
            debtExt.pageRedirect();
            debtExt.debtAddList.get(0).debt.Credit_Limit_Amt__c = 1000;
            debtExt.debtAddList.get(0).debt.Card_Overdraft_Bal_Amt__c = 500;
            debtExt.debtAddList.get(0).debt.Reduced_Credit_Limit__c = 100;
            
            debtExt.debtAddList.get(1).debt.Mortgage_Bal_Amt__c = 500;
            debtExt.debtAddList.get(1).debt.Mortgage_Borrowed_Amt__c = 1000;
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Amt__c = null;
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            debtExt.debtAddList.get(1).debt.Acknowledge_Payout__c = true;
            debtExt.pageRedirect();
            debtExt.debtAddList.get(1).debt.Mortgage_Repayment_Amt__c = 100;

            debtExt.debtAddList.get(2).debt.Car_Personal_Bal_Amt__c = 500;
            debtExt.debtAddList.get(2).debt.Car_Personal_Repay_Amt__c = 250;
            debtExt.debtAddList.get(2).debt.Car_Personal_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            debtExt.debtAddList.get(2).debt.Car_Personal_Borrowed_Amt__c = 1000;
            
            debtExt.debtAddList.get(3).debt.Other_Borrowed_Amt__c = 15000;
            debtExt.debtAddList.get(3).debt.Other_Repay_Amt__c = 500;
            debtExt.debtAddList.get(3).debt.Other_Repay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;

            debtExt.addDebt();
            debtExt.debtAddList.get(4).debt.Debt_Category__c = GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT;
            debtExt.debtAddList.get(4).debt.Financier_Name__c = 'Test';
            debtExt.debtAddList.get(4).debt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
            debtExt.debtAddList.get(4).debt.Credit_Limit_Amt__c = 1000;
            debtExt.debtAddList.get(4).debt.Card_Overdraft_Bal_Amt__c = 500;
            debtExt.debtAddList.get(4).debt.Reduced_Credit_Limit__c = 100;
            debtExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(6, debtExt.debtAddList.size());
        System.assertEquals('Save', debtExt.redirectTo);
        System.assertEquals(0, debtExt.debtListToDel.size());
        //System.assert(debtExt.debtValidationResults);
    }
}