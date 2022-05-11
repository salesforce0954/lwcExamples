/*
 * @Description: APP_EligibiltyExt test class
 * @Author: Jade Serrano
 * @Date Created: 14-MAR-2014
 * @History:
 *  =====================================================================
 *      Jade - 14-MAR-2014: Created
 *      Russell - 10-APR-2014: Added Test Methods   
 *  =====================================================================
 */
 @isTest
public with sharing class APP_EligibilityExt_Test {
    
    @testSetup static void staticRecords() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Status__c = 'Active';
        testBrand.Site__c = null;
        testBrand.Loan_Term__c = '6 months;2 year';
        insert testBrand;
        
        List<Brand_Content__c> testBrandContentList = new List<Brand_Content__c>();

        Brand_Content__c testBrandContent = TestDataBuilder.createBrandContent(testBrand.id);
        testBrandContent.Description__c = 'Eligibility Questions';
        testBrandContentList.add(testBrandContent);

        Brand_Content__c testBrandContentBroker = TestDataBuilder.createBrandContent(testBrand.id);
        testBrandContentBroker.Description__c = 'Eligibility Broker Questions';
        testBrandContentList.add(testBrandContentBroker);
        insert testBrandContentList;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
    
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
    }

    static testMethod void picklistValues_Test(){
        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.getloanTermOptions();
            controller.getloanFrequencyOptions();
            controller.loanFrequencySelected = 'test';
            controller.isApp1AccessNumber = false;
            controller.isApp2AccessNumber = false;
            controller.result = 'test';

        Test.stopTest();
    }

    static testMethod void pageActionPostSubmit_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'Submitted';
        insert testApplication;
        
        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.validatePostSubmit();
        Test.stopTest();
    }

    static testMethod void pageActionBroker_Test(){
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
            ProfileId = profile1.Id,
            UserRoleId = [SELECT ID FROM UserRole WHERE name = 'System Administrator'].id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);        
        
        System.runAs ( portalAccountOwner1 ) {
            Account acc = new Account (Name = 'newAcc1');  
            insert acc;
            
            Contact con = new Contact (
                AccountId = acc.id,
                LastName = 'portalTestUser'
            );
            insert con;
    
            Profile customerProfile = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1]; 
            
            User customer = TestDatabuilder.createUser2(customerProfile.Id);
            customer.contactId = con.id;
            insert customer;

            System.runAs(customer){
                Test.startTest();
                Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
                if(bsoffer==null){
                bsoffer.BetterStartAUActive__c = false;   
                bsoffer.BetterStartNZActive__c = false;        
                }
                insert bsoffer;
    
                    APP_EligibilityExt controller = new APP_EligibilityExt();
                    ApexPages.CurrentPage().getParameters().put('form', 'broker');
                    controller.validatePostSubmit();
                Test.stopTest();
            }            
        }
    }

    static testMethod void constructorNewApp_Test(){
        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            APP_EligibilityExt controller = new APP_EligibilityExt();
        Test.stopTest();
    }

    static testMethod void constructorBroker_Test(){
        ApexPages.CurrentPage().getParameters().put('form', 'broker');

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
        Test.stopTest();
    }

    static testMethod void constructorVeda_Test(){
        ApexPages.CurrentPage().getParameters().put('sourceid', '3');
        ApexPages.CurrentPage().getParameters().put('amount', '5000');

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
        Test.stopTest();
    }

    static testMethod void constructorExistingSingleApp_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRef = Page.APP_Eligibility;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            APP_EligibilityExt controller = new APP_EligibilityExt();
        Test.stopTest();
    }

    static testMethod void constructorExistingJointApp_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        PageReference pageRef = Page.APP_Eligibility;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
        Test.stopTest();
    }

    static testMethod void removeLoanPurpose_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference pageRef = Page.APP_Eligibility;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.removeLoanPurpose();
        Test.stopTest();
    }

    static testMethod void nextPageNegative_Test(){
        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            ApexPages.CurrentPage().getParameters().put('form', 'broker');
            controller.addLoanPurpose();
            controller.loanWrapList[0].Loan.Value__c = 'Please Select';
            controller.loanWrapList[1].Loan.Value__c = 'Other';
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositive_Test(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(null, ONRrecordType.Id);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationType = 'Single';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            ApexPages.CurrentPage().getParameters().put('gemid1', 'test');
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveJoint_Test(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(null, ONRrecordType.Id);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationType = 'Joint';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.confirm2EligibleForLoan = true;
            controller.confirm2ApplicationMeetsNeeds = true;
            controller.confirm2AgreedToPolicy = true;
            controller.confirm2KBHLGraduateCustomer = true;
            controller.confirm2InterestedInOtherOffer = true;
            controller.confirm2ReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveExistingSingle_Test(){
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveExistingJoint_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationType = 'Joint';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.confirm2EligibleForLoan = true;
            controller.confirm2ApplicationMeetsNeeds = true;
            controller.confirm2AgreedToPolicy = true;
            controller.confirm2KBHLGraduateCustomer = true;
            controller.confirm2InterestedInOtherOffer = true;
            controller.confirm2ReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveExistingSingleToJoint_Test(){
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationType = 'Joint';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.confirm2EligibleForLoan = true;
            controller.confirm2ApplicationMeetsNeeds = true;
            controller.confirm2AgreedToPolicy = true;
            controller.confirm2KBHLGraduateCustomer = true;
            controller.confirm2InterestedInOtherOffer = true;
            controller.confirm2ReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveVeda_Test(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(null, ONRrecordType.Id);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        ApexPages.CurrentPage().getParameters().put('gemid2', 'test');
        ApexPages.CurrentPage().getParameters().put('sourceid', '3');
        ApexPages.CurrentPage().getParameters().put('amount', '5000');
        ApexPages.CurrentPage().getParameters().put('gender', 'm');
        ApexPages.CurrentPage().getParameters().put('dob', '01011980');

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationType = 'Single';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveKiwibank_Test(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(null, ONRrecordType.Id);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        ApexPages.CurrentPage().getParameters().put('form', 'postshop');

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.kiwiComments = 'Test';
            controller.applicationType = 'Single';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositiveBroker_Test(){
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(null, ONRrecordType.Id);
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Contact testBroker = TestDataBuilder.createBrokerRecord();
        insert testBroker;

        ApexPages.CurrentPage().getParameters().put('form', 'broker');

        Contact broker = [SELECT Broker_ID__c FROM Contact WHERE Id =: testBroker.Id LIMIT 1];

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.brokerId = broker.Broker_ID__c;
            controller.applicationType = 'Single';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

    static testMethod void nextPagePositivePicStarter_Test(){
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        testApplication.X3rd_Party_Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER;
        insert testApplication;

        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);

        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.applicationSource = GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER;
            controller.applicationType = 'Single';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }
     static testMethod void nextPageQuoteSingle_Test(){
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
         
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
         Street_Type_Setting__c streetType = new Street_Type_Setting__c();
        streetType.Name='Road';
        streetType.Value__c='Road';
        streetType.Region__c='Both';
        streetType.Value_Abbreviated__c='Rd';
        streetType.Value_Abbreviated_NZ__c='Rd';
        insert streetType;
        
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUOnline();
        quoteList[0].Application__c=testApplication.Id;
        insert quoteList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        ApexPages.CurrentPage().getParameters().put('qId', quoteList[0].Id);
        
       
        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }
    static testMethod void brokerQuote_Test(){
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
         
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
         Street_Type_Setting__c streetType = new Street_Type_Setting__c();
        streetType.Name='Road';
        streetType.Value__c='Road';
        streetType.Region__c='Both';
        streetType.Value_Abbreviated__c='Rd';
        streetType.Value_Abbreviated_NZ__c='Rd';
        insert streetType;
        
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        
        insert testBroker;

        ApexPages.CurrentPage().getParameters().put('form', 'broker');

        Contact broker = [SELECT Broker_ID__c FROM Contact WHERE Id =: testBroker.Id LIMIT 1];
        
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBroker();
        quoteList[0].Application__c=testApplication.Id;
        quoteList[0].Broker_ID__c=broker.Broker_ID__c;     
        insert quoteList;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        ApexPages.CurrentPage().getParameters().put('qId', quoteList[0].Id);
        
       
        Test.startTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_EligibilityExt controller = new APP_EligibilityExt();
            controller.promoId = '';
            controller.loanTermSelected = '2 years';
            controller.loanWrapList[0].Loan.Value__c = 'Test';
            controller.loanWrapList[0].Loan.Loan_Amount__c = 5000;
            controller.confirmEligibleForLoan = true;
            controller.confirmApplicationMeetsNeeds = true;
            controller.confirmAgreedToPolicy = true;
            controller.confirmReadCreditGuide = true;
            controller.nextPage();
        Test.stopTest();
    }

}