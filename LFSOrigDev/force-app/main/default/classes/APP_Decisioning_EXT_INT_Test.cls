/*
 * @Description: Test class for APP_Decisioning_EXT_INT class
 * @Author: August Del Rosario
 * @Date Created: Jan-30-2014
 * @History:
   =====================================================================
       28-01-14: Created - August
   =====================================================================
 */

@isTest
private class APP_Decisioning_EXT_INT_Test {

    static testMethod void constructorWithValues() {
    	
    	Application__c testApplication = TestDataBuilder.createApplication();
    	insert testApplication;
 
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
   	
    	List<Decision__c> decisionList = new List<Decision__c>();
    	Decision__c testDecision = new Decision__c();
    	testDecision.Application__c = testApplication.Id;
    	decisionList.Add(testDecision);
    	insert decisionList;
    	
    	Test.startTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_Decisioning_EXT_INT decisioningExInt = new APP_Decisioning_EXT_INT(standardCon);
            decisioningExInt.decList = decisionList;
			
        Test.stopTest();

        System.assert(!decisioningExInt.decList.isEmpty());
        System.assert(!decisioningExInt.manualAction);
    }

    static testMethod void testMethodforSysWrapper(){
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Description__c = 'Looooooooooooooooooooong test Response_Description__c';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        List<Decision__c> decisionList = new List<Decision__c>();
        Decision__c testDecision = new Decision__c();
        testDecision.Application__c = testApplication.Id;
        decisionList.Add(testDecision);
        insert decisionList;
        
        Test.startTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_Decisioning_EXT_INT decisioningExInt = new APP_Decisioning_EXT_INT(standardCon);
            decisioningExInt.getSysWrap();
            
        Test.stopTest();
        
        System.assert(decisioningExInt.decList.isEmpty());
        System.assert(!decisioningExInt.manualAction);
    }

    static testMethod void testMethodManualApproveApp(){
	
		createSandMCustomSettings();
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Description__c = 'Looooooooooooooooooooong test Response_Description__c';
        testApplication.Response_Code__c = 'SCR';
        testApplication.Out_Of_Sync__c=false;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        List<Decision__c> decisionList = new List<Decision__c>();
        Decision__c testDecision = new Decision__c();
        testDecision.Application__c = testApplication.Id;
        decisionList.Add(testDecision);
        insert decisionList;
        
        Test.startTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_Decisioning_EXT_INT decisioningExInt = new APP_Decisioning_EXT_INT(standardCon);
            decisioningExInt.approveApplication();
            
        Test.stopTest();
        
        System.assert(decisioningExInt.decList.isEmpty());
        System.assert(!decisioningExInt.manualAction);
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