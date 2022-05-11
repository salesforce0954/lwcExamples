/**
 * @Description: Class that handles the Appication request.
 * @Author: Fel Saliba
 * @Date Created: SEPT-19-2013
 * @History:
   =====================================================================
       09-19-13: Created. - Fel
       09-23-13: Added Exception Handling - Fel
       10-08-13: Updated: Added Exception Log object as return
       12-10-13: Refactored App Cancel - Dan
       17-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */ 
global class IS_ApplicationSubmit implements IS_RetryInterface{
    
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
        validationErrors = applicationSubmitRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
    
    /**  Description: Method that calls application submit webservice class and pass the required parameters.
     *  Author: Dan Crisologo
     *  Date Created: 09-19-13
     *  Input Parameters: applicationID, mockEnable, requestedName
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> applicationSubmitRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
    
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try {     
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
                
            if(appDTO.applicant!=null) {
      
                //load budget details, products, ONRs, loan purposes
                appDTO = IS_WebserviceCommonUtil.loadOtherApplicationData(appDTO);
                //load aml data
                appDTO = IS_WebserviceCommonUtil.loadAdditionalSubmitData(appDTO);
                //load user and branch
                appDTO = IS_WebserviceCommonUtil.loadUserAndBranchData(appDTO, requestedName);
                
                //perform validations here
                IS_IValidator validator = new IS_ApplicationSubmitValidator(); 
                validationErrors = validator.validate(appDTO); 
                if(validationErrors.size()>0) {
                  //failed validation..... return error to caller
                  return validationErrors;   
                }

                if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                    applicationSubmitRequest(applicationID, mockEnable, requestedName);
                } else { //do the synch call if exceptionLogId is present
                    processWSApplicationSubmit(appDTO, mockEnable, requestedName, exceptionLogId);
                }

            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + applicationId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_SUBMIT, errorMesg));
            }
        
      } catch(Exception e){
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_PRESUBMIT_EXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_SUBMIT,
                                                                      'ApplicationSubmitRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_SUBMIT);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_SUBMIT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    //@future (callout = true)      MLASALA: 17-SEPT-15 - COMMENTED OUT TO MOVE FROM ASYNC TO SYNC CALLS
    private static void applicationSubmitRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            //load budget details, products, ONRs, loan purposes
            appDTO = IS_WebserviceCommonUtil.loadOtherApplicationData(appDTO);
            //load aml data
            appDTO = IS_WebserviceCommonUtil.loadAdditionalSubmitData(appDTO);
            //load user and branch
            appDTO = IS_WebserviceCommonUtil.loadUserAndBranchData(appDTO, requestedName);
     
            processWSApplicationSubmit(appDTO, mockEnable, requestedName, null);

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.WSCLASS_SUBMIT,
                                                                        'ApplicationSubmitRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_SUBMIT);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: voidIS_ApplicationSubmit
     */
    private static void processWSApplicationSubmit(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_ApplicationSubmit wsAppSubmit = new WS_ApplicationSubmit(boolean.Valueof(mockEnable)); 
     
            //invoke request
            IS_WebserviceResponseDTO wsResponse = wsAppSubmit.applicationSubmitRequest(appDTO.app, appDTO.loanPurList, appDTO.onrList, appDTO.product, appDTO.branch, appDTO.applicationOwner, appDTO.applicationDebits,
                                                               appDTO.feesAndCharges, appDTO.applicant, appDTO.incList, appDTO.assetList, appDTO.debtList, appDTO.expenseList,
                                                               appDTO.applicant2, appDTO.incList2, appDTO.assetList2, appDTO.debtList2, appDTO.expenseList2,
                                                               appDTO.collateralList, appDTO.personalReferenceList,appDTO.clvList, appDTO.clvList2, appDTO.amlList, appDTO.amlList2, appDTO.brokerDetails,appDTO.disbursementList,requestedName);     
            //process response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_SUBMIT,
                                                                        'applicationSubmitRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_SUBMIT);
                   
        } catch (Exception e) {
            throw e;
        }
    }
         
}