/**
 * @Description: Webservice Class for Confirm Contract Received
 * @Author: Fel Saliba
 * @Date Created: FEB-11-2014
 * @History:
   =====================================================================
       02-11-2014: Created. - Fel
       01-20-2015: Updated. - Sandeep Gali PMIHM #141
   =====================================================================
 */ 
public with sharing class WS_ConfirmContractReceived extends WS_WebserviceCommons{

    public WS_ConfirmContractReceived(Boolean mockEnable) {
        super(mockEnable);
    }
    
     /**  Description: Calls a webservice that invokes Accept Contract Service
    *  Author: Fel Saliba
    *  Date Created: 02-11-13
    *  Input Parameters: Application__c app, String channel
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO confirmContractReceivedRequest(Application__c app, 
                                                 String channel, 
                                                 List<Disbursement__c> disbursements, 
                                                 Applicant__c applicant1, 
                                                 Applicant__c applicant2){
    
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContext;
        ConsumerAnzCapitalGeComOriginations.confirmContractReceivedDataType applicationData;
//        ConsumerAnzCapitalGeComOriginations.decisionDataType decisionData;
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP oass;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;

        try{              
            //***** Set-up Service Context *****
            //Build business and customer context
            ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext(getMainBusinessUnit(), getSubBusinessUnit());
            ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext(getRequestedBy(), channel, getServiceVersion(), getTargetServiceAppSubmit(), businessContext);
            
            //build exception collection (when to populate this?)
            ConsumerAnzCapitalGeComOriginations.Exception_x[] exceptionXList = new ConsumerAnzCapitalGeComOriginations.Exception_x[]{WS_WebServiceHelper.generateExceptionX(null, null, null, null, null, null)}; //still need to populate?
            ConsumerAnzCapitalGeComOriginations.ExceptionCollection exceptionCollection = WS_WebServiceHelper.generateExceptionCollection(exceptionXList);
            
            //build service context
            serviceContext = WS_WebServiceHelper.generateServiceContext(consumerContext, exceptionCollection);
          
            //  Commented for #141   
            /* //****** Set-up Decision Data Type *******
            decisionData = new ConsumerAnzCapitalGeComOriginations.decisionDataType();
            decisionData.setUpLoanAmount = app.Total_Loan_Amount_with_Insurance__c;
            decisionData.setUpLoanTerm = Integer.valueOf(app.Loan_Term_Months__c);
            
            ConsumerAnzCapitalGeComOriginations.CustomerDetails customerDetails = new ConsumerAnzCapitalGeComOriginations.CustomerDetails();
            List<ConsumerAnzCapitalGeComOriginations.CustomerDetail> custDetail = new List<ConsumerAnzCapitalGeComOriginations.CustomerDetail>();
            
            List<Disbursement__c> applicant1Disbursement = new List<Disbursement__c>();
            List<Disbursement__c> applicant2Disbursement = new List<Disbursement__c>();
            Id refinanceRecType = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
            
            //loop through disbursements and add disbursements per applicant.
            for(Disbursement__c d: disbursements) {
                if(d.recordTypeId == refinanceRecType) {
                    if(d.Applicable_Party__c==GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP1) {
                        applicant1Disbursement.add(d);
                    } else if(d.Applicable_Party__c==GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2) {
                        applicant2Disbursement.add(d);
                    } else if(d.Applicable_Party__c==GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH) {
                        applicant1Disbursement.add(d);
                        applicant2Disbursement.add(d);
                    }
                }
            }
            
            custDetail.add(createCustomerDetail(applicant1,applicant1Disbursement));
            if(app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
                custDetail.add(createCustomerDetail(applicant2,applicant2Disbursement));
            }
            
            customerDetails.customer = custDetail;
           // decisionData.customers = customerDetails; */
            
            //***** Set-up confirm Contract Received Data Type *****
            applicationData= new ConsumerAnzCapitalGeComOriginations.confirmContractReceivedDataType();
            applicationData.sfApplicationId = app.id;
            applicationData.applicationId = app.UID__c;
           // applicationData.decisionData = decisionData;            

             //***** Invoke Confirm Contract Received *****
            oass = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.ConfirmContractReceivedResponse_element wsResponse;

            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                mockedCode.messageDescription = '';
                ConsumerAnzCapitalGeComOriginations.ConfirmContractReceivedResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.ConfirmContractReceivedResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = oass.confirmContractReceived(serviceContext, applicationData);
                callSuccessful = true;
            }
            
            String messageDescription = wsResponse.applicationResponse.messageDescription;
            
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
            wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, 
                                                  e.getMessage() + ':' + e.getStackTraceString());
        }  finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_CONFIRMCONTRACTRECEIVED, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, oass.endpoint_x, oass.clientCertName_x, channel, oass.timeout_x, callTime);
            }
        }     
              
        return wsrDTO;
        
    }
     
     //Commented by Sandeep Gali PMIHM #141    
    //maps sfdc field to customer detail element
   /* private ConsumerAnzCapitalGeComOriginations.CustomerDetail createCustomerDetail(Applicant__c applicant, List<Disbursement__c> refinances) {
        ConsumerAnzCapitalGeComOriginations.CustomerDetail custDetail = new ConsumerAnzCapitalGeComOriginations.CustomerDetail();
        
        custDetail.existingRecvCustomerId = applicant.ICBS_Customer_Number__c;
        custDetail.sfApplicantId = applicant.Id;
        if(!refinances.isEmpty()) {
            custDetail.refinanceAccounts = WS_WebServiceHelper.generateRefinance(refinances);
        }
        
        return custDetail;
    } */

}