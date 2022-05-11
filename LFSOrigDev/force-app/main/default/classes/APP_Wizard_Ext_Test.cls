@isTest
public class APP_Wizard_Ext_Test {
    @testSetup static void staticRecords(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
    }
    static testMethod void construtor_Test(){
        Test.StartTest();
        APP_Wizard_Ext wizard = new APP_Wizard_Ext();
        Test.StopTest();
        
        System.assertEquals(wizard.IPAddress, ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
    }

    static testMethod void submit_Test(){
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        Test.StartTest();
            List<IS_ValidationError> validationList = APP_Wizard_Ext.submitApplicaton(applicationBuilder.application.Id);

            try{
                APP_Wizard_Ext.addApplicationResponseTopic();
            } catch(DmlException e){
                //For some reason, existing PushTopic is seen without @isTest(SeeAllData=false)
                System.assert( e.getMessage().contains('A PushTopic with this name already exists'), e.getMessage());
            }

            System.assertEquals(validationList.isEmpty(), true);
        Test.StopTest();
    }
    
    static testMethod void linkQuote_Test(){
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        insert testAdminSettings;
        //Get Record Type for AU
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType
                                            WHERE DeveloperName = 'AU' AND sObjectType = 'Quote__c'];
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='Both';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
     
        Quote__c quoteObj = new Quote__c();
        quoteObj.RecordTypeId = recordTypeList[0].Id;
        quoteObj.Loan_Amount__c = 8000;
        quoteObj.Loan_Term__c = '3 years';
        quoteObj.Loan_Purpose__c = 'Car purchase';
        quoteObj.Channel__c = 'online';
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
        //quoteObj.Product__c='GEM Personal Loan';
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        //quoteObj.Broker_ID__c =broker.Broker_ID__c;
                quoteObj.Quote_Rate__c =2;
        quoteObj.Brokerage_Fee__c = 10; 
        quoteObj.Quote_Privacy_Consent__c = true;
        insert quoteObj;
        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);
        
        Application__c objApp = new Application__c();
        objApp.id = applicationBuilder.application.Id;
        objApp.Brand_String__c ='Latitude';
        update objApp;
        
        Test.setCurrentPageReference(new PageReference('Page.APP_Wizard')); 
        System.currentPageReference().getParameters().put('qid', quoteObj.id);
        
        Test.StartTest();
            APP_Wizard_Ext wizard = new APP_Wizard_Ext();
            APP_Wizard_Ext.linkQuoteToApplicaton(objApp.Id,quoteObj.Id);
            List<IS_ValidationError> validationList = APP_Wizard_Ext.submitApplicaton(applicationBuilder.application.Id);

            try{
                
            } catch(DmlException e){
                //For some reason, existing PushTopic is seen without @isTest(SeeAllData=false)
                System.assert( e.getMessage().contains('A PushTopic with this name already exists'), e.getMessage());
            }

            System.assertEquals(validationList.isEmpty(), true);
        Test.StopTest();
    }
}