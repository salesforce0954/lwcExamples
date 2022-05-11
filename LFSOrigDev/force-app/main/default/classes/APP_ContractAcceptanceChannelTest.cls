/*
Author: Russell Cadapan Cloud Sherpas
Created Date: 03/18/2014
Description: Test Class for APP_ContractAcceptanceChannel
*/
@isTest
public with sharing class APP_ContractAcceptanceChannelTest {
    
    static testMethod void getTextDisplayedSingle_Test(){
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        insert testApplication;
        
        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
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

        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.Contract_Account_Number__c = '123123123123';
        insert appResponse;
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        insert testDocument;
        
        String testTextDisplay = 'The Customer has been given a copy of the';
        
        
        
        
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',testapplication.Id);
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.isInsuranceAcknowledgement();
        contract.isTimeOutAccountCreation();
        contract.refreshPage();
        String textDisplayed = contract.getTextDisplayed();
        Test.StopTest();
        
        System.assertEquals(testTextDisplay,textDisplayed);
    }
    static testMethod void getTextDisplayedJoint_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        insert testDocument;
        
        String testTextDisplay = 'The Customers have been given a copy of the';
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        String textDisplayed = contract.getTextDisplayed();
        Test.StopTest();
        
        System.assertEquals(testTextDisplay,textDisplayed);
    }
    static testMethod void getApplicationInsurance_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Name = 'Disability Insurance';
        testProduct.Type__c = 'Insurance';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        insert testDocument;
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',testapplication.Id);
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.getApplicationInsurance();
        Test.StopTest();
    }
    static testMethod void getIsRefresh_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.getIsRefresh();
        Test.StopTest();
        
        System.assertEquals(false, contract.getIsRefresh());
    }
    static testMethod void getWrapperContract_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        testDocument.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_TERMS_AND_CONDITIONS;
        insert testDocument;
        
        Related_Document__c testDocument2 = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument2.isAccepted__c = false;
        testDocument2.Section__c = 'Privacy';
        testDocument2.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument2.Status__c = 'Sent';
        testDocument2.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_CREDIT_GUIDE;
        insert testDocument2;
        
        Related_Document__c testDocument3 = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument3.isAccepted__c = false;
        testDocument3.Section__c = 'Privacy';
        testDocument3.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument3.Status__c = 'Sent';
        testDocument3.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_COMPLAINTS_BROCHURE;
        insert testDocument3;
        
        Related_Document__c testDocument4 = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument4.isAccepted__c = false;
        testDocument4.Section__c = 'Privacy';
        testDocument4.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument4.Status__c = 'Sent';
        testDocument4.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_LPI_BROCHURE;
        insert testDocument4;
        
        Related_Document__c testDocument5 = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument5.isAccepted__c = false;
        testDocument5.Section__c = 'Privacy';
        testDocument5.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument5.Status__c = 'Sent';
        testDocument5.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_EIDV_CONSENT;
        insert testDocument5;
        
        Attachment testAttachment = TestDataBuilder.createAttachment(testDocument.Id);
        insert testAttachment;
        
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.getWrapperContract();
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, testDocument.Application__c);
        System.assertEquals(testDocument.Id, testAttachment.ParentId);
    }
    static testMethod void RCProfileAccess_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'New');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        
        
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.getRCCreateAccess('New');
        contract.getProfileAccess(UserInfo.getProfileId());
        Test.StopTest();
        
        System.assertEquals(true, contract.getRCCreateAccess('New'));
        System.assertEquals(true, contract.getProfileAccess(UserInfo.getProfileId()));
    }
    static testMethod void getLatestContractAccessStatus_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.getLatestContractAccessStatus();
        Test.StopTest();
        
        System.assert(contract.getLatestContractAccessStatus());
    }
    static testMethod void validateRD_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = true;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.getName();
        contract.validateRD();
        Test.StopTest();
        
        System.assertEquals(null, contract.validateRD());
        
    }
    
    static testMethod void redirectToCompletePage_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        System.debug('***TC::'+testApplication.Id);
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = true;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.redirectToCompletePage();
        Test.StopTest();
        
        PageReference pRef = new PageReference('/apex/app_complete?Id='+testApplication.Id);
        System.assertEquals(pRef.getUrl(),contract.redirectToCompletePage().getUrl());
    }
    static testMethod void validateAppAndRD_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = false;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.validateAppAndRD();
        Test.StopTest();
        
        System.assertEquals(null, contract.validateAppAndRD());
    }
    static testMethod void retryRelatedDocument_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = true;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel contract = new APP_ContractAcceptanceChannel();
        contract.applicationId = testApplication.Id;
        contract.retryRelatedDocument();
        contract.validationErrors = new List<IS_ValidationError>();
        contract.docGenFailed = false;
        contract.fireDocGenServiceCallRetry();
        contract.docGenFailed = true;
        contract.fireDocGenServiceCallRetry();
        Test.StopTest();
    }
    static testMethod void updateRelatedDocument_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = true;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        
        Test.StartTest();
        APP_ContractAcceptanceChannel.updateRelatedDocument(testDocument.Id, true);
        Test.StopTest();
        
        Related_Document__c testDoc = [SELECT isAccepted__c FROM Related_Document__c where Id =: testDocument.Id LIMIT 1];
        System.assertEquals(true, testDoc.isAccepted__c);
    }
    static testMethod void updateRelatedDocument2_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Application_Type__c = 'Joint';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
      
        Applicant__c applicant1 = TestDataBuilder.createApplicant(null, testApplication.Id);
        applicant1.Is_Primary_Applicant__c = true;
        applicant1.Email_Address__c = UserInfo.getUserEmail();
        insert applicant1;
        
        
        
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        insert responseCodeControl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        System.assert(testProfileControl.Create_Account__c);
        
        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(null, testApplication.Id);
        testDocument.isAccepted__c = true;
        testDocument.Section__c = 'Privacy';
        testDocument.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        testDocument.Status__c = 'Sent';
        insert testDocument;
        
        
        PageReference tpageRef = Page.APP_ContractAcceptance;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id',testApplication.Id);
        
        PushTopic pt=new PushTopic();
        pt.name='testing';
        pt.query='SELECT Id, Contract_Account_Number__c, Application__c FROM Application_Response__c';
        pt.NotifyForFields='Referenced';
        pt.ApiVersion = 29.0;
        insert pt;
        
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',testapplication.Id);
        

         
        APP_ContractAcceptanceChannel.updateApplication(testApplication.Id, true);
        APP_ContractAcceptanceChannel.updateRelatedDocument1(testDocument.Id, false,'isAcceptedSec');
        APP_ContractAcceptanceChannel.updateRelatedDocument1(testDocument.Id, true,'isAccepted');
        //APP_ContractAcceptanceChannel.checkPushTopic();
        //APP_ContractAcceptanceChannel.acceptContract();
        APP_ContractAcceptanceChannel newCntr=new APP_ContractAcceptanceChannel();
        newCntr.isPrimary = true;
        newCntr.checkPushTopic();
        newCntr.acceptContract();
        newCntr.secCheckRD();
                                     
        newCntr.isPrimary = true;
        APP_ContractAcceptanceChannel.updateRelatedDocument(testDocument.Id, false);
        APP_ContractAcceptanceChannel.updateRelatedDocument(testDocument.Id, true);
        
       
       // System.debug('***testDocument.Id:'+testDocument.Id);
      //  newCntr.isEnabledId = testDocument.Id;
         
        newCntr.enableCheckbox();
        newCntr.enableInsuranceCheckBox();
        newCntr.redirectToCompletePage();
        newCntr.isPrimary =  false;
        
          APP_ContractAcceptanceChannel.updateRelatedDocument(testDocument.Id, false);
        APP_ContractAcceptanceChannel.updateRelatedDocument(testDocument.Id, true);
        newCntr.enableInsuranceCheckBox();
        newCntr.enableCheckbox();
        
        newCntr.appList[0].Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA;
        
        newCntr.retryRelatedDocument();
        newCntr.validationErrors = new List<IS_ValidationError>();
        newCntr.docGenFailed = false;
        newCntr.fireDocGenServiceCallRetry();
        newCntr.docGenFailed = true;
        newCntr.fireDocGenServiceCallRetry();
        Test.StopTest();
        
        
        Related_Document__c testDoc = [SELECT isAccepted__c FROM Related_Document__c where Id =: testDocument.Id LIMIT 1];
        Application__c app = [SELECT Insurance_Acknowledgement__c FROM Application__c where Id =: testapplication.Id LIMIT 1];
        
        System.assertEquals(true, app.Insurance_Acknowledgement__c);
        
    }
}