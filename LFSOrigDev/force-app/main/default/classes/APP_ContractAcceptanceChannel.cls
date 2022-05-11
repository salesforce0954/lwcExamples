/*
 * @Description: Controller for online and offline contract acceptance 
                 visualforce components used in sales and customer ui.
 * @Author: Fel Saliba
 * @Date Created: Feb-03-2014
 * @History:
   =====================================================================
       Fel      -  03-02-14: Created
       Adrian   -  04-02-14: Created redirectToCompletePage method
       2015-07-03 - Fix contact number display on contract acceptance page
   =====================================================================
 */
global class APP_ContractAcceptanceChannel {
    // Class Variable Declaration
    public static final String TOPIC_NAME = 'AppResponse';
    public ID applicationId {get; set;}
    public List<Related_Document__c> relDocList{get;set;} 
    public String contractAccntNumber {get; set;}
    public Boolean isTimeOut {get; set;}
    public Boolean hasContract {get; set;}
    public String timeOutMessage {get; set;}
    public Boolean timeOutAccCreation {get; set;}
    public String relatedDocumentId {get;set;}
    public Boolean allAccepted {get;set;}
    public Boolean insuranceAcknowledgement {get;set;}
    public Boolean isInsuranceAcknowledmentRequired {get;set;}
    public WS_FileUpload fileUploadClass{get; set;}
    public String siteName {get;set;}
    public String validationFlag {get;set;}
    public String contractUrl {get;set;}
    public Boolean hasLife {get;set;}
    public Boolean hasDisability {get;set;}
    public Boolean hasIUI {get;set;}
    public String timeoutSettings {get; set;} 
    public String pdsFsgLink {get;set;} 
    public String brandName {get;set;}
    public  Boolean isPrimary {get;set;}
    public Boolean allSecAccepted {get;set;}
    public List<Application__c> appList;
    public string applicant1{get;set;}
    public string applicant2{get;set;}
    public string appType{get;set;}
    public List<Related_Document__c> Related_Document_List{get;set;}
    public String faxNumber {get;set;}
    public String contactNumber {get;set;}
    // public List<ContractWrapper> wrapperContract{get;set;}
    public ID isEnabledId {get;set;}
    /*  Description: Class Constructor
     *  Author: Adrian Recio
     *  Date Created: APR-11-2014
     */  
    public APP_ContractAcceptanceChannel(){
      //  wrapperContract = new List<ContractWrapper>();
       applicationId = ApexPages.currentPage().getParameters().get('id');
        Web_Service_Settings__c sto =  Web_Service_Settings__c.getInstance('ResponseTimeOut');
        if(sto!=null) {
            timeoutSettings = sto.value__c;
        } else {
            timeoutSettings = '60'; //default 
        }
        contractUrl = '';
        // Instantiate file upload class
        fileUploadClass = new WS_FileUpload();
        fileUploadClass.applicationId = (ID)ApexPages.currentPage().getParameters().get('id');
        fileUploadClass.getApplicantOptions();
        Related_Document_List = getRelDocList(); 
       
        isPrimary = checkIfPrimary();
        // Pull existing contract number on load
        displayContractNumber();
        
        isAllAccepted();
        
        isInsuranceAcknowledmentRequired = checkInsuranceExist();
       
       
        hasLife = false;
        hasDisability = false;
        hasIUI = false;
        insuranceSelectedCheck();
    }
    
    public Boolean checkIfPrimary(){
        
        Boolean primary = false;
        appList = getApp();
        applicant1 = appList[0].Applicant_1_Name__c;
        applicant2 = appList[0].Applicant_2_Name__c;
        appType = appList[0].Application_type__c;

        //Map<Id,[Select Id,Is_Primary_Applicant__c from Applicant__c Where Application__c =: appList[0].Id AND Is_Primary_Applicant__c = true]> applicantMap = new Map<Id,Applicant__c>([Select Id,Is_Primary_Applicant__c from Applicant__c Where Application__c =: appList[0].Id AND Is_Primary_Applicant__c = true]);
       
        List<Applicant__c> applicant_List = [SELECT Id, 
                                                    Email_Address__c, 
                                                    Is_Primary_Applicant__c,
                                                    Application__c 
                                             FROM   Applicant__c 
                                             WHERE  Application__c =: appList[0].Id 
                                             AND    Is_Primary_Applicant__c = true];
       
        
        // Filtering done here rather than in SOQL as cannot filter by encrypted field
        for(Applicant__c app : applicant_List){
            System.debug('###Id created ' + app.Application__c + '@ge.com');
            if(String.ValueOf(UserInfo.getUserEmail()).toLowerCase().equals(String.ValueOf(app.Application__c).toLowerCase() + '@ge.com')){
                primary = true;
                break;
            }
        }
        system.debug('## User email address' + UserInfo.getUserEmail());
        system.debug('###Primary Applicant Flag ' + primary);
        return primary;
    }

     /* Description: 
      *  Author: Fel Saliba
      *  Date Created: June-19-2014
      */  
    public void insuranceSelectedCheck(){
       String query = 'SELECT ';
       String appId = applicationId;
       List<Product_Item__c> prodItems = new List<Product_Item__c>();
       for(Schema.FieldSetMember f : SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields()) {
           query += f.getFieldPath() + ', ';
       }
       query += 'Id, Product_Version__r.GEProduct__c, Product_Version__r.Product_Name__c FROM Product_Item__c where Application__c =: appId and Product_Version__c != null';
       prodItems =  Database.query(query); 
       
       if(prodItems.size()>0){
           for(Product_Item__c prodItem: prodItems){
               if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                   hasLife = true;
               }
               else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                   hasDisability = true;    
               }
               else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                   hasIUI = true;
               }
           }
       }      
    }
    
     /* Description: 
      *  Author: Fel Saliba
      *  Date Created: JAN-3-2014
      */  
    public String getTextDisplayed(){
    
        allAccepted = checkRD();
        //if(Profile_country__c.getInstance(userinfo.getProfileId()).NZ__c==true){
            allSecAccepted=secCheckRD();
        //}
        String appType = '';
        if(applicationId != null){
            List<Application__c> app = new List<Application__c>(); 
            app = getApp();
            if(!app.isEmpty()){
                if(app[0].Application_Type__c == 'Single'){
                    appType = 'The Customer has been given a copy of the'; 
                }
                else{
                    appType = 'The Customers have been given a copy of the'; 
                }
            }
        }
        return appType;
    }
    
   /*  Description: 
    *  Author: Fel Saliba
    *  Date Created: JAN-3-2014
    */  
    public List<String> getApplicationInsurance(){
        List<Product_Item__c> productItems = [SELECT    Product_Version__r.Product_Name__c 
                                              FROM      Product_Item__c 
                                              WHERE     Application__c =: applicationId
                                              AND       Product_Version__r.Type__c = 'Insurance'];
        List<String> insuranceList = new List<String>();
        Integer i = 0;
        
        if(!productItems.isEmpty()){
            for(Product_Item__c p: productItems){
                i++;
                if(i == productItems.size()){
                    insuranceList.add(String.valueOf(p.Product_Version__r.Product_Name__c));
                } else {
                    insuranceList.add(String.valueOf(p.Product_Version__r.Product_Name__c)+', ');
                }
            }
        }
        return insuranceList;
    }
    
    /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public List<Application__c> getApp(){
        System.debug('***applicationId:'+applicationId);
        List<Application__c> appList1 =  new List<Application__c>();
        appList1 = [SELECT  Id, Brokerage_Fee__c, Application_Type__c, Submission_Status__c, Status__c, Response_Code__c, Insurance_Acknowledgement__c, 
                            Out_Of_Sync__c, Total_Loan_Amount__c, Total_Insurance_Premium__c, Offered_Establishment_Fee__c, Offered_PPSR_Registration_Fee__c, 
                            Offered_PPSR_Search_Fee__c, Total_Loan_Amount_with_Insurance__c, Loan_Term__c, Is_Accepted_Primary__c, Is_Accepted_Secondary__c, 
                            Loan_Term_Months__c, Offered_Interest_Rate__c, Acceptance_Channel__c, Brand_Lookup__r.Brand_Display_Name__c, Applicant_1_Name__c, 
                            Applicant_2_Name__c, Is_Insurance_Acknowledgement_Enabled__c, Is_Insurance_Acknowledgement_Enabled_2nd__c, Insurance_Acknowledgement_Secondary__c, 
                            Brand_Lookup__r.Country__c, Brand_String__c, Brand_Lookup__r.Fax_Number__c, Brand_Lookup__r.Contact_Number__c 
                    FROM    Application__c 
                    WHERE   Id =: applicationId];
        
        system.debug('Application Id:' + applicationId);
        system.debug('app count:' + appList1.size());
        insuranceAcknowledgement = appList1[0].Insurance_Acknowledgement__c;
        brandName = appList1[0].Brand_Lookup__r.Brand_Display_Name__c;
        faxNumber = appList1[0].Brand_Lookup__r.Fax_Number__c;
        contactNumber = appList1[0].Brand_Lookup__r.Contact_Number__c;
        return appList1;
    }
    
    /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public Boolean getIsRefresh(){
        Boolean isRefresh = false;
        hasContract = false;
        relDocList = Related_Document_List;
        system.debug('has passed');
        if(!relDocList.isEmpty()){
            for(Related_Document__c rd:relDocList){
                if(rd.Status__c != 'Received'){
                    isRefresh = true;
                }
            }
        }
        return isRefresh;
    }
    


    /*  Description: 
     *  Auapplicationid
     */  
    public List<ContractWrapper> getWrapperContract(){
        
        relDocList = Related_Document_List;
        Map<String,String> attachMap = new Map<String,String>();
        Set<String> relatedIdSet = new Set<String>();        
        if(!relDocList.isEmpty()){
            for(Related_Document__c rd:relDocList){
                relatedIdSet.add(rd.Id);
            }
            
            List<Attachment> attachList = new List<Attachment>();
            attachList = [Select Id, ParentId from Attachment Where ParentId IN:relatedIdSet Order by CreatedDate desc];
            
            for(Attachment attach:attachList){
                if(!attachMap.containsKey(attach.ParentId)){
                    attachMap.put(attach.ParentId,attach.Id);
                }   
            }
        }       
         //Added Brand_Lookup__r.Insurance_Disclosure_Statement__c in where clause  by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017

        Application__C app = [SELECT    Brand_Lookup__r.URL_Complaints_Brochure__c, Brand_Lookup__r.URL_Credit_Guide__c, 
                                        Brand_Lookup__r.URL_Electronic_ID_Consent__c, Brand_Lookup__r.URL_LPI_Complaints_Brochure__c, 
                                        Brand_Lookup__r.URL_Terms_Conditions__c, Brand_Lookup__r.Site__c, Brand_Lookup__r.URL_PDS_FSG__c,
                                        Brand_Lookup__r.URL_Disclosure_Statement__c,Brand_Lookup__r.Insurance_Disclosure_Statement__c
                              FROM      Application__c
                              WHERE     Id =: applicationId LIMIT 1];

        siteName = app.Brand_Lookup__r.Site__c;
        pdsFsgLink = app.Brand_Lookup__r.URL_PDS_FSG__c;
        
        List<ContractWrapper> wrapperContract = new List<ContractWrapper>();
        if(!relDocList.isEmpty()){
            String section = '';
            Integer ctr = 0;
            ContractWrapper cw = new ContractWrapper();
            for(Related_Document__c rd:relDocList){ 
                if(rd.GE_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC){
                    if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_TERMS_AND_CONDITIONS){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_Terms_Conditions__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_CREDIT_GUIDE){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_Credit_Guide__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_COMPLAINTS_BROCHURE){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_Complaints_Brochure__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_LPI_BROCHURE){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_LPI_Complaints_Brochure__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_EIDV_CONSENT){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_Electronic_ID_Consent__c+'?id='+applicationId;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_RPI_POLICY){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_PDS_FSG__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.URL_Disclosure_Statement__c;
                    }
                   //Added  by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
                    else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT){
                      rd.AttachmentUrl__c = app.Brand_Lookup__r.Insurance_Disclosure_Statement__c;
                    }
                }
                else{
                    DocumentLinkEndpoints__c dle = DocumentLinkEndpoints__c.getInstance();                
                    rd.AttachmentUrl__c = dle.AttachmentUrl__c+attachMap.get(rd.Id);
                    if(rd.Section__c == 'Contract'){
                       contractUrl = rd.AttachmentUrl__c; 
                    }
                }                                          
                if(section == ''){
                   cw = new ContractWrapper(); 
                   cw.title =  rd.Section__c;
                   cw.relDoc.add(rd);
                   section = rd.Section__c;
                }
                else{                    
                    if(rd.Section__c== section){
                        cw.relDoc.add(rd);
                    }
                    else if(rd.Section__c != section){
                       wrapperContract.add(cw);
                       cw = new ContractWrapper(); 
                       cw.title =  rd.Section__c;
                       cw.relDoc.add(rd);                                                                          
                       section = rd.Section__c;
                                          
                    }                   
               }
               if(ctr == relDocList.size()-1){
                        wrapperContract.add(cw);
               }                
               ctr++;                                                              
            }
        }
        return wrapperContract;
    }
    /*  Description: Method to get Related Document fields to use in query.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: List<Schema.FieldSetMember>
     */
    public List<Schema.FieldSetMember> getRelatedDocumentFields() {
        return SObjectType.Related_Document__c.FieldSets.Income_Document_Commons.getFields();
    }
    
    /*  Description: Method to get List of Related Documents related to the Application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: List<Liability__c>
     */
    public List<Related_Document__c> getRelDocList() {
        String category = GEN_OriginationsConstants.LOAN_DOCUMENTS; 
        String genLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED;
        String staticLinkType = DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC;
        String internalCategory = GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL;
        String disclosureStatement = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT;
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getRelatedDocumentFields()) {
            query += f.getFieldPath() + ', ';
        }
        //query += 'Id FROM Related_Document__c where Document_Category__c =: category AND Application__c =: applicationId AND (GE_Link_Type__c =: genLinkType  OR GE_Link_Type__c =: staticLinkType) Order by CreatedDate desc'; //Section__c asc';
        query += 'Id FROM Related_Document__c where Application__c =: applicationId AND ((Document_Category__c =: category AND ';
        query += '(GE_Link_Type__c =: genLinkType OR GE_Link_Type__c =: staticLinkType)) OR (Document_Category__c =: internalCategory AND Type__c =: disclosureStatement)) ';
        System.debug('query-->'+query); 
        return Database.query(query);
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public Boolean checkRD(){
        System.debug('***'+isPrimary);
        Boolean isNotCheck = false;
        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate.addAll(Related_Document_List);
        if(!relDocListValidate.isEmpty()){
            for(Related_Document__c rd:relDocListValidate){
                if(isPrimary){
                    if(rd.isAccepted__c == false){
                        isNotCheck = true;}
                } else {
                    if(rd.isAcceptedSec__c == false){
                        isNotCheck = true;
                    }
                }
                system.debug('rdtestVal' + rd.Id + rd.isAccepted__c);
            }
        }
        
        if(!isNotCheck && checkInsuranceExist()){
            Application__c app = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
            
            if(app != null){
                if(app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION && 
                   ((isPrimary && app.Insurance_Acknowledgement__c != isInsuranceAcknowledmentRequired) || 
                   (!isPrimary && app.Insurance_Acknowledgement_Secondary__c != isInsuranceAcknowledmentRequired))){
                    
                    isNotCheck = true;
                }
            }
        }     
        return isNotCheck;
    }   

    
    /*  Description: Getter method to pull response code access to create account
     *   Author: Adrian Recio
     *   Date Created: 09-Apr-2014
     *   Input Parameters: Na
     *   Return: Boolean
     */    
    public boolean getRCCreateAccess(String rCode){
        Response_Code_Control__c rCC = Response_Code_Control__c.getValues(rCode);
        Boolean enableCreateAccount = true;
        
        if(rCC!=null){
            enableCreateAccount = rCC.Create_Account__c;
        }
                
        return enableCreateAccount;
    }
    
    /*  Description: Getter method to pull profile access to create account
     *   Author: Adrian Recio
     *   Date Created: 09-Apr-2014
     *   Input Parameters: Na
     *   Return: Boolean
     */    
    public boolean getProfileAccess(Id profileId){
        Profile_Control__c pcCS = Profile_Control__c.getInstance(profileId);
        Boolean hasAccess = true;
        if(pcCS!=null){
            hasAccess = pcCS.Create_Account__c;
        }
        return hasAccess;
    }
    
    
    
    /*  Description: Method that checks access of user to accept 
                     contract based on response code and submission status
     *  Author: Adrian Recio
     *  Date Created: 10-APR-2014
     *  Input Parameters: Na
     *  Return: Boolean
     */
    public Boolean getLatestContractAccessStatus(){
        
        Application__c appVar = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
        
        // Access Variable
        Boolean hasContractAccess = false;
                                 
        // Pull Access settings
        Boolean hasCreateAccountAccess = getRCCreateAccess(appVar.Response_Code__c);
        Boolean hasProfileAccess = getProfileAccess(UserInfo.getProfileId());

        //Enable access if:
        //1. Response Code = PCO
        //2. Application Type = Joint and Acceptance Channel != null
             //2.1 Response Code = PCO Applicant 1 Pending or PCO Applicant 2 Pending
        if(appVar.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA || 
           (appVar.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT && 
            appVar.Acceptance_Channel__c != null && 
            (appVar.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1 || 
             appVar.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2))){
            
            hasContractAccess = true;
        }   

        //Enable access if:
        //3. Response Code = Pending FIA
            //3.1 Acceptance Channel != null or Submission Status = Service Unavailable
        if(Userinfo.getUserType() != 'CspLitePortal' && 
           hasCreateAccountAccess && 
           hasProfileAccess && 
           (appVar.Submission_Status__c == GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SERVICE_UNAVAILABLE || 
            //appVar.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE)){
            appVar.Acceptance_Channel__c != null)){
                
            hasContractAccess = true;
        }
        return hasContractAccess;
    }

     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public PageReference validateRD(){
        system.debug('On Create Account:' + getLatestContractAccessStatus());
        if(getLatestContractAccessStatus() == false){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Account is already created.'));
            return null;
        }
        
        System.debug('#### Validate RD');
        timeOutMessage = null;
        Boolean isNotCheck = secCheckRD(); 
        hasContract = true;
        if(isNotCheck){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not all check-boxes have been selected.'));
            allAccepted = true;
        }
        else{
            //call Accept Contract Web Service.
            return acceptContract();
        }
        return null;
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public PageReference validateAppAndRD(){
        
        if(getLatestContractAccessStatus() == false){
            PageReference pgRef = Page.APP_Main_PostSubmit;
            pgRef.getParameters().put('id',applicationId);
            return pgRef;
        }
        
        Boolean hasInsurance = checkInsuranceExist();    
        Boolean isNotCheck = checkRD(); 
        
        if(isNotCheck){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not all check-boxes have been selected.'));
            allAccepted = true;

        } else {
            
            List<Application__c> app = new List<Application__c>(); 
            app = getApp();
            
            if(!app.isEmpty()){
                
                if(app.get(0).Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION && 
                   ((isPrimary && !app.get(0).Insurance_Acknowledgement__c && hasInsurance ||
                    !isPrimary && !app.get(0).Insurance_Acknowledgement_Secondary__c && hasInsurance))){
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not all check-boxes have been selected.'));    
                    allAccepted = true;

                } else {
                    return redirectToCompletePage();
                }
            }           
        }
        return null;
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public PageReference acceptContract(){
         try{
            checkPushTopic();

            if(Userinfo.getUserType()=='CspLitePortal'){
                return redirectToCompletePage();
            } else {
                List<IS_ValidationError> validationErrors = IS_AcceptContract.acceptContractRequest(applicationId, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                validationFlag = 'true';

                if(!validationErrors.isEmpty()){
                    //validation failed    
                    validationFlag = 'false';            
                    
                    for(IS_ValidationError i: validationErrors){
                      Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
                    }
                }
                return null;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
            return null;   
        }
    }

     /*  Description: Method to send a related Document in a Webservice Call out individually
     *  Author: Fel Saliba
     *  Date Created: 25-Feb-2014
     *  Input Parameters: NONE
     *  Return: PageReference
     */
    /*
    public PageReference retryRelatedDocument(){

         try{
            List<IS_ValidationError> validationErrors = IS_GenerateDocument.generateDocumentRequest(applicationId, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId,null); 
            
            if(validationErrors.isEmpty()){
                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('id', String.valueOf(applicationId));
                pageRef.getParameters().put('tab', 'contractTab');
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                //validation failed
            
                //TODO: iterate through the errors and display properly
                //Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: ' + validationErrors);
                for(IS_ValidationError i: validationErrors){
                  Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
                }
                return null;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    */

    // Public variables for validatio errors in doc gen
    public List<IS_ValidationError> validationErrors;
    public Boolean docGenFailed;

    /*  Description: Method to send a related Document for validation if its ready for a  retry
     *  Author: Fel Saliba
     *  Date Created: 19-Feb-2014
     *  Input Parameters: NONE
     *  Return: PageReference
     */
    public void retryRelatedDocument(){
       this.validationErrors = new List<IS_ValidationError>();
       this.docGenFailed = false;
       relatedDocumentId = ApexPages.currentPage().getParameters().get('relatedDocumentId');

        try{
            System.debug('relatedDocumentId-->'+relatedDocumentId);
            this.validationErrors = IS_GenerateDocument.generateDocumentRequest(applicationId, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId,null); 
            system.debug('val1:' + this.validationErrors);
        }catch(Exception e){
            this.docGenFailed = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
        }
    }

    /* Description: Second layer method to fire synchronous web service 
                    callout after a dml in acceptOffer Method.
     *  Author: Adrian Recio
     *  Date Created: 09-22-2015
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference fireDocGenServiceCallRetry(){
        System.debug('relatedDocumentId-->'+this.relatedDocumentId);
        system.debug('val2:' + this.validationErrors);
      if(this.validationErrors.isEmpty() && this.docGenFailed==false){
            try{
                // Call sync webservice to perform doc gen        
                IS_GenerateDocument.generateDocumentRequest(applicationId, Util.getUser().Mock_Enable__c,  Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
                return null;
            }
            PageReference pageRef = Page.APP_ApplicationMain_INT;
            pageRef.getParameters().put('id', String.valueOf(applicationId));
            pageRef.getParameters().put('tab', 'contractTab');
            pageRef.setRedirect(true);
            return pageRef;
      }else{
            for(IS_ValidationError i: this.validationErrors){
              Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
            }
            return null;
       }
    }

     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public void isAllAccepted(){
        allAccepted = checkRD();
        //if(Profile_country__c.getInstance(userinfo.getProfileId()).NZ__c==true){
            allSecAccepted=secCheckRD();
        //}        
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public void isInsuranceAcknowledgement(){
        List<Application__c> app = new List<Application__c>(); 
        app = getApp();
        if(!app.isEmpty()){
            insuranceAcknowledgement = app[0].Insurance_Acknowledgement__c;
        }      
    }

     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public void isTimeOutAccountCreation(){
        timeOutAccCreation = true;        
    }

     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public void displayContractNumber(){
        System.debug('## gettingContractNumber ');
        applicationId = ApexPages.currentPage().getParameters().get('id');
        List<Application_Response__c> appResp = [Select Id, Contract_Account_Number__c from Application_Response__c where Application__c = :applicationId and Response_Code__c = 'FIA'];
        for(Application_Response__c a : appResp){
            if(a.Contract_Account_Number__c != null){
                contractAccntNumber = a.Contract_Account_Number__c;
                hasContract = false;                
                //timeOutAccCreation = false;
            }            
        }   
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public PageReference refreshPage(){
        
        PageReference pageRef = new PageReference('/apex/APP_ApplicationMain_INT?id='+applicationId+'&tab=contractTab');
        pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('id', String.valueOf(applicationId)); 
        pageRef.getParameters().put('tab', 'contractTab');       
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    
    /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    @RemoteAction 
    global static void updateRelatedDocument1(String relatedDocumentId, Boolean isCheck,String fieldName) {
        if(relatedDocumentId != null){
        
            Related_Document__c rd = [SELECT    Id, 
                                                isAccepted__c, 
                                                isAcceptedSec__c, 
                                                When_Accepted__c, 
                                                Who_Accepted__c
                                      FROM      Related_Document__c 
                                      WHERE     Id =: relatedDocumentId];
      
            if(fieldName=='isAcceptedSec'){
                rd.isAcceptedSec__c  = isCheck;
            } else {
                rd.isAccepted__c = isCheck;
            }
            if(isCheck == true){
                rd.When_Accepted__c = System.now();
                rd.Who_Accepted__c = UserInfo.getName();
            } else {
                rd.When_Accepted__c = null;
                rd.Who_Accepted__c = null;
            }
            
            try{
                
                update rd;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceExt', 'Related_Document__c', 'Class', null);
            }            
        }   
    }
    /*
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    @RemoteAction 
    global static void updateRelatedDocument(String relatedDocumentId, Boolean isCheck){

        if(relatedDocumentId != null){
            
            Related_Document__c rd = [SELECT Id, 
                                                Application__c, 
                                             isAccepted__c, 
                                                isAcceptedSec__c, 
                                             When_Accepted__c, 
                                             Who_Accepted_Sec__c, 
                                             Who_Accepted__c, 
                                             When_Accepted_Sec__c
                                      FROM  Related_Document__c 
                                      WHERE Id =: relatedDocumentId];
            
      


            List<Applicant__c> applicantList = [SELECT Id, 
                                                    Is_Primary_Applicant__c, 
                                                    Email_Address__c 
                                             FROM   Applicant__c 
                                             WHERE  Application__c =: rd.Application__c];

            if(!applicantList.isEmpty()){
                
                Boolean isPrimary = false;
                
                for(Applicant__c a: applicantList){
                    if(a.Email_Address__c == UserInfo.getUserEmail() && 
                       a.Is_Primary_Applicant__c){

                        isPrimary = true;
                        break;
                    }
                }

                if(isPrimary){
                    rd.isAccepted__c = isCheck;
                } else {
                    rd.isAcceptedSec__c = isCheck;
                }

                if(isCheck){
                    if(isPrimary){
                        rd.Who_Accepted__c = UserInfo.getName();
                        rd.When_Accepted__c = System.now();
                    } else {
                        rd.Who_Accepted_Sec__c = UserInfo.getName();
                        rd.When_Accepted_Sec__c = System.now();
                    }
                } else {
                    if(isPrimary){
                        rd.When_Accepted__c = null;
                        rd.Who_Accepted__c = null;
                    } else {
                        rd.Who_Accepted_Sec__c = null;
                        rd.When_Accepted_Sec__c = null;
                    }
                }
                
                try{
                    update rd;
                    //System.debug('***'+rd.isAccepted__c);
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceExt', 'Related_Document__c', 'Class', null);
                }
            }
        }       
    }
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    @RemoteAction 
    global static void updateApplication(String appId, Boolean isCheck) { 
        
        List<Application__c> app = new List<Application__c>(); 
        
        app = [SELECT Id FROM Application__c WHERE Id =: appId];
        
        if(!app.isEmpty()){
            List<Applicant__c> applicantList = [SELECT Id, 
                                                       Is_Primary_Applicant__c, 
                                                       Email_Address__c 
                                                FROM   Applicant__c 
                                                WHERE  Application__c =: appId];
            if(!applicantList.isEmpty()){
                Boolean isPrimary = false;
                for(Applicant__c a: applicantList){
                    if(a.Email_Address__c == UserInfo.getUserEmail() && 
                       a.Is_Primary_Applicant__c){
                        isPrimary = true;
                        break;
                    }
                }
                if(isPrimary){
            app[0].Insurance_Acknowledgement__c = isCheck;
                } else {
                    app[0].Insurance_Acknowledgement_Secondary__c = isCheck;
                }
                   
            try{                
                update app;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceExt', 'Application__c', 'Class', String.valueOf(app.get(0).Id));    
                }
            }
        } 
    }
    
    public String getName() {        
        return topic_Name; 
    }  
    

    /*  Description: Method to insert into Push Topic 
     *  Author: Jan Mark Domingo
     *  Date Created: SEPT-19-2013
     *  Input: None     
     */
    public void checkPushTopic(){ 
        try{    
            //check if the push topic already exists            
            List<PushTopic> topics = [SELECT id, name, query FROM PushTopic WHERE name =: TOPIC_NAME];                        
            //if not create it
            if(topics.size()==0) {
                PushTopic pushTopic = new PushTopic();
                pushTopic.Name = topic_Name;                
                pushTopic.Query = 'SELECT Id, Contract_Account_Number__c, Application__c FROM Application_Response__c';
                pushTopic.ApiVersion = 29.0;
                //pushTopic.NotifyForOperationCreate = true;
                //pushTopic.NotifyForOperationUpdate = false;
                //pushTopic.NotifyForOperationUndelete = false;
                //pushTopic.NotifyForOperationDelete = false;
                pushTopic.NotifyForFields = 'Referenced';                
                insert pushTopic;
            }
        }catch(Exception e){
            system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'checkPushTopic', 'APP_WaitPageController', 'Class', 
                String.valueOf(fileUploadClass.applicationId));
            
        }
    }

    /*  Description: Method to redirect to complete page
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectToCompletePage(){
        List<Application__c> app = new List<Application__c>();

        app = getApp();

        if(!app.isEmpty()){
            
            if(isPrimary){
                
               // Capture primary applicant's acceptance
                app[0].Is_Accepted_Primary__c = true;

                if(app.get(0).Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE && 
                   app.get(0).Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){

                    app[0].Is_Accepted_Secondary__c = true;
                }

            } else {

                //Capture applicant 2's acceptance
                app[0].Is_Accepted_Secondary__c = true;
            }

            if(app.get(0).Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE || 
               app.get(0).Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE || 
               (app.get(0).Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE && 
                app.get(0).Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT && 
                app.get(0).Is_Accepted_Primary__c && 
                app.get(0).Is_Accepted_Secondary__c)){

                app.get(0).Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PENDING_FIA;

            } else {
                
                app.get(0).Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2;
                
                if(!isPrimary){
                    app.get(0).Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1;
                }
            }

            try {
                update app;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceChannel', 'Application__c', 'Class', String.valueOf(fileUploadClass.applicationId));
            }

            PageReference pgRef = Page.APP_Complete;
            pgRef.getParameters().put('Id', fileUploadClass.applicationId);
            pgRef.setRedirect(true);
            return pgRef;
        }
        return null;
    }
    
    /*  Description: Method to check if there is Insurance related Document.
     *  Author: Fel Saliba
     *  Date Created: 14-APR-2014
     *  Parameter 
     *  Return: Boolean
     */
    public Boolean checkInsuranceExist(){
        Boolean hasInsurance = false;
        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate = Related_Document_List;
        if(!relDocListValidate.isEmpty()){
            for(Related_Document__c rd:relDocListValidate){
                //check if related document section is equal to Insurance.
                if(rd.Section__c == DOC_GenerateDocumentsUtil.SECTION_INSURANCE){
                    hasInsurance = true;
                }
            }
        }                
        return hasInsurance;
    }
    
    //===============================================================
    //                    INNER CLASSES / WRAPPERS
    //===============================================================
    
    /*  Description: Wrapper class for the Related Document object
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */
     
    public class ContractWrapper {
    
    public String title{get;set;}
        public Boolean isEnabled{get;set;}
    public List<Related_Document__c> relDoc {get; set;}
    
        /* Description: Wrapper constructor.
         *  Author: Fel Saliba
         *  Date Created: JAN-3-2014
         *  Input Parameters: None
         *  Return: N/A
         */
        public ContractWrapper(){ 
            title = '';
            relDoc = new List<Related_Document__c>();
        }
    }
    
    /*  Description: Update checkbox that enables in the customet Ui
     *  Author: Keerthan
     *  Date Created: MAR-2-2015
     */ 
    public void enableCheckbox(){
        
     // System.debug('**CW:'+wrapperContract.size());
      System.debug('**CW:'+isEnabledId+'**'+Related_Document_List);
      List<Related_Document__c> updateRD = new List<Related_Document__c> ();
        for(Related_Document__c rd : Related_Document_List){
      rd.AttachmentUrl__c = (rd.GE_Link_Type__c == 'Static') ? rd.AttachmentUrl__c : '';
      System.debug('****rd.Id:'+rd.AttachmentUrl__c);
            if(String.valueOf(rd.Id).equals(String.valueOf(isEnabledId))){
            System.debug('checkIfPrimary:'+checkIfPrimary());
                if(checkIfPrimary()){
              rd.isEnabled__c = true;
              
                } else {
                rd.isEnabled_Sec__c = true;
             }
              updateRD.add(rd);
          }
      }
        
       if(!updateRD.isEmpty())
       update updateRD;
       // wrapperContract.clear();
       // wrapperContract = getWrapperContract();
    }
    public void enableInsuranceCheckBox(){
        
        Application__c appVar = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
        if(appVar != null){
            if(isPrimary){
                appVar.Is_Insurance_Acknowledgement_Enabled__c = true;
            } else {
                appVar.Is_Insurance_Acknowledgement_Enabled_2nd__c = true;
    }
    
            try {
                update appVar;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceChannel', 'Application__c', 'Class', String.valueOf(fileUploadClass.applicationId));
            }
        }
    }
    
     /*  Description: 
     *  Author: Vijay
     *  Date Created: MAR-2-2015
     */  
    public Boolean secCheckRD(){
        System.debug('***'+isPrimary);
        Boolean isNotCheck = false;
        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate = Related_Document_List;
        if(!relDocListValidate.isEmpty()){
            for(Related_Document__c rd:relDocListValidate){
                if(appList[0].application_type__c=='Joint'){
                    if(rd.isAccepted__c == false || rd.isAcceptedSec__c == false){
                        isNotCheck = true;
                        
                    }
                }else{
                    if(rd.isAccepted__c == false){
                        isNotCheck = true;
                    }
                }
            }
        }                
        return isNotCheck;
    }

    public PageReference updateAllRelatedDocument(){

        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate.addAll(Related_Document_List);

        if(!relDocListValidate.isEmpty()){
            
            for(Related_Document__c rd: relDocListValidate){
                if(isPrimary){
                    rd.isAccepted__c = true;
                    rd.Who_Accepted__c = UserInfo.getName();
                    rd.When_Accepted__c = System.now();
                } else {
                    rd.isAcceptedSec__c = true;
                    rd.Who_Accepted_Sec__c = UserInfo.getName();
                    rd.When_Accepted_Sec__c = System.now();
                }
            }
            
            try{
                update relDocListValidate;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceExt', 'Related_Document__c', 'Class', null);
            }
        }
        
        if(checkInsuranceExist()){
            Application__c app = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
            
            if(app != null){
                if(isPrimary){
                    app.Insurance_Acknowledgement__c = true;
                } else {
                    app.Insurance_Acknowledgement_Secondary__c = true;
                }
                   
            try{                
                update app;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ContractAcceptanceExt', 'Application__c', 'Class', String.valueOf(app.Id));    
                }
            }
        }
        return validateAppAndRD();
    }
}