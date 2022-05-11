/**
 * @Description: Class extension for APP_CustomerUIFileUpload
 * @Author: Adrian Recio
 * @Date Created: 18/3/2014
 * @History:
   =====================================================================
       01-10-13: Created - Adrian Recio
   =====================================================================
 */
global without sharing class APP_GSD_FileUpload extends APP_CommonExt{
   
    // Class Variable Declaration
    public List<Requested_Document__c> rdMainList{get; set;}
    public List<Requested_Document__c> rdDeleteList{get; set;}
    public string rdAngularList{get; set;}
    public String removeIndex {get; set;}
    public String responseCodeControlType{get;set;}
    public Brand__c brand {get;set;}  //Variable used for display of brand display name and contact number

    public string applicationMainId {get; set;}

    /*  Description: uploadEndPoint getter/setter 
     *  Author: Adrian Recio
     *  Date Created: 08/02/2016
     *  Input Parameters: None
     *  Return: String
     */
    public String uploadEndPoint { 
        get {
            if (uploadEndPoint==null) {
                uploadEndPoint = Web_Service_Settings__c.getValues('File Upload Endpoint').value__c;
            }
            return uploadEndPoint;
        }
        set;
    }
    
    /*  Description: Class constructor
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter ApexPages.StandardController
     *  Return: na
     */
    public APP_GSD_FileUpload(ApexPages.StandardController applicationController) {
        
        super(applicationController);
        
        system.debug('Current page value:' + ApexPages.currentPage());
        
        commonAuthorizationRequired();
        queryDocumentRequest();
        
        rdAngularList = String.escapeSingleQuotes(JSON.serialize(rdMainList));
        
        system.debug('rdAngularList:' + rdAngularList);
        

        responseCodeControlType = getResponseCodeControlType();
        brand = [SELECT Contact_Number__c FROM Brand__c WHERE Id = :this.application.Brand_Lookup__c LIMIT 1];
        
        applicationMainId = application.Id;
    }
    
    /*  Description: Getter method to pull response code details
     *  Author: Adrian Recio
     *  Date Created: 2-APR-2014
     *  Parameter na
     *  Return: string
     */
    public string getResponseCodeControlType(){
        try {
            responseCodeControlType = Response_Code_Control__c.getValues(application.Response_Code__c).Type__c;
        } catch(Exception e){
            responseCodeControlType = '';
        }
        return responseCodeControlType;
    }
    
    /*  Description: Method to check if applicaiton is joint
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Boolean getIsJoint(){
        if(applicantList.size()>1){
            return true;
        }
        
        return false;
    }
    
    public boolean IsRequestedDoc{get; set;}

    /*  Description: Main Method to query requested document 
                     based on current application
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public void queryDocumentRequest(){
        
        IsRequestedDoc = false;
        string pageStrValue = string.valueOf(ApexPages.currentPage()).toLowerCase();
        rdMainList = new List<Requested_Document__c>();
        
        boolean testUploadView = false;
        
        if(pageStrValue.toLowerCase().contains('testval=true')){
            testUploadView = true;
        }
        
        // Pull Requested Document Records
        if(pageStrValue.toLowerCase().contains('app_gsd_requesteddoc') || testUploadView){
            IsRequestedDoc = true;
            rdMainList = pullRequestedDocumentRecords('Application__c = \''+ application.Id + '\' AND Status__c != \'Complete\' order by createdDate ASC' );
        }

        // Pull related applicants of application
        List<Applicant__c>appliList = [Select First_Name__c,Last_Name__c,
                                              Id,Email_Address__c,Is_Primary_Applicant__c from 
                                              Applicant__c where 
                                              Application__c =:application.Id  limit 2];
        
        if(pageStrValue.toLowerCase().contains('app_gsd_aml_response') || testUploadView){
            // Create shell requested documents for AML
            Requested_Document__c rdVarAML = new Requested_Document__c();
            rdVarAML.Status__c = 'Complete';
            rdVarAML.Category__c = 'AML';
            rdVarAML.Application__c = application.Id;
            rdMainList.add(rdVarAML);
        }
        
        if(pageStrValue.toLowerCase().contains('app_gsd_poi_response') || testUploadView){

            for(Applicant__c appLoopVar: appliList){
                if(appLoopVar.Is_Primary_Applicant__c==true){
                    // Create shell requested documents for POI
                    Requested_Document__c rdVarPOI = new Requested_Document__c();
                    rdVarPOI.Status__c = 'Complete';
                    rdVarPOI.Category__c = 'POI1';
                    rdVarPOI.Application__c = application.Id;
                    rdVarPOI.Applicant__c = appLoopVar.Id;
                    rdMainList.add(rdVarPOI);
                }else{
                    if(application.Application_Type__c == 'Joint'){
                        Requested_Document__c rdVarPOI2 = new Requested_Document__c();
                        rdVarPOI2.Status__c = 'Complete';
                        rdVarPOI2.Category__c = 'POI2';
                        rdVarPOI2.Application__c = application.Id;
                        rdVarPOI2.Applicant__c = appLoopVar.Id;
                        rdMainList.add(rdVarPOI2);
                    }
                }
            }
        }
      
        if(pageStrValue.toLowerCase().contains('app_gsd_poa_response') || testUploadView){
            // Create shell requested documents for Proof of Address       
            Requested_Document__c rdVarPOA = new Requested_Document__c();
            rdVarPOA.Status__c = 'Complete';
            rdVarPOA.Category__c = 'Proof of Address';
            rdVarPOA.Application__c = application.Id;
            rdMainList.add(rdVarPOA);
        }
    
        if(pageStrValue.toLowerCase().contains('app_gsd_contractacceptance') || testUploadView){
            // Create shell requested documents       
            Requested_Document__c rdVarCA = new Requested_Document__c();
            rdVarCA.Status__c = 'Complete';
            rdVarCA.Category__c = '';
            rdVarCA.Application__c = application.Id;
            rdMainList.add(rdVarCA);
        }
       
    }
    
    /*  Description: Main method to construct query statement and pull field sets 
                     to query related requested document based on current application.
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public List<Requested_Document__c> pullRequestedDocumentRecords(string queryCondition){
        
        // Build query string
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : this.getRequestedDocumentFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,Applicant__r.First_Name__c,Applicant__r.Last_Name__c FROM Requested_Document__c where ' + queryCondition;
        
        return Database.query(query);
    }
    
    /*  Description: Pull Requested Document Field Set
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter na
     *  Return: 
     */
    public List<Schema.FieldSetMember> getRequestedDocumentFields() {
        return SObjectType.Requested_Document__c.FieldSets.Requested_Document.getFields();
    }
    
    /*  Description: Method to redirect to main page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectMain(){
        pageReference pgRef = Page.APP_ApplicationMain_INT;
        pgRef.getParameters().put('Id', application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 06-MAY-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }
    
    /*  Description: Getter method to pull requested document count
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Integer getRDCount(){
        return rdMainList.size();
    }
    
    /*  Description: Method to redirect to complete page
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference redirectToCompletePage(){
        PageReference pgRef = Page.APP_Complete;
        pgRef.getParameters().put('FileUpload','1');
        pgRef.getParameters().put('Id', application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Method that redirects page to app main or post submit page dependending on application status
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference validatePostSubmit(){
        
        // Redirect to app complete page if response code is FIA
        if(application.Response_Code__c == 'FIA'){
            pageReference pgRef = Page.APP_Complete;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        
        // Pull application response code
        Response_Code_Control__c responseValue = Response_Code_Control__c.getValues(application.Response_Code__c);
        String typeValue = '';
        if(responseValue!=null){
            typeValue = responseValue.Type__c;
        }
        
        List<Requested_Document__c>rDocList = [Select Id, Name, Application__c from Requested_Document__c where Application__c = :application.Id];
        
        // Redirect page to app main if appliction is still new
        if(application.Status__c=='New' ){
            pageReference pgRef = Page.APP_Main;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }

        // Redirect page to app main post submit if application is not new but response code is not valid
        if( (application.Response_Code__c == 'PCO') || (typeValue == 'Referred' && rDocList.size() == 0) || typeValue == ''){
            pageReference pgRef = Page.APP_Main_PostSubmit;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        
        return null;
    }
    
    /*  Description: Upload infor wrapper class
     *  Author: Adrian Recio
     *  Date Created: 08/02/2016
     *  Parameter 
     *  Return: NA
     */
    global class uploadInfo{
        global string applicantFirstName{get; set;}
        global string applicantLastName{get; set;}
        global string applicationUniqueID{get; set;}
        global string getDateStamp{get; set;}
        global string productId{get; set;}
        global string recordIdSaved{get; set;}
    }
    
    /*  Description: Insert remote action for creating related and request documents
     *  Author: Adrian Recio
     *  Date Created: 08/02/2016
     *  Parameter 
     *  Return: APP_GSD_FileUpload.uploadInfo
     */
    @RemoteAction
    global static APP_GSD_FileUpload.uploadInfo insertRelatedDocument(string title, string type, string category, string statusVar, string applicationId, Boolean mockEnabled){
        
        Map<String, Applicant__c> applicantMap = APP_GSD_FileUpload.getApplicantOptions(applicationId);
      
        APP_GSD_FileUpload.uploadInfo uploadInfoVar = new APP_GSD_FileUpload.uploadInfo();
      
        string applicantFirstName = '';
        string applicantLastName = '';
        string applicationUniqueID = '';
        string getDateStamp = '';
        string productId = '';
        string recordIdSaved = '';
      
        Related_Document__c relatedDocument = new Related_Document__c();
        
          
        System.debug('application unique Id:' + applicationUniqueID); 

        // Pull related applicants of application
        List<Applicant__c>appliList = [Select First_Name__c,Last_Name__c,
                                              Id,Email_Address__c,Is_Primary_Applicant__c from 
                                              Applicant__c where 
                                              Application__c =:applicationId  limit 2];
        
        Applicant__c primaryApplicant = new Applicant__c();
        Map<string,Id> appEmailMap = new Map<string,Id>();
        
        // Pull Primary Applicant from list
        // Pull email map from list
        for(Applicant__c appLoopVar: appliList){
            if(appLoopVar.Is_Primary_Applicant__c==true){
                primaryApplicant = appLoopVar;
            }
            appEmailMap.put(appLoopVar.Email_Address__c,appLoopVar.Id);
        }
        
        if(applicationUniqueID == null || applicationUniqueID == '') {
            Application__c app = [Select UID__c from Application__c where id =: applicationId];
            applicationUniqueID = app.UID__c;
            System.debug('new application unique Id:' + applicationUniqueID);
        }
        
        system.debug('selected user:' + relatedDocument.applicant__c);
        
        if((applicantFirstName == null && applicantLastName == null ) || ( applicantFirstName == '' && applicantLastName == '')) {
            applicantFirstName = applicantMap.get(primaryApplicant.Id).first_name__c;
            applicantLastName = applicantMap.get(primaryApplicant.Id).last_name__c;
            System.debug('First2--->'+applicantFirstName); 
        }
        try {
            relatedDocument.Application__c = applicationId;
            relatedDocument.Title__c = title;
            relatedDocument.product__c = applicantMap.get(primaryApplicant.Id).Application__r.Brand_Lookup__r.File_Upload_Product__c;

            if(mockEnabled==false){
                relatedDocument.Status__c = DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_DRAFT;
            }else{
                relatedDocument.Status__c = DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_RECEIVED;
            }

            if(site.getName()!=null&&site.getName()!=''){
                if(category=='POI1' || category=='POI2'){
                    relatedDocument.Document_Category__c = 'POI';
                }else{
                    relatedDocument.Document_Category__c = category;
                }
                relatedDocument.Type__c = type;
            }
            // If applicant is null, this means that the class is referenced in customer UI.
            // Default the applicant to current login user.
            try{
                if(relatedDocument.applicant__c==null){
                    system.debug('Applicant Auto Assigned.');
                    User userVar = [Select Id, Email from User where Id = :UserInfo.getUserId()];
                    if(userVar.Email!=null){
                        Id appMatchId = appEmailMap.get(userVar.Email);
                        system.debug('Auto Applicant:' + appMatchId);
                        if(appMatchId!=null){
                            relatedDocument.applicant__c = appMatchId;
                        }
                    }
                }
            }catch(exception e){
                system.debug('Upload Error:' + string.valueOf(e));
            }
            
            
            insert  relatedDocument;
            recordIdSaved = relatedDocument.Id;
            productId = applicantMap.get(primaryApplicant.Id).Application__r.Brand_Lookup__r.File_Upload_Product__c;
            relatedDocument.id = null;
            system.debug('Inserted Related Document Id:' + relatedDocument.Id);
            
            // Generate Requested Document
            if(statusVar=='Complete' && category!=null){
                Requested_Document__c rdVar = new Requested_Document__c();
                rdVar.Status__c = 'Complete';

                if(category=='POI1' || category=='POI2'){
                    rdVar.Category__c = 'POI';
                }else{
                    rdVar.Category__c = category;
                }
                rdVar.Document_Type__c = type;
                rdVar.Application__c = applicationId;

                if(rdVar.Document_Type__c==null || rdVar.Document_Type__c==''){
                    rdVar.Document_Type__c = 'Not Applicable';
                }

                if(rdVar.Number_Required__c==null || rdVar.Number_Required__c==''){
                    rdVar.Number_Required__c = '1';
                }

                insert rdVar;
            }

            uploadInfoVar.applicantFirstName = applicantFirstName;
            uploadInfoVar.applicantLastName = applicantLastName;
            uploadInfoVar.applicationUniqueID = applicationUniqueID;
            uploadInfoVar.getDateStamp = getDateStamp;
            uploadInfoVar.productId = productId;
            uploadInfoVar.recordIdSaved = recordIdSaved;
        
        } catch (Exception e) {
            Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
            system.debug('Upload Error:' + string.valueOf(e));
        }
        
        return uploadInfoVar;
    }
     
    /*  Description: Delete remote action for removing related 
     *               and request documents for failed uploads.
     *  Author: Adrian Recio
     *  Date Created: 08/02/2016
     *  Parameter 
     *  Return: void
     */
    @RemoteAction
    global static void deleteRelatedDocument(string delRelId){
        if(delRelId!=null && delRelId!=''){
            List<Related_Document__c> delRelList = [Select Id from Related_Document__c where Id = :delRelId];
            if(delRelList.size()==1){
                delete delRelList;
            }
        }
    }
   
    /*  Description: Main method for pulling applicants for current application
     *  Author: Adrian Recio
     *  Date Created: 08/02/2016
     *  Parameter 
     *  Return: Map<String, Applicant__c>
     */
    public static Map<String, Applicant__c> getApplicantOptions(string applicationId) {
        Map<String, Applicant__c> applicantMap = new Map<String, Applicant__c>();
        
        List<Applicant__c>appListVar = [Select Id, First_Name__c, 
                                               Last_Name__c,
                                               Application__r.Brand_Lookup__r.File_Upload_Product__c 
                                               from Applicant__c 
                                               where Application__c =: applicationId];
        for(Applicant__c a: appListVar){
            applicantMap.put(a.id, a);
        }
        return applicantMap;
    }
    
    
}