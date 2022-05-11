/* @Description: Test class for APP_PreDocCheckListExt_INT Class
 * @Author: Adrian Recio
 * @Date Created: 7-04-2015
 * @History:
   =====================================================================
       7-04-2015: Created - Adrian
    						Note: I didn't created the original class
    							  that's why I'm not familiar with the business process invloved.
    							  My only goal is to only create some proper test coverage for this class.
    							  Assertion might be clunky.
   =====================================================================
 */ 
@IsTest
public with sharing class APP_PreDocCheckListExt_INT_Test {

    static testMethod void constructor_Test(){

    	List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
    	insert testAdminSettings;

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

         Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_PreDocCheckListExt_INT extension = new APP_PreDocCheckListExt_INT(standardCon);
        Test.StopTest();

        System.assertEquals(testApplication.Id, extension.application.Id);
        System.assertEquals(testBrand.Id, extension.application.Brand_Lookup__c);
    }

    static testMethod void save_Test(){

    	List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
    	insert testAdminSettings;

		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

         Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_PreDocCheckListExt_INT extension = new APP_PreDocCheckListExt_INT(standardCon);
            extension.application.MarriageCertificateFlag__c = true;
            extension.application.NameChangeDocumenationFlag__c = true;
            extension.application.CreditCardStatementFlag__c = true;
            extension.application.CreditReferenceFlag__c = true;
            extension.application.ProofOfPaymentOfDefaultFlag__c = true;
            extension.application.ProofOfPaymentFlag__c = true;
            extension.application.ProofOfClearVehicleOwnershipFlag__c = true;
            extension.application.CoOwnershipOfSecurityAuthorityFlag__c = true;
            extension.savePreference();
        Test.StopTest();

        Application__c updatedApplication = [SELECT MarriageCertificateFlag__c, 
        											NameChangeDocumenationFlag__c, 
        											CreditCardStatementFlag__c, 
        											CreditReferenceFlag__c, 
        											ProofOfPaymentOfDefaultFlag__c, 
        											ProofOfPaymentFlag__c, 
        											ProofOfClearVehicleOwnershipFlag__c, 
        											CoOwnershipOfSecurityAuthorityFlag__c 
        									 FROM 	Application__c
        									 WHERE 	Id =: testApplication.Id];

        System.assertEquals(true, updatedApplication.MarriageCertificateFlag__c);
        System.assertEquals(true, updatedApplication.NameChangeDocumenationFlag__c);
        System.assertEquals(true, updatedApplication.CreditCardStatementFlag__c);
        System.assertEquals(true, updatedApplication.CreditReferenceFlag__c);
        System.assertEquals(true, updatedApplication.ProofOfPaymentOfDefaultFlag__c);
        System.assertEquals(true, updatedApplication.ProofOfPaymentFlag__c);
        System.assertEquals(true, updatedApplication.ProofOfClearVehicleOwnershipFlag__c);
        System.assertEquals(true, updatedApplication.CoOwnershipOfSecurityAuthorityFlag__c);
    }
}