/*
 * @Description: Controller for Document Tab for Staff UI
 * @Author: Campbell McKay
 * @Date Created: 
 * @History:
   =====================================================================
               : Created - Campbell
       12:11:14: Added Mass Edit Functionality and URL link retrieval from GE System    
       7:5:2015: Update - Adrian Recio, Removed display of static documents  
       7:5:2015: Update - Adrian Recio, Added applicant selection picklist methods for applicant editing in documents section    
   =====================================================================
 */
public class APP_Documents_EXT_INT extends APP_CommonExt {

    public List<RelatedDocumentWrapper> relatedDocumentWrapperListLoan {get;set;}
    public List<RelatedDocumentWrapper> relatedDocumentWrapperListNotLoan {get;set;}
    public String relatedDocumentId {get;set;}
    transient public String successCode {get;set;}
    transient public String retryableCode {get;set;}
    public Boolean showDocs {get;set;}
    
    transient public Boolean editDocumentButton {get;set;}
    transient public Boolean newEditDocument {get;set;}
    
    //Added by vijay DBHZL-200
    public string applicationChannel;
    public boolean insuranceConsent;
    public boolean plIDVForm;
    public string responseCode;
    
    public APP_Documents_EXT_INT(ApexPages.StandardController applicationController) {
        super(applicationController);
        application__c application=[select channel__c,Loan_Insurance_Consent__c,personal_loan_form_IDV__c,response_code__c from application__c where id=:applicationController.getRecord().id];
        applicationChannel=application.channel__c;
        insuranceConsent=application.Loan_Insurance_Consent__c;
        plIDVForm=application.personal_loan_form_IDV__c;
        responseCode=application.response_code__c;
        getRelatedDocuments(); 
        relatedDocumentId = '';
        newEditDocument = buttonControl();
        successCode = GEN_OriginationsConstants.WSCODE_DOCGEN_SUCCESS;
        retryableCode = GEN_OriginationsConstants.WSCODE_DOCGEN_RETRYABLE;
        showDocs = true;
    }
    
    public void getRelatedDocuments(){

        //Retrieve existing documents of an application
        this.relatedDocumentWrapperListLoan = new List<RelatedDocumentWrapper>();
        this.relatedDocumentWrapperListNotLoan = new List<RelatedDocumentWrapper>();
        
        List<Related_Document__c> relatedDocs = GEN_RecordRetrievalUtility.retrieveApplicationRelatedDocuments(this.application.Id);
        //store all "generated document" ids in the set
        Map<Id, String> documentLinkMap = GEN_RelatedDocumentUtility.getDocumentURL(relatedDocs);
        map<string,id>docIdmap=new map<string,id>();
        
        for(document d:[select id,DeveloperName from document where DeveloperName IN:GEN_OriginationsConstants.DOCUMENTNAMES]){
            if(GEN_OriginationsConstants.DOCUMENTNAMES.contains(d.DeveloperName)){
                docIdmap.put(d.DeveloperName,d.id);
            }
        }
        
        boolean hasLifeInsurance=false;
        boolean hasDisabilityInsurance=false;
        List<Product_Item__c> prodItemList=[select id,Product_Version__r.Product_Name__c from Product_Item__c where Application__c=:this.application.id];
        if(prodItemList!= null){
            if(prodItemList.size()>0){
                for(Product_Item__c prod:prodItemList){
                    if(prod.Product_Version__r.Product_Name__c.equals(GEN_OriginationsConstants.LIFE_INSURANCE))hasLifeInsurance = true;
                    if(prod.Product_Version__r.Product_Name__c.equals(GEN_OriginationsConstants.DISABILITY_INSURANCE))hasDisabilityInsurance=true;
                }
            }
        }
        for(Related_Document__c rd: relatedDocs){
        
            String tempURL = documentLinkMap.get(rd.Id);
            RelatedDocumentWrapper tempRelDoc = new RelatedDocumentWrapper();
            tempRelDoc.relatedDocument = rd;
            tempRelDoc.isStatic=false;
            if(rd.Applicant__r.First_Name__c != null){
                tempRelDoc.applicantName += String.valueOf(rd.Applicant__r.First_Name__c);
            }
            if(rd.Applicant__r.Last_Name__c != null){
                tempRelDoc.applicantName += ' ' + String.valueOf(rd.Applicant__r.Last_Name__c);
            }
            if(tempURL != null && tempURL != ''){
                if(tempURL.contains('/Name')){
                    tempRelDoc.documentURL = tempURL.split('/Name=')[0];
                    tempReldoc.documentURLDisplay = tempURL.split('/Name=')[1];
                }
            }
            
            if((rd.GE_Link_Type__c != DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED && rd.GE_Link_Type__c != DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC) &&
             (rd.GE_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_EVOLVE &&  rd.status__c == DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_RECEIVED)){
                relatedDocumentWrapperListNotLoan.add(tempRelDoc);
            } else if (rd.GE_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED) { //ge link type = "Generated Document"
                relatedDocumentWrapperListLoan.add(tempRelDoc);
            }
        }
       
        
        Application__c currentApplication = new Application__c();
        currentApplication = [Select Id, Response_Code__c From Application__c Where Id =: application.Id];

        responseCodeProfileControl(currentApplication.Response_Code__c);

    }    
    public PageReference refreshRelatedDocumentList() {

        getRelatedDocuments();
        return null;
    }
    
    /*  Description: Method to send a related Document in a Webservice Call out
     *  Author: Fel Saliba
     *  Date Created: 19-Feb-2014
     *  Input Parameters: NONE
     *  Return: PageReference
     */
    /*
    public PageReference retryRelatedDocument(){

         try{
            System.debug('relatedDocumentId-->'+relatedDocumentId);
            List<IS_ValidationError> validationErrors = IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId, null); 
            
            if(validationErrors.isEmpty()){
                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('id', String.valueOf(application.Id));
                pageRef.getParameters().put('tab', 'docTab');
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

    /*  Description: Method to send a related Document in a Webservice Call out
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
            this.validationErrors = IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId,null); 
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
                IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c,  Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, relatedDocumentId);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
                return null;
            }
            
            PageReference pageRef = Page.APP_ApplicationMain_INT;
            pageRef.getParameters().put('id', String.valueOf(application.Id));
            pageRef.getParameters().put('tab', 'docTab');
            pageRef.setRedirect(true);
            return pageRef;
      }else{
            for(IS_ValidationError i: this.validationErrors){
              Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
            }
            return null;
       }
    }
    

    /*  Description: This will control button rendering
     *  Author: Jade Serrano
     *  Date Created: 21-Jan-2014
     *  Input Parameters: String
     *  Return: Void
     */
    public void responseCodeProfileControl(String status) {
        List<Response_Code_Control__c> rList = new List<Response_Code_Control__c>();
        rList = [Select Id From Response_Code_Control__c Where Name =: status];
        if(rList.size()>0){
            Boolean resEditDocument = Response_Code_Control__c.getInstance(status).Edit_Document__c;

            Boolean proEditDocument = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_Document__c;

            system.debug('!@#resEditDocument: '+resEditDocument+' proEditDocument:'+proEditDocument);
            if(resEditDocument && proEditDocument){
                editDocumentButton = false;
            }else{
                editDocumentButton = true;
            }
        }            
    }
    
    /*  Description: Wrapper class for the related document
     *  Author: Russell Cadapan
     *  Date Created: JAN-08-2014
     */
    Public Class RelatedDocumentWrapper{
        Public Related_Document__c relatedDocument {get;set;}
        Public String ApplicantName                {get;set;}
        Public String documentURL                  {get;set;}
        Public String documentURLDisplay           {get;set;}
        public boolean isStatic                    {get;set;}
         /*  Description: Wrapper constructor, creates relatedDocument and documentURL
         *  Author: Russell Cadapan
         *  Date Created: JAN-08-2014
         *  Input Parameters: None
         *  Return: N/A
         */
        Public RelatedDocumentWrapper(){
            this.relatedDocument = new Related_Document__c();
            this.ApplicantName = '';
            this.documentURL = '';
            this.documentURLDisplay = '';
        }
    }
    
    public PageReference uploadDocument() {
        PageReference pr = Page.APP_Document_INT;
        pr.getParameters().put('id', this.application.Id);
        pr.setRedirect(false);
        return pr;
    }
    
    public PageReference goBack() {
        PageReference pr = Page.APP_ApplicationMain_INT;
        pr.getParameters().put('id', this.application.Id);
        pr.setRedirect(false);
        return pr;
    }
    public PageReference updateRealtedDocumentsNotLoan(){
        SavePoint sp = Database.setSavePoint();
        
        Boolean noCategory = false;
        Boolean noType = false;
        for(RelatedDocumentWrapper rdw: relatedDocumentWrapperListNotLoan){
            if(rdw.relatedDocument.Document_Category__c == null || rdw.relatedDocument.Document_Category__c == '--None--'){                
                 noCategory = true;
            }
            if(rdw.relatedDocument.Type__c == null || rdw.relatedDocument.Type__c == '--None--'){
                noType = true;
            }
            System.debug('rdw.relatedDocument--->'+rdw.relatedDocument);
        }
        
        if(noCategory && noType){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Document Category is required'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Type is required'));
            showDocs = false;
            return null;
        }
        else if(noCategory && noType == false){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Document Category is required'));
            showDocs = false;
            return null;
        }
        else if(noCategory == false && noType){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Type is required'));
            showDocs = false;
            return null;
        }
        if(noCategory == false && noType == false){
            List<Related_Document__c> docListToUpdate = new List<Related_Document__c>();
            for(RelatedDocumentWrapper rdw: relatedDocumentWrapperListNotLoan){
                docListToUpdate.add(rdw.relatedDocument);
            }
            if(docListToUpdate.size() > 0){
                try{
                    update docListToUpdate;
                }
                catch(Exception e){
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_Documents_EXT_INT', 'Related_D', 'Class', String.valueOf(this.application.Id));
                }

                // Change by: Adrian Recio
                // Description: Out of sync on update of document is removed to fix US-PMIHM-1050
                // Change Date: 14/8/2015
                /*
                try {
                    updateAndSetApplicationOutOfSync(this.application);
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ProofIncomeExt_INT', 'Application__c', 'Class', String.valueOf(this.application.Id));
                }
                */
            }
            
            getRelatedDocuments();
            showDocs = true;
        }

        return null;        
    }

    public Boolean buttonControl(){
        Boolean ret = true;

        List<Response_Code_Control__c> responseCodeControlList = new List<Response_Code_Control__c>();
        responseCodeControlList = [Select Id From Response_Code_Control__c Where Name =: this.application.Response_Code__c];

        if(responseCodeControlList.size()>0){
            Boolean newResponseCodeControl = Response_Code_Control__c.getInstance(this.application.Response_Code__c).New_Edit_Document__c;
            Boolean newProfileControl = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_Edit_Document__c;

            if(newResponseCodeControl && newProfileControl){
                ret = false;
            }else{
                ret = true;
            }

            return ret;
        }else{
            Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
            return ret;
        }
    }   
    
    /*  Description:Method to generate select options for applicants
     *  Author: Adrian Recio
     *  Date Created: 7-MAY-2015
     *  Parameter 
     *  Return: 
     */
    public List<SelectOption> getJointApplicant(){
        List<SelectOption> options = new List<SelectOption>();
        
        String nameStr1 = '';
        String nameStr2 = '';
        
        nameStr1 = nullSetter(applicant.First_Name__c) + ' ' + nullSetter(applicant.Last_Name__c);
        
        if(applicant.First_Name__c==null && applicant.Last_Name__c==null){
            nameStr1 = 'Applicant 1';
        }
        
        options.add(new SelectOption(applicant.Id, nameStr1));
        
        if(getIsJoint()){
            
            nameStr2 = nullSetter(applicant2.First_Name__c) + ' ' + nullSetter(applicant2.Last_Name__c);
            
            if(applicant2.First_Name__c==null && applicant2.Last_Name__c==null){
                nameStr2 = 'Applicant 2';
            }   
            options.add(new SelectOption(applicant2.Id,nameStr2));
            //options.add(new SelectOption('Both','Both'));
        }
        return options;
    }   
    
    /*  Description:Getter method that determines if application is joint
     *  Author: Adrian Recio
     *  Date Created: 7-MAY-2015
     *  Parameter 
     *  Return: 
     */
    public Boolean getIsJoint(){
        if(applicantList.size()>1){
            return true;
        }
        
        return false;
    }

    /*  Description:Converts null value to string
     *  Author: Adrian Recio
     *  Date Created: 7-MAY-2015
     *  Parameter 
     *  Return: 
     */
    public string nullSetter(String checkStr){
        if(checkStr == null){
            return '';
        }
        
        return checkStr;
    }
}