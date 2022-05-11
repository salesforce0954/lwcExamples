/**
 * @Description: Integration Class for Verify POI Service
 * @Author: Dan Crisologo
 * @Date Created: DEC-20-2013
 * @History:
   =====================================================================
       12-20-13: Created. - Dan
       2015-09-17: Changed Async Callout to Sync Callout - Tony Xu
   =====================================================================
 */ 
global class IS_VerifyPOI implements IS_RetryInterface{
    
    /**  Description: Interface method for retry functionality
     *  Author: Dan Crisologo
     *  Date Created: 03-11-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        validationErrors = verifyPOIRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
    
    /**  Description: Method that calls verify POI webservice class and pass the required parameters.
     *  Author: Dan Crisologo
     *  Date Created: 12-20-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> verifyPOIRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
      try {     
        //populate Application, Applicant1 and Applicant2
        appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
        
        if(appDTO.applicant!=null) {
            
            //retrieve additional income data
            appDTO.incList = GEN_RecordRetrievalUtility.retrieveIncomeSortedByAmount(appDTO.applicant.Id);
            if(appDTO.app.application_type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
              appDTO.incList2 = GEN_RecordRetrievalUtility.retrieveIncomeList(appDTO.applicant2.Id);
            }

            //perform validations here
            IS_IValidator validator = new IS_VerifyPOIValidator(); 
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
              //failed validation..... return error to caller
              return validationErrors;   
            }
            
            if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                verifyPOIRequest(applicationID, mockEnable, requestedName);
            } else { //do the synch call if exceptionLogId is present
                processWSVerifyPOI(appDTO, mockEnable, requestedName, exceptionLogId);
            }
            
        } else {
            String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + applicationId;
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_VERIFYPOI, errorMesg));
        }
        
      } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_VERIFYPOI,
                                                                      'VerifyPOIRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_VERIFYPOI);
          validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_VERIFYPOI, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    //@future (callout = true)      Commented out by TXU to change Async callout to Sync Callout
    private static void verifyPOIRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            //retrieve additional income data
            appDTO.incList = GEN_RecordRetrievalUtility.retrieveIncomeSortedByAmount(appDTO.applicant.Id);
            if(appDTO.app.application_type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
              appDTO.incList2 = GEN_RecordRetrievalUtility.retrieveIncomeList(appDTO.applicant2.Id);
            }


            processWSVerifyPOI(appDTO, mockEnable, requestedName, null);
             
        } catch(Exception e){
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_VERIFYPOI,
                                                                      'VerifyPOIRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_VERIFYPOI);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSVerifyPOI(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
           WS_VerifyPOI wsVerifyPOI = new WS_VerifyPOI(boolean.Valueof(mockEnable)); 
           IS_WebserviceResponseDTO wsResponse = wsVerifyPOI.verifyPOIRequest(appDTO.app, 
                                                                              appDTO.applicant, 
                                                                              appDTO.applicant2,
                                                                              appDTO.incList,
                                                                              appDTO.incList2,
                                                                              requestedName);     
    
           IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                       wsResponse.messageDescription,
                                                                       GEN_OriginationsConstants.WSCLASS_VERIFYPOI,
                                                                       'verifyPOIRequest',
                                                                       appDTO.app.ID,
                                                                       requestedName,
                                                                       exceptionLogId,
                                                                       appDTO.app,
                                                                       Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                       GEN_OriginationsConstants.SERVICENAME_VERIFYPOI);                                        
        } catch (Exception e) {
            throw e;
        }
    }
    
}