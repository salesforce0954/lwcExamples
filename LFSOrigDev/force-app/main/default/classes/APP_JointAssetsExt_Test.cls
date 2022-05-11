@isTest
private class APP_JointAssetsExt_Test {
   static testMethod void testAssestMethods(){  
   List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'FIA Pending';
        insert testApplication;
        
        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Asset_Exempt__c = true;
        insert testApplicant;
        
        System.assertEquals(true,testApplicant.Asset_Exempt__c);

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
     APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon );
     asset.assetValidationResults = true;
     asset.isBetterStart = false;
     asset.totalassets = 100;
     System.assertEquals(asset.totalassets,100);
     System.assertEquals(asset.assetValidationResults,true);
     //MyBudgetsAssetWrapper mbawr = new MyBudgetsAssetWrapper(testApplicant);
     
     try{
     
     Asset__c assettt = new Asset__c();
     List<MyBudgetsAssetWrapper> assetAddList = new List<MyBudgetsAssetWrapper>();
    MyBudgetsAssetWrapper mbawlist = new MyBudgetsAssetWrapper(assettt);
    mbawlist.asset.Asset_Category__c = 'House';
    mbawlist.asset.Asset_Value__c = 100;
    System.assertEquals(100,mbawlist.asset.Asset_Value__c);
    assetAddList.add(mbawlist);
    Integer size = assetAddList.size();
        System.assertEquals(1,size);
        }catch(Exception e){
        }
        try{
        
        Asset__c assett = [select id from Asset__c limit 1];
//        insert assett;
//        assett.id = null;
//        test.startTest();
//        update assett;
//        test.stopTest();
         assett.id = null;
         insert assett;

        System.assertEquals(null,assett.id);
        MyBudgetsAssetWrapper bsw = new MyBudgetsAssetWrapper(assett);
        bsw.asset.Asset_Shared__c = false;
        System.assertEquals(false,bsw.asset.Asset_Shared__c);
        System.AssertNotEquals(Null, bsw.asset.Id);
        //System.debug('Result'+bsw.asset.id);
        //System.assertEquals(null,bsw.asset.id);
        
        }catch(Exception e){
        }
       
        List<Asset__c> assetListToDel = new List<Asset__c>();  
        Asset__c insertAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insertAsset.Asset_Category__c = 'car';
        insertAsset.Asset_Shared__c = true;
        insertAsset.Asset_Value__c = 13245;
        insertAsset.Ownership_Status__c = 'Own outright';
        insertAsset.Total_Assets__c = 2;
        insertAsset.of_ownership_of_the_asset__c=10;
        insert insertAsset;
        
        
        
       
       
        asset.getTimeOut();
        asset.getWarning();
        asset.addAsset();
        try{
        asset.removethisAsset();
        
        }catch(Exception e){
        }     
        
        asset.removeAllAssets();   
        asset.refreshCount();
        asset.getTotalAsset();
        asset.validateFields();
        asset.pageRedirect();
        asset.getbankAccountHeldOptions();
        asset.register();
        asset.logout();
        
        /*MyBudgetsAssetWrapper mbaw = new MyBudgetsAssetWrapper(testApplicant);
        
        mbaw.setTotalAsset(100.99);
        mbaw.clearAssetFields();
        mbaw.validateAsset();
        
        List<MyBudgetsAssetWrapper> assetAddList = new List<MyBudgetsAssetWrapper>();
        assetAddList.add(mbaw);
        
        MyBudgetsAssetWrapper mbsw = new MyBudgetsAssetWrapper(insertAsset);
        mbsw.setTotalAsset(100.99);
        mbsw.clearAssetFields();
        mbsw.validateAsset();
        
        assetAddList.add(mbsw);
        
        for(MyBudgetsAssetWrapper test:assetAddList){
         test.asset.Asset_Shared__c = true;
         System.assertEquals(test.asset.Asset_Shared__c ,true);
        }*/
        
        
//        Asset__c testAsset1 = TestDataBuilder.createAsset(testApplicant.Id);
//        insert testAsset;
        
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

       
        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;
        
        Asset__c testAsset2 = TestDataBuilder.createAsset(testApplicant2.Id);
        insert testAsset2;
        
        //List<Expense__c> elist = [SELECT Applicant__c FROM Expense__c];
        
        //Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

             ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
     APP_JointAssetsExt aset = new APP_JointAssetsExt(standardCon );
            aset.redirectTo ='Save';
            aset.validateLoanFields();
            aset.pageRedirect();
        Test.StopTest();
       // System.assertEquals(testAsset.Id, aset.assetAddList.asset.Id);
       // System.assertEquals(testAsset2.Id, aset.assetAddList.asset.Id);
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

         Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

         Asset__c testAsset2 = TestDataBuilder.createAsset(testApplicant2.Id);
        insert testAsset2;

        //Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset= new APP_JointAssetsExt(standardCon);
            asset.redirectTo ='Save';
            asset.validateLoanFields();
            asset.pageRedirect();
        Test.StopTest();
        
        //System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
        //System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
    }
    static testMethod void saveRecordNotRenting_Test(){
        //Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Bank_Accounts_Held__c ='Cheque and one credit card';
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

         Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

         Asset__c testAsset2 = TestDataBuilder.createAsset(testApplicant2.Id);
        insert testAsset2;

        //Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset= new APP_JointAssetsExt(standardCon);
            asset.redirectTo ='Save';
           //asset.pageRedirect();
        Test.StopTest();
        //System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
        //System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
        System.assertEquals('Save', asset.redirectTo);
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

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        
        Asset__c insertAsset = new Asset__c();
        insertAsset.Applicant__c = testApplicant.Id;
        insertAsset.Asset_Shared__c = true;
        insertAsset.Asset_Value__c = 100;
        insertAsset.of_Ownership_of_the_asset__c = 100;
        insertAsset.Total_Assets__c =  100;
        insert insertAsset;
        
        System.assertEquals(insertAsset.Asset_Shared__c,true);
        System.assertEquals(insertAsset.Asset_Value__c,100);
        System.assertEquals(insertAsset.of_Ownership_of_the_asset__c,100);
        System.assertEquals(insertAsset.Total_Assets__c,100);

        Asset__c testAsset2 = TestDataBuilder.createAsset(testApplicant2.Id);
        insert testAsset2;

       // Test.setCurrentPage(Page.App_JointExpenses);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;  

            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            List<MyBudgetsAssetWrapper> assetAddList = new List<MyBudgetsAssetWrapper>();
            asset.removeAllAssets();
            System.assertEquals(assetAddList.size(),0);    
            asset.redirectTo ='Timeout';
            asset.pageRedirect();
        Test.StopTest();
        //System.assertEquals(testExpense.Id, exp.expenseWrapper.expense.Id);
        //System.assertEquals(testExpense2.Id, exp.expense2Wrapper.expense.Id);
        System.assertEquals('Timeout', asset.redirectTo);
     
             
    }
    // Test 1 functions
     static testMethod void constructorWithNoExistingRecords_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

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
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.register();
            asset.logout();
            asset.getTimeOut();
            asset.getWarning();
            
        Test.StopTest();

        System.assertEquals(1, asset.assetListSize);
        System.assertEquals(testApplication.Id, asset.application.Id);
    }
    static testMethod void constructorWithExistingRecords_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Asset__c testAsset = TestDataBuilder.createasset(testApplicant.Id);
        insert testAsset;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.selectedRow = 0;
            asset.removethisAsset();
            asset.getTotalAsset();
        Test.StopTest();

        System.assertEquals(1, asset.assetListSize);
        System.assertEquals(testApplication.Id, asset.application.Id);
    }
    static testMethod void saveAssetSuccess_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Asset__c testAsset = TestDataBuilder.createasset(testApplicant.Id);
        insert testAsset;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        PageReference testAppMain = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        Test.setCurrentPage(Page.APP_JointAssets);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.redirectTo = 'Save';
            asset.validateLoanFields();
            PageReference pageRedirect = asset.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, asset.application.Id);
        //System.assertEquals(testAppMain.getUrl(), pageRedirect.getUrl());
    }
    static testMethod void saveNewAssetSuccess_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;


        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Asset__c testAsset = TestDataBuilder.createasset(testApplicant.Id);
        insert testAsset;

        Asset__c testAssetCar = TestDataBuilder.createAsset(testApplicant.Id);
        testAssetCar.Asset_Category__c = GEN_OriginationsConstants.ASSET_CATEGORY_CAR;
        testAssetCar.Ownership_Status__c = GEN_OriginationsConstants.ASSET_OWNERSHIP_OWE;
        testAssetCar.Asset_Value__c = 1000;


        Asset__c testAssetHouse = TestDataBuilder.createAsset(testApplicant.Id);
        testAssetCar.Asset_Category__c = GEN_OriginationsConstants.ASSET_CATEGORY_HOUSE;
        testAssetCar.Ownership_Status__c = GEN_OriginationsConstants.ASSET_OWNERSHIP_OWE;
        testAssetCar.Asset_Value__c = 1000;

        PageReference testAppMain = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        Test.setCurrentPage(Page.APP_JointAssets);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.redirectTo = 'Save';
            MyBudgetsAssetWrapper mbawCar = new MyBudgetsAssetWrapper(testApplicant);
            mbawCar.asset = testAssetCar;

            MyBudgetsAssetWrapper mbawHouse = new MyBudgetsAssetWrapper(testApplicant);
            mbawHouse.asset = testAssetHouse;

            asset.assetAddList.add(mbawCar);
            asset.assetAddList.add(mbawHouse);
            asset.validateLoanFields();
            PageReference pageRedirect = asset.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, asset.application.Id);
        //System.assertEquals(testAppMain.getUrl(), pageRedirect.getUrl());
    }
    static testMethod void saveNewAssetHouseFailure_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;


        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Asset__c testAssetCar = TestDataBuilder.createAsset(testApplicant.Id);
            testAssetCar.Asset_Category__c = null;
            testAssetCar.Ownership_Status__c = null;
            testAssetCar.Asset_Value__c = null;
        insert testAssetCar;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.redirectTo = 'Save';
            asset.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, asset.application.Id);
        System.assertEquals(null, asset.pageRedirect());
    }
    static testMethod void saveNewAssetCarFailure_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id, onrRecordTypeId);
            testONR.Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Asset__c testAssetCar = TestDataBuilder.createAsset(testApplicant.Id);
            testAssetCar.Asset_Category__c = null;
            testAssetCar.Ownership_Status__c = null;
            testAssetCar.Asset_Value__c = null;
        insert testAssetCar;

        Asset__c testAssetCar2 = TestDataBuilder.createAsset(testApplicant.Id);
        testAssetCar2.Asset_Category__c = GEN_OriginationsConstants.ASSET_CATEGORY_CAR;
        testAssetCar2.Vehicle_make__c = null;
        testAssetCar2.Vehicle_model__c = null;
        testAssetCar2.Vehicle_year__c = null;
        testAssetCar2.Asset_Value__c = 1000;
        testAssetCar2.Asset_Shared__c = false;
        insert testAssetCar2;


        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.redirectTo = 'Save';
            asset.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, asset.application.Id);
        System.assertEquals(null, asset.pageRedirect());
    }
    static testMethod void timeOut_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        
        PageReference testPageRedirect = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.redirectTo = 'Timeout';
            asset.pageRedirect();
        Test.StopTest();

        System.assertEquals(testApplication.Id, asset.application.Id);
        //Mike TODO: sprint 10
        //System.assertEquals(testPageRedirect.getUrl(), asset.pageRedirect().getUrl());
    }
    static testMethod void removeAllAssets_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Asset_Exempt__c = true;
        insert testApplicant;

        Asset__c testAsset = TestDataBuilder.createasset(testApplicant.Id);
        insert testAsset;

        PageReference testAppMain = new PageReference('/apex/app_timeout?id=' + testApplication.Id);
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.applicant.Asset_Exempt__c = true;
            asset.removeAllAssets();
        Test.StopTest();
        //System.assertEquals(0, asset.assetAddList.size());
    }
    static testMethod void removeThisAsset_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Asset_Exempt__c = true;
        insert testApplicant;

        Asset__c testAsset = TestDataBuilder.createasset(testApplicant.Id);
        insert testAsset;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;        
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt asset = new APP_JointAssetsExt(standardCon);
            asset.selectedRow = 0;
            asset.removethisAsset();
        Test.StopTest();

        System.assertEquals(1, asset.assetAddList.size());
        System.assertEquals(null,asset.assetAddList[0].asset.Id);
        APP_JointAssetsExt.testcodeCov();
    }
    //End

}