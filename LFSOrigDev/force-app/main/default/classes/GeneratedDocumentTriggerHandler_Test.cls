/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 05, 2014
Description: Test class for AttachementTriggerHandler 
*/
@isTest
private class GeneratedDocumentTriggerHandler_Test {
    
    @isTest static void testUpdateRelatedDocument() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Related_Document__c testRelatedDocument = TestDataBuilder.createRelatedDocument(testApplicant.Id,testApplication.Id);
        insert testRelatedDocument;

        Attachment testAttachment = TestDataBuilder.createAttachment(testRelatedDocument.Id);
        insert testAttachment;

        Application__c appAss = [Select Id FROM Application__c WHERE Id =:testApplication.Id];
        Related_Document__c relDocAss = [Select Id,Application__c,Status__c FROM Related_Document__c WHERE Id =:testRelatedDocument.Id];

        System.assertEquals(appAss.Id,relDocAss.Application__c);
        System.assertEquals(relDocAss.Status__c, 'Received');
    }

    @isTest static void testWebServiceCall(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Related_Document__c testRelatedDocument = TestDataBuilder.createRelatedDocument(testApplicant.Id,testApplication.Id);
        testRelatedDocument.GE_Link_Type__c = 'Generated Document';
        testRelatedDocument.Status__c = 'Received';
        insert testRelatedDocument;

        Related_Document__c testRelatedDocument1 = TestDataBuilder.createRelatedDocument(testApplicant.Id,testApplication.Id);
        testRelatedDocument1.GE_Link_Type__c = 'Generated Document';
        insert testRelatedDocument1;

        Related_Document__c testRelatedDocument2 = TestDataBuilder.createRelatedDocument(testApplicant.Id,testApplication.Id);
        testRelatedDocument2.GE_Link_Type__c = 'Generated Document';
        insert testRelatedDocument2;

        Related_Document__c testRelatedDocument3 = TestDataBuilder.createRelatedDocument(testApplicant.Id,testApplication.Id);
        testRelatedDocument3.GE_Link_Type__c = 'Static';
        insert testRelatedDocument3;

        Attachment testAttachment = TestDataBuilder.createAttachment(testRelatedDocument.Id);
        insert testAttachment;

        Attachment testAttachment2 = TestDataBuilder.createAttachment(testRelatedDocument1.Id);
        insert testAttachment2;
        
        Attachment testAttachment3 = TestDataBuilder.createAttachment(testRelatedDocument2.Id);
        insert testAttachment3;

        Application__c appAss = [Select Id,Generated_Doc_Confirm_Sent__c FROM Application__c WHERE Id =:testApplication.Id];
        appAss.Generated_Doc_Confirm_Sent__c = true;
        update appAss;
        Related_Document__c relDocAss = [Select Id,Application__c,Status__c FROM Related_Document__c WHERE Id =:testRelatedDocument.Id];

        System.assertEquals(appAss.Id,relDocAss.Application__c);
        System.assertEquals(relDocAss.Status__c,'Received');
        System.assertEquals(appAss.Generated_Doc_Confirm_Sent__c,True);

    }
    
}