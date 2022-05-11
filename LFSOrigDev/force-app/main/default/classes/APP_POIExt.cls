/**
 * @Description: Income Confirmation Page controller.
 * @Author: Fel Saliba
 * @Date Created: OCTOBER-07-2013
 * @History:
   =====================================================================
        OCT-7 (Fel): Created.
        NOV-22 (Mike): Added pageCancel() method
   =====================================================================
 */ 
global class APP_POIExt extends APP_CommonExt{
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<Income_Document__c> allDocuments;
    public Set<String> allIncomeSource;
    public Boolean isCust {get; set;}
    
    public String fullTime {get;set;}
    public List<Income_Document__c> fullTimeDocuments {get;set;}
    public Set<String> fullTimeSet;
    public Boolean hasFullTime{get;set;}
    
    public String rental{get;set;}
    public List<Income_Document__c> rentalDocuments {get;set;}
    public Set<String> rentalSet;
    public Boolean hasRental{get;set;}
    
    public String superan{get;set;}
    public List<Income_Document__c> superDocuments {get;set;}
    public Set<String> superSet;
    public Boolean hasSuper{get;set;}
    
    public String mode{get;set;}
    
    public String uploadEndPoint {get; set;}
    public Related_Document__c initialDocument {get; set;}
    private Map<Id, String> documentIdNameMap;
    
    //Added by Fel Saliba 1/14/2014
    //Info to bind upon submit attachment
    public String applicationId {get; set;}
    public String applicationUniqueID {get; set;}
    public String applicantFirstName {get; set;}
    public String applicantLastName {get; set;}
    public String recordIdSaved {get; set;}
    public String title {get; set;}
    public String status {get; set;}
    public Related_Document__c relatedDocument;
    
    public APP_POIExt(ApexPages.StandardController applicationController) {
        super(applicationController);
        
        //Added by Fel Saliba 1/14/2014
        applicantFirstName = applicant.First_Name__c;
        applicantLastName  = applicant.Last_Name__c;
        Application__c app = [Select UID__c from Application__c where id =: application.Id];
        applicationUniqueID = app.UID__c;
        recordIdSaved = '';
        status = '';
        relatedDocument = new Related_Document__c();
        
        mode = ApexPages.currentPage().getParameters().get('mode');
        isCust = isCustomer();
        this.uploadEndPoint = Web_Service_Settings__c.getValues('File Upload Endpoint').Value__c;

        allIncomeSource = new Set<String>();
        documentIdNameMap = new Map<Id,String>();
        
        for(Income__c inc : retrieveIncomeList(this.applicant.Id)){
            allIncomeSource.add(inc.Income_Source__c);
        }
        
        allDocuments = new List<Income_Document__c>();
        allDocuments = [Select Id, Name, Income_Source__c, Information_to_show__c 
                       from Income_Document__c where Income_Source__c IN: allIncomeSource];
        
        fullTime = '';
        fullTimeDocuments = new List<Income_Document__c>();
        fullTimeSet = new Set<String>();
        hasFullTime = false;
        
        rental ='';
        rentalDocuments = new List<Income_Document__c>();
        rentalSet = new Set<String>();
        hasRental = false;
        
        superan ='';
        superDocuments = new List<Income_Document__c>();
        superSet = new Set<String>();
        hasSuper = false;

        for(Income_Document__c all: allDocuments){
        
            documentIdNameMap.put(all.Id, all.Name);
        
            if(all.Income_Source__c == 'Permanent full time / Part time'){
                fullTimeDocuments.add(all);
                fullTimeSet.add(all.Name);  
                hasFullTime = true;              
            } else if(all.Income_Source__c == 'Rental Income'){
                rentalDocuments.add(all);
                rentalSet.add(all.Name);
                hasRental = true;
            } else if(all.Income_Source__c == 'Superannuation'){
                superDocuments.add(all);
                superSet.add(all.Name);
                hasSuper = true;
            }

        }                           
    }
    
    /*  Description: Initially creates a document
     *  Author: Dan Crisologo
     *  Date Created: JAN-07-2014
     *  Input Parameters: None
     *  Return: None
     */
    public void createInitialRelatedDocument() {
        initialDocument = new Related_Document__c();
        
        //assign the existing related document income if it has an existing empty income document
        for(Related_Document__c rd: [Select   Id, 
                                              Application__c, 
                                              //Income_Document__c, 
                                              Applicant__c,
                                              Document_Category__c,
                                              Type__c
                                     from     Related_Document__c 
                                     where    Application__c =: application.Id 
                                      AND     Applicant__c =: applicant.Id
                                     order by CreatedDate DESC
                                     limit    1]) {            
            initialDocument = rd;
            System.debug(initialDocument.id);
        }
        //insert a new one if no document found
        if(initialDocument.Id==null) {
            initialDocument.Application__c = application.Id;
            initialDocument.Applicant__c = applicant.Id;
            insert initialDocument;
        }
    }
    
    //Mike 03/18/14: Inquire if still needed
    @RemoteAction 
    global static String testInsertForMultiple(String applicationId, String applicantId, String incomeDocumentId) { //
        
        Related_Document__c rd = new Related_Document__c();
        rd.Application__c = applicationId; 
        rd.Applicant__c = applicantId; 
        //rd.Income_Document__c = incomeDocumentId;
        rd.Document_Category__c = GEN_OriginationsConstants.DOCUMENT_CATEGORY_POI; 

        insert rd;

        return rd.Id;

    }
    
    public List<SelectOption> getFullTimeOpt() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(Income_Document__c s: fullTimeDocuments){
            options.add(new SelectOption(s.Id,s.Name)); 
        }        
        return options; 
    }
    
    public List<SelectOption> getRentalOpt() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(Income_Document__c s: rentalDocuments){
            options.add(new SelectOption(s.Id,s.Name)); 
        }       
        return options; 
    }
    
    public List<SelectOption> getSuperOpt() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(Income_Document__c s: superDocuments){
            options.add(new SelectOption(s.Id,s.Name)); 
        }        
        return options; 
    }

    /*  Description: get a string-formatted date time stamp
     *  Author: Dan Crisologo
     *  Date Created: JAN-09-2014
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

    /*  Description: Redirect to Assets Page (Staff UI)
     *  Author: Mike Lasala
     *  Date Created: NOV-22-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageCancel(){
        PageReference pageRef;
        
        if(mode == 'Cust'){
            pageRef = Page.APP_Main;
            pageRef.setRedirect(true);
            pageRef.getParameters().put('aId', String.valueOf(this.applicant.Id));
        } else if(mode == 'Staff'){
            pageRef = Page.APP_ApplicationMain_INT;
        } else {
            pageRef =Page.APP_JointIncome_INT;
        }
        pageRef.getParameters().put('id', String.valueOf(this.application.Id));
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*  Description: Method to insert Related Document (Staff UI)
     *  Author: Fel Saliba
     *  Date Created: Jan-14-2014
     *  Input Parameters: None
     *  Return: None
     */
     
    public void insertRelatedDocument() {
        relatedDocument = new Related_Document__c();
        try {
            relatedDocument.Application__c = application.Id;
            relatedDocument.Title__c = title;
            relatedDocument.Document_Category__c = 'POI';
            relatedDocument.Status__c = 'Draft';
            insert relatedDocument;
            recordIdSaved = relatedDocument.Id;
        } catch (Exception e) {
          Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
        } 
    }
    
    /*  Description: Method to update Related Document Status upon submit (Staff UI)
     *  Author: Fel Saliba
     *  Date Created: Jan-14-2014
     *  Input Parameters: None
     *  Return: None
     */     
    public PageReference updateRelatedDocument() {
       
        if(status == 'success'){
            try {
                relatedDocument.Status__c = 'Sent';
                update relatedDocument;                
                Util.addMessage(ApexPages.Severity.CONFIRM, 'Your document has been sent');
            } catch (Exception e) {
                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
            }
            
            try{
                applicant.Has_Uploaded__c = true;
                update applicant;
            } catch (Exception e) {
                ErrorHandlerException.recordException(e.getMessage(), 'APP_POIExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured. Please contact your administrator.');
            }
        }
        else if(status == '209'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Upload Fail.Please try again later.');
        }
        else if(status == '220'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Your document is larger than 10MB. Please use a smaller document.');
        }
        else if(status == '221'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Upload Fail. Your document file format is unsupported. Please use another document.');
        }
        else if(status == '222'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Upload Fail. Your document is corrupted. Please use another document.');
        }
        else if(status == '210'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Invalid Input Parameters.');
        }
        return null;                  
    }
}