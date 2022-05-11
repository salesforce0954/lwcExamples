@isTest
private class APP_JointExpensesExt_Test {
    static testMethod void constructorWithoutExistingRecord_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;


        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.getTimeOut();
            exp.register();
            exp.logout();
            exp.getWarning();
        Test.StopTest();

        System.assertEquals(null, exp.expenseWrapper.expense.Id);
    }
    static testMethod void constructorWithExistingRecord_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
        testExpense.Living_Exp_Int__c = null;
        testExpense.Food_Groc_Entert__c = 4332;
        testExpense.Insurance_Expense__c = 4332;
        testExpense.Utilities_Expense__c = 4332;
        testExpense.Transport_Expense__c = 4332;
        testExpense.Education_and_child_Expense__c = 4332;
        testExpense.Personal_Other_Expense__c = 4332;
        testExpense.Food_Groc_Interval__c = null;
        testExpense.Insurance_Expense_Interval__c = null;
        testExpense.Utilities_Expense_Interval__c = null;
        testExpense.Transport_Expense_Interval__c = null;
        testExpense.Education_and_child_Expense_Interval__c = null;
        testExpense.Personal_Other_Expense_Interval__c = null;
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
        insert testExpense2;
        List<Expense__c> elist = [SELECT Applicant__c FROM Expense__c];
        
        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.redirectTo ='Save';
            exp.validateLoanFields();
            exp.pageRedirect();
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
    //    System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }
    static testMethod void saveRecordInterval_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;


        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
            testExpense.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
            testExpense2.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        insert testExpense2;

        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.redirectTo ='Save';
            exp.validateLoanFields();
            exp.pageRedirect();
        Test.StopTest();
        
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
     //   System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }
    static testMethod void saveRecordRental_Test(){
        //Joint with no Expense (weekly and fortnight)
/*
        Admin_Settings__c testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Admin_Settings__c testOmnitureAdminSettings = TestDataBuilder.adminSet();
            testOmnitureAdminSettings.Name = GEN_OriginationsConstants.ADMIN_SETTINGS_OMNITURE;
            testOmnitureAdminSettings.Value__c = '//nexus.ensighten.com/gecapitalau/dev/Bootstrap.js';
        insert testOmnitureAdminSettings;
*/        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Res_Status__c = 'Renting';
        insert testApplicant2;

        Applicant__c testApplicant3 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant3.Res_Status__c = 'Renting';
        insert testApplicant3;

        Applicant__c testApplicant4 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant4.Res_Status__c = 'Renting';
        insert testApplicant4;

        Applicant__c testApplicant5 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant5.Res_Status__c = 'Renting';
        insert testApplicant5;


        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
            testExpense.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Food_Groc_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Insurance_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Utilities_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Transport_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Education_and_child_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Personal_Other_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Mortgage_Rent_Board_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Secondary_Mortgage_Rent_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Property_rates_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Other_Property_Expenses_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            testExpense.Mortgage_Rent_Board__c = 5123;
            testExpense.Secondary_Mortgage_Rent__c= 4332;
            testExpense.Other_Property_Expenses__c = 4332;
            testExpense.Property_rates__c= 4332;
            testExpense.Living_Exp__c = 5123;
            testExpense.Food_Groc_Entert__c = 4332;
            testExpense.Insurance_Expense__c = 4332;
            testExpense.Utilities_Expense__c = 4332;
            testExpense.Transport_Expense__c = 4332;
            testExpense.Education_and_child_Expense__c = 4332;
            testExpense.Personal_Other_Expense__c = 4332;
    
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
            testExpense2.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Food_Groc_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Insurance_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Utilities_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Transport_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Education_and_child_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Personal_Other_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Mortgage_Rent_Board_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Secondary_Mortgage_Rent_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Property_rates_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Other_Property_Expenses_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            testExpense2.Mortgage_Rent_Board__c = 5123;
            testExpense2.Secondary_Mortgage_Rent__c= 4332;
            testExpense2.Other_Property_Expenses__c = 4332;
            testExpense2.Property_rates__c= 4332;
            testExpense2.Living_Exp__c = 5123;
            testExpense2.Food_Groc_Entert__c = 4332;
            testExpense2.Insurance_Expense__c = 4332;
            testExpense2.Utilities_Expense__c = 4332;
            testExpense2.Transport_Expense__c = 4332;
            testExpense2.Education_and_child_Expense__c = 4332;
            testExpense2.Personal_Other_Expense__c = 4332;
        insert testExpense2;

        Expense__c testExpense3 = TestDataBuilder.createExpense(testApplicant3.Id);
            testExpense3.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Food_Groc_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Insurance_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Utilities_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Transport_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Education_and_child_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Personal_Other_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Mortgage_Rent_Board_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Secondary_Mortgage_Rent_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Property_rates_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Other_Property_Expenses_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            testExpense3.Mortgage_Rent_Board__c = 5123;
            testExpense3.Secondary_Mortgage_Rent__c= 4332;
            testExpense3.Other_Property_Expenses__c = 4332;
            testExpense3.Property_rates__c= 4332;
            testExpense3.Living_Exp__c = 5123;
            testExpense3.Food_Groc_Entert__c = 4332;
            testExpense3.Insurance_Expense__c = 4332;
            testExpense3.Utilities_Expense__c = 4332;
            testExpense3.Transport_Expense__c = 4332;
            testExpense3.Education_and_child_Expense__c = 4332;
            testExpense3.Personal_Other_Expense__c = 4332;
        insert testExpense3;

        Expense__c testExpense4 = TestDataBuilder.createExpense(testApplicant4.Id);
            testExpense4.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Food_Groc_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Insurance_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Utilities_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Transport_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Education_and_child_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Personal_Other_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Mortgage_Rent_Board_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Secondary_Mortgage_Rent_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Property_rates_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Other_Property_Expenses_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER;
            testExpense4.Mortgage_Rent_Board__c = 5123;
            testExpense4.Secondary_Mortgage_Rent__c= 4332;
            testExpense4.Other_Property_Expenses__c = 4332;
            testExpense4.Property_rates__c= 4332;
            testExpense4.Living_Exp__c = 5123;
            testExpense4.Food_Groc_Entert__c = 4332;
            testExpense4.Insurance_Expense__c = 4332;
            testExpense4.Property_rates__c = 4332;
            testExpense4.Transport_Expense__c = 4332;
            testExpense4.Education_and_child_Expense__c = 4332;
            testExpense4.Personal_Other_Expense__c = 4332;
        insert testExpense4;

        Expense__c testExpense5 = TestDataBuilder.createExpense(testApplicant5.Id);
            testExpense5.Living_Exp_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Food_Groc_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Insurance_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Utilities_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Transport_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Education_and_child_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Personal_Other_Expense_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Mortgage_Rent_Board_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Secondary_Mortgage_Rent_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Property_rates_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Other_Property_Expenses_Interval__c= GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            testExpense5.Mortgage_Rent_Board__c = 5123;
            testExpense5.Secondary_Mortgage_Rent__c= 4332;
            testExpense5.Other_Property_Expenses__c = 4332;
            testExpense5.Property_rates__c= 4332;
            testExpense5.Living_Exp__c = 5123;
            testExpense5.Food_Groc_Entert__c = 4332;
            testExpense5.Insurance_Expense__c = 4332;
            testExpense5.Utilities_Expense__c = 4332;
            testExpense5.Transport_Expense__c = 4332;
            testExpense5.Education_and_child_Expense__c = 4332;
            testExpense5.Personal_Other_Expense__c = 4332;
        insert testExpense5;


        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            MyBudgetsExpenseWrapper mbew = new MyBudgetsExpenseWrapper(testExpense,testApplicant);            
            MyBudgetsExpenseWrapper mbew2 = new MyBudgetsExpenseWrapper(testExpense2,testApplicant2);            
            MyBudgetsExpenseWrapper mbew3 = new MyBudgetsExpenseWrapper(testExpense3,testApplicant3);            
            MyBudgetsExpenseWrapper mbew4 = new MyBudgetsExpenseWrapper(testExpense4,testApplicant4);            
            MyBudgetsExpenseWrapper mbew5 = new MyBudgetsExpenseWrapper(testExpense5,testApplicant5);
          
            
            exp.redirectTo ='Save';
            exp.validateLoanFields();
            exp.clearRentFields();
            exp.pageRedirect();
            exp.Mode = 'Test';
            exp.isBetterStart = false;
            exp.expense2Wrapper = new MyBudgetsExpenseWrapper(testExpense,testApplicant);
            exp.iPayExpenses = 'Yes, I pay all the expenses';
            exp.recomputeTotalExpense();
            mbew.computeTotalExpense(false,'AU');
            mbew2.computeTotalExpense(false,'AU');
            mbew3.computeTotalExpense(false,'AU');
            mbew4.computeTotalExpense(false,'AU');
            mbew5.computeTotalExpense(false,'AU');
            mbew.computeTotalExpense(true,'NZ');
            mbew2.computeTotalExpense(true,'NZ');
            mbew3.computeTotalExpense(true,'NZ');
            mbew4.computeTotalExpense(true,'NZ');
            mbew5.computeTotalExpense(true,'NZ');
            mbew5.validateExpense(false,'AU');
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
     //   System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }
    
    static testMethod void saveRecordFailure_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Res_Status__c = 'Renting';
        insert testApplicant2;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
            testExpense.Rent_Board_Pay_Int__c  = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
            testExpense2.Rent_Board_Pay_Int__c  = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        insert testExpense2;

        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.expenseWrapper.expense.Living_Exp__c = null;
            exp.expenseWrapper.expense.Living_Exp_Int__c = null;
            exp.expenseWrapper.expense.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            exp.expenseWrapper.expense.Rent_Board_Pay_Amt__c  = null;
            exp.expenseWrapper.expense.Rent_Board_Pay_Int__c  = null;
            exp.expenseWrapper.expense.Agent_Landlord_Name__c   = 'ERR1';
            exp.expenseWrapper.expense.Agent_Landlord_Phone_Number__c   = 'ERR1';
         //   exp.expense2Wrapper.expense.Agent_Landlord_Phone_Number__c    = 'ERR4';
         //   exp.expense2Wrapper.expense.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            exp.redirectTo ='Save';
            exp.pageRedirect();
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
      //  System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }
    static testMethod void saveRecordNotRenting_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Please Select';
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Res_Status__c = 'Please Select';
        insert testApplicant2;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
            testExpense.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
            testExpense2.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        insert testExpense2;

        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.redirectTo ='Save';
            exp.pageRedirect();
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
     //   System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
        System.assertEquals('Save', exp.redirectTo);
    }
    static testMethod void expenseTimeout_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Please Select';
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Res_Status__c = 'Please Select';
        insert testApplicant2;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
            testExpense.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
            testExpense2.Rent_Board_Pay_Int__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        insert testExpense2;

        Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.redirectTo ='Timeout';
            exp.pageRedirect();
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
     //   System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
        System.assertEquals('Timeout', exp.redirectTo);
    }
    static testMethod void constructorWithSoftQuoteRecord_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
          Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
                      
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
         List<Quote__c> quoteList = TestDataBuilder.createQuoteAUOnline();
         quoteList[0].Application__c=testApplication.Id;
         insert quoteList;
             
         Quote_Product_Item__c testquoteProductItem = new Quote_Product_Item__c(Quote__c=quoteList[0].Id, Product_Version__c=testProductVersion.Id);
         insert testquoteProductItem;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
        insert testExpense2;
        List<Expense__c> elist = [SELECT Applicant__c FROM Expense__c];
        
        Test.setCurrentPage(Page.App_JointExpenses);
        ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpensesExt exp = new APP_JointExpensesExt(standardCon);
            exp.redirectTo ='Save';
            exp.validateLoanFields();
            exp.pageRedirect();
        Test.StopTest();
        System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
  //      System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }

    
}