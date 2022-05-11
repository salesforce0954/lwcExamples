/**
 * @Description: Webservice Class for Accept Contract Service
 * @Author: Dan Crisologo
 * @Date Created: FEB-11-2014
 * @History:
   =====================================================================
       02-11-2014: Created. - Dan
   =====================================================================
 */ 
public with sharing class WS_AcceptContract extends WS_WebserviceCommons{

    public WS_AcceptContract(Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Calls a webservice that invokes Accept Contract Service
    *  Author: Dan Crisologo
    *  Date Created: 02-11-13
    *  Input Parameters: Application__c app - application record
                         String channel - source of call. either sales / customer ui
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO acceptContractRequest(Application__c app, String channel){
    
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        ConsumerAnzCapitalGeComOriginations.AcceptContractDataType acceptContractData;
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
            acceptContractData = new ConsumerAnzCapitalGeComOriginations.acceptContractDataType();
            acceptContractData.sfApplicationId = app.id;
            acceptContractData.applicationId = app.UID__c;
            
             //***** Invoke Accept Contract Service *****
            oass = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element wsResponse;
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                mockedCode.messageDescription = '';
                ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.acceptContractResponse_element();
                mockedResponse.applicationResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = oass.acceptContract(serviceContextParam, acceptContractData);
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
        } finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_ACCEPTCONTRACT, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, app.id, oass.endpoint_x, oass.clientCertName_x, channel, oass.timeout_x, callTime);
            }
        }   

        return wsrDTO;
        
    }
    
}