/*Author: Russel Cadapan Cloud Sherpas
  Created Date: 01/28/2014
  Description: Test Class for APP_JointIncomeExt

*/
@isTest
public class APP_JointIncomeExt_Test {
    static testMethod void contructorWithExistingRecords_Test(){
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
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
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.setApplicantTab();
            income.getTimeOut();
            income.register();
            income.logout();
            income.getWarning();
        Test.StopTest();

        System.assertEquals(1, income.incomeAddList.size());
        System.assertEquals(1, income.incomeAddList2.size());
        System.assertEquals(testIncome.Id, income.incomeAddList[0].income.Id);
        System.assertEquals(testIncome2.Id, income.incomeAddList2[0].income.Id);
    }
    static testMethod void contructorWithNoExistingRecords_Test(){
        
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
        Test.StopTest();

        System.assertEquals(1, income.incomeAddList.size());
        System.assertEquals(1, income.incomeAddList2.size());
        System.assertEquals(null, income.incomeAddList[0].income.Id);
        System.assertEquals(null, income.incomeAddList2[0].income.Id);

    }

    static testMethod void removeIncome_Test(){
        
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Income__c testIncome3 = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome3;

        Income__c testIncome4 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome4;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.selectedList = 1;
            income.selectedRow = 1;
            income.removethisIncome();

            income.selectedList = 2;
            income.selectedRow = 1;
            income.removethisIncome();
        Test.StopTest();

        

        System.assertEquals(1, income.incomeAddList.size());
        System.assertEquals(1, income.incomeAddList2.size());
        System.assertEquals(testIncome.Id, income.incomeAddList[0].income.Id);
        System.assertEquals(testIncome2.Id, income.incomeAddList2[0].income.Id);
    }
    static testMethod void saveIncomeSuccess_Test(){
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Income__c testIncome3 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome3;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        Test.setCurrentPage(Page.App_JointIncome);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.selectedList = 2;
            income.selectedRow = 0;
            income.removethisIncome();
            income.redirectTo = 'Save';
            income.validateLoanFields();
            income.pageRedirect();
        Test.StopTest();

        //System.assertEquals(pageRedirect.getUrl(), income.pageRedirect().getUrl());
        System.assertEquals(testApplicant.Id, income.incomeAddList.get(0).income.Applicant__c);
    }
    static testMethod void saveIncomeTimeout_Test(){
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        PageReference pageRedirect = new PageReference('/apex/app_timeout');
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.redirectTo = 'Timeout';
            income.pageRedirect();
        Test.StopTest();
        
        //Mike TODO: sprint 10
        //System.assertEquals(pageRedirect.getUrl(), income.pageRedirect().getUrl());
        System.assertEquals(testApplicant.Id, income.incomeAddList.get(0).income.Applicant__c);
    }
    
    /*static testMethod void saveIncomePOI_Test(){
        
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_poi?id=' + testApplication.Id);
        
        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.redirectTo = 'POI';
            income.validateLoanFields();
            income.pageRedirect();
        Test.StopTest();
        
        //Mike TODO: sprint 10
        //System.assertEquals(pageRedirect.getUrl(), income.pageRedirect().getUrl());
        System.assertEquals(testApplicant.Id, income.incomeAddList.get(0).income.Applicant__c);
    }*/
    
    static testMethod void saveFaliure_Test(){
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Time_at_previous_employer_months__c = 12;
            testApplicant.Primary_Employment_Status__c = '';
            testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Time_at_previous_employer_months__c = 12;
            testApplicant2.Primary_Employment_Status__c = '';
            testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
            testIncome2.Income_Source__c = GEN_OriginationsConstants.INCOME_SOURCE_SEASONAL;
            testIncome2.Emp_Bus_Name__c = null;
            testIncome2.Emp_Bus_Contact_No__c = null;
            testIncome2.Total_Income__c = 100000;
        insert testIncome2;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_poi?id=' + testApplication.Id);
        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.redirectTo = 'POI';
            income.pageRedirect();
        Test.StopTest();
        
        System.assertEquals(null, income.pageRedirect());
    }
    static testMethod void removethisIncome_Test(){
        
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'AU';
        insert brand;   
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
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
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.selectedList = 1;
            income.selectedRow = 0;
            income.removethisIncome();

            income.selectedList = 2;
            income.selectedRow = 0;
            income.removethisIncome();
        Test.StopTest();

        System.assertEquals(1, income.incomeAddList.size());
        System.assertEquals(1, income.incomeAddList2.size());
        System.assertEquals(null, income.incomeAddList[0].income.Id);
        System.assertEquals(null, income.incomeAddList2[0].income.Id);
    }
    
    static testMethod void createQuoteIncome_Test(){
        //Added by Tony Xu to include brand in the application
        Brand__c brand = TestDataBuilder.createBrand();
        brand.country__c = 'NZ';
        insert brand;   
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = brand.id;
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

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Income_Redundancy__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Income_Redundancy__c = true;
        insert testApplicant2;

        /*Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Income__c testIncome3 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome3;*/

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);

        Test.setCurrentPage(Page.App_JointIncome);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointIncomeExt income = new APP_JointIncomeExt(standardCon);
            income.selectedList = 2;
            income.selectedRow = 0;
            income.isBetterStart = false;
            income.country = 'NZ';
            income.confirmIncomeChanges = 'Yes';
            income.confirmIncomeChangesA2 = 'Yes';
            income.confirmincomechange1 = 'Yes';
            income.confirmincomechange2 = 'Yes';
            income.removethisIncome();
            income.redirectTo = 'Save';
            income.validateLoanFields();
            income.pageRedirect();
        Test.StopTest();

        //System.assertEquals(pageRedirect.getUrl(), income.pageRedirect().getUrl());
        System.assertEquals(testApplicant.Id, income.incomeAddList.get(0).income.Applicant__c);
    }
    
}