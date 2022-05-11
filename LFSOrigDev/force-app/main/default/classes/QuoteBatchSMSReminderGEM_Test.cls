@IsTest
public with sharing class QuoteBatchSMSReminderGEM_Test {
    @TestSetup
    static void makeData(){
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        Brand_Content__c bc5=new Brand_Content__c();
        bc5.Output_HTML__c = 'a';
        bc5.Name = 'Quote Reminder SMS GEM Day 2';
        
        Brand_Content__c bc6=new Brand_Content__c();
        bc6.Output_HTML__c = 'a';
        bc6.Name = 'Quote Reminder SMS GEM Day 4';    
        
        List<Brand_Content__c> listBC = new List<Brand_Content__c>();
        listBC.add(bc5);
        listBC.add(bc6);
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
        
        List<Quote__c> q5 = TestDataBuilder.createQuoteNZOnline();
        q5[0].Quote_Stage__c = 'Initial Submit';
        q5[0].Monthly_Repayment__c=98.23;
        q5[0].Quote_Rate__c=12.99;
        q5[0].Quote_Secured_Rate__c=10.99;
        q5[0].Quote_Offered_On__c = system.today()-2;
        insert q5; 
        q5[0].Quote_Stage__c = 'Quote Offered';
        update q5;        
        
        List<Quote__c> q6 = TestDataBuilder.createQuoteNZOnline();
        q6[0].Quote_Stage__c = 'Initial Submit';
        q6[0].Monthly_Repayment__c=98.23;
        q6[0].Quote_Rate__c=12.99;
        q6[0].Quote_Secured_Rate__c=10.99;
        q6[0].Quote_Offered_On__c = system.today()-4;
        insert q6; 
        q6[0].Quote_Stage__c = 'Quote Offered';
        update q6;                
    }

    @IsTest
    static void testBatchReminderSMS() {
        Test.setMock(HttpCalloutMock.class, new MessageMediaSendSmsCalloutMock());
        Test.StartTest();
        ScheduleQuoteSMSReminderGEM sh1 = new ScheduleQuoteSMSReminderGEM();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Check', sch, sh1); 
        Test.stopTest();         
    }
}