/**
 * @Description: Webservice Class for Verify POI Service
 * @Author: Dan Crisologo
 * @Date Created: DEC-20-2013
 * @History:
   =====================================================================
       12-20-13: Created. - Dan
   =====================================================================
 */ 
public with sharing class WS_VerifyPOI extends WS_WebserviceCommons{

    public WS_VerifyPOI(Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Calls a webservice that invokes aml verification service
    *  Author: Dan Crisologo
    *  Date Created: 12-20-13
    *  Input Parameters: app, applicant1, applicant2, channel
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO verifyPOIRequest(         
                                                        Application__c app, 
                                                        Applicant__c applicant1, 
                                                        Applicant__c applicant2,
                                                        List<Income__c> incomeList, 
                                                        List<Income__c> incomeList2, 
                                                        String channel){
    
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        ConsumerAnzCapitalGeComOriginations.VerifyPOIDataType verifyPOIDataType;
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP cacgco;
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
            serviceContextParam = WS_WebServiceHelper.generateServiceContext(consumerContext, exceptionCollection);
            
            //***** Set-up POI Data type *****
            verifyPOIDataType = new ConsumerAnzCapitalGeComOriginations.VerifyPOIDataType();
            verifyPOIDataType.sfApplicationId = app.id;
            verifyPOIDataType.applicationId = app.UID__c;
            system.debug('Income Details ' + incomeList + 'Income Detail 2' + incomeList2);
            verifyPOIDataType.applicants = WS_WebServiceHelper.generatePOIApplicantsCollection(applicant1, applicant2,incomeList,incomeList2);

             //***** Invoke Verify AML Service *****
            cacgco = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.verifyPOIResponse_element wsResponse;
            
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                mockedCode.messageDescription = '';
                ConsumerAnzCapitalGeComOriginations.verifyPOIResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.verifyPOIResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = cacgco.verifyPOI(serviceContextParam, verifyPOIDataType);
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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_VERIFYPOI, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }       
             
        return wsrDTO;
        
    }
    
}