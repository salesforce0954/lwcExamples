/*
 * @Description: Visualforce controller for offline and online contract acceptance in customer UI
 * @Author: Adrian Recio
 * @Date Created: Feb-25-2016
 * @History:
   =====================================================================
       Adrian Recio      - Created
   =====================================================================
 */
global class APP_GSD_ContractAcceptanceChannel { 
    // Class Variable Declaration
    public static final String TOPIC_NAME = 'AppResponse';
    public ID applicationId {get; set;}
    public List<Related_Document__c> relDocList{get;set;} 
    public String contractAccntNumber {get; set;}
    public Boolean isTimeOut {get; set;}
    //public Boolean hasContract {get; set;}
    public String timeOutMessage {get; set;}
    public Boolean timeOutAccCreation {get; set;}
    public String relatedDocumentId {get;set;}
    public Boolean allAccepted {get;set;}
    public Boolean insuranceAcknowledgement {get;set;}
    public Boolean isInsuranceAcknowledmentRequired {get;set;}

    
    public String siteName {get;set;}
    public String validationFlag {get;set;}
    public String contractUrl {get;set;}
    public Boolean hasLife {get;set;}
    public Boolean hasDisability {get;set;}
    public Boolean hasIUI {get;set;}
    
    
    public String pdsFsgLink {get;set;} 
    public String brandName {get;set;}
    public Boolean isPrimary {get;set;}
    public Boolean allSecAccepted {get;set;}

    public string applicant1{get;set;}
    public string applicant2{get;set;}
    public string appType{get;set;}
    
    public String faxNumber {get;set;}
    public String contactNumber {get;set;}
    
    
    
    public ID isEnabledId {get;set;}
    
    public List<ContractWrapper> wrapperContract {get; set;}
    public List<Related_Document__c> Related_Document_List{get;set;}
    public string applicantJSONVar {get; set;}
    public string appJSONVar {get; set;}
    public string wrapConList {get; set;}
    
    /*  Description: Class Constructor
     *  Author: Adrian Recio
     *  Date Created: APR-11-2014
     */  
    public APP_GSD_ContractAcceptanceChannel(){
 
        // Pull current application Id
        applicationId = ApexPages.currentPage().getParameters().get('id');
        // Pull related documents
        Related_Document_List = getRelDocList(); 
        
        system.debug('Related Document Count:' + Related_Document_List.size());
       
        initApplicant();
        initApplication();
        
        // Pull existing contract number on load
        //displayContractNumber();
        
        checkInsuranceExist(); 
        insuranceSelectedCheck(); 
        
        //isAllAccepted(); 

        wrapperContract = pullWrapperContract();
        // JS Binding Variables
        wrapConList = String.escapeSingleQuotes(JSON.serialize(wrapperContract));
        appJSONVar = String.escapeSingleQuotes(JSON.serialize(applicationMain));
        applicantJSONVar = String.escapeSingleQuotes(JSON.serialize(applicantMain));
    }
    
    public Applicant__c applicantMain {get; set;}
    public void initApplicant(){
        /*
        system.debug('Current Email:' + UserInfo.getUserEmail());
        
            applicantMain     = [SELECT Id, 
                                        Email_Address__c, 
                                        Is_Primary_Applicant__c 
                                 FROM   Applicant__c 
                                 WHERE  Application__c =: applicationId
                                //AND   Is_Primary_Applicant__c = true 
                                 AND    Email_Address__c =: UserInfo.getUserEmail() limit 1];
            isPrimary = applicantMain.Is_Primary_Applicant__c;
        
        
        isPrimary = false;
        */

        List<Applicant__c>applicantMainTemp = [SELECT Id, 
                                                      Email_Address__c, 
                                                      Is_Primary_Applicant__c 
                                                      FROM   Applicant__c 
                                                      WHERE  Application__c =: applicationId];

           
        List<User> uList = [SELECT ID, Email__c, AppId__c FROM User WHERE Email =: UserInfo.getUserEmail()];
        
        for(Applicant__c app : applicantMainTemp){
            for(User u : uList){                
                if(u.Email__c == app.Email_Address__c && u.appId__c == applicationId){
                    applicantMain = app;
                    isPrimary = app.Is_Primary_Applicant__c;
                    break;
                }
            }
        }
    }
    public Application__c applicationMain {get; set;}
   
   //Added Brand_Lookup__r.Insurance_Disclosure_Statement__c in where clause  by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
    public void queryMainAppInfo(){
        applicationMain = [SELECT  Id, Brokerage_Fee__c, Application_Type__c, Submission_Status__c, Status__c, Response_Code__c, Insurance_Acknowledgement__c, 
                            Out_Of_Sync__c, Total_Loan_Amount__c, Total_Insurance_Premium__c, Offered_Establishment_Fee__c, Offered_PPSR_Registration_Fee__c, 
                            Offered_PPSR_Search_Fee__c, Total_Loan_Amount_with_Insurance__c, Loan_Term__c, Is_Accepted_Primary__c, Is_Accepted_Secondary__c, 
                            Loan_Term_Months__c, Offered_Interest_Rate__c, Acceptance_Channel__c, Brand_Lookup__r.Brand_Display_Name__c, Applicant_1_Name__c, 
                            Applicant_2_Name__c, Is_Insurance_Acknowledgement_Enabled__c, Is_Insurance_Acknowledgement_Enabled_2nd__c, Insurance_Acknowledgement_Secondary__c, 
                            Brand_Lookup__r.Country__c, Brand_String__c, Brand_Lookup__r.Fax_Number__c, Brand_Lookup__r.Contact_Number__c,
                            
                            Brand_Lookup__r.URL_Complaints_Brochure__c, Brand_Lookup__r.URL_Credit_Guide__c, 
                            Brand_Lookup__r.URL_Electronic_ID_Consent__c, Brand_Lookup__r.URL_LPI_Complaints_Brochure__c, 
                            Brand_Lookup__r.URL_Terms_Conditions__c, Brand_Lookup__r.Site__c, Brand_Lookup__r.URL_PDS_FSG__c,
                            Brand_Lookup__r.URL_Disclosure_Statement__c,Brand_Lookup__r.Insurance_Disclosure_Statement__c
                             
                    FROM    Application__c 
                    WHERE   Id =: applicationId limit 1];
    }

    public void initApplication(){
        queryMainAppInfo();
        insuranceAcknowledgement = applicationMain.Insurance_Acknowledgement__c;
        brandName = applicationMain.Brand_Lookup__r.Brand_Display_Name__c;
        faxNumber = applicationMain.Brand_Lookup__r.Fax_Number__c;
        contactNumber = applicationMain.Brand_Lookup__r.Contact_Number__c;
        applicant1 = applicationMain.Applicant_1_Name__c;
        applicant2 = applicationMain.Applicant_2_Name__c;
        appType = applicationMain.Application_type__c;
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
        String insuranceDisclosureStatement = DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT;
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getRelatedDocumentFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Related_Document__c where Application__c =: applicationId AND ((Document_Category__c =: category AND ';
        query += '(GE_Link_Type__c =: genLinkType OR GE_Link_Type__c =: staticLinkType)) OR (Document_Category__c =: internalCategory AND (Type__c =: disclosureStatement OR Type__c =: insuranceDisclosureStatement))) ';
        System.debug('related document query -->' + query); 
        return Database.query(query);
    }
    
   /*  Description: Pull contract number from response and set 
    *               contract flag to false if response code is FIA
    *  Author: Fel Saliba
    *  Date Created: JAN-3-2014
    */  
    /*
    public void displayContractNumber(){
        System.debug('## gettingContractNumber ');
        applicationId = ApexPages.currentPage().getParameters().get('id');
        List<Application_Response__c> appResp = [Select Id, Contract_Account_Number__c from Application_Response__c where 
                                                 Application__c = :applicationId and Response_Code__c = 'FIA'];
        for(Application_Response__c a : appResp){
            if(a.Contract_Account_Number__c != null){
                contractAccntNumber = a.Contract_Account_Number__c;
                hasContract = false;                
            }            
        }   
    }
    */
    
    /*  Description: Method to check if there is Insurance related Document.
     *  Author: Fel Saliba
     *  Date Created: 14-APR-2014
     *  Parameter 
     *  Return: Boolean
     */
    public void checkInsuranceExist(){
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
        isInsuranceAcknowledmentRequired = hasInsurance;
    }
    
    
    
     /* Description: 
      *  Author: Fel Saliba
      *  Date Created: June-19-2014
      */  
    public void insuranceSelectedCheck(){
       hasLife = false;
       hasDisability = false;
       hasIUI = false;
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
    
    
    
  
    
   
    
    /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public Boolean getIsRefresh(){
        Boolean isRefresh = false;
        //hasContract = false;
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
    public List<ContractWrapper> pullWrapperContract(){
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
        
        siteName = applicationMain.Brand_Lookup__r.Site__c;
        pdsFsgLink = applicationMain.Brand_Lookup__r.URL_PDS_FSG__c;
        
        List<ContractWrapper> wrapperContract = new List<ContractWrapper>();
        if(!relDocList.isEmpty()){
            String section = '';
            Integer ctr = 0;
            ContractWrapper cw = new ContractWrapper();
            for(Related_Document__c rd:relDocList){ 
                if(rd.GE_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC){
                    if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_TERMS_AND_CONDITIONS){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_Terms_Conditions__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_CREDIT_GUIDE){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_Credit_Guide__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_COMPLAINTS_BROCHURE){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_Complaints_Brochure__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_LPI_BROCHURE){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_LPI_Complaints_Brochure__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_EIDV_CONSENT){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_Electronic_ID_Consent__c+'?id='+applicationId;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_RPI_POLICY){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_PDS_FSG__c;
                    } else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.URL_Disclosure_Statement__c;
                    }
                    //Added by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
                    else if(rd.Type__c == DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT){
                      rd.AttachmentUrl__c = applicationMain.Brand_Lookup__r.Insurance_Disclosure_Statement__c;
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
    
    
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    /*
    public Boolean checkRD(){
        System.debug('***'+applicantMain.Is_Primary_Applicant__c);
        Boolean isNotCheck = false;
        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate.addAll(Related_Document_List);
        if(!relDocListValidate.isEmpty()){
            for(Related_Document__c rd:relDocListValidate){
                if(applicantMain.Is_Primary_Applicant__c){
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
        
        if(!isNotCheck && isInsuranceAcknowledmentRequired){
            Application__c app = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
            
            if(app != null){
                if(app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION && 
                   ((applicantMain.Is_Primary_Applicant__c && app.Insurance_Acknowledgement__c != isInsuranceAcknowledmentRequired) || 
                   (!applicantMain.Is_Primary_Applicant__c && app.Insurance_Acknowledgement_Secondary__c != isInsuranceAcknowledmentRequired))){
                    
                    isNotCheck = true;
                }
            }
        }     
        return isNotCheck;
    }   
    */

    
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
    /*
    public PageReference validateAppAndRD(){
        
        if(getLatestContractAccessStatus() == false){
            PageReference pgRef = Page.APP_Main_PostSubmit;
            pgRef.getParameters().put('id',applicationId);
            return pgRef;
        }
        
        Boolean hasInsurance = isInsuranceAcknowledmentRequired;    
        Boolean isNotCheck = checkRD(); 
        
        if(isNotCheck){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not all check-boxes have been selected.'));
            allAccepted = true;

        } else {
            
            Application__c app = new Application__c(); 
            app = applicationMain;
            
            if(!(app==null)){
                
                if(app.Brand_Lookup__r.Country__c == GEN_OriginationsConstants.AU_REGION && 
                   ((applicantMain.Is_Primary_Applicant__c && !app.Insurance_Acknowledgement__c && hasInsurance ||
                    !applicantMain.Is_Primary_Applicant__c && !app.Insurance_Acknowledgement_Secondary__c && hasInsurance))){
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not all check-boxes have been selected.'));    
                    allAccepted = true;

                } else {
                    return redirectToCompletePage();
                }
            }           
        }
        return null;
    }
    */
    
   

    

    // Public variables for validatio errors in doc gen
    public List<IS_ValidationError> validationErrors;
    public Boolean docGenFailed;

     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */ 
    /*
    public void isAllAccepted(){
        allAccepted = checkRD(); 
        if(Profile_country__c.getInstance(userinfo.getProfileId()).NZ__c==true){
            allSecAccepted=secCheckRD(); 
        }        
    }
    */
    
     /*  Description: 
     *  Author: Fel Saliba
     *  Date Created: JAN-3-2014
     */  
    public void isInsuranceAcknowledgement(){
        Application__c app = new Application__c(); 
        app = applicationMain;
        if(!(app==null)){
            insuranceAcknowledgement = app.Insurance_Acknowledgement__c;
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
                ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_ContractAcceptanceExt', 'Application__c', 'Class', String.valueOf(app.get(0).Id));    
                }
            }
        } 
    }
    
    public String getName() {        
        return topic_Name; 
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
    
    @RemoteAction
    global static void enableCheckboxRA(String relDocId, Boolean IsPrimary){
        if(relDocId!=null&&IsPrimary!=null){
            Related_Document__c rdVar = new Related_Document__c(Id=relDocId);
            if(IsPrimary==true){
                rdVar.isEnabled__c = true;
            }else{
                rdVar.isEnabled_Sec__c = true;
            }
            update rdVar;
        }
    }
        
    @RemoteAction
    global static void enableInsuranceCheckBoxRA(String appId, Boolean IsPrimary){
        if(appId!=null&&IsPrimary!=null){
            Application__c appVar = new Application__c(Id=appId);
            if(IsPrimary==true){
                appVar.Is_Insurance_Acknowledgement_Enabled__c = true;
            }else{
                appVar.Is_Insurance_Acknowledgement_Enabled_2nd__c = true;
            }
            update appVar;
        }
    }
    
     /*  Description: 
     *  Author: Vijay
     *  Date Created: MAR-2-2015
     */  
    /*
    public Boolean secCheckRD(){
        System.debug('***'+applicantMain.Is_Primary_Applicant__c);
        Boolean isNotCheck = false;
        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate = Related_Document_List;
        if(!relDocListValidate.isEmpty()){
            for(Related_Document__c rd:relDocListValidate){
                if(applicationMain.application_type__c=='Joint'){
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
    */

    // Online Redirect Button
    public PageReference updateAllRelatedDocument(){

        PageReference pgRef = Page.APP_Gsd_Response;
        pgRef.getParameters().put('id',applicationId);
        
        Boolean docUpdateFail = false;
        Boolean insuranceUpdateFail = false;

        // make sure that current access is still valid for user
        if(getLatestContractAccessStatus() == false){
            return pgRef;
        }
        
        // Refresh related documents
        Map<Id,Related_Document__c> relDocMapTemp = new Map<Id,Related_Document__c>();
        relDocMapTemp.putAll(getRelDocList());
        Set<Id> freshRelDocId = relDocMapTemp.keySet();
        Boolean RelIsRefreshed = false;

        for(Related_Document__c rd: Related_Document_List){
            if(freshRelDocId.contains(rd.Id)){
                Related_Document_List = relDocMapTemp.values();
                RelIsRefreshed = true;
                break;
            }
        }

        List<Related_Document__c> relDocListValidate = new List<Related_Document__c>();
        relDocListValidate.addAll(Related_Document_List);

        // Make sure related documents are refreshed to current version and is not empty
        // If not refreshed, documents might be outdated for the current view due to re-docgen
        if(!relDocListValidate.isEmpty() && RelIsRefreshed==true){
            
            for(Related_Document__c rd: relDocListValidate){            
                if(applicantMain.Is_Primary_Applicant__c){
                    rd.isEnabled__c = true;
                    rd.isAccepted__c = true;
                    rd.Who_Accepted__c = UserInfo.getName();
                    rd.When_Accepted__c = System.now();
                } else {
                    rd.isEnabled_Sec__c = true;
                    rd.isAcceptedSec__c = true;
                    rd.Who_Accepted_Sec__c = UserInfo.getName();
                    rd.When_Accepted_Sec__c = System.now();
                }
            }
            
            try{
                update relDocListValidate;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_ContractAcceptanceExt', 'Related_Document__c', 'Class', null);
                docUpdateFail = true;
            }
        }
        
        system.debug('Insurance flag:' + isInsuranceAcknowledmentRequired);
        system.debug('Is Primary:' + applicantMain.Is_Primary_Applicant__c);

        if(isInsuranceAcknowledmentRequired){
            // This will refresh app information incase 
            // another applicant update the application for Joint
            queryMainAppInfo(); 

            if(applicationMain != null){
                if(applicantMain.Is_Primary_Applicant__c){
                    applicationMain.Insurance_Acknowledgement__c = true;
                    applicationMain.Is_Insurance_Acknowledgement_Enabled__c = true;
                } else {
                    applicationMain.Insurance_Acknowledgement_Secondary__c = true;
                    applicationMain.Is_Insurance_Acknowledgement_Enabled_2nd__c = true;
                }
                   
                try{                
                    update applicationMain;
                    system.debug('App Updated:' + applicationMain);
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_ContractAcceptanceExt', 'Application__c', 'Class', String.valueOf(applicationMain.Id)); 
                    system.debug('App Failed:' + applicationMain);   
                    insuranceUpdateFail = true;
                }
            }
        }
        
        // Make sure related document update is successfull
        if(docUpdateFail==false && insuranceUpdateFail==false){
            return redirectToCompletePage();
        }else{
            return pgRef;
        }
    }


    // Offline Redirect button
    /*  Description: Method to redirect to complete page
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectToCompletePage(){

        // Refresh application
        queryMainAppInfo(); 

        if(!(applicationMain==null)){
            
            if(applicantMain.Is_Primary_Applicant__c){
                
               // Capture primary applicant's acceptance
                applicationMain.Is_Accepted_Primary__c = true;

                if(applicationMain.Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE && 
                   applicationMain.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){

                    applicationMain.Is_Accepted_Secondary__c = true;
                }

            } else {

                //Capture applicant 2's acceptance
                applicationMain.Is_Accepted_Secondary__c = true;
            }

            if(applicationMain.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE || 

               ((applicationMain.Acceptance_Channel__c == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE || 
                applicationMain.Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE) && 
                applicationMain.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT && 
                applicationMain.Is_Accepted_Primary__c && applicationMain.Is_Accepted_Secondary__c)){

                applicationMain.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PENDING_FIA;

            } else {
                
                if(applicantMain.Is_Primary_Applicant__c){
                    applicationMain.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2;
                }else{
                    applicationMain.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1;
                }
            }

            try {
                update applicationMain;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_GSD_ContractAcceptanceChannel', 'Application__c', 'Class', String.valueOf(applicationId));
            }

            //PageReference pgRef = Page.APP_Complete;
            PageReference pgRef = Page.app_gsd_response;
            pgRef.getParameters().put('Id', applicationId);
            pgRef.setRedirect(true);
            return pgRef;
        }
        return null;
    }

}