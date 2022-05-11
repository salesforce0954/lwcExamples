global class IS_verifyCapacityUpdate {

  /**  Description: Method that prepares Application verifier capacity request.
     *  Author: Madhusudhan S
     *  Date Created: 11/05/2021
     *  Input Parameters: Application id, Channel
     *  Return: ExceptionLog__C 
   */  
   //@future(CallOut = true)
    public static void verifyCapacityRequest(Id applicationId,string appChannel) {   
    
            String requestedName = '';
              
            if (appChannel =='Sales') {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c;
            } else {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Customer').Value__c;
            }
          
           
           verifyCapacityRequest(applicationId,requestedName,false,null);
       
      
  }
 /**  Description: Method that calls application Verifier capacity webservice class and pass the required parameters.
     *  Author: Madhusudhan S
     *  Date Created: 11/05/2021
     *  Input Parameters: ApplicationId, mockEnable, requestedName
     *  Return: ExceptionLog__C 
   */  
    public static List<IS_ValidationError> verifyCapacityRequest(Id applicationId,String requestedName,boolean mockEnable,ID exceptionLogId) {
    
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
              
        try {     
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationId);
                
            if(appDTO.app!=null) {
      
               //perform validations here
                IS_IValidator validator = new IS_ApplicationSubmitValidator(); 
                validationErrors = validator.validate(appDTO); 
                if(validationErrors.size()>0) {
                  //failed validation..... return error to caller
                  return validationErrors;   
                }
                  System.debug(applicationId+'...applicationId.....'+mockEnable+'...mockEnable......'+requestedName);
                  verifyCapacityUpdateRequest(applicationId, mockEnable, requestedName);
              

            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + applicationId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY, errorMesg));
            }
        
      } catch(Exception e){
            /* IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY,
                                                                        'processWSVerifyCapacityUpdate',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY);
       
            */ }
      return validationErrors;
    }

   @future (callout = true)   
   @testvisible
    private static void verifyCapacityUpdateRequest(Id appID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
        
            //populate Application info
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(appID);
            system.debug('check after+++'+appDTO);
            processWSVerifyCapacityUpdate(appDTO, mockEnable, requestedName, null);

        } catch(Exception e) {
           IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY,
                                                                        'processWSVerifyCapacityUpdate',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY);
        }
    }
    
    /**  Description: This method will call the Application Verify Capcity WS service class
     *  Date Created: 11-05-2021
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
    **/
    @testvisible
    private static void processWSVerifyCapacityUpdate(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
           
            WS_VerifyCapacityUpdate wsVerifyCapacity = new WS_VerifyCapacityUpdate(boolean.Valueof(mockEnable));
            //invoke request
           system.debug('Before call'+appDTO.app);
            IS_WebserviceResponseDTO wsResponse = wsVerifyCapacity.verifyCapacityUpdateRequest(appDTO.app,requestedName);
            system.debug('After  call'+wsResponse);
            //process response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY,
                                                                        'processWSVerifyCapacityUpdate',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_VERIFY_CAPACITY); 
            
                   
        } catch (Exception e) {
            throw e;
        }
    }
}