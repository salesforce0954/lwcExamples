@isTest
public class APP_WaitPageExt_Test {

    static testMethod void constructorGE_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        Brand_Content__c testBrandContent = new Brand_Content__c();
        testBrandContent.Name = 'APP_SubmitWait';
        testBrandContent.Brand__c = testBrand.Id;
        testBrandContent.Output_HTML__c = 'Test';
        insert testBrandContent;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('ResponseTimeOut', '50');
        insert testWebServiceSettings;

        Test.StartTest();
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_WaitPageExt wait = new APP_WaitPageExt(standardCon);
            wait.checkApplicationDetails();
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, wait.applicationId);
        System.assertEquals(testWebServiceSettings.Value__c, wait.timeoutSettings);
        System.assertEquals('#3a73ba', wait.titleStyle);
        System.assertEquals(testBrandContent.Output_HTML__c, wait.marketingContent);
    }

    static testMethod void constructorAussie_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_AUSSIE;
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        Brand_Content__c testBrandContent = new Brand_Content__c();
        testBrandContent.Name = 'APP_SubmitWait';
        testBrandContent.Brand__c = testBrand.Id;
        insert testBrandContent;

        Test.StartTest();
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_WaitPageExt wait = new APP_WaitPageExt(standardCon);
            wait.checkApplicationDetails();
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, wait.applicationId);
        System.assertEquals('45', wait.timeoutSettings);
        System.assertEquals('#711371', wait.titleStyle);
        System.assertEquals('', wait.marketingContent);
    }

    static testMethod void redirect_Test() {

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        //BEGIN MLASALA: 08-FEB-16 TQLQW-20 Templates & Configuration
        //Portal redesign. Redirect to new post submit page
        PageReference postSubmitPage = Page.APP_Main_PostSubmit;
        //PageReference postSubmitPage = Page.APP_GSD_Response;
        //END MLASALA: 08-FEB-16 TQLQW-20 Templates & Configuration
        
        Test.StartTest();
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_WaitPageExt wait = new APP_WaitPageExt(standardCon);
            PageReference redirectPage = wait.proceedToPostSubmit();
        Test.StopTest();
        
        System.assertEquals(true, String.valueOf(redirectPage.getURL()).contains(String.valueOf(postSubmitPage.getURL())));
        System.assertEquals(testApplication.Id, wait.applicationId);
        System.assertEquals('45', wait.timeoutSettings);
    }
    
    static testMethod void postSubmitResponseTest() {
        Admin_Settings__c gsd = new Admin_Settings__c(Name = 'GSD Enabled', 
                                                      Value__c = 'TRUE');
        insert gsd;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;

        PageReference postSubmitPage = Page.APP_GSD_Response;
        
        Test.StartTest();
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_WaitPageExt wait = new APP_WaitPageExt(standardCon);
            PageReference redirectPage = wait.proceedToPostSubmit();
        Test.StopTest();
        
        System.assertEquals(true, String.valueOf(redirectPage.getURL()).contains(String.valueOf(postSubmitPage.getURL())));
        System.assertEquals(testApplication.Id, wait.applicationId);
        System.assertEquals('45', wait.timeoutSettings);
    }
    
    static testMethod void postSubmitOfferTest() {
        Admin_Settings__c gsd = new Admin_Settings__c(Name = 'GSD Enabled', 
                                                      Value__c = 'TRUE');
        insert gsd;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'PAO';
        testApplication.Credit_Score__c = 'E';
        testApplication.Higher_Approval_Consent__c = true;
        testApplication.Total_Loan_Amount__c = 5000;
        testApplication.Max_Capacity_Unsecured__c = 7500;
        testApplication.Offered_Interest_Rate__c = 31.99;
        testApplication.Max_Monthly_Capacity__c = 7000;
        testApplication.EMI_with_Service_Fee__c = 285.22;
        testApplication.Insurance_Eligibility_Flag_Applicant_1__c = 3;
        testApplication.Online_Self_serve_Upsell_Eligibility__c = true;
        testApplication.Online_Self_serve_Insurance_Eligibility__c = true;
        insert testApplication;

        PageReference postSubmitPage = Page.APP_GSD_Upsell_Insurance;
        
        Test.StartTest();
            ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_WaitPageExt wait = new APP_WaitPageExt(standardCon);
            PageReference redirectPage = wait.proceedToPostSubmit();
        Test.StopTest();
        
        // System.assertEquals(true, String.valueOf(redirectPage.getURL()).contains(String.valueOf(postSubmitPage.getURL())));
        System.assertEquals(testApplication.Id, wait.applicationId);
        System.assertEquals('45', wait.timeoutSettings);
    }
}