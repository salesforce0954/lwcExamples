/**
 * @Description: Integration Class for Confirm Contract Received
 * @Author: Fel Saliba
 * @Date Created: FEB-11-2014
 * @History:
   =====================================================================
       02-11-14: Created. - Fel
   =====================================================================
 */ 
global class IS_ConfirmContractReceived implements IS_RetryInterface{
 
    /**  Description: Interface method for retry functionality
     *  Author: Dan Crisologo
     *  Date Created: 03-11-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        validationErrors = confirmContractReceivedRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
 
    /**  Description: Method that calls Confirm Contract Received webservice class and pass the required parameters.
     *  Author: Fel Saliba
     *  Date Created: 02-11-2014
     *  Input Parameters: applicationID, mockEnable, requestedName
     *  Return: List<IS_ValidationError> 
     */
    public static List<IS_ValidationError> confirmContractReceivedRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
      try {     
        //populate Application, Applicant1 and Applicant2
        appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
        if(appDTO.app != null){
            appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);
        }
        
        //perform validations here
        IS_IValidator validator = new IS_ConfirmContractReceivedValidator(); 
        validationErrors = validator.validate(appDTO); 
        if(validationErrors.size()>0) {
          //failed validation..... return error to caller
          return validationErrors;   
        }

        if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
            confirmContractReceivedRequest(applicationID, mockEnable, requestedName);
        } else { //do the synch call if exceptionLogId is present
            processWSConfirmContractReceived(appDTO, mockEnable, requestedName, exceptionLogId);
        }

      } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_CONTRACTRECEIVED,
                                                                      'confirmContractReceivedRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_CONFIRMCONTRACTRECEIVED);
          validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_CONFIRMCONTRACTRECEIVED, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    // Updated by: Adrian Recio
    // Description: Annotation removed to make method synchronous on call.
    // Date: 23/09/2015
    //@future (callout = true)
    private static void confirmContractReceivedRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try {
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            if(appDTO.app != null){
                appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);
            }
            
            processWSConfirmContractReceived(appDTO, mockEnable, requestedName, null);
               
        } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_CONTRACTRECEIVED,
                                                                      'confirmContractReceivedRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_CONFIRMCONTRACTRECEIVED);
        } 
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSConfirmContractReceived(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            
            WS_ConfirmContractReceived wsConfirmContractReceived = new WS_ConfirmContractReceived(boolean.Valueof(mockEnable)); 
            
            //invoke the request
            IS_WebserviceResponseDTO wsResponse = wsConfirmContractReceived.confirmContractReceivedRequest(appDTO.app,
                                                                                                           requestedName,
                                                                                                           appDTO.disbursementList,
                                                                                                           appDTO.applicant,
                                                                                                           appDTO.applicant2);

            //process the response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_CONTRACTRECEIVED,
                                                                        'confirmContractReceivedRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_CONFIRMCONTRACTRECEIVED);
                                                    
        } catch (Exception e) {
            throw e;
        }
    }
    
}