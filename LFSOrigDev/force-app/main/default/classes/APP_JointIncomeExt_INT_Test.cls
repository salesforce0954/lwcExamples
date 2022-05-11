@isTest (seeALLData = false)
private class APP_JointIncomeExt_INT_Test {
    
    
    static testMethod void Income_Test() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';

            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Pensioner';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Rental Income';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Child Support';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

    static testMethod void Income_TestNZ() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Previous_Employment_Status__c = 'Full Time';
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;

        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
           
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
    }

     static testMethod void Income_TestNZ2() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Previous_Employment_Status__c = null;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        testApplicant.Previous_Employment_Status__c = null;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
           
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
    }
    
     static testMethod void Income_TestNZ3() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 0;
        testApplicant.Time_at_previous_employer_months__c = 1;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Previous_Employment_Status__c = 'full time';
        testApplicant.Prev_Emp_Bus_Name__c  = 'test';
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 0;
        testApplicant.Previous_Employment_Status__c = null;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
           
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        //System.assert(incomeExt.invalidPreEmployerMonth);
    }

    static testMethod void Income_TestNZ4() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 0;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Previous_Employment_Status__c = 'full time';
        testApplicant.Prev_Emp_Bus_Name__c  = 'test';
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 0;
        testApplicant.Previous_Employment_Status__c = null;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
           
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        //System.assert(incomeExt.invalidPreEmployerMonth);
    }
    
    static testMethod void Income_Test2() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;
        
        //Joint with existing Income for Applicant 1
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Primary_Employment_Status__c = 'Contractor';
        testApplicant.Time_at_previous_employer_months__c = 2;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Primary_Employment_Status__c = 'Contractor';
        testApplicant2.Time_at_previous_employer_months__c = 2;
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.redirectTo = 'Next';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Rental Income';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals('Next', incomeExt.redirectTo);
        System.assert(incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

    static testMethod void Income_Test3() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;
        
        //Joint with existing Income
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Primary_Employment_Status__c = 'Contractor';
        testApplicant.Time_at_previous_employer_months__c = 2;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Primary_Employment_Status__c = 'Contractor';
        testApplicant2.Time_at_previous_employer_months__c = 2;
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.selectedRow = 0;
            incomeExt.selectedList = 1;
            incomeExt.removethisIncome();
            incomeExt.selectedList = 2;
            incomeExt.getTotalIncome();
            incomeExt.removethisIncome();
            incomeExt.redirectTo = 'Next';
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals('Next', incomeExt.redirectTo);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(2, incomeExt.incomeListToDel.size());
    }

    

   static testMethod void Income_Test4() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        testApplicant2.Prev_Emp_Bus_Name__c  = null;
        testApplicant2.Previous_Employment_Status__c  = 'test';
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

     static testMethod void Income_Test9() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        testApplicant2.Prev_Emp_Bus_Name__c  = null;
        testApplicant2.Previous_Employment_Status__c  = 'test';
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '02123';
            incomeExt.incomeAddList.get(0).income.Employer_Business_Contact_No_Area_Code__c = '02';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Employer_Business_Contact_No_WS__c = '02';
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        
    }

    static testMethod void Income_Test5() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        testApplicant2.Prev_Emp_Bus_Name__c  = 'test';
        testApplicant2.Previous_Employment_Status__c  = 'test';
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 0; //mdavid
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 1; //mdavid
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

     static testMethod void Income_Test6() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 13;
        testApplicant2.Prev_Emp_Bus_Name__c  = 'test';
        testApplicant2.Previous_Employment_Status__c  = 'test';
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

    static testMethod void Income_Test7() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 0;
        testApplicant2.Prev_Emp_Bus_Name__c  = 'test';
        testApplicant2.Previous_Employment_Status__c  = 'test';
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }

    static testMethod void Income_Test8() {
        //Modified Tony Xu to Add in Brand
        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
        //Joint with no Income
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;        
        system.debug('====TXU===='+testApplication.Brand_Lookup__c);
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Time_at_previous_employer_years__c = 00; //mdavid
        testApplicant.Time_at_previous_employer_months__c = 00; //mdavid
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Previous_Employment_Status__c  = 'Full time'; //mdavid
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Time_at_previous_employer_years__c = 1;
        testApplicant2.Time_at_previous_employer_months__c = 1;
        testApplicant2.Prev_Emp_Bus_Name__c  = 'test';
        testApplicant2.Previous_Employment_Status__c  = null;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncome inc = new APP_JointIncome();
            inc.getIncomeSource();
            inc.getIncomeInterval();
            inc.getOccupation();
            APP_JointIncomeExt_INT incomeExt = new APP_JointIncomeExt_INT(standardCon);
            incomeExt.setApplicantTab();
            incomeExt.redirectTo = 'Back';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Cancel';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'POI';
            incomeExt.pageRedirect();
            incomeExt.redirectTo = 'Save';
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Occupation__c = null;
            incomeExt.incomeAddList.get(0).income.Income_Source__c ='Net Salary/Wages';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 00;
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 00;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR1';
            incomeExt.incomeAddList.get(0).income.Months_With_Employer__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = '<.>;';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = 'ERR4';
            incomeExt.incomeAddList.get(0).applicant.Time_at_previous_employer_months__c = 13;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList.get(0).income.Total_Income__c = 1000;
            incomeExt.incomeAddList.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
            incomeExt.incomeAddList.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList.get(0).income.Occupation__c = 'IT';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Name__c = 'Name';
            incomeExt.incomeAddList.get(0).income.Emp_Bus_Contact_No__c = '0412341324';
            incomeExt.incomeAddList.get(0).income.Years_With_Employer__c = 1;
            incomeExt.incomeAddList.get(0).income.Income_Amount__c = 1000;
            incomeExt.selectedList = 1;
            incomeExt.addIncome();
            incomeExt.incomeAddList.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT;

            incomeExt.incomeAddList2.get(0).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(0).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(0).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK;
            incomeExt.incomeAddList2.get(0).income.Total_Income__c = 1000;
            incomeExt.selectedList = 2;
            incomeExt.addIncome();
            incomeExt.incomeAddList2.get(1).income.Income_Source__c = 'Net Salary/Wages';
            incomeExt.incomeAddList2.get(1).income.Income_Amount__c = 1000;
            incomeExt.incomeAddList2.get(1).income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR;
            incomeExt.pageRedirect();
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 2;
            incomeExt.incomeAddList2.get(0).applicant.Primary_Employment_Status__c = 'Contractor';
            incomeExt.incomeAddList2.get(0).applicant.Time_at_previous_employer_months__c = 5;
            incomeExt.pageRedirect();
            //APP_JointIncomeExt_INT.MyBudgetsIncomeWrapper w = new incomeExt.MyBudgetsIncomeWrapper();
            //incomeExt.MyBudgetsIncomeWrapper.removeGovernmentBenefitType();

        Test.StopTest();

        System.assertEquals(testApplicant.Application__c, testApplication.Id);
        System.assertEquals(testApplicant2.Application__c, testApplication.Id);
        System.assertEquals(incomeExt.incomeListSize, incomeExt.incomeAddList.size());
        System.assertEquals(incomeExt.incomeList2Size, incomeExt.incomeAddList2.size());
        System.assertEquals(incomeExt.redirectTo, 'Save');
        System.assert(incomeExt.invalidPreEmployerMonth);
        System.assert(!incomeExt.invalidPreEmployerMonth2);
        System.assert(!incomeExt.employmentStatusValid);
        System.assert(!incomeExt.employmentStatusValid2);
        System.assert(!incomeExt.incomeValidationResults);
        System.assertEquals(0, incomeExt.incomeListToDel.size());
    }
}