/*
 * @Description: Controller extension for APP_LogoutExt Page
 * @Author: Adrian
 * @Date Created: APR-03-2014
 * @History:
   =====================================================================
       Adrian   -  APR-03-14: Created
   =====================================================================
 */
 @IsTest
public with sharing class APP_LogoutExt_Test {
	static testMethod void testAPPLogOutExt_One(){
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
        brandVar.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        brandVar.Site__c = null;
        //BEGIN MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        brandVar.URL_Home_Page__c = 'http://www.aussie.com.au/';
        insert brandVar;
        
		test.startTest();
			APP_LogoutExt appLogOutExt = new APP_LogoutExt();
			system.assertEquals('color:#711371;',appLogOutExt.buttonStyle);
			system.assertEquals(brandVar.URL_Home_Page__c,appLogOutExt.homeURL);
			system.assertEquals('color:#711371',appLogOutExt.footerTextStyle);
			
			brandVar.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
			brandVar.URL_Home_Page__c = 'http://www.gemoney.com.au/';
			update brandVar;
			appLogOutExt = new APP_LogoutExt();
			system.assertEquals('color:#3b73b9;',appLogOutExt.buttonStyle);
			system.assertEquals(brandVar.URL_Home_Page__c,appLogOutExt.homeURL);
			
			brandVar.Name = GEN_OriginationsConstants.BRAND_NAME_KIWI;
			brandVar.URL_Home_Page__c = 'http://www.kiwibank.co.nz/';
			update brandVar;
			appLogOutExt = new APP_LogoutExt();
			system.assertEquals('color:#000;',appLogOutExt.buttonStyle);
			system.assertEquals(brandVar.URL_Home_Page__c,appLogOutExt.homeURL);
			system.assertEquals('color:#6fa23e',appLogOutExt.footerTextStyle);
			
			brandVar.Name = 'NOMATCH';
			brandVar.URL_Home_Page__c = 'http://www.gemoney.co.nz/';
			update brandVar;
			appLogOutExt = new APP_LogoutExt();
			system.assertEquals('color:#3a73ba;',appLogOutExt.buttonStyle);
			system.assertEquals(brandVar.URL_Home_Page__c,appLogOutExt.homeURL);
			//END MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
			system.assertEquals('color:#3a73ba',appLogOutExt.footerTextStyle);
			
		test.stopTest();
	}
}