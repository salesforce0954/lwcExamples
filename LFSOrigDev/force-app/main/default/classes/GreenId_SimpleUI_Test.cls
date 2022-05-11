/* @Description: Green Id simpleUI test methods
 * @Author : Adrian Recio
 * @Date : 21-JUNE-2016
 * @History:
   =========================================================================================================
   		21-JUNE-2016 : Created - Adrian Recio
   =========================================================================================================
 */
@IsTest
public with sharing class GreenId_SimpleUI_Test {
    	
    // Initiate common test data
    @testSetup static void testData() {
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('ResponseTimeOut', '60');
        insert testWebServiceSettings;
        
        Insurance_Premium_Calculation_Variables__c testInsurance = TestDataBuilder.createInsurancePremium();
        insert testInsurance;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand; 

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Submission_Status__c);
        insert testResponseCodeControl;
        
        Response_Code_Control__c testResponseCodeControl2 = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        insert testResponseCodeControl2;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
            testProfileControl.SetupOwnerId = UserInfo.getProfileId();
        insert testProfileControl;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
	}
    
	public static testMethod void GreenId_SimpleUI_Test() {
		
        Application__c testApplication = [Select Id from Application__c limit 1];
        Applicant__c testApplicant = [Select Id from Applicant__c limit 1];
        
        ApexPages.currentPage().getParameters().put('Id', testApplication.Id); 
        ApexPages.currentPage().getParameters().put('aId', testApplicant.Id); 
        
        /*
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock(); 
		mock.setStaticResource('greenIdTokenResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/xml');
        */
        
        
        test.startTest();
        	//test.setMock(WebServiceMock.class, mock);
        	GreenId_SimpleUI gsCntrl = new GreenId_SimpleUI();	
        test.stopTest();
	}
}