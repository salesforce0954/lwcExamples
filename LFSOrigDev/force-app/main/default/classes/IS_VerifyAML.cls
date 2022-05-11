/**
 * @Description: Integration Class for Verify AML Service
 * @Author: Dan Crisologo
 * @Date Created: DEC-19-2013
 * @History:
   =====================================================================
       12-19-13: Created. - Dan
       2015-09-17: Changed Async callout to Sync Callout - Tony Xu
   =====================================================================
 */ 
global class IS_VerifyAML implements IS_RetryInterface{
    
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
        validationErrors = verifyAMLRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
    
    /**  Description: Method that calls verify AML webservice class and pass the required parameters.
     *  Author: Dan Crisologo
     *  Date Created: 12-19-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> verifyAMLRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
      try {     
        //populate Application, Applicant1 and Applicant2
        appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
        
        if(appDTO.applicant!=null) {
            //load AML Data
            appDTO = loadAMLData(appDTO);
            
            //perform validations here
            IS_IValidator validator = new IS_VerifyAMLValidator(); 
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
              //failed validation..... return error to caller
              return validationErrors;   
            }
            
            system.debug('exception log: '+exceptionLogId); 
            if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                verifyAMLRequest(applicationID, mockEnable, requestedName);
            } else { //do the synch call if exceptionLogId is present
                processWSVerifyAML(appDTO, mockEnable, requestedName, exceptionLogId);
            }
            
        } else {
            String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + applicationId;
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_VERIFYAML, errorMesg));
        }
        
      } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_VERIFYAML,
                                                                      'verifyAMLRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_VERIFYAML);
          validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_VERIFYAML, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    //@future (callout = true)			Commented out by TXU to change Async Callout to Sync Callout.
    private static void verifyAMLRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try {
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            
            //load AML Data
            appDTO = loadAMLData(appDTO);
            system.debug('appDTO: '+appDTO.amlList);
            processWSVerifyAML(appDTO, mockEnable, requestedName, null);
            
       } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_VERIFYAML,
                                                                      'verifyAMLRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_VERIFYAML);
       }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSVerifyAML(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_VerifyAML wsVerifyAML = new WS_VerifyAML(boolean.Valueof(mockEnable)); 
            
            IS_WebserviceResponseDTO wsResponse = wsVerifyAML.verifyAMLRequest(appDTO.app, appDTO.amlList, appDTO.amlList2,requestedName);     
            System.debug('wsVerifyAML->'+wsVerifyAML+'--'+appDTO.amlList+'--'+appDTO.amlList2);
            System.debug('wsResponse.messageCode:'+wsResponse.messageCode);
            System.debug('wsResponse.messageDescription:'+wsResponse.messageDescription);
            System.debug('GEN_OriginationsConstants.WSCLASS_VERIFYAML:'+GEN_OriginationsConstants.WSCLASS_VERIFYAML);
             
            Boolean success = IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                                            wsResponse.messageDescription,
                                                                                            GEN_OriginationsConstants.WSCLASS_VERIFYAML,
                                                                                            'VerifyAMLRequest',
                                                                                            appDTO.app.ID,
                                                                                            requestedName,
                                                                                            exceptionLogId,
                                                                                            appDTO.app,
                                                                                            Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
           
           
                                                                                            GEN_OriginationsConstants.SERVICENAME_VERIFYAML);
            
            //Tag the has_aml to true if processing is successful
            if(success){
                Set<Id> applicantIds = new Set<Id>();
                
                if(appDTO.amlList!=null &&!appDTO.amlList.isEmpty()){
                    for(AML__c a: appDTO.amlList){
                        applicantIds.add(a.Applicant__c);
                        a.AML_Ver_Date__c = Date.today(); 
                    }
                    update appDTO.amlList;
                } 
                if(appDTO.amlList2!=null && !appDTO.amlList2.isEmpty()){
                    for(AML__c a: appDTO.amlList2){
                        applicantIds.add(a.Applicant__c);
                        a.AML_Ver_Date__c = Date.today(); 
                    }

                    update appDTO.amlList2;
                }             
            }
                                               
        } catch (Exception e) {
            throw e;
        }
    }
    
    /*  Description: Query AML records
     *  Author: Dan Crisologo
     *  Date Created: DEC-19-2013
     *  Input: appDTO
     *  Return: IS_ApplicationDTO
     */
    private static IS_ApplicationDTO loadAMLData(IS_ApplicationDTO appDTO) {
    
        if(!appDTO.applicant.Has_AML__c || !appDTO.applicant.Has_POA__c){
          //appDTO.amlList = GEN_RecordRetrievalUtility.retrieveAMLList(appDTO.applicant.Id);
          appDTO.amlList = GEN_RecordRetrievalUtility.retrieveAMLListPostSubmit(appDTO.applicant.Id);
        }
        if(appDTO.applicant2!=null) {
            if(!appDTO.applicant2.Has_AML__c || !appDTO.applicant2.Has_POA__c){
              //appDTO.amlList2 = GEN_RecordRetrievalUtility.retrieveAMLList(appDTO.applicant2.Id);
              appDTO.amlList2 = GEN_RecordRetrievalUtility.retrieveAMLListPostSubmit(appDTO.applicant2.Id);
            }
        }
        return appDTO;
    }
    
}