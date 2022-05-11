/**
 * @Description: Class that handles the Generation of Appliation Extract document using the GenerateDocument service
 * @Author: Dan Crisologo
 * @Date Created: MAR-17-2014
 * @History:
   =====================================================================
       03-17-13: Created.
       12-01-14: Modified code for DBHZL-64 - Tony Xu
   =====================================================================
 */ 
global class IS_GenerateApplicationExtract implements IS_RetryInterface{

    /**  Description: Interface method for retry functionality
     *  Author: Dan Crisologo
     *  Date Created: 03-11-13
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> invokeRetryRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        //Do all necessary pre-retry operations here
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        validationErrors = generateApplicationExtractRequest(applicationID, mockEnable, requestedName, exceptionLogId);
        return validationErrors;
    }

    /**  Description: Calls the Generate Documents Request service to generate an application extract document 
     *  Author: Dan Crisologo
     *  Date Created: 03-17-14
     *  Input Parameters: applicationID - application record id to retry
                          mockEnable - use mock service if user attempting to retry has mockenabled = true
                          requestedName - original ui source
                          exceptionLogId - the exception log record to retry
     *  Return: List<IS_ValidationError>
     *  Update: 12-01-14	Determines application extract template name based on Application Brand Country for DBHZL64  -  Tony Xu
     */
    public static List<IS_ValidationError> generateApplicationExtractRequest(ID applicationID, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        System.debug('*****generateApplicationExtractRequest***');
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        SavePoint sp;
        try {
            //populate Application
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            
            /** Tony Xu Added for DBHZL64  Start **/ 
            String applicationExtractTemplateName = '';
            system.debug('appDTO.app.Brand_Country__c:'+appDTO.app.Brand_Country__c);
            if(appDTO.app.Brand_Country__c == 'AU'){
            	applicationExtractTemplateName = GEN_OriginationsConstants.DOCUMENT_TEMPLATENAME_APPEXTRACT;
            }else{
            	if(appDTO.app.Brand_Country__c == 'NZ'){
            		applicationExtractTemplateName = GEN_OriginationsConstants.DOCUMENT_TEMPLATENAME_APPEXTRACT_NZ;
            	}
            }             
            /** End **/  
            
            if(appDTO.app!=null) {
                if(exceptionLogId!=null) { //load these data only if it is for retry. Note that we don't need to pre-load this data since this service is also called after app submit validations
                    appDTO = loadOtherExtractData(appDTO);

                    //query acceptance document
                    appDTO.acceptanceDocuments = [SELECT  Id, 
                                                          application__r.UID__c,
                                                          Title__c,
                                                          Document_Category__c,
                                                          Type__c,
                                                          Template_Name__c
                                                  FROM    Related_Document__c
                                                  WHERE   Application__c =: applicationID 
                                                   AND    Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL
                                                   AND    Type__c =: GEN_OriginationsConstants.DOCUMENT_TYPE_COPY_OF_APPLICATION
                                                   AND    Template_Name__c =: applicationExtractTemplateName];	//Modified for DBHZL64  Tony Xu
                }

                //perform validations here
                IS_IValidator validator = new IS_GenerateApplicationExtractValidator(); 
                validationErrors = validator.validate(appDTO); 
                if(validationErrors.size()>0) {
                    //failed validation..... return error to caller
                    return validationErrors;   
                }
                
                if(exceptionLogId==null) { //do not delete/create related documents during retry.
                
                    //Check if application extract document already exists
                    List<Related_Document__c> rdList = new List<Related_Document__c>();
    
                    for(Related_Document__c rd: [SELECT  id
                                                 FROM    Related_Document__c 
                                                 WHERE   Application__c =: applicationID 
                                                  AND    Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL
                                                  AND    Type__c =: GEN_OriginationsConstants.DOCUMENT_TYPE_COPY_OF_APPLICATION
                                                  AND    Template_Name__c =: applicationExtractTemplateName]) {	//Modieifed for DBHZL64 Tony Xu
                        rdList.add(rd);
                    }
                    
                    //set a savepoint first
                    sp = Database.setSavepoint();
                    
                    //delete all existing related documents that matches the given criteria
                    if(!rdList.isEmpty()) {
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Related_Document__c.sObjectType.getDescribe().isDeletable()){
                          delete rdList;
                        }
                        */
                        delete rdList;
                    }
                    
                    //create a new related document for app extract, this will be queried later in the future handler
                    Related_Document__c newRD = new Related_Document__c(Application__c = applicationID,
                                                                        Document_Category__c = GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL,
                                                                        Type__c = GEN_OriginationsConstants.DOCUMENT_TYPE_COPY_OF_APPLICATION,
                                                                        Title__c = GEN_OriginationsConstants.DOCUMENT_TYPE_COPY_OF_APPLICATION,
                                                                        Template_Name__c = applicationExtractTemplateName,		//Modified for DBHZL64 Tony Xu
                                                                        Status__c = GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_SENT,
                                                                        Section__c = GEN_OriginationsConstants.DOCUMENT_SECTION_APPEXTRACT,
                                                                        GE_Link_Type__c = GEN_OriginationsConstants.DOCUMENT_LINK_TYPE_GENERATED);
                    insert newRD;
                    
                }
                
                if(exceptionLogId==null) { //if exceptionLogId is null, this means it is not a retry call and therefore can use a future call
                    generateApplicationExtractRequest(applicationID, mockEnable, requestedName);
                } else { //do the synch call if exceptionLogId is present
                    processWSGenerateApplicationExtract(appDTO, mockEnable, requestedName, exceptionLogId);
                }
                
            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPID_NOT_FOUND + applicationId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT, errorMesg));
            }

        } catch(Exception e) {
            if(sp!=null) {
                Database.rollback(sp);
            }
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_APPEXTRACT,
                                                                      'generateApplicationExtractRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
    
    /**  Description: Future call for Generating Application Extract
     *  Author: Dan Crisologo
     *  Date Created: 03-17-14
     *  Input Parameters: applicationID
                        : mockEnable 
                        : requestedName
     *  Return: void
     */
    @future (callout = true)
    public static void generateApplicationExtractRequest(ID applicationID, Boolean mockEnable, String requestedName) {
        
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();

        try{ 

            //populate Application
            appDTO = IS_WebserviceCommonUtil.initializeApplicationData(applicationID);
            
            appDTO = loadOtherExtractData(appDTO);
            
            /** Tony Xu Added for DBHZL64  Start **/
            String applicationExtractTemplateName = '';
            
            if(appDTO.app.Brand_Country__c == 'AU'){
            	applicationExtractTemplateName = GEN_OriginationsConstants.DOCUMENT_TEMPLATENAME_APPEXTRACT;
            }else{
            	if(appDTO.app.Brand_Country__c == 'NZ'){
            		applicationExtractTemplateName = GEN_OriginationsConstants.DOCUMENT_TEMPLATENAME_APPEXTRACT_NZ;
            	}
            }             
            /** End **/ 
            
            //query acceptance document
            appDTO.acceptanceDocuments = [SELECT  Id, 
                                                  application__r.UID__c,
                                                  Title__c,
                                                  Document_Category__c,
                                                  Type__c,
                                                  Template_Name__c
                                          FROM    Related_Document__c
                                          WHERE   Application__c =: applicationID 
                                           AND    Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL
                                           AND    Type__c =: GEN_OriginationsConstants.DOCUMENT_TYPE_COPY_OF_APPLICATION
                                           AND    Template_Name__c =: applicationExtractTemplateName];

            processWSGenerateApplicationExtract(appDTO, mockEnable, requestedName, null);
            
         } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_APPEXTRACT,
                                                                      'generateApplicationExtractRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT);
        }
    }
    
    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
    private static void processWSGenerateApplicationExtract(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_GenerateApplicationExtract wsGenerateApplicationExtract = new WS_GenerateApplicationExtract(mockEnable); 
            IS_WebserviceResponseDTO wsResponse = wsGenerateApplicationExtract.generateApplicationExtractRequest(appDTO, requestedName);

            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_APPEXTRACT,
                                                                        'generateApplicationExtractRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId,
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_GENERATEAPPEXTRACT);
        } catch (Exception e) {
            throw e;
        }
    }
    
    /*  Description: Query other application-related recordss
     *  Author: Dan Crisologo
     *  Date Created: MAR-18-2014
     *  Input: IS_ApplicationDTO appDTO
     *  Return: IS_ApplicationDTO
     */
    public static IS_ApplicationDTO loadOtherExtractData(IS_ApplicationDTO appDTO) {
        try {
        
            appDTO.product = [SELECT  Product_Name__c 
                              FROM    GEProduct__c 
                              WHERE   id =: appDTO.app.Product_Id__c]; 
        
            appDTO.loanPurList = GEN_RecordRetrievalUtility.retrieveLoanPurposeList(appDTO.app.Id); 
        
            appDTO.incList = GEN_RecordRetrievalUtility.retrieveIncomeSortedByAmount(appDTO.applicant.Id);
            appDTO.assetList = GEN_RecordRetrievalUtility.retrieveAssetList(appDTO.applicant.Id);
            appDTO.debtList = GEN_RecordRetrievalUtility.retrieveDebtList(appDTO.applicant.Id); 
            appDTO.expenseList = GEN_RecordRetrievalUtility.retrieveExpenseList(appDTO.applicant.Id);
            
            //query additional budget details for joint application
            if(appDTO.app.application_type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
                appDTO.incList2 = GEN_RecordRetrievalUtility.retrieveIncomeList(appDTO.applicant2.Id);
                appDTO.assetList2 = GEN_RecordRetrievalUtility.retrieveAssetList(appDTO.applicant2.Id);
                appDTO.debtList2 = GEN_RecordRetrievalUtility.retrieveDebtList(appDTO.applicant2.Id); 
                appDTO.expenseList2 = GEN_RecordRetrievalUtility.retrieveExpenseList(appDTO.applicant2.Id);
            }
            
            appDTO.personalReferenceList = [SELECT Personal_Ref_Address__c,
            									   Town_City__c,
            									   Suburb__c,
            									   Street_Type__c,
            									   Street_Number__c,
            									   Street_Name__c,
            									   State__c,
            									   Property_Name__c,
            									   Postcode__c,
            									   Country__c,
                                                   Name__c,
                                                   Phone_Number__c,
                                                   Relationship__c,
                                                   unit_number__c
                                            FROM   Personal_Reference_Check__c
                                            WHERE  Application__c =: appDTO.app.Id]; 
            
            //load insurance list
            appDTO.insuranceList = [SELECT Policy_Type__c, 
                                           Ins_Term__c, 
                                           Product_Version__r.GEProduct__r.Insurance_Type_Num__c, 
                                           Fixed_Premium_Amount__c,
                                           Cover_Amount_Formula__c,
                                           Insurance_GST__c,
                                           Insurance_Stamp_Duty__c,
                                           Policy_Num__c
                                    FROM   Product_Item__c
                                    WHERE  Product_Version__r.GEProduct__r.Insurance_Type_Num__c != 0
                                     AND   Product_Version__r.Start_Date__c <=: Date.valueOf(appDTO.app.LastModifiedDate)
                                     AND   Product_Version__r.End_Date__c >=: Date.valueOf(appDTO.app.LastModifiedDate)
                                     AND   Application__c =: appDTO.app.Id];
        
            //Query broker details
            if(appDTO.app.Broker__c!=null) {
                appDTO.brokerDetails = [SELECT Broker_ID__c,
                                         firstName,
                                         lastName,
                                         account.Name,
                                         account.Trust_Entity_Name__c,
                                         account.Aggregator_Account_Name__c,
                                         MailingCity,
                                         MailingState,
                                         MailingPostalCode,
                                         Phone,
                                         MobilePhone,
                                         Contact_Accreditation_Status__c
                                   FROM  Contact
                                   WHERE Id =: appDTO.app.Broker__c];
            }
            
            return appDTO;
        } catch (Exception e) {
            throw e;
        }
    }
}