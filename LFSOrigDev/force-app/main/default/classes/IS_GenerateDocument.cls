/**
 * @Description: Class that handles the Accept Offer webservice
 * @Author: Dan Crisologo
 * @Date Created: DEC-17-2013
 * @History:
   =====================================================================
       12-17-13: Created.
       01-21-14: This is now the IS for generate document service
       08-AUG-2015 FORCE APPLICATION UPDATE PRIOR TO DOC GEN - MLASALA
   =====================================================================
 */ //implements IS_RetryInterface
global class IS_GenerateDocument implements IS_RetryInterface {

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
        //fourth parameter relatedDocuId will not be populated. retry everything.
        validationErrors = generateDocumentRequest(applicationID, mockEnable, requestedName, null, exceptionLogId);
        return validationErrors;
    }

    /**  Description: Calls the Generate Documents Request webservice
     *  Author: Dan Crisologo
     *  Date Created: 11-11-13
     *  Input Parameters: Id - Application Id
     *  Return: List<IS_ValidationError>
     */
    public static List<IS_ValidationError> generateDocumentRequest(ID applicationID, Boolean mockEnable, String requestedName, String relatedDocuId, Id exceptionLogId) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try {
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId);   
            
            for(sObject applicants: GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId)) {
                Applicant__c applicantResult = (Applicant__c) applicants;
                if(applicantResult.Is_Primary_Applicant__c) {
                    appDTO.applicant = applicantResult; //assign to applicant1 if primary applicant
                } else {
                    appDTO.applicant2 = applicantResult; //assign to applicant2 if secondary applicant
                }
            }
            appDTO.applicationDebits = queryApplicationDebits(appDTO.app.Id);
            appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);// queryDisbursement(appDTO.app.Id);
            appDTO.disbursementPlanList  = queryDisbursementPlans(appDTO.app.Id);
            appDTO.product = queryProduct(appDTO.app.Product_Id__c);
            appDTO.collateralList = queryCollaterals(appDTO.app.Id);
            appDTO.complianceCheckList = queryComplianceCheck(appDTO.app.Id);
            appDTO.personalReferenceList = queryPersonalReferenceCheck(appDTO.app.Id);
            appDTO.applicationAllDebits = queryApplicationAllDebits(appDTO.app.Id);
            
            if(appDTO.app.Branch__c != null){
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
            
            if(appDTO.app!=null) {
                
                if(exceptionLogId==null) { //if exception log id is null, then this means that we will run the process as ASYNC and will be able to use DML before callout
                    appDTO = runAsyncRelatedDocumentProcess(appDTO, relatedDocuId);
                } else {
                    appDTO = setUpDocGenRecords(appDTO, relatedDocuId); //if exception Log id is not empty, set up the doc gen record for SYNC proccess
                }
                
                //BEGIN MLASALA: 08-SEPT-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN
                IS_IValidator validator = new IS_GenerateDocumentValidator ();

                //perform validations here
                validationErrors = validator.validate(appDTO); 
                if(validationErrors.size()>0) {
                    System.debug('validationErrors---->'+validationErrors);
                    //failed validation..... return error to caller
                    return validationErrors;   
                } else {
                    
                    //Validate if update was done prior to doc gen
                    if(!appDTO.app.Doc_Gen_Check__c || 
                       !appDTO.app.Update_Doc_Gen_Check__c){

                        //Return error message to force update
                        validationErrors.add(new IS_ValidationError('IS_GenerateDocument.generateDocumentRequest','Application not in sync, please update before generating documents.'));

                        //Set doc gen check flag to true
                        appDTO.app.Doc_Gen_Check__c = true;
                        appDTO.app.Out_Of_Sync__c = true;
                        
                        //MLASALA 11-JUL-16 - TQLQW-72 Lock-down Offer (Hide them from Customer UI)
                        //Force lock down offer on doc gen
                        if(!appDTO.app.Customer_Confirmed_Online_Offer__c && (appDTO.app.Online_Self_serve_Upsell_Eligibility__c || appDTO.app.Online_Self_serve_Insurance_Eligibility__c)){
                            appDTO.app.Staff_Hide__c = true;
                        }
                        
                        //BEGIN MLASALA 06-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                        //Flush promo online message if unconditionally approved to doc gen
                        if(appDTO.app.Promo_Online_Message__c != null){
                            
                            appDTO.app.Promo_Online_Message__c = null;
                        }
                        //END MLASALA 06-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                    
                        try{
                            update appDTO.app;
                        }
                        catch(Exception e){
                            ErrorHandlerException.recordException(e.getMessage(),'generateDocumentRequest','Application__c','IS_GenerateDocument', String.valueOf(appDTO.app.Id));
                        }

                        return validationErrors;   

                    }
                }
                //END MLASALA: 08-SEPT-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN

                if(exceptionLogId==null) {
                    
                    // Removed by: Adrian Recio
                    // Description: Moved a separate call to allow synchronous calls on click of doc gen button
                    // Change Date: 23/09/2015
                    // make the asynchrous web service call 
                    // System.debug('###generate document future called');
                    // generateDocumentRequest(applicationID, mockEnable, requestedName, relatedDocuId);

                } else { //do the synch call if exceptionLogId is present
                    processWSGenerateDocument(appDTO, mockEnable, requestedName, exceptionLogId);
                }
            } else {
                String errorMesg = GEN_OriginationsConstants.ERR_MESSAGE_APPID_NOT_FOUND + applicationId;
                validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT, errorMesg));
            }

        } catch(Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_GENERATEDOC,
                                                                      'generateDocumentRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      exceptionLogId,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT);
            validationErrors.add(new IS_ValidationError(GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT, GEN_OriginationsConstants.ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION));
        }
        return validationErrors;
    }
    
    /**  Description: Future call for Generate Documents Webservice
     *  Author: Dan Crisologo
     *  Date Created: 12-16-13
     *  Input Parameters: applicationID
                        : mockEnable 
                        : requestedName
     *  Return: void
     */
    // Change by: Adrian Recio
    // Description: Sync fix for doc gen.
    // Date: 22/9/2015
    //@future (callout = true)
    public static void generateDocumentRequest(ID applicationID, Boolean mockEnable, String requestedName, String relatedDocuId) {
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        try{ 
            //populate Application
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), GEN_RecordRetrievalUtility.OBJECTNAME_APPLICATION, applicationId); 
            
            for(sObject applicants: GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId)) {
                Applicant__c applicantResult = (Applicant__c) applicants;
                if(applicantResult.Is_Primary_Applicant__c) {
                    appDTO.applicant = applicantResult; //assign to applicant1 if primary applicant
                } else {
                    appDTO.applicant2 = applicantResult; //assign to applicant2 if secondary applicant
                }
            }

            appDTO = setUpDocGenRecords(appDTO, relatedDocuId);

            processWSGenerateDocument(appDTO, mockEnable, requestedName, null); // exceptionLogId is null since ASYNC call is not used for RETRY services

         } catch (Exception e) {
            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(GEN_OriginationsConstants.MESSAGE_CODE_OTHEREXCEPTION,
                                                                      e.getMessage() + ':' + e.getStackTraceString(),
                                                                      GEN_OriginationsConstants.WSCLASS_GENERATEDOC,
                                                                      'generateDocumentRequest',
                                                                      appDTO.app.ID,
                                                                      requestedName,
                                                                      null,
                                                                      appDTO.app,
                                                                      Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                      GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT);
        }
    }

    /**  Description: Prepare Related Document Data
     *  Author: Russell Cadapan
     *  Date Created: 02-04-2014
     *  Input Parameters: IS_ApplicationDTO appDTO
     *  Return: IS_ApplicationDTO
     */
    @testvisible
    private static IS_ApplicationDTO runAsyncRelatedDocumentProcess(IS_ApplicationDTO appDTO, Id relatedDocuId) {
        if(relatedDocuId != null){
            List<Related_Document__c> rdList = new List<Related_Document__c>();
            rdList = [Select Id, Type__c, Title__c, Document_Category__c, Template_Name__c
                      From Related_Document__c 
                      Where Id =: relatedDocuId];
                      
            appDTO.acceptanceDocuments = rdList;
        } else{
            Set<String> existingTypes = new Set<String>();
            DOC_GenerateDocumentsUtil doc = new DOC_GenerateDocumentsUtil();
            appDTO.acceptanceDocuments = doc.retrieveDocumentsRequired(appDTO.app.Id);
            
            //start contract generation
            Set<Related_Document__c> existingRelatedDocumentsToDelete = new Set<Related_Document__c>();
            List<Related_Document__c> existingRelatedDocuments = GEN_RecordRetrievalUtility.retrieveApplicationRelatedDocuments(appDTO.app.Id);

            //retrieve existing documents that will be replaced by the new generated documents
            for(Related_Document__c existingRd : existingRelatedDocuments){
                for(Related_Document__c  accDoc : appDTO.acceptanceDocuments){
                    if((existingRd.Document_Category__c == 'Loan Documents' || existingRd.type__c!='Copy of Application') 
                        && (existingRd.GE_Link_Type__c == 'Static' || existingRd.GE_Link_Type__c == 'Generated Document') && existingRd.Document_Category__c == accDoc.Document_Category__c
                        && existingRd.type__c!='PicStarter Transcript' //TQLQW-481 [PL - AU] PicStarter - MDAVID - 9/02/2016
                        && existingRd.type__c!='ePOI Statement'){ //TQLQW-534 ePOI - RCADAPAN 12-OCT-2016
                        existingRelatedDocumentsToDelete.add(existingRd);
                    }
                }
            }

            List<Related_Document__c> relatedDocumentListToInsert = new List<Related_Document__c>();
            for(Related_Document__c rd: appDTO.acceptanceDocuments){
              relatedDocumentListToInsert.add(rd);
            }

            List<Related_Document__c> relDocToDel = new List<Related_Document__c>();
            //delete existing documents that passed the criteria above
            if(existingRelatedDocumentsToDelete.size() > 0){
                for(Related_Document__c rd: existingRelatedDocumentsToDelete){
                    relDocToDel.add(rd);
                }
            }

            if(relDocToDel.size() > 0){
                try{
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Related_Document__c.sObjectType.getDescribe().isDeletable()){
                      delete relDocToDel;
                      System.debug('###deleteDocuments');
                    }
                    */
                    delete relDocToDel;
                    System.debug('###deleteDocuments');
                }
                catch(Exception e){
                    System.debug('###error: ' + e.getStackTraceString());
                    ErrorHandlerException.recordException(e.getMessage(),'generateDocumentRequest','Related_Document__c','IS_GenerateDocument', String.valueOf(appDTO.app.Id));
                }
            }
            try{
                appDTO.app.Generated_Doc_Confirm_Sent__c = false;
                update appDTO.app;
            }
            catch(Exception e){
                System.debug('###error: ' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage(),'generateDocumentRequest','Related_Document__c','IS_GenerateDocument', String.valueOf(appDTO.app.Id));
            }
            //insert new acceptance documents
            if(appDTO.acceptanceDocuments.size() > 0){
                try{
                    insert relatedDocumentListToInsert;
                    System.debug('###generateAcceptance');
                }
                catch(Exception e){
                    ErrorHandlerException.recordException(e.getMessage(),'generateDocumentRequest','Related_Document__c','IS_GenerateDocument', String.valueOf(appDTO.app.Id));
                }
            }//end contract generation
        }

        return appDTO;

    }

    /**  Description: query additional records based on the existing documents
     *  Author: Dan Crisologo / Fel Saliba
     *  Date Created: 02-07-2014
     *  Input Parameters: IS_ApplicationDTO appDTO
     *  Return: IS_ApplicationDTO
     */
    private static IS_ApplicationDTO setUpDocGenRecords(IS_ApplicationDTO appDTO, String relatedDocuId) {

        //add all valid document types
        Set<String> documentTypes = new Set<String>();
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_CONTRACT);
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_ONR); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_LPI); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT);
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT_NZ);  
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_PRIVACY); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_CLOSURE_AUTH); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_REDUCTION_AUTH); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_PAYOUT_STATEMENT); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_IFREBATE); 
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_DISBURSEMENT_AUTH);
        //added as part of DBHZL-197 -start
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_NZ_SIGNUP_LETTER);
        documentTypes.add(GEN_OriginationsConstants.DOCUMENT_TYPE_GEMONEY_NZ_SIGNUP_LETTER);
        //---end-----
        
        String category = GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN;
        String appId = appDTO.app.Id;

        //Select all required acceptance documents
        String query = 'SELECT Id, Application__R.UID__C, Disbursement__c, Disbursement__r.Disbursement_Account_Type__c, Disbursement__r.New_Credit_Limit__c, Disbursement__r.Bank_Acc_No_NZ__c,'+ 
                       'Disbursement__r.Payout_Effective_Date__c, Disbursement__r.Record_Type_Name__c, Disbursement__r.Net_Payoff_Due__c, Disbursement__r.Bank_Acc_No__c, Disbursement__r.BSB__c, Disbursement__r.Account_Holders__c,'+ 
                       'Disbursement__r.Product_Name__c, Disbursement__r.Financial_Institution_Address_1__c, Disbursement__r.Amount__c, Disbursement__r.Payee__c, Disbursement__r.Current_Balance__c,'+ 
                       'Disbursement__r.Financial_Institution_Address_2__c, Disbursement__r.Financial_Institution_State__c, Disbursement__r.Valid_Until_Date__c,'+
                       'Disbursement__r.Financial_Institution_Suburb__c, Disbursement__r.Fin_Institution__c, Disbursement__r.Applicable_Party__c,Disbursement__r.RecordTypeId,'+
                       'Disbursement__r.Principal_Amount__c, Disbursement__r.Interest_Due__c, Disbursement__r.Late_Fees_Due__c, Disbursement__r.Branch__c,'+
                       'Disbursement__r.Penalty_Interest_Due__c, Disbursement__r.Fees_or_Charges_Due__c, Disbursement__r.Charge_Off_Amount__c,'+
                       'Disbursement__r.Insurance_Rebate__c, Disbursement__r.Broker_Name__c, Disbursement__r.Early_Termination_Fee__c, Type__c, Title__c, Disbursement__r.Financial_Institution_Postcode__c,'+
                       'Disbursement__r.Branch_Number__c, Disbursement__r.Suffix_Number__c, Disbursement__r.Financial_Institution_City__c, Disbursement__r.card_Number_or_3rd_Party_Ref__c,'+ //Added TXU to fix #1010
                       'Disbursement__r.Disbursement_Type_Code__c,Disbursement__r.BillerShortName__c,Disbursement__r.BillerCode__c,Disbursement__r.Reference__c,'+ //Added by Suneel for Cheque Disbursement Removal
                       'Document_Category__c, Template_Name__c'+
                       ' FROM Related_Document__c'+
                       ' WHERE Document_Category__c =: category'+
                       ' AND Type__c IN: documentTypes'+
                       ' AND Application__c =: appId';           
        
        if(relatedDocuId != null){
            query += ' AND Id =: relatedDocuId';
        }
        
        appDTO.acceptanceDocuments = Database.query(query);
        System.debug('appDTO.acceptanceDocuments--->'+appDTO.acceptanceDocuments);

        //Query document records
        appDTO = queryDocumentRecord(appDTO);
        System.debug('AppDTO.Product-->'+appDTO.product);

        return appDTO;
    
    }

    /**  Description: This will call the WS service class
     *  Author: Dan Crisologo
     *  Date Created: 03-24-2014
     *  Input Parameters: mockEnable, appDTO, requestedName, applicationID
     *  Return: void
     */
     @testvisible
    private static void processWSGenerateDocument(IS_ApplicationDTO appDTO, Boolean mockEnable, String requestedName, Id exceptionLogId) {
        try {
            WS_GenerateDocument wsGenerateDocument = new WS_GenerateDocument(mockEnable); 
            IS_WebserviceResponseDTO wsResponse = wsGenerateDocument.generateDocumentRequest(appDTO, requestedName);

            IS_WebserviceCommonUtil.processResponseAndUpdateApplication(wsResponse.messageCode,
                                                                        wsResponse.messageDescription,
                                                                        GEN_OriginationsConstants.WSCLASS_GENERATEDOC,
                                                                        'generateDocumentRequest',
                                                                        appDTO.app.ID,
                                                                        requestedName,
                                                                        exceptionLogId, 
                                                                        appDTO.app,
                                                                        Schema.sObjectType.Application__c.fields.Last_Webservice_Operation_Status__c,
                                                                        GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT);
                   
        } catch (Exception e) {
            throw e;
        }
    }
    @testvisible
    /**  Description: query additional records based on the existing documents
     *  Author: Dan Crisologo
     *  Date Created: 02-07-2014
     *  Input Parameters: IS_ApplicationDTO appDTO
     *  Return: IS_ApplicationDTO
     */
    private static IS_ApplicationDTO queryDocumentRecord(IS_ApplicationDTO appDTO) {
        
        Set<String> existingDocTypes = new Set<String>();
        
        //Query records based on the existence of required document types
        for(Related_Document__c rd: appDTO.acceptanceDocuments) {
            existingDocTypes.add(rd.Type__c);
        }
        
        //Query required contract records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_CONTRACT)) {
            if(appDTO.branch == null && appDTO.app.branch__c != null) {
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
            appDTO.collateralList = queryCollaterals(appDTO.app.Id);
                
            appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);//queryDisbursement(appDTO.app.Id);
                                 
            appDTO.insuranceList = queryProductItems(appDTO.app.Id);
            
            if(appDTO.app.Broker__c != null){
                appDTO.brokerDetails = queryBrokerDetails(appDTO.app.Broker__c);
            }
                        
            appDTO.feesAndCharges = queryFeesAndCharges(appDTO.app);
            
            appDTO.product = queryProduct(appDTO.app.Product_Id__c);
        }
        
        //Query required onr records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_ONR)) {
            //check if collateral hasn't been populated yet before using a query.
            if(appDTO.collateralList == null) {
                appDTO.collateralList = queryCollaterals(appDTO.app.Id);
            }
            //check if loanPurList hasn't been populated yet before using a query.
            if(appDTO.loanPurList == null) {
                appDTO.loanPurList = GEN_RecordRetrievalUtility.retrieveLoanPurposeList(appDTO.app.Id); 
            }

            //check if insuranceList hasn't been populated yet before using a query.
            if(appDTO.insuranceList == null) {
                appDTO.insuranceList = queryProductItems(appDTO.app.Id);
            }
            
            //check if product hasn't been populated yet before using a query.
            if(appDTO.product == null) {
                appDTO.product = queryProduct(appDTO.app.Product_Id__c);
            }
        }
        
        //Query required lpi records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_LPI)) {
            
            //check if insuranceList hasn't been populated yet before using a query.
            if(appDTO.insuranceList == null) {
                appDTO.insuranceList = queryProductItems(appDTO.app.Id);
            }
        }
        
        //Query required direct debit records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT) || existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT_NZ)) {
            
            appDTO.applicationDebits = queryApplicationDebits(appDTO.app.Id);
        }
        
        //Query required account closure records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_CLOSURE_AUTH)) {
            if(appDTO.branch == null && appDTO.app.branch__c != null) {
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
        }

        //Query required limit reduction records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_REDUCTION_AUTH)) {
            if(appDTO.branch == null && appDTO.app.branch__c != null) {
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
        }

        //Query required IF Rebate records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_IFREBATE)) {
            
            if(appDTO.branch == null && appDTO.app.branch__c != null) {
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
            appDTO.disbursementPlanList = queryDisbursementPlans(appDTO.app.Id);                       
        
        }
        
        //Query required Disbursement Auth records
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_DISBURSEMENT_AUTH)) {
            if(appDTO.applicationDebits == null) {
                appDTO.applicationDebits = queryApplicationDebits(appDTO.app.Id);
            }
        }
        
        //Query required NZ Signup letter records DBHZL-197
        if(existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_NZ_SIGNUP_LETTER) || existingDocTypes.contains(GEN_OriginationsConstants.DOCUMENT_TYPE_GEMONEY_NZ_SIGNUP_LETTER)) {
            if(appDTO.branch == null && appDTO.app.branch__c != null) {
                appDTO.branch = queryBranchDetails(appDTO.app.branch__c);
            }
            
            appDTO.collateralList = queryCollaterals(appDTO.app.Id);
                
            appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);//queryDisbursement(appDTO.app.Id);
                                 
            appDTO.insuranceList = queryProductItems(appDTO.app.Id);
            
            if(appDTO.applicationDebits == null) {
                appDTO.applicationDebits = queryApplicationDebits(appDTO.app.Id);
            }
            
            if(appDTO.loanPurList == null) {
                appDTO.loanPurList = GEN_RecordRetrievalUtility.retrieveLoanPurposeList(appDTO.app.Id); 
            }
        }
        
        System.debug('appDTO.applicationDebits'+appDTO.applicationDebits);
        return appDTO;
    }
    @testvisible
    private static Branch__c queryBranchDetails(Id branchId) {
        return [SELECT Branch_Id__c, 
                       name,
                       Phone__c, 
                       Fax__c, 
                       Primary_Contact__r.Name,
                       Suburb__c,
                       State__c,
                       address__c,
                       Postcode__c,
                       Country__c                       
                FROM   Branch__c 
                WHERE  id =: branchId];
    }
    @testvisible
    private static List<Collateral__c> queryCollaterals(Id applicationId) {
        return [SELECT Collateral_Body_Type__c, 
                       Collateral_Reg_No__c,
                       Collateral_Eng_No__c,
                       Collateral_VIN_No__c,
                       Collateral_Type__c,
                       Collateral_Make__c,
                       Collateral_Model__c,
                       Collateral_Year__c,
                       Collateral_Val__c,
                       Collateral_Date_Valued__c,
                       Collateral_Insurance_company_name__c,
                       Collateral_Insurance_expiry_date__c,
                       Collateral_Insurance_Policy_number__c,
                       Collateral_NVIC__c,
                       Collateral_State_of_Registration__c,
                       Collateral_Owner__c,
                       Color__c,
                       Length__c,
                       Record_Type_Name__c
                FROM   Collateral__c
                WHERE  Application__c =: applicationId];
    }
    @testvisible
    private static List<Disbursement__c> queryDisbursement(Id applicationId) {
        return [SELECT Fin_Institution__c,                    
                       Amount__c,
                       Disbursement_Outcome_Comments__c,
                       RecordTypeId,
                       Disbursement_Outcome__c,
                       Disbursement_Account_Type__c,
                       Bank_Acc_No__c,
                       Bank_Acc_No_NZ__c,
                       Financial_Institution_Address_1__c,
                       Financial_Institution_Address_2__c,
                       Payout_Effective_Date__c,
                       Principal_Amount__c,
                       Interest_Due__c,
                       Late_Fees_Due__c,
                       Penalty_Interest_Due__c,
                       Fees_or_Charges_Due__c,
                       Charge_Off_Amount__c,
                       Insurance_Rebate__c,
                       Early_Termination_Fee__c,
                       Net_Payoff_Due__c,
                       New_Credit_Limit__c,
                       Valid_Until_Date__c,
                       Product_Name__c,
                       Record_Type_Name__c,
                       Payee__c,
                       Insurance_Type__c,
                       Broker_Aggregator_Account_Name__c,
                       Broker_Name__c                                              
                FROM   Disbursement__c
                WHERE  Application__c =: applicationId];
                                     
    }
    @testvisible
    private static List<Product_Item__c> queryProductItems(Id applicationId) {
        return [SELECT Product_Version__r.Product_Name__c,
                       Insurance_Stamp_Duty__c,
                       Insurance_Stamp_Duty_Amount__c,
                       Insurance_GST__c,
                       Benefit_Amount__c,
                       BenefitPercent__c,
                       Max_Benefit__c,
                       Max_Duration_Of_Repay__c,
                       Fixed_Premium_Amount__c,
                       Policy_Type__c,
                       Applicant1__c,  //Added by Tony Xu to fix issue with Rows not retrieved in WebServiceHelper
                       Applicant2__c
                FROM   Product_Item__c
                WHERE  Application__c =: applicationId];
                                     
    }
    @testvisible
    private static Contact queryBrokerDetails(Id brokerId) {
        return [SELECT Broker_ID__c,
                         firstName,
                         lastName,
                         account.Name,
                         account.Trust_Entity_Name__c,
                         account.Aggregator_Account_Name__c,
                         MailingCity,
                         MailingState,
                         MailingPostalCode,
                         HomePhone,
                         MobilePhone,
                         Broker_Aggregator_Account_Name__c,
                         Contact_Accreditation_Status__c
                   FROM  Contact
                   WHERE Id =: brokerid];
                                     
    }
    @testvisible
    private static List<Debit__c> queryApplicationDebits(Id applicationId) {
        
        List<Debit__c> debits = GEN_RecordRetrievalUtility.retrieveApplicationDebit(applicationId);
        List<Debit__c> debitsToReturn = new List<Debit__c>();
        if(!debits.isEmpty()){
            for(Debit__c d:debits){
               if(d.RecordType.Name == GEN_OriginationsConstants.DIRECT_DEBIT_RECORDTYPE || d.RecordType.Name == GEN_OriginationsConstants.DIRECT_DEBIT_RECORDTYPE_NZ){
                    debitsToReturn.add(d);
                }
            }
        }
        return debitsToReturn;
                                     
    }
    @testvisible
    private static List<Debit__c> queryApplicationAllDebits(Id applicationId) {
        
        List<Debit__c> debits = GEN_RecordRetrievalUtility.retrieveApplicationDebit(applicationId);
        List<Debit__c> debitsToReturn = new List<Debit__c>();
        if(!debits.isEmpty()){
            for(Debit__c d:debits){
             debitsToReturn.add(d);       
            }
        }
      return debitsToReturn;
                                     
    }   
    @testvisible
    private static List<Disbursement_Plan__c> queryDisbursementPlans(Id applicationId) {
        
        //BEGIN MLASALA: 22-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
         Id cardClosureType = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE).getRecordTypeId();
         //BEGIN Suneel : 10-07-18 - Adding two record types for IFRebate Letter
         Id cardLimitIntFreeType = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('LFS Card Limit Reduction with Interest Free').getRecordTypeId();
         Id cardPayDownIntFreeType = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('LFS Card Pay down with Interest Free').getRecordTypeId();

        /*
        List<Disbursement__c> disbursements = GEN_RecordRetrievalUtility.retrieveDisbursementsList(applicationId);
        
        Set<Id> disbursementId = new Set<Id>();
        if(!disbursements .isEmpty()){
            for(Disbursement__c d:disbursements ){
                if(d.Record_Type_Name__c == GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE){
                    disbursementId.add(d.Id);
                }                               
            }
        }
        */
        //END MLASALA: 22-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        
        List<Disbursement_Plan__c> disbursementPlans = new List<Disbursement_Plan__c>();
        disbursementPlans = [Select Disbursement__c,
                                    IF_Credit_Plan_Number__c,
                                    IF_Current_Credit_Plan_Balance__c,
                                    Rebate_Amount__c,
                                    Disbursement__r.Payee__c,
                                    Disbursement__r.Bank_Acc_No__c,
                                    Disbursement__r.Bank_Acc_No_NZ__c,
                                    Disbursement__r.Total_Rebate_Amount__c,
                                    Disbursement__r.Total_IF_Credit_Plan_Balance__c
                                    From Disbursement_Plan__c
                            Where   Disbursement__r.application__c =: applicationId
                             and    (Disbursement__r.recordTypeId =: cardClosureType OR Disbursement__r.recordTypeId =: cardLimitIntFreeType OR Disbursement__r.recordTypeId =: cardPayDownIntFreeType)];
        
        return disbursementPlans;       
                                     
    }
    @testvisible
    private static List<Fees_Charges__c> queryFeesAndCharges(Application__c app) {
    
        GEProduct__c product = [Select name, Logo_Id__c, Org_Id__c,Description__c, External_ID__c, Insurance_Type__c,
                                 Product_Name__c, Product_Number__c, Type__c, Logo_Id_Secured__c, Brands__r.Name from GEProduct__c where id =: app.Product_Id__c]; 
    
        Set<String> feesToQuery = new Set<String>();
        feesToQuery.add(GEN_OriginationsConstants.FEE_ESTABLISHMENT);
        feesToQuery.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION1);
        feesToQuery.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION2);
        feesToQuery.add(GEN_OriginationsConstants.FEE_PAYMENT_HANDLING);
        feesToQuery.add(GEN_OriginationsConstants.FEE_LOAN_SERVICE);
        feesToQuery.add(GEN_OriginationsConstants.FEE_LATE_PAYMENT);
    
         return [SELECT Brand__c, 
                        Fee_Amount__c,
                        Fee_Type__c
                 FROM   Fees_Charges__c
                 WHERE  Fee_Type__c IN: feesToQuery
                  AND   Brand__c =: product.Brands__r.Name
                  AND   (Effective_Start_Date__c <=: Date.valueOf(app.LastModifiedDate) OR Effective_Start_Date__c = null)
                  AND   (Effective_End_Date__c >=: Date.valueOf(app.LastModifiedDate) OR Effective_End_Date__c = null)
                  AND   (Low_Value__c <=: app.Total_Loan_Amount__c OR Low_Value__c = null)
                  AND   (High_Value__c >=: app.Total_Loan_Amount__c OR High_Value__c = null)
                  AND   Active__c = true];
    }
    @testvisible
    private static GEProduct__c queryProduct(String prodId){
        
        GEProduct__c product = [Select name, Logo_Id__c, Org_Id__c, Description__c, External_ID__c, Insurance_Type__c,
                                 Product_Name__c, Product_Number__c, Type__c, Logo_Id_Secured__c, Brands__r.Name from GEProduct__c where id =: prodId];
                                 
                                 
        return product;                      
    }
    @testvisible
    private static List<Compliance_Check__c> queryComplianceCheck(String appId){
        
       List<Compliance_Check__c> compliance = new List<Compliance_Check__c>();
       compliance = [Select Id, Pre_Contract_Indicator__c, PFR_Check__c, PFR_Only__c, BM_Check__c, BM_Only__c
                    from Compliance_Check__c where Application__c =: appId];
       
       return compliance;
    }
    @testvisible
    private static List<Personal_Reference_Check__c> queryPersonalReferenceCheck(String appId){
        
       List<Personal_Reference_Check__c> personal = new List<Personal_Reference_Check__c>();
       personal = [Select Id, Relationship__c,Personal_Ref_Address__c,
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
                                                   Phone_Number__c,unit_number__c from Personal_Reference_Check__c where Application__c =: appId];
       
       return personal;
    }      
}