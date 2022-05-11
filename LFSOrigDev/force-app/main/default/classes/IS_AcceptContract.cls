/**
 * @Description: Integration Class for Accept Contract Service
 * @Author: Dan Crisologo
 * @Date Created: FEB-11-2014
 * @History:
   =====================================================================
       02-11-14: Dan - Created.
       04-09-14: Adrian - Added update response code to 'Pending FIA' on call of asynchronous webservice to GE.
       18-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */ 
global class IS_AcceptContract implements IS_RetryInterface{
    
    /**  Description: Interface method for retry functionality
     *  Author: Dan Crisologo
     *  Date Created: 03-11-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: ExceptionLog__C 
     */
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId){
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        validationErrors = acceptContractRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }
    
    /**  Description: Method that calls accept contract webservice class and pass the required parameters.
     *  Author: Dan Crisologo
     *  Date Created: 02-11-2014
     *  Input Parameters: applicationID, mockEnable, requestedName
     *  Return: List<IS_ValidationError> 
     */
    public static List<IS_ValidationError> acceptContractRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
      List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
      IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
      try {     
          //populate Application
          appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId);
          
          for(sObject applicants: GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId)) {
                Applicant__c applicantResult = (Applicant__c) applicants;
                if(applicantResult.Is_Primary_Applicant__c) {
                    appDTO.applicant = applicantResult; //assign to applicant1 if primary applicant
                } else {
                    appDTO.applicant2 = applicantResult; //assign to applicant2 if secondary applicant
                }
            }
             
          appDTO.collateralList = queryCollaterals(appDTO.app.Id);
          appDTO.complianceCheckList = queryComplianceCheck(appDTO.app.Id);
          appDTO.disbursementList = queryDisbursement(appDTO.app.Id);

          //perform validations here
          IS_IValidator validator = new IS_AcceptContractValidator(); 
          validationErrors = validator.validate(appDTO); 
          if(validationErrors.size()>0) {
            //failed validation..... return error to caller
            return validationErrors;   
          }

          //make the asynchrous web service call 
          if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
              acceptContractRequest(applicationID, mockEnable, requestedName);
          } else { //do the synch call if exceptionLogId is populated
              processWSAcceptContract(appDTO, mockEnable, requestedName, exceptionLogId);
          }

		  // Update response code to Pending FIA.
		  // This will lock contract acceptance access to customers and sales
		  appDTO.app.Response_Code__c = 'Pending Create Loan';
		  update appDTO.app;
		  
      } catch(Exception e){
          IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                      'acceptContractRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);
          validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
      }
      return validationErrors;
    }

    //@future (callout = true)      MLASALA: 18-SEPT-15 - ASYNC TO SYNC CALL OUT
    private static void acceptContractRequest(ID applicationID, Boolean mockEnable, String requestedName) {

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        
        try { 
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId); 
            
            //load other data if needed                   
            processWSAcceptContract(appDTO, mockEnable, requestedName, null);

        } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                      'acceptContractRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSAcceptContract(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_AcceptContract wsAcceptContract = new WS_AcceptContract(boolean.Valueof(mockEnable)); 
            //invoke the request
            IS_WebserviceResponseDTO wsResponse = wsAcceptContract.acceptContractRequest(appDTO.app,requestedName);     
            //process the response
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT,
                                                                        'acceptContractRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT);

        } catch (Exception e) {
            throw e;
        }
    }
    

    private static List<Collateral__c> queryCollaterals(Id applicationId) {
        return [SELECT PPSR_Reference_Number_1__c
                FROM   Collateral__c
                WHERE  Application__c =: applicationId];
    }

    private static List<Compliance_Check__c> queryComplianceCheck(String appId){
        
       List<Compliance_Check__c> compliance = new List<Compliance_Check__c>();
       compliance = [SELECT Id, 
                            PFR_Check__c, 
                            PFR_Only__c, 
                            Pre_Settlement_Indicator__c, 
                            BM_Check__c, 
                            BM_Only__c 
                     FROM   Compliance_Check__c 
                     WHERE  Application__c =: appId];
       
       return compliance;
    }
    
    private static List<Disbursement__c> queryDisbursement(Id applicationId) {
        return [SELECT Fin_Institution__c,
                       Amount__c,
                       Disbursement_Outcome_Comments__c,
                       RecordTypeId,
                       Disbursement_Outcome__c,
                       Disbursement_Account_Type__c,
                       Bank_Acc_No__c,
                       Bank_Acc_No_NZ__c,
                       Financial_Institution_Address_1__c,
                       Financial_Institution_Address_2__c,
                       Payout_Effective_Date__c,
                       Principal_Amount__c,
                       Interest_Due__c,
                       Late_Fees_Due__c,
                       Penalty_Interest_Due__c,
                       Fees_or_Charges_Due__c,
                       Charge_Off_Amount__c,
                       Insurance_Rebate__c,
                       Early_Termination_Fee__c,
                       Net_Payoff_Due__c,
                       New_Credit_Limit__c,
                       Valid_Until_Date__c,
                       Product_Name__c,
                       Record_Type_Name__c,
                       Payee__c,
                       Insurance_Type__c,
                       Broker_Aggregator_Account_Name__c,
                       Broker_Name__c                                              
                FROM   Disbursement__c
                WHERE  Application__c =: applicationId];
                                     
    }
}