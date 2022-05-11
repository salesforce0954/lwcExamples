global class IS_QuoteSubmitPartialUpdate {
  /**  Description: Method that prepares quote submit required parameters.
     *  Author: Manoj kumar 
     *  Date Created: 08/09/2020
     *  Input Parameters: Softquote id, Channel
     *  Return: ExceptionLog__C 
   */  
    public static void quoteInputRequest(Id qId,string qChannel) {   
    
            String requestedName = '';
              
            if (qChannel =='Sales') {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c;
            } else {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Customer').Value__c;
            }
           system.debug('ID of Quote'+qId);
           //quoteID = quote.quoteID;
           
           quoteSubmitPartialRequest(qId,false,requestedName,null);
       
      
  }
 /**  Description: Method that calls application submit webservice class and pass the required parameters.
     *  Author: Manoj kumar
     *  Date Created: 08/09/2020
     *  Input Parameters: QuoteId, mockEnable, requestedName
     *  Return: ExceptionLog__C 
   */  
    public static List<IS_ValidationError> quoteSubmitPartialRequest(Id quoteID, boolean mockEnable, String requestedName,ID exceptionLogId) {
    
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
              
        try {     
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeQuoteData(quoteID);
                
            if(appDTO.quote!=null) {
      
               //perform validations here
                IS_IValidator validator = new IS_ApplicationSubmitValidator(); 
                validationErrors = validator.validate(appDTO); 
                if(validationErrors.size()>0) {
                  //failed validation..... return error to caller
                  return validationErrors;   
                }

               // if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                    System.debug(quoteID+'...quoteID.....'+mockEnable+'...mockEnable......'+requestedName);
                    quotePartialUpdateRequest(quoteID, mockEnable, requestedName);
              /*  } else { //do the synch call if exceptionLogId is present
                    processWSQuoteSubmit(appDTO, mockEnable, requestedName, exceptionLogId);
                }*/

            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + quoteId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_QUOTEINTERESTUPDATE, errorMesg));
            }
        
      } catch(Exception e){
            /*IS_WebserviceCommonUtil.processResponseAndUpdateQuote(GEN_OriginationsConstants.MESSAGE_CODE_PRESUBMIT_EXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_QUOTESUBMIT,
                                                                      'quoteSubmitRequest',
                                                                      appDTO.quote.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.quote,
                                                                      Schema.sObjectType.Quote__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_QUOTESUBMIT);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_SUBMIT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));*/
      }
      return validationErrors;
    }

   @future (callout = true)   
   @testvisible
    private static void quotePartialUpdateRequest(Id qID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
        
            //populate quote info
            appDTO = IS_WebserviceCommonUtil.initializeQuoteData(qID);
            system.debug('check after+++'+appDTO);
            system.debug('check after+++'+requestedName);
            system.debug('check after+++'+mockEnable);
            processWSQuotePartialSubmit(appDTO, mockEnable, requestedName, null);

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateQuote(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTEINTERESTUPDATE,
                                                                        'quoteUpdateRequest',
                                                                        appDTO.quote.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.quote,
                                                                        Schema.sObjectType.Quote__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTEINTERESTUPDATE);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: voidIS_ApplicationSubmit
     */
     @testvisible
    private static void processWSQuotePartialSubmit(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
           
            WS_QuotePartialSubmit  wsQuoteSubmit = new WS_QuotePartialSubmit(boolean.Valueof(mockEnable));
            //invoke request
           system.debug('Before call'+appDTO.quote);
            IS_WebserviceResponseDTO wsResponse = wsQuoteSubmit.quotePartialUpdateRequest(appDTO.quote,requestedName);
            system.debug('After  call'+wsResponse);
            //process response
            IS_WebserviceCommonUtil.processResponseAndUpdateQuote(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTEINTERESTUPDATE,
                                                                        'quotePartialUpdateRequest',
                                                                        appDTO.quote.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.quote,
                                                                        Schema.sObjectType.Quote__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTEINTERESTUPDATE);
            
                   
        } catch (Exception e) {
            throw e;
        }
    }
}