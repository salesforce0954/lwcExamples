/**
 * @Description: Integration Class for generate payoff figure DBHZL386
 * @Author: Tony Xu
 * @Date Created: 2015-03-02
 * @History:
   =====================================================================
       2015-03-02: Created. - Tony Xu
       17-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */
global class IS_GeneratePayoffFigure implements IS_RFRetryInterface {

	/**  Description: Interface method for retry functionality
     *  Author: Tony Xu
     *  Date Created: 2015-03-02
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
     
     public static List<IS_ValidationError> RFinvokeRetryRequest(ID applicationID, String bankAccountNumber, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        //fourth parameter relatedDocuId will not be populated. retry everything.
        validationErrors = generatePayoffFigureRequest(applicationID, bankAccountNumber, mockEnable, requestedName, exceptionLogId);
        return validationErrors; 
    }
    
    /**  Description: Calls the Generate Payoff Figure Request webservice
     *  Author: Tony Xu
     *  Date Created: 2015-03-02
     *  Input Parameters: Id - Application Id
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> generatePayoffFigureRequest(ID applicationID, String bankAccountNumber, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId);   
            
            if(appDTO.app.Branch__c != null){
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
            
            //perform validations here
            IS_IValidator validator = new IS_GeneratePayoffFigureValidator (); 
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
                System.debug('validationErrors---->'+validationErrors);
                //failed validation..... return error to caller
                return validationErrors;   
            }
            
            if(exceptionLogId==null) {
                //make the asynchrous web service call 
                System.debug('###generate payoff figure called');
                generatePayoffFigureRequest(applicationID, bankAccountNumber, mockEnable, requestedName);
            } else { //do the synch call if exceptionLogId is present
                processWSPayoffFigure(appDTO, bankAccountNumber, mockEnable, requestedName, exceptionLogId);
            }
            

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_GENERATEPAYOFFFIGURE,
                                                                      'generatePayoffFigureRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
     
	/**  Description: Future call for Generate Payoff Figure Webservice
     *  Author: Tony Xu
     *  Date Created: 2015-03-02
     *  Input Parameters: applicationID
                        : mockEnable 
                        : requestedName
     *  Return: void
     */
    //@future (callout = true)      MLASALA: 17-SEPT-15 - COMMENTED OUT TO MOVE FROM ASYNC TO SYNC CALLS
    public static void generatePayoffFigureRequest(ID applicationID, String bankAccountNumber, Boolean mockEnable, String requestedName) {
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try{ 
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId); 
			if(appDTO.app.Branch__c != null){
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }

            processWSGeneratePayoffFigure(appDTO, bankAccountNumber, mockEnable, requestedName, null); // exceptionLogId is null since ASYNC call is not used for RETRY services

         } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
             															e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_GENERATEPAYOFFFIGURE,
                                                                      'generatePayoffFigureRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Tony xu
     *  Date Created: 2015-03-02
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSGeneratePayoffFigure(IS_ApplicationDTO appDTO, String bankAccountNumber, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_GeneratePayoffFigure wsGeneratePayoffFigure = new WS_GeneratePayoffFigure(mockEnable); 
            IS_WebserviceResponseDTO wsResponse = wsGeneratePayoffFigure.generatePayoffFigureRequest(appDTO, bankAccountNumber, requestedName);

            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_GENERATEPAYOFFFIGURE,
                                                                        'generatePayoffFigureRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId, 
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE);
                   
        } catch (Exception e) {
            throw e;
        }
    }
    
     /**  Description: This will call the WS service class
     *  Author: Tony Xu
     *  Date Created: 2015-03-02
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSPayoffFigure(IS_ApplicationDTO appDTO, String bankAccountNumber, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_GeneratePayoffFigure wsGeneratePayoffFigure = new WS_GeneratePayoffFigure(boolean.Valueof(mockEnable)); 
            IS_WebserviceResponseDTO wsResponse = wsGeneratePayoffFigure.generatePayoffFigureRequest(appDTO, bankAccountNumber, requestedName);     
            
            Boolean success = IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                                            wsResponse.messageDescription,
                                                                                            GEN_OriginationsConstants.WSCLASS_GENERATEPAYOFFFIGURE,
                                                                                            'generatePayoffFigureRequest',
                                                                                            appDTO.app.ID,
                                                                                            requestedName,
                                                                                            exceptionLogId,
                                                                                            appDTO.app,
                                                                                            Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                                            GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE);
           system.debug('=========TXU DEBUG=========='+success);                      
        } catch (Exception e) {
            throw e;
        }
    }
    
    private static Branch__c queryBranchDetails(Id branchId) {
        return [SELECT Branch_Id__c, 
                       name,
                       Phone__c, 
                       Fax__c, 
                       Primary_Contact__r.Name,
                       Suburb__c,
                       State__c,
                       address__c,
                       Postcode__c,
                       Country__c                       
                FROM   Branch__c 
                WHERE  id =: branchId];
    }
    
}