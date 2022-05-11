@isTest
private class APP_AMLEXT_Test {

    @isTest static void amlNoRecordsConstructorTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        ////ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant2.Id);          
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant2.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant2.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(null, aml.poa);
    }
    
    @isTest static void amlNoRecordsConstructorTestNZ() {
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

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        ////ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
            
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
    }
    
    @isTest static void poaNoRecordsConstructorTestNZ() {
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

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Has_AML__c = true;
        testApplicant.Verification_Method__c = 'Proof of Address';
        insert testApplicant;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void amlWithOneRecordConstructorTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
        insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(amlList.size(), aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
    }
    
    @isTest static void amlWithTwoRecordsConstructorTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
        insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(amlList.size(), aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
    }
    
    @isTest static void amlWithThreeRecordsConstructorTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 3, 'Utility Bill'));
        insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(amlList.size(), aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
    }
    
    @isTest static void amlPoaRecordsConstructorTestNZ() {
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

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Has_AML__c = true; 
        testApplicant.Verification_Method__c = 'Manual AML';
        insert testApplicant;
        
        List<AML__c> amlList = new List<AML__c>();
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
        
        AML__c poa = new AML__c(Applicant__c = testApplicant.Id);
        poa.POA_Type__c = 'Electronic POV'; 
        amlList.add(poa);
        insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(1, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(poa.Id, aml.poa.aml.Id);
    }
    
    @isTest static void amlOneRecordTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
                
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.isAml2Exposed = false;
	        aml.aml1.aml.AML_Pos_Verified_Type__c = null; 
	        aml.saveAML();
	        aml.aml1.aml.ID_1__c = 'Driving Licence';
	        aml.saveAML();
	        aml.aml1.aml.ID_No__c = 'ERR1';
	        aml.saveAML();
	        aml.aml1.aml.ID_No__c = '1234';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1; 
	        aml.aml1.aml.ID_Expiry_State__c = 'State';
	        aml.aml1.aml.Issue_Country__c  = 'Country';
	        aml.saveAML();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        //System.assertEquals(1, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(null, aml.poa);
    }
    
    @isTest static void amlTwoRecordTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
                
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.isAml2Exposed = true;
	        aml.aml1.aml.AML_Pos_Verified_Type__c = 'In Branch';
	        aml.aml1.aml.ID_1__c = 'Driving Licence';
	        aml.aml1.aml.ID_No__c = '1234';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1; 
	        aml.aml1.aml.ID_Expiry_State__c = 'State';
	        aml.aml1.aml.Issue_Country__c  = 'Country';
	        aml.saveAML();
	        aml.aml2.aml.ID_2__c = '';
	        aml.saveAML();
	        aml.aml2.aml.ID_2__c = 'Centrelink Statement';
	        aml.saveAML();
	        aml.aml2.aml.ID_Issue_Date__c = Date.today()-1; 
	        aml.aml2.aml.ID_Issuer__c = 'Issuer';
	        aml.saveAML();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(2, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(null, aml.poa);
    }
    
    @isTest static void amlThreeRecordTestAU() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
                
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.isAml2Exposed = true;
	        aml.aml1.aml.AML_Pos_Verified_Type__c = 'In Branch';
	        aml.aml1.aml.ID_1__c = 'Birth Certificate';
	        aml.aml1.aml.ID_Issue_Date__c = Date.today()+1; 
	        aml.aml1.aml.ID_Issuer__c = 'Issuer';
	        aml.aml2.aml.ID_2__c = 'Centrelink Statement';
	        aml.aml2.aml.ID_Issue_Date__c = Date.today()+1; 
	        aml.aml2.aml.ID_Issuer__c = 'Issuer';
	        aml.saveAML();
	        aml.saveAML();
	        aml.aml3.aml.ID_3__c = 'Overseas Passport';
	        aml.saveAML();
	        aml.aml3.aml.ID_No__c = 'ERR1';
	        aml.aml3.aml.ID_Expiry_Date__c = Date.today()+1;
	        aml.aml3.aml.Issue_Country__c = 'Australia'; 
	        aml.saveAML();
	        aml.aml1.aml.ID_Issue_Date__c = Date.today()-1;
	        aml.aml2.aml.ID_Issue_Date__c = Date.today()-1;
	        aml.aml3.aml.ID_No__c = '1234';
	        aml.aml3.aml.Issue_Country__c = 'Country';
	        aml.saveAML();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(3, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(null, aml.poa);
    }
    
    @isTest static void driversLicenseTestNZ() {
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
	        aml.aml1.aml.ID_1__c = 'NZ Driver Licence';
            aml.poa.aml.POA_Issue_Date__c = Date.today()+1;
            aml.poa.aml.ID_No__c = null;
	        aml.poa.aml.ID_Expiry_Date__c = null;
	        aml.saveAML();
	        aml.aml1.aml.Version__c = '1234';
	        aml.aml1.aml.ID_No__c = '1!';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()-1;
	        aml.aml1.aml.Issue_Country__c = 'qwertyuiopqwertyuiopqwertyuiopqw';
	        aml.saveAML();
	        aml.aml1.aml.Version__c = '12!';
	        aml.aml1.aml.ID_No__c = '123456789';
	        aml.aml1.aml.Issue_Country__c = 'test!';
	        aml.saveAML();
	        aml.aml1.aml.ID_No__c = '12345678';
	        aml.saveAML();
	        aml.aml1.aml.Version__c = '12';
	        aml.aml1.aml.ID_No__c = 'ab123456';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1;
	        aml.aml1.aml.Issue_Country__c = 'Country';
	        aml.poa.aml.POA_Type__c = 'Electronic POV';
	        aml.poa.aml.POA_Reference_Number__c = '1234';
	        aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
	        aml.poa.aml.ID_Issuer__c = 'Test';
	        aml.saveAML();
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
    
    @isTest static void overseasPassportTestNZ() {
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
	        aml.aml1.aml.ID_1__c = 'Overseas Passport';
	        aml.poa.aml.POA_Type__c = 'Electronic POV';
	        aml.poa.aml.POA_Reference_Number__c = '1234';
	        aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
	        aml.poa.aml.ID_Issuer__c = 'Test';
            aml.poa.aml.Issue_Country__c = null;
	        aml.saveAML();
	        aml.aml1.aml.NZ_Residency_Number__c = '12345678901';
	        aml.aml1.aml.ID_No__c = '1!';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()-1;
	        aml.aml1.aml.Issue_Country__c = 'New Zealand';
	        aml.saveAML();
	        aml.aml1.aml.NZ_Residency_Number__c = '123456789!';
	        aml.aml1.aml.ID_No__c = '123456789';
	        aml.saveAML();
	        aml.aml1.aml.NZ_Residency_Number__c = '123456789';
	        aml.saveAML();
	        aml.aml1.aml.Version__c = '12';
	        aml.aml1.aml.ID_No__c = 'ab123456';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1;
	        aml.aml1.aml.Issue_Country__c = 'Country';
	        aml.saveAML();
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

    @isTest static void verifyAMLNegativeTest() {
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
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.verifyAML();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('AML is already satisfied')){
                isError = true;
            }
        }
        System.assert(isError);
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void cancelTest() {
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
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        //ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
            Test.setCurrentPageReference(Page.APP_AML);
            System.currentPageReference().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.cancel();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(0, aml.amlOld.size());
        System.assertEquals(0, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void deleteRecordsTest() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = true;
        testApplicant2.Has_AML__c = true; 
        insert testApplicant2;
        
        List<AML__c> amlList = new List<AML__c>();
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant2.Id, 1, 'Learning Permit'));
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant2.Id, 2, 'Driving Licence'));
        amlList.add(TestDataBuilder.createAMLRecords(testApplicant2.Id, 3, 'Utility Bill'));
        insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        ApexPages.currentPage().getParameters().put('aid', testApplicant2.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.isAml2Exposed = false;
	        aml.aml1.aml.ID_1__c = 'Centrelink Statement';
	        aml.aml1.aml.ID_Issue_Date__c = Date.today()-1;
	        aml.aml1.aml.ID_Issuer__c  = 'Issuer';
	        aml.aml2.aml = amlList.get(1);
	        aml.aml3.aml = amlList.get(2);
	        aml.saveAML();
        Test.StopTest();
        
        System.assertEquals(testApplicant2.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant2.Id, aml.appId);
        System.assertEquals('Australia', aml.country);
        System.assertEquals(amlList.size(), aml.amlOld.size());
        System.assertEquals(1, aml.upsertAML.size());
        System.assertEquals(2, aml.deleteAML.size());
        System.assert(!aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertEquals(null, aml.poa);
    }
    
    @isTest static void poaDeleteAmlTestNZ() {
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
        
        //List<AML__c> amlList = new List<AML__c>();
        //amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
        //amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
        //amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 3, 'Utility Bill'));
        //insert amlList;
        
        Test.StartTest();
	        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
	        ApexPages.currentPage().getParameters().put('aid', testApplicant.Id);
	        APP_AMLEXT aml = new APP_AMLEXT(standardCon);
	        aml.isAml2Exposed = false;      
            aml.aml1.aml.AML_Pos_Verified_Type__c = 'In Branch';
            aml.aml1.aml.ID_1__c = 'NZ Certificate of Citizenship';
            aml.aml1.aml.Version__c = '12';
            aml.aml1.aml.ID_No__c = 'ab123456';
            aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1;
            aml.aml1.aml.Issue_Country__c = 'Country';
            aml.aml2.aml.ID_2__c = 'SuperGold card with Photo';
            aml.aml2.aml.Version__c = '12';
            aml.aml2.aml.ID_No__c = 'ab123456';
            aml.aml2.aml.ID_Expiry_Date__c = Date.today()+1;
            aml.aml2.aml.Issue_Country__c = 'Country';      
	        aml.saveAML();
	        aml.applicnt.Verification_Method__c  = 'Proof of Address';
	        aml.isPOA();
	        aml.poa.aml.POA_Type__c = 'Electronic POV';
	        aml.poa.aml.POA_Reference_Number__c = '1234';
	        aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
	        aml.poa.aml.ID_Issuer__c = 'Test';
	        //aml.aml1.aml = amlList.get(0);
	        //aml.aml2.aml = amlList.get(1);
	        //aml.aml3.aml = amlList.get(2);
            
	        aml.saveAML();
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        //System.assertEquals(amlList.size(), aml.amlOld.size());
        System.assertEquals(2, aml.upsertAML.size());
        //System.assertEquals(amlList.size(), aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }
    
    @isTest static void birhtCertificateTestNZ() {
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
	        aml.applicnt.Verification_Method__c  = 'Manual AML';
	        aml.isPOA();
            //aml.verificationMethod = 'In Branch';
	        aml.aml1.aml.AML_Pos_Verified_Type__c = 'In Branch';
	        aml.aml1.aml.ID_1__c = 'NZ Certificate of Citizenship';
	        aml.aml1.aml.Version__c = '12';
	        aml.aml1.aml.ID_No__c = 'ab123456';
	        aml.aml1.aml.ID_Expiry_Date__c = Date.today()+1;
	        aml.aml1.aml.Issue_Country__c = 'Country';
	        aml.aml2.aml.ID_2__c = 'SuperGold card with Photo';
	        aml.aml2.aml.Version__c = '12';
	        aml.aml2.aml.ID_No__c = 'ab123456';
	        aml.aml2.aml.ID_Expiry_Date__c = Date.today()+1;
	        aml.aml2.aml.Issue_Country__c = 'Country';
	        aml.poa.aml.POA_Type__c = 'Electronic POV';
	        aml.poa.aml.POA_Reference_Number__c = '1234';
	        aml.poa.aml.POA_Issue_Date__c = Date.today()-1;
	        aml.poa.aml.ID_Issuer__c = 'Test';
	        aml.saveAML();	
        Test.StopTest();
        
        System.assertEquals(testApplicant.Id, aml.applicnt.Id);
        System.assertEquals(testApplicant.Id, aml.appId);
        System.assertEquals('New Zealand', aml.country);
        System.assertEquals(1, aml.amlOld.size());
        //System.assertEquals(4, aml.upsertAML.size());
        System.assertEquals(3, aml.upsertAML.size());
        System.assertEquals(0, aml.deleteAML.size());
        System.assert(aml.isNZ);
        System.assert(!aml.poaOnly);
        System.assertNotEquals(null, aml.poa);
    }

    @isTest static void idenNullValidatePreSubmitAML_Test() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = null;

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();  

        System.assert(result == false); 
            
    }

    @isTest static void driversLicenseValidatePreSubmitAML_TestVersionNull() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'NZ Driver Licence';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest(); 

        System.assert(result == false);   
            
    }

    @isTest static void driversLicenseValidatePreSubmitAML_TestVersionGreaterThanThree() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'NZ Driver Licence';
        testPreAML.Version__c = '124567';
        //insert testPreAML;

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();   

        System.assert(result == false); 
            
    }

    @isTest static void driversLicenseValidatePreSubmitAML_TestVersionInvalid() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'NZ Driver Licence';
        testPreAML.Version__c = '1;2';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();   

        System.assert(result == false); 
            
    }

    @isTest static void australiaPassportValidatePreSubmitAML_Test() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'Australia/Cook Islands/Tokelau/Niue Passport';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();  
            
    }

    @isTest static void overseasPassportValidatePreSubmitAML_TestResidencyNumNull() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'Overseas Passport';
        testPreAML.NZ_Residency_Number__c = null;
        testPreAML.Issue_Country__c = null;

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();   

        System.assert(result == false); 
    }

    @isTest static void overseasPassportValidatePreSubmitAML_TestResidencyNumGreaterThanMax() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'Overseas Passport';
        testPreAML.NZ_Residency_Number__c = '1a2b3c4d5f6e';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();  

        System.assert(result == false);  
    }

    @isTest static void overseasPassportValidatePreSubmitAML_TestResidencyNumInvalid() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'Overseas Passport';
        testPreAML.NZ_Residency_Number__c = '1*-$b%&^f?';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(true, testPreAML, pdw);
        Test.StopTest();   

        System.assert(result == false); 
    }

    @isTest static void certifiedDocsReqValidatePreSubmitAML_Test() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
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

        AML__c testPreAML = TestDatabuilder.createAMLRecords(testApplicant.Id, 0, 'NZ Passport');
        testPreAML.Identification__c = 'Other - Certified Documents required';

        personalDetailsWrapper pdw = new personalDetailsWrapper();
        pdw.applicant = testApplicant;
        pdw.applicationCountry = 'NZ';
                
        Test.StartTest();
            MyBudgetsAMLWrapper mbaw = new MyBudgetsAMLWrapper(testPreAML);
            Boolean result = mbaw.validatePreSubmitAML(false, testPreAML, pdw);
        Test.StopTest();   
    }
}