/*
 * @Description: Test class for Customer Search and Account Search Service
 * @Author: Dan Crisologo
 * @Date Created: MAR-18-2014
 * @History:
   =====================================================================
       18-03-14: Created - Dan
   =====================================================================
 */

@isTest
public class WS_CustomerSearch_Test {

    static testMethod void testSuccessfulCustomerSearch() {
        createSandMCustomSettings();
        Applicant_Search__c appSearch = new Applicant_Search__c(Account_Number__c = '1234567890123456',
                                                                Date_of_Birth__c = '2014-12-12',
                                                                Status__c = 'Request Sent');
        
        insert appSearch;
        
        Test.startTest();
        
        List<IS_ValidationError> valErrors = IS_CustomerSearch.customerSearchService(appSearch.Id, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,false);
        WS_CustomerSearch CS =  new WS_CustomerSearch(true);
        IS_WebserviceResponseDTO WSRDTO = CS.customerSearchAndMatch(appSearch,'Online',false);           
        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);

        Test.stopTest();
    }
    
    static testMethod void testSuccessfulAccountSearch() {
        createSandMCustomSettings();
        Applicant_CLV__c appCLV = new Applicant_CLV__c(GE_Contact_ID__c = '1234567890123456');
        
        insert appCLV;
        
        Set<Id> clvIds = new Set<Id>();
        clvIds.add(appCLV.Id);
        
        Test.startTest();
        
        List<IS_ValidationError> valErrors = IS_CustomerSearch.customerAccountSearchService(clvIds, true, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);

        //We cannot simulate the callout itself but flow should be smooth and no error should return. 
        System.assertEquals(valErrors.isEmpty(), true);
        Test.stopTest();
    }
    
    private static void createSandMCustomSettings() {
        List<Web_Service_Settings__c> wss = new List<Web_Service_Settings__c>();
        wss.add(new Web_Service_Settings__c(Name ='Application Service Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OASS'));
        wss.add(new Web_Service_Settings__c(Name ='Certificate Name',
                                            Value__c = 'GE_TEST_CERT'));
        wss.add(new Web_Service_Settings__c(Name ='Customer Search Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OCSS'));
        wss.add(new Web_Service_Settings__c(Name ='Generate Document Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OGDS'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Main Business Unit',
                                            Value__c = 'GE-TESTBU'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Mock Enabled Requested By',
                                            Value__c = 'SFDC_TEST1'));   
        wss.add(new Web_Service_Settings__c(Name ='General WS Timeout',
                                            Value__c = '10000'));
        wss.add(new Web_Service_Settings__c(Name ='Product Code Override - VIC',
                                            Value__c = '111'));                                                                        
        wss.add(new Web_Service_Settings__c(Name ='Requested By',
                                            Value__c = 'SFDC_TEST2'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name',
                                            Value__c = 'RequestedNameTest'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name Customer',
                                            Value__c = 'CustomerUI'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name Sales',
                                            Value__c = 'SalesUI'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Service Version',
                                            Value__c = '0.0'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Broker',
                                            Value__c = 'AA1'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Customer',
                                            Value__c = 'AA2'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Sales',
                                            Value__c = 'AA3'));                                                                        
        wss.add(new Web_Service_Settings__c(Name ='Sub-Business Unit',
                                            Value__c = 'SubBusinessTest')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service App Submit',
                                            Value__c = 'TEST_CLASS')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service Customer Search',
                                            Value__c = 'TEST_CLASS2')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service Doc Generation',
                                            Value__c = 'TEST_CLASS2')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Base Endpoint',
                                            Value__c = 'http://endpoint2.testurl.test:port/')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Application',
                                            Value__c = 'oass')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Customer Search',
                                            Value__c = 'ocss')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Documents',
                                            Value__c = 'odgs'));
        wss.add(new Web_Service_Settings__c(Name ='Retrieve Payoff Figure Endpoint',
                                            Value__c = 'http://endpoint2.testurl.test:port/'));
        wss.add(new Web_Service_Settings__c(Name ='Target Service Retrieve Payoff Figure',
                                            Value__c = 'http://endpoint2.testurl.test:port/'));
        
        insert wss;
    }

}