@isTest
public class WS_SoftQuoteBrokerValidation_Test {
    
    static testMethod void BrokerValid_Test() {
    
        
     //Prepare Quote Data
     TestDataBuilder.IsTestFlag = true;
       Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'Soft Quote Org Enabled';
        as1.Value__c = 'true';
        insert as1;
       Contact BrokerContact= TestDataBuilder.createBrokerRecord();
       insert BrokerContact;
       Contact checkSOQL = [Select Id, Name, Broker_ID__c From Contact];
       
        system.debug('check'+checkSOQL);
        system.debug('check broker Id'+checkSOQL.Broker_ID__c);
        
        WS_SoftQuoteBrokerValidation.brokerQuoteWrapper brokerWrap= new WS_SoftQuoteBrokerValidation.brokerQuoteWrapper();
        brokerWrap.brokerID=checkSOQL.Broker_ID__c;
        
        String myJSON = JSON.serialize(brokerWrap);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.RequestURI='https://gecapitalanz--OrigDEV.my.salesforce.com/services/apexrest/api/SoftQuoteBroker/*';
        req.HttpMethod ='POST';
        req.headers.put('Content-Type', 'application/json');
        req.requestBody= Blob.valueof(myJSON);
        Test.StartTest();
        RESTContext.request = req;
       RESTContext.response= res;
         WS_SoftQuoteBrokerValidation.checkBrokerID();
       
       Test.StopTest();
    }
    static testMethod void BrokerInValid_Test() {
    
        
     //Prepare Quote Data
     TestDataBuilder.IsTestFlag = true;
     
       Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'Soft Quote Org Enabled';
        as1.Value__c = 'true';
        insert as1;
        
       Contact BrokerContact= TestDataBuilder.createBrokerRecord();
               
        WS_SoftQuoteBrokerValidation.brokerQuoteWrapper brokerWrap= new WS_SoftQuoteBrokerValidation.brokerQuoteWrapper();
        brokerWrap.brokerID='121333';
        
        String myJSON = JSON.serialize(brokerWrap);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.RequestURI='https://gecapitalanz--OrigDEV.my.salesforce.com/services/apexrest/api/SoftQuoteBroker/*';
        req.HttpMethod ='POST';
        req.headers.put('Content-Type', 'application/json');
        req.requestBody= Blob.valueof(myJSON);
        Test.StartTest();
        RESTContext.request = req;
       RESTContext.response= res;
         WS_SoftQuoteBrokerValidation.checkBrokerID();
       
       Test.StopTest();
    }
     static testMethod void BrokerEmpty_Test() {
    
        
     //Prepare Quote Data
     TestDataBuilder.IsTestFlag = true;
     
       Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'Soft Quote Org Enabled';
        as1.Value__c = 'true';
        insert as1;
        
       Contact BrokerContact= TestDataBuilder.createBrokerRecord();
               
        WS_SoftQuoteBrokerValidation.brokerQuoteWrapper brokerWrap= new WS_SoftQuoteBrokerValidation.brokerQuoteWrapper();
        brokerWrap.brokerID='';
        
        String myJSON = JSON.serialize(brokerWrap);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.RequestURI='https://gecapitalanz--OrigDEV.my.salesforce.com/services/apexrest/api/SoftQuoteBroker/*';
        req.HttpMethod ='POST';
        req.headers.put('Content-Type', 'application/json');
        req.requestBody= Blob.valueof(myJSON);
        Test.StartTest();
        RESTContext.request = req;
       RESTContext.response= res;
         WS_SoftQuoteBrokerValidation.checkBrokerID();
       
       Test.StopTest();
    }
         static testMethod void BrokerFalse_Test() {
    
        
     //Prepare Quote Data
     TestDataBuilder.IsTestFlag = true;
     
       Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'Soft Quote Org Enabled';
        as1.Value__c = 'false';
        insert as1;
        
       Contact BrokerContact= TestDataBuilder.createBrokerRecord();
               
        WS_SoftQuoteBrokerValidation.brokerQuoteWrapper brokerWrap= new WS_SoftQuoteBrokerValidation.brokerQuoteWrapper();
        brokerWrap.brokerID='';
        
        String myJSON = JSON.serialize(brokerWrap);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.RequestURI='https://gecapitalanz--OrigDEV.my.salesforce.com/services/apexrest/api/SoftQuoteBroker/*';
        req.HttpMethod ='POST';
        req.headers.put('Content-Type', 'application/json');
        req.requestBody= Blob.valueof(myJSON);
        Test.StartTest();
        RESTContext.request = req;
       RESTContext.response= res;
         WS_SoftQuoteBrokerValidation.checkBrokerID();
       
       Test.StopTest();
    }
      
}