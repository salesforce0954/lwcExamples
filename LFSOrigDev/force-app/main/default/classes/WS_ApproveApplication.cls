/**
 * @Description: Webservice Class for Approve Application Service
 * @Author: Adrian Recio
 * @Date Created: MARCH-23-2016
 * @History:
   =====================================================================
       23-03-2016: Created. - Adrian Recio
   =====================================================================
 */ 
public with sharing class WS_ApproveApplication extends WS_WebserviceCommons{
	
    public WS_ApproveApplication(Boolean mockEnable) {
        super(mockEnable);
    }

    /* Description: Calls a webservice that invokes Accept Contract Service
    *  Author: Adrian Recio
    *  Date Created: 23-03-16
    *  Input Parameters: Application__c app - application record
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO approveApplicationRequest(Application__c app, string channel){
    
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        //ConsumerAnzCapitalGeComOriginations.AcceptContractDataType acceptContractData;
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
            serviceContextParam = WS_WebServiceHelper.generateServiceContext(consumerContext, exceptionCollection);
            
            //***** Set-up Accept Contract type *****
            /*
            acceptContractData = new ConsumerAnzCapitalGeComOriginations.acceptContractDataType();
            acceptContractData.sfApplicationId = app.id;
            acceptContractData.applicationId = app.UID__c;
            */
            
             //***** Invoke Approve Application Service *****
            oass = setupApplicationServiceSOAP();
            //ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element wsResponse;
            ConsumerAnzCapitalGeComOriginations.approveApplicationResponse_element wsResponse;
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                //ConsumerAnzCapitalGeComOriginations.receiveApplicationType mockedCode = new ConsumerAnzCapitalGeComOriginations.receiveApplicationType();

                mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                mockedCode.messageDescription = '';
                //ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element();
                ConsumerAnzCapitalGeComOriginations.approveApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.approveApplicationResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                //mockedResponse.approveApplicationResult = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();

                consumerAnzCapitalGeComOriginations.approveApplicationDataType approveApplicationDataTypeVar = new consumerAnzCapitalGeComOriginations.approveApplicationDataType();
                approveApplicationDataTypeVar.sfApplicationId = app.Id;
                approveApplicationDataTypeVar.applicationNumber = app.UID__c;

                //wsResponse = oass.acceptContract(serviceContextParam, acceptContractData);
                wsResponse = oass.approveApplication(serviceContextParam, approveApplicationDataTypeVar);
                callSuccessful = true;
            }
            
            String messageDescription = wsResponse.applicationResponse.messageDescription;
            //String messageDescription = wsResponse.approveApplicationResult.messageDescription;
            
            
            if(wsResponse.applicationResponse.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.applicationResponse.messageCode, messageDescription);
            
            /*
            if(wsResponse.approveApplicationResult.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.approveApplicationResult.messageCode, messageDescription);
            */
            
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
        } finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               //insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, oass.endpoint_x, oass.clientCertName_x, channel, oass.timeout_x, callTime);
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_APPROVEAPPLICATION, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, oass.endpoint_x, oass.clientCertName_x, channel, oass.timeout_x, callTime);
            }
        }   

        return wsrDTO;
        
    }
}