@RestResource(urlMapping='/api/otp/v1/*')
global with sharing class WS_OneTimePasswordGenerator {

    @HttpPost
    global static OneTimePasswordResponse generateOtp(){
        Boolean quoteAccess = Schema.sObjectType.Quote__c.isAccessible();
        System.debug('quoteAccess: '+quoteAccess);
        Boolean quoteSmsAccess = Schema.sObjectType.Quote_Sms_Tracker__c.isAccessible();
        System.debug('quoteSmsAccess: '+quoteSmsAccess);
        RestRequest restReq      =  RestContext.request;
        RestResponse restRes     =  RestContext.response;
        Map<String, Object> requestBodyParamsMap = (Map<String, Object>) JSON.deserializeUntyped(restReq.requestBody.toString());
        OneTimePasswordResponse otpResponse = new OneTimePasswordResponse();
        
        //check if the madatory fields have values
        String dateOfBirth;
        String emailId;
        String quoteRefNumber;
        Date dob;
        
        dateOfBirth = (requestBodyParamsMap.get('dateOfBirth') != null && requestBodyParamsMap.get('dateOfBirth') != '' ?  (String)requestBodyParamsMap.get('dateOfBirth') : null);
        emailId = (requestBodyParamsMap.get('emailID') != null && requestBodyParamsMap.get('emailID') != '' ?  (String)requestBodyParamsMap.get('emailID') : null);
        quoteRefNumber = (requestBodyParamsMap.get('quoteReference') != null && requestBodyParamsMap.get('quoteReference') != '' ?  (String)requestBodyParamsMap.get('quoteReference') : null);

        /**MANDATORY FIELDS VALIDATION: START */
        if(dateOfBirth == null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.DOB_BLANK, GEN_OriginationsConstants.DOB_BLANK_MSG);
        }
        if(emailId == null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.EMAIL_ID_BLANK, GEN_OriginationsConstants.EMAIL_ID_BLANK_MSG);
        }
        try{
            dob = Date.parse(dateOfBirth);
            System.debug('CHECK-1 DateOfBirth: '+dateOfBirth);
            System.debug('CHECK-2 dob: '+dob);
        }catch(Exception e){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.INVALID_DOB_FORMAT, GEN_OriginationsConstants.INVALID_DOB_FORMAT_MSG);
        }
        //check if any validation has failed
        if(otpResponse.status == GEN_OriginationsConstants.ERROR_STATUS){
            return otpResponse;
        }
        /**MANDATORY FIELDS VALIDATION: END */

        /**ACTIVE QUOTES MATCHING CRITERIA: START */

        //check if there are any active quotes in the system with the combination of email id, dob  quote reference 
        List<Quote__c> activeQuotesList = new List<Quote__c>();
        Id matchingQuoteId;
        String quoteMobileNumber;
        String quoteRegion;
        String quoteProduct;
        String quoteStage_Quote_Offered = GEN_OriginationsConstants.QUOTE_OFFERED_STAGE;
        String quoteStage;
        String maskedMobileNumber;
        String brokerChannel = 'Broker';
        //String soqlQuery = 'SELECT Id,Name,Date_of_Birth__c,Mobile_Number__c,Quote_Stage__c,Region__c,Product__c FROM Quote__c WHERE Email_ID__c = \'' +emailId+ '\' AND Quote_Stage__c = \'' +quoteStage_Quote_Offered+ '\' ';
        String soqlQuery = 'SELECT Id,Name,Date_of_Birth__c,Mobile_Number__c,Quote_Stage__c,Region__c,Product__c FROM Quote__c WHERE Email_ID__c = \'' +String.escapeSingleQuotes(emailId)+ '\'  ';
        if(!String.isEmpty(quoteRefNumber)){
            soqlQuery += ' AND Name = \'' +String.escapeSingleQuotes(quoteRefNumber)+ '\' ';
        }
        //Add a channel filter (to not consider Broker)
        soqlQuery += ' AND Channel__c != \'' +brokerChannel+ '\' ';
        //Order the Query
        soqlQuery += ' ORDER BY CreatedDate DESC';
        activeQuotesList = Database.query(soqlQuery);
        //Check if Date Of Birth Matches the records fetched & status is Quote Offered
        for(Quote__c quoteObj : activeQuotesList){
            quoteStage = quoteObj.Quote_Stage__c;
            if(quoteObj.Date_of_Birth__c == dateOfBirth && quoteObj.Quote_Stage__c == GEN_OriginationsConstants.QUOTE_OFFERED_STAGE){
                matchingQuoteId = quoteObj.Id;
                quoteMobileNumber = quoteObj.Mobile_Number__c;
                quoteRegion = quoteObj.Region__c;
                quoteProduct = quoteObj.Product__c;
                break;
            }
        }
        if(activeQuotesList.size() == 0 || matchingQuoteId== null){
            otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
            otpResponse.error.put(GEN_OriginationsConstants.NO_ACTIVE_QUOTE, GEN_OriginationsConstants.NO_ACTIVE_QUOTE_MSG);
            otpResponse.data.put(GEN_OriginationsConstants.QUOTE_STAGE, quoteStage);
            return otpResponse;
        }
        /**ACTIVE QUOTES MATCHING CRITERIA: END */

        /** CHECK OTP ATTEMPTS REMAINING: START */
        Id quoteSmsTrackerId;
        Double smsAttempts;
        Double currentAttempt;
        Integer attemptsRemaining;
        if(matchingQuoteId !=null){
            //Step-1 : Check if an entry exists in Quote Sms Tracker, if not create one, if it does check the count
            List<Quote_Sms_Tracker__c> quoteSmsTrackerList = [SELECT Id,
                                                                     Attempt__c,
                                                                     Verification_Attempts__c,
                                                                     Valid_From__c,
                                                                     Valid_Till__c,
                                                                     Verified__c,
                                                                     Token__c
                                                                FROM Quote_Sms_Tracker__c
                                                               WHERE Quote__c = :matchingQuoteId
                                                                     AND
                                                                     Verified__c = false
                                                                     ORDER BY CreatedDate DESC];
            if(quoteSmsTrackerList.size() == 0){
                //Create a record for 1st Attempt of quote retrival
                String mobileWithCountryCode = getMobileNumWithCountryCode(quoteMobileNumber,quoteRegion);
                String token = String.valueOf(generateToken()); 
                String message = populateTemplateWithToken(token,quoteProduct);
                String sourceNumber = getSourceNumberFromProduct(quoteProduct);
                maskedMobileNumber = getMaskedMobileNumber(quoteMobileNumber);

                //For normal execution
                if(!Test.isRunningTest()){
                    String messageId = SmsManager.sendMessage(mobileWithCountryCode,message,sourceNumber);
                    System.debug('messageId: '+messageId);
                    if(messageId != GEN_OriginationsConstants.ERROR_STATUS && SmsManager.validateSentMessage(messageId)){
                        quoteSmsTrackerId = createSmsTrackerRecord(matchingQuoteId,1,token);
                        //Set Success Response for Digital
                        otpResponse.status = GEN_OriginationsConstants.SUCCESS_STATUS;
                        otpResponse.data.put(GEN_OriginationsConstants.SUCCESS_MSG, GEN_OriginationsConstants.OTP_GENERATED);
                        otpResponse.data.put(GEN_OriginationsConstants.QUOTE_MOBILE_NUMBER, maskedMobileNumber);
                        otpResponse.data.put(GEN_OriginationsConstants.SF_TRANSACTION_ID, EncryptionManager.encryptTransactionId(String.valueOf(quoteSmsTrackerId)));
                        otpResponse.data.put(GEN_OriginationsConstants.ATTEMPTS_REMAINING, '2');
                    }else{
                        otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                        otpResponse.error.put(GEN_OriginationsConstants.ERROR_SENDING_SMS, GEN_OriginationsConstants.ERROR_SENDING_SMS_MSG);
                        return otpResponse;
                    }
                }else{
                    //For test class execution
                        otpResponse.status = GEN_OriginationsConstants.SUCCESS_STATUS;
                        otpResponse.data.put(GEN_OriginationsConstants.SUCCESS_MSG, GEN_OriginationsConstants.OTP_GENERATED);
                }
            }else{
                //Get Current Attempt count (this indicates how many unsuccessfult attempts were made previously)
                currentAttempt = quoteSmsTrackerList[0].Attempt__c;
                if(currentAttempt == 1){
                    attemptsRemaining = 1;
                }else if(currentAttempt == 2){
                    attemptsRemaining = 0;
                }
                System.debug('CURRENT ATTEMPT: '+currentAttempt);
                System.debug('quoteSmsTrackerList[0]: '+quoteSmsTrackerList[0]);
                if(currentAttempt == 3){
                    //error message: maximum attempts reached to generate a OTP
                    otpResponse.status = GEN_OriginationsConstants.ERROR_STATUS;
                    otpResponse.error.put(GEN_OriginationsConstants.MAX_SMS_ATTEMPTS_REACHED, GEN_OriginationsConstants.MAX_SMS_ATTEMPTS_REACHED_MSG);
                    return otpResponse;

                }else{
                    String mobileWithCountryCode = getMobileNumWithCountryCode(quoteMobileNumber,quoteRegion);
                    String token = String.valueOf(generateToken());
                    String message = populateTemplateWithToken(token,quoteProduct);
                    String sourceNumber = getSourceNumberFromProduct(quoteProduct);
                    maskedMobileNumber = getMaskedMobileNumber(quoteMobileNumber);
                    
                    //For normal execution
                    if(!Test.isRunningTest()){
                        String messageId = SmsManager.sendMessage(mobileWithCountryCode,message,sourceNumber);
                        if(messageId != GEN_OriginationsConstants.ERROR_STATUS && SmsManager.validateSentMessage(messageId)){
                            quoteSmsTrackerId = createSmsTrackerRecord(matchingQuoteId,Integer.valueOf(currentAttempt+1),token);
                            //Set Success Response for Digital
                            otpResponse.status = GEN_OriginationsConstants.SUCCESS_STATUS;
                            otpResponse.data.put(GEN_OriginationsConstants.SUCCESS_MSG, GEN_OriginationsConstants.OTP_GENERATED);
                            //otpResponse.data.put(GEN_OriginationsConstants.QUOTE_ID, matchingQuoteId);
                            otpResponse.data.put(GEN_OriginationsConstants.QUOTE_MOBILE_NUMBER, maskedMobileNumber);
                            otpResponse.data.put(GEN_OriginationsConstants.SF_TRANSACTION_ID, EncryptionManager.encryptTransactionId(String.valueOf(quoteSmsTrackerId)));
                            otpResponse.data.put(GEN_OriginationsConstants.ATTEMPTS_REMAINING, String.valueOf(attemptsRemaining));
                        }
                    }else{
                        otpResponse.status = GEN_OriginationsConstants.SUCCESS_STATUS;
                        otpResponse.data.put(GEN_OriginationsConstants.SUCCESS_MSG, GEN_OriginationsConstants.OTP_GENERATED);
                    }
                }
            }                                                               
        }
        /** CHECK OTP ATTEMPTS REMAINING: END */

       
        return otpResponse;
    }

    /** Generate a 6-digit Token*/
    private static Integer generateToken(){
        //return Math.round((Math.random() * (900000) + 100000));
        return 123456;
        }

    /**
     * Name: createSmsTrackerRecord
     * Description: Create a record for tracking the sms
     */
    private static Id createSmsTrackerRecord(Id quoteId,Integer attempt,String token){
        DateTime validFrom = System.now();
        DateTime validTill = validFrom.addMinutes(5);
        Quote_Sms_Tracker__c qstObj = new Quote_Sms_Tracker__c();
        qstObj.Quote__c = quoteId;
        qstObj.Attempt__c = attempt;
        qstObj.Verification_Attempts__c = 0;
        qstObj.Token__c = token;
        qstObj.Valid_From__c = validFrom;
        qstObj.Valid_Till__c = validTill;
        insert qstObj;
        return qstObj.Id;
    }

    /**
    * Name: getMobileNumWithCountryCode
    * Description: Construct the mobile number with the country code. Remove zero and populate with country code.
    */
    private static String getMobileNumWithCountryCode(String quoteMobileNumber, String quoteRegion){
        String mobileWithCountryCode = '';
        if(quoteMobileNumber != null && quoteRegion != null){
            String regExp = '[0]{1}';
            String auReplacement = GEN_OriginationsConstants.AU_COUNTRY_CODE; 
            String nzReplacement = GEN_OriginationsConstants.NZ_COUNTRY_CODE;
            if(quoteRegion == GEN_OriginationsConstants.AU_REGION){
                mobileWithCountryCode = quoteMobileNumber.replaceFirst(regExp, auReplacement);
            }else if(quoteRegion == GEN_OriginationsConstants.NZ_REGION){
                //mobileWithCountryCode = quoteMobileNumber.replaceFirst(regExp, nzReplacement);
                //For testing replacing NZ Code with AU Code (Disabled Validation rule of Phone number NZ)
                mobileWithCountryCode = quoteMobileNumber.replaceFirst(regExp, auReplacement);
            }
        }
        return mobileWithCountryCode;
    }

    /**
    * Name: populateTemplateWithToken
    * Description: Get the template linked to the product and populate it with the generated token
    */
    private static String populateTemplateWithToken(String token, String product){
        String message = '';
        String target = '[OTP]';
        if(product == GEN_OriginationsConstants.LATITUDE_PL_LOAN){
            message = Admin_Settings__c.getValues('MessageMedia_Latitude_Template').Value__c;
        }else if(product == GEN_OriginationsConstants.GEM_PL_LOAN){
            message = Admin_Settings__c.getValues('MessageMedia_Gem_Template').Value__c;
        }else if(product == GEN_OriginationsConstants.KIWI_PL_LOAN){
            message = Admin_Settings__c.getValues('MessageMedia_Kiwi_Template').Value__c;
        }
        message = message.replace(target, token);
        return message;
   }

    /**
    * Name: getSourceNumberFromProduct
    * Description: Based on the Product Name set the name of the sourceNumber. SourceNumber is used to 
    *              set the from display name on the message from MessageMedia.
    */
    private static String getSourceNumberFromProduct(String product){
        String sourceNumber='';
        if(product == GEN_OriginationsConstants.LATITUDE_PL_LOAN){
            sourceNumber = GEN_OriginationsConstants.SOURCE_NUMBER_LATITUDE;
        }else if(product == GEN_OriginationsConstants.GEM_PL_LOAN){
            sourceNumber = GEN_OriginationsConstants.SOURCE_NUMBER_GEM;
        }else if(product == GEN_OriginationsConstants.KIWI_PL_LOAN){
            sourceNumber = GEN_OriginationsConstants.SOURCE_NUMBER_KIWI;
        }
        return sourceNumber;
   }

   /**
    * Description: Mask the mobile number
    */

    private static String getMaskedMobileNumber(String quoteMobileNumber){
        String maskedMobileNumber;
        if(quoteMobileNumber != null && quoteMobileNumber != '' && quoteMobileNumber.length() >= 9){
            maskedMobileNumber = quoteMobileNumber.substring(0, 2) + '******' + quoteMobileNumber.substring(8);
        }
        return maskedMobileNumber;
    }

}