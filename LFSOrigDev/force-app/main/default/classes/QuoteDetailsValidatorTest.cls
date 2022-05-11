@isTest
public with sharing class QuoteDetailsValidatorTest {
    
    @isTest
    static void testQuoteAU(){
               
    
        Test.startTest();
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBroker();
         //Set an invalid date format to trigger a validation error
        quoteList[0].Date_of_Birth__c = '18-09-1980';
        qdv.runCustomValidations(quoteList);
        System.assertEquals('AU', quoteList[0].Region__c);
        quoteList = TestDataBuilder.createQuoteNZOnline();
        //Set an invalid date format to trigger a validation error
        quoteList[0].Driver_s_License_Issue_Date__c = '18-09-2020';
        quoteList[0].Driver_s_License_Expiry_Date__c = '18-09-2030';
        qdv.runCustomValidations(quoteList);
        System.assertEquals('NZ', quoteList[0].Region__c);
        
        Test.stopTest();

    }
    
        static testmethod void testQuoteCheck(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;
        
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
         Web_Service_Settings__c wssVar27 = TestDataBuilder.createWebServiceSettings('Requested Name Customer','CustomerUI');
        insert wssVar27;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
       

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        rateCard.Start_Date__c =system.today();
        rateCard.End_Date__c =system.today().AddDays(10);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        rate.Credit_Score__c='AA';
        rate.Principal_Minimum__c =100;
        rate.Principal_Maximum__c=9000;
        insert rate;
        // end

        Rule_Set__c testRuleSet = TestDataBuilder.createPricingRuleSet(testProductVersion.Id);
        insert testRuleSet;

        Rule__c testRule = new Rule__c(Rate_Card__c=rateCard.Id,Rule_Set__c=testRuleSet.Id,IsActive__c=true,name='Unsecured Sales Pricing');
        insert testRule;
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
         List<Quote__c> quoteList = TestDataBuilder.createQuoteAUOnline();
         insert quoteList;
         Quote_Product_Item__c testProductItem = new Quote_Product_Item__c(Quote__c=quoteList[0].Id, Product_Version__c=testProductVersion.Id);
        insert testProductItem;
    
        Test.startTest();
        QuoteDetailsValidator qdv = new QuoteDetailsValidator();
       
        
        qdv.checkCreditScore(quoteList);
        qdv.createQuoteProductLineItems(quoteList);
        qdv.invokeQuoteSubmit(quoteList);
        Test.stopTest();

    }
 

}