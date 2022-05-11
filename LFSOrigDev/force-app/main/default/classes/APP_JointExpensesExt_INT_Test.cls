@isTest
private class APP_JointExpensesExt_INT_Test {
    
    static testMethod void Expense_Test() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Joint with no Expense (weekly and fortnight)
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense exp = new APP_JointExpense();
            exp.getPayOption();
            exp.getLivingExpenseInterval();
            exp.getRentExpenseInterval();
            APP_JointExpensesExt_INT expenseExt = new APP_JointExpensesExt_INT(standardCon);
            expenseExt.redirectTo = 'Back';
            expenseExt.pageRedirect();
            expenseExt.redirectTo = 'Cancel';
            expenseExt.pageRedirect();
            expenseExt.redirectTo = 'Save';
            expenseExt.expenseWrapper.applicant.Res_Status__c = 'Please select';
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.applicant.Res_Status__c = 'Renting';
            expenseExt.expenseWrapper.validateExpense(false,'AU');            
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Agent_Landlord_Name__c = 'ERR1';
            expenseExt.expenseWrapper.expense.Agent_Landlord_Phone_Number__c = 'ERR1';
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Agent_Landlord_Phone_Number__c = 'ERR4';
            expenseExt.pageRedirect();
         //   expenseExt.expense2Wrapper.applicant.Res_Status__c = 'Living with friends/family';
            expenseExt.pageRedirect();
            expenseExt.recomputeTotalExpense();
            expenseExt.expenseWrapper.expense.Living_Exp__c = 1000;
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = 'Week';
            expenseExt.expenseWrapper.expense.Food_Groc_Entert__c = 1000;
            expenseExt.expenseWrapper.expense.Food_Groc_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Insurance_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Insurance_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Utilities_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Utilities_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Transport_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Transport_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Education_and_child_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Education_and_child_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Personal_Other_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Personal_Other_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c = 1000;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c = 'Week';
            expenseExt.pageRedirect();
          //  expenseExt.expense2Wrapper.expense.Living_Exp__c = 1000;
            expenseExt.pageRedirect();
          //  expenseExt.expense2Wrapper.expense.Living_Exp_Int__c = 'Fortnight';
            expenseExt.pageRedirect();
            expenseExt.recomputeTotalExpense();
            expenseExt.updateJointApplicantResStatus();
        Test.StopTest();

        system.assertEquals(testApplicant.Id, expenseExt.expenseWrapper.applicant.Id);
       // system.assertEquals(testApplicant2.Id, expenseExt.expense2Wrapper.applicant.Id);
        system.assertEquals(expenseExt.expenseWrapper.applicant.Res_Status__c, 'Renting');
       // system.assertEquals(expenseExt.expense2Wrapper.applicant.Res_Status__c, 'Living with friends/family');
        system.assertEquals(expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c, 1000);
        system.assertEquals(expenseExt.expenseWrapper.expense.Total_Exp__c.setScale(2), 34666.67);
       // system.assertEquals(expenseExt.expense2Wrapper.expense.Total_Exp__c.setScale(2), 2166.67);
        system.assertEquals(expenseExt.expenseWrapper.expense.Living_Exp_Int__c, expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c);
    }

    static testMethod void Expense_Test2() {
        //Joint with existing Expense (monthly and fortnight renting)
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Is_Primary_Applicant__c = false;
        //insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Res_Status__c = 'Renting';
        //insert testApplicant2;
        
        List<Applicant__c> apList = new List<Applicant__c>();
        apList.add(testApplicant);
        apList.add(testApplicant2);
        insert apList;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
        testExpense.Living_Exp_Int__c = 'Month';
        testExpense.Rent_Board_Pay_Int__c = 'Month';
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
        testExpense2.Rent_Board_Pay_Int__c = 'Fortnight';
        insert testExpense2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense exp = new APP_JointExpense();
            MyBudgetsExpenseWrapper mbew = new MyBudgetsExpenseWrapper(apList[0]); 
            mbew.applicant.Res_Status__c = 'Renting';
            exp.getPayOption();
            exp.getLivingExpenseInterval();
            exp.getRentExpenseInterval();
            APP_JointExpensesExt_INT expenseExt = new APP_JointExpensesExt_INT(standardCon);
            expenseExt.expenseValidationResults = true;
            expenseExt.expenseWrapper.validateExpense(false,'AU');            
            expenseExt.expense2Wrapper = new MyBudgetsExpenseWrapper(apList[0]);
            expenseExt.redirectTo = 'Next';
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = '';
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = 'Fortnight';
            expenseExt.pageRedirect();
            expenseExt.validateFields();
            expenseExt.updateJointApplicantResStatus();
        Test.StopTest();

        system.assertEquals(testApplicant.Id, expenseExt.expenseWrapper.applicant.Id);
       // system.assertEquals(testApplicant2.Id, expenseExt.expense2Wrapper.applicant.Id);
      //  system.assertEquals(expenseExt.expenseWrapper.applicant.Res_Status__c, expenseExt.expense2Wrapper.applicant.Res_Status__c);
       // system.assertEquals(expenseExt.expense2Wrapper.expense.Living_Exp_Int__c, 'Fortnight');
       // system.assertEquals(expenseExt.expenseWrapper.expense.Living_Exp_Int__c, expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c);
    } 
    
    static testMethod void Expense_Test3() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        //Joint with no Expense (weekly and fortnight)
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense exp = new APP_JointExpense();
            exp.getPayOption();
            exp.getLivingExpenseInterval();
            exp.getRentExpenseInterval();
            APP_JointExpensesExt_INT expenseExt = new APP_JointExpensesExt_INT(standardCon);
            expenseExt.redirectTo = 'Back';
            expenseExt.pageRedirect();
            expenseExt.redirectTo = 'Cancel';
            expenseExt.pageRedirect();
            expenseExt.redirectTo = 'Save';
            expenseExt.pageRedirect();
            expenseExt.redirectTo = 'Next';
            expenseExt.expenseWrapper.applicant.Res_Status__c = 'Please select';
            expenseExt.pageRedirect();
            expenseExt.validateFields();
            expenseExt.expenseWrapper.applicant.Res_Status__c = 'Living with friends/family';
            expenseExt.expenseWrapper.validateExpense(true,'AU');
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Agent_Landlord_Name__c = 'ERR1';
            expenseExt.expenseWrapper.expense.Agent_Landlord_Phone_Number__c = 'ERR1';
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Agent_Landlord_Phone_Number__c = 'ERR4';
            expenseExt.pageRedirect();
         //   expenseExt.expense2Wrapper.applicant.Res_Status__c = 'Living with friends/family';
            expenseExt.pageRedirect();
            expenseExt.recomputeTotalExpense();
            expenseExt.expenseWrapper.expense.Living_Exp__c = 1000;
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = 'Week';
            expenseExt.expenseWrapper.expense.Food_Groc_Entert__c = 1000;
            expenseExt.expenseWrapper.expense.Food_Groc_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Insurance_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Insurance_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Utilities_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Utilities_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Transport_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Transport_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Education_and_child_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Education_and_child_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Personal_Other_Expense__c = 1000;
            expenseExt.expenseWrapper.expense.Personal_Other_Expense_Interval__c = 'Week';
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c = 1000;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c = 'Week';
            
            expenseExt.pageRedirect();
          //  expenseExt.expense2Wrapper.expense.Living_Exp__c = 1000;
            expenseExt.pageRedirect();
          //  expenseExt.expense2Wrapper.expense.Living_Exp_Int__c = 'Fortnight';
            expenseExt.pageRedirect();
            expenseExt.recomputeTotalExpense();
            expenseExt.updateJointApplicantResStatus();
        Test.StopTest();

        system.assertEquals(testApplicant.Id, expenseExt.expenseWrapper.applicant.Id);
       // system.assertEquals(testApplicant2.Id, expenseExt.expense2Wrapper.applicant.Id);
        system.assertEquals(expenseExt.expenseWrapper.applicant.Res_Status__c, 'Living with friends/family');
       // system.assertEquals(expenseExt.expense2Wrapper.applicant.Res_Status__c, 'Living with friends/family');
        system.assertEquals(expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c, null);
        system.assertEquals(expenseExt.expenseWrapper.expense.Total_Exp__c.setScale(2), 30333.33);
       // system.assertEquals(expenseExt.expense2Wrapper.expense.Total_Exp__c.setScale(2), 2166.67);
        system.assertEquals(expenseExt.expenseWrapper.expense.Living_Exp_Int__c, 'Week');
    }
    
    static testMethod void Expense_Test4() {
        //Joint with existing Expense (monthly and fortnight renting)
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Is_Primary_Applicant__c = true;
        //insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Res_Status__c = 'Renting';
        //insert testApplicant2;
        
        List<Applicant__c> apList = new List<Applicant__c>();
        apList.add(testApplicant);
        apList.add(testApplicant2);
        insert apList;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicant.Id);
        testExpense.Living_Exp_Int__c = 'Month';
        testExpense.Rent_Board_Pay_Int__c = 'Month';
        insert testExpense;

        Expense__c testExpense2 = TestDataBuilder.createExpense(testApplicant2.Id);
        testExpense2.Rent_Board_Pay_Int__c = 'Fortnight';
        insert testExpense2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense exp = new APP_JointExpense();
            MyBudgetsExpenseWrapper mbew = new MyBudgetsExpenseWrapper(apList[0]); 
            mbew.applicant = testApplicant;
            mbew.applicant.Res_Status__c = 'Renting';
            exp.getPayOption();
            exp.getLivingExpenseInterval();
            exp.getRentExpenseInterval();
            APP_JointExpensesExt_INT expenseExt = new APP_JointExpensesExt_INT(standardCon);
            expenseExt.expenseValidationResults = true;
            expenseExt.expenseWrapper.validateExpense(false,'AU');            
            expenseExt.expense2Wrapper = new MyBudgetsExpenseWrapper(apList[0]);
            expenseExt.redirectTo = 'Next';
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = null;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c = null;
            expenseExt.pageRedirect();
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = null;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c = null;
            expenseExt.pageRedirect();
            expenseExt.validateFields();
            expenseExt.updateJointApplicantResStatus();
        Test.StopTest();

        system.assertEquals(testApplicant.Id, expenseExt.expenseWrapper.applicant.Id);
       // system.assertEquals(testApplicant2.Id, expenseExt.expense2Wrapper.applicant.Id);
      //  system.assertEquals(expenseExt.expenseWrapper.applicant.Res_Status__c, expenseExt.expense2Wrapper.applicant.Res_Status__c);
       // system.assertEquals(expenseExt.expense2Wrapper.expense.Living_Exp_Int__c, 'Fortnight');
       // system.assertEquals(expenseExt.expenseWrapper.expense.Living_Exp_Int__c, expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c);
    }

       static testMethod void Expense_Test5() {
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Res_Status__c = 'Renting';
        testApplicant.Is_Primary_Applicant__c = false;
        //insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Res_Status__c = 'Renting';
        //insert testApplicant2;
        
        List<Applicant__c> apList = new List<Applicant__c>();
        apList.add(testApplicant);
        apList.add(testApplicant2);
        insert apList;

        Expense__c exp1 = new Expense__c();
        
        Expense__c exp2 = new Expense__c();
        
        List<Expense__c> expList = new List<Expense__c>();
        expList.add(exp1);
        expList.add(exp2);
        
        try{
        insert expList;
        }
        catch(DMLException e){
         
        }
        
         ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
         APP_JointExpensesExt_INT expenseExt = new APP_JointExpensesExt_INT(standardCon);
            expenseExt.expenseValidationResults = true;
            expenseExt.expenseWrapper.validateExpense(false,'AU');            
            expenseExt.expenseWrapper.expense.Living_Exp_Int__c = null;
            expenseExt.expenseWrapper.expense.Living_Exp__c = null;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Amt__c = null;
            expenseExt.expenseWrapper.expense.Rent_Board_Pay_Int__c = null;
            expenseExt.validateFields();
            expenseExt.recomputeTotalExpense();

        
       }
    
   
       
}