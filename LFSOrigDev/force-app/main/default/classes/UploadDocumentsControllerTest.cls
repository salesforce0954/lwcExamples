@istest
public with sharing class UploadDocumentsControllerTest {
    @isTest
    static void testGetApplicationDetail(){
        List<Account> accs = TestDataBuilder.createAccounts(1);
        Application__c testApplication = TestDataBuilder.createApplication();
        insert accs;
        insert testApplication;
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Date_of_Birth_Doc_Gen__c = '10/02/1996';
        insert testApplicant;
        Income__c income = TestDataBuilder.createIncome(testApplicant.Id);
        insert income;        
        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(testApplication.Id, null);
        lp.Value__c = 'Debt consolidation';
        insert lp;
        Test.startTest();
        UploadDocumentsController.UDWrapper appQuery = UploadDocumentsController.getApplicationDetail(testApplication.Id);
        Test.stopTest();
    }
}