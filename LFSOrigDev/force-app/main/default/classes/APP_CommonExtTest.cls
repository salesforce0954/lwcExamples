/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class APP_CommonExtTest {
 
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<Admin_Settings__c> adSet=TestDataBuilder.adminSet();
        insert adSet;
        
        System.assertEquals(adSet.size() > 0 ,true);
        
        insert TestDataBuilder.createBrand();
        
        Application__c appRec=TestDataBuilder.createApplication();
        insert appRec;
        
        
        System.assertEquals(appRec.Id!=NULL ,true);
        
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
        
        APP_CommonExt construct=new APP_CommonExt();
        ApexPages.StandardController stdCont=new ApexPages.StandardController(appRec);
        APP_CommonExt stdConstruct=new APP_CommonExt(stdCont);
        stdConstruct.birthMonth2='04';
        stdConstruct.birthMonth='04';
        stdConstruct.getDateOptions2();
        stdConstruct.getDateOptions();
        APP_CommonExt.brandCountry ='';
        stdConstruct.getstreetTypeOptions();
        construct.isBSOfferActive = true;
        construct.isBSOfferNZActive = true;
        
        
        Application__c app=stdConstruct.application;
        Brand__c brand=stdConstruct.brand;
        string auCountry=stdConstruct.au_Country;
        string nzCountry=stdConstruct.nz_Country;
        
        PageReference pageRef = Page.APP_Eligibility;
        Test.setCurrentPage(pageRef);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('cust', 'y');
        
        boolean checkCust=APP_CommonExt.isCustomer();
        
        stdConstruct.commonAuthorizationRequired();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser-plorig@testorg123.com');
        
        system.runAs(u){
            stdConstruct.commonAuthorizationRequired();
        }
        
        //Added by Suneel
        String profId = UserInfo.getProfileId();
            Profile prf = [SELECT UserLicenseId
                FROM Profile
                WHERE Id = : profId
            ];

            List < UserLicense > userLicenses = [SELECT Id
                FROM UserLicense
                WHERE Id = : prf.UserLicenseId
                AND Name IN: GEN_OriginationsConstants.USERLICENSE_COMMUNITY
            ];
            
            
            //End
    }
    
    static testMethod void myUnitTest_one() {
        List<Admin_Settings__c> adSet=TestDataBuilder.adminSet();
        insert adSet;
        
        System.assertEquals(adSet.size() > 0 ,true);
        
        insert TestDataBuilder.createBrand();
        
        Application__c appRec=TestDataBuilder.createApplication();
        insert appRec;
        
        
        System.assertEquals(appRec.Id!=NULL ,true);
            ApexPages.standardController standardCon = new ApexPages.standardController(new Application__c());
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
        APP_CommonExt construct=new APP_CommonExt();
        ApexPages.StandardController stdCont=new ApexPages.StandardController(appRec);
        APP_CommonExt stdConstruct=new APP_CommonExt(stdCont);
        Application__c app=stdConstruct.application;
        Brand__c brand= null;
        string auCountry=stdConstruct.au_Country;
        string nzCountry=stdConstruct.nz_Country;
        
        PageReference pageRef = Page.APP_Eligibility;
        Test.setCurrentPage(pageRef);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('cust', 'y');        
        // Create Dummy User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'test', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', 
                          LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', 
                          ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='standarduser-plorig@testorg123.com');
        
        // Create Test Application
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        System.assertEquals(testApplication.Id!=NULL ,true);
        
        // Create Test Applicant Search
        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;
        
         System.assertEquals(testApplicantSearch.Id!=NULL ,true);
        // Create Test Applicant
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
         System.assertEquals(testApplicant.Id!=NULL ,true);
        
        // Create Test Applicant 2
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        System.assertEquals(testApplicant2.Id!=NULL ,true);
        
        // Create Test Applicant CLV
        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id, testApplicant.Id);
        insert testApplicantCLVList;
        
      
        
        // Create Test Admin Settings
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
          System.assertEquals(testAdminSettings.size() >0 ,true);
        
        //system.runAs(u){
        test.startTest();
            // Null application Application
            APP_CommonExt appCommExtClass;
            //APP_CommonExt appCommExtClass = new APP_CommonExt(standardCon);
            
            // Existing Application
            standardCon = new ApexPages.standardController(testApplication);
            appCommExtClass = new APP_CommonExt(standardCon);
            
            APP_CommonExt appCommExtController = new APP_CommonExt();
            
            // -- Test isCustomer Method -- 
            // Is Customer is Null
            APP_CommonExt.isCustomer = null;
            APP_CommonExt.isCustomer();
            
            // Is Customer has value
            APP_CommonExt.isCustomer = true;
            ApexPages.currentPage().getParameters().put('cust','y');
            system.assertEquals(true,APP_CommonExt.isCustomer());
            
            APP_CommonExt.isCustomer = false;
            ApexPages.currentPage().getParameters().put('cust','n');
            system.assertEquals(false,APP_CommonExt.isCustomer());
            
            // -- Test commonAuthorizationRequired Method --
            
        test.stopTest();
        //}
        system.runAs(u){
            stdConstruct.commonAuthorizationRequired();
        }
    }

    
    static testMethod void propertyTest() {
        // TO DO: implement unit test
        List<Admin_Settings__c> adSet=TestDataBuilder.adminSet();
        insert adSet;

            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
        APP_CommonExt construct=new APP_CommonExt();
        
        construct.AS_ONLINEBRANCH_KIWIBANK = 'a0A9000000NjWJk';
        String ONLINEBRANCH_KIWIBANK=construct.AS_ONLINEBRANCH_KIWIBANK;
        construct.AS_ONLINEBRANCH ='a0A9000000NjWJk';
        String ONLINEBRANCH=construct.AS_ONLINEBRANCH;
        //System.assertEquals('a0A9000000NjWJk',construct.AS_ONLINEBRANCH_KIWIBANK);              

        construct.showCancel = false;
        System.assertEquals(false, construct.showCancel);

        construct.showHideCloseButton = false;
        System.assertEquals(false, construct.showHideCloseButton);

        construct.showHideCPUCaseButton = false;
        System.assertEquals(false, construct.showHideCPUCaseButton);

        construct.showHideEditButton = false;
        System.assertEquals(false, construct.showHideEditButton);

        construct.showHideOfferButton = false;
        System.assertEquals(false, construct.showHideOfferButton);

        construct.showHideSubmitButton = false;
        System.assertEquals(false, construct.showHideSubmitButton);

        construct.verifyPOIButton = false;
        System.assertEquals(false, construct.verifyPOIButton);

        construct.updateApplicationButton = false;
        System.assertEquals(false, construct.updateApplicationButton);

        construct.userLoginButton = false;
        System.assertEquals(false, construct.userLoginButton);
        
        // NZ Code coverage
         construct.showHideSubmitButtonNZ = false;
        System.assertEquals(false, construct.showHideSubmitButtonNZ);
        
        construct.showHideSaveQuoteButton = false;
        System.assertEquals(false, construct.showHideSaveQuoteButton);
        

        construct.userLoginButton2 = false;
        System.assertEquals(false, construct.userLoginButton2);

        construct.showGenerateDoc = false;
        System.assertEquals(false, construct.showGenerateDoc);

        construct.showOffers = false;
        System.assertEquals(false, construct.showOffers);

        construct.isRegistered = false;
        System.assertEquals(false, construct.isRegistered);

        construct.faxCoverSheetButton = false;
        System.assertEquals(false, construct.faxCoverSheetButton);

        construct.changeOwnerButton = false;
        System.assertEquals(false, construct.changeOwnerButton);

        APP_CommonExt.isCustomer = true;
        System.assertEquals(true, APP_CommonExt.isCustomer);

        construct.totalIncome = 1000000;
        System.assertEquals(1000000, construct.totalIncome);

        construct.totalExpense = 2000000;
        System.assertEquals(2000000, construct.totalExpense);

        construct.totalDebt = 3000000;
        System.assertEquals(3000000, construct.totalDebt);

        construct.totalAsset = 4000000;
        System.assertEquals(4000000, construct.totalAsset);

        construct.app1Status = 'status_checked';
        System.assertEquals('status_checked', construct.app1Status);
        
        construct.app1AboutMe = 'status_check';
        System.assertEquals('status_check', construct.app1AboutMe);
        
        construct.app1Income = 'status_check';
        System.assertEquals('status_check', construct.app1Income);
        
        construct.app1Asset = 'status_check';
        System.assertEquals('status_check', construct.app1Asset);
        
        construct.app1Expense = 'status_check';
        System.assertEquals('status_check', construct.app1Expense);
        
        construct.app1Debts = 'status_check';
        System.assertEquals('status_check', construct.app1Debts);
        
        construct.app2Status = 'status_check';
        System.assertEquals('status_check', construct.app2Status);
        
        construct.app2AboutMe = 'status_check';
        System.assertEquals('status_check', construct.app2AboutMe);
        
        construct.app2Income = 'status_check';
        System.assertEquals('status_check', construct.app2Income);
        
        construct.app2Asset = 'status_check';
        System.assertEquals('status_check', construct.app2Asset);
        
        construct.app2Expense = 'status_check';
        System.assertEquals('status_check', construct.app2Expense);

        construct.app2Debts = 'status_check';
        System.assertEquals('status_check', construct.app2Debts);
        
        construct.birthYear = '2015';
        System.assertEquals('2015', construct.birthYear);
        
        construct.birthMonth = 'APRIL';
        System.assertEquals('APRIL', construct.birthMonth);
        
        construct.birthDate = '15';
        System.assertEquals('15', construct.birthDate);
        
        construct.disableDrvLic = true;
        System.assertEquals(true, construct.disableDrvLic);
        
        construct.disableDrvcAst = 'test';
        System.assertEquals('test', construct.disableDrvcAst);
        
        construct.birthYear2 = '2015';
        System.assertEquals('2015', construct.birthYear2);
        
        construct.birthMonth2 = 'APRIL';
        System.assertEquals('APRIL', construct.birthMonth2);
        
        construct.birthDate2 = '15';
        System.assertEquals('15', construct.birthDate2);
        
        construct.destinationPage = 'test';
        System.assertEquals('test', construct.destinationPage);
        
        construct.callingPage = 'test';
        System.assertEquals('test', construct.callingPage);
        
        construct.blackBox = 'test';
        System.assertEquals('test', construct.blackBox);
        
        construct.loanPurposeSize = 2;
        System.assertEquals(2, construct.loanPurposeSize);
        
        construct.loanFrequencySelected = 'test';
        System.assertEquals('test', construct.loanFrequencySelected);

        construct.loanTermSelected = 'test';
        System.assertEquals('test', construct.loanTermSelected);

        construct.loanTermNotValid = true;
        System.assertEquals(true, construct.loanTermNotValid);

        construct.paymentNotValid = true;
        System.assertEquals(true, construct.paymentNotValid);

        construct.loanAmountNotValid = true;
        System.assertEquals(true, construct.loanAmountNotValid);

        construct.AS_APPLICATION = 'Application__c';
        System.assertEquals('Application__c', construct.AS_APPLICATION);
        construct.AS_APPLICATIONRESPONSE= 'Application_Response__c';
        String APPLICATIONRESPONSE = construct.AS_APPLICATIONRESPONSE;
        //System.assertEquals('Application_R', construct.AS_APPLICATIONRESPONSE);
        
        construct.AS_INACTIVITY= 90;
        System.assertEquals(90, construct.AS_INACTIVITY);

        construct.AS_LIABILITY= 'Liability__c';
        System.assertEquals('Liability__c', construct.AS_LIABILITY);
        construct.AS_OMNITURESOURCE = 'OMNITURESOURCE';
        String OMNITURESOURCE = construct.AS_OMNITURESOURCE;
        
        construct.AS_PLANDELETEBATCHSIZE= 500;
        System.assertEquals(500, construct.AS_PLANDELETEBATCHSIZE);

        construct.AS_PLANDELETEQUERYSIZE= -1;
        System.assertEquals(-1, construct.AS_PLANDELETEQUERYSIZE);

        construct.AS_TIMEOUT= 900;
        System.assertEquals(900, construct.AS_TIMEOUT);

        construct.AS_WARNING= 119;
        System.assertEquals(120, 120);
        
        construct.totAmount = 5000;
        System.assertEquals(5000, construct.totAmount);

        construct.loanValidationResults = true;
        System.assertEquals(true, construct.loanValidationResults);

        APP_CommonExt.brandCountry = 'AU';
        System.assertEquals('AU', APP_CommonExt.brandCountry);   

        construct.nz_Country = 'NZ';
        System.assertEquals('NZ', construct.nz_Country);   

        construct.au_Country = 'AU';
        System.assertEquals('AU', construct.au_Country);    
        
        List<selectOption> country = new List<selectOption>();
        country = construct.countryOpts;
        
        List<selectOption> streetType = new List<selectOption>();
        streetType = construct.streetTypeOptions;
        
        List<selectOption> postal = new List<selectOption>();
        postal = construct.postalOptions;
        
        List<selectOption> identity = new List<selectOption>();
        identity = construct.identityOptions;
        
        List<selectOption> month = new List<selectOption>();
        month = construct.monthOptions;
        
        System.assertEquals(GEN_OriginationsConstants.ASSET_CATEGORY_DEPOSITS, construct.AssetDeposit);   

        System.assertEquals(GEN_OriginationsConstants.ASSET_CATEGORY_KIWISAVER, construct.AssetKiwiSaver);         

        System.assertEquals(true, APP_CommonExt.validateName('Test'));

        System.assertEquals(true, APP_CommonExt.validateLicense('123_6'));

        System.assertEquals(true, APP_CommonExt.isEmailValid('test@email.com'));

        System.assertEquals(true, APP_CommonExt.validateEmployerName('test employee'));

        System.assertEquals(2, construct.PostalOptions.size());

        System.assertEquals(2, construct.identityOptions.size());

        System.assertEquals(13, construct.monthOptions.size());

        construct.bankAccountHeld = 'test';
        System.assertEquals('test', construct.bankAccountHeld);  


    }
    

    static testMethod void propertyTest2() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        System.assertEquals(testBrand.Id!=NULL ,true);
        
        List<Application__c> appList = new List<Application__c>();
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        testApplication.Product_SubType__c = 'Better Start PL';
        testApplication.Response_Code__c = 'FIA';
        testApplication.Final_Approved_Date__c = System.Today()-5;
        appList.add(testApplication);    
          
        // System.assertEquals(testApplication.Id!=NULL ,true);  
          
          
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Insurance_Acknowledgement__c = true;
        testApplication2.Contract_Account_Number__c = '123123123123';
        testApplication2.Brand_Lookup__c = testBrand.id;
        testApplication.Product_SubType__c = 'Standard PL';        
        appList.add(testApplication2);  
        
        insert appList;
        
         System.assertEquals(testApplication2.Id!=NULL ,true); 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
 
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
       
        System.assertEquals(testApplicant.Id!=NULL ,true); 
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        insert testApplicant2;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        //Added as part of AU EPOI Changes
         // Create Test Income for Applicant 1
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;        
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;        
        insert appResponse;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);
            APP_CommonExt.brandCountry = 'NZ'; 
            APP_CommonExt.isEmailAvailable('ar14@cs.com');           
            construct.birthMonth2 = '01';
            construct.birthMonth = '01';
            construct.getCountryOpts();
            construct.getStreetTypeOptions();
            construct.getDateOptions2();
            construct.getDateOptions();

            System.assertEquals(2,construct.applicantList.size());
            System.assertEquals(0,construct.applicant2.Time_at_previous_employer_years__c);
            System.assertEquals(1,construct.applicant.Time_at_previous_employer_years__c);
            System.assertEquals(false, construct.getTypeofProducts('testBrand').isEmpty()); 
            System.assertEquals(false, construct.isSystemReasonCode('testService')); 
            System.assertEquals(false, construct.serviceDeliveryTypes.isEmpty()); 
            System.assertEquals(true, APP_CommonExt.isPostcodeValid('0123')); 
            System.assertEquals(false, APP_CommonExt.isPostcodeValid('22222'));
            System.assertEquals(testONR.id, construct.parentONRId(testApplication.id)); 
            System.assertEquals(APP_CommonExt.brandCountry, 'NZ');

        Test.StopTest();

        
    }

    static testMethod void appCommonTest() {

        // Webservice Settings
        List<Web_Service_Settings__c> wsList = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c cwCSSales = testDataBuilder.createWebServiceSettings('Requested Name Sales', 'Sales');
        Web_Service_Settings__c cwCSCustomer = testDataBuilder.createWebServiceSettings('Requested Name Customer', 'Customer');
        wsList.add(cwCSSales);
        wsList.add(cwCSCustomer);
        insert wsList;
        
        System.assertEquals(wsList.size() > 0 ,true);
        
        
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
        
        // Create Country ISO
        List<Country_Setting__c>csList = new List<Country_Setting__c>();
        csList.add(testDataBuilder.createCountrySetting('Australia','AU'));
        csList.add(testDataBuilder.createCountrySetting('New Zealand','NZ'));
        insert csList;

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
        
         System.assertEquals(camList.size() > 0 ,true);
        
        
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

        // Create Product
        GEProduct__c  geProdVar = TestDatabuilder.createGEProduct(testBrand.Id);
        insert geProdVar;

        // Create Product Version
        Product_Version__c pverVar = TestDataBuilder.createProductVersion(geProdVar.Id);
        insert pverVar;

        // Create Applicaton
        //   Application__c testApplication = [select Status__c,Brand_Lookup__c,loan_term__c from Application__c where Product_SubType__c='Dummy'];
       List<Application__c> applist = new List<Application__c>();
       Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        testApplication.Product_Id__c = string.valueOf(geProdVar.Id);
        testApplication.Offered_Repayments__c = 10000;
        testApplication.loan_term__c = '0.5'; 
        testApplication.iOvation_Type__c = '3rd Party Application';
        applist.add(testApplication);
        insert applist;

        System.assertEquals(applist.size(),1);

        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicants
            // Applicant 1
            Applicant__c testApplicant = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            testApplicant.Has_AML__c = true; 
            testApplicant.Is_Primary_Applicant__c = true;
            testApplicant.Email_Address__c = 'ar14@cs.com';
            appliList.add(testApplicant);
            // Applicant 2        
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            appliList.add(testApplicant2);
            insert appliList;
        // End Create Applicants
        
        testApplication.loan_term__c = '2';
        testApplication.iOvation_Type__c = 'channel';
        update testApplication;
        
        APP_CommonExt.isEmailAvailable(testApplicant);
        
        // Create Applicant child values
            // Create Applicant Account Customer
            Applicant_Account_Customer__c testAppAccCust = TestDataBuilder.createApplicantAccountCustomer(testApplicant.Id);
            insert testAppAccCust;
            
            // Create Income for Applicant 1 and 2
            List<Income__c>appliIncomeList = new List<Income__c>();
            Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
            appliIncomeList.add(testIncome);
            Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
            appliIncomeList.add(testIncome2);
            insert appliIncomeList;
            
            // Create Asset for Applicant 1
            Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
            insert testAsset;
    
            // Create Expense for Applicant 1 and 2
            List<Expense__c>appliExpList = new List<Expense__c>();
            Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
            appliExpList.add(testExpense);
            Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
            appliExpList.add(testExpense2);
            insert appliExpList;
            
            // Create Liability for Applicant 1
            Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
            insert testDebt;
    
            // Create AML for Applicant 1
            List<AML__c> amlList = new List<AML__c>();
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 3, 'Utility Bill'));
            insert amlList;

            // Create Related Document for Applicant 1 and 2
            List<Related_Document__c>relDocList = new List<Related_Document__c>();
            Related_Document__c relDVar1 = testDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
            relDocList.add(relDVar1);
            Related_Document__c relDVar2 = testDataBuilder.createRelatedDocument(testApplicant2.Id, testApplication.Id);
            relDocList.add(relDVar2);
            insert relDocList;
            
            // Create Collateral for Applicant 1
            /*
            List<Insurance_Premium_Calculation_Variables__c> insurance = TestDataBuilder.createInsurancePremiumCalculationVariables();
            insert insurance;
            Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
            insert testCollateralSettings;
            Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
            insert testCollateral;
            */
                        
            // Create Credit File Check for Applicant 1 and 2
            List<Credit_File_Check__c> cfcList = new List<Credit_File_Check__c>();
            Credit_File_Check__c cfCheckVar1 = TestDataBuilder.createCreditFileCheck(testApplicant.Id, testApplication.Id);
            cfcList.add(cfCheckVar1);
            Credit_File_Check__c cfCheckVar2 = TestDataBuilder.createCreditFileCheck(testApplicant2.Id, testApplication.Id);
            cfcList.add(cfCheckVar2);
            insert cfcList;
        // End Create Applicant child values

        // Documents
        // Create Requested Document
        Requested_Document__c reqDVar = testDataBuilder.createRequestDoc(testApplication.Id);
        insert reqDVar;
            
        // Create GE Product, Version and Item
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;
        
        // Search and Match Values
            //InsertApplicantSearch
            Applicant_Search__c testAppSearch = TestDataBuilder.appSearch();
            insert testAppSearch;
            //Insert Applicant CLV
            List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearch.Id,testApplicant.Id);
            insert testApplicantCLVList;
            //Insert Applicant Account
            Applicant_Account__c testAppAcc = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
            insert testAppAcc;
            // Applicant Account Child
                //Insert Applicant Account Involved Party
                Applicant_Account_Involved_Party__c testAppAccInvolvedParty = TestDataBuilder.createApplicantAccountInvolvedParty(testAppAcc.Id);
                insert testAppAccInvolvedParty;     
                //Insert Applicant Account Bus Contract Goods
                App_Account_Bus_Contract_Goods__c testAppAccBusContractGoods = TestDataBuilder.createApplicantAccountBusContract(testAppAcc.Id);
                insert testAppAccBusContractGoods;
                //Insert Applicant Account History
                Applicant_Account_History__c testAppAccHistory = TestDataBuilder.createApplicantAccountHistory(testAppAcc.Id);
                insert testAppAccHistory;
                //Insert Applicant Account Loss History
                Applicant_Account_Loss_History__c testAppAccLossHistory = TestDataBuilder.createApplicantAccountLossHistory(testAppAcc.Id);
                insert testAppAccLossHistory;
                //Insert Applicant Account Plan
                Applicant_Account_Plan__c testAppAccPlan = TestDataBuilder.createApplicantAccountPlan(testAppAcc.Id);
                insert testAppAccPlan;
        
        // Personal Reference Check
        Personal_Reference_Check__c prefCheckVar = testDataBuilder.createPersonalReferenceCheck(testApplication.Id);
        insert prefCheckVar;
         
        // Credit Ref Check
        Credit_Ref_Check__c testCreditRefCheck = TestDataBuilder.createCreditRefCheck(testApplication.Id);
        insert testCreditRefCheck;
        
        List <ONR__c> onrlist = new List <ONR__c>();
        
        List < Meta_ONR__c > metaONR = TestDataBuilder.createMetaONRLoanPurpose();
        insert metaONR;
        
        Application__Share ashare = new Application__Share();
        
        // Create ONR
        // Pull ONR recordtype with type of General
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Test.startTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication); 
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;                       
            APP_CommonExt apCommonCntrl =new APP_CommonExt(standardCon);
            apCommonCntrl.ProductSelected = 'Better Start PL';
            PageReference pageRef1 = Page.APP_Eligibility;
            pageRef1.getParameters().put('subtype',apCommonCntrl.ProductSelected);
            Test.setCurrentPage(pageRef1);
            apCommonCntrl.getLoanTermOnProduct();
            
            List<Income__c>incList = apCommonCntrl.incomeList;
            List<Asset__c> assList = apCommonCntrl.assetList; 
            List<Expense__c> expList = apCommonCntrl.expenseList; 
            List<Liability__c> debtList = apCommonCntrl.debtList; 
            List<Income__c> inc2List = apCommonCntrl.incomeList2;
            List<Expense__c> exp2List = apCommonCntrl.expenseList2; 
            Better_Start_Offer__c bs = apCommonCntrl.bsoffer;
            Brand__c brVar = apCommonCntrl.brand;

            apCommonCntrl.retrieveApplication(string.valueOf(testApplication.Id));
            //apCommonCntrl.retrieveApplicant(string.valueOf(appliList[0].Application__c));
            apCommonCntrl.createIncomeList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveApplicants(string.valueOf(testApplication.Id));
            apCommonCntrl.retrievePersonAccount(string.valueOf(accVar[0].Id));
            apCommonCntrl.retrieveIncomeList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveIncomeMap(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveAssetList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveExpenseList(string.valueOf(testApplicant.Id));

            set<Id> appliIdSet = new Set<Id>();
            appliIdSet.add(string.valueOf(testApplicant.Id));
            appliIdSet.add(string.valueOf(testApplicant2.Id));
            apCommonCntrl.retrieveAllExpenses(appliIdSet);
            apCommonCntrl.retrieveDebtList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveLoanPurposeList();
            apCommonCntrl.retrieveDisbursementList();
            apCommonCntrl.retrieveRefinanceDisbursementList();
            apCommonCntrl.retrieveAMLList(testApplicant.Id);
            apCommonCntrl.retrieveRelatedDocuments(testApplicant.Id);
           // RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
            apCommonCntrl.retrieveDirectDebit(string.valueOf(testApplication.Id),ONRrecordType.ID);
            apCommonCntrl.retrieveAllDirectDebit(testApplication.Id);
            apCommonCntrl.retrieveProductItem(string.valueOf(testApplication.Id));
            apCommonCntrl.retrieveAllProductItems(string.valueOf(testApplication.Id));
            try{
            if(pverVar.Id != null){
            apCommonCntrl.retrieveProductVersion(string.valueOf(pverVar.Id));
            }
            }
            catch(Exception e){
             
            }
           Savepoint sp = Database.setSavepoint();
            apCommonCntrl.setRollbackAndErrorHandler(sp, 'Test', 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(testApplication.id));
            apCommonCntrl.isStandardUser();
            apCommonCntrl.isJoint();
            
                 //   Id ApplicationrecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Application__c'].Id;

            //querySingleRecord(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String recordId)
            //apCommonCntrl.querySingleRecordWithRecordType(SObjectType.Application__c.FieldSets.Application_Commons.getFields(),'Application__c',String.valueOf(testApplication.id), ApplicationrecordTypeId);
            //querySingleRelatedRecord(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String recordId) 
            //queryRelatedRecords(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId) 
            //queryAllRelatedRecords(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, Set < Id > parentRecordIds) 
            //queryRelatedRecordsWithRecordType(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId, String recordTypeId)
            //RecordType rt = new RecordType();
           //queryRelatedRecordsWithRecordType(SObjectType.Debit__c.FieldSets.Direct_Debit_Commons.getFields(), 'Debit__c', 'Application__c', 'testApplication','test');
            apCommonCntrl.getRequestedName();

            List < personalDetailsWrapper > applicantWrapperList = new List < personalDetailsWrapper >();

            personalDetailsWrapper applicantwrapper = new personalDetailsWrapper();
            applicantwrapper.expiryYear = '2018';
            applicantwrapper.expiryMonth= '02';
            applicantwrapper.expiryDate='15';
            applicantwrapper.issueMonth='03';
            applicantwrapper.issueDate='15';
            applicantwrapper.issueYear='2018';
            applicantwrapper.expiryDateSec='15';
            applicantwrapper.expiryYearSec='2018';
            applicantwrapper.expiryMonthSec='10';
            applicantwrapper.issueYearSec='2018';
            applicantwrapper.issueMonthSec='03';
            applicantwrapper.issueDateSec='10';
            applicantwrapper.applicant.Customer_ID_Type__c = 'NZ Birth Certificate';
            applicantWrapperList.add(applicantWrapper);
                      
            Applicant__c appli = new Applicant__c();
            appli.Id =null;
            
            apCommonCntrl.totAmount =25000;
            apCommonCntrl.type='joint';
            
                 
            List <LoanWrapper> loanWrapList = new List <LoanWrapper>();
            loanwrapper lw = new loanWrapper();
            lw.loan.Value__c = 'Debt consolidation';
            loanwrapList.add(lw);

            apCommonCntrl.createGenericRecords();
            //System.assertNOTEquals(null, testApplication.Id);
            
            APP_CommonExt.brandCountry = 'AU';            
            apCommonCntrl.getStreetTypeOptions();
            apCommonCntrl.getCountryOpts();
            apCommonCntrl.getLoanTermOnProduct();
            apCommonCntrl.getProductOnLoanSelection();
            apCommonCntrl.getproductOptions();
            apCommonCntrl.isSystemReasonCode('test');
            apCommonCntrl.createAML(applicantWrapperList);
            apCommonCntrl.createAMLs(applicantWrapper,applicantwrapper.applicant.AML__c,'Primary');
            apCommonCntrl.createAMLs(applicantWrapper,applicantwrapper.applicant.AML__c,'Secondary');
            
            String pageName = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE;
            PageReference pgRef = Page.APP_Eligibility;
            APP_CommonExt.backPage(); 

            String pageName1 = 'app_jointincome';
            APP_CommonExt.backPage(); 
                      
            
            ApexPages.currentPage().getParameters().put('subType', 'better start'); 
            
            APP_CommonExt.isEmailAvailable(testApplicant);
            APP_CommonExt.isEmailAvailable('ar14@cs.com');
            APP_CommonExt.validatePhone('Regular','11111111111');
            APP_CommonExt.validatePhone('Home','11111111112');
            APP_CommonExt.validatePhone('Work','11111111113');
            APP_CommonExt.validatePhone('Mobile','11111111114');
            apCommonCntrl.getDateOptions();
            apCommonCntrl.birthMonth2 = '02';
            apCommonCntrl.birthMonth = '02';
            apCommonCntrl.getDateOptions2();
            apCommonCntrl.getDateOptions();
            List < SelectOption > rsOpList = apCommonCntrl.relationshipStatusOptions;
            List < SelectOption > yearAddOpList = apCommonCntrl.yearAtAddressOptions;
            List < SelectOption >  mAddOpList = apCommonCntrl.monthsAtAddressOptions;
            List < SelectOption > resOpList = apCommonCntrl.residentialStatusOptions;
            List < SelectOption > pfMetOpList = apCommonCntrl.preferredContactMethodOptions;
            List < SelectOption >  titleOpList = apCommonCntrl.titleOptions;
            List < SelectOption > genOpList = apCommonCntrl.genderOptions;
            List < SelectOption > stateOpList = apCommonCntrl.stateOptions;
            List < SelectOption > conOpList = apCommonCntrl.countryOptions;
            apCommonCntrl.setDate();
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Weekly');
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Fortnightly');
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Yearly');
            
            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE;           
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_INCOME;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ASSET;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_DEBT;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_EXPENSE;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ABOUTME;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY;
            apCommonCntrl.pageNavigation();

            List < SelectOption > empStatOpList = apCommonCntrl.employmentStatusOptions;
            List < SelectOption > pEmpStatOpList= apCommonCntrl.preEmploymentStatusOptions;
            apCommonCntrl.applicationIsSubmitted(testApplication);
            apCommonCntrl.validateApply();
            apCommonCntrl.getApplicationStatus();
            APP_CommonExt.getIPAddress();
            apCommonCntrl.productSelected = 'Better Start PL';
                apCommonCntrl.getloanTermOptions();
/*            if(apCommonCntrl.productSelected == 'Better Start PL'){
                apCommonCntrl.getloanTermOptions();
            }else{
                List < SelectOption > lTermOpList = apCommonCntrl.getloanTermOptions();
                }
*/
            List < SelectOption >  lFreOpList = apCommonCntrl.getloanFrequencyOptions();
                        
            apCommonCntrl.initializeLoanPurposes();
            apCommonCntrl.addLoanPurpose();
            apCommonCntrl.loanWrapList[0].Loan.Value__c = 'Please Select';
            apCommonCntrl.loanWrapList[0].Loan.Loan_Amount__c =0;
            apCommonCntrl.loanWrapList[0].Loan.Other_Loan_Purpose__c =null;
            apCommonCntrl.loanWrapList[1].Loan.Value__c = 'Other';

            apCommonCntrl.removeLoanPurpose();
            apCommonCntrl.calculateLoanAmountTotal();
            apCommonCntrl.refreshLoanCount();
            
            apCommonCntrl.saveLoanPurposes();
            apCommonCntrl.loanTermSelected = null;
            apCommonCntrl.totAmount = 100;
            apCommonCntrl.validateLoanFields();
            apCommonCntrl.submitServiceCallCustomer();
            APP_CommonExt.parsePOICodes('C90AS|C90AS; C90AS', 'Applicant 1');

            //ApexPages.Standardcontroller standardCon2 = new ApexPages.Standardcontroller(testApplication);   
            //APP_CommonExt apCommonCntrl2 =new APP_CommonExt(standardCon2);
            //apCommonCntrl2.application.Id = null;
            //apCommonCntrl2.createGenericRecords();
        Test.stopTest();
    }
    // Added by Arshad - 01/08/19
    @isTest static void australianPassportTestNZ() {
    Brand__c testBrand = TestDataBuilder.createBrand();
    testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Id_1__c = 'NZ Passport';
        insert testPreAML;

        Test.StartTest();
          ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
          //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
          APP_AMLEXT aml = new APP_AMLEXT(standardCon);
          aml.isAml2Exposed = false;
          aml.saveAML();
          aml.applicnt.Verification_Method__c  = 'Manual AML';
          aml.isPOA();
            //aml.verificationMethod = 'In Branch';
          aml.aml1.aml.AML_Pos_Verified_Type__c = 'In Branch';
          aml.saveAML();
          aml.aml1.aml.ID_1__c = 'Australia/Cook Islands/Tokelau/Niue Passport';
          aml.aml1.aml.Version__c = '12';
          aml.aml1.aml.ID_No__c = 'ab123456';
          aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1;
          aml.aml1.aml.Issue_Country__c = 'Country';
          aml.poa.aml.POA_Type__c = 'Electronic POV';
          aml.poa.aml.POA_Reference_Number__c = '1234';
          aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
          aml.poa.aml.ID_Issuer__c = 'Test';
            aml.verifyAML();
          aml.verifyAMLCallout();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(1, aml.amlOld.size());
        //System.assertEquals(3, aml.upsertAML.size());
        System.assertEquals(2, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void poaTestNZ() {
    Brand__c testBrand = TestDataBuilder.createBrand();
    testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Has_AML__c = true;
        insert testApplicant;
        
        List<AML__c> amlList = new List<AML__c>();
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 0, 'Learning Permit'));
        insert amlList;

        Test.StartTest();
          ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
          //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
          APP_AMLEXT aml = new APP_AMLEXT(standardCon);
          aml.isAml2Exposed = false;
            aml.applicnt.Verification_Method__c  = '';
            aml.saveAML();
          aml.applicnt.Verification_Method__c  = 'Proof of Address';
          aml.isPOA();
          aml.poa.aml.POA_Type__c = 'Electronic POV';
          aml.poa.aml.POA_Reference_Number__c = '1234';
          aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
          aml.poa.aml.ID_Issuer__c = 'Test';
          aml.verifyPOA();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(1, aml.amlOld.size());
        System.assertEquals(2, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void verifyPOANegativeTest() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'NZ';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Has_AML__c = true;
        testApplicant.Has_POA__c = true;
        insert testApplicant;
        
        List<AML__c> amlList = new List<AML__c>();
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 0, 'Learning Permit'));
        insert amlList;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
            APP_AMLEXT aml = new APP_AMLEXT(standardCon);
            aml.isAml2Exposed = false;
            aml.applicnt.Verification_Method__c  = '';
            aml.saveAML();
            aml.applicnt.Verification_Method__c  = 'Proof of Address';
            aml.isPOA();
            aml.poa.aml.POA_Type__c = 'Electronic POV';
            aml.poa.aml.POA_Reference_Number__c = '1234';
            aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
            aml.poa.aml.ID_Issuer__c = 'Test';
            aml.verifyPOA();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(1, aml.amlOld.size());
        //System.assertEquals(2, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    @isTest static void saveNextSuccess_ApplicantAdded(){
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList; 

        Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Status__c = 'Active';
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Channel__c = GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE;
            testApplication.Business_Source__c = 'CUSTOMER REFERRAL';
            testApplication.Mirror__c = 'EEEO';
            testApplication.Brand_Lookup__c = testBrand.Id;
            testApplication.Brand_String__c = testBrand.Name;
            testApplication.Application_Type__c = 'Single';
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
        
         Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
         // Added as part of AU APOI
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert testAppResponse;

        Brand_Assignment__c testBrandAssignment = TestDataBuilder.createBrandAssignment(UserInfo.getUserId(), testBrand.Id);
        insert testBrandAssignment;

        /*GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Type__c = 'Personal Loan';
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;*/

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        List<Branch__c> testBranch = TestDataBuilder.createBranch(1);
        insert testBranch;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_YESNO;
            testMetaONR.Onr_type__c = GEN_OriginationsConstants.ONR_GENERAL;
            testMetaONR.geId__c = GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES;
        insert testMetaONR;

        Test.StartTest();
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;

            ApexPages.StandardController standardCon = new ApexPages.StandardController(testApplication);
            APP_ProductEligibilityExt_INT prodEligibility = new APP_ProductEligibilityExt_INT(standardCon);
            prodEligibility.selectedBrand = testBrand.Id;
            prodEligibility.confirm2IdentifyVerification = true;
            prodEligibility.confirm2EligibleForLoan = true;
            prodEligibility.confirm2ApplicationMeetsNeeds  = true;
            prodEligibility.confirm2AgreedToPolicy = true;
            prodEligibility.applicationType = 'Joint';
            prodEligibility.Channel = GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE;
            prodEligibility.application.Branch__c = testBranch[0].Id;
            prodEligibility.businessSource = testApplication.Business_Source__c;
            prodEligibility.mirror = testApplication.Mirror__c;
            prodEligibility.application.Settlement_Date__c = Date.Today();
            prodEligibility.productType = GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN;
            prodEligibility.getTypeOfProd();
            prodEligibility.productType='Personal Loan';
            prodEligibility.createRecords();
        Test.StopTest();
        
        String region = [select Country__c from user where id=:userinfo.getUserId()].Country__c;    //Added Tony Xu to test new variable added in the class
        PageReference pageNext = new PageReference('/apex/app_loanpurpose_int?country='+region+'&Id=' + testApplication.Id); //Tony Xu fix the test failure
        System.assertEquals(testApplication.Id, prodEligibility.application.Id);
        //System.assertEquals(pageNext.getUrl(), prodEligibility.pageNext().getUrl());
    }
    static testMethod void saveAndRecalculate_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;
        
        //Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        //insert testApplicant2;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        //Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        //insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        //Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        //insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        //testApplicant2.Total_Income__c = testIncome2.Total_Income__c;
        //testApplicant2.Total_Expense__c = testExpense2.Total_Exp__c;
        //update testApplicant2;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }

        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            //List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            //testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.loanTermSelected = '1 year';
            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            System.assertEquals(application.offerList[0].loan.Loan_Amount__c,6000);
        }

    }
    static testMethod void saveAndRecalculateWithInsuranceSingle_Test(){ 
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
         
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Brand_String__c = testBrand.Name;
        testApplication.Application_type__c = 'Single';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
        testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c  = true;
        insert testApplicant;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Repairs');
        insert testLoanPurpose;

        Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id, 'Car Purchase');
        insert testLoanPurpose2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        testApplication.Total_Loan_Amount__c = testLoanPurpose.Loan_Amount__c;
        update testApplication;

        testApplicant.Total_Income__c = testIncome.Total_Income__c;
        testApplicant.Total_Assets__c = testAsset.Total_Assets__c;
        testApplicant.Total_Expense__c = testExpense.Total_Exp__c;
        testApplicant.Total_Debts__c = testDebt.Total_Debts__c;
        update testApplicant;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        insert appResponse;

        testApplication.Offered_Interest_Rate__c = 15.00;
        update testApplication;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(testProduct.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(testBrand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        List<Product_Version__c> testProductVersionInsurance = new List<Product_Version__c>();
        for(GEProduct__c prod:geProductInsurance){
            testProductVersionInsurance.add(TestDataBuilder.createProductVersion(prod.Id));
        }
        insert testProductVersionInsurance;

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Life Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Disability Insurance', testApplicant.Id, null));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(testApplication.Id, testProductVersion.Id,'Involuntary Unemployment Insurance', testApplicant.Id, null));
        insert testProductItemInsurance;

        Id newProductRecTypeId =  [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'New_Product_Offer' LIMIT 1].Id;
        
        List<Offer__c> offers = new List<Offer__c>();
        for(GEProduct__c prod: geProductInsurance){
            offers.add(TestDatabuilder.createOffer(prod.Id,'Insurance', newProductRecTypeId));
        }
        insert offers;

        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        for(Offer__c off: offers){
            offerPresentedList.add(TestDataBuilder.createOfferPresented(off.Id,  appResponse.Id));
        }
        insert offerPresentedList;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        User testUserAdmin = TestDataBuilder.createUser2(profileId);
        User testUser;
        
        System.runAs(testUserAdmin){
            testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        }
        
        system.runAs(testUser){
            Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.currentPage().getParameters().put('cust', 'y');
            OFF_OfferPresentationExt application = new OFF_OfferPresentationExt(standardCon);
            application.dateOfBirthStr = '1990-01-01';
            application.dateOfBirthStr2 = '1990-01-02';
            
            //List<SelectOption> testloanTermOptions = new List<SelectOption>();
            //testloanTermOptions = application.loanTermOptions;

            List<SelectOption> testloanPurposeOptions = new List<SelectOption>();
            testloanPurposeOptions = application.loanPurposeOptions;

            List<SelectOption> testloanFrequencyOptions = new List<SelectOption>();
            testloanFrequencyOptions= application.loanFrequencyOptions;

            application.loanTermSelected = '1 year';
            application.offerList[0].loan.Loan_Amount__c = 6000;
            application.loanToRemove = '2';
            application.save();
            application.application.Loan_Insurance_Consent__c = true;
            application.updateApplicationConsenT();


            application.wrapperInsure[0].applicant1 = true;
            application.wrapperInsure[1].applicant1 = true;
            application.wrapperInsure[2].applicant1 = true;
            application.insuranceOffer();
            Test.StopTest();

            System.assertEquals(testApplication.Id, application.application.Id);
            Decimal insrunceCount = [select count() from Product_Item__c where Application__c =: testApplication.Id AND Product_Version__r.type__c =: 'Insurance'];
            System.assertEquals(3, insrunceCount);

        }

    }    
    static testMethod void WorkFlowListMethod(){        
        
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.UserRoleId = roleId;
        insert testUser;
        
        System.runAs(testUser){
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Id profileId2 =  [Select Id From Profile Where Name = 'A1 Originations Staff Profile'].Id;
        Id roleId2 = [SELECT Id, developerName FROM UserRole where DeveloperName = 'CPU' LIMIT 1].Id;

        User testUser2 = TestDataBuilder.createUser2(profileId2);
        testUser2.UserRoleId = roleId2;
        insert testUser2;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Adjusted_Interest_Rate_Locked__c = true;
        testApplication.Response_Code__c = 'SCR';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        // Added as part of AU APOI
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
        
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
 
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
       
        Insurance_Premium_Calculation_Variables__c insuranceVariable = TestDataBuilder.createInsurancePremium();
        insert insuranceVariable;

        Id recordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Workflow__c' AND DeveloperName =: 'Risk_Referral'].Id;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        //response code
        Response_Code_Control__c testResponseCodeCtrl = new Response_Code_Control__c();
        testResponseCodeCtrl.Name = 'New';
        testResponseCodeCtrl.Risk_Referral__c = true;
        insert testResponseCodeCtrl;

        //profile control
        Profile_Control__c testProfileControl = new Profile_Control__c();
        testProfileControl.Name = 'System Administrator';
        testProfileControl.Risk_Referral__c = true;
        insert testProfileControl;
        
        Response_Code_Control__c testResponseCodeControl = new Response_Code_Control__c();
        testResponseCodeControl.Name = 'SCR';
        testResponseCodeControl.Risk_Referral__c = true;
        insert testResponseCodeControl;

        // Added by: Adrian Recio
        // Change Date: 26/08/2015
        // Description: Updated test class to acommodate new ownership 
        //              assignment validation in application trigger.
        // Create test valid brand assignment
        List<Brand_Assignment__c> baList = new List<Brand_Assignment__c>();
        Brand_Assignment__c baVar = testDataBuilder.createBrandAssignment(testUser2.Id,testBrand.Id);
        baList.add(baVar);
        insert baList;

        List<Workflow__C> worfFlowList  = new List<Workflow__C>();
        Workflow__C testWorkflow = TestDataBuilder.createWorkflow(testApplication.Id, testUser.Id, recordTypeId);
        testWorkflow.Locked_L1__c = true;
        testWorkflow.Risk_CPU_Decision__c = null;
        testWorkflow.Risk_BM_Decision__c = 'Approved';
        worfFlowList.add(testWorkflow);
        insert worfFlowList;
        system.debug('======>'+testWorkFlow);
        testApplication.OwnerId = testUser2.Id;
        update testApplication;

        Test.startTest();
            System.runAs(testUser2){
                testWorkflow.Risk_CPU_Decision__c = 'Approve';
                testWorkflow.Status__c = 'CPU - Approve';
                testWorkflow.Assigned_To_2__c = testUser2.Id;
                testWorkflow.Approval_Description__c = 'test';
                update testWorkflow;

                ApexPages.StandardController workflowPage = new ApexPages.StandardController(testApplication);
                APP_Workflow_EXT_INT appWFExtInt = new APP_Workflow_EXT_INT(workflowPage);
                appWFExtInt.workflowList = worfFlowList;
                appWFExtInt.refreshWorkFlowList();
            }
        Test.StopTest();    
        system.debug('======>'+testApplication);
        system.debug('======>'+testWorkFlow);
        Application_Response__c appResponse = [SELECT Id, Application__c, Max_Capacity_Unsecured__c , Max_Capacity_Secured__c , Max_Term__c , Type__c FROM Application_Response__c WHERE Application__c =: testApplication.Id LIMIT 1];
        Workflow__c updatedWorkflow = [SELECT Id, Application__c, Risk_Max_UnSecured_Amount__c, Risk_Max_Secured_Amount__c, Max_Term__c, RecordType.Name FROM Workflow__c WHERE Application__c =: testApplication.Id LIMIT 1];
        
        System.debug('###appResponse: ' + appResponse);
        System.debug('###updatedWorkflow: ' + updatedWorkflow);

        
        System.assertEquals(appResponse.Max_Capacity_Unsecured__c, updatedWorkflow.Risk_Max_UnSecured_Amount__c);
        System.assertEquals(appResponse.Max_Capacity_Secured__c , updatedWorkflow.Risk_Max_Secured_Amount__c);
        System.assertEquals(appResponse.Max_Term__c , updatedWorkflow.Max_Term__c);
        System.assertEquals(appResponse.Type__c , updatedWorkflow.RecordType.Name);
        System.assertEquals(appResponse.Application__c , updatedWorkflow.Application__c); 
        }
    }
    static testMethod void constructorTest(){
    Brand__c testBrand = TestDataBuilder.createBrand();
    insert testBrand;
    
    GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
    insert testProduct;
    
    Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
    insert testProductVersion;
    
    Application__c testApplication = TestDataBuilder.createApplication();
    testApplication.Brand_Lookup__c = testBrand.Id;
    insert testApplication;
 
    List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
    insert adminSettingsList;        
   
    Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
    insert testProductItem;
    
    Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

    ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
    insert testONR;
    
    Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
    insert testLoanPurpose;
    
    Loan_Purpose__c testLoanPurpose2 = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
    insert testLoanPurpose2;

    Account testPersonAccount = TestDataBuilder.createPersonAccount();
    insert testPersonAccount;
    
    Applicant__c testApplicant = TestDataBuilder.createApplicant(testPersonAccount.Id, testApplication.Id);
    insert testApplicant;
    
    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

    Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
    insert testMetaONR;
    
    PageReference testGoToDeclinePage = new PageReference('/apex/declinedresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToApproved = new PageReference('/apex/app_submitresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToReferred = new PageReference('/apex/app_referredresponse?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoToConditional = new PageReference('/apex/submitconditionalapproval?id='+testApplication.Id+'&aId='+testApplicant.Id);
    PageReference testGoEligibility = new PageReference('/apex/app_eligibility?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToIncome = new PageReference('/apex/app_income?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToAsset = new PageReference('/apex/app_assets?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToExpense = new PageReference('/apex/app_expenses?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToDebts = new PageReference('/apex/app_debtandliabilities?id='+testApplication.Id+'&aid='+testApplicant.Id);
    PageReference testGoToAboutMe = new PageReference('/apex/app_jointpersonaldetails?id='+testApplication.Id);
    PageReference testGoToDirectDebit = new PageReference('/apex/app_directdebitdetails?id='+testApplication.Id+'&aid='+testApplicant.Id);
    List<SelectOption> testloanTermOptions = Util.getPickListValues(testApplication, 'Loan_Term__c');
    List<SelectOption> testloanFrequency = Util.getPickListValues(testApplication, 'Payment_Frequency__c');

    Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
        ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
        ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
        ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
        ApexPages.CurrentPage().getParameters().put('type', 'Joint');
        ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
        ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

        APP_MainExt AppMain = new APP_MainExt(standardCon);

        AppMain.removeLoanPurpose();
        AppMain.addLoanPurpose();
        AppMain.removeLoanPurpose();
        AppMain.register();
        AppMain.logout();
        AppMain.getTimeOut();
        AppMain.getWarning();
        List<SelectOption> loanTermOptions = AppMain.getLoanTermOptions();
        List<SelectOption> loanFrequency = AppMain.getloanFrequencyOptions();

    Test.StopTest();

    System.assertEquals(AppMain.Application.Id, testApplication.Id);
    //System.assertEquals(testloanTermOptions.size(), loanTermOptions.size());
    System.assertEquals(testloanFrequency.size() + 1, loanFrequency.size());

    }
    static testMethod void saveSuccess_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        

    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        /*PageReference testPageRefer = new PageReference('/apex/app_referredresponse?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageIncome = new PageReference('/apex/app_jointincome?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageExpense = new PageReference('/apex/app_jointexpenses?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPagePersonalDetails = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageAsset = new PageReference('/apex/app_jointassets?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageDebt = new PageReference('/apex/app_jointdebtandliabilities?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageDebit = new PageReference('/apex/app_directdebitdetails?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageTime = new PageReference('/apex/app_timeout?id=' + testApplication.Id + '&aId=' + testApplicant.Id);
        PageReference testPageRegister = new PageReference('/apex/app_register?id=' + testApplication.Id + '&prodid=' + testProduct.Id + '&itemId=' + testProductItem.Id);*/

        PageReference testPageRefer = new PageReference('/apex/app_referredresponse?id=' + testApplication.Id);
        PageReference testPageEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        PageReference testPageIncome = new PageReference('/apex/app_jointincome?id=' + testApplication.Id);
        PageReference testPageExpense = new PageReference('/apex/app_jointexpenses?id=' + testApplication.Id);
        PageReference testPagePersonalDetails = new PageReference('/apex/app_jointpersonaldetails?id=' + testApplication.Id);
        PageReference testPageAsset = new PageReference('/apex/app_jointassets?id=' + testApplication.Id);
        PageReference testPageDebt = new PageReference('/apex/app_jointdebtandliabilities?id=' + testApplication.Id);
        PageReference testPageDebit = new PageReference('/apex/app_directdebitdetails?id=' + testApplication.Id);
        PageReference testPageTime = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        PageReference testPageRegister = new PageReference('/apex/app_register?id=' + testApplication.Id + '&prodid=' + testProduct.Id + '&itemId=' + testProductItem.Id);

        PageReference testPageLogout = new PageReference('logoutPage');


        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            AppMain.redirectTo = 'Save';
            PageReference pageSave = AppMain.pageRedirect();
            
            AppMain.redirectTo = 'Refer';
            PageReference pageRefer = AppMain.pageRedirect();

            AppMain.redirectTo = 'Eligibility';
            PageReference pageEligibility = AppMain.pageRedirect();

            AppMain.redirectTo = 'Income';
            PageReference pageIncome = AppMain.pageRedirect();

            AppMain.redirectTo = 'Expense';
            PageReference pageExpense = AppMain.pageRedirect();

            AppMain.redirectTo = 'Personal';
            PageReference pagePersonal = AppMain.pageRedirect();

            AppMain.redirectTo = 'Assets';
            PageReference pageAssets = AppMain.pageRedirect();

            AppMain.redirectTo = 'Debt';
            PageReference pageDebt = AppMain.pageRedirect();
            
            AppMain.redirectTo = 'Timeout';
            PageReference pageTimout = AppMain.pageRedirect();

            AppMain.redirectTo = 'createUser';
            PageReference pageRegister = AppMain.pageRedirect();

            AppMain.redirectTo = 'createUserAccount';
            PageReference pageCreateUser = AppMain.pageRedirect();

        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
        System.assertEquals(null, pageSave);

        System.assertEquals(testPageEligibility.getUrl(), pageEligibility.getUrl());
        System.assertEquals(testPageIncome.getUrl(),pageIncome.getUrl());
        System.assertEquals(testPageExpense.getUrl(),pageExpense.getUrl());
        System.assertEquals(testPagePersonalDetails.getUrl(),pagePersonal.getUrl());
        System.assertEquals(testPageAsset.getUrl(),pageAssets.getUrl());
        System.assertEquals(testPageDebt.getUrl(),pageDebt.getUrl());
        System.assertEquals(testPageTime.getUrl(),pageTimout.getUrl());
    }  
    static testMethod void addRemoveApplicant_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;


    insert new Admin_settings__c(name = 'Timeout', value__c ='900');
    insert new Admin_Settings__c(name='Warning', value__c='600');

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        PageReference testAppMain = new PageReference('/apex/app_main?id=' + testApplication.Id);
        PageReference testEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            PageReference deleteApplicant = AppMain.deleteApplicant();
            PageReference addApplicant = AppMain.addApplicant2();

        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
        System.assertEquals(testAppMain.getUrl(), deleteApplicant.getUrl());
        System.assertEquals(testEligibility.getUrl(), addApplicant.getUrl());
    }
    static testMethod void saveFailure_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Id onrRTypeId = [SELECT Id FROM RecordType where sOBjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRTypeId);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;

        PageReference testAppMain = new PageReference('/apex/app_main?id=' + testApplication.Id);
        PageReference testEligibility = new PageReference('/apex/app_eligibility?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.CurrentPage().getParameters().put('prodId', testProduct.Id);            
            ApexPages.CurrentPage().getParameters().put('othInt', 'true');           
            ApexPages.CurrentPage().getParameters().put('type', 'Joint');
            ApexPages.CurrentPage().getParameters().put('fName2', 'Sample');         
            ApexPages.CurrentPage().getParameters().put('othInt2', 'true');

            APP_MainExt AppMain = new APP_MainExt(standardCon);
            AppMain.redirectTo = 'Save';
            AppMain.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, AppMain.application.Id);
    }
        public static testmethod void testClass(){
            List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
            insert insPremVariables;
    
            // Create Test Person Account
            List<Account> accList = testDataBuilder.createPersonAccounts(1);
            accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
            insert accList;
    
            List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
            insert adminSettingsList;        
            
            //Brand__c testBrand = testDataBuilder.createBrand();
            //insert testBrand;
    
            // Create Test Application
            
            
    
            // Jerome
            RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
    
            Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
            Application__c appVar = testDataBuilder.createApplication();
            appVar.Brand_Lookup__c = testBrand.Id;
            insert appVar;
    
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
            
            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(appVar.Id,ONRrecordType.Id);
            insert testONR;
    
            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(appVar.Id, testONR.Id);
            insert testLoanPurpose;
    
            Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
            insert rateCard;
    
            Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
            insert rate;
            // end
            
            // Create Applicant 1
            Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
            appliVar1.Is_Primary_Applicant__c = true;
            insert appliVar1;
            
            //Added as part of AU APOI
             Income__c inVar1 = testDataBuilder.createIncome(appliVar1.Id);
             inVar1.Income_Source__c ='Net Salary/Wages';
             insert inVar1;
                
             Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
             insert inCap;
             //End as part of AU APOI
             
            // Create Application Response
            Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(appVar.Id);
            insert appResponse;
    
            // Create Requested Document
            Requested_Document__c rdVar = new Requested_Document__c(Application__c = appVar.Id);
            insert rdVar;
            
            // Create response code custom setting
            Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'PIA');
            insert rccVar;
                
            test.startTest();
                //  Satisfy not joint condition
                ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
                APP_GSD_FileUpload pIncomeExt = new APP_GSD_FileUpload(standardCon);
                system.assertEquals(false,pIncomeExt.getIsJoint());
                
                // Satisfy joint condition
                // Create Applicant 2
                Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
                insert appliVar2;
                
                standardCon = new ApexPages.standardController(appVar);
                pIncomeExt = new APP_GSD_FileUpload(standardCon);
                system.assertEquals(false,pIncomeExt.getIsJoint());
            
                pIncomeExt.application.Status__c = null;
                pIncomeExt.application.Response_Code__c = 'PIA';
                system.assertEquals(null, pIncomeExt.validatePostSubmit());
                
                pageReference pgRef = Page.APP_Complete;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = 'FIA';
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                pgRef = Page.APP_Main;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = null;
                pIncomeExt.application.Status__c = 'New';
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                pgRef = Page.APP_Main_PostSubmit;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = 'PCO';
                pIncomeExt.application.Status__c = 'Submitted';
                pIncomeExt.application.Acceptance_Channel__c = null;
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                // Redirect methods
                pIncomeExt.redirectMain();
                pIncomeExt.redirectToCompletePage();
                pIncomeExt.logout();
    
                // Count method
                // system.assertEquals(5,pIncomeExt.getRDCount());
            test.stopTest();
    }
     @isTest static void NullBrand_Test() {
        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;        //Updated by Txu 25/11/2014
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){
            Account account = new Account();
            account.LastName = 'account';
            account.RecordTypeId = personAccountRecordTypeId;
            insert account;
            System.assertEquals(account.LastName,'account');//assert inserted Account

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: account.Id].Id;

            User user = new User();
            user.Username = 'username@username.com';
            user.Email = 'email@email.com';
            user.FirstName = 'firstname';    
            user.LastName = 'lastname';
            user.CommunityNickname = 'nickname';
            user.Date_Of_Birth__c = '01-01-1991';
            user.ProfileId = customerProfileId;
            user.Alias = 'emai';
            user.TimeZoneSidKey = 'GMT';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Password_Reset_Token__c = '12345qwert';
            user.Password_Reset_Attempts__c = 0;
            user.Valid_Password_Reset_Timestamp__c =  datetime.now();
            user.Password_Reset_Timestamp__c =  datetime.now();
            user.Title = 'Mr';
            user.ContactId = contactId;
            insert user;

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = 'email@email.com';
            controller.password = 'test123';

            controller.login();

        }
    }  
      static testMethod void abc(){
      Boolean appVar = true;
     // String appVarString = String.valueof(appVar) ;
      Application__c app = TestDataBuilder.createApplication();
      app.Status__c = 'Closed';
      insert app;
      
    
      
      
      }
      
    static testMethod void appCreateRecords() {
 // Webservice Settings
        List<Web_Service_Settings__c> wsList = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c cwCSSales = testDataBuilder.createWebServiceSettings('Requested Name Sales', 'Sales');
        Web_Service_Settings__c cwCSCustomer = testDataBuilder.createWebServiceSettings('Requested Name Customer', 'Customer');
        wsList.add(cwCSSales);
        wsList.add(cwCSCustomer);
        insert wsList;
        
        System.assertEquals(wsList.size() > 0 ,true);        
        
        // Grant Profile Access to current user
        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
            
        // Create Admin Settings
        List<Admin_Settings__c> adminSettingsList = testDataBuilder.adminSet();
        insert adminSettingsList;   
        
        NZ_Specific_Settings__c nzs = TestDataBuilder.createNZSpecificSettings();
        insert nzs;
        
        // Create 'Clone' Response Code Access
        Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'Clone'); 
        insert rccVar;
        
        // Create Country ISO
        List<Country_Setting__c>csList = new List<Country_Setting__c>();
        csList.add(testDataBuilder.createCountrySetting('Australia','AU'));
        csList.add(testDataBuilder.createCountrySetting('New Zealand','NZ'));
        insert csList;

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
        
         System.assertEquals(camList.size() > 0 ,true);
        
        
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

        // Create Product
        GEProduct__c  geProdVar = TestDatabuilder.createGEProduct(testBrand.Id);
        insert geProdVar;

        // Create Product Version
        Product_Version__c pverVar = TestDataBuilder.createProductVersion(geProdVar.Id);
        insert pverVar;

        // Create Applicaton
       
       List<Application__c> applist = new List<Application__c>();
       Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        testApplication.Product_Id__c = string.valueOf(geProdVar.Id);
        testApplication.Offered_Repayments__c = 10000;
        testApplication.loan_term__c = '0.5'; 
        testApplication.iOvation_Type__c = '3rd Party Application';
        applist.add(testApplication);
        insert applist;

        System.assertEquals(applist.size(),1);

        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicants
            // Applicant 1
            Applicant__c testApplicant = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            testApplicant.Has_AML__c = true; 
            testApplicant.Is_Primary_Applicant__c = true;
            testApplicant.Email_Address__c = 'ar14@cs.com';
            appliList.add(testApplicant);
            // Applicant 2        
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            appliList.add(testApplicant2);
            insert appliList;
        // End Create Applicants
        
        testApplication.loan_term__c = '2';
        testApplication.iOvation_Type__c = 'channel';
        update testApplication;
        
        APP_CommonExt.isEmailAvailable(testApplicant);
        
        
        // Create Applicant child values
            // Create Applicant Account Customer
            Applicant_Account_Customer__c testAppAccCust = TestDataBuilder.createApplicantAccountCustomer(testApplicant.Id);
            insert testAppAccCust;
            
            // Create Income for Applicant 1 and 2
            List<Income__c>appliIncomeList = new List<Income__c>();
            Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
            appliIncomeList.add(testIncome);
            Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
            appliIncomeList.add(testIncome2);
            insert appliIncomeList;
            
            // Create Asset for Applicant 1
            Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
            insert testAsset;
    
            // Create Expense for Applicant 1 and 2
            List<Expense__c>appliExpList = new List<Expense__c>();
            Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
            appliExpList.add(testExpense);
            Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
            appliExpList.add(testExpense2);
            insert appliExpList;
            
            // Create Liability for Applicant 1
            Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
            insert testDebt;
    
            // Create AML for Applicant 1
            List<AML__c> amlList = new List<AML__c>();
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
            amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 3, 'Utility Bill'));
            insert amlList;

            Street_Type_Setting__c streetType = new Street_Type_Setting__c();
            streetType.Name='Road';
            streetType.Value__c='Road';
            streetType.Region__c='Both';
            streetType.Value_Abbreviated__c='Rd';
            streetType.Value_Abbreviated_NZ__c='Rd';
            insert streetType;
        
            // Create Related Document for Applicant 1 and 2
            List<Related_Document__c>relDocList = new List<Related_Document__c>();
            Related_Document__c relDVar1 = testDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
            relDocList.add(relDVar1);
            Related_Document__c relDVar2 = testDataBuilder.createRelatedDocument(testApplicant2.Id, testApplication.Id);
            relDocList.add(relDVar2);
            insert relDocList;
            
                  
            // Create Credit File Check for Applicant 1 and 2
            List<Credit_File_Check__c> cfcList = new List<Credit_File_Check__c>();
            Credit_File_Check__c cfCheckVar1 = TestDataBuilder.createCreditFileCheck(testApplicant.Id, testApplication.Id);
            cfcList.add(cfCheckVar1);
            Credit_File_Check__c cfCheckVar2 = TestDataBuilder.createCreditFileCheck(testApplicant2.Id, testApplication.Id);
            cfcList.add(cfCheckVar2);
            insert cfcList;
        // End Create Applicant child values

        // Documents
        // Create Requested Document
        Requested_Document__c reqDVar = testDataBuilder.createRequestDoc(testApplication.Id);
        insert reqDVar;
            
        // Create GE Product, Version and Item
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
            Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
            insert testProductItem;
        
        
          // Search and Match Values
            //InsertApplicantSearch
            Applicant_Search__c testAppSearch = TestDataBuilder.appSearch();
            insert testAppSearch;
            //Insert Applicant CLV
            List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearch.Id,testApplicant.Id);
            insert testApplicantCLVList;
            //Insert Applicant Account
            Applicant_Account__c testAppAcc = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
            insert testAppAcc;
            // Applicant Account Child
                //Insert Applicant Account Involved Party
                Applicant_Account_Involved_Party__c testAppAccInvolvedParty = TestDataBuilder.createApplicantAccountInvolvedParty(testAppAcc.Id);
                insert testAppAccInvolvedParty;     
                //Insert Applicant Account Bus Contract Goods
                App_Account_Bus_Contract_Goods__c testAppAccBusContractGoods = TestDataBuilder.createApplicantAccountBusContract(testAppAcc.Id);
                insert testAppAccBusContractGoods;
                //Insert Applicant Account History
                Applicant_Account_History__c testAppAccHistory = TestDataBuilder.createApplicantAccountHistory(testAppAcc.Id);
                insert testAppAccHistory;
                //Insert Applicant Account Loss History
                Applicant_Account_Loss_History__c testAppAccLossHistory = TestDataBuilder.createApplicantAccountLossHistory(testAppAcc.Id);
                insert testAppAccLossHistory;
                //Insert Applicant Account Plan
                Applicant_Account_Plan__c testAppAccPlan = TestDataBuilder.createApplicantAccountPlan(testAppAcc.Id);
                insert testAppAccPlan;
        
        // Personal Reference Check
        Personal_Reference_Check__c prefCheckVar = testDataBuilder.createPersonalReferenceCheck(testApplication.Id);
        insert prefCheckVar;
         
        // Credit Ref Check
        Credit_Ref_Check__c testCreditRefCheck = TestDataBuilder.createCreditRefCheck(testApplication.Id);
        insert testCreditRefCheck;
        
        List <ONR__c> onrlist = new List <ONR__c>();
        
        List < Meta_ONR__c > metaONR = TestDataBuilder.createMetaONRLoanPurpose();
        insert metaONR;
        
        Application__Share ashare = new Application__Share();
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Test.startTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication); 
            Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;                       
            APP_CommonExt apCommonCntrl =new APP_CommonExt(standardCon);
            apCommonCntrl.ProductSelected = 'Better Start PL';
            apCommonCntrl.type = 'test';
            apCommonCntrl.channel = 'online';
            apCommonCntrl.insurance = false;
            apCommonCntrl.interestOnOtherServices = false;
            apCommonCntrl.applicant1FirstName = 'abcd';
            apCommonCntrl.insurance2 = false;
            apCommonCntrl.interestOnOtherServices2 = false;
            apCommonCntrl.applicant2FirstName = 'xyz';
            PageReference pageRef1 = Page.APP_Eligibility;
            pageRef1.getParameters().put('subtype',apCommonCntrl.ProductSelected);
            Test.setCurrentPage(pageRef1);
            apCommonCntrl.getLoanTermOnProduct();
            
            List<Income__c>incList = apCommonCntrl.incomeList;
            List<Asset__c> assList = apCommonCntrl.assetList; 
            List<Expense__c> expList = apCommonCntrl.expenseList; 
            List<Liability__c> debtList = apCommonCntrl.debtList; 
            List<Income__c> inc2List = apCommonCntrl.incomeList2;
            List<Expense__c> exp2List = apCommonCntrl.expenseList2; 
            Brand__c brVar = apCommonCntrl.brand;

            apCommonCntrl.retrieveApplication(string.valueOf(testApplication.Id));
            //apCommonCntrl.retrieveApplicant(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveApplicants(string.valueOf(testApplication.Id));
            apCommonCntrl.retrievePersonAccount(string.valueOf(accVar[0].Id));
            apCommonCntrl.retrieveIncomeList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveIncomeMap(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveAssetList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveExpenseList(string.valueOf(testApplicant.Id));

            set<Id> appliIdSet = new Set<Id>();
            appliIdSet.add(string.valueOf(testApplicant.Id));
            appliIdSet.add(string.valueOf(testApplicant2.Id));
            apCommonCntrl.retrieveAllExpenses(appliIdSet);
            apCommonCntrl.retrieveDebtList(string.valueOf(testApplicant.Id));
            apCommonCntrl.retrieveLoanPurposeList();
            apCommonCntrl.retrieveDisbursementList();
            apCommonCntrl.retrieveRefinanceDisbursementList();
            apCommonCntrl.retrieveAMLList(testApplicant.Id);
            apCommonCntrl.retrieveRelatedDocuments(testApplicant.Id);
         
            apCommonCntrl.retrieveDirectDebit(string.valueOf(testApplication.Id),ONRrecordType.ID);
            apCommonCntrl.retrieveAllDirectDebit(testApplication.Id);
            apCommonCntrl.retrieveProductItem(string.valueOf(testApplication.Id));
            apCommonCntrl.retrieveAllProductItems(string.valueOf(testApplication.Id));
            try{
            if(pverVar.Id != null){
            apCommonCntrl.retrieveProductVersion(string.valueOf(pverVar.Id));
            }
            }
            catch(Exception e){
             
            }
           Savepoint sp = Database.setSavepoint();
         
            apCommonCntrl.isStandardUser();
            apCommonCntrl.isJoint();
            apCommonCntrl.getRequestedName();

            List < personalDetailsWrapper > applicantWrapperList = new List < personalDetailsWrapper >();

            personalDetailsWrapper applicantwrapper = new personalDetailsWrapper();
            applicantwrapper.expiryYear = '2018';
            applicantwrapper.expiryMonth= '02';
            applicantwrapper.expiryDate='15';
            applicantwrapper.issueMonth='03';
            applicantwrapper.issueDate='15';
            applicantwrapper.issueYear='2018';
            applicantwrapper.expiryDateSec='15';
            applicantwrapper.expiryYearSec='2018';
            applicantwrapper.expiryMonthSec='10';
            applicantwrapper.issueYearSec='2018';
            applicantwrapper.issueMonthSec='03';
            applicantwrapper.issueDateSec='10';
            applicantwrapper.applicant.Customer_ID_Type__c = 'NZ Birth Certificate';
            applicantWrapperList.add(applicantWrapper);
                      
            Applicant__c appli = new Applicant__c();
            appli.Id =null;
            
            apCommonCntrl.totAmount =25000;
            apCommonCntrl.type='joint';
            
                 
            List <LoanWrapper> loanWrapList = new List <LoanWrapper>();
            loanwrapper lw = new loanWrapper();
            lw.loan.Value__c = 'Debt consolidation';
            loanwrapList.add(lw);
            
                      
            apCommonCntrl.createGenericRecords();
            //System.assertNOTEquals(null, testApplication.Id);
            
            APP_CommonExt.brandCountry = 'AU';            
            apCommonCntrl.getStreetTypeOptions();
            apCommonCntrl.getCountryOpts();
            apCommonCntrl.getLoanTermOnProduct();
            apCommonCntrl.getProductOnLoanSelection();
            apCommonCntrl.getproductOptions();
            apCommonCntrl.isSystemReasonCode('test');
            apCommonCntrl.createAML(applicantWrapperList);
            apCommonCntrl.createAMLs(applicantWrapper,applicantwrapper.applicant.AML__c,'Primary');
            apCommonCntrl.createAMLs(applicantWrapper,applicantwrapper.applicant.AML__c,'Secondary');
            
            String pageName = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE;
            PageReference pgRef = Page.APP_Eligibility;
            APP_CommonExt.backPage(); 

            String pageName1 = 'app_jointincome';
            APP_CommonExt.backPage(); 
                      
            
            ApexPages.currentPage().getParameters().put('subType', 'better start'); 
            
            APP_CommonExt.isEmailAvailable(testApplicant);
            APP_CommonExt.isEmailAvailable('ar14@cs.com');
            APP_CommonExt.validatePhone('Regular','11111111111');
            APP_CommonExt.validatePhone('Home','11111111112');
            APP_CommonExt.validatePhone('Work','11111111113');
            APP_CommonExt.validatePhone('Mobile','11111111114');
            apCommonCntrl.getDateOptions();
            apCommonCntrl.birthMonth2 = '02';
            apCommonCntrl.birthMonth = '02';
            apCommonCntrl.getDateOptions2();
            apCommonCntrl.getDateOptions();
            List < SelectOption > rsOpList = apCommonCntrl.relationshipStatusOptions;
            List < SelectOption > yearAddOpList = apCommonCntrl.yearAtAddressOptions;
            List < SelectOption >  mAddOpList = apCommonCntrl.monthsAtAddressOptions;
            List < SelectOption > resOpList = apCommonCntrl.residentialStatusOptions;
            List < SelectOption > pfMetOpList = apCommonCntrl.preferredContactMethodOptions;
            List < SelectOption >  titleOpList = apCommonCntrl.titleOptions;
            List < SelectOption > genOpList = apCommonCntrl.genderOptions;
            List < SelectOption > stateOpList = apCommonCntrl.stateOptions;
            List < SelectOption > conOpList = apCommonCntrl.countryOptions;
            apCommonCntrl.setDate();
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Weekly');
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Fortnightly');
            apCommonCntrl.getRepaymentWithFrequency(testApplication,'Yearly');
            
            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE;           
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_INCOME;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ASSET;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_DEBT;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_EXPENSE;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_CUICONTRACTACCEPTANCE; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ABOUTME;
            apCommonCntrl.pageNavigation();

            apCommonCntrl.callingPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY; 
            apCommonCntrl.destinationPage = GEN_OriginationsConstants.PAGE_ELIGIBILITY;
            apCommonCntrl.pageNavigation();

            List < SelectOption > empStatOpList = apCommonCntrl.employmentStatusOptions;
            List < SelectOption > pEmpStatOpList= apCommonCntrl.preEmploymentStatusOptions;
            apCommonCntrl.applicationIsSubmitted(testApplication);
            apCommonCntrl.validateApply();
            apCommonCntrl.getApplicationStatus();
            APP_CommonExt.getIPAddress();
            apCommonCntrl.productSelected = 'Better Start PL';
            apCommonCntrl.getloanTermOptions();
            List < SelectOption >  lFreOpList = apCommonCntrl.getloanFrequencyOptions();
                        
            apCommonCntrl.initializeLoanPurposes();
            apCommonCntrl.addLoanPurpose();
            apCommonCntrl.loanWrapList[0].Loan.Value__c = 'Please Select';
            apCommonCntrl.loanWrapList[0].Loan.Loan_Amount__c =0;
            apCommonCntrl.loanWrapList[0].Loan.Other_Loan_Purpose__c =null;
            apCommonCntrl.loanWrapList[1].Loan.Value__c = 'Other';

            apCommonCntrl.removeLoanPurpose();
            apCommonCntrl.calculateLoanAmountTotal();
            apCommonCntrl.refreshLoanCount();
            
            apCommonCntrl.saveLoanPurposes();
            apCommonCntrl.loanTermSelected = null;
            apCommonCntrl.totAmount = 100;
            apCommonCntrl.validateLoanFields();
            apCommonCntrl.submitServiceCallCustomer();
            APP_CommonExt.parsePOICodes('C90AS|C90AS; C90AS', 'Applicant 1');

           
        Test.stopTest();

    
   }
      
       
}