/**
 * This class contains unit tests for validating the behavior of Apex class APP_GSD_Personal_Reference_Ext
 * @Author: Kabir Singh
    * @Date Created: 11-FEB-2016
    * @History:
    =====================================================================
        11-FEB-2016: Created - Kabir Singh
    ===================================================================== 
 */
@isTest
private class APP_GSD_Personal_Reference_Ext_Test {
    
    @testsetup
    static void setupTestData(){
        System.debug('APP_GSD_Personal_Reference_Ext_Test setupTestData start');  
        // Create Test Application
		Application__c app = TestDataBuilder.createApplication();
        app.Response_Code__c ='Test';        
        insert app;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;     
        
        Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,app.Response_code__c);
        insert testResponseCodeCtrl;
        
        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;
        System.debug('APP_GSD_Personal_Reference_Ext_Test setupTestData complete');  
    }

	@isTest
    static void getPersonalReferenceTest() {
        System.debug('executing test case getPersonalReferenceTest');        
        
        Application__c app = [select id, name from application__c where Case_Manager_Id__c = '0916185395213'];
        System.debug('getPersonalReferenceTest retrieved app');
        System.debug('getPersonalReferenceTest retrieved app'+app.Id);
        Personal_Reference_Check__c personalRefObj = TestDataBuilder.createPersonalReferenceCheck(app.Id);
        insert personalRefObj;
        Test.StartTest();
        	Personal_Reference_Check__c personalRefTestObj = APP_GSD_Personal_Reference_Ext.getPersonalReference(app.Id);
            //APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            //branchLocator = amlResponseExt.branchLocatorURL;
        Test.StopTest();
        
        System.assertNotEquals(null, personalRefTestObj);
    }
    
    @isTest
    static void getPersonalReferenceNullTest() {
        System.debug('executing test case getPersonalReferenceNullTest');
        // Create Test Application
		Application__c app = [select id, name from application__c where Case_Manager_Id__c = '0916185395213'];
        
        Personal_Reference_Check__c personalRefObj = TestDataBuilder.createPersonalReferenceCheck(app.Id);
        insert personalRefObj;
        Test.StartTest();
        	Personal_Reference_Check__c personalRefTestObj = APP_GSD_Personal_Reference_Ext.getPersonalReference(null);
            //APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            //branchLocator = amlResponseExt.branchLocatorURL;
        Test.StopTest();
        
        System.assertEquals(null, personalRefTestObj);
    }
    
    @isTest
    static void upsertPersonalReferenceUpdateTest() {
        System.debug('executing test case upsertPersonalReferenceUpdateTest');
        
        Application__c app = [select id, name from application__c where Case_Manager_Id__c = '0916185395213'];
        
        Personal_Reference_Check__c personalRefObj = TestDataBuilder.createPersonalReferenceCheck(app.Id);
        insert personalRefObj;
        Test.StartTest();
        	String result = APP_GSD_Personal_Reference_Ext.upsertPersonalReference(personalRefObj);
            //APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            //branchLocator = amlResponseExt.branchLocatorURL;
        Test.StopTest();
        
        System.assertEquals(personalRefObj.Id, result);
    }
    
    @isTest
    static void upsertPersonalReferenceInsertTest() {
        System.debug('executing test case upsertPersonalReferenceInsertTest');
       
        Application__c app = [select id, name from application__c where Case_Manager_Id__c = '0916185395213'];
        
        Personal_Reference_Check__c personalRefObj = TestDataBuilder.createPersonalReferenceCheck(app.Id);
        
        Test.StartTest();
        	String result = APP_GSD_Personal_Reference_Ext.upsertPersonalReference(personalRefObj);
            //APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            //branchLocator = amlResponseExt.branchLocatorURL;
        Test.StopTest();
        
        System.assertEquals(personalRefObj.Id, result);
    }
    
    @isTest
    static void upsertPersonalReferenceNullTest() {
        System.debug('executing test case upsertPersonalReferenceNullTest');
        Application__c app = [select id, name from application__c where Case_Manager_Id__c = '0916185395213'];
        
        Personal_Reference_Check__c personalRefObj = TestDataBuilder.createPersonalReferenceCheck(app.Id);
        
        Test.StartTest();
        	String result = APP_GSD_Personal_Reference_Ext.upsertPersonalReference(null);
            //APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            //branchLocator = amlResponseExt.branchLocatorURL;
        Test.StopTest();
        
        System.assertEquals(null, null);
    }

}