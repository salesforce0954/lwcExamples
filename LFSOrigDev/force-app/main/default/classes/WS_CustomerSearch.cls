/**
 * @Description: Webservice Class for Customer Search and Match
 * @Author: Dan Crisologo
 * @Date Created: NOV-25-2013
 * @History:
   =====================================================================
       11-25-13: Created. - Dan
       12-10-13: Added WS_WebserviceCommons as parent
       11-12-14: Added country to be sent for DBHZL28 - Tony Xu
       10-20-15: Added new parameter for called IsNewAppForm in customerServiceAndMatch method - Adrian Recio
   =====================================================================
 */ 
public with sharing class WS_CustomerSearch extends WS_WebserviceCommons{

    public WS_CustomerSearch (Boolean mockEnable) {
        super(mockEnable);
    }

    /**  Description: Method that invokes the WS search and match
    *  Author: Dan Crisologo
    *  Date Created: 11-25-13
    *  Input Parameters: 
    *  Return: string   
     * Modified: Lavanya Kavuri 21-04-2015, Added First Name, Last Name, Drivers License. 
     * Modified: Adrian Recio 29-10-2015, Added a boolean parameter called "NewAppForm" to determine if search and match is from redesigned form or the old form 
    */
    public IS_WebserviceResponseDTO customerSearchAndMatch(Applicant_Search__c appSearch, String channel, Boolean IsNewAppForm){   
        system.debug('customer search and match: '+appSearch);
        IS_WebserviceResponseDTO wsrDTO;
        CustomerSearchGeComOriginations.CustomerSearchDataType customerSearch;
        CustomerSearchGeComOriginations.ServiceContext serviceContext;
        CustomerSearchGeComOriginations.CustomerSearchServiceSOAP csss;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;

        try {
            //***** MAIN PARAM1: Create service context *****
            serviceContext = createServiceContext(channel);
            
            //***** MAIN PARAM2: Create Customer Search Data *****
            customerSearch = new CustomerSearchGeComOriginations.CustomerSearchDataType();
            
            customerSearch.sfTransactionId = appSearch.Id;
            if(appSearch.Date_of_Birth__c!=null) {
                customerSearch.dateOfBirth = appSearch.Date_of_Birth__c;
            }
            customerSearch.postCode = appSearch.Post_Code__c;
            customerSearch.mobileNumber = appSearch.Mobile_Phone__c;
            customerSearch.previousPostCode = appSearch.Previous_Postcode__c;
            customerSearch.accountNumber = appSearch.Account_Number__c;
            customerSearch.firstName = appSearch.First_Name__c;
            customerSearch.lastName = appSearch.Last_Name__c;
            customerSearch.driversLicense = appSearch.Drivers_License__c;
            customerSearch.country = appSearch.Country__c;
           
            customerSearch.homePhone = appSearch.Home_Phone__c;
            customerSearch.workPhone = appSearch.Work_Phone__c;
            customerSearch.middleName = appSearch.Middle_Name__c;
            
            customerSearch.sendAcctDetailsToSFDC = string.valueOf(IsNewAppForm);
           
             //***** Invoke Customer Search Service *****
            csss = setUpCustomerSearchService();
            CustomerSearchGeComOriginations.SearchCustomerResponse_element wsResponse;
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                CustomerSearchGeComOriginations.CustomerSearchResponseDataType mockedCode = new CustomerSearchGeComOriginations.CustomerSearchResponseDataType();
                mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                mockedCode.messageDescription = '';
                CustomerSearchGeComOriginations.SearchCustomerResponse_element mockedResponse = new CustomerSearchGeComOriginations.SearchCustomerResponse_element();
                mockedResponse.customerSearchResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = csss.searchCustomer(serviceContext, customerSearch);
                callSuccessful = true;
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.customerSearchResponse.messageCode, wsResponse.customerSearchResponse.messageDescription);
                
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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_CUSTOMERSEARCH, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, null, csss.endpoint_x, csss.clientCertName_x, channel, csss.timeout_x, callTime);
            }
        }      
        
        return wsrDTO;
    }
    
    /**  Description: Invokes customer account search service
    *  Author: Dan Crisologo
    *  Date Created: 11-25-13
    *  Input Parameters: 
    *  Return: string     
    */
    public IS_WebserviceResponseDTO customerAccountSearch(Id applicantID, List<Applicant_CLV__c> applicantCLVs, String channel){   

        IS_WebserviceResponseDTO wsrDTO;
        CustomerSearchGeComOriginations.customerAccountSearchDataType customerAccountSearch;
        CustomerSearchGeComOriginations.ServiceContext serviceContext;
        CustomerSearchGeComOriginations.CustomerSearchServiceSOAP csss;
        boolean callAttempted = false;
        boolean callSuccessful = false;
        Long callTime = -1;
        
        try {
            //***** MAIN PARAM1: Create service context *****
            serviceContext = createServiceContext(channel);
            
            //***** MAIN PARAM2: Create Customer Search Data *****
            customerAccountSearch = new CustomerSearchGeComOriginations.CustomerAccountSearchDataType();
            customerAccountSearch.sfTransactionId = applicantID;
            List<CustomerSearchGeComOriginations.CustomerContact> customerContactsList = new List<CustomerSearchGeComOriginations.CustomerContact>();
            for(Applicant_CLV__c appCLV: applicantCLVs) {
                CustomerSearchGeComOriginations.CustomerContact customerContact = new CustomerSearchGeComOriginations.CustomerContact();
                customerContact.sfApplicantCLVId = appCLV.Id;
                customerContact.contactId = appCLV.GE_Contact_ID__c;
                customerContact.country = country;  //12-03-2014 New field to be sent added by Tony xu
                customerContactsList.add(customerContact);
            }
            customerAccountSearch.contact = customerContactsList;

             //***** Invoke Customer Search Service *****
            csss = setUpCustomerSearchService();
           
            CustomerSearchGeComOriginations.searchCustomerAccountResponse_element wsResponse;
            if(Test.isRunningTest()) {
                //Generate a mocked-response since we cannot simulate the actual webservice call
                CustomerSearchGeComOriginations.customerAccountSearchResponseDataType mockedCode = new CustomerSearchGeComOriginations.customerAccountSearchResponseDataType();
                mockedCode.messageCode = GEN_OriginationsConstants.MESSAGE_CODE_SUCCESS;
                mockedCode.messageDescription = '';
                CustomerSearchGeComOriginations.searchCustomerAccountResponse_element mockedResponse = new CustomerSearchGeComOriginations.searchCustomerAccountResponse_element();
                mockedResponse.customerAccountSearchResponse = mockedCode;
                wsResponse = mockedResponse;
            } else {
                callAttempted = true;
                callTime = System.currentTimeMillis();
                wsResponse = csss.searchCustomerAccount(serviceContext, customerAccountSearch);
                callSuccessful = true;
            }
            
            wsrDTO = new IS_WebserviceResponseDTO(wsResponse.customerAccountSearchResponse.messageCode, wsResponse.customerAccountSearchResponse.messageDescription);
            
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
               insertWebServiceLog(GEN_OriginationsConstants.SERVICENAME_ACCOUNTSEARCH, callSuccessful, wsrDTO.messageCode, wsrDTO.messageDescription, null, csss.endpoint_x, csss.clientCertName_x, channel, csss.timeout_x, callTime);
            }
        }  
        
        return wsrDTO;
    }
     
    private CustomerSearchGeComOriginations.CustomerSearchServiceSOAP setUpCustomerSearchService() {
        CustomerSearchGeComOriginations.CustomerSearchServiceSOAP csss = new CustomerSearchGeComOriginations.CustomerSearchServiceSOAP();
        csss.endpoint_x = getCustomerSearchEndpoint();
        csss.clientCertName_x = getCertificateName();
        csss.timeout_x = Integer.valueOf(getSearchAndMatchTimeout());
        return csss;
    }
    
    
    /**  Description: Creates service context for customer search webservice
    *  Author: Dan Crisologo
    *  Date Created: 12-12-13
    *  Input Parameters: 
    *  Return: String     
    */
    private CustomerSearchGeComOriginations.ServiceContext createServiceContext(String channel) {
        CustomerSearchGeComOriginations.ServiceContext serviceContext;
        //create business context
        CustomerSearchGeComOriginations.BusinessContext businessContext = new CustomerSearchGeComOriginations.BusinessContext();
        businessContext.mainBusinessUnit = getMainBusinessUnit();
        businessContext.subBusinessUnit = getSubBusinessUnit();
    
        //create consumer context
        CustomerSearchGeComOriginations.ConsumerContext consumer = new CustomerSearchGeComOriginations.ConsumerContext();
        consumer.requestedBy = getRequestedBy();
        consumer.requestedName = channel; 
        consumer.serviceVersion = getServiceVersion();
        consumer.targetService = getTargetServiceCustomerSearch();
        consumer.businessUnit = businessContext;
        serviceContext = new CustomerSearchGeComOriginations.ServiceContext();
        serviceContext.consumer = consumer;
        
        return serviceContext;

    }

}