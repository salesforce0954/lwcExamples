@isTest
public class APP_Main_PostSubmitExt_Test {
    /* 
    *  Description: Post Submit Test
    *  Author: Adrian Recio
    *  Input Parameters: NA
    *  Return: void
    */
    static testMethod void PostSubmit_testMethod() {
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

        // Create Document
        List<Document>docList = new List<Document>();
        Document docVar1 = TestDataBuilder.createDocument('GE_terms_and_conditions');
        Document docVar2 = TestDataBuilder.createDocument('Kiwibank_terms_and_conditions');
        Document docVar3 = TestDataBuilder.createDocument('Disclosure_Statement');
        Document docVar4 = TestDataBuilder.createDocument('Repayment_protection_brochure');
        docList.add(docVar1);
        docList.add(docVar2);
        docList.add(docVar3);
        docList.add(docVar4);
        insert docList;

        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        testApplication.Application_Type__c = GEN_OriginationsConstants.APPLICATION_TYPE_JOINT;
        insert testApplication;
        
        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicants
            // Applicant 1
            Applicant__c testApplicant = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            testApplicant.Has_AML__c = true; 
            appliList.add(testApplicant);
            // Applicant 2        
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
            appliList.add(testApplicant2);
            insert appliList;
        // End Create Applicants
        
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
        reqDVar.Status__c = 'Requested';
        insert reqDVar;
            
        // Create GE Product, Version and Item
            List<GEProduct__c> gePList = new List<GEProduct__c>();
            GEProduct__c testProductInsurance = TestDataBuilder.createGEProduct(testBrand.Id);
            testProductInsurance.Name = GEN_OriginationsConstants.LIFE_INSURANCE;
            gePList.add(testProductInsurance);

            GEProduct__c testProductDisability = TestDataBuilder.createGEProduct(testBrand.Id);
            testProductDisability.Name = GEN_OriginationsConstants.DISABILITY_INSURANCE;
            gePList.add(testProductDisability);

            insert gePList;

            List<Product_Version__c>pvList = new List<Product_Version__c>();
            Product_Version__c testProductVersion1 = TestDataBuilder.createProductVersion(testProductInsurance.Id);
            pvList.add(testProductVersion1);

            Product_Version__c testProductVersion2 = TestDataBuilder.createProductVersion(testProductDisability.Id);
            pvList.add(testProductVersion2);
            
            insert pvList;

            List<Product_Item__c>piList = new List<Product_Item__c>();
            Product_Item__c testProductItem1 = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion1.Id);
            piList.add(testProductItem1);

            Product_Item__c testProductItem2 = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion2.Id);
            piList.add(testProductItem2);

            insert piList;
        
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
        
        // Create ONR
        // Pull ONR recordtype with type of General
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;


        test.StartTest();
             ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
             APP_Main_PostSubmitExt mainPost = new APP_Main_PostSubmitExt(standardCon);

             // Assert document endpoints
             //system.assertEquals(mainPost.GETnCurl, '/servlet/servlet.FileDownload?file=' + docVar1.Id);
             //system.assertEquals(mainPost.KiwiTnCurl,'/servlet/servlet.FileDownload?file=' + docVar2.Id);
             //system.assertEquals(mainPost.Disclouserurl,'/servlet/servlet.FileDownload?file=' + docVar3.Id);
             //system.assertEquals(mainPost.repaymentURL,'/servlet/servlet.FileDownload?file=' + docVar4.Id);

             // Assert flag variables
             system.assertEquals(mainPost.hasDisabilityInsurance,true);
             system.assertEquals(mainPost.hasLifeInsurance,true);
             system.assertEquals(mainPost.hadDocuments,true);

             // Call validate Application Status if Status is New
             PageReference appMaintPR = Page.APP_Main;
             appMaintPR.getParameters().put('Id',mainPost.application.Id);
             system.assertEquals(string.valueOf(mainPost.validateApplicationStatus()),string.valueOf(appMaintPR));
             
             // Update Application Response Code to Accepted
             mainPost.application.Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
             mainPost.application.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_ACCEPTED;

             // Call validate Application Status if Response Code is Accepted
             PageReference appComPR = Page.APP_Complete;
             appComPR.getParameters().put('Id',mainPost.application.Id);
             system.assertEquals(string.valueOf(mainPost.validateApplicationStatus()),string.valueOf(appComPR));

             // Update Application Response Code to invalid match
             mainPost.application.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA;

            // Call validate Application Status if Response Code is PCA
             system.assertEquals(string.valueOf(mainPost.validateApplicationStatus()),null);

             // Null Redirect
             mainPost.redirectTo = null;
             system.assertEquals(mainPost.pageRedirect(),null);

             // Logout Redirect
             mainPost.redirectTo = 'logout';
             system.assertEquals(string.valueOf(mainPost.pageRedirect()),string.valueOf(Page.APP_Logout));

             // Timeout Redirect
             mainPost.redirectTo = 'timeout';
             system.assertEquals(string.valueOf(mainPost.pageRedirect()),string.valueOf(Page.APP_Timeout));

             // Logout redirect
             system.assertEquals(string.valueOf(mainPost.logout()),string.valueOf(Page.APP_Logout));
             
             // File Upload Redirect
             PageReference gtUploadVar = Page.APP_CustomerUIFileUpload;
             gtUploadVar.getParameters().put('id',mainPost.application.Id);
             system.assertEquals(string.valueOf(mainPost.goToUpload()),string.valueOf(gtUploadVar));

             // Getters
             system.assertEquals(mainPost.AS_TIMEOUT,mainPost.getTimeOut());
             system.assertEquals(mainPost.AS_WARNING,mainPost.getWarning());

             // Validate Applicant Access
             mainPost.validateApplicantAccess();
             
        test.StopTest();
    }
}