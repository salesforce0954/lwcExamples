/**
 * @Description: General class for generic record retrieval methods
 * @Author: Dan Crisologo
 * @Date Created: DECEMBER-10-2013
 * @History:
   =====================================================================
       01-10-13: Created. - Dan
   =====================================================================
 */
global without sharing class WS_FileUpload{

    // Component Parameters
    public ID applicationId {get; set;}
    public String applicationUniqueID {get; set;}
    public String applicantFirstName {get; set;}
    public String applicantLastName {get; set;}
    public String recordIdSaved {get; set;}
    public String title {get; set;}
    public String status {get; set;}
    public String productId {get; set;}
    public String delRelId {get; set;}
    public String category {get; set;}
    public String type {get; set;}

    private Map<String, Applicant__c> applicantMap;

    /*  Description: relatedDocment getter/setter
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2013
     *  Input Parameters: None
     *  Return: Related Document
     */
    public Related_Document__c relatedDocument{
        get {
            if (relatedDocument==null) {
                relatedDocument = new Related_Document__c();
            }
            return relatedDocument;
        }
        set;
    }
    
    /*  Description: uploadEndPoint getter/setter 
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2013
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
    
    /*  Description: Get list of applicant related to the application
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getApplicantOptions() {
        applicantMap = new Map<String, Applicant__c>();
        List<SelectOption> options = new List<SelectOption>();
        
        List<Applicant__c>appListVar = [Select Id, First_Name__c, 
                                               Last_Name__c,
                                               Application__r.Brand_Lookup__r.File_Upload_Product__c 
                                               from Applicant__c 
                                               where Application__c =: applicationId];
        for(Applicant__c a: appListVar){
            options.add(new SelectOption(a.Id, a.First_Name__c + ' ' + a.Last_Name__c));
            applicantMap.put(a.id, a);
        }
        return options; 
    }
    
    /*  Description: Get document categories
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2013
     *  Input Parameters: None
     *  Return: SelectOption
     */
    public List<SelectOption> getDocumentCategoryOptions() {
      List<SelectOption> options = new List<SelectOption>();
      Schema.DescribeFieldResult fieldResult = Related_Document__c.Document_Category__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
      }
       return options; 
    }
    
    /*  Description: get a string-formatted date time stamp
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2014
     *  Input Parameters: None
     *  Return: String
     */
    public String getDateStamp {
        get {
            DateTime dt = DateTime.now();
            //7/17/13, 5:01:14 PM Australian Eastern Standard Time
            return dt.formatGmt('MM/dd/yy, hh:mm:ss a zzzzz'); 
        }
        set;
    }
    
     /*  Description: Action method to delete related document.
                      New method for PMIHM-1729 and PMIHM-1104.
     *  Author: Adrian Recio
     *  Date Created: AUG-08-2015
     *  Input Parameters: None
     *  Return: NA
     */
    public void deleteRelatedDocument(){
        if(delRelId!=null && delRelId!=''){
            List<Related_Document__c> delRelList = [Select Id from Related_Document__c where Id = :delRelId];
            if(delRelList.size()==1){
                delete delRelList;
            }
        }
    }

    /*  Description: action method to insert related document
     *  Author: Dan Crisologo
     *  Date Created: JAN-11-2013
     *  Input Parameters: None
     *  Return: Related document Id
     */
    public PageReference insertRelatedDocument() {
        
        System.debug('application unique Id:' + applicationUniqueID); 

        // Pull related applicants of application
        List<Applicant__c>appliList = [Select First_Name__c,Last_Name__c,
        									  Id,Email_Address__c,Is_Primary_Applicant__c from 
        							   		  Applicant__c where 
                                       		  Application__c =: applicationId limit 2];
        
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
            relatedDocument.Status__c = DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_DRAFT;
            if(site.getName()!=null&&site.getName()!=''){
                relatedDocument.Document_Category__c = category;
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
            
            system.debug('Upload Document Category:' + relatedDocument.Document_Category__c);
            system.debug('Upload Document Type:' + relatedDocument.Type__c);
            system.debug('Product :' + relatedDocument.product__c);            
            system.debug('Related Document Applicant:' + relatedDocument.applicant__c);
            system.debug('Related document record ' + relatedDocument);
            insert  relatedDocument;
            recordIdSaved = relatedDocument.Id;
            productId = applicantMap.get(primaryApplicant.Id).Application__r.Brand_Lookup__r.File_Upload_Product__c;
            relatedDocument.id = null;
            system.debug('Inserted Related Document Id:' + relatedDocument.Id);
        } catch (Exception e) {
            Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
            System.debug('catch');
        }

        return null;
    }
     
     /*  Description: Method to Redirect to the main page.
     *  Author: Fel Saliba
     *  Date Created: March-20-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference goBack() {
        PageReference pr = Page.APP_ApplicationMain_INT;
        pr.getParameters().put('id', applicationId);
        pr.setRedirect(false);        return pr;
    }
    
    /*  Description: Method to set boolean that specifies that an applicant already uploaded a document.
     *  Author: Adrian Recio
     *  Date Created: March-21-2014
     *  Input Parameters: Id
     *  Return: void
     */
    public void setApplicantUploadStatus(Id appliId){
        
        List<Applicant__c> appList = [Select Id, Name from Applicant__c where Id = :appliId];
        
        for(Applicant__c appVar: appList){
            appVar.Has_Uploaded__c = true;
        }
        
        update appList;
    }
}