/*
 * @Description: Test class for Quote Partial Submit service
 * @Author: Manoj kumar
 * @Date Created: Sep-09-2020

   =====================================================================

 */

@isTest
public class WS_VerifyCapacityUpdate_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    
     @TestVisible class ResponseMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNs,
            String responseName,
            String responseType
        ) {
            CalloutException e = new CalloutException();
            e.setMessage('Validation Error(s) occurred during Foo Get.');
            throw e;
             
        }
    }   
    static testMethod void testQuoteBroker() {
        TestDataBuilder.IsTestFlag = false;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
       GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;
         
        
         // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + 'AU' + '-'+ GEN_OriginationsConstants.OFFLINE_ACCEPTANCE;

        system.debug('Own Key 1' + country_channel_Key);
        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;
        Web_Service_Settings__c wssVar1 = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        insert wssVar1;
        Web_Service_Settings__c wssVar2 = TestDataBuilder.createWebServiceSettings('Mock Enabled Requested By', 'Salesforce PROD');
        insert wssVar2;
        
         Web_Service_Settings__c wssVar3 = TestDataBuilder.createWebServiceSettings('Main Business Unit', 'GE-CAPITAL');
        insert wssVar3;
        Web_Service_Settings__c wssVar4 = TestDataBuilder.createWebServiceSettings('Sub-Business Unit', 'LOAN');
        insert wssVar4;
        Web_Service_Settings__c wssVar5 = TestDataBuilder.createWebServiceSettings('Target Service App Submit', 'GE_LOAN_ORIG');
        insert wssVar5;
         Web_Service_Settings__c wssVar6 = TestDataBuilder.createWebServiceSettings('Target Service Customer Search', 'GE_CUST_SEARCH');
        insert wssVar6;
        Web_Service_Settings__c wssVar7 = TestDataBuilder.createWebServiceSettings('Certificate Name', 'LFS_WS_Cert_DEV1_2019');
        insert wssVar7;
        Web_Service_Settings__c wssVar8 = TestDataBuilder.createWebServiceSettings('Application Service Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/CreditApplication/OriginationApplicationService');
        insert wssVar8;
       
        Web_Service_Settings__c wssVar10 = TestDataBuilder.createWebServiceSettings('Target Service Customer Search', 'GE_CUST_SEARCH');
        insert wssVar10;
        Web_Service_Settings__c wssVar11 = TestDataBuilder.createWebServiceSettings('Customer Search Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/CustomerSearchService/CustomerSearchService');
        insert wssVar11;
        Web_Service_Settings__c wssVar12 = TestDataBuilder.createWebServiceSettings('Generate Document Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/PLDocManagement/PLDocManagementService');
        insert wssVar12;
        Web_Service_Settings__c wssVar13 = TestDataBuilder.createWebServiceSettings('Retrieve Payoff Figure Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/PayOffQuote/PayOffQuoteService');
        insert wssVar13;
        Web_Service_Settings__c wssVar14 = TestDataBuilder.createWebServiceSettings('Webservice Base Endpoint', ' https://hookb.in/');
        insert wssVar14;
        Web_Service_Settings__c wssVar15 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Application', 'KlOMy6Wb');
        insert wssVar15;
        Web_Service_Settings__c wssVar16 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Customer Search', 'KlOMy6Wb');
        insert wssVar16;
         Web_Service_Settings__c wssVar17 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Documents', 'KlOMy6Wb');
        insert wssVar17;
        Web_Service_Settings__c wssVar18 = TestDataBuilder.createWebServiceSettings('SOLCode Sales', 'BU1');
        insert wssVar18;
        Web_Service_Settings__c wssVar19 = TestDataBuilder.createWebServiceSettings('SOLCode Customer', 'BD1');
        insert wssVar19;
        Web_Service_Settings__c wssVar20 = TestDataBuilder.createWebServiceSettings('SOLCode Broker', 'BU1');
        insert wssVar20;
         Web_Service_Settings__c wssVar21 = TestDataBuilder.createWebServiceSettings('Target Service Doc Generation', 'GE_DOC_GEN');
        insert wssVar21;
        Web_Service_Settings__c wssVar22 = TestDataBuilder.createWebServiceSettings('Target Service Retrieve Payoff Figure', 'GE_PAYOFF_QUOTE');
        insert wssVar22;
        Web_Service_Settings__c wssVar23 = TestDataBuilder.createWebServiceSettings('General WS Timeout', '60000');
        insert wssVar23;
         Web_Service_Settings__c wssVar24 = TestDataBuilder.createWebServiceSettings('Service Version', '1.0');
        insert wssVar24;
        Web_Service_Settings__c wssVar25 = TestDataBuilder.createWebServiceSettings('200', 'Your document has been sent.');
        insert wssVar25;
        Web_Service_Settings__c wssVar26 = TestDataBuilder.createWebServiceSettings('Product Code Override - VIC', '200');
        insert wssVar26;
        
        Test.setMock(WebServiceMock.class, new ResponseMock());
       
        Test.startTest();
        List<IS_ValidationError> valErrors = IS_verifyCapacityUpdate.verifyCapacityRequest(testApplication.Id,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,true,null);

       
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
         
    }
    
    static testMethod void testQuoteException() {       
       
        
        TestDataBuilder.IsTestFlag = true;
        
         Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
       
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;
        // Create web service setting
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + 'AU' + '-'+ GEN_OriginationsConstants.OFFLINE_ACCEPTANCE;

        system.debug('Own Key 1' + country_channel_Key);
        Web_Service_Settings__c wssVar = TestDataBuilder.createWebServiceSettings(country_channel_Key, 'BU1');
        insert wssVar;
        Web_Service_Settings__c wssVar1 = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        insert wssVar1;
        Web_Service_Settings__c wssVar2 = TestDataBuilder.createWebServiceSettings('Mock Enabled Requested By', 'Salesforce PROD');
        insert wssVar2;
        
         Web_Service_Settings__c wssVar3 = TestDataBuilder.createWebServiceSettings('Main Business Unit', 'GE-CAPITAL');
        insert wssVar3;
        Web_Service_Settings__c wssVar4 = TestDataBuilder.createWebServiceSettings('Sub-Business Unit', 'LOAN');
        insert wssVar4;
        Web_Service_Settings__c wssVar5 = TestDataBuilder.createWebServiceSettings('Target Service App Submit', 'GE_LOAN_ORIG');
        insert wssVar5;
         Web_Service_Settings__c wssVar6 = TestDataBuilder.createWebServiceSettings('Target Service Customer Search', 'GE_CUST_SEARCH');
        insert wssVar6;
        Web_Service_Settings__c wssVar7 = TestDataBuilder.createWebServiceSettings('Certificate Name', 'LFS_WS_Cert_DEV1_2019');
        insert wssVar7;
        Web_Service_Settings__c wssVar8 = TestDataBuilder.createWebServiceSettings('Application Service Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/CreditApplication/OriginationApplicationService');
        insert wssVar8;
       
        Web_Service_Settings__c wssVar10 = TestDataBuilder.createWebServiceSettings('Target Service Customer Search', 'GE_CUST_SEARCH');
        insert wssVar10;
        Web_Service_Settings__c wssVar11 = TestDataBuilder.createWebServiceSettings('Customer Search Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/CustomerSearchService/CustomerSearchService');
        insert wssVar11;
        Web_Service_Settings__c wssVar12 = TestDataBuilder.createWebServiceSettings('Generate Document Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/PLDocManagement/PLDocManagementService');
        insert wssVar12;
        Web_Service_Settings__c wssVar13 = TestDataBuilder.createWebServiceSettings('Retrieve Payoff Figure Endpoint', 'https://sf2geservices-dev1.sandbox.latitudefinancial.com.au/PayOffQuote/PayOffQuoteService');
        insert wssVar13;
        Web_Service_Settings__c wssVar14 = TestDataBuilder.createWebServiceSettings('Webservice Base Endpoint', ' https://hookb.in/');
        insert wssVar14;
        Web_Service_Settings__c wssVar15 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Application', 'KlOMy6Wb');
        insert wssVar15;
        Web_Service_Settings__c wssVar16 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Customer Search', 'KlOMy6Wb');
        insert wssVar16;
         Web_Service_Settings__c wssVar17 = TestDataBuilder.createWebServiceSettings('Webservice Endpoint - Documents', 'KlOMy6Wb');
        insert wssVar17;
        Web_Service_Settings__c wssVar18 = TestDataBuilder.createWebServiceSettings('SOLCode Sales', 'BU1');
        insert wssVar18;
        Web_Service_Settings__c wssVar19 = TestDataBuilder.createWebServiceSettings('SOLCode Customer', 'BD1');
        insert wssVar19;
        Web_Service_Settings__c wssVar20 = TestDataBuilder.createWebServiceSettings('SOLCode Broker', 'BU1');
        insert wssVar20;
         Web_Service_Settings__c wssVar21 = TestDataBuilder.createWebServiceSettings('Target Service Doc Generation', 'GE_DOC_GEN');
        insert wssVar21;
        Web_Service_Settings__c wssVar22 = TestDataBuilder.createWebServiceSettings('Target Service Retrieve Payoff Figure', 'GE_PAYOFF_QUOTE');
        insert wssVar22;
        Web_Service_Settings__c wssVar23 = TestDataBuilder.createWebServiceSettings('General WS Timeout', '60000');
        insert wssVar23;
         Web_Service_Settings__c wssVar24 = TestDataBuilder.createWebServiceSettings('Service Version', '1.0');
        insert wssVar24;
        Web_Service_Settings__c wssVar25 = TestDataBuilder.createWebServiceSettings('200', 'Your document has been sent.');
        insert wssVar25;
        Web_Service_Settings__c wssVar26 = TestDataBuilder.createWebServiceSettings('Product Code Override - VIC', '200');
        insert wssVar26;
      
       Test.setMock(WebServiceMock.class, new ResponseMock());
       
        Test.startTest();
       
        List<IS_ValidationError> valErrors = IS_verifyCapacityUpdate.verifyCapacityRequest(testApplication.Id,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,true,null);

        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
}