/*
 * @Description: Test class for APP_GSD_ContractAcceptanceChannel Class
 * @Author: Adrian Recio
 * @Date Created: March-08-2016
 * @History:
   =====================================================================
       Adrian Recio      - Created
   =====================================================================
 */
@IsTest
public with sharing class APP_GSD_ContractAcceptanceChannelTest {
	public APP_GSD_ContractAcceptanceChannelTest() {
		
	}
    
    static testMethod void testCAMethods(){
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Acceptance_Channel__c = 'Online Acceptance';
        testApplication.Application_Type__c = 'Single';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        List<GEProduct__c> prodList = new List<GEProduct__c>();
        GEProduct__c testProduct1 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct1.name = GEN_OriginationsConstants.LIFE_INSURANCE;
        GEProduct__c testProduct2 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct2.name = GEN_OriginationsConstants.DISABILITY_INSURANCE;
        GEProduct__c testProduct3 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct3.name = GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE;
        prodList.add(testProduct1);
        prodList.add(testProduct2);
        prodList.add(testProduct3);
        insert prodList;
        
        List<Product_Version__c> pvList = new List<Product_Version__c>();
        Product_Version__c testProductVersion1 = TestDataBuilder.createProductVersion(testProduct1.Id);            
        Product_Version__c testProductVersion2 = TestDataBuilder.createProductVersion(testProduct2.Id);
        Product_Version__c testProductVersion3 = TestDataBuilder.createProductVersion(testProduct3.Id);
        pvList.add(testProductVersion1);
        pvList.add(testProductVersion2);
        pvList.add(testProductVersion3);
        insert pvList;
        
        List<Product_Item__c> piList = new List<Product_Item__c>();
        Product_Item__c testProductItem1 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion1.Id);
       	Product_Item__c testProductItem2 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion2.Id);
        Product_Item__c testProductItem3 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion3.Id);
		piList.add(testProductItem1);
        piList.add(testProductItem2);
        piList.add(testProductItem3);
        insert piList;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion1.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        
        // Create Test PCO Response Code
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'PCO';
        appResponse.Contract_Account_Number__c = '04444444444';
        insert appResponse;
        
        // Create Test Account
		Account testAcc = TestDataBuilder.createPersonAccount();
        insert testAcc;
        
        // Create Test Applicant
        List<Applicant__c>applicantList = new List<Applicant__c>();
        Applicant__c testApplicant = TestDataBuilder.createApplicant(testAcc.Id, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Email_Address__c = 'test@ge.com';
        applicantList.add(testApplicant);
        insert applicantList;
		
        
        // Create Test Related Documents from Doc Gen
        List<Related_Document__c> relDocList = new List<Related_Document__c>();
        
        String category = GEN_OriginationsConstants.LOAN_DOCUMENTS; // 'Loan Documents'
        String genLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED; // 'Generated Document'
        String staticLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC; // 'Static'
        String internalCategory = GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL; // 'Internal'
        String disclosureStatement = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT; // 'Disclosure Statement'
        
        Related_Document__c testDocument1 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument1.isAccepted__c = false;
        testDocument1.Document_Category__c = category;
        testDocument1.GE_Link_Type__c = staticLinkType;
        testDocument1.Section__c = DOC_GenerateDocumentsUtil.SECTION_INSURANCE;
        
        Related_Document__c testDocument2 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument2.isAccepted__c = false;
        testDocument2.Document_Category__c = internalCategory;
        testDocument2.GE_Link_Type__c = genLinkType;
        testDocument2.Section__c = DOC_GenerateDocumentsUtil.SECTION_CONTRACT;
        testDocument2.Type__c = disclosureStatement;
        testDocument2.GE_Document_ID__c = null;
        testDocument2.Status__c = 'Sent';
         
        Related_Document__c testDocument3 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument3.isAccepted__c = false;
        testDocument3.GE_Link_Type__c = staticLinkType;
        testDocument3.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_TERMS_AND_CONDITIONS;
        
        Related_Document__c testDocument4 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument4.isAccepted__c = false;
        testDocument4.GE_Link_Type__c = staticLinkType;
        testDocument4.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_CREDIT_GUIDE;
        
        Related_Document__c testDocument5 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument5.isAccepted__c = false;
        testDocument5.GE_Link_Type__c = staticLinkType;
        testDocument5.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_COMPLAINTS_BROCHURE;
        
		Related_Document__c testDocument6 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument6.isAccepted__c = false;
        testDocument6.GE_Link_Type__c = staticLinkType;
        testDocument6.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_LPI_BROCHURE;        
        
        Related_Document__c testDocument7 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument7.isAccepted__c = false;
        testDocument7.GE_Link_Type__c = staticLinkType;
        testDocument7.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_EIDV_CONSENT;  
        
        Related_Document__c testDocument8 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument8.isAccepted__c = false;
        testDocument8.GE_Link_Type__c = staticLinkType;
        testDocument8.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_RPI_POLICY; 
        
         // Not Receieved
        Related_Document__c testDocument9 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument9.isAccepted__c = false;
        testDocument9.GE_Link_Type__c = staticLinkType;
        testDocument9.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT; 
        testDocument9.Document_Category__c = internalCategory;
        
        
        relDocList.add(testDocument1);
        relDocList.add(testDocument2);
        relDocList.add(testDocument3);
        relDocList.add(testDocument4);
        relDocList.add(testDocument5);
        relDocList.add(testDocument6);
        relDocList.add(testDocument7);
        relDocList.add(testDocument8);
        relDocList.add(testDocument9);
        
        insert relDocList;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        responseCodeControl.Create_Account__c = true;
        insert responseCodeControl;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	    User u = new User(Alias = 'standt', Email='test@ge.com',Email__c = 'test@ge.com',
	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
	    LocaleSidKey='en_US', ProfileId = p.Id,
	    TimeZoneSidKey='America/Los_Angeles', UserName='latitude@ge.com');
        
        System.runAs(u) {
            test.startTest();
            	Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
                testProfileControl.SetupOwnerId = UserInfo.getProfileId();
                insert testProfileControl;
            
                ApexPages.currentPage().getParameters().put('Id',testApplication.Id);
                APP_GSD_ContractAcceptanceChannel appGSDCA = new APP_GSD_ContractAcceptanceChannel();
                appGSDCA.isInsuranceAcknowledgement();
                system.assertEquals(true,appGSDCA.insuranceAcknowledgement );
            	system.assertEquals(true, appGSDCA.getIsRefresh());
            
            	testDocument2.Status__c = 'Received';
            	testDocument2.GE_Document_ID__c = '0014';
            	update testDocument2; 
            
            	// Create Attachment
                Attachment attVar = TestDataBuilder.createAttachment(testDocument2.Id);
                insert attVar;
            	appGSDCA = new APP_GSD_ContractAcceptanceChannel();
            	system.assertEquals( false, appGSDCA.getIsRefresh());
            	system.assertEquals( true, appGSDCA.getRCCreateAccess('PCO'));
            	system.assertEquals( true, appGSDCA.getProfileAccess(UserInfo.getProfileId()));
            	system.assertEquals( true, appGSDCA.getLatestContractAccessStatus());
            	system.assertEquals( 'AppResponse', appGSDCA.getName());
            	APP_GSD_ContractAcceptanceChannel.enableCheckboxRA(testDocument1.Id,true);
            	APP_GSD_ContractAcceptanceChannel.enableInsuranceCheckBoxRA(testApplication.Id,true); 
            	APP_GSD_ContractAcceptanceChannel.updateApplication(testApplication.Id,true);
            	//appGSDCA.updateAllRelatedDocument();
            test.stopTest();
        }
    }
    
    static testMethod void testCAMethodsFail(){
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Acceptance_Channel__c = 'Online Acceptance';
        testApplication.Application_Type__c = 'Single';
        testApplication.Response_Code__c = 'PCO';
        insert testApplication;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        List<GEProduct__c> prodList = new List<GEProduct__c>();
        GEProduct__c testProduct1 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct1.name = GEN_OriginationsConstants.LIFE_INSURANCE;
        GEProduct__c testProduct2 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct2.name = GEN_OriginationsConstants.DISABILITY_INSURANCE;
        GEProduct__c testProduct3 = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct3.name = GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE;
        prodList.add(testProduct1);
        prodList.add(testProduct2);
        prodList.add(testProduct3);
        insert prodList;
        
        List<Product_Version__c> pvList = new List<Product_Version__c>();
        Product_Version__c testProductVersion1 = TestDataBuilder.createProductVersion(testProduct1.Id);            
        Product_Version__c testProductVersion2 = TestDataBuilder.createProductVersion(testProduct2.Id);
        Product_Version__c testProductVersion3 = TestDataBuilder.createProductVersion(testProduct3.Id);
        pvList.add(testProductVersion1);
        pvList.add(testProductVersion2);
        pvList.add(testProductVersion3);
        insert pvList;
        
        List<Product_Item__c> piList = new List<Product_Item__c>();
        Product_Item__c testProductItem1 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion1.Id);
       	Product_Item__c testProductItem2 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion2.Id);
        Product_Item__c testProductItem3 = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion3.Id);
		piList.add(testProductItem1);
        piList.add(testProductItem2);
        piList.add(testProductItem3);
        insert piList;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion1.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        
        // Create Test PCO Response Code
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'PCO';
        appResponse.Contract_Account_Number__c = '04444444444';
        insert appResponse;
        
        // Create Test Account
		Account testAcc = TestDataBuilder.createPersonAccount();
        insert testAcc;
        
        // Create Test Applicant
        List<Applicant__c>applicantList = new List<Applicant__c>();
        Applicant__c testApplicant = TestDataBuilder.createApplicant(testAcc.Id, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Email_Address__c = 'test@ge.com';
        applicantList.add(testApplicant);
        insert applicantList;
		
        
        // Create Test Related Documents from Doc Gen
        List<Related_Document__c> relDocList = new List<Related_Document__c>();
        
        String category = GEN_OriginationsConstants.LOAN_DOCUMENTS; // 'Loan Documents'
        String genLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED; // 'Generated Document'
        String staticLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC; // 'Static'
        String internalCategory = GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL; // 'Internal'
        String disclosureStatement = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT; // 'Disclosure Statement'
        
        Related_Document__c testDocument1 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument1.isAccepted__c = false;
        testDocument1.Document_Category__c = category;
        testDocument1.GE_Link_Type__c = staticLinkType;
        testDocument1.Section__c = DOC_GenerateDocumentsUtil.SECTION_INSURANCE;
        
        Related_Document__c testDocument2 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument2.isAccepted__c = false;
        testDocument2.Document_Category__c = internalCategory;
        testDocument2.GE_Link_Type__c = genLinkType;
        testDocument2.Section__c = DOC_GenerateDocumentsUtil.SECTION_CONTRACT;
        testDocument2.Type__c = disclosureStatement;
        testDocument2.GE_Document_ID__c = null;
        testDocument2.Status__c = 'Sent';
         
        Related_Document__c testDocument3 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument3.isAccepted__c = false;
        testDocument3.GE_Link_Type__c = staticLinkType;
        testDocument3.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_TERMS_AND_CONDITIONS;
        
        Related_Document__c testDocument4 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument4.isAccepted__c = false;
        testDocument4.GE_Link_Type__c = staticLinkType;
        testDocument4.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_CREDIT_GUIDE;
        
        Related_Document__c testDocument5 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument5.isAccepted__c = false;
        testDocument5.GE_Link_Type__c = staticLinkType;
        testDocument5.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_COMPLAINTS_BROCHURE;
        
		Related_Document__c testDocument6 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument6.isAccepted__c = false;
        testDocument6.GE_Link_Type__c = staticLinkType;
        testDocument6.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_LPI_BROCHURE;        
        
        Related_Document__c testDocument7 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument7.isAccepted__c = false;
        testDocument7.GE_Link_Type__c = staticLinkType;
        testDocument7.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_EIDV_CONSENT;  
        
        Related_Document__c testDocument8 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument8.isAccepted__c = false;
        testDocument8.GE_Link_Type__c = staticLinkType;
        testDocument8.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_RPI_POLICY; 
        
         // Not Receieved
        Related_Document__c testDocument9 = TestDataBuilder.createRelatedDocument(applicantList[0].Id, testApplication.Id);
        testDocument9.isAccepted__c = false;
        testDocument9.GE_Link_Type__c = staticLinkType;
        testDocument9.Type__c = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT; 
        testDocument9.Document_Category__c = internalCategory;
        
        
        relDocList.add(testDocument1);
        relDocList.add(testDocument2);
        relDocList.add(testDocument3);
        relDocList.add(testDocument4);
        relDocList.add(testDocument5);
        relDocList.add(testDocument6);
        relDocList.add(testDocument7);
        relDocList.add(testDocument8);
        relDocList.add(testDocument9);
        
        insert relDocList;
        
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, 'PCO');
        responseCodeControl.Create_Account__c = true;
        insert responseCodeControl;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	    User u = new User(Alias = 'standt', Email='test@ge.com',Email__c = 'test@ge.com',
	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
	    LocaleSidKey='en_US', ProfileId = p.Id,
        AppId__c = testApplication.id,                  
	    TimeZoneSidKey='America/Los_Angeles', UserName='latitude@ge.com');
        
        System.runAs(u) {
            test.startTest();
            	Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
                testProfileControl.SetupOwnerId = UserInfo.getProfileId();
                insert testProfileControl;
            
                ApexPages.currentPage().getParameters().put('Id',testApplication.Id);
                APP_GSD_ContractAcceptanceChannel appGSDCA = new APP_GSD_ContractAcceptanceChannel();
                appGSDCA.isInsuranceAcknowledgement();
                system.assertEquals(true,appGSDCA.insuranceAcknowledgement );
            	system.assertEquals(true, appGSDCA.getIsRefresh());
            
            	testDocument2.Status__c = 'Received';
            	testDocument2.GE_Document_ID__c = '0014';
            	update testDocument2; 
            
            	// Create Attachment
                Attachment attVar = TestDataBuilder.createAttachment(testDocument2.Id);
                insert attVar;
            	appGSDCA = new APP_GSD_ContractAcceptanceChannel();
            	system.assertEquals( false, appGSDCA.getIsRefresh());
            	system.assertEquals( true, appGSDCA.getRCCreateAccess('PCO'));
            	system.assertEquals( true, appGSDCA.getProfileAccess(UserInfo.getProfileId()));
            	system.assertEquals( true, appGSDCA.getLatestContractAccessStatus());
            	system.assertEquals( 'AppResponse', appGSDCA.getName());
            	APP_GSD_ContractAcceptanceChannel.enableCheckboxRA(testDocument1.Id,true);
            	APP_GSD_ContractAcceptanceChannel.enableInsuranceCheckBoxRA(testApplication.Id,true); 
            	APP_GSD_ContractAcceptanceChannel.updateApplication(testApplication.Id,true);
            	appGSDCA.updateAllRelatedDocument();
            test.stopTest();
        }
    }
}