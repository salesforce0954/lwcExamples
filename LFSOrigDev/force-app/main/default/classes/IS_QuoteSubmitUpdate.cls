global class IS_QuoteSubmitUpdate {
  
  /**  Description: Method that prepares quote submit required parameters.
     *  Author: Madhusudhan S
     *  Date Created: 12/05/2020
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
           
           quoteSubmitRequest(qId,false,requestedName,null);
       
      
  }
 /**  Description: Method that calls application submit webservice class and pass the required parameters.
     *  Author: Madhusudhan S
     *  Date Created: 12/05/2020
     *  Input Parameters: QuoteId, mockEnable, requestedName
     *  Return: ExceptionLog__C 
   */  
    public static List<IS_ValidationError> quoteSubmitRequest(Id quoteID, boolean mockEnable, String requestedName,ID exceptionLogId) {
    
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
                     return validationErrors;   
                }

                 System.debug(quoteID+'...quoteID.....'+mockEnable+'...mockEnable......'+requestedName);
                    quoteSubmitRequest(quoteID, mockEnable, requestedName);
             

            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + quoteId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_QUOTESUBMIT, errorMesg));
            }
        
      } catch(Exception e){
            }
     return validationErrors;
    }

   @future (callout = true)   
   @testvisible
    private static void quoteSubmitRequest(Id qID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
        
            //populate quote info
            appDTO = IS_WebserviceCommonUtil.initializeQuoteData(qID);
            system.debug('check after+++'+appDTO);
           
            processWSQuoteSubmit(appDTO, mockEnable, requestedName, null);

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateQuote(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.WSCLASS_QUOTESUBMIT,
                                                                        'quoteSubmitRequest',
                                                                        appDTO.quote.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.quote,
                                                                        Schema.sObjectType.Quote__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTESUBMIT);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: voidIS_ApplicationSubmit
     */
     @testvisible
    private static void processWSQuoteSubmit(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
           
             WS_QuoteSubmit  wsQuoteSubmit = new WS_QuoteSubmit(boolean.Valueof(mockEnable));
            //invoke request
           system.debug('Before call'+appDTO.quote);
            IS_WebserviceResponseDTO wsResponse = wsQuoteSubmit.quoteSubmitRequest(appDTO.quote,requestedName);
            system.debug('After  call'+wsResponse);
            //process response
            IS_WebserviceCommonUtil.processResponseAndUpdateQuote(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_QUOTESUBMIT,
                                                                        'quoteSubmitRequest',
                                                                        appDTO.quote.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.quote,
                                                                        Schema.sObjectType.Quote__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_QUOTESUBMIT);
          
            
                   
        } catch (Exception e) {
            throw e;
        }
    }
}