/**  Test class for QuoteBatchSMSReminder 
 * @Author: William Putra
 * @Date Created: Oct-07-2021 
 * @History:
   ========================================================================
     
   ========================================================================
 */ 
@IsTest
public with sharing class QuoteBatchSMSReminder_Test {
    @TestSetup
    static void makeData(){
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        Brand_Content__c bc1=new Brand_Content__c();
        bc1.Output_HTML__c = 'a';
        bc1.Name = 'Quote Reminder SMS AU Day 2';

        Brand_Content__c bc2=new Brand_Content__c();
        bc2.Output_HTML__c = 'a';
        bc2.Name = 'Quote Reminder SMS AU Day 4';
        
        Brand_Content__c bc3=new Brand_Content__c();
        bc3.Output_HTML__c = 'a';
        bc3.Name = 'Quote Reminder SMS AU Day 13'; 
        
        List<Brand_Content__c> listBC = new List<Brand_Content__c>();
        listBC.add(bc1);
        listBC.add(bc2);
        listBC.add(bc3);
        insert listBC;

        List<Admin_Settings__c> adminSettingsList = new List<Admin_Settings__c>();

        Admin_Settings__c adminSettings_1 = new Admin_Settings__c();
        adminSettings_1.Name = 'MessageMedia_Endpoint';
        adminSettings_1.Value__c = 'https://api.messagemedia.com/v1/messages';
        adminSettingsList.add(adminSettings_1);

        Admin_Settings__c adminSettings_2 = new Admin_Settings__c();
        adminSettings_2.Name = 'MessageMedia_Token';
        adminSettings_2.Value__c = 'FBcyeXCHBTUHCQTj53Ig:Z7C2CIbZHTG6Tx8hPkkDOYNk6J56Vo';
        adminSettingsList.add(adminSettings_2);

        insert adminSettingsList;        

        List<Quote__c> q1 = TestDataBuilder.createQuoteAUOnline();
        q1[0].Quote_Stage__c = 'Initial Submit';
        q1[0].Monthly_Repayment__c=98.23;
        q1[0].Quote_Rate__c=12.99;
        q1[0].Quote_Secured_Rate__c=10.99;
        q1[0].Quote_Offered_On__c = system.today()-2;
        q1[0].Sub_Type__c='Standard';
        q1[0].Loan_Term__c='3 Years';
        q1[0].Loan_Amount__c=20000;
        q1[0].Loan_Purpose__c='Debt Consolidation';         
        insert q1;    
        q1[0].Quote_Stage__c = 'Quote Offered';
        update q1;

        List<Quote__c> q2 = TestDataBuilder.createQuoteAUOnline();
        q2[0].Quote_Stage__c = 'Initial Submit';
        q2[0].Monthly_Repayment__c=98.23;
        q2[0].Quote_Rate__c=12.99;
        q2[0].Quote_Secured_Rate__c=10.99;
        q2[0].Quote_Offered_On__c = system.today()-4;
        q2[0].Sub_Type__c='Standard';
        q2[0].Loan_Term__c='3 Years';
        q2[0].Loan_Amount__c=20000;
        q2[0].Loan_Purpose__c='Debt Consolidation';         
        insert q2;    
        q2[0].Quote_Stage__c = 'Quote Offered';
        update q2;
        
        List<Quote__c> q3 = TestDataBuilder.createQuoteAUOnline();
        q3[0].Quote_Stage__c = 'Initial Submit';
        q3[0].Monthly_Repayment__c=98.23;
        q3[0].Quote_Rate__c=12.99;
        q3[0].Quote_Secured_Rate__c=10.99;
        q3[0].Quote_Offered_On__c = system.today()-13;
        q3[0].Sub_Type__c='Standard';
        q3[0].Loan_Term__c='3 Years';
        q3[0].Loan_Amount__c=20000;
        q3[0].Loan_Purpose__c='Debt Consolidation';         
        insert q3;    
        q3[0].Quote_Stage__c = 'Quote Offered';
        update q3;                    
    }

    @IsTest
    static void testBatchReminderSMS() {
        Test.setMock(HttpCalloutMock.class, new MessageMediaSendSmsCalloutMock());
        Test.StartTest();
        ScheduleQuoteSMSReminder sh1 = new ScheduleQuoteSMSReminder();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Check', sch, sh1); 
        Test.stopTest();         
    }
}