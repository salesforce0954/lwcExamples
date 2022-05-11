@isTest
public with sharing class WS_OneTimePasswordValidatorTest {
    
    @isTest static void validateOtp_1(){
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;
        
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
        qObj.Sub_Type__c = 'Standard';
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
         Id transactionId = qstObj.Id;

         System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Validation*/        
        String body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":"768909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.SUCCESS_STATUS, otpResponse.status);

        /*Test Case Scenario: Incorrect OTP */  
        body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":"700909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.debug('OTP RESPONSE: '+otpResponse);
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);
        
        
        body     = '{"transactionId":"","quoteId":"'+quoteId+'","otp":"760909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

        body     = '{"transactionId":"'+transactionId+'","quoteId":"","otp":"760909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

        body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":""}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);



    } 

    @isTest static void validateOtp_2(){
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;
        
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
         qstObj.Attempt__c = 3;
         qstObj.Valid_From__c = System.now();
         qstObj.Valid_Till__c = System.now() + 5;
         qstObj.Verification_Attempts__c = 3;
         qstObj.Token__c = '768909'; 
         insert qstObj;
         Id transactionId = qstObj.Id;

         System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Validation*/        
        String body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":"768909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

    } 

    @isTest static void validateOtp_3(){
        
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;
        
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
         qstObj.Attempt__c = 3;
         qstObj.Valid_From__c = System.now();
         qstObj.Valid_Till__c = System.now();
         qstObj.Verification_Attempts__c = 0;
         qstObj.Token__c = '768909';
         insert qstObj;
         Id transactionId = qstObj.Id;

         System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Validation*/        
        String body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":"768909"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);

    } 

    @isTest static void validateOtp_4(){
    	
        Admin_Settings__c as1 = new Admin_Settings__c();
        as1.Name = 'QuoteId_Encryption_Key';
        as1.Value__c = 'QuoteId';
        insert as1;
        
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
         Id transactionId = qstObj.Id;

         System.RestContext.request  =   new RestRequest();
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        /*Test Case Scenario: Successful OTP Validation*/        
        String body     = '{"transactionId":"'+transactionId+'","quoteId":"'+quoteId+'","otp":"768009"}' ;
        RestContext.request.requestBody = Blob.valueOf(body);
        otpResponse = WS_OneTimePasswordValidator.validateOtp();
        System.assertEquals(GEN_OriginationsConstants.ERROR_STATUS, otpResponse.status);
    }
}