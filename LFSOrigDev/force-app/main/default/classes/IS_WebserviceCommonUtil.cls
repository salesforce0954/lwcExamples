/**
 * @Description: IS Class for application update
 * @Author: Dan Crisologo
 * @Date Created: MAR-12-2014
 * @History:
   =====================================================================
       03-12-14: Created. - Dan
       2015-08-12: PMIHM-1307 new static method to populate risk referral workflow Tony Xu
   =====================================================================
 */ 
public class IS_WebserviceCommonUtil {

    /*  Description: Query application and applicant records
     *  Author: Dan Crisologo
     *  Date Created: DEC-16-2013
     *  Input: applicationID
     *  Return: ApplicationSubmitCommons 
     */
    public static IS_ApplicationDTO initializeApplicationData(Id applicationID) {
        try {
            IS_ApplicationDTO appDTO = new IS_ApplicationDTO(); 
    
            appDTO.app = (Application__c) GEN_RecordRetrievalUtility.querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), 'Application__c', applicationId);   
            system.debug('app feilds check'+appDTO.app);
            for(sObject applicants: GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId)) {
                Applicant__c applicantResult = (Applicant__c) applicants;
                if(applicantResult.Is_Primary_Applicant__c) {
                    appDTO.applicant = applicantResult; //assign to applicant1 if primary applicant
                } else {
                    appDTO.applicant2 = applicantResult; //assign to applicant2 if secondary applicant
                }
            }
        
            return appDTO;
        } catch(Exception e) {
            throw e;
        }
    
    }

    /*  Description: Query other application-related records that are common to both submit and update services
     *  Author: Dan Crisologo
     *  Date Created: DEC-16-2013
     *  Input: applicationID
     *  Return: ApplicationSubmitCommons 
     */
    public static IS_ApplicationDTO loadOtherApplicationData(IS_ApplicationDTO appDTO) {
        try {
            appDTO.onrList = [Select Id, Name, geID__c, Prompt__c, Type__c, Value__c from ONR__c where Application__c = : appDTO.app.Id]; 
            appDTO.incList = GEN_RecordRetrievalUtility.retrieveIncomeSortedByAmount(appDTO.applicant.Id);
            appDTO.assetList = GEN_RecordRetrievalUtility.retrieveAssetList(appDTO.applicant.Id);
            appDTO.debtList = GEN_RecordRetrievalUtility.retrieveDebtList(appDTO.applicant.Id); 
            appDTO.expenseList = GEN_RecordRetrievalUtility.retrieveExpenseList(appDTO.applicant.Id);
            appDTO.clvList = GEN_RecordRetrievalUtility.retrieveApplicantCLVList(appDTO.applicant.Id); //use a direct query since we only need the clv__c field
            
            appDTO.collateralList =  GEN_RecordRetrievalUtility.retrieveCollateralList(appDTO.app.Id);
            appDTO.loanPurList = GEN_RecordRetrievalUtility.retrieveLoanPurposeList(appDTO.app.Id); 
            
            appDTO.applicationDebits = GEN_RecordRetrievalUtility.retrieveApplicationDebit(appDTO.app.Id);
            
            appDTO.product = [SELECT  name, 
                                      Logo_Id__c, 
                                      Org_Id__c, 
                                      Description__c, 
                                      External_ID__c, 
                                      Insurance_Type__c,
                                      Product_Name__c, 
                                      Product_Number__c, 
                                      Type__c, 
                                      Logo_Id_Secured__c, 
                                      Brands__r.Name, 
                                      Brands__r.Country__c,
                                      Logo_Id_Bundled__c,
                                      Logo_Id_Bundled_Secured__c
                              FROM    GEProduct__c 
                              WHERE   id =: appDTO.app.Product_Id__c]; 
            
            appDTO.personalReferenceList = [SELECT Personal_Ref_Address__c,
                                                   Name__c,
                                                   Phone_Number__c,
                                                   Relationship__c,
                                                   Town_City__c,
                                                   Suburb__c,
                                                   Street_Type__c,
                                                   Street_Number__c,
                                                   Street_Name__c,
                                                   State__c,
                                                   Property_Name__c,
                                                   Postcode__c,
                                                   Country__c,
                                                   unit_number__c
                                            FROM   Personal_Reference_Check__c
                                            WHERE  Application__c =: appDTO.app.Id]; 
            
            //Query all fee types that are required for webservice
            Set<String> feesToQuery = new Set<String>();
            feesToQuery.add(GEN_OriginationsConstants.FEE_ESTABLISHMENT);
            feesToQuery.add(GEN_OriginationsConstants.FEE_PPSR_SEARCH);
            feesToQuery.add(GEN_OriginationsConstants.FEE_PPSR_REGISTRATION);
            feesToQuery.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION1);
            feesToQuery.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION2);
            feesToQuery.add(GEN_OriginationsConstants.FEE_PAYMENT_HANDLING);
            feesToQuery.add(GEN_OriginationsConstants.FEE_LOAN_SERVICE);
            feesToQuery.add(GEN_OriginationsConstants.FEE_LATE_PAYMENT);
            
            appDTO.feesAndCharges = [SELECT Brand__c, 
                                            Fee_Amount__c,
                                            Fee_Type__c
                                     FROM   Fees_Charges__c
                                     WHERE  Fee_Type__c IN: feesToQuery
                                      AND   Brand__c =: appDTO.product.Brands__r.Name
                                      AND   (Effective_Start_Date__c <=: Date.valueOf(appDTO.app.LastModifiedDate) OR Effective_Start_Date__c = null)
                                      AND   (Effective_End_Date__c >=: Date.valueOf(appDTO.app.LastModifiedDate) OR Effective_End_Date__c = null)
                                      AND   (Low_Value__c <=: appDTO.app.Total_Loan_Amount__c OR Low_Value__c = null)
                                      AND   (High_Value__c >=: appDTO.app.Total_Loan_Amount__c OR High_Value__c = null)
                                      AND   Active__c = true];
            
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
            
            //query additional budget details only if application is joint
            if(appDTO.app.application_type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
                appDTO.incList2 = GEN_RecordRetrievalUtility.retrieveIncomeList(appDTO.applicant2.Id);
                appDTO.assetList2 = GEN_RecordRetrievalUtility.retrieveAssetList(appDTO.applicant2.Id);
                appDTO.debtList2 = GEN_RecordRetrievalUtility.retrieveDebtList(appDTO.applicant2.Id); 
                appDTO.expenseList2 = GEN_RecordRetrievalUtility.retrieveExpenseList(appDTO.applicant2.Id);
                appDTO.clvList2 = GEN_RecordRetrievalUtility.retrieveApplicantCLVList(appDTO.applicant2.Id); //use a direct query since we only need the clv__c field
            }
            
            return appDTO;
        } catch (Exception e) {
            throw e;
        }
    }
    
    /**  Description: loads additional required application update data such as Insurance, Broker and Disbursements details
     *  Author: Dan Crisologo
     *  Date Created: 01-21-13
     *  Input Parameters: appDTO
     *  Return: IS_ApplicationDTO
     */
    public static IS_ApplicationDTO loadAdditionalUpdateData(IS_ApplicationDTO appDTO) {
        try {
            //load insurance list
            appDTO.insuranceList = [SELECT  Policy_Type__c, 
                                                       Ins_Term__c, 
                                                       Product_Version__r.GEProduct__r.Insurance_Type_Num__c, 
                                                       Fixed_Premium_Amount__c,
                                                       Cover_Amount_Formula__c,
                                                       Insurance_GST__c,
                                                       Insurance_Stamp_Duty__c,
                                                       Insurance_Stamp_Duty_Amount__c,
                                                       Product_Version__r.Start_Date__c,
                                                       Product_Name__c,
                                                       Product_Version__r.End_Date__c
                                                       //Application__r.Brand_Country__c
                                                FROM   Product_Item__c
                                                WHERE  Product_Version__r.GEProduct__r.Insurance_Type_Num__c != 0
                                                 AND   Application__c =: appDTO.app.Id];

            //Disbursement list
            appDTO.disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appDTO.app.Id);
            
            //Query compliance checks
            appDTO.complianceCheckList = [SELECT   PFR_Check__c,
                                                   Meta_Compliance_Post_Settle__r.Checklist__c,
                                                   Meta_Compliance_Post_Settle__r.Integration_ID__c
                                          FROM     Compliance_Check__c
                                          WHERE    Application__c =: appDTO.app.Id
                                           AND     Meta_Compliance_Post_Settle__r.Integration_ID__c != null];
        
            return appDTO;
            
        } catch (Exception e) {
            throw e;
        }

    }
    
    /**  Description: loads additional required/optional application submit data such as the aml data
     *  Author: Dan Crisologo
     *  Date Created: 02-05-2014
     *  Input Parameters: appDTO
     *  Return: IS_ApplicationDTO
     */
    public static IS_ApplicationDTO loadAdditionalSubmitData(IS_ApplicationDTO appDTO) {
        try {
            appDTO.amlList = GEN_RecordRetrievalUtility.retrieveAMLList(appDTO.applicant.Id);
            if(appDTO.applicant2!=null) {
                appDTO.amlList2 = GEN_RecordRetrievalUtility.retrieveAMLList(appDTO.applicant2.Id);
            }
            
            return appDTO;
        } catch (Exception e) {
            throw e;
        }
    }
    
    /**  Description: loads user and branch data
     *  Author: Dan Crisologo
     *  Date Created: 02-05-2014
     *  Input Parameters: appDTO
     *  Return: IS_ApplicationDTO
     */
    public static IS_ApplicationDTO loadUserAndBranchData(IS_ApplicationDTO appDTO, String requestedName) {
        try {
            if(appDTO.app.branch__c!=null) {
                appDTO.branch = [SELECT Branch_Id__c, 
                                        District__r.Name, 
                                        Phone__c, 
                                        Fax__c, 
                                        Primary_Contact__r.Name,
                                        Name
                                 FROM   Branch__c 
                                 WHERE  id =: appDTO.app.branch__c];
            }
            if(requestedName==Web_Service_Settings__c.getValues('Requested Name Sales').Value__c && 
                appDTO.app.ownerId!=null) {
                if(Util.isIdTypeOfObject(appDTO.app.ownerId, User.sObjectType)) {
                    appDTO.applicationOwner = [SELECT Name,
                                                      SSO_Number__c
                                               FROM   User
                                               WHERE  Id =: appDTO.app.ownerId];
                }
            }
            return appDTO;
        } catch (Exception e) {
            throw e;
        }
    }
    
    /*  *Description: handles webservice response post-processing
        *Author: Dan Crisologo
        *Created: MAR-25-2014
        *Param: response - webservice messge code
                responseDescription - ws msg description
                errorClassName - class name
                errorClassMethod - method invoked
                recordId - application / customer search id
                wsRequestedName - source ui
                exceptionLogId - exception log record, if present
        *return: None. 
    */
    public static Boolean processResponseAndUpdateApplication(String response, 
                                          String responseDescription, 
                                          String className, 
                                          String classMethod, 
                                          Id recordId, 
                                          String wsRequestedName,
                                          Id exceptionLogId,
                                          Application__c app,
                                          Schema.DescribeFieldResult appFieldToUpdate,
                                          String serviceName) {
        
        System.debug('***** Response = ['+response+'] *****');  
        System.debug('***** Response Description = ['+responseDescription+'] *****');  
        System.debug('Retry log ID: ' + exceptionLogId);
        Boolean isSuccess = true;
        
        //update the existing error log if present. Retry result should be logged in the exceptionlog record
        ExceptionLog__c exLog;   
        
        Set<String> retryAbleErrors = new Set<String>();
        for(Webservice_Message_Codes__c wmc : [Select Name from Webservice_Message_Codes__c where Retry__c = true AND Synchronous__c = true]) {
            retryAbleErrors.add(wmc.Name);
        }
           
        if(exceptionLogId!=null) {
            exLog = [SELECT Retry_Message__c, 
                            Retry_Attempts__c, 
                            Retry_Status__c, 
                            Last_Retry_Attempt__c,
                            Exception__c
                     FROM   ExceptionLog__c
                     WHERE  Id =: exceptionLogId];
            
            String exceptionMessage = exLog.Exception__c + '** RETRY RESULT: ' + responseDescription + ' **';
            ErrorHandlerException.updateWebServiceRetryLog(response, exceptionMessage, exLog);
                     
        } else if(response!=GEN_OriginationsConstants.WSCODE_SUCCESS2) {

            //if it is not for retry then it is automatically failed
            String retryStatus = retryAbleErrors.contains(response)? GEN_OriginationsConstants.RETRY_STATUS_PENDING : GEN_OriginationsConstants.RETRY_STATUS_FAILED; 
     
            RecordType recMap = Util.getWebServiceRecordType();
            ErrorHandlerException.recordWebserviceException('Response Code: [' + response + '] - ' + responseDescription, 
                                                            null, //stacktrace
                                                            className, 
                                                            classMethod, 
                                                            ErrorHandlerException.ORIGIN_CLASS, 
                                                            ErrorHandlerException.STATUS_FAILED, 
                                                            recordId, 
                                                            0, 
                                                            recMap.Id,
                                                            response,
                                                            wsRequestedName,
                                                            retryStatus);    

        } 
        
        //update the application status
        if(response!=null && className!=GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH && app!=null) { //do not update application if customer search / account search
            
            Boolean lessThanMaxAttempt = true;
            if(exLog!=null) {
                lessThanMaxAttempt = exLog.Retry_Attempts__c + 1 >= Integer.valueOf(Web_Service_Settings__c.getValues('Max Retry').Value__c) ? false : true;
            }
            //for application submit, make sure to also update the response code (in case of sync failures, etc. to properly show the submit failure)
            if(className==GEN_OriginationsConstants.WSCLASS_SUBMIT) {
                app = populateAppSubmitFields(app, response, lessThanMaxAttempt, retryAbleErrors.contains(response));
            }
            
            //for application update/verify AML/verity POI/accept contract, make sure to also update the response code (in case of sync failures, etc. to properly show the update failure)
            if(className==GEN_OriginationsConstants.WSCLASS_UPDATE || 
               className==GEN_OriginationsConstants.WSCLASS_VERIFYAML || 
               className==GEN_OriginationsConstants.WSCLASS_VERIFYPOI || 
               className==GEN_OriginationsConstants.WSCLASS_ACCEPTCONTRACT) {
                
                app = populateOtherOperationFields(app, response);
            }

            //for doc gen, set the doc gen confirm flagging to false
            if(className==GEN_OriginationsConstants.WSCLASS_GENERATEDOC) {
                app = populateDocGenFields(app, response);
            }

            app.Last_Webservice_Operation_Invoked__c = serviceName;
                
            isSuccess = updateWSStatus(app, appFieldToUpdate, response, lessThanMaxAttempt, retryAbleErrors.contains(response));

        }
        
        return isSuccess;
    }
    
    /*  *Description: update application submit fields
        *Author: Dan Crisologo
        *Created: MAR-27-2014
        *Param: response - response code received
                lessThanMaxAttempt - less than max attempt not yet hit
                retryAbleResponse - response code is considered retryAble response
        *return: Application__c - Application with values set 
    */
    public static Application__c populateAppSubmitFields(Application__c app, String response, Boolean lessThanMaxAttempt, Boolean retryAbleResponse)  {

        if(app.Initial_Submit_Date__c==null) {
            app.Initial_Submit_Date__c = Datetime.Now();
        }
        app.Last_Submit_Date__c = Datetime.Now();
        app.Error_Response_Code__c = response;

        //setting the response code uses a workflow rule to set the equivalent value of status__c
        if(response==GEN_OriginationsConstants.WSCODE_SUCCESS2) {//Sync response is successful
            //set Response Code to SUC to disable buttons while waiting for the Application Response record to be inserted.
            app.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_SUCCESS;
            app.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
            app.Error_Response_Code__c = null;
        } else if(retryAbleResponse && lessThanMaxAttempt) {//sync response is retry-able
            //app.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_RETRY;
            app.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_RETRY_IN_PROGRESS;
        } else if(response==GEN_OriginationsConstants.WSCODE_SU || response==GEN_OriginationsConstants.WSCODE_SU2) { //system unavailable
            //app.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_SERVICEUNAVAILABLE;
            app.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SERVICE_UNAVAILABLE;
        } else {
            //set the response code to submit failure only if it is not a pre-submit exception
            //maintain the status__c as NEW

            // Code Scan Fix: Adrian Recio - Empty Condition
            /*
            if(response!=GEN_OriginationsConstants.MESSAGE_CODE_PRESUBMIT_EXCEPTION) { 
                //app.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_SUBMITFAILURE;
            }
            */
          
            app.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMIT_FAILURE;
        }
        return app;
    }
    /*  *Description: update application update fields
        *Author: Dan Crisologo
        *Created: MAR-27-2014
        *Param: response - response code received
                lessThanMaxAttempt - less than max attempt not yet hit
                retryAbleResponse - response code is considered retryAble response
        *return: Application__c - Application with values set 
    */
    public static Application__c populateOtherOperationFields(Application__c app, String response) {
        //setting the response code uses a workflow rule to set the equivalent value of status__c
        if(response==GEN_OriginationsConstants.WSCODE_SUCCESS2) {//Sync response is successful
            app.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_SUCCESS;
            app.Error_Response_Code__c = null;
        } else { //Populate error response code if unsuccessful
            app.Error_Response_Code__c = response;
        }

        return app;
    }

    /*  *Description: update doc gen fields
        *Author: Dan Crisologo
        *Created: MAY-02-2014
        *Param: Application - application record to update
                response - response code returned by WS
        *return: Application__c - Application with values set 
    */
    public static Application__c populateDocGenFields(Application__c app, String response)  {

        //set confirm sent to false for every successful doc gen request
        if(response==GEN_OriginationsConstants.WSCODE_SUCCESS2) {
            app.Generated_Doc_Confirm_Sent__c = false;
            //app.Response_Code__c = GEN_OriginationsConstants.WSCODE_DOCGEN_SUCCESS;
        }

        return app;
    }

    /*  *Description: update application from other ws services
        *Author: Dan Crisologo
        *Created: MAR-27-2014
        *Param: app - application record to update
                appFieldToUpdate - response code received Schema.sObjectType.Account.fields.AccountNumber;
                wsStatus - less than max attempt not yet hit
                retryAbleResponse - response code is retryAble response 
                lessThanMaxAttempt - less than max attempt not yet hit
        *return: None. 
    */
    public static Boolean updateWSStatus(Application__c app, 
                                         Schema.DescribeFieldResult appFieldToUpdate, 
                                         String response, 
                                         Boolean retryAbleResponse, 
                                         Boolean lessThanMaxAttempt) {
        
        Boolean isSuccess = false;
        String status = '';
        
        if(response==GEN_OriginationsConstants.WSCODE_SUCCESS2) {//Sync response is successful
            status = GEN_OriginationsConstants.WS_STATUS_SENT;
            isSuccess = true;
        } else if(retryAbleResponse && lessThanMaxAttempt) {//sync response is retry-able
            status = GEN_OriginationsConstants.WS_STATUS_RETRYPENDING;
        } else { //system unavailable or general error
            status = GEN_OriginationsConstants.WS_STATUS_FAILED;
        } 
        
        app.put(appFieldToUpdate.getsObjectField(), status);
        update app;
        
        return isSuccess;
        
    }
    
    /*  *Description: Extract the detail message from service context in an OASS response
        *Author: Dan Crisologo
        *Created: APR-16-2014
        *Param: serviceContext - service context of a webservice response
        *return: None. 
    */
    public static String getOASSExceptionDetail(ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContext) {
        String exceptionDetail = '--';
        if(serviceContext.exceptions!=null) {
            if(serviceContext.exceptions.exception_x!=null) {
                if(serviceContext.exceptions.exception_x.size()>0) {
                    Integer ctr = 1;
                    for(ConsumerAnzCapitalGeComOriginations.Exception_x ex: serviceContext.exceptions.exception_x) {
                        exceptionDetail = exceptionDetail + 'EXCEPTION' + ctr + ':' + ex.detailedMessage;
                        ctr++;
                    }
                }
            }
        }
        return exceptionDetail;
    }
    
    /**Description: Extract the detail message from service context in an GeneratePayoffQuote response DBHZL386
        *Author: Tony Xu
        *Created: 2015-03-02
        *Param: serviceContext - service context of a webservice response
        *return: None. 
    */
    public static String getGeneratePayoffFigureExceptionDetail(PayoffQuoteAnzCapitalGeCom.ServiceContext serviceContext) {
        String exceptionDetail = '--';
        if(serviceContext.exceptions!=null) {
            if(serviceContext.exceptions.exception_x!=null) {
                if(serviceContext.exceptions.exception_x.size()>0) {
                    Integer ctr = 1;
                    for(PayoffQuoteAnzCapitalGeCom.Exception_x ex: serviceContext.exceptions.exception_x) {
                        exceptionDetail = exceptionDetail + 'EXCEPTION' + ctr + ':' + ex.detailedMessage;
                        ctr++;
                    }
                }
            }
        }
        return exceptionDetail;
    }
    
    
    /**
        Description: Extract the workflow associated with the application to pass the risk referal decision makers
                     decision and sso down to Activate
        Author:      Tony Xu
        Date:        2015-08-12
        Input Param: IS_ApplicationDTO
        Return: IS_ApplicationDTO
    **/
    public static IS_ApplicationDTO loadRiskWorkflow(IS_ApplicationDTO appDTO){
        
        appDTO.workflowList = GEN_RecordRetrievalUtility.retrieveWorkflow(appDTO.app.id);
        return appDTO;
                
    }
    
    /**
        Description: Extract the quote feilds to call Submit Interface down to Activate
        Author:     Madhusudhan Seethala
        Date:        2020-03-20
        Input Param: Quote ID
        Return: IS_ApplicationDTO
    **/
    public static IS_ApplicationDTO initializeQuoteData(ID quoteID){
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO(); 
        appDTO.quote = GEN_RecordRetrievalUtility.retrieveQuote(quoteID);
        return appDTO;
                
    }
     
  /*  *Description: handles webservice response post-processing
        *Author: Madhusudhan Seethala
        *Created: APR-01-2020
        *Param: response - webservice messge code
                responseDescription - ws msg description
                errorClassName - class name
                errorClassMethod - method invoked
                recordId - application / customer search id
                wsRequestedName - source ui
                exceptionLogId - exception log record, if present
        *return: None. 
    */
    public static Boolean processResponseAndUpdateQuote(String response, 
                                          String responseDescription, 
                                          String className, 
                                          String classMethod, 
                                          Id recordId, 
                                          String wsRequestedName,
                                          Id exceptionLogId,
                                          Quote__c quote,
                                          Schema.DescribeFieldResult quoteFieldToUpdate,
                                          String serviceName) {
        
        System.debug('***** Response = ['+response+'] *****');  
        System.debug('***** Response Description = ['+responseDescription+'] *****');  
        System.debug('Retry log ID: ' + exceptionLogId);
        Boolean isSuccess = true;
        
        //update the existing error log if present. Retry result should be logged in the exceptionlog record
        ExceptionLog__c exLog;   
        
        Set<String> retryAbleErrors = new Set<String>();
        for(Webservice_Message_Codes__c wmc : [Select Name from Webservice_Message_Codes__c where Synchronous__c = false]) {
            retryAbleErrors.add(wmc.Name);
        }
           
        if(exceptionLogId!=null) {
            exLog = [SELECT Retry_Message__c, 
                            Retry_Attempts__c, 
                            Retry_Status__c, 
                            Last_Retry_Attempt__c,
                            Exception__c
                     FROM   ExceptionLog__c
                     WHERE  Id =: exceptionLogId];
            
            String exceptionMessage = exLog.Exception__c + '** RETRY RESULT: ' + responseDescription + ' **';
            ErrorHandlerException.updateWebServiceRetryLog(response, exceptionMessage, exLog);
                     
        } else if(response!=GEN_OriginationsConstants.WSCODE_SUCCESS2) {

            //if it is not for retry then it is automatically failed
            String retryStatus = retryAbleErrors.contains(response)? GEN_OriginationsConstants.RETRY_STATUS_PENDING : GEN_OriginationsConstants.RETRY_STATUS_FAILED; 
     
            RecordType recMap = Util.getWebServiceRecordType();
            ErrorHandlerException.recordWebserviceException('Response Code: [' + response + '] - ' + responseDescription, 
                                                            null, //stacktrace
                                                            className, 
                                                            classMethod, 
                                                            ErrorHandlerException.ORIGIN_CLASS, 
                                                            ErrorHandlerException.STATUS_FAILED, 
                                                            recordId, 
                                                            0, 
                                                            recMap.Id,
                                                            response,
                                                            wsRequestedName,
                                                            retryStatus);    

        } 
        
        //update the quote status
        if(response!=null && className!=GEN_OriginationsConstants.WSCLASS_CUSTOMERSEARCH && quote!=null) { 
            
            Boolean lessThanMaxAttempt = true;
            if(exLog!=null) {
                lessThanMaxAttempt = exLog.Retry_Attempts__c + 1 >= Integer.valueOf(Web_Service_Settings__c.getValues('Max Retry').Value__c) ? false : true;
            }
                       
                       
            isSuccess = updateQuoteWSStatus(quote, quoteFieldToUpdate, response, lessThanMaxAttempt, retryAbleErrors.contains(response));

        }
        
        return isSuccess;
    }
    /*  *Description: update quote from other ws services
        *Author: Madhusudhan Seethala
        *Created: APR-01-2020
        *Param: quote - quote record to update
                quoteFieldToUpdate - response code received Schema.sObjectType.Quote__c.fields;
                wsStatus - less than max attempt not yet hit
                retryAbleResponse - response code is retryAble response 
                lessThanMaxAttempt - less than max attempt not yet hit
        *return: None. 
    */
    public static Boolean updateQuoteWSStatus(Quote__c quote, 
                                         Schema.DescribeFieldResult quoteFieldToUpdate, 
                                         String response, 
                                         Boolean retryAbleResponse, 
                                         Boolean lessThanMaxAttempt) {
        
        Boolean isSuccess = false;
        String status = '';
        
        if(response==GEN_OriginationsConstants.WSCODE_SUCCESS2) {
            status = GEN_OriginationsConstants.WS_STATUS_SENT;
            isSuccess = true;
        } else if(retryAbleResponse && lessThanMaxAttempt) {
            status = GEN_OriginationsConstants.WS_STATUS_RETRYPENDING;
        } else { //system unavailable or general error
            status = GEN_OriginationsConstants.WS_STATUS_FAILED;
        } 
        
        quote.put(quoteFieldToUpdate.getsObjectField(), status);
        update quote;
        
        return isSuccess;
        
    }
    
    
}