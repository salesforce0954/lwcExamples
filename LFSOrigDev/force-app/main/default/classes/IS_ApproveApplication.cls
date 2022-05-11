/**
 * @Description: Integration Class for Approve Application Service
 * @Author: Adrian Recio
 * @Date Created: MARCH-23-2016
 * @History:
   =====================================================================
       23-03-16: Adrian Recio - Created.
   =====================================================================
 */ 
global class IS_ApproveApplication implements IS_RetryInterface{

	
    /**  Description: Interface method for retry functionality
     *  Author: Adrian Recio
     *  Date Created: 23-03-16
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
   
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId){
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        validationErrors = approveApplicationRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
  
    
    /**  Description: Method that calls approve application webservice class and pass the required parameters.
     *  Author: Adrian recio
     *  Date Created: 23-03-2016
     *  Input Parameters: applicationID, mockEnable, requestedName
     *  Return: List<IS_ValidationError> 
     */
    public static List<IS_ValidationError> approveApplicationRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
      try {     
          //populate Application
          appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId);
          
		  // Place any custom validations here
		  // Place any extra values in the retrieve application here if necessary 

          //make the asynchrous web service call 
          if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
              approveApplicationRequest(applicationID, mockEnable, requestedName);
          } else { //do the synch call if exceptionLogId is populated
              processWSApproveApplication(appDTO, mockEnable, requestedName, exceptionLogId);
          }

		  // Update response code to Pending FIA.
		  // This will lock contract acceptance access to customers and sales
		  //appDTO.app.Response_Code__c = 'Pending Create Loan';
		  //update appDTO.app;
		  
      } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      //GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                      GEN_OriginationsConstants.WSCLASS_APPROVEAPPLICATION,
                                                                      //'acceptContractRequest',
                                                                      'approveApplicationRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      //GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);
																	  GEN_OriginationsConstants.SERVICENAME_APPROVEAPPLICATION);
          //validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
          validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_APPROVEAPPLICATION, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    //@future (callout = true)      
    private static void approveApplicationRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try { 
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId); 
            
            //load other data if needed                   
            processWSApproveApplication(appDTO, mockEnable, requestedName, null);

        } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      //GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                      GEN_OriginationsConstants.WSCLASS_APPROVEAPPLICATION,
                                                                      //'acceptContractRequest',
                                                                      'approveApplicationRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      //GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);
																	  GEN_OriginationsConstants.SERVICENAME_APPROVEAPPLICATION);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Adrian Recio
     *  Date Created: 23-03-2016
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSApproveApplication(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            //WS_AcceptContract wsAcceptContract = new WS_AcceptContract(boolean.Valueof(mockEnable)); 
            WS_ApproveApplication wsApproveAppplication = new WS_ApproveApplication(boolean.Valueof(mockEnable)); 

            //invoke the request
            //IS_WebserviceResponseDTO wsResponse = wsAcceptContract.acceptContractRequest(appDTO.app,requestedName);     
            IS_WebserviceResponseDTO wsResponse = wsApproveAppplication.approveApplicationRequest(appDTO.app,requestedName);

            //process the response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        //GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                        GEN_OriginationsConstants.WSCLASS_APPROVEAPPLICATION,
                                                                        //'acceptContractRequest',
                                                                        'approveApplicationRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        //GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);
																		GEN_OriginationsConstants.SERVICENAME_APPROVEAPPLICATION);

        } catch (Exception e) {
            throw e;
        }
    }
}