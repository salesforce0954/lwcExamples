/**
 * @Description: Class that handles the Appication Cancel Webservice Request
 * @Author: Dan Crisologo
 * @Date Created: DEC-10-2013
 * @History:
   =====================================================================
       12-10-13: Refactored out from IS_ApplicationSubmit - Dan
       13-08-2015: PMIHM-1307 - Added risk referral workflow detail to pass risk referral decision 
       			   and decision maker's SSO to Activate
   =====================================================================
 */ 
global class IS_ApplicationCancel implements IS_RetryInterface{

    /**  Description: Interface method for retry functionality
     *  Author: Dan Crisologo
     *  Date Created: 03-11-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, 
                                                              Boolean mockEnable, 
                                                              String requestedName, 
                                                              Id exceptionLogId) {
        
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
    
        //Do all necessary pre-retry operations here
        try {
            String cancelReason = '';
            String cancelIntent = '';
            //query the latest cancel workflow record
            Id closeWFTypeId = Schema.SObjectType.Workflow__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.WORKFLOW_STATUS_CLOSEAPP).getRecordTypeId();
            Workflow__c wf = [SELECT Comments__c,
                                     Status__c
                              FROM   Workflow__c
                              WHERE  Application__c =: applicationID
                               AND   RecordTypeId =: closeWFTypeId];
            
            if(wf!=null) {
                cancelReason = wf.Status__c;
                cancelIntent = wf.Comments__c;
            }
            //invoke the cancel service
            validationErrors = applicationCancelRequest(applicationID, 
                                                        cancelReason, 
                                                        cancelIntent, 
                                                        mockEnable, 
                                                        requestedName, 
                                                        exceptionLogId);

        } catch (Exception e) {
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_CANCELDECLINE, GEN_OriginationsConstants.ERR_MESSAGE_WORKFLOW_NO_LONGER_EXISTS));
        }
        
        
        return validationErrors;
    }

    /**  Description: Calls the Application Cancel Request webservice
     *  Author: Dan Crisologo
     *  Date Created: 11-11-13
     *  Input Parameters: Id - Application Id
     *  Return: ExceptionLog__C
     */
    public static List<IS_ValidationError> applicationCancelRequest(ID applicationID, 
                                                                    String cancelReason, 
                                                                    String cancelIntent, 
                                                                    Boolean mockEnable, 
                                                                    String requestedName, 
                                                                    Id exceptionLogId) {
        
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {   
            //query all necessary data
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId);   
            //PMIHM-1307 2015-08-13 Kabir Start
            appDTO = IS_WebserviceCommonUtil.loadRiskWorkflow(appDTO);
		    //=====END
            
            IS_IValidator validator = new IS_ApplicationCancelValidator(); 
            
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
                //failed validation..... return error to caller
                return validationErrors;   
            }
            
            //invoke the service
            WS_ApplicationCancel wsAppCancel = new WS_ApplicationCancel(mockEnable);
            //PMIHM-1307 2015-08-13 Kabir Start
            IS_WebserviceResponseDTO wsResponse = wsAppCancel.applicationDeclineCancelRequest(appDTO.app, cancelReason, cancelIntent, requestedName, appDTO.workflowList);
			//=====END
            //process the response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_CANCELDECLINE,
                                                                        'applicationCancelRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_CANCELDECLINE);
            
        } catch(Exception e){
           IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                       e.getMessage() + ':' + e.getStackTraceString(),
                                                                       GEN_OriginationsConstants.WSCLASS_CANCELDECLINE,
                                                                       'ApplicationCancelRequest',
                                                                       appDTO.app.ID,
                                                                       requestedName,
                                                                       null,
                                                                       appDTO.app,
                                                                       Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                       GEN_OriginationsConstants.WSCLASS_CANCELDECLINE);
           validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_CANCELDECLINE, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
    
}