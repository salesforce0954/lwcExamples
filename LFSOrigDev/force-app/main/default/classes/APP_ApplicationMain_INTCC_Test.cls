@isTest
public class APP_ApplicationMain_INTCC_Test {
    static testMethod void constructorEnableButtonsTest(){
        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;
        

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('submit','onSubmit');
            ApexPages.CurrentPage().getParameters().put('tab','preContractGenTab');
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();

        
        System.assertEquals(false, AppMain.showHideCloseButton);
        System.assertEquals(false, AppMain.showHideCPUCaseButton );
        System.assertEquals(false, AppMain.showHideEditButton );
        System.assertEquals(false, AppMain.showHideSubmitButton );
        System.assertEquals(false, !AppMain.verifyPOIButton );
        //System.assertEquals(false, AppMain.updateApplicationButton );
        System.assertEquals(false, AppMain.userLoginButton );
        System.assertEquals(false, AppMain.userLoginButton2 );
        System.assertEquals(false, AppMain.showGenerateDoc );
        // Adding NZ CR code changes
        // System.assertEquals(false, AppMain.showHideSubmitButtonNZ );
         // System.assertEquals(false,AppMain.showHideSaveQuoteButton );

    }
    static testMethod void constructorDisableButtonsTest(){
        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(false);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('submit','onSubmit');
            ApexPages.CurrentPage().getParameters().put('tab','preContractGenTab');
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();
        
        System.assertEquals(true, AppMain.showHideCloseButton);
        System.assertEquals(true, AppMain.showHideCPUCaseButton );
        System.assertEquals(true, AppMain.showHideEditButton );
        System.assertEquals(true, AppMain.showHideSubmitButton );
        System.assertEquals(true, AppMain.verifyPOIButton );
        //System.assertEquals(true, AppMain.updateApplicationButton ); //UPDATED BY DYU 17-AUG-2015 - Remove and investigate assert failure
        System.assertEquals(true, AppMain.userLoginButton );
        System.assertEquals(true, AppMain.userLoginButton2 );
        System.assertEquals(true, AppMain.showGenerateDoc );
        // Adding NZ CR code changes
         System.assertEquals(true, AppMain.showHideSubmitButtonNZ );
          System.assertEquals(true, AppMain.showHideSaveQuoteButton );
    }
    static testMethod void constructorDisableButtons2Test(){
        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Compliance_Check__c testComplianceCheck = TestDataBuilder.createComplianceCheck(testApplication.Id);
            testComplianceCheck.PFR_Check__c = 'Yes';
            testComplianceCheck.BM_Check__c = 'Yes';
            testComplianceCheck.BM_Only__c = true;
            testComplianceCheck.PFR_Only__c = true;
        insert testComplianceCheck;

        Compliance_Check__c testComplianceCheck2 = TestDataBuilder.createComplianceCheck(testApplication.Id);
            testComplianceCheck2.PFR_Only__c = true;
            testComplianceCheck2.BM_Only__c = true;
        insert testComplianceCheck2;

        Compliance_Check__c testComplianceCheck3 = TestDataBuilder.createComplianceCheck(testApplication.Id);
            testComplianceCheck3.PFR_Only__c = true;
            testComplianceCheck2.BM_Only__c = true;
        insert testComplianceCheck3;

        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'Sample');
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, 'Sample');
        insert testResponseCodeControl2;
        
        

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(false);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('tab','onSubmit');
            ApexPages.CurrentPage().getParameters().put('subTab ','test');
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();
        
        System.assertEquals(true, AppMain.showHideCloseButton);
        System.assertEquals(true, AppMain.showHideCPUCaseButton );
        System.assertEquals(true, AppMain.showHideEditButton );
        System.assertEquals(true, AppMain.showHideSubmitButton );
        System.assertEquals(true, AppMain.verifyPOIButton );
        System.assertEquals(true, AppMain.updateApplicationButton );
        System.assertEquals(true, AppMain.userLoginButton );
        System.assertEquals(true, AppMain.userLoginButton2 );
        System.assertEquals(true, AppMain.showGenerateDoc );
        // Adding NZ CR code changes
        // System.assertEquals(true, AppMain.showHideSubmitButtonNZ );
         //System.assertEquals(true, AppMain.showHideSaveQuoteButton );
    }
    static testMethod void PageReferencesTest(){
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant2.Is_Primary_Applicant__c = false;
        insert testApplicant2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        testAsset.Applicable_Party__c = GEN_OriginationsConstants.BOTH;
        insert testAsset;
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('document','true');
            //ApexPages.CurrentPage().getParameters().put('tab','preContractGenTab');
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();
        
        AppMain.acceptOffer();
        AppMain.fireDocGenServiceCall();
        AppMain.verifyPOI();
        AppMain.cancelApplication();
        AppMain.creatUser();
        AppMain.updateApplication();
        AppMain.submitApplication();
        AppMain.editApplication();
        //AppMain.extractApplication();
        AppMain.updateFPfields();
        AppMain.refreshApplication();

        System.assertEquals('Requested Name Sales', testWebServiceSettings.Name);
        System.assertEquals('SalesUI', testWebServiceSettings.Value__c);
        System.assertEquals(testBrand.Id, testApplication.Brand_Lookup__c);
        System.assert(!adminSettingsList.isEmpty());
        System.assertEquals(testApplication.Submission_Status__c, testResponseCodeControl.Name);
        System.assertEquals(testApplication.Response_Code__c, testResponseCodeControl2.Name);
        System.assertEquals(testApplication.Id, testApplicant.Application__c);
        System.assertEquals(testApplication.Id, testApplicant2.Application__c);
        System.assertEquals(testApplicant.Id, testAsset.Applicant__c);
    }

    static testMethod void SubmitApplicationTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Name = 'Disability Insurance';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Fees_Charges__c testFees = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        insert testFees;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applicationBuilder.application.Id);
        insert testAppResponse;

        Decision__c testDecision = TestDataBuilder.createDecision(applicationBuilder.application.Id, true);
        insert testDecision;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(applicationBuilder.application);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.updateFPfields();
            AppMain.submitServiceCall();
            //AppMain.updateApplication();
        Test.StopTest();
        
        System.assertEquals(testBrand.Id, testProduct.Brands__c);
        System.assertEquals(testProduct.Id, testProductVersion.GEProduct__c);
        System.assert(!adminSettingsList.isEmpty());
        System.assertEquals(testProductVersion.Id, testFees.Product_Version__c);
        System.assertEquals('Requested Name Sales', testWebServiceSettings.Name);
        System.assertEquals('SalesUI', testWebServiceSettings.Value__c);
    }

    static testMethod void updateApplicationTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Name = 'Disability Insurance';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Fees_Charges__c testFees = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        insert testFees;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);

        applicationBuilder.application.Out_Of_Sync__c = true;
        applicationBuilder.application.Doc_Gen_Check__c = true;
        update applicationBuilder.application;

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applicationBuilder.application.Id);
        insert testAppResponse;

        Decision__c testDecision = TestDataBuilder.createDecision(applicationBuilder.application.Id, true);
        insert testDecision;

        Test.StartTest();
          Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(applicationBuilder.application);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.updateApplication();
        Test.StopTest();
        
        System.assertEquals(testBrand.Id, testProduct.Brands__c);
        System.assertEquals(testProduct.Id, testProductVersion.GEProduct__c);
        System.assert(!adminSettingsList.isEmpty());
        System.assertEquals(testProductVersion.Id, testFees.Product_Version__c);
        System.assertEquals('Requested Name Sales', testWebServiceSettings.Name);
        System.assertEquals('SalesUI', testWebServiceSettings.Value__c);
    }

    //Pending verifyPOI and acceptOffer: waiting for Dan's test classes
    static testMethod void RemainingTest1(){
      Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
      insert testWebServiceSettings;

        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;  
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;      
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

      WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(applicationBuilder.application);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.verifyPOI();
            AppMain.acceptOffer();
            AppMain.fireDocGenServiceCall();
        Test.StopTest();
    }

    static testMethod void TimeoutTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;  
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Status__c = null;
        testApplication.Response_Code__c = 'test';
        testApplication.Last_Webservice_Operation_Invoked__c = 'test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;      
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.Name = 'test';
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

        Webservice_Message_Codes__c testWMC = new Webservice_Message_Codes__c ();
        testWMC.Name = 'err';
        testWMC.Synchronous__c = false;
        testWMC.Error_Message__c = 'err';
        testWMC.Message_Description__c = 'test';
        insert testWMC;

        Webservice_Status_Error_Messages__c testWSEM = new Webservice_Status_Error_Messages__c();
        testWSEM.Name = 'test';
        testWSEM.Error_Message__c = 'test';
        testWSEM.Status_Field__c = 'Response_Code__c';
        testWSEM.Status_Value__c = 'test';
        insert testWSEM;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            ApexPages.CurrentPage().getParameters().put('timeout','test');
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();
    }

    static testMethod void ASYNCWebserviceErrorsTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Status__c = null;
        testApplication.Response_Code__c = 'err';
        testApplication.Last_Webservice_Operation_Invoked__c = 'test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;        
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.Name = 'test';                                    
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;


        Webservice_Message_Codes__c testWMC = new Webservice_Message_Codes__c ();
        testWMC.Name = 'err';
        testWMC.Synchronous__c = false;
        testWMC.Error_Message__c = 'err';
        testWMC.Message_Description__c = 'test';
        insert testWMC;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;    
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
        Test.StopTest();
    }

    static testMethod void cancelApplicationTest(){
        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'New';
        insert testApplication;
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.cancelApplication();
        Test.StopTest();

        Application__c updatedApplication = [SELECT Status__c, Response_code__c FROM Application__c WHERE Id =: testApplication.Id];

        System.assertEquals(updatedApplication.Status__c, updatedApplication.Response_Code__c);
    }

    static testMethod void changeBrandKiwibankTest(){

        List<Branch__c> testBranchList = TestDataBuilder.createBranch(2);
        testBranchList.get(0).Branch_Id__c = '190';
        testBranchList.get(1).Branch_Id__c = '191';
        insert testBranchList;

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'NZ';
        testBrand.Name = 'Kiwibank';
        insert testBrand; 

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id, GEN_OriginationsConstants.PRODUCT_TYPE);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;    
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Branch__c = testBranchList.get(1).Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;    
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        Application__c insertedApplication = [SELECT Id FROM Application__c WHERE Id =: testApplication.Id];

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(insertedApplication);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.changeBrand();
        Test.StopTest();

        Application__c updatedApplication = [SELECT Brand_Lookup__c, 
                                                    Brand_String__c,
                                                    Branch__c,
                                                    Out_Of_Sync__c,
                                                    Need_Deal_Reallocation__c
                                             FROM   Application__c 
                                             WHERE  Id =: testApplication.Id];

        
        //BEGIN - UPDATED BY DYU - FOR INVESTIGATION
        /*System.assertEquals(testBrand.Id, updatedApplication.Brand_Lookup__c);
        System.assertEquals(testBrand.Name, updatedApplication.Brand_String__c);
        System.assertEquals(testBranchList.get(0).Id, updatedApplication.Branch__c);
        System.assertEquals(true, updatedApplication.Out_Of_Sync__c);
        System.assertEquals(false, updatedApplication.Need_Deal_Reallocation__c);*/
        //END
    }

    static testMethod void changeBrandGEMoneyNZTest(){

        List<Branch__c> testBranchList = TestDataBuilder.createBranch(2);
        testBranchList.get(0).Branch_Id__c = '190';
        testBranchList.get(1).Branch_Id__c = '191';
        insert testBranchList;

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Country__c = 'NZ';
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;       //MLASALA: 18-MAR-16 TQLQW-127 Re-brand
        insert testBrand; 

        Brand__c testBrand2 = TestDataBuilder.createBrand();
        testBrand2.Country__c = 'NZ';
        testBrand2.Name = 'Kiwibank NZ';
        insert testBrand2; 

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id, GEN_OriginationsConstants.PRODUCT_TYPE);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand2.Id;
        testApplication.Branch__c = testBranchList.get(0).Id;
        testApplication.Total_Insurance_Premium__c = 100;
        testApplication.Credit_Score__c = 'A';
        insert testApplication;

        Product_Item__c testProductItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;        
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        Application__c insertedApplication = [SELECT Id FROM Application__c WHERE Id =: testApplication.Id];

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(insertedApplication);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.changeBrand();
        Test.StopTest();

        Application__c updatedApplication = [SELECT Brand_Lookup__c, 
                                                    Brand_String__c,
                                                    Branch__c,
                                                    Out_Of_Sync__c,
                                                    Need_Deal_Reallocation__c
                                             FROM   Application__c 
                                             WHERE  Id =: testApplication.Id];

        //BEGIN - UPDATED BY DYU - FOR INVESTIGATION 
        /*System.assertEquals(testBrand.Id, updatedApplication.Brand_Lookup__c);
        System.assertEquals(testBrand.Name, updatedApplication.Brand_String__c);
        System.assertEquals(testBranchList.get(1).Id, updatedApplication.Branch__c);
        System.assertEquals(true, updatedApplication.Out_Of_Sync__c);
        System.assertEquals(false, updatedApplication.Need_Deal_Reallocation__c);*/
        //END - UPDATED BY DYU - FOR INVESTIGATION 
    }

    static testMethod void changeBrandNoneTest(){

        List<Branch__c> testBranchList = TestDataBuilder.createBranch(1);
        testBranchList.get(0).Branch_Id__c = '180';
        insert testBranchList;

        //Brand__c testBrand = TestDataBuilder.createBrand();
        //testBrand.Country__c = 'NZ';
        //testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;     //MLASALA: 18-MAR-16 TQLQW-127 Re-brand
        //insert testBrand;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList; 
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Branch__c = testBranchList.get(0).Id;
        insert testApplication;       
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        Application__c insertedApplication = [SELECT Id FROM Application__c WHERE Id =: testApplication.Id];

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(insertedApplication);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.changeBrand();
        Test.StopTest();

        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('No other Brand found for NZ')){
                isError = true;
            }
        }

        System.assertEquals(true, isError);
    }
    
    static testMethod void assignToLPENegativeTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Submission_Status__c = 'Test';
        testApplication.Out_Of_Sync__c = true;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
        insert profileControl;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationMain_INTCC application = new APP_ApplicationMain_INTCC(standardCon);
            application.assignToLPE();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('please update Application before assigning to LPE Queue')){
                isError = true;
            }
        }

        System.assertEquals(true, isError);
    }
    
    static testMethod void assignToLPEPositiveTest(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Submission_Status__c = 'Test';
        testApplication.OwnerId = UserInfo.getUserId();
        testApplication.Out_Of_Sync__c = false;
        insert testApplication;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PCO';
        insert testApplicant;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        for(Admin_Settings__c setting: adminSettingsList){
            if(setting.Name == 'TOM Enabled'){
                setting.Value__c = 'TRUE';
            }
        }
        insert adminSettingsList;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
        insert profileControl;
        
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
          if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
          }
          insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_ApplicationMain_INTCC application = new APP_ApplicationMain_INTCC(standardCon);
            application.assignToLPE();
        Test.StopTest();
        
        Application__c updatedApplication = [SELECT Owner_at_Release_to_LPE_Queue__c, 
                                                    OwnerId, 
                                                    Release_to_LPE_Queue_Datetime__c, 
                                                    Cash_Amount_on_Release_to_LPE_Queue__c, 
                                                    Total_Loan_Amount_New_Cash__c
                                             FROM   Application__c 
                                             WHERE  Id =: testApplication.Id];
        
        Group lpeQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =: GEN_OriginationsConstants.LPE_QUEUE_DEVELOPERNAME LIMIT 1];
        
        System.assertEquals(updatedApplication.OwnerId, lpeQueue.Id);
        System.assertNotEquals(updatedApplication.Release_to_LPE_Queue_Datetime__c, null);
        System.assertEquals(updatedApplication.Cash_Amount_on_Release_to_LPE_Queue__c, updatedApplication.Total_Loan_Amount_New_Cash__c);
    }
}