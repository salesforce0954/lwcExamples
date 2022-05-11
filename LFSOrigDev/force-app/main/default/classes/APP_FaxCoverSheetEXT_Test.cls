@isTest
public class APP_FaxCoverSheetEXT_Test{

    static testMethod void FaxCoverSheet_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.URL_Customer_Portal_Login__c = 'test';
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        Test.StartTest();
            ApexPages.currentPage().getParameters().put('id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_FaxCoverSheetEXT fax = new APP_FaxCoverSheetEXT(standardCon);
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, fax.application.Id);
        System.assertEquals(testApplication.Id, fax.applicationId);
    }
}