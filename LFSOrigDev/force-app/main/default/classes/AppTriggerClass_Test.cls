/*
 * @Description: Test class for AppTriggerClass class
 * @Author: August Del Rosario
 * @Date Created: Jan-30-2014
 * @History:
   =====================================================================
       28-01-14: Created - August
                 Updated - Adrian Recio, updated myUnitTest5 method to include 
                           validateBrandOwnership method specific test.
   =====================================================================
 */
@isTest
private class AppTriggerClass_Test {

    static testMethod void myUnitTest() {
        Set<Id>idSet = new Set<Id>();

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        Brand__c testBrand = TestDatabuilder.createBrandNZ();
        insert testBrand;

        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'SCR';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        TestDataBuilder.createListInsurancePremiumVars();

        List<Application__c> applicationList = new List<Application__c>();
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Channel__c = 'Broker';
        testApplication.Brand_Lookup__c = testBrand.id;
        applicationList.add(testApplication);        
        insert applicationList;

        Response_Code_Control__c responseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, String.valueOf(applicationList[0].Response_Code__c));
        insert responseCodeControl2;
        system.assertEquals(String.valueOf(applicationList[0].Response_Code__c),responseCodeControl2.Name);//assert inserted Response_Code_Control__c

        idSet.add(testApplication.Id);
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        Applicant__c testApplicant = TestDataBuilder.createApplicant(acc.Id, testApplication.Id);
        
        
        List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
        Set<Id> appIds = new Set<Id>();
        Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
        appIds.add(testCompliance.Id);
        complianceList.add(testCompliance);
        insert complianceList;

        RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Broker Fee'];

        Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applicationList[0].Id);
        testDisbursement.RecordType = disRecordType;
        insert testDisbursement;

        String prof1 = 'PFR';
        String prof2 = 'BM';

        Test.startTest();
            insert testApplicant;
            AppTriggerClass atc = new AppTriggerClass();
            atc.updateComplianceDate(complianceList, prof1);
            atc.updateComplianceDate(complianceList, prof2);
            atc.updateCreditFileCheckbox(idSet);
            atc.updateCorrelationId(applicationList);
            atc.updateCreditFileCheckbox(appIds);
            //atc.createDisbursement(applicationList);
            
        Test.stopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(testApplication.Id, testCompliance.Application__c);
        System.assertEquals(testApplication.Id, testDisbursement.Application__c);
        System.assertEquals(disRecordType, testDisbursement.RecordType);
    }

    static testMethod void myUnitTest2() {
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;

        Brand__c testBrand = TestDatabuilder.createBrandNZ();
        insert testBrand;

        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'SCR';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        TestDataBuilder.createListInsurancePremiumVars();
        
        Set<Id>idSet = new Set<Id>();
        List<Application__c> applicationList = new List<Application__c>();
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Channel__c = 'Broker';
        testApplication.Brand_Lookup__c = testBrand.id;
        applicationList.add(testApplication);        
        insert applicationList;

        Response_Code_Control__c responseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, String.valueOf(applicationList[0].Response_Code__c));
        insert responseCodeControl2;
        system.assertEquals(String.valueOf(applicationList[0].Response_Code__c),responseCodeControl2.Name);//assert inserted Response_Code_Control__c
        
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        Applicant__c testApplicant = TestDataBuilder.createApplicant(acc.Id, testApplication.Id);
        insert testApplicant;
        
        idSet.add(testApplicant.Id);
        
        List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
        Set<Id> appIds = new Set<Id>();
        Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
        appIds.add(testCompliance.Id);
        testCompliance.PFR_Check__c = null;
        testCompliance.BM_Check__c  = null;
        complianceList.add(testCompliance);
        insert complianceList;

        RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Broker Fee'];

        Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applicationList[0].Id);
        testDisbursement.RecordType = disRecordType;
        insert testDisbursement;

        String prof1 = 'PFR';
        String prof2 = 'BM';

        Test.startTest();
            AppTriggerClass atc = new AppTriggerClass();
            atc.updateComplianceDate(complianceList, prof1);
            atc.updateComplianceDate(complianceList, prof2);
            atc.updateCreditFileCheckbox(idSet);
            atc.updateCorrelationId(applicationList);
            atc.updateCreditFileCheckbox(appIds);
            atc.verifyDeletedCFC(idSet);
        Test.stopTest();

        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(testApplication.Id, testCompliance.Application__c);
        System.assertEquals(testApplication.Id, testDisbursement.Application__c);
        System.assertEquals(disRecordType, testDisbursement.RecordType);
    }

    static testMethod void myUnitTest3() {
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        Profile_Control__c prof = testDataBuilder.createProfileControl(true);
        insert prof;


        TestDataBuilder.createListInsurancePremiumVars();
        
        Set<Id> idSet = new Set<Id>();
        List<Application__c> applicationList = new List<Application__c>();
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        applicationList.add(testApplication);        
        insert applicationList;     

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        testProductItem.Name = GEN_OriginationsConstants.LIFE_INSURANCE;
        insert testProductItem;

        Product_Item__c testProductItem2 = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        testProductItem2.Name = GEN_OriginationsConstants.DISABILITY_INSURANCE;
        insert testProductItem2;
        
        Product_Item__c testProductItem3 = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        testProductItem3.Name = GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE;
        insert testProductItem3;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, String.valueOf(applicationList[0].Response_Code__c));
        insert responseCodeControl;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        
        system.assertEquals(String.valueOf(applicationList[0].Response_Code__c),responseCodeControl.Name);//assert inserted Response_Code_Control__c
        
        idSet.add(testApplication.Id);

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(acc.Id, testApplication.Id);
        insert testApplicant;

        Test.startTest();
            AppTriggerClass atc = new AppTriggerClass();
            atc.calculateOfferedRate(applicationList, true, true);
        Test.stopTest();

        System.assertEquals(testProduct.Brands__c, testBrand.Id);
        System.assertEquals(testProductVersion.GEProduct__c, testProduct.Id);
        System.assertEquals(testApplication.Brand_Lookup__c, testBrand.Id);
        System.assertEquals(testApplicant.Application__c, testApplication.Id);
    }

    //create auto-risk referral workflow and feed item post
    static testMethod void myUnitTest4(){

        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;

        Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
        responseCodeControl.Name = 'SCR';
        responseCodeControl.Decision__c = 'System';
        responseCodeControl.Close_CLV__c = true;
        responseCodeControl.CPU_Case_CLV__c = true;
        responseCodeControl.Edit_CLV__c = true;
        responseCodeControl.Type__c = 'Conditionally Approved';
        responseCodeControl.Personal_Reference_Check__c = true;
        responseCodeControl.Credit_Ref_Check__c = true;
        responseCodeControl.Credit_File_Check__c = true;
        responseCodeControl.Risk_Referral__c = true;
        responseCodeControl.Lending_Limit_Override__c = false;
        responseCodeControl.Rate_Reduction__c = false;
        responseCodeControl.Fee_Reduction__c = false;
        responseCodeControl.Manager_Approval__c = true;
        responseCodeControl.Save_Collateral_Standard__c = true;
        responseCodeControl.Save_Debit_Standard__c = true;
        responseCodeControl.Save_Disbursement_Standard__c = true;
        responseCodeControl.Edit_Collateral_Standard__c = true;
        responseCodeControl.Edit_Debit_Standard__c = true;
        responseCodeControl.Delete_Collateral_Standard__c = true;
        responseCodeControl.Delete_Debit_Standard__c = true;
        responseCodeControl.Delete_Disbursement_Standard__c = true;
        insert responseCodeControl;

        // Grant Profile Access to current user
        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
            
        // Create Admin Settings
        List<Admin_Settings__c> adminSettingsList = testDataBuilder.adminSet();
        insert adminSettingsList;   
        
        // Create 'Clone' Response Code Access
        Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'Clone'); 
        insert rccVar;
        
        // Create Account
        List<Account> accVar = testDataBuilder.createPersonAccounts(1);
        accVar[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accVar;
        
        // Create Billing ICBS 
        List<Billing_ICBS__c> billICBS = testDataBuilder.createBIcbs(2, accVar[0].Id);
        billICBS[0].Account_Number__c = '2000018223345';
        billICBS[0].Contract_Date__c = '31/08/2015';
        billICBS[1].Account_Number__c = '2000018223344';
        billICBS[1].Contract_Date__c = '25/08/2015';
        insert billICBS;
        
        // Create Campaign
        List<Campaign> camList = TestDataBuilder.createCampaign(1);
        camList[0].Promotional_Campaign__c = '60 Day Certificate';
        insert camList; 
        
        // Create Lead (Opportunity)
        List<Opportunity> oppVar = testDataBuilder.createOpportunities(1, accVar[0].Id);
        oppVar[0].Name = 'Test Lead Joint';
        oppVar[0].StageName = 'New';
        oppVar[0].Application_Number__c = '18223345'; 
        oppVar[0].Contract_Date__c = Date.valueOf('2015-08-31');
        oppVar[0].CampaignId = camList[0].Id;
        insert oppVar;

        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;

        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicant
        Applicant__c testApplicant = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
        testApplicant.Has_AML__c = true; 
        appliList.add(testApplicant);
        insert appliList;

        // Create Applicant Account Customer
        Applicant_Account_Customer__c testAppAccCust = TestDataBuilder.createApplicantAccountCustomer(testApplicant.Id);
        insert testAppAccCust;
        
        // Create Income for Applicant 1 and 2
        List<Income__c>appliIncomeList = new List<Income__c>();
        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        appliIncomeList.add(testIncome);
        insert appliIncomeList;

        // Create Expense for Applicant 1 and 2
        List<Expense__c>appliExpList = new List<Expense__c>();
        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        appliExpList.add(testExpense);
        insert appliExpList;

        // Create Liability for Applicant 1
        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.status__c = 'Referred: Refer to CPU/CMO';
        test.startTest();
        update testApplication;    
        test.stopTest();
    }

    static testMethod void myUnitTest5() {
        Set<Id>idSet = new Set<Id>();

        /**Create CMO user**/
        Profile p = [SELECT id FROM Profile WHERE name = 'System Administrator'];
        User usr = TestDataBuilder.createUser(p.id);
        insert usr;
        /****/      
        
        system.runAs(usr){
            NZ_Specific_Settings__c nz = new NZ_Specific_Settings__c();
            nz.name='CMO Manager';
            nz.Value__c = usr.Username;
            
                insert nz;
                        
            Profile_Control__c prof = testDataBuilder.createProfileControl(true);
            insert prof;
    
            Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
            responseCodeControl.Name = 'SCR';
            responseCodeControl.Decision__c = 'System';
            responseCodeControl.Close_CLV__c = true;
            responseCodeControl.CPU_Case_CLV__c = true;
            responseCodeControl.Edit_CLV__c = true;
            responseCodeControl.Type__c = 'Conditionally Approved';
            responseCodeControl.Personal_Reference_Check__c = true;
            responseCodeControl.Credit_Ref_Check__c = true;
            responseCodeControl.Credit_File_Check__c = true;
            responseCodeControl.Risk_Referral__c = true;
            responseCodeControl.Lending_Limit_Override__c = false;
            responseCodeControl.Rate_Reduction__c = false;
            responseCodeControl.Fee_Reduction__c = false;
            responseCodeControl.Manager_Approval__c = true;
            responseCodeControl.Save_Collateral_Standard__c = true;
            responseCodeControl.Save_Debit_Standard__c = true;
            responseCodeControl.Save_Disbursement_Standard__c = true;
            responseCodeControl.Edit_Collateral_Standard__c = true;
            responseCodeControl.Edit_Debit_Standard__c = true;
            responseCodeControl.Delete_Collateral_Standard__c = true;
            responseCodeControl.Delete_Debit_Standard__c = true;
            responseCodeControl.Delete_Disbursement_Standard__c = true;
            insert responseCodeControl;
            
    
            TestDataBuilder.createListInsurancePremiumVars();
    
            Brand__c testBrand = TestDatabuilder.createBrandNZ();
            insert testBrand;
    
            List<Application__c> applicationList = new List<Application__c>();

            // Test App 1
            Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
            testApplication.Channel__c = 'Broker';
            testApplication.Status__c = 'Referred: Refer to CPU/CMO';
            testApplication.Response_code__c  = 'SCR';

            // Added by: Adrian Recio
            // Date: 26/08/2015
            // Description: ownership validation specific application
            // Test App 2 specific to ownership validation
            Application__c testApplication2 = TestDataBuilder.createApplicationNZ(testBrand);
            testApplication2.Channel__c = 'Broker';
            testApplication2.Status__c = 'Referred: Refer to CPU/CMO';
            testApplication2.Response_code__c  = 'SCR';

            //testApplitication.Brand_Lookup__c = testBrand.id;
            applicationList.add(testApplication);  
            applicationList.add(testApplication2);  
            insert applicationList;

            Response_Code_Control__c responseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, String.valueOf(applicationList[0].Response_Code__c));
            insert responseCodeControl2;
            system.assertEquals(String.valueOf(applicationList[0].Response_Code__c),responseCodeControl2.Name);//assert inserted Response_Code_Control__c
    
    
            idSet.add(testApplication.Id);
            Account acc = TestDataBuilder.createPersonAccount();
            insert acc;
            Applicant__c testApplicant = TestDataBuilder.createApplicant(acc.Id, testApplication.Id);
            
            
            List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
            Set<Id> appIds = new Set<Id>();
            Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
            appIds.add(testCompliance.Id);
            complianceList.add(testCompliance);
            insert complianceList;
    
            RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Broker Fee'];
    
            Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applicationList[0].Id);
            testDisbursement.RecordType = disRecordType;
            insert testDisbursement;
    
            String prof1 = 'PFR';
            String prof2 = 'BM';
            
            // Updated by: Adrian Recio
            // Date: 26/08/2015
            // Description: Test Values for testing validateBrandOwnership method.
            //              Standard user and queue test instance.
            // Create standard user
            List<User> valOwnerUserList = new List<User>();
            Profile profVar = [Select Id from Profile where Name='A1 Originations Staff Profile'];
            User stndUsr = testDataBuilder.createUser(profVar.Id);
            stndUsr.Username = 'stndUsr@mail.com';
            stndUsr.CommunityNickname = 'stndU';

            User stndUsr2 = testDataBuilder.createUser(profVar.Id);
            stndUsr2.Username = 'stndUsr2@mail.com';
            stndUsr2.CommunityNickname = 'stndU2';

            valOwnerUserList.add(stndUsr);
            valOwnerUserList.add(stndUsr2);
            insert valOwnerUserList;

            // Create queu user
            Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Application__c');
            insert q1;

            // Result flag
            Boolean stndAssignF = false;
            Boolean stndAssignS = false;
            Boolean queueAssignS = false;

            Test.startTest();
                insert testApplicant;
                AppTriggerClass atc = new AppTriggerClass();
                atc.updateComplianceDate(complianceList, prof1);
                atc.updateComplianceDate(complianceList, prof2);
                atc.updateCreditFileCheckbox(idSet);
                //atc.updateCorrelationId(applicationList);
                atc.updateCreditFileCheckbox(appIds);
                //atc.createDisbursement(applicationList);

                // Updated by: Adrian Recio
                // Date: 26/08/2015
                // Description: Test call for validateBrandOwnership method.

                // Test ownership assignment for queue user
                try{
                    applicationList[0].ownerId = g1.Id;
                    update applicationList;     
                    queueAssignS = true;
                }catch(exception e){
                    system.debug('Queue owner exception:' + e.getMessage());
                }

                // Test ownership assignment for standard user
                try{
                    applicationList[0].ownerId = stndUsr.Id;
                    update applicationList;     
                }catch(exception e){
                    stndAssignF = true;
                    system.debug('Standard owner exception:' + e.getMessage());
                }

                // Create test valid brand assignment
                List<Brand_Assignment__c> baList = new List<Brand_Assignment__c>();
                Brand_Assignment__c baVar = testDataBuilder.createBrandAssignment(stndUsr.Id,testBrand.Id);
                Brand_Assignment__c baVar2 = testDataBuilder.createBrandAssignment(stndUsr2.Id,testBrand.Id);
                baList.add(baVar);
                baList.add(baVar2);
                insert baList;

                // Test ownership assignment for standard user
                try{
                    applicationList[0].ownerId = stndUsr.Id;
                    applicationList[1].ownerId = stndUsr2.Id;
                    update applicationList;     
                    stndAssignS = true;
                }catch(exception e){
                    system.debug('Standard owner exception:' + e.getMessage());
                }
            Test.stopTest();
    
            System.assertEquals(testApplication.Id, testApplicant.Application__c);
            System.assertEquals(testApplication.Id, testCompliance.Application__c);
            System.assertEquals(testApplication.Id, testDisbursement.Application__c);
            System.assertEquals(disRecordType, testDisbursement.RecordType);

            // Updated by: Adrian Recio
            // Date: 26/08/2015
            // Description: Assert validateBrandOwnership method test
            /**
            System.assertEquals(true,stndAssignF);
            System.assertEquals(true,stndAssignS);
            System.assertEquals(true,queueAssignS);
            **/
        }
    }
    
    static testMethod void myUnitTest6() {
        Set<Id>idSet = new Set<Id>();

        /**Create CMO user**/
        Profile p = [SELECT id FROM Profile WHERE name = 'System Administrator'];
        User usr = TestDataBuilder.createUser(p.id);
        insert usr;
        /****/      
        
        system.runAs(usr){
            NZ_Specific_Settings__c nz = new NZ_Specific_Settings__c();
            nz.name='CMO Manager';
            nz.Value__c = usr.Username;
            
                insert nz;
                        
            Profile_Control__c prof = testDataBuilder.createProfileControl(true);
            insert prof;
    
            Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
            responseCodeControl.Name = 'SCR';
            responseCodeControl.Decision__c = 'System';
            responseCodeControl.Close_CLV__c = true;
            responseCodeControl.CPU_Case_CLV__c = true;
            responseCodeControl.Edit_CLV__c = true;
            responseCodeControl.Type__c = 'Conditionally Approved';
            responseCodeControl.Personal_Reference_Check__c = true;
            responseCodeControl.Credit_Ref_Check__c = true;
            responseCodeControl.Credit_File_Check__c = true;
            responseCodeControl.Risk_Referral__c = true;
            responseCodeControl.Lending_Limit_Override__c = false;
            responseCodeControl.Rate_Reduction__c = false;
            responseCodeControl.Fee_Reduction__c = false;
            responseCodeControl.Manager_Approval__c = true;
            responseCodeControl.Save_Collateral_Standard__c = true;
            responseCodeControl.Save_Debit_Standard__c = true;
            responseCodeControl.Save_Disbursement_Standard__c = true;
            responseCodeControl.Edit_Collateral_Standard__c = true;
            responseCodeControl.Edit_Debit_Standard__c = true;
            responseCodeControl.Delete_Collateral_Standard__c = true;
            responseCodeControl.Delete_Debit_Standard__c = true;
            responseCodeControl.Delete_Disbursement_Standard__c = true;
            insert responseCodeControl;
            
    
            TestDataBuilder.createListInsurancePremiumVars();
    
            Brand__c testBrand = TestDatabuilder.createBrandNZ();
            insert testBrand;
            
            Account acc = TestDataBuilder.createPersonAccount();
            insert acc;
            
            // Create Lead (Opportunity)
            List<Opportunity> oppVar = testDataBuilder.createOpportunities(3, acc.Id);
            oppVar[0].Name = 'Test Lead Joint';
            oppVar[0].StageName = 'New';
            oppVar[0].X3rd_Party_Lead_Number__c = 'app123';
            oppVar[0].X3rd_Party_Photo__c = 'Test';
            oppVar[0].Application_Number__c = '18223345'; 
            oppVar[0].X3rd_Party_Photo_Tag__c = 'Car';
            oppVar[0].X3rd_Party_Lead_Source__c = 'PicStarter';
            
            oppVar[1].Name = 'Test Lead Joint';
            oppVar[1].StageName = 'New';
            oppVar[1].X3rd_Party_Lead_Number__c = 'app1231';
            oppVar[1].X3rd_Party_Photo__c = 'Test';
            oppVar[1].Application_Number__c = '18223345'; 
            oppVar[1].X3rd_Party_Photo_Tag__c = 'Car';
            oppVar[1].X3rd_Party_Lead_Source__c = 'Veda Quote';
            insert oppVar;
            
            Attachment testAttachment = testDatabuilder.createAttachment(oppVar[0].Id);
            testAttachment.Name = 'PicStarter Conversation'; 
            insert testAttachment;
            
            List<Application__c> applicationList = new List<Application__c>();
    
            // Test App 1
            Application__c testApplication = TestDataBuilder.createApplicationNZ(testBrand);
            testApplication.Channel__c = 'Broker';
            testApplication.Status__c = 'Referred: Refer to CPU/CMO';
            testApplication.Response_code__c  = 'SCR';
            testApplication.Total_Insurance_Premium__c = 100;
            testApplication.Credit_Score__c = 'AAA';
            
            Application__c testApplication2 = TestDataBuilder.createApplicationNZ(testBrand);
            testApplication2.Channel__c = 'Broker';
            testApplication2.Status__c = 'Referred: Refer to CPU/CMO';
            testApplication2.Response_code__c  = 'SCR';
            testApplication2.Total_Insurance_Premium__c = 100;
            testApplication2.Credit_Score__c = 'AAA';
            testApplication2.Out_Of_Sync__c = false;
            testApplication2.Adjusted_Interest_Rate__c = 12.99;
            
            Application__c testApplication3 = TestDataBuilder.createApplication();
            testApplication3.X3rd_Party_Application_Source__c = 'PicStarter';
            testApplication3.Mirror__c = 'PicStarter';
            testApplication3.X3rd_Party_Application_Number__c = 'app123';
            testApplication3.Response_code__c = 'PCO';
            testApplication2.Credit_Score__c = 'AA';
            testApplication3.Out_Of_Sync__c = True;
            testApplication3.PCA_Flush__c = False;
            testApplication3.Generated_Doc_Confirm_Sent__c = True;
            testApplication3.Adjusted_Interest_Rate__c = 14.99;
            testApplication3.Total_Insurance_Premium__c = 100;
            testApplication3.Acceptance_Channel__c = 'Offline Acceptance';
            
            Application__c testApplication4 = TestDataBuilder.createApplication();
           // testApplication4.X3rd_Party_Application_Source__c = 'Veda Quote';
            testApplication4.Mirror__c = 'Veda Quote';
            testApplication4.X3rd_Party_Application_Number__c = 'app1232';
            testApplication4.Max_Monthly_Capacity__c = 1000;
            testApplication4.EMI_with_Service_Fee__c = 5000;
            testApplication4.EVerifier_Income_Applicant_1__c = 6000;
            testApplication4.Application_Type__c = 'Single';
            testApplication4.Acceptance_Channel__c = 'Online Acceptance';
            testApplication4.Total_Insurance_Premium__c = 1000;
                       
            applicationList.add(testApplication);  
            applicationList.add(testApplication2);  
            applicationList.add(testApplication3);  
            applicationList.add(testApplication4);
            insert applicationList;
            
            Force_com_Site_URL__c cs = new Force_com_Site_URL__c();
            cs.Name = 'Latitude';
            cs.Site_URL__c = 'test';
            insert cs;
                        
            Applicant__c testApplicant = TestDataBuilder.createApplicant(acc.Id, applicationList[0].Id);
            insert testApplicant;
            
            
            Response_Code_Control__c responseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, String.valueOf(applicationList[2].Response_Code__c));
            insert responseCodeControl2;    
            system.assertEquals(String.valueOf(testApplication3.Response_Code__c),responseCodeControl2.Name);//assert inserted Response_Code_Control__c
    
    
            idSet.add(testApplication3.Id);
            
            List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
            Set<Id> appIds = new Set<Id>();
            Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(applicationList[2].Id);
            appIds.add(testCompliance.Id);
            complianceList.add(testCompliance);
            insert complianceList;
    
            RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Broker Fee'];
    
            Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applicationList[0].Id);
            testDisbursement.RecordType = disRecordType;
            insert testDisbursement;
    
            String prof1 = 'PFR';
            String prof2 = 'BM';
            
            List<User> valOwnerUserList = new List<User>();
            Profile profVar = [Select Id from Profile where Name='A1 Originations Staff Profile'];
            User stndUsr = testDataBuilder.createUser(profVar.Id);
            stndUsr.Username = 'stndUsr@mail.com';
            stndUsr.CommunityNickname = 'stndU';

            User stndUsr2 = testDataBuilder.createUser(profVar.Id);
            stndUsr2.Username = 'stndUsr2@mail.com';
            stndUsr2.CommunityNickname = 'stndU2';

            valOwnerUserList.add(stndUsr);
            valOwnerUserList.add(stndUsr2);
            insert valOwnerUserList;

            // Create queu user
            Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Application__c');
            insert q1;

            // Result flag
            Boolean stndAssignF = false;
            Boolean stndAssignS = false;
            Boolean queueAssignS = false;

            Test.startTest();
            AppTriggerClass.generate3rdPartyURL(applicationList);
            AppTriggerClass.clear_execution_flags();
            AppTriggerClass.invokeNegativeCapacityWS(applicationList);
            AppTriggerClass.accessControl(applicationList);
                AppTriggerClass atc = new AppTriggerClass();
                atc.updateComplianceDate(complianceList, prof1);
                atc.updateComplianceDate(complianceList, prof2);
                atc.updateCreditFileCheckbox(idSet);
                atc.updateCreditFileCheckbox(appIds);
                atc.recalculateRepayments(idSet);
                
                // Test ownership assignment for queue user
                try{
                    applicationList[2].ownerId = g1.Id;
                    update applicationList[2];     
                    queueAssignS = true;
                }catch(exception e){
                    system.debug('Queue owner exception:' + e.getMessage());
                }

                // Test ownership assignment for standard user
                try{
                    applicationList[2].ownerId = stndUsr.Id;
                    update applicationList[2];     
                }catch(exception e){
                    stndAssignF = true;
                    system.debug('Standard owner exception:' + e.getMessage());
                }

                // Create test valid brand assignment
                List<Brand_Assignment__c> baList = new List<Brand_Assignment__c>();
                Brand_Assignment__c baVar = testDataBuilder.createBrandAssignment(stndUsr.Id,testBrand.Id);
                Brand_Assignment__c baVar2 = testDataBuilder.createBrandAssignment(stndUsr2.Id,testBrand.Id);
                baList.add(baVar);
                baList.add(baVar2);
                insert baList;

                // Test ownership assignment for standard user
                try{
                    applicationList[2].ownerId = stndUsr.Id;
                    applicationList[2].ownerId = stndUsr2.Id;
                    update applicationList[2];     
                    stndAssignS = true;
                }catch(exception e){
                    system.debug('Standard owner exception:' + e.getMessage());
                }
            Test.stopTest();
    
            System.assertEquals(applicationList[0].Id, testApplicant.Application__c);
            System.assertEquals(applicationList[2].Id, testCompliance.Application__c);
            System.assertEquals(applicationList[0].Id, testDisbursement.Application__c);
            System.assertEquals(disRecordType, testDisbursement.RecordType);
        }
    }
    
}