/*
 * Author: Adrian Recio Cloud Sherpas
 * Created Date: 23/09/2015
 * Description: Test method for Off_OfferPresentationRemote class
 */
 @isTest
public with sharing class Off_OfferPresentationRemoteTest {
	public static testMethod void Off_OfferPresentationRemoteTest1() {

		//Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Generated_Doc_Confirm_Sent__c = false;
        insert testApplication;

        /*
        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
		*/

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        // Create test related document
		Related_Document__c rdVar = TestDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        rdVar.GE_Link_Type__c = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED;
        rdVar.Document_Category__c = GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN; 
        rdVar.Status__c = 'Received';
        insert rdVar;

		test.startTest();
			ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
			Off_OfferPresentationRemote offPreCntrl = new Off_OfferPresentationRemote(standardCon);

			Application_Response__c intVar = Off_OfferPresentationRemote.checkForApplicationResponseNonStreaming(testApplication.Id);
			Application_Response__c appResponse = Off_OfferPresentationRemote.checkForRetrievePayoffApplicationResponse(testApplication.Id);
			
			Boolean conReceived = Off_OfferPresentationRemote.callConfirmContractRecieved(testApplication.Id);

			rdVar.Status__c = 'Sent';
			update rdVar;

	        conReceived = Off_OfferPresentationRemote.callConfirmContractRecieved(testApplication.Id);
		test.stopTest();
	}
}