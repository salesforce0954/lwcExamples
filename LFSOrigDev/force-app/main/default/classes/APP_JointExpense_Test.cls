@isTest
private class APP_JointExpense_Test {
    
    @isTest static void SelectOptions_Test() {
        List<SelectOption> testLivingExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Living_Exp_Int__c');
        List<SelectOption> testRentExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Rent_Board_Pay_Int__c');

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.channel__c = 'Broker';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            //ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense expense = new APP_JointExpense();
            
    
            List<SelectOption> LivingExpenseInterval = expense.getLivingExpenseInterval();
            List<SelectOption> RentExpenseInterval = expense.getRentExpenseInterval();
            
            List<SelectOption> FoodGrocExpenseInterval = expense.getFoodGrocExpenseInterval();
            List<SelectOption> InsuranceExpenseInterval = expense.getInsuranceExpenseInterval();
            List<SelectOption> UtilitiesExpenseInterval = expense.getUtilitiesExpenseInterval();
            List<SelectOption> TransportExpenseInterval = expense.getTransportExpenseInterval();
            List<SelectOption> EducationExpenseInterval = expense.getEducationExpenseInterval();
            List<SelectOption> MortgageExpenseInterval = expense.getMortgageExpenseInterval();
             List<SelectOption> SecondaryMortgageInterval = expense.getSecondaryMortgageInterval();
            List<SelectOption> OtherPropertyExpenseInterval = expense.getOtherPropertyExpenseInterval();
            List<SelectOption> AnyNewAdditionalExpenseInterval = expense.getAnyNewAdditionalExpenseInterval();
      
      
        Test.StopTest();

        System.assertEquals(2, expense.getPayOption().size());
        System.assertEquals(testLivingExpenseInterval.size()+1, LivingExpenseInterval.size());
        //System.assertEquals(testRentExpenseInterval.size()+1, RentExpenseInterval.size());
    }

    @isTest static void recomputeTotalExpenseComp_Test() {
        
        List<SelectOption> testLivingExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Living_Exp_Int__c');
        List<SelectOption> testRentExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Rent_Board_Pay_Int__c');

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Boarding Other';
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

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            //ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense expense = new APP_JointExpense();
            List<SelectOption> LivingExpenseInterval = expense.getLivingExpenseInterval();
            List<SelectOption> RentExpenseInterval = expense.getRentExpenseInterval();
            expense.region = 'NZ';
            expense.Country_NZ = 'NZ';
            expense.isJoint = true;

            expense.expenseWrapperComp = new MyBudgetsExpenseWrapper(testExpense,testApplicant);
            expense.recomputeTotalExpenseComp();
        Test.StopTest();

        System.assert(expense.expenseWrapperComp.expense.Total_Exp__c != null);
    }

    @isTest static void clearFields_Test() {
        
        List<SelectOption> testLivingExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Living_Exp_Int__c');
        List<SelectOption> testRentExpenseInterval = Util.getPicklistValues(new Expense__c(), 'Rent_Board_Pay_Int__c');

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Res_Status__c = 'Boarding Other';
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

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            //ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointExpense expense = new APP_JointExpense();
            List<SelectOption> LivingExpenseInterval = expense.getLivingExpenseInterval();
            List<SelectOption> RentExpenseInterval = expense.getRentExpenseInterval();
            expense.region = 'NZ';
            expense.isJoint = true;

            expense.expenseWrapperComp = new MyBudgetsExpenseWrapper(testExpense,testApplicant);
            expense.clearFields();
        Test.StopTest();

        System.assert(expense.expenseWrapperComp.expense.Total_Exp__c != null);
    }
}