@Istest
public with sharing class ClientPaymentDetailsControllerTest {
    @TestSetup
    public static void setupData() {
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
        Response_Code_Control__c setting = new Response_Code_Control__c();
        setting.Name = 'PA';
        setting.Save_Debit_Standard__c = true;
        setting.Save_Disbursement_Standard__c = true;
        insert setting;        
    }

    @IsTest
    public static void testLoadData() {
        Test.startTest();
        Application__c application = [SELECT ID FROM Application__c LIMIT 1];    
        ClientPaymentDetailsController.loadClientPaymentDetailsData(application.Id);
        Test.stopTest();
    }

    @IsTest
    public static void testLoadDataWithDebitAndCreditExist() {
        Schema.DescribeSObjectResult R = Debit__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapDebitRecordType = R.getRecordTypeInfosByDeveloperName();   
        
        R = Disbursement__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapCreditRecordType = R.getRecordTypeInfosByDeveloperName();           

        Application__c application = [SELECT ID, Status__c FROM Application__c LIMIT 1];    
        System.debug('DEBUG TEST : '+application.Status__c);
        Debit__c directDebit = TestDataBuilder.createDebit(mapDebitRecordType.get('Direct_Debit').getRecordTypeId(), application.Id);
        insert directDebit;

        Disbursement__c directCredit = new Disbursement__c();
        directCredit.Application__c = application.Id;
        directCredit.RecordTypeId = mapCreditRecordType.get('Direct_Credit').getRecordTypeId();
        directCredit.Bank_Acc_No__c = '12312312';
        directCredit.BSB__c = '123456';
        directCredit.Account_Holders__c = 'ABCDS';
        directCredit.Bank_Name__c = 'ATB';
        directCredit.Branch__c='Melbourne';
        insert directCredit;

        Test.startTest();
        ClientPaymentDetailsController.loadClientPaymentDetailsData(application.Id);
        Test.stopTest();
    }    

    @IsTest
    public static void testInsertDirectDebit() {
        Application__c application = [SELECT ID, Status__c FROM Application__c LIMIT 1];   
        ClientPaymentDetailsController.insertDirectDebit(application.Id, 'ABCDFE', '123456', '123618236817263', 'ABC', 'Melbourne', 'Monthly', '01/01/2022');
    }

    @IsTest
    public static void testInsertDirectCredit() {
        Application__c application = [SELECT ID, Status__c FROM Application__c LIMIT 1]; 
        ClientPaymentDetailsController.insertDirectCredit(application.Id, 
        'ABCDFE',
        '123456',
        '1235612537',
        'ATB',
        'Melbourne');        
    }    
}