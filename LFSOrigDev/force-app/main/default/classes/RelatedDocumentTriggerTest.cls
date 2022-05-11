@IsTest
public with sharing class RelatedDocumentTriggerTest {
    @TestSetup
    static void makeData(){
        Application__c application = TestDataBuilder.createApplication();
        application.Status__c = 'Conditionally Approved: AML';
        insert application;

        List<Account> accounts = TestDataBuilder.createAccounts(3);
        insert accounts;

        Applicant__c applicant = TestDataBuilder.createApplicant(null, application.Id);
        insert applicant;
    }

    @IsTest
    static void testInsertRelatedDocument() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
    }

    @IsTest
    static void testUpdateAttachmentURL2() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
        
        rd.GE_Document_ID__c = 'Test';
        update rd;
    }

    @IsTest
    static void testUpdateAttachmentURL3() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
        
        application.Status__c = 'Conditionally Approved: POI';
        update application;

        rd.GE_Document_ID__c = 'Test';
        update rd;
    }
    
    @IsTest
    static void testUpdateAttachmentURL4() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
        
        application.Status__c = 'Conditionally Approved: AML and POI';
        update application;

        rd.GE_Document_ID__c = 'Test';
        update rd;
    }    

    @IsTest
    static void testUpdateAttachmentURL5() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
        
        application.Status__c = 'Referred: Sales';
        update application;

        rd.GE_Document_ID__c = 'Test';
        update rd;
    }        

    @IsTest
    static void testDeleteRelatedDocument() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;

        String rdName = rd.Name;

        delete rd;

        //undelete rd;

        /*Related_Document__c[] savedRd = [SELECT Id, Name FROM Related_Document__c WHERE Name = :rdName ALL ROWS]; 
        try {
            undelete savedRd;
        } catch (DmlException e) {
            // Process exception here
        }*/        
    }  
    
    @IsTest
    static void testUpdateApplicationPOI() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1]; 
        Applicant__c applicant = [SELECT ID FROM Applicant__c LIMIT 1];
        Related_Document__c rd = TestDataBuilder.createRelatedDocument(applicant.Id, application.Id);
        insert rd;
        
        RelatedDocumentTriggerClass rdt = new RelatedDocumentTriggerClass();
        rdt.updateApplicationPOICompletion(new Set<Id>{application.Id});
    }      
}