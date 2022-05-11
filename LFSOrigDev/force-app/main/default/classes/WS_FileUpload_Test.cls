/**
 * @Description: Test Class for WS_FileUpload Class
 * @Author: Adrian Recio
 * @Date Created: APR-3-2014
 * @History:
   =====================================================================
       APR-3-2014: Created. - Adrian
   =====================================================================
 */
@IsTest
public with sharing class WS_FileUpload_Test {
    public static testMethod void testWSFileUpload(){
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        insert appVar;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        // Create Applicant 1
        Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        appliVar1.Is_Primary_Applicant__c = true;
        insert appliVar1;
        
        // Create Applicant 2
        Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar2;
        
        // File upoad success value
        Web_Service_Settings__c fileUpload = new Web_Service_Settings__c();
        fileUpload.name='File Upload Success';
        fileUpload.Value__c='Your document has been sent.';
        insert fileUpload;
        
        // File upload end point
        Web_Service_Settings__c fileUploadEP = new Web_Service_Settings__c();
        fileUploadEP.name='File Upload Endpoint';
        fileUploadEP.Value__c='https://fileupload-dev.au.money.ge.com/fileupload/income/salesforceRequest';
        insert fileUploadEP;
        
        test.startTest();
            WS_FileUpload cntrl = new WS_FileUpload();
            string enpointStr = cntrl.uploadEndPoint;
            string timeStampStr = cntrl.getDateStamp;
            
            cntrl.getDocumentCategoryOptions();
            cntrl.applicationId = appVar.Id;
            cntrl.status = 'Your document has been sent.';
            cntrl.getApplicantOptions();
            cntrl.insertRelatedDocument();
            cntrl.goBack();
            cntrl.setApplicantUploadStatus(appVar.Id);
        test.stopTest();

        System.assertEquals(appVar.Id, cntrl.applicationId);
    }
}