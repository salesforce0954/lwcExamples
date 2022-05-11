/**
 * @Description: Webservice Class for Application Cancel
 * @Author: Dan Crisologo
 * @Date Created: DEC-10-2013
 * @History:
   =====================================================================
       12-10-13: Created. - Dan
       13-08-2015: PMIHM-1307 - Added risk referral workflow detail to pass risk referral decision 
       			   and decision maker's SSO to Activate
   =====================================================================
 */ 
public with sharing class WS_ApplicationCancel extends WS_WebserviceCommons{

    public WS_ApplicationCancel (Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Method that cancels application request sent previously
    *  Author: Dan Crisologo
    *  Date Created: 11-11-13
    *  Return: IS_WebserviceResponseDTO - webservice response   
    */
    public IS_WebserviceResponseDTO applicationDeclineCancelRequest(Application__c application, String reason, String intent, String channel, List<Workflow__c> workflowList /*PMIHM-1307 */ ){       
                                        
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        ConsumerAnzCapitalGeComOriginations.ApplicationDataType applicationDataType;     
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
            applicationDataType = WS_WebServiceHelper.generateApplicationDataType(application.Id, application.uid__c, intent, reason);
            
            /**PMIHM-1307  START **/
            ConsumerAnzCapitalGeComOriginations.riskUserDataType riskUserDataType;
            if(workflowList.size() > 0){
            	//MLASALA: 24-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance - Added application parameter
            	riskUserDataType = WS_WebServiceHelper.generateRiskUserDataType(workflowList[0], application);
            }
            /**END**/

             //***** Invoke Cancel Application Service *****
            cacgco = setupApplicationServiceSOAP();
            
            //check whether to invoke cancel or decline
            if(invokeCancelCall(reason)) {
                ConsumerAnzCapitalGeComOriginations.CancelApplicationResponse_element wsResponse ;
                
                if(Test.isRunningTest()) {
                    //Generate a mocked-response since we cannot simulate the actual webservice call
                    ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                    mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                    mockedCode.messageDescription = '';
                    ConsumerAnzCapitalGeComOriginations.CancelApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.CancelApplicationResponse_element();
                    mockedResponse.applicationResponse = mockedCode;
                    wsResponse = mockedResponse;
                } else {
                    callAttempted = true;
                    callTime = System.currentTimeMillis();
                    wsResponse = cacgco.cancelApplication(serviceContextParam, applicationDataType, riskUserDataType);/**PMIHM-1307  Added riskUserDataType **/
                    callSuccessful = true;
                }
                
                String messageDescription = wsResponse.applicationResponse.messageDescription;
            
                if(wsResponse.applicationResponse.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                    messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
                }
                
                wsrDTO = new IS_WebserviceResponseDTO(wsResponse.applicationResponse.messageCode, messageDescription);
            } else {
                ConsumerAnzCapitalGeComOriginations.DeclineApplicationResponse_element wsResponse;
                
                if(Test.isRunningTest()) {
                    //Generate a mocked-response since we cannot simulate the actual webservice call
                    ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                    mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                    mockedCode.messageDescription = '';
                    ConsumerAnzCapitalGeComOriginations.DeclineApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.DeclineApplicationResponse_element();
                    mockedResponse.applicationResponse = mockedCode;
                    wsResponse = mockedResponse;
                } else {
                    callAttempted = true;
                    callTime = System.currentTimeMillis();
                    wsResponse = cacgco.declineApplication(serviceContextParam, applicationDataType, riskUserDataType);/**PMIHM-1307  Added riskUserDataType **/
                    callSuccessful = true;
                }
                
                String messageDescription = wsResponse.applicationResponse.messageDescription;
            
                if(wsResponse.applicationResponse.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                    messageDescription = messageDescription + IS_WebserviceCommonUtil.getOASSExceptionDetail(wsResponse.serviceContext);
                }
                
                wsrDTO = new IS_WebserviceResponseDTO(wsResponse.applicationResponse.messageCode, messageDescription);
            }

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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_CANCELDECLINE, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, application.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }         
             
        return wsrDTO;
    
    }
    
    /**  Description: Check if reason is applicable for cancel or decline service
    *  Author: Dan Crisologo
    *  Date Created: 01-21-14
    *  Input Parameters: reason
    *  Return: Boolean 
    */
    private Boolean invokeCancelCall(String reason) {
        Boolean reasonIsCancel = true;

        List<Webservice_Decline_Reasons__c> wdr = [Select Name from Webservice_Decline_Reasons__c where Reason_Name__c =: reason];
        //if a reason matches with a record in the custom settings, call the DECLINE webservice instead
        if(!wdr.isEmpty()) {
            reasonIsCancel = false;
        }
        
        return reasonIsCancel;
    }
    
}