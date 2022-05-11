/*
 * @Description: Test class for APP_DirectDebitDetailsExt_INT.cls
 * @Author: Russell Cadapan
 * @Date Created: January 28, 2013
 */ 
@isTest
public class APP_DirectDebitDetailsExt_INT_Test{
    private static Schema.DescribeSObjectResult debitSchema = Schema.SObjectType.Debit__c; 
    private static Map<String,Schema.RecordTypeInfo> debitRecordTypeInfo = debitSchema.getRecordTypeInfosByName();
    private static Id directDebitRecordTypeId = debitRecordTypeInfo.get(GEN_OriginationsConstants.DIRECT_DEBIT_RECORDTYPE).getRecordTypeId();

    static testMethod void DirectDebit_Test(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Offered_Repayments__c = 1000;
        insert testApplication;

        Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Debit__c testDebit = TestDataBuilder.createDebit(directDebitRecordTypeId, testApplication.Id);
        insert testDebit;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Object_Definition__c testObject = new Object_Definition__c();
        testObject.Name = GEN_OriginationsConstants.OBJECT_DEBIT;
        // Code Scan Fix: Adrian Recio - Hard Coded Ids
        //testObject.Object_id__c = '01IO00000000rVI';
        //testObject.Application__c = '00NO00000017V4C'; 
        insert testObject;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_DirectDebitDetailsExt_INT directDebit = new APP_DirectDebitDetailsExt_INT(standardCon);
        Test.StopTest();

        System.assert(!directDebit.debitList.isEmpty());
        System.assertEquals(testObject.Object_id__c, directDebit.debitObjId);
        System.assertEquals(testObject.Application__c, directDebit.applicationFieldId);
        System.assert(!directDebit.newEditContract);
    }

    static testMethod void DirectDebit_Test2(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Offered_Repayments__c = 1000;
        insert testApplication;

        Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Debit__c testDebit = TestDataBuilder.createDebit(directDebitRecordTypeId, testApplication.Id);
        insert testDebit;

        Debit__c testDebit2 = TestDataBuilder.createDebit(directDebitRecordTypeId, testApplication.Id);

        try{
          insert testDebit2;
        }
        catch(Exception e){
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0) );
           System.assert(e.getMessage().contains('Debit record already exists'));
        }

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Object_Definition__c testObject = new Object_Definition__c();
        testObject.Name = GEN_OriginationsConstants.OBJECT_DEBIT;
        // Code Scan Fix: Adrian Recio - Hard Coded Ids
        //testObject.Object_id__c = '01IO00000000rVI';
        //testObject.Application__c = '00NO00000017V4C'; 
        insert testObject;
        
        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_DirectDebitDetailsExt_INT directDebit = new APP_DirectDebitDetailsExt_INT(standardCon);
        Test.StopTest();
        
        System.assert(directDebit.debitList.size()==1);
        System.assertEquals(testObject.Object_id__c, directDebit.debitObjId);
        System.assertEquals(testObject.Application__c, directDebit.applicationFieldId);
        System.assert(directDebit.newEditContract);
    }
}