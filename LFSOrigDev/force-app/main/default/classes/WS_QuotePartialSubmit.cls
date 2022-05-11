/**
 * @Description: Class that pass the quote data in the web service
 * @Author: Manoj kumar
 * @Date Created: Sep-08-2020
 * @History:
   =====================================================================
   
 */ 
public with sharing class WS_QuotePartialSubmit extends WS_WebserviceCommons{

    public WS_QuotePartialSubmit(Boolean mockEnable) {
        super(mockEnable); 
    }

    /** Description: Method that populates the Quote data for webservice submit
    *  Author: Manoj kumar
    *  Date Created: Sep-04-2020
    *  Return: IS_WebserviceResponseDTO      
    */
    public IS_WebserviceResponseDTO quotePartialUpdateRequest(Quote__c quote, String requestedName){       
                                        
        IS_WebserviceResponseDTO wsrDTO;
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        ConsumerAnzCapitalGeComOriginations.applicationPartialCustomerDataType applicationPartialCustomerDataType;
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP cacgco;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;
        
        try {  
            //***** Create request data *****
            ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext(getMainBusinessUnit(), getSubBusinessUnit());
            ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext(getRequestedBy(), quote.Channel__c, getServiceVersion(), getTargetServiceAppSubmit(), businessContext);
            
            //build exception collection (when to populate this?)
            ConsumerAnzCapitalGeComOriginations.Exception_x[] exceptionXList = new ConsumerAnzCapitalGeComOriginations.Exception_x[]{WS_WebServiceHelper.generateExceptionX(null, null, null, null, null, null)}; //still need to populate?
            ConsumerAnzCapitalGeComOriginations.ExceptionCollection exceptionCollection = WS_WebServiceHelper.generateExceptionCollection(exceptionXList);
            
            //build service context
            serviceContextParam = WS_WebServiceHelper.generateServiceContext(consumerContext, exceptionCollection);
            applicationPartialCustomerDataType = new ConsumerAnzCapitalGeComOriginations.applicationPartialCustomerDataType();
            //GenericApplicationPartialData quoteData = setupQuoteData(quote);    
            applicationPartialCustomerDataType.sfApplicationId = quote.id;
            applicationPartialCustomerDataType.applicationId = quote.UID__c; 
            applicationPartialCustomerDataType.initialInterestRate = quote.Quote_Rate__c;                
            //***** Create additional app submit data *****
                
            //***** Invoke Submit quote Service *****
             
            System.debug('***** Sending quote submit *****');  
            System.debug('$$$ serviceContextParam : '+serviceContextParam);
            System.debug('$$$ applicationPartialCustomerDataType: '+applicationPartialCustomerDataType);
            cacgco = setupApplicationServiceSOAP();
            ConsumerAnzCapitalGeComOriginations.updatePartialApplicationResponse_element wsResponse;
            if(TestDataBuilder.IsTestFlag) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                ConsumerAnzCapitalGeComOriginations.ApplicationResponseType mockedCode = new ConsumerAnzCapitalGeComOriginations.ApplicationResponseType();
                ConsumerAnzCapitalGeComOriginations.updatePartialApplicationResponse_element mockedResponse = new ConsumerAnzCapitalGeComOriginations.updatePartialApplicationResponse_element();
                consumerAnzCapitalGeComOriginations.ServiceContext mockedSecurity= new consumerAnzCapitalGeComOriginations.ServiceContext();
                consumerAnzCapitalGeComOriginations.Exception_x excp = new consumerAnzCapitalGeComOriginations.Exception_x();
                consumerAnzCapitalGeComOriginations.ExceptionCollection excepColl = new consumerAnzCapitalGeComOriginations.ExceptionCollection();
                List<consumerAnzCapitalGeComOriginations.Exception_x> excList = new List<consumerAnzCapitalGeComOriginations.Exception_x>();
                                
                excp.code ='test';
                excp.severity ='test';
                excp.occurredTime =System.today();
                excp.message ='Callout Test';
                excp.detailedMessage ='Callout Test';
                excp.sourceSystem ='Callout Test';
                excList.add(excp);
                excepColl.exception_x =excList;
                
                mockedCode.messageCode = GEN_OriginationsConstants.WSCODE_SYSTEM_ERROR;
                mockedCode.messageDescription = '';
                mockedSecurity.exceptions=excepColl;
                 mockedResponse.applicationResponse = mockedCode;
                 mockedResponse.serviceContext = mockedSecurity;
                mockedResponse.applicationResponse = mockedCode;
                //mockedResponse.serviceContext = mockedSecurity;
                   wsResponse = mockedResponse;
                //wsResponse.serviceContext.exceptions.exception_x =excList;
            } else {
                system.debug('....quoteData.applicationPartialCustomerData....'+applicationPartialCustomerDataType);
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = cacgco.updatePartialApplication(serviceContextParam, 
                                                      applicationPartialCustomerDataType);
                callSuccessful = true;
                System.debug('Quote response: '+wsResponse);
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
               insertQuoteWebServiceLog(GEN_OriginationsConstants.SERVICENAME_INTEREST_RATE_UPDATE, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, quote.id, cacgco.endpoint_x, cacgco.clientCertName_x, quote.channel__c, cacgco.timeout_x, callTime);
            }
        }     
             
        return wsrDTO;
    
    }

}