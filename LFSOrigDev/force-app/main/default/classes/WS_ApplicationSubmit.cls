/**
 * @Description: Class that pass the application data in the web service
 * @Author: Dan Crisologo
 * @Date Created: SEPT-23-2013
 * @History:
   =====================================================================
       10-23-13: Created. - Dan
       12-10-13: Application Cancel moved to WS_ApplicationCancel
                 Added WS_WebserviceCommons as parent
       12-12-13: Added Application Update     
   =====================================================================
 */ 
public with sharing class WS_ApplicationSubmit extends WS_WebserviceCommons{

    public WS_ApplicationSubmit(Boolean mockEnable) {
        super(mockEnable); 
    }

    /**  Description: Method that populates the Application data for webservice submit
    *  Author: Dan Crisologo
    *  Date Created: 09-23-13
    *  Return: IS_WebserviceResponseDTO      
    */
    public IS_WebserviceResponseDTO applicationSubmitRequest(Application__c application, 
                                                               List<Loan_Purpose__c> loanPurposeList,
                                                               List<ONR__C> onrList,
                                                               GEProduct__c product,
                                                               Branch__c branch,
                                                               User appOwner,
                                                               List<Debit__c> debits,
                                                               List<Fees_Charges__c> feesAndCharges,
                                                               Applicant__c applicant, 
                                                               List<Income__c> incomeList, 
                                                               List<Asset__c> assetList, 
                                                               List<Liability__c> debtList, 
                                                               List<Expense__c> expList, 
                                                               Applicant__c applicant2, 
                                                               List<Income__c> incomeList2, 
                                                               List<Asset__c> assetList2, 
                                                               List<Liability__c> debtList2, 
                                                               List<Expense__c> expList2, 
                                                               List<Collateral__c> collaterals,
                                                               List<Personal_Reference_Check__c> personalReferenceList,
                                                               List<Applicant_CLV__c> applicant1CLVList,
                                                               List<Applicant_CLV__c> applicant2CLVList,
                                                               List<AML__c> amlList,
                                                               List<AML__c> amlList2,
                                                               Contact broker,
                                                               List<Disbursement__c> refinances,
                                                               String channel){       
                                        
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP cacgco;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;
        
        try {  
            //***** Create request data *****
            GenericApplicationData applicationData = setupGenericApplicationData(application, 
                                                           loanPurposeList,
                                                           onrList,
                                                           product,
                                                           branch,
                                                           appOwner,
                                                           debits,
                                                           feesAndCharges,
                                                           applicant, 
                                                           incomeList, 
                                                           assetList, 
                                                           debtList, 
                                                           expList, 
                                                           applicant2, 
                                                           incomeList2, 
                                                           assetList2, 
                                                           debtList2, 
                                                           expList2,
                                                           collaterals,
                                                           personalReferenceList,
                                                           applicant1CLVList,
                                                           applicant2CLVList,
                                                           refinances,
                                                           channel);
        
            //***** Create additional app submit data *****
            ConsumerAnzCapitalGeComOriginations.amlApplicantsCollection amlApplicants;
            Boolean isAMLAvailable = false;
            //check if AML exists
            if(amlList!=null) {
                if(!amlList.isEmpty()) {
                    isAMLAvailable = true;
                }
            }
            if(amlList2!=null) {
                if(!amlList2.isEmpty()) {
                    isAMLAvailable = true;
                }
            }
            //populate additional AML data if at least one aml is present
            if(isAMLAvailable) {
                amlApplicants = WS_WebServiceHelper.generateAMLApplicantsCollection(amlList, amlList2);
            }
            
            //***** Set-up Broker Details if present *****
            if(broker!=null) {
                applicationData.applicationCustomerData.brokerDetails = WS_WebServiceHelper.generateBrokerDetailsType(broker, application);
            }
        
            //***** Invoke Submit Application Service *****
             
            System.debug('***** Sending application submit *****');  
            System.debug('$$$ applicationData: '+applicationData);
            cacgco = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.SubmitApplicationResponse_element wsResponse;
            if(TestDataBuilder.IsTestFlag) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                mockedCode.messageDescription = '';
                ConsumerAnzCapitalGeComOriginations.SubmitApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.SubmitApplicationResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = cacgco.submitApplication(applicationData.serviceContextParam, 
                                                      applicationData.applicationCustomerData, 
                                                      applicationData.applicationSupportingData,
                                                      amlApplicants
                                                      //applicationData.thirdpartyData, // Afreen- June 27,2016- for thirdparty details
                                                      //applicationData.reportDetailsData // Afreen- June 27,2016- for TOM reporting 
                                                     );
                callSuccessful = true;
            }
            
            string messageDescription;
            
            try{
              consumerAnzCapitalGeComOriginations.Exception_x[] exResponseList = wsResponse.serviceContext.exceptions.exception_x;
              string errStrVar = '--->';
              for(consumerAnzCapitalGeComOriginations.Exception_x exRVar:exResponseList){
                errStrVar = errStrVar + '{{{{{';
                errStrVar = errStrVar + '(code:' + exRVar.code + ')';
                errStrVar = errStrVar + '(severity:' + exRVar.severity + ')';
                errStrVar = errStrVar + '(occurredTime:' + exRVar.occurredTime + ')';
                errStrVar = errStrVar + '(message:' + exRVar.message + ')';
                errStrVar = errStrVar + '(detailMessage:' + exRVar.detailedMessage + ')';
                errStrVar = errStrVar + '(sourceSystem:' + exRVar.sourceSystem + ')' + '}}}}}';
              }

              messageDescription = wsResponse.applicationResponse.messageDescription + errStrVar;
            }catch(Exception e){
                messageDescription = wsResponse.applicationResponse.messageDescription;
            } 
            
            if(wsResponse.applicationResponse.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.applicationResponse.messageCode, messageDescription);

        } catch(CalloutException ce){ 
            System.debug('Callout Exception Occured: ' + ce.getMessage() + '- -' + ce.getStackTraceString());
            if(ce.getMessage().indexOf('Read timed out')!=-1) { //timeout exception - not able to receive a response within a specified time
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_SFTIMEOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
            } else { //other callout exception. Parse exception, invalid endpoint, etc
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_CALLOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
            }
        } catch(Exception e){ 
            System.debug('General Exception Occured: ' + e.getMessage() + '- -' + e.getStackTraceString());
            wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_PRESUBMIT_EXCEPTION, 
                                                  e.getMessage() + ':' + e.getStackTraceString());
        } finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_SUBMIT, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, application.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }     
             
        return wsrDTO;
    
    }

}