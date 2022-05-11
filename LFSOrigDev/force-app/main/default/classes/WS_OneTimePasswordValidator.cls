@RestResource(urlMapping='/api/otp/v2/*')
global without sharing class WS_OneTimePasswordValidator {

    @HttpPost
    global static OneTimePasswordResponse validateOtp(){
        RestRequest restReq      =  RestContext.request;
        RestResponse restRes     =  RestContext.response;
        Map<String, Object> requestBodyParamsMap = (Map<String, Object>) JSON.deserializeUntyped(restReq.requestBody.toString());
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        
        //check if the madatory fields have values
        String transactionId;
        String quoteId;
        String otp;

        transactionId = (requestBodyParamsMap.get('transactionId') != null && requestBodyParamsMap.get('transactionId') != '' ?  (String)requestBodyParamsMap.get('transactionId') : null);
        otp = (requestBodyParamsMap.get('otp') != null && requestBodyParamsMap.get('otp') != '' ?  (String)requestBodyParamsMap.get('otp') : null);

        /**MANDATORY FIELDS VALIDATION: START */
        if(transactionId == null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.TRANSACTION_ID_BLANK, GEN_OriginationsConstants.TRANSACTION_ID_BLANK_MSG);
        }
        /*if(quoteId == null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.QUOTE_ID_BLANK, GEN_OriginationsConstants.QUOTE_ID_BLANK_MSG);
        }*/
        if(otp == null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.OTP_BLANK, GEN_OriginationsConstants.OTP_BLANK_MSG);
        }
        /**MANDATORY FIELDS VALIDATION: END */

         //check if any validation has failed
         if(otpResponse.status == GEN_OriginationsConstants.ERROR_STATUS){
            return otpResponse;
        }
        //Decrypt Transaction Id
        transactionId = EncryptionManager.decryptTransactionId(transactionId);
        /**OTHER VALIDATIONS: START */
        List<Quote_Sms_Tracker__c> quoteSmsTrackerList = [SELECT    Id,
                                                                    Quote__c,
                                                                    Verified__c,
                                                                    Verification_Attempts__c,
                                                                    Valid_From__c,
                                                                    Valid_Till__c,
                                                                    Token__c,
                                                                    Quote__r.Name,
                                                                    Quote__r.First_Name__c,
                                                                    Quote__r.Loan_Amount__c,
                                                                    Quote__r.Loan_Purpose__c, 
                                                                    Quote__r.Loan_Term__c, 
                                                                    Quote__r.Quote_Rate__c,
                                                                    Quote__r.Quote_Secured_Rate__c,
                                                                    Quote__r.Monthly_Repayment__c,
                                                                    Quote__r.Comparison_Rate__c,
			                                                        Quote__r.Sub_Type__c
                                                            FROM    Quote_Sms_Tracker__c
                                                           WHERE    Id = :transactionId];
        if(quoteSmsTrackerList.size() != 1){
            //error message
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.INCORRECT_DETAILS, GEN_OriginationsConstants.INCORRECT_DETAILS_MSG);
            return otpResponse;
        }else{
            Quote_Sms_Tracker__c qstObj = quoteSmsTrackerList[0];
            quoteId = qstObj.Quote__c;
            //Validate is Verified Flag is false
            if(qstObj.Verified__c){
                otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                otpResponse.error.put(GEN_OriginationsConstants.OTP_ALREADY_VERIFIED, GEN_OriginationsConstants.OTP_ALREADY_VERIFIED_MSG);
                return otpResponse;
            }
            //Check if attempts is 3
            if(qstObj.Verification_Attempts__c == 3){
                otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                otpResponse.error.put(GEN_OriginationsConstants.OTP_VERIFICATION_MAX_ATTEMPTS, GEN_OriginationsConstants.OTP_VERIFICATION_MAX_ATTEMPTS_MSG);
                return otpResponse;
            }
            //Check if OTP has not expired
            Datetime currentTime = System.now();
            if(!(currentTime >= qstObj.Valid_From__c && currentTime <=qstObj.Valid_Till__c)){
                otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                otpResponse.error.put(GEN_OriginationsConstants.OTP_EXPIRED, GEN_OriginationsConstants.OTP_EXPIRED_MSG);
                return otpResponse;
            }
            //Check if Token Valid
            if(otp != qstObj.Token__c){
                //update Verification Attempts
                Decimal verificationAttempts = qstObj.Verification_Attempts__c;
                Decimal verificationAttemptsRemaining = 3 - (verificationAttempts + 1);
                updateVerificationAttempts(qstObj.Id,verificationAttempts);
                otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                otpResponse.error.put(GEN_OriginationsConstants.OTP_INCORRECT, GEN_OriginationsConstants.OTP_INCORRECT_MSG);
                otpResponse.data.put(GEN_OriginationsConstants.VERIFICATION_ATTEMPTS_REMAINING, String.valueOf(verificationAttemptsRemaining));
                return otpResponse;
            }else{
                //valid OTP, fetch Quote Details. Set Success Response for Digital
                updateOtpValidationDetails(qstObj.Id,qstObj.Verification_Attempts__c);
                otpResponse.status = GEN_OriginationsConstants.SUCCESS_STATUS;
                otpResponse.data.put(GEN_OriginationsConstants.SUCCESS_MSG, GEN_OriginationsConstants.OTP_VALIDATED);
                otpResponse.data.put(GEN_OriginationsConstants.ENCRYPTED_QUOTE_ID, EncryptionManager.encryptQuoteId(quoteId));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_ID, quoteId);
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_REFERENCE, qstObj.Quote__r.Name);
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_FIRST_NAME, qstObj.Quote__r.First_Name__c);
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_LOAN_AMOUNT, String.valueOf(qstObj.Quote__r.Loan_Amount__c));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_LOAN_TERM, qstObj.Quote__r.Loan_Term__c);
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_LOAN_PURPOSE, qstObj.Quote__r.Loan_Purpose__c);
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_INTEREST_RATE, String.valueOf(qstObj.Quote__r.Quote_Rate__c));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_SECURED_INTEREST_RATE, String.valueOf(qstObj.Quote__r.Quote_Secured_Rate__c));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_COMPARISON_RATE, String.valueOf(qstObj.Quote__r.Comparison_Rate__c));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_REPAYMENTS, String.valueOf(qstObj.Quote__r.Monthly_Repayment__c));
                otpResponse.data.put(GEN_OriginationsConstants.QUOTE_SUBTYPE, String.valueOf(qstObj.Quote__r.Sub_Type__c));
            }

        }
        
        return otpResponse;
    }

    private static void updateVerificationAttempts(Id qstId,Decimal verificationAttempts){
        Quote_Sms_Tracker__c qstObj = new Quote_Sms_Tracker__c(); 
        qstObj.Id = qstId;
        qstObj.Verification_Attempts__c = verificationAttempts + 1;
        update qstObj;
    }

    private static void updateOtpValidationDetails(Id qstId,Decimal verificationAttempts){
        Quote_Sms_Tracker__c qstObj = new Quote_Sms_Tracker__c();
        qstObj.Id = qstId;
        qstObj.Verification_Attempts__c = verificationAttempts + 1;
        qstObj.Verified__c = true;
        qstObj.Verified_On__c = System.now();
        update qstObj;
    }
}