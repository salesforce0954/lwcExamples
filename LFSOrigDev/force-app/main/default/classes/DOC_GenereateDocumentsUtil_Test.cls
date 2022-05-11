/*Author: Russel Cadapan Cloud Sherpas
  Created Date: 01/28/2014
  Description: Test Class for APP_JointAssetExt

*/
@isTest
private class DOC_GenereateDocumentsUtil_Test {
    static testMethod void retrieveDocumentsRequired_Test(){        

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = 'kiwibank';
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Type__c = 'Insurance';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Brand_Lookup__c = testBrand.Id;
            testApplication.Brand_String__c = testBrand.Name;
        insert testApplication;

        Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;

        Product_Item__c testProdItem = TestDataBuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProdItem;

        Id debitRecordType = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' and DeveloperName = 'Direct_Debit' LIMIT 1].Id;
        Debit__c testDebit = TestDataBuilder.createDebit(debitRecordType, testApplication.Id);
        insert testDebit;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;

        Applicant_CLV__c testApplicantCLV = TestDataBuilder.createApplicantCLV(testApplicantSearch.Id,testApplicant.Id);
        insert testApplicantCLV;

        Id rTypeICBS = [SELECT Id FROM RecordType WHERE sObjectType =: 'Applicant_Account__c' AND DeveloperName =: 'ICBS'].Id;

        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLV.Id);
            testApplicantAccount.RecordTypeId = rTypeICBS;
            testApplicantAccount.Account_Balance__c = '1234';
            testApplicantAccount.Account_Number__c = '1234';
        insert testApplicantAccount;
    
        Id disbursementDirectCreditId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Direct_Credit' LIMIT 1].Id;
        Disbursement__c testDirectCreditDisbursement = TestDataBuilder.createDisbursement(testApplication.Id);
            testDirectCreditDisbursement.RecordTypeId = disbursementDirectCreditId;
            testDirectCreditDisbursement.Disbursement_Outcome__c = 'Close';
        insert testDirectCreditDisbursement;

        Id disRecTypeId;
        Schema.DescribeSObjectResult descSobjects = Disbursement__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> rtMapByNames = descSobjects.getRecordTypeInfosByName();
        disRecTypeId = rtMapByNames.get('Re-Finance').getRecordTypeId();

        Disbursement__c testRefinanceDisbursement = TestDataBuilder.createDisbursement(testApplication.Id); 
            testRefinanceDisbursement.RecordTypeId = disRecTypeId;
            testRefinanceDisbursement.Bank_Acc_No__c = '1234';
            testRefinanceDisbursement.Disbursement_Outcome__c = 'Reduce';
        insert testRefinanceDisbursement;

        Disbursement_Plan__c testDisbursementPlan = new Disbursement_Plan__c(Disbursement__c=testRefinanceDisbursement.Id);
        insert testDisbursementPlan;

        Test.startTest();
            DOC_GenerateDocumentsUtil doc = new DOC_GenerateDocumentsUtil();
            List<Related_Document__c> docList = doc.retrieveDocumentsRequired(testApplication.Id);
            //doc.generateStaticDocument(testApplication.Id,'test','test','test');
        Test.StopTest();

        System.assertEquals(testRefinanceDisbursement.Id, testDisbursementPlan.Disbursement__c);
    }
}