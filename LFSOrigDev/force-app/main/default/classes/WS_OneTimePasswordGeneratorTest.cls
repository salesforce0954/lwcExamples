@isTest
public with sharing class WS_OneTimePasswordGeneratorTest {
    
    @TestSetup static void setupData(){

        List<Admin_Settings__c> adminSettingsList = new List<Admin_Settings__c>();

        Admin_Settings__c adminSettings_1 = new Admin_Settings__c();
        adminSettings_1.Name = 'MessageMedia_Latitude_Template';
        adminSettings_1.Value__c = 'Enter SMS Code [OTP] to retrieve your Latitude Personal Loan interest rate. Unexpected SMS? Call 13 28 26';
        adminSettingsList.add(adminSettings_1);

        Admin_Settings__c adminSettings_2 = new Admin_Settings__c();
        adminSettings_2.Name = 'MessageMedia_Gem_Template';
        adminSettings_2.Value__c = 'Enter SMS Code [OTP] to retrieve your Latitude Personal Loan interest rate. Unexpected SMS? Call 13 28 26';
        adminSettingsList.add(adminSettings_2);

        Admin_Settings__c adminSettings_3 = new Admin_Settings__c();
        adminSettings_3.Name = 'MessageMedia_Kiwi_Template';
        adminSettings_3.Value__c = 'Enter SMS Code [OTP] to retrieve your Latitude Personal Loan interest rate. Unexpected SMS? Call 13 28 26';
        adminSettingsList.add(adminSettings_3);

        insert adminSettingsList;


        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        testProduct.Type__c = 'Personal Loan';
        insert testProduct;

          Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;

        List<Quote__c> quotesList = TestDataBuilder.createQuoteAUOnline();
        insert quotesList;
        Id quoteId = quotesList[0].Id;
        Quote__c qObj = new Quote__c();
        qObj.Id = quoteId;
        qObj.Quote_Stage__c = 'Quote Offered';
        update qObj;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

    } 
    
    @isTest static void generateOtpTest_AU(){
        System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Generation*/        
        String body     = '{"dateOfBirth":"18/08/1976","emailID":"asd@zz.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.SUCCESS_STATUS, otpResponse.status);

        body = '{"dateOfBirth":"","emailID":"asd@zz.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

        body = '{"dateOfBirth":"18/08/1976","emailID":"","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

        body = '{"dateOfBirth":"18/08/1976","emailID":"asd@zztest.com","quoteReference":"Q9999999999"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);
    }

    @isTest static void generateOtpTest_NZ_Gem(){
    
          Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='Both';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;    

        List<Quote__c> quotesList = TestDataBuilder.createQuoteNZOnline();
        insert quotesList;
        Id quoteId = quotesList[0].Id;
        Quote__c qObj = new Quote__c();
        qObj.Id = quoteId;
        qObj.Quote_Stage__c = 'Quote Offered';
        update qObj; 

        System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Generation*/        
        String body     = '{"dateOfBirth":"18/06/1976","emailID":"asd@zzgem.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.SUCCESS_STATUS, otpResponse.status);
    }

    @isTest static void generateOtpTest_NZ_Kiwi(){
    
          Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='Both';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;    

        List<Quote__c> quotesList = TestDataBuilder.createQuoteNZOnlineKiwi(); 
        insert quotesList;
        Id quoteId = quotesList[0].Id;
        Quote__c qObj = new Quote__c();
        qObj.Id = quoteId;
        qObj.Quote_Stage__c = 'Quote Offered';
        update qObj;

        System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Generation*/        
        String body     = '{"dateOfBirth":"18/07/1976","emailID":"asd@zzkiwi.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.SUCCESS_STATUS, otpResponse.status);
    }

    @isTest static void generateOtpTest_AU_OTP(){
    
          Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;
        
        List<Quote__c> quotesList = TestDataBuilder.createQuoteAUOnline();
        insert quotesList;
        Id quoteId = quotesList[0].Id;
        Quote__c qObj = new Quote__c();
        qObj.Id = quoteId;
        qObj.Quote_Stage__c = 'Quote Offered';
        update qObj;

        //For 3 Attempts Error
        Quote_Sms_Tracker__c qstObj = new Quote_Sms_Tracker__c();
        qstObj.Quote__c = quoteId;
        qstObj.Attempt__c = 3;
        qstObj.Valid_From__c = System.now();
        qstObj.Valid_Till__c = System.now() + 5;
        qstObj.Verification_Attempts__c = 3;
        qstObj.Token__c = '768909';
        insert qstObj;

        System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Generation*/        
        String body     = '{"dateOfBirth":"18/08/1976","emailID":"asd@zz.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        //System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);
    }

    @isTest static void generateOtpTest_AU_OTP_Success(){
           Street_Type_Setting__c st1 = new Street_Type_Setting__c();
        St1.name='Road';
        St1.Value__c='Road';
        St1.Region__c='AU';
        St1.Value_Abbreviated_NZ__c='Rd';
        St1.Value_Abbreviated__c='Rd';
        insert St1;   
            
        List<Quote__c> quotesList = TestDataBuilder.createQuoteAUOnline();
        insert quotesList;
        Id quoteId = quotesList[0].Id;
        Quote__c qObj = new Quote__c();
        qObj.Id = quoteId;
        qObj.Quote_Stage__c = 'Quote Offered';
        update qObj;

        //For 1 Attempts Scenario
        Quote_Sms_Tracker__c qstObj = new Quote_Sms_Tracker__c();
        qstObj.Quote__c = quoteId;
        qstObj.Attempt__c = 1;
        qstObj.Valid_From__c = System.now();
        qstObj.Valid_Till__c = System.now() + 5;
        qstObj.Verification_Attempts__c = 0;
        qstObj.Token__c = '768909';
        insert qstObj;

        System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Generation*/        
        String body     = '{"dateOfBirth":"18/08/1976","emailID":"asd@zz.com","quoteReference":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordGenerator.generateOtp();
        System.assertEquals(GEN_OriginationsConstants.SUCCESS_STATUS, otpResponse.status);

    }

}