@isTest
public class BrokerSubmittedEntities_Test {
    private static final String EXTRENAL_APP_ID_VALID = 'XAppId';
    private static final String EXTRENAL_SECURITY_TOKEN = 'stoken';
    
    @testSetup static void makeData() {
        insert TestDataBuilder.createResponseCodeControlPA();
        insert TestDataBuilder.createBSBList();
        Response_Code_Control__c setting = new Response_Code_Control__c();
        setting.Name = 'PA';
        setting.Save_Debit_Standard__c = true;
        setting.Save_Disbursement_Standard__c = true;
        insert setting;   
    }
    
    
    static testMethod void QuoteBroker_Test() {
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;

                List<RecordType> recordTypeConatctList = [SELECT Id 
                                             FROM RecordType
                                            WHERE DeveloperName = 'APAC Contact' AND sObjectType = 'Contact'];
                                               
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        //testBroker.RecordTypeId = recordTypeConatctList[0].Id;
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
        quoteObj.Last_Webservice_Operation_Status__c='Not Submitted';
        quoteObj.Consent_For_Soft_Enquiry__c = true;
        quoteObj.Broker_ID__c =broker.Broker_ID__c;
        quoteObj.Brokerage_Fee__c = 100;
        quoteObj.Quote_Privacy_Consent__c = true;
        
        insert quoteObj;
        
        
        BrokerSubmittedEntities.getBrokerId();
        BrokerDetailsWrapper bdw = new BrokerDetailsWrapper();
        bdw.brokerId = broker.Broker_ID__c;
        bdw.accessLevel = 'Team View';
        bdw.brokerType = 'APAC_Contact';
        
        BrokerDetailsWrapper bdw1 = new BrokerDetailsWrapper();
        bdw1.brokerId = broker.Broker_ID__c;
        bdw1.accessLevel = 'Team View';
        bdw1.brokerType = 'Broker_Assistants';
        
        BrokerDetailsWrapper bdw2 = new BrokerDetailsWrapper();
        bdw2.brokerId = broker.Broker_ID__c;
        bdw2.accessLevel = 'Individual View';
        bdw2.brokerType = 'Broker_Assistants';
        
        BrokerDetailsWrapper bdw3 = new BrokerDetailsWrapper();
        bdw3.brokerId = broker.Broker_ID__c;
        bdw3.accessLevel = 'Individual View';
        bdw3.brokerType = 'APAC_Contact';
        
        BrokerDetailsWrapper bdw4 = new BrokerDetailsWrapper();
        bdw4.brokerId = broker.Broker_ID__c;
        bdw4.accessLevel = '';
        bdw4.brokerType = 'APAC_Contact';
        
        BrokerDetailsWrapper bdw5 = new BrokerDetailsWrapper();
        bdw5.brokerId = broker.Broker_ID__c;
        bdw5.accessLevel = '';
        bdw5.brokerType = 'Broker_Assistants';
        
        
       BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','0438484484');
        
       BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','0438484484');
        
        BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','0438484484');



   BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','0438484484');
    BrokerSubmittedEntities.getQuotes('1','1','','0438484484');
      BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','');

      BrokerSubmittedEntities.getQuotes('1','1','','0438484484');

     BrokerSubmittedEntities.getQuotes('1','1','asd@zz.com','');


       BrokerSubmittedEntities.getBrokerRecordForPrint(quoteObj.Id,'18/08/1976'); 
        BrokerSubmittedEntities.getBrokerRecordForPrint(quoteObj.Id,'18/07/1976'); 
        BrokerSubmittedEntities.getBrokerRecordForPrint(quoteObj.Id,'18/07/1976'); 
        BrokerSubmittedEntities.getBrokerRecordForPrint(quoteObj.Id,'18/07/1976'); 
        BrokerSubmittedEntities.getBrokerRecordForPrint(quoteObj.Id,'18/07/1976'); 
        BrokerSubmittedEntities.getAppCopyDocument(null,'18/07/1976','Copy of Application',quoteObj.Name);
        BrokerSubmittedEntities.generateQuotePrintablePage(quoteObj.Id);

       
       BrokerSubmittedEntities.getStatusAndEncryptedQuote(quoteObj.Id);
       BrokerSubmittedEntities.getConvertedToAppNotes(quoteObj.Id);
       BrokerSubmittedEntities.createNote(quoteObj.Id);
    }
    
    @isTest
    static void testApplications_1(){
        //APAC & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        insert testBroker;

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        Quote__c quoteObj;
        if(quoteList.size() > 0){
                quoteObj =  quoteList[0];
                insert quoteObj;            
        }
                BrokerSubmittedEntities.getApplications('56554567','Jason Padua');
    }
    @isTest
    static void testApplications_2(){
        //Broker Assistant & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        
        insert testBroker;
        
        Id brokerRecordType = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Broker Assistants').RecordTypeId;
        Contact testNomBroker = TestDataBuilder.createBrokerRecord();
        testNomBroker.RecordTypeID= brokerRecordType;
        testNomBroker.Broker_View_Access__c = 'Individual View';
        testNomBroker.Email = 'testBroker@test.com';
        testNomBroker.Nominated_Broker__c =testBroker.Id;
        insert testNomBroker;

        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        Quote__c quoteObj;
        if(quoteList.size() > 0){
                quoteObj =  quoteList[0];
                insert quoteObj;            
        }
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.UID__c= '34453445345';
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
                BrokerSubmittedEntities.getApplications('34453445345','FirstName Lastname');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','FirstName Lastname');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','FirstNameLastname');
    }
        @isTest
    static void testApplications_3(){
        //Broker Assistant & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        
        insert testBroker;
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        Quote__c quoteObj;
        if(quoteList.size() > 0){
                quoteObj =  quoteList[0];
                insert quoteObj;            
        }
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Contact c= [select id, Broker_ID__c from Contact];
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.UID__c= '34453445345';
        testApplication.Response_Code__c = 'Test';
        testApplication.Broker_ID__c=c.Broker_ID__c;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
                BrokerSubmittedEntities.getApplications('34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','LastnameFirstName');
                BrokerSubmittedEntities.QuoteWrapper qWrap= new BrokerSubmittedEntities.QuoteWrapper ();
                qWrap.quoteStage= 'test';
                qWrap.encryptedQuoteId='awerqwerwqr';
                qWrap.brokerId='svh';
                qWrap.brokerName='adfkh';
                qWrap.emailIdOnQuote='asdkh';
                
    } 

    @isTest
    static void testApplications_4(){
        //Broker Assistant & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        
        insert testBroker;
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        Quote__c quoteObj;
        if(quoteList.size() > 0){
                quoteObj =  quoteList[0];
                insert quoteObj;            
        }
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Contact c= [select id, Broker_ID__c from Contact];

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'PA';
        testApplication.UID__c= '34453445345';
        testApplication.Broker_ID__c=c.Broker_ID__c;
        testApplication.Status__c = 'Referred: Refer to CPU/CMO';
        insert testApplication;

        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(testApplication.Id, null);
        insert lp;

        // create dd and dc
        Schema.DescribeSObjectResult R = Debit__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapDebitRecordType = R.getRecordTypeInfosByDeveloperName();   
        
        R = Disbursement__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapCreditRecordType = R.getRecordTypeInfosByDeveloperName();  
        
        Debit__c directDebit = TestDataBuilder.createDebit(mapDebitRecordType.get('Direct_Debit').getRecordTypeId(), testApplication.Id);
        insert directDebit;

        Disbursement__c directCredit = new Disbursement__c();
        directCredit.Application__c = testApplication.Id;
        directCredit.RecordTypeId = mapCreditRecordType.get('Direct_Credit').getRecordTypeId();
        directCredit.Bank_Acc_No__c = '12312312';
        directCredit.BSB__c = '123456';
        directCredit.Account_Holders__c = 'ABCDS';
        directCredit.Bank_Name__c = 'ATB';
        directCredit.Branch__c='Melbourne';
        insert directCredit;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
                BrokerSubmittedEntities.getApplications('34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','LastnameFirstName');
                BrokerSubmittedEntities.QuoteWrapper qWrap= new BrokerSubmittedEntities.QuoteWrapper ();
                qWrap.quoteStage= 'test';
                qWrap.encryptedQuoteId='awerqwerwqr';
                qWrap.brokerId='svh';
                qWrap.brokerName='adfkh';
                qWrap.emailIdOnQuote='asdkh';
                
    } 

    @isTest
    static void testApplications_5(){
        //Broker Assistant & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        
        insert testBroker;
        
        Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        //Create Quote                                    
        List<Quote__c> quoteList = TestDataBuilder.createQuoteAUBrokerWithBrokerId(testBroker);
        Quote__c quoteObj;
        if(quoteList.size() > 0){
                quoteObj =  quoteList[0];
                insert quoteObj;            
        }
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Contact c= [select id, Broker_ID__c from Contact];

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'PA';
        testApplication.UID__c= '34453445345';
        testApplication.Broker_ID__c=c.Broker_ID__c;
        testApplication.Status__c = 'Referred: Refer to CPU/CMO';
        insert testApplication;

        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(testApplication.Id, null);
        insert lp;

        // create dd and dc
        Schema.DescribeSObjectResult R = Debit__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapDebitRecordType = R.getRecordTypeInfosByDeveloperName();   
        
        R = Disbursement__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> mapCreditRecordType = R.getRecordTypeInfosByDeveloperName();  
        
        Debit__c paymentCard = TestDataBuilder.createDebit(mapDebitRecordType.get('Charge_Card').getRecordTypeId(), testApplication.Id);
        insert paymentCard;

        Disbursement__c cheque = new Disbursement__c();
        cheque.Application__c = testApplication.Id;
        cheque.RecordTypeId = mapCreditRecordType.get('Cheque').getRecordTypeId();
        cheque.Bank_Acc_No__c = '12312312';
        cheque.BSB__c = '123456';
        cheque.Account_Holders__c = 'ABCDS';
        cheque.Bank_Name__c = 'ATB';
        cheque.Branch__c='Melbourne';
        insert cheque;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
                BrokerSubmittedEntities.getApplications('34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','Lastname FirstName');
                BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','LastnameFirstName');
                BrokerSubmittedEntities.QuoteWrapper qWrap= new BrokerSubmittedEntities.QuoteWrapper ();
                qWrap.quoteStage= 'test';
                qWrap.encryptedQuoteId='awerqwerwqr';
                qWrap.brokerId='svh';
                qWrap.brokerName='adfkh';
                qWrap.emailIdOnQuote='asdkh';
                
    } 

      @isTest
    static void testApplicationCheckIF(){
        //Broker & Individual View Scenario
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        
        insert testBroker;
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.UID__c= '34453445345';
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Date_of_Birth_Doc_Gen__c = '10/02/1996';
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
        List<ApplicationDetailsWrapper.AppListView> appListView = new List<ApplicationDetailsWrapper.AppListView>();
        ApplicationDetailsWrapper.AppListView appViewList = new ApplicationDetailsWrapper.AppListView();
        appViewList.firstName='dfkjh';
        appViewList.lastName='dfkjh';
        appViewList.applicationId=testApplication.Id;
        appViewList.brokerId='dfkjh';
        appViewList.applicationName='dfkjh';
        appViewList.loanAmount=9000;
        appViewList.loanTerm='dfkjh';
        appViewList.loanNumber='dfkjh';
        appListView.add(appViewList);
               
       BrokerSubmittedEntities.filterBasedOnName(appList,'34453445345','LastnameFirstName');
       Boolean chk = BrokerSubmittedEntities.checkIfAppIdFound(appViewList.applicationId,appListView);
       System.debug('DEB THE DEBUGGER: '+chk);
       BrokerSubmittedEntities.getAppCopyDocument(appViewList.applicationId,'10/02/1996','Copy of Application', testApplication.UID__c);    
       BrokerSubmittedEntities.getApplicationStatus(testApplication.Id);

       ApplicationDetailsWrapper.AppListView alv = new ApplicationDetailsWrapper.AppListView();
       alv.status = 'Test';
       alv.applicationType = 'Joint';
    } 
        @isTest
    static void testApplicationContactBroker(){
        
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'broker' + 'test392@test.com',
            Alias = 'brokeest',
            Email='broker.tsst392@test.com',
            EmailEncodingKey='UTF-8',
            Firstname='broker',
            Lastname='test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
    Database.insert(portalAccountOwner1);

    User portalUser ;    
    System.runAs ( portalAccountOwner1 ) 
    {
     //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
        );
        Database.insert(portalAccount1);

        //Create contact
        Contact testBroker = TestDataBuilder.createBrokerRecord();
        testBroker.Broker_View_Access__c = 'Individual View';
        testBroker.Email = 'testBroker@test.com';
        testBroker.FirstName = 'Test';
        testBroker.Lastname = 'McTesty';
        testBroker.AccountId = portalAccount1.Id;   
        testBroker.Primary_Contact__c=true;    
        Database.insert(testBroker);
       
       /* Id brokerRecordType = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Broker Assistants').RecordTypeId;
        Contact testNomBroker = TestDataBuilder.createBrokerRecord();
        testNomBroker.RecordTypeID= brokerRecordType;
        testNomBroker.Broker_View_Access__c = 'Individual View';
        testNomBroker.Email = 'testBroker@test.com';
        testNomBroker.Nominated_Broker__c =testBroker.Id;
        testNomBroker.Primary_Contact__c=true;
        Database.insert(testNomBroker);
        */
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile where name ='A10 Latitude Broker Community Login' Limit 1];
        portalUser = new User(
        Username = 'brokerp' + 'test12345@test.com',
        ContactId = testBroker.Id,
        ProfileId = portalProfile.Id,
        Alias = 'por123',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'pdsd',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        Database.insert(portalUser);          
                 
    }
    System.runas(portalUser ){
     Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        Contact c= [select id, Broker_ID__c from Contact];
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.UID__c= '34453445345';
        testApplication.Response_Code__c = 'Test';
        testApplication.Broker_ID__c=c.Broker_ID__c;
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Date_of_Birth_Doc_Gen__c = '10/02/1996';
        
       List<Applicant__c> appList = new List<Applicant__c>();
       appList.add(testApplicant);
        insert appList;
        
        
         BrokerSubmittedEntities.getApplications('34453445345','FirstName Lastname');
         BrokerSubmittedEntities.getAppCopyDocument(testApplication.Id,'10/02/1996','Copy of Application', testApplication.UID__c);
        
        Map<String,String> statusMap = new Map<String,String>();
        statusMap.put('Referred: Sales', 'ID & Proof of Income required (Based on IDV or POI or both pending on the application)');
        String applicationStatus = 'Referred: Sales';
        
        BrokerSubmittedEntities.mapStatusForPortal(statusMap,applicationStatus,'C91AS');
        BrokerSubmittedEntities.mapStatusForPortal(statusMap,applicationStatus,'C80AS');
      
            
    }
  } 
      

}