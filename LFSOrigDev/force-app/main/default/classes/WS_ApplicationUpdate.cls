/**
 * @Description: Webservice class for application update
 * @Author: Dan Crisologo
 * @Date Created: MAR-12-2013
 * @History:
   =====================================================================
       03-12-14: Created. - Dan 
       2015-01-28: Update by Tony Xu - fix defect #125. App Update now sending AML block
       2015-08-12: PMIHM-1307 Added risk referral workflow detail to pass risk referral decision 
                   and decision maker's SSO to Activate - Tony Xu
   =====================================================================
 */ 
public with sharing class WS_ApplicationUpdate extends WS_WebserviceCommons{

    public WS_ApplicationUpdate(Boolean mockEnable) {
        super(mockEnable); 
    }

    /**  Description: Method that populates the Application data for webservice update
    *  Author: Dan Crisologo
    *  Date Created: 12-16-2013
    *  Return: IS_WebserviceResponseDTO     
    */
    public IS_WebserviceResponseDTO applicationUpdateRequest(Application__c application, 
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
                                                               List<Product_Item__c> insuranceList,
                                                               List<Applicant_CLV__c> applicant1CLVList,
                                                               List<Applicant_CLV__c> applicant2CLVList,
                                                               Contact broker, 
                                                               List<Disbursement__c> disbursements,
                                                               List<Compliance_Check__c> complianceCheck,
                                                               List<Disbursement__c> refinances,
                                                               String channel,
                                                               //Tony Xu Defect Fix #125
                                                               List<AML__c> amlList,
                                                               List<AML__c> amlList2,
                                                               //PMIHM-1307 Start
                                                               List<Workflow__c> workflowList
                                                               ){       
                                        
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
            
            //for application update, populate the cpu override data, insurance, disbursements and broker details
            ConsumerAnzCapitalGeComOriginations.ApplicationCpuOverrideDataType applicationCpuOverrideData;
            if(application.Max_Capacity_Unsecured_Risk__c != null && 
               application.Max_Capacity_Secured_Risk__c != null){
                
                applicationCpuOverrideData = WS_WebServiceHelper.generateApplicationCpuOverrideDataType(application);
            }
           
            //***** Set-up Insurance Collection *****
            if(insuranceList!=null) {
                if(!insuranceList.isEmpty()) {
                    applicationData.applicationCustomerData.insuranceDetails = WS_WebServiceHelper.generateInsuranceCollection(insuranceList);
                }
            }
            
            //***** Set-up Disbursement Collection *****
            if(disbursements!=null) {
                if(!disbursements.isEmpty()) {
                    applicationData.applicationCustomerData.disbursements = WS_WebServiceHelper.generateDisbursementCollection(disbursements);
                }
            }
            
            //***** Set-up Broker Details if present *****
            if(broker!=null) {
                applicationData.applicationCustomerData.brokerDetails = WS_WebServiceHelper.generateBrokerDetailsType(broker, application);
            }
            
            /**Added by Tony Xu Defect fix 125 START**/
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
            /**END**/
            
            /**PMIHM-1307 Tony Xu START **/
            consumerAnzCapitalGeComOriginations.riskUserDataType riskUserDataType;
            if(workflowList.size() > 0){
                //MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance - Added application parameter
                riskUserDataType = WS_WebServiceHelper.generateRiskUserDataType(workflowList[0], application);
            } else {
                //MLASALA: 30-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance - Added condition when there is no risk referral to pass required fields
                riskUserDataType = WS_WebServiceHelper.generateRiskUserDataType(null, application);
            }
            system.debug('!@#$riskUserDataType:'+riskUserDataType);
            /**END**/

            //Added by FSALIBA - 12/2/2014 - (DBHZL- 55)
            //***** Set-UP Offer Details *****
            applicationData.applicationCustomerData.offerDetails = WS_WebServiceHelper.generateOfferDetailsType(application);
                        
            //***** Set-up Compliance Checks if present *****
            for(Compliance_Check__c cc: complianceCheck) {
                if(cc.Meta_Compliance_Post_Settle__r.Integration_ID__c!=null) {
                    if(cc.Meta_Compliance_Post_Settle__r.Integration_ID__c == GEN_OriginationsConstants.COMPLIANCE_LPI_BY_PHONE) {
                    
                        applicationData.applicationCustomerData.lpiByPhone = cc.PFR_Check__c==GEN_OriginationsConstants.CHOICE_YES ? true: false;
                        
                    } else if(cc.Meta_Compliance_Post_Settle__r.Integration_ID__c == GEN_OriginationsConstants.COMPLIANCE_MASTERCARD_XLIST) {
                    
                        applicationData.applicationCustomerData.mastercardXSell = cc.PFR_Check__c==GEN_OriginationsConstants.CHOICE_YES ? true: false;
                        
                    } else if(cc.Meta_Compliance_Post_Settle__r.Integration_ID__c == GEN_OriginationsConstants.COMPLIANCE_MVI_REFERRAL) {
                    
                        applicationData.applicationCustomerData.mviReferral = cc.PFR_Check__c==GEN_OriginationsConstants.CHOICE_YES ? true: false;
                        
                    }
                }
            }

            //Added for system control PHIHM #141 Sandeep Gali
            ConsumerAnzCapitalGeComOriginations.decisionDataType decisionData = WS_WebServiceHelper.generateDecisionDataType(application);

             //***** Invoke Update Application Service *****
            System.debug('***** Sending application update *****');  
             
            cacgco = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.UpdateApplicationResponse_element wsResponse;
            system.debug('applicationData: '+applicationData);
            if(Test.isRunningTest()) {
              //Generate a mocked-response since we cannot simulate the actual webservice call
              ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
              mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
              mockedCode.messageDescription = '';
              ConsumerAnzCapitalGeComOriginations.UpdateApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.UpdateApplicationResponse_element();
              mockedResponse.applicationResponse = mockedCode;
              wsResponse = mockedResponse;
            } else {
              callAttempted = true;
              callTime = System.currentTimeMillis();
              wsResponse = cacgco.updateApplication(applicationData.serviceContextParam, 
                                                    applicationData.applicationCustomerData, 
                                                    //applicationData.thirdpartyData, // Afreen- June 22,2016- for thirdparty details
                                                    applicationData.reportDetailsData, // Afreen- June 22,2016- for TOM reporting
                                                    applicationCpuOverrideData,
                                                    applicationData.applicationSupportingData,
                                                    decisionData,
                                                    amlApplicants,
                                                    riskUserDataType    //2015-08-12 Tony Xu PMIHM-1307
                                                    );
              System.debug('***************************wsresponse = ' + wsResponse);
              callSuccessful = true;
            }
            
            String messageDescription = wsResponse.applicationResponse.messageDescription;
            if(wsResponse.applicationResponse.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
            }
            
            System.debug('message description  = ' + messageDescription);
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.applicationResponse.messageCode, messageDescription);
            
            System.debug('WSDTO = ' + wsrDTO);
        } catch(CalloutException ce){ 
            System.debug('Callout Exception Occured: ' + ce.getMessage() + '- -' + ce.getStackTraceString());
            if(ce.getMessage().indexOf('Read timed out')!=-1) { //timeout exception - not able to receive a response within a specified time
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_SFTIMEOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
                 
                 System.debug('callout exception wsrDTO = ' + wsrDTO);
            } else { //other callout exception. Parse exception, invalid endpoint, etc
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_CALLOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
                System.debug('callout exception wsrDTO = ' + wsrDTO);
            }
        } catch(Exception e){ 
            System.debug('General Exception Occured: ' + e.getMessage() + '- -' + e.getStackTraceString());
            wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, 
                                                  e.getMessage() + ':' + e.getStackTraceString());
           System.debug('callout exception wsrDTO = ' + wsrDTO);
        } finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_UPDATE, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, application.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }        
             
        return wsrDTO;
    
    }
    
}