@isTest
public class APP_Documents_EXT_INT_Test {
    
    @isTest static void generatedDocuments() {

        Application__c testApplication = testDatabuilder.createApplication();
        
        Brand__c Brand = new Brand__c();
        Brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ;       //MLASALA: 18-MAR-16 TQLQW-127 Re-brand
        Brand.External_ID__c = '1';
        Brand.URL_Key__c = '1234';
        Brand.Country__c = 'NZ';
        brand.Loan_Term__c='{1 year;2 year;6 Months}';
        insert Brand;
        testApplication.Brand_Lookup__c=Brand.id;
        insert testApplication;
        
        
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = testDatabuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;

        Related_Document__c testRelatedDocument = testDatabuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        testRelatedDocument.GE_Link_Type__c = 'Generated Document';
        insert testRelatedDocument;

        Attachment testAttachment = testDatabuilder.createAttachment(testRelatedDocument.Id);
        insert testAttachment;
        
        Test.startTest();
            ApexPages.StandardController docu = new ApexPages.StandardController(testApplication);
            APP_Documents_EXT_INT docuTest = new APP_Documents_EXT_INT(docu);
            docuTest.getRelatedDocuments();
            docuTest.refreshRelatedDocumentList();
            docuTest.retryRelatedDocument();
            docuTest.validationErrors = new List<IS_ValidationError>();
            docuTest.docGenFailed = false;
            docuTest.fireDocGenServiceCallRetry();
            docuTest.nullSetter('Test');
            docuTest.getIsJoint(); 
        Test.stopTest();

        System.assert(!docuTest.relatedDocumentWrapperListLoan.isEmpty());
        System.assert(docuTest.relatedDocumentWrapperListNotLoan.isEmpty());
        System.assertEquals(GEN_OriginationsConstants.WSCODE_DOCGEN_SUCCESS, docuTest.successCode);
        System.assertEquals(GEN_OriginationsConstants.WSCODE_DOCGEN_RETRYABLE, docuTest.retryableCode);
        
    }

    @isTest static void notLoanDocuments() {

        Application__c testApplication = testDatabuilder.createApplication();
        Brand__c Brand = new Brand__c();
        Brand.Name = 'Kiwibank';
        Brand.External_ID__c = '1';
        Brand.URL_Key__c = '1234';
        Brand.Country__c = 'NZ';
        brand.Loan_Term__c='{1 year;2 year;6 Months}';
        insert Brand;
        testApplication.Brand_Lookup__c=Brand.id;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = testDatabuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;

        Related_Document__c testRelatedDocument = testDatabuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        testRelatedDocument.Document_Category__c = 'AML';
        insert testRelatedDocument;

        Attachment testAttachment = testDatabuilder.createAttachment(testRelatedDocument.Id);
        insert testAttachment;

        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert testResponseCodeControl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(false);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

        Test.startTest();
            ApexPages.StandardController docu = new ApexPages.StandardController(testApplication);
            APP_Documents_EXT_INT docuTest = new APP_Documents_EXT_INT(docu);
            docuTest.getRelatedDocuments();
            docuTest.refreshRelatedDocumentList();
            docuTest.retryRelatedDocument();
            docuTest.validationErrors = new List<IS_ValidationError>();
            docuTest.docGenFailed = false;
            docuTest.fireDocGenServiceCallRetry();
        Test.stopTest();

        System.assert(docuTest.relatedDocumentWrapperListLoan.isEmpty());
        System.assert(!docuTest.relatedDocumentWrapperListNotLoan.isEmpty());
        System.assertEquals(GEN_OriginationsConstants.WSCODE_DOCGEN_SUCCESS, docuTest.successCode);
        System.assertEquals(GEN_OriginationsConstants.WSCODE_DOCGEN_RETRYABLE, docuTest.retryableCode);
    }

    @isTest static void pageRefAndControlsTest() {
        Application__c testApplication = testDatabuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = testDatabuilder.createApplicant(null,testApplication.Id);
        insert testApplicant;

        Related_Document__c testRelatedDocument = testDatabuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        testRelatedDocument.Document_Category__c = null;
        testRelatedDocument.Type__c  = null;
        insert testRelatedDocument;

        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;

        Test.startTest();
            ApexPages.StandardController docu = new ApexPages.StandardController(testApplication);
            APP_Documents_EXT_INT docuTest = new APP_Documents_EXT_INT(docu);
            docuTest.uploadDocument();
            docuTest.goBack();
            docuTest.updateRealtedDocumentsNotLoan();
            docuTest.relatedDocumentWrapperListNotLoan[0].relatedDocument.Document_Category__c = 'AML';
            docuTest.updateRealtedDocumentsNotLoan();
            docuTest.relatedDocumentWrapperListNotLoan[0].relatedDocument.Document_Category__c = null;
            docuTest.relatedDocumentWrapperListNotLoan[0].relatedDocument.Type__c = 'Test';
            docuTest.updateRealtedDocumentsNotLoan();
            docuTest.relatedDocumentWrapperListNotLoan[0].relatedDocument.Document_Category__c = 'AML';
            docuTest.updateRealtedDocumentsNotLoan();
        Test.stopTest();

        System.assert(docuTest.relatedDocumentWrapperListLoan.isEmpty());
        System.assert(!docuTest.relatedDocumentWrapperListNotLoan.isEmpty());
    }
}