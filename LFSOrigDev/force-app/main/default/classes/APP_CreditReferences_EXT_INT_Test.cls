/*
* @Description: Test class for APP_CreditReferences_EXT_INT class
* @Author: August Del Rosario
* @Date Created: Jan-30-2014
* @History:
=====================================================================
30-01-14: Created - August
=====================================================================
*/
@isTest
private class APP_CreditReferences_EXT_INT_Test {

    static testMethod void constructorWithValues() {

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_code__c ='Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,testApplication.Response_code__c);
        insert testResponseCodeCtrl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        Credit_Ref_Check__c testCreditRefCheck = TestDataBuilder.createCreditRefCheck(testApplication.Id);
        insert testCreditRefCheck;

        Test.startTest();

        ApexPages.CurrentPage().getParameters().put('id', testApplication.Id);
        ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
        APP_CreditReferences_EXT_INT crExtInt = new APP_CreditReferences_EXT_INT(standardCon);
        Test.stopTest();

        System.assertEquals(testApplication.Id, crExtInt.applicationId);
        System.assert(!crExtInt.creditRefList.isEmpty());
    }

}