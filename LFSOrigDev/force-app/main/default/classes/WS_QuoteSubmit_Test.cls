/*
 * @Description: Test class for Quote Submit service
 * @Author: Madhusudhan Seethala
 * @Date Created: Mar-31-2020

   =====================================================================

 */

@isTest
public class WS_QuoteSubmit_Test {
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



    
    static testMethod void testQuoteSubmit() {
        TestDataBuilder.IsTestFlag = true;
       
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
      
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Quote_Privacy_Consent__c = true;
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        insert quoteObj;
        
                
               
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
         /*Web_Service_Settings__c wssVar27 = TestDataBuilder.createWebServiceSettings('Target Service Doc Generation', 'GE_DOC_GEN');
        insert wssVar27;
        Web_Service_Settings__c wssVar28 = TestDataBuilder.createWebServiceSettings('Target Service Retrieve Payoff Figure', 'GE_PAYOFF_QUOTE');
        insert wssVar28;
        Web_Service_Settings__c wssVar29 = TestDataBuilder.createWebServiceSettings('General WS Timeout', '60000');
        insert wssVar23;
         Web_Service_Settings__c wssVar24 = TestDataBuilder.createWebServiceSettings('Service Version', '1.0');
        insert wssVar24;*/
       
        Test.startTest();
        List<IS_ValidationError> valErrors= IS_QuoteSubmitUpdate.quoteSubmitRequest(quoteObj.Id,true,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
       
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    static testMethod void testQuoteSubmitNZ() {
        TestDataBuilder.IsTestFlag = true;
       
        //Get Record Type for NZ
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'NZ' AND sObjectType = 'Quote__c'];

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        //Create Quote                                    
      
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Auto Purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'NZ';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0238484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = 'er425315';
        quoteObj.Driver_s_License_Version__c ='443';
        quoteObj.Driver_s_License_Issue_Date__c='10/10/2010';
        quoteObj.Driver_s_License_Expiry_Date__c='10/10/2030';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_City__c= 'Auckland';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'New Zealand';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'Net Salary/Wages';
        quoteObj.Occupation__c = 'Assistant';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='GEM Personal Loan';
        quoteObj.Quote_Privacy_Consent__c = true;
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
          quoteObj.Consent_For_Soft_Enquiry__c = true;
        insert quoteObj;
        
        
        
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
         /*Web_Service_Settings__c wssVar27 = TestDataBuilder.createWebServiceSettings('Target Service Doc Generation', 'GE_DOC_GEN');
        insert wssVar27;
        Web_Service_Settings__c wssVar28 = TestDataBuilder.createWebServiceSettings('Target Service Retrieve Payoff Figure', 'GE_PAYOFF_QUOTE');
        insert wssVar28;
        Web_Service_Settings__c wssVar29 = TestDataBuilder.createWebServiceSettings('General WS Timeout', '60000');
        insert wssVar23;
         Web_Service_Settings__c wssVar24 = TestDataBuilder.createWebServiceSettings('Service Version', '1.0');
        insert wssVar24;*/
       
        Test.startTest();
        List<IS_ValidationError> valErrors= IS_QuoteSubmitUpdate.quoteSubmitRequest(quoteObj.Id,true,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
       
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    
        static testMethod void testQuoteException() {
        
       
        
        TestDataBuilder.IsTestFlag = true;
       
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        //Create Quote                                    
      
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Quote_Privacy_Consent__c = true;
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
          quoteObj.Consent_For_Soft_Enquiry__c = true;
        insert quoteObj;
        
        
        
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
      
       
        Test.startTest();
        List<IS_ValidationError> valErrors= IS_QuoteSubmitUpdate.quoteSubmitRequest(quoteObj.Id,true,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
       
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    
    static testMethod void testQuoteExcn() {
        TestDataBuilder.IsTestFlag = false;
       
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];

         Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
      
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Online';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
       quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Quote_Privacy_Consent__c = true;
       quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        insert quoteObj;
        
       
        
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
       
        List<IS_ValidationError> valErrors= IS_QuoteSubmitUpdate.quoteSubmitRequest(quoteObj.Id,true,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
       
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
         
    }
    
     static testMethod void testQuoteBroker() {
        TestDataBuilder.IsTestFlag = false;
        List<RecordType> recordTypeConatctList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'APAC_Contact' AND sObjectType = 'Contact'];
                                               
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.RecordTypeId = recordTypeConatctList[0].Id;
        insert testBroker;
        Contact broker = [SELECT Broker_ID__c FROM Contact WHERE Id =: testBroker.Id LIMIT 1];
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
         Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;                                            

        //Create Quote                                    
     
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'Broker';
        quoteObj.Region__c = 'AU';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Title__c = 'Mr';
        quoteObj.First_Name__c = 'Larry';
        quoteObj.Middle_Name__c = 'J';
        quoteObj.Last_Name__c = 'Smith';
        quoteObj.Date_of_Birth__c = '18/08/1976';
        quoteObj.Gender__c = 'Male';
        quoteObj.Mobile_Number__c = '0438484484';
        quoteObj.Email_ID__c = 'asd@zz.com';
        quoteObj.Driver_s_Licence_Number__c = '65435778';
        quoteObj.Residential_Street_Number__c = '110';
        quoteObj.Residential_Street_Name__c = 'City Road';
        quoteObj.Residential_Street_Type__c = 'Road';
        quoteObj.Residential_Suburb__c = 'Southbank';
        quoteObj.Residential_State__c = 'VIC';
        quoteObj.Residential_Postcode__c = '3006';
        quoteObj.Residential_Country__c = 'Australia';
        quoteObj.Years_at_Residential_Address__c = 3;
        quoteObj.Months_at_Residential_Address__c = 4;
        quoteObj.Income_Source__c = 'My permanent - full time job';
        quoteObj.Occupation__c = 'Civil Service';
        quoteObj.Years_at_Current_Employment__c = 2;
        quoteObj.Months_at_Current_Employment__c = 2;
        quoteObj.Residential_Status__c = 'Renting';
        quoteObj.Product__c='Latitude Personal Loan';
        quoteObj.Quote_Privacy_Consent__c = true;
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Broker_ID__c =broker.Broker_ID__c;
        
        quoteObj.Brokerage_Fee__c =100;
        insert quoteObj;
        
       
        
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
       
        List<IS_ValidationError> valErrors= IS_QuoteSubmitUpdate.quoteSubmitRequest(quoteObj.Id,true,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,null);
       
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
         
    }
 

    
 }