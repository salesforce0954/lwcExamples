/**
 * @Description: Webservice Class for Verify AML Service
 * @Author: Dan Crisologo
 * @Date Created: DEC-19-2013
 * @History:
   =====================================================================
       12-19-13: Created. - Dan
   =====================================================================
 */ 
public with sharing class WS_VerifyAML extends WS_WebserviceCommons{

    public WS_VerifyAML(Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Calls a webservice that invokes aml verification service
    *  Author: Dan Crisologo
    *  Date Created: 12-19-13
    *  Input Parameters: app, AMLs1, AMLs2, channel
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO verifyAMLRequest(Application__c app, List<AML__c> AMLs1, List<AML__c> AMLs2,String channel){
    
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP cacgco;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        ConsumerAnzCapitalGeComOriginations.VerifyAMLDataType verifyAMLDataType;
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
            
            //***** Set-up AML Data type *****
            verifyAMLDataType = new ConsumerAnzCapitalGeComOriginations.VerifyAMLDataType();
            verifyAMLDataType.sfApplicationId = app.id;
            verifyAMLDataType.applicationId = app.UID__c;
            verifyAMLDataType.applicants = WS_WebServiceHelper.generateAMLApplicantsCollection(AMLs1, AMLs2);
            system.debug('amls: '+verifyAMLDataType.applicants);
             //***** Invoke Verify AML Service *****
            cacgco = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.VerifyAMLResponse_element wsResponse;
            
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                mockedCode.messageDescription = '';
                ConsumerAnzCapitalGeComOriginations.VerifyAMLResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.VerifyAMLResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = cacgco.verifyAML(serviceContextParam, verifyAMLDataType);
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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_VERIFYAML, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }     
             
        return wsrDTO;
        
    }
    
}