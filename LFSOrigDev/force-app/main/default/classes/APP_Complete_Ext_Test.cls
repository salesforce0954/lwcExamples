/*
 * @Description: Test class for APP_Complete_Ext class
 * @Author: Adrian
 * @Date Created: March-30-2015
 * @History:
   =====================================================================
       Adrian   -  APR-03-14: Created
   =====================================================================
 */

@IsTest
public with sharing class APP_Complete_Ext_Test {
	static testMethod void testAPPCompleteExt_One(){
		//Joint with no Expense (weekly and fortnight)
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<admin_settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;
        
        // Create Test Brand
        Brand__c brandVar = TestDataBuilder.createBrand();
        brandVar.Site__c = null;
        insert brandVar;
        
		test.startTest();
			ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
			APP_Complete_Ext appComCls = new APP_Complete_Ext(standardCon);
			
			system.assertEquals(true,appComCls.getJointApplication());
			system.assertEquals(false,appComCls.getOffLine());
			
			appComCls.homePage='http://google.com';
			PageReference ref = new PageReference('http://google.com');
			system.assertEquals(ref.getURL(),appComCls.redirectToPostSubmit().getURL());
			
			system.assertEquals(false,appComCls.getFromFileUpload());
			
			PageReference pageRef = Page.APP_Logout;
        	pageRef.setRedirect(true);
			system.assertEquals(pageRef.getURL(),appComCls.logout().getURL());
			
			appComCls.applicantList.clear();
			system.assertEquals(false,appComCls.getJointApplication());
			
			appComCls.application.Acceptance_Channel__c = 'Offline Acceptance';
			system.assertEquals(true,appComCls.getOffLine());
			
			ApexPages.currentPage().getParameters().put('FileUpload','1');
			system.assertEquals(true,appComCls.getFromFileUpload());
		test.stopTest();
	}
}