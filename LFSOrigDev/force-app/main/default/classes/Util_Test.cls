@isTest
private class Util_Test {
    @isTest static void getPicklistValues_Test(){
        List<Branch__c> testBranch = TestDataBuilder.createBranch(1);
        insert testBranch;

        List<Admin_Settings__c> testAdminSetting = TestDataBuilder.adminSet();
        testAdminSetting[6].Value__c = testBranch[0].Id;
        insert testAdminSetting;

        Test.StartTest();

        List<SelectOption> productType = Util.getPicklistValues(new GEProduct__c(), 'Type__c');
        List<SelectOption> ruleSetting = Util.getRuleSettingValues();
        List<SelectOption> allFieldList = Util.getAllFields(new Applicant__c());
        List<String> fieldList = Util.getFields(new Applicant__c());
        User user = Util.getUser();
        Util.addMessage(ApexPages.Severity.ERROR, 'Test ERROR');
        RecordType rType = Util.getWebServiceRecordType();
        util.stringToInteger('1');
        util.integerToString(1);
        string s1;
        decimal d1;
        util.nullCheck(s1);
        s1='test';
        d1=10;
        util.nullCheck(s1);
        Test.StopTest();
        System.assertEquals(4,productType.size());
        System.assertEquals(testAdminSetting.size(), ruleSetting.size());
    }   
}