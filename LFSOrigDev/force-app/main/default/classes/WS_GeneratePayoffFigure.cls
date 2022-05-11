/**
 * @Description: Webservice Class for Generate Payoff Figure Service DBHZL386
 * @Author: Tony Xu 
 * @Date Created: 2015-03-02
 * @History:
   =====================================================================
       2015-03-02: Created. - Tony Xu
   =====================================================================
 */ 

public with sharing class WS_GeneratePayoffFigure extends WS_WebserviceCommons {
    
    public WS_GeneratePayoffFigure(Boolean mockEnable) {
        super(mockEnable);
    }
    
    /**  Description: Calls a webservice that invokes generate payoff figure service
    *  Author: Tony Xu
    *  Date Created: 2015-03-02
    *  Input Parameters: 
    *  Return: string - Webservice response   
    */
    public IS_WebserviceResponseDTO generatePayoffFigureRequest(IS_ApplicationDTO appDTO, String bankAccountNumber, String channel){
    
        IS_WebserviceResponseDTO wsrDTO;
        PayoffQuoteAnzCapitalGeCom.PayOffQuoteServiceSOAP cacgco;
        PayoffQuoteAnzCapitalGeCom.ServiceContext serviceContextParam;
        PayoffQuoteAnzCapitalGeCom.RetrievePayOffQuoteReqDataType retrievePayoffQuoteDataType;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;
        try{              
            //***** Set-up Service Context *****
            //Build business and customer context
            PayoffQuoteAnzCapitalGeCom.BusinessContext businessContext = WS_WebServiceHelper.generatePayoffQuoteBusinessContext(getMainBusinessUnit(), getSubBusinessUnit());
            PayoffQuoteAnzCapitalGeCom.ConsumerContext consumerContext = WS_WebServiceHelper.generatePayoffQuoteConsumerContext(getRequestedBy(), channel, getServiceVersion(), getTargetServiceAppSubmit(), businessContext);
            
            //build exception collection (when to populate this?)
            PayoffQuoteAnzCapitalGeCom.Exception_x[] exceptionXList = new PayoffQuoteAnzCapitalGeCom.Exception_x[]{WS_WebServiceHelper.generatePayoffQuoteExceptionX(null, null, null, null, null, null)}; //still need to populate?            
            PayoffQuoteAnzCapitalGeCom.ExceptionCollection exceptionCollection = WS_WebServiceHelper.generatePayoffQuoteExceptionCollection(exceptionXList);            
            
            //build service context
            serviceContextParam = createPayoffQuoteServiceContext(channel); 
            System.debug('serviceContextParam ' + serviceContextParam );
            //***** Set-up AML Data type *****
            retrievePayoffQuoteDataType = new PayoffQuoteAnzCapitalGeCom.RetrievePayOffQuoteReqDataType ();
            retrievePayoffQuoteDataType.sfUpdateId = appDTO.app.id;
            retrievePayoffQuoteDataType.BranchNum = appDTO.branch.Branch_ID__c;
            retrievePayoffQuoteDataType.ICBSAcctNum = bankAccountNumber;
            retrievePayoffQuoteDataType.AsAtDt = Date.today();
            
             //***** Invoke Verify AML Service *****
            cacgco = setupGeneratePayoffFigureServiceSOAP();
            //system.debug('cacgco' + cacgco ); 
            system.debug('*******TXU DEBUG*******'+cacgco);
            
            PayoffQuoteAnzCapitalGeCom.retrievePayOffQuoteResponse_element wsResponse;
            
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                PayoffQuoteAnzCapitalGeCom.RetrievePayOffQuoteResDataType mockedCode = new PayoffQuoteAnzCapitalGeCom.RetrievePayOffQuoteResDataType();
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SUCCESS2;
                System.debug('messageCode' +mockedCode.messageCode);
                mockedCode.messageDescription = '';
                PayoffQuoteAnzCapitalGeCom.retrievePayOffQuoteResponse_element mockedResponse = new PayoffQuoteAnzCapitalGeCom.retrievePayOffQuoteResponse_element();
                mockedResponse.payOffQuoteData = mockedCode;
                System.debug('mockedResponse' +mockedResponse.payOffQuoteData);
                wsResponse = mockedResponse;
                
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = cacgco.RetrievePayOffQuote(serviceContextParam, retrievePayoffQuoteDataType);
                callSuccessful = true;
           }
             
            String messageDescription = wsResponse.payOffQuoteData.messageDescription;
            
            if(wsResponse.payOffQuoteData.messageCode==GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR && wsResponse.serviceContext!=null) {
                messageDescription = messageDescription + IS_WebserviceCommonUtil.getGeneratePayoffFigureExceptionDetail(wsResponse.serviceContext);
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.payOffQuoteData.messageCode, messageDescription);

        } catch(CalloutException ce){ 
            System.debug('Callout Exception Occured: ' + ce.getMessage() + '- -' + ce.getStackTraceString());
            if(ce.getMessage().indexOf('Read timed out')!=-1) { //timeout exception - not able to receive a response within a specified time
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_SFTIMEOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
                //System.debug('The wsrDTO1 is: ' + wsrDTO );
            } else { //other callout exception. Parse exception, invalid endpoint, etc
                wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_CALLOUTEXCEPTION, 
                                                      ce.getMessage() + ':' + ce.getStackTraceString());
                System.debug('The wsrDTO2 is: ' + wsrDTO );
            }
        } catch(Exception e){ 
            System.debug('General Exception Occured: ' + e.getMessage() + '- -' + e.getStackTraceString());
            wsrDTO = new IS_WebserviceResponseDTO(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION, 
                                                  e.getMessage() + ':' + e.getStackTraceString());
        }  finally {
            if(callAttempted) {
               callTime = System.currentTimeMillis() - callTime;
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_GENERATEPAYOFFFIGURE, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, appDTO.app.id, cacgco.endpoint_x, cacgco.clientCertName_x, channel, cacgco.timeout_x, callTime);
            }
        }     
             
        return wsrDTO;
        
    }
    
    
    
}