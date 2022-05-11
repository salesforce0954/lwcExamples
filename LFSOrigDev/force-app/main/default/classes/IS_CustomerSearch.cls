/**
 * @Description: Integration Service class for Search and Match webservice
 * @Author: Dan Crisologo
 * @Date Created: NOVEMBER-25-2013
 * @History:
   =====================================================================
       11-25-13: Created. - Dan       
   =====================================================================
 */ 
global class IS_CustomerSearch{
     
     /**  Description: Calls the Application Search webservice
     *  Author: Dan Crisologo
     *  Date Created: 01-14-14
     *  Input Parameters: Id applicantSearch
                          Boolean mockEnable
                          String channelName
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> customerSearchService(Id applicantSearch, Boolean mockEnable, String channelName, Boolean IsNewAppForm) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            
            appDTO.appSearch = getAppSearch(applicantSearch);
            IS_IValidator validator = new IS_CustomerSearchValidator(); 
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
                //failed validation..... return error to caller
                return validationErrors;   
            }
            
            //make the asynchrous web service call 
            customerSearchServiceFuture(applicantSearch, mockEnable, channelName, IsNewAppForm);

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString() + ' Applicant__Search__c.id=['+applicantSearch+']',
                                                                        GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                        'customerSearchService',
                                                                        applicantSearch,
                                                                        channelName,
                                                                        null,
                                                                        null,
                                                                        null,
                                                                        GEN_OriginationsConstants.SERVICENAME_CUSTOMERSEARCH);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_CUSTOMERSEARCH, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
     
    /**  Description: Method that calls the customer search webservice and pass the required parameters.
    *  Author: Dan Crisologo
    *  Date Created: 11-25-13
    *  Input Parameters: applicantSearch - Id of the applicant search record
                         mockEnable - uses mock service if true
                         channelName - channel name
    *  Return: void
    */
    // Removed By: Adrian Recio
    // Description: Removed future annotation to make call sync
    // Date: 10/9/2015
    //@future(callout=true)
    private static void customerSearchServiceFuture(Id applicantSearch, Boolean mockEnable, String channelName, Boolean IsNewAppForm) {
    
        try{ 
        
            WS_CustomerSearch wsCustomerSearch = new WS_CustomerSearch(mockEnable); 
            IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
            
            appDTO.appSearch = getAppSearch(applicantSearch);
            
            
   
            IS_WebserviceResponseDTO wsResponse = wsCustomerSearch.customerSearchAndMatch(appDTO.appSearch, channelName, IsNewAppForm); 
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                                    wsResponse.messageDescription,
                                                                                    GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                                    'customerSearchService',
                                                                                    applicantSearch,
                                                                                    channelName,
                                                                                    null, //exception log id is null. No auto retry
                                                                                    null, //application record and field is null. No update to application
                                                                                    null,
                                                                                    GEN_OriginationsConstants.SERVICENAME_CUSTOMERSEARCH); 

            
        } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString() + ' Applicant__Search__c.id=['+applicantSearch+']',
                                                                        GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                        'customerSearchService',
                                                                        applicantSearch,
                                                                        channelName,
                                                                        null,
                                                                        null,
                                                                        null,
                                                                        GEN_OriginationsConstants.SERVICENAME_CUSTOMERSEARCH);
        }
        
    }
    
    /**  Description: Calls the Application Account Search webservice
     *  Author: Dan Crisologo
     *  Date Created: 01-14-14
     *  Input Parameters: Set<Id> applicantCLVIds
                          Boolean mockEnable
                          String channelName
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> customerAccountSearchService(Set<Id> applicantCLVIds, Boolean mockEnable, String channelName) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            
            appDTO.applicantCLVs = getAppCLV(applicantCLVIds);
            
            IS_IValidator validator = new IS_CustomerAccountSearchValidator(); 
            validationErrors = validator.validate(appDTO); 
            if(validationErrors.size()>0) {
                //failed validation..... return error to caller
                return validationErrors;   
            }
            
            //make the asynchrous web service call 
            customerAccountSearchServiceFuture(applicantCLVIds, mockEnable, channelName);

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                        'customerAccountSearchService',
                                                                        null,
                                                                        channelName,
                                                                        null,
                                                                        null,
                                                                        null,
                                                                        GEN_OriginationsConstants.SERVICENAME_ACCOUNTSEARCH);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_ACCOUNTSEARCH, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
    
    /**  Description: Invoke customer account search service
    *  Author: Dan Crisologo
    *  Date Created: 12-13-13
    *  Input Parameters: applicantCLVIds - set of Ids of applicant CLV records
                         mockEnable - uses mock service if true
                         channelName - channel name
    *  Return: void
    */
    // Removed By: Adrian Recio
    // Description: Removed future annotation to make call sync. Fix needed for account search/select sync.
    // Date: 10/9/2015
    //@future(callout=true)
    public static void customerAccountSearchServiceFuture(Set<Id> applicantCLVIds, Boolean mockEnable, String channelName) {
       
        try{ 
        
            WS_CustomerSearch wscs = new WS_CustomerSearch(mockEnable);

            IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
            appDTO.applicantCLVs = getAppCLV(applicantCLVIds);
            
            Id applicantId;
            //transaction ID is not necessary, we will just pass the first applicant ID that we can get from the CLVs we have.
            for(Applicant_CLV__c appCLV: appDTO.applicantCLVs) {
                applicantId = appCLV.applicant__c;
                break;
            }

            IS_WebserviceResponseDTO wsResponse = wscs.customerAccountSearch(applicantId, appDTO.applicantCLVs, channelName);
            system.debug('response webservice: '+wsResponse);

            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                        'customerAccountSearchService',
                                                                        applicantId,
                                                                        channelName,
                                                                        null, //exception log id is null. No auto retry
                                                                        null, //application record and field is null. No update to application
                                                                        null,
                                                                        GEN_OriginationsConstants.SERVICENAME_ACCOUNTSEARCH); 

        } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                        e.getMessage() + ':' + e.getStackTraceString(),
                                                                        GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH,
                                                                        'customerAccountSearchService',
                                                                        null,
                                                                        channelName,
                                                                        null,
                                                                        null,
                                                                        null,
                                                                        GEN_OriginationsConstants.SERVICENAME_ACCOUNTSEARCH);
        }
        
    }
    
    /**  Description: Query applicant search record
     *  Author: Dan Crisologo
     *  Date Created: 01-14-14
     *  Input Parameters: Id applicantSearch
     *  Return: Applicant_Search__c
     * Modified Lavanya Kavuri, 23-04-2015, AML - 600, Added First Name, Last Name, Drivers License.
     */
    private static Applicant_Search__c getAppSearch(Id applicantSearch) {
        return [SELECT   Id, 
                         Date_of_Birth__c, 
                         Post_Code__c, 
                         Mobile_Phone__c, 
                         Previous_Postcode__c, 
                         First_Name__c,
                         Last_Name__c,
                         Drivers_License__c,
                         Account_Number__c,
                         Country__c,         //DBHZL28
                         Home_Phone__c, 
                         Work_Phone__c, 
                         Middle_Name__c
                 FROM    Applicant_Search__c
                 WHERE   Id =: applicantSearch];
    }
    
    /**  Description: Query applicant search record
     *  Author: Dan Crisologo
     *  Date Created: 01-14-14
     *  Input Parameters: Set<Id> applicantCLVIds
     *  Return: List<Applicant_CLV__c>
     */
    private static List<Applicant_CLV__c> getAppCLV(Set<Id> applicantCLVIds) {
        return [SELECT  Id,
                        applicant__c,
                        GE_Contact_ID__c
                FROM    Applicant_CLV__c
                WHERE   Id IN: applicantCLVIds];
    }
    
}