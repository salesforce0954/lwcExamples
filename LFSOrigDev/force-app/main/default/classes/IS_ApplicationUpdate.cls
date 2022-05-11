/**
 * @Description: IS Class for application update service
 * @Author: Dan Crisologo
 * @Date Created: MAR-12-2014
 * @History:
   =====================================================================
        03-12-14: Created. - Dan
        2015-08-12: PMIHM-1307 -Added risk referral workflow detail to pass risk referral decision and decision maker's SSO to Activate - Tony Xu 
        17-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */ 
public class IS_ApplicationUpdate implements IS_RetryInterface{

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
        validationErrors = applicationUpdateRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }

    /**  Description: Method that calls the application update webservice class.
     *  Author: Dan Crisologo
     *  Date Created: 09-19-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: List<IS_ValidationError> - empty if successfull
     */
    public static List<IS_ValidationError> applicationUpdateRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      String response; 
      ExceptionLog__C exLog = null;                
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();

      try {    
        //populate Application, Applicant1 and Applicant2
        appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);

        if(appDTO.applicant!=null) {

           //load budget details, products, ONRs, loan purposes
           appDTO = IS_WebserviceCommonUtil.loadOtherApplicationData(appDTO);
           //for update, load insurance, disbursements and broker details
           appDTO = IS_WebserviceCommonUtil.loadAdditionalUpdateData(appDTO);
           //load user and branch
           appDTO = IS_WebserviceCommonUtil.loadUserAndBranchData(appDTO, requestedName);
           //load aml data
           appDTO = IS_WebserviceCommonUtil.loadAdditionalSubmitData(appDTO);
           //PMIHM-1307 2015-08-12 Tony Xu Start
           appDTO = IS_WebserviceCommonUtil.loadRiskWorkflow(appDTO);
       //=====END
       
           //perform validations here
           IS_IValidator validator = new IS_ApplicationUpdateValidator(); 
           validationErrors = validator.validate(appDTO); 
           if(validationErrors.size()>0) {
              //failed validation..... return error to caller
              return validationErrors;   
           }

           //BEGIN MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
           //BEGIN MLASALA 10-SEPT-2015     FORCE APPLICATION UPDATE PRIOR TO DOC GEN
           //else {

           //     //Validate if doc gen was done
           //     if(appDTO.app.Doc_Gen_Check__c){

           //         //Validate if update is because of doc gen
           //         if(appDTO.app.Update_Doc_Gen_Check__c){

           //             //Set update doc gen check flag
           //             appDTO.app.Update_Doc_Gen_Check__c = false;
           //         } else {

           //             appDTO.app.Update_Doc_Gen_Check__c = true;
           //         }

           //         try{
           //             update appDTO.app;
           //         }
           //         catch(Exception e){
           //             ErrorHandlerException.recordException(e.getMessage(),'applicationUpdateRequest','Application__c','IS_ApplicationUpdate', String.valueOf(appDTO.app.Id));
           //         }
           //     }
           //}
           //END MLASALA 10-SEPT-2015     FORCE APPLICATION UPDATE PRIOR TO DOC GEN
           //END MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
           
           if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                applicationUpdateRequest(applicationID, mockEnable, requestedName);
            } else { //do the synch call if exceptionLogId is present
                processWSApplicationUpdate(appDTO, mockEnable, requestedName, exceptionLogId);
            }

        } else {
            String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPLICANTID_NOT_FOUND + applicationId + applicationId;
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_UPDATE, errorMesg));
        }
        
      } catch(Exception e){
        IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_UPDATE,
                                                                      'ApplicationUpdateRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_UPDATE);
        validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_UPDATE, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));

      }
      return validationErrors;
    }

    //@future (callout = true)      MLASALA: 17-SEPT-15 - COMMENTED OUT TO MOVE FROM ASYNC TO SYNC CALLS
    private static void applicationUpdateRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try {
            //populate Application, Applicant1 and Applicant2
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            //load budget details, products, ONRs, loan purposes,Brand data
            appDTO = IS_WebserviceCommonUtil.loadOtherApplicationData(appDTO);
            //for update, load insurance, disbursements and broker details
            appDTO = IS_WebserviceCommonUtil.loadAdditionalUpdateData(appDTO);
            //load user and branch
            appDTO = IS_WebserviceCommonUtil.loadUserAndBranchData(appDTO, requestedName);
            //load aml data
            appDTO = IS_WebserviceCommonUtil.loadAdditionalSubmitData(appDTO);
            //PMIHM-1307 2015-08-12 Tony Xu Start
            appDTO = IS_WebserviceCommonUtil.loadRiskWorkflow(appDTO);
        //=====END


            processWSApplicationUpdate(appDTO, mockEnable, requestedName, null);
            
        } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.WSCLASS_UPDATE,
                                                                        'ApplicationUpdateRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        null,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_UPDATE);
        }
        
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSApplicationUpdate(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
          
            WS_ApplicationUpdate wsAppUpdate = new WS_ApplicationUpdate(mockEnable);
        system.debug('!@#$Workflow:'+appDTO.workflowList);
            //invoke webservice request
            IS_WebserviceResponseDTO wsResponse = wsAppUpdate.applicationUpdateRequest(appDTO.app, appDTO.loanPurList, appDTO.onrList, appDTO.product, appDTO.branch, appDTO.applicationOwner, appDTO.applicationDebits,
                                                               appDTO.feesAndCharges, appDTO.applicant, appDTO.incList, appDTO.assetList, appDTO.debtList, appDTO.expenseList,
                                                               appDTO.applicant2, appDTO.incList2, appDTO.assetList2, appDTO.debtList2, appDTO.expenseList2,
                                                               appDTO.collateralList, appDTO.personalReferenceList, appDTO.insuranceList, appDTO.clvList, appDTO.clvList2, 
                                                               appDTO.brokerDetails, appDTO.disbursementList, appDTO.complianceCheckList, appDTO.disbursementList, requestedName, appDTO.amlList, appDTO.amlList2, appDTO.workflowList);      

            //process the webservice response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                    wsResponse.messageDescription,
                                                    GEN_OriginationsConstants.WSCLASS_UPDATE,
                                                    'applicationUpdateRequest',
                                                    appDTO.app.Id,
                                                    requestedName,
                                                    exceptionLogId,
                                                    appDTO.app,
                                                    Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                    GEN_OriginationsConstants.SERVICENAME_UPDATE);
                                                    
        } catch (Exception e) {
            throw e;
        }
    }

}