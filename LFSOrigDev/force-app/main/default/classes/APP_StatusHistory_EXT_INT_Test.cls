@isTest
public class APP_StatusHistory_EXT_INT_Test {
    
    static testMethod void StatusHistory_Test() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_StatusHistory_EXT_INT statusHistory = new APP_StatusHistory_EXT_INT(standardCon);
            testApplication.Brand_String__c = 'Test';
            update testApplication;
            statusHistory.applicationHistoryList();
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, statusHistory.applicationId);
    }
}