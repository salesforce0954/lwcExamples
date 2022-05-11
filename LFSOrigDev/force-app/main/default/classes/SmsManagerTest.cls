@isTest public with sharing class SmsManagerTest {


    @TestSetup
    static void createData(){

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
        
    }
    @isTest static void testSendSms(){

        Test.setMock(HttpCalloutMock.class, new MessageMediaSendSmsCalloutMock());
        Test.startTest();
        String messageId = SmsManager.sendMessage('+614045000000', 'Test Message', 'Latitude');
        System.assertNotEquals(null, messageId);
        Test.stopTest();
    }

    @isTest static void testSendBulkSms(){
        Test.setMock(HttpCalloutMock.class, new MessageMediaSendSmsCalloutMock());
        Test.startTest();
        List<SmsManager.BulkSMSWrapper> lBSW = new List<SmsManager.BulkSMSWrapper>();
        SmsManager.BulkSMSWrapper bsw1 = new SmsManager.BulkSMSWrapper();
        bsw1.content = 'first';
        bsw1.destination_number = '09798797';
        bsw1.source_number = 'Latitude';
        lBSW.add(bsw1);
        String messageId = SmsManager.sendBulkMessage(lBSW);
        System.assertNotEquals(null, messageId);
        Test.stopTest();        
    }

    @isTest static void testValidateSms(){

        Test.setMock(HttpCalloutMock.class, new MessageMediaValidateSmsCalloutMock());
        Test.startTest();
        String messageId = 'dummyMessageId';
        Boolean validated = SmsManager.validateSentMessage(messageId);
        System.assertNotEquals(null, validated);
        Test.stopTest();
    }
    
}