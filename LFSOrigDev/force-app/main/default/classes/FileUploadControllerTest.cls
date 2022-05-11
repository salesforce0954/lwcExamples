@IsTest
public with sharing class FileUploadControllerTest {
    @TestSetup
    static void makeData(){
        List<Account> accs = TestDataBuilder.createAccounts(1);
        Application__c testApplication = TestDataBuilder.createApplication();
        insert accs;
        testApplication.Status__c = 'Referred: Refer to CPU/CMO';
        insert testApplication;
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Date_of_Birth_Doc_Gen__c = '10/02/1996';
        insert testApplicant;
        insert TestDataBuilder.createResponseCodeControlPA();
        insert TestDataBuilder.createBSBList();
        Web_Service_Settings__c setting = new Web_Service_Settings__c();
        setting.Name = 'File Upload Endpoint';
        setting.value__c = 'test';
        insert setting;         
    }

    @IsTest
    public static void testGetUrlEndPoint() {
        FileUploadController.getUploadEndPoint();
    }

    @IsTest
    public static void testInsertAndDeleteRelatedDocument() {
        Application__c application = [SELECT ID FROM Application__c LIMIT 1];
        Applicant__c applicant = [SELECT ID FROM Applicant__c WHERE Application__c = :application.Id LIMIT 1];
        FileUploadController.UploadInfo ui = FileUploadController.insertRelatedDocument('Test', application.Id, applicant.Id, false);
        FileUploadController.deleteRelatedDocument(ui.recordIdSaved); 
    }    
}