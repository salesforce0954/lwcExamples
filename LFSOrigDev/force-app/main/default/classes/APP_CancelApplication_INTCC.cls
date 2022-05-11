public with sharing class APP_CancelApplication_INTCC{

    public String cancelReasonStr{get;set;}
    public String comment{get;set;}
    Public Workflow__c wf {get; set;}
    public static ID appId;
    
    Id applicationId;

    public APP_CancelApplication_INTCC(){
        try{            
            //get application id
            applicationId = ApexPages.currentPage().getParameters().get('id');
            appId=ApexPages.currentPage().getParameters().get('id');
            system.debug('**applicantionId: '+applicationId);
        }catch(Exception e){            
            //exception log
            system.debug('**EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'APP_CancelApplication_INTCC()', 'APP_CancelApplication_INTCC', 'Class', String.valueOf(applicationId));
            Util.addMessage(ApexPages.Severity.ERROR, 'There has been an error, please notify your administrator');
        }
  
    }
    
    public PageReference cancel(){    
        PageReference pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('Id',applicationId);
        pageRef.setRedirect(true);
        return pageRef;        
    }
    
    public PageReference save(){
    
        Application__c application;
        Boolean statusValid = false;
        Savepoint sp;   //store savepoint here
        
        try {
            application = [Select Id, Submission_Status__c, Name, Initial_Submit_Date__c from Application__c where Id =: applicationId];
            if((application.Submission_Status__c == GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED || 
               application.Submission_Status__c == GEN_OriginationsConstants.APP_SUBMITTION_STATUS_RESPONSE_RECEIVED) &&
               application.Initial_Submit_Date__c != null) {
                statusValid = true; //set status to true; only submitted application can be cancelled
            } else {
                
                Util.addMessage(ApexPages.Severity.ERROR, 'You can only cancel submitted applications.');
            }
        } catch (Exception e) {
            
            Util.addMessage(ApexPages.Severity.ERROR, 'The application you are trying to cancel no longer exists');
        }
        
        if(statusValid) {
            try{
                Boolean saveTask = true;
                
                if(cancelReasonStr=='null'){

                    Util.addMessage(ApexPages.Severity.ERROR, 'Please choose a cancel reason');
                    saveTask = false;
                    
                }
                if(comment=='' || comment==null){

                    Util.addMessage(ApexPages.Severity.ERROR, 'Please put a comment');
                    saveTask = false;
                    
                }
                //Id taskOriginationsActionId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Originations Action').getRecordTypeId();
                
                if(saveTask){     
                    //call the cancel request webservice
                    IS_ApplicationCancel.ApplicationCancelRequest(application.Id, cancelReasonStr, comment, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                    sp = Database.setSavepoint();

                    //TO DO

                    Id devRecordTypeId = Schema.SObjectType.Workflow__c.getRecordTypeInfosByName().get('Close Application').getRecordTypeId();
                    //System.debug('*** Application Workflow ' + wf.Application__c + ' ID: ' + application.Id + ' WFID ' + wf.Id);
                    //Id appId = application.Id;
                    //String sWfId = wf.Id;
                    //System.debug('&&& APPID ' + appId + ' length ' + sWfId.length());
                    //if(wf.Application__c==null && sWfId.length() == 0) {
                    //    wf.Application__c = application.Id;
                    //}
                    //
                    wf = new Workflow__c();
                    wf.Description__c = 'Close Application';
                    wf.Application__c = application.Id;
                    wf.Comments__c = comment;
                    wf.Status__c = cancelReasonStr;
                    
                    wf.RecordTypeId = devRecordTypeId;
                    System.debug('@@ wf ' + wf);
                    insert wf;
                    
                    //NOTE: This might be removed later on as there might be a mock service to update the app response code
                    List<Webservice_Decline_Reasons__c> wdr = [Select Name from Webservice_Decline_Reasons__c where Reason_Name__c =: cancelReasonStr];
                    
                    //if a reason matches with a record in the custom settings, set status to closed - declined
                    if(!wdr.isEmpty()) {
                        application.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_DECLINED;
                    } else {
                        application.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_CANCELLED;
                    }
                    
                    application.Response_Description__c = '';
                    update application;
                    disablePortalUser(applicationId);
                    PageReference pageRef = Page.APP_ApplicationMain_INT;
                    pageRef.getParameters().put('Id',applicationId);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
            }catch(Exception e){            
                //exception log
                system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
                ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'save()', 'APP_CancelApplication_INTCC', 'Class', String.valueOf(applicationId));
                Util.addMessage(ApexPages.Severity.ERROR, 'There has been an error, please notify your administrator');
                
                if(sp!=null) {
                    Database.rollback( sp ); //rollback if an exception occured
                }
                return null;
            }
        } 
        return null;
    }
    
    public List<SelectOption> cancelReason{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('null', 'Please Select'));
            //BEGIN DWATSON: 12-Aug-19 PL Decline Reason update remove TD as an option
            //options.add(new SelectOption('SCORE – TD', 'SCORE – TD'));
            //END DWATSON: 12-Aug-19 PL Decline Reason update remove TD as an option
            options.add(new SelectOption('EMP. – CASUAL < 12 MTHS', 'EMP. – CASUAL < 12 MTHS'));
            options.add(new SelectOption('EMP. – PROBATION', 'EMP. – PROBATION'));
            options.add(new SelectOption('EMP. – UNEMPLOYED', 'EMP. – UNEMPLOYED'));
            options.add(new SelectOption('EMP. – UNABLE TO VERIFY', 'EMP. – UNABLE TO VERIFY'));
            options.add(new SelectOption('CAP. – NEGATIVE CAPACITY', 'CAP. – NEGATIVE CAPACITY'));
            options.add(new SelectOption('CAP. – S/E NO FIGURES', 'CAP. – S/E NO FIGURES'));
            options.add(new SelectOption('CAP. – UNABLE TO VERIFY', 'CAP. – UNABLE TO VERIFY'));
            //BEGIN MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            options.add(new SelectOption('U/W – ADVERSE GE HISTORY', 'U/W – ADVERSE '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY.toUpperCase()+' HISTORY'));
            options.add(new SelectOption('U/W – ADVERSE REFERENCES(NON GE)', 'U/W – ADVERSE REFERENCES(NON '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY.toUpperCase()+')'));            
            options.add(new SelectOption('U/W. – ADVERSE CREDIT HISTORY', 'U/W. – ADVERSE CREDIT HISTORY'));
            options.add(new SelectOption('U/W. – MAX GE EXPOSURE', 'U/W. – MAX '+GEN_OriginationsConstants.BRAND_NAME_GEMONEY.toUpperCase()+' EXPOSURE'));
            //END MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            options.add(new SelectOption('U/W. – FRAUD', 'U/W. – FRAUD'));
            options.add(new SelectOption('U/W. – LOW INCOME POLICY', 'U/W. – LOW INCOME POLICY'));
            options.add(new SelectOption('U/W. – UNABLE TO VERIFY ID', 'U/W. – UNABLE TO VERIFY ID'));
            options.add(new SelectOption('U/W. – AML REQUESTED BUT DECLINED', 'U/W. – AML REQUESTED BUT DECLINED'));
            options.add(new SelectOption('U/W. – UNDISCLOSED DEBT', 'U/W. – UNDISCLOSED DEBT'));
            options.add(new SelectOption('U/W. – INVALID LOAN PURPOSE', 'U/W. – INVALID LOAN PURPOSE'));
            options.add(new SelectOption('U/W. – RESPONSIBLE LENDING', 'U/W. – RESPONSIBLE LENDING'));
            options.add(new SelectOption('U/W. – EXPENSE INDICATOR', 'U/W. – EXPENSE INDICATOR'));                
            options.add(new SelectOption('CUST. – INTEREST RATE', 'CUST. – INTEREST RATE'));
            options.add(new SelectOption('CUST. – DECLINED DOWNSELL', 'CUST. – DECLINED DOWNSELL'));
            options.add(new SelectOption('CUST. – NO SECURITY / WONT PROVIDE', 'CUST. – NO SECURITY / WONT PROVIDE'));
            options.add(new SelectOption('CUST. – OBTAINED ELSEWHERE', 'CUST. – OBTAINED ELSEWHERE'));
            options.add(new SelectOption('CUST. – NO RESPONSE', 'CUST. – NO RESPONSE'));
            options.add(new SelectOption('CUST. – NO RESPONSE SINCE OFFER', 'CUST. – NO RESPONSESINCE OFFER'));
            options.add(new SelectOption('CUST. – UNHAPPY WITH PROCESS', 'CUST. – UNHAPPY WITH PROCESS'));
            options.add(new SelectOption('CUST. – NON PERM RESIDENT', 'CUST. – NON PERM RESIDENT'));
            //BEGIN DWATSON: 12-Aug-19 PL Decline Reason update remove other as an option
            //options.add(new SelectOption('OTHER – RECORD REASON IN NOTES', 'OTHER – RECORD REASON IN NOTES'));
            //END DWATSON: 12-Aug-19 PL PL Decline Reason update remove other as an option
            options.add(new SelectOption('CUST. – NO LONGER REQUIRED', 'CUST. – NO LONGER REQUIRED'));
            options.add(new SelectOption('DUPE. – DUPLICATE / INVALID APPLICATION', 'DUPE. – DUPLICATE / INVALID APPLICATION'));
            return options;
        }
        set;
    }
    
    /*To disable user registration when application is closed/ cancelled*/
    @future
    public static void  disablePortalUser(Id appId1){
        System.debug('appId===>'+appId1);
        if(appId1 != null){
        User[] uObj =[select id,IsActive,IsRegistered__c from User where AppId__c =:appId1 ];
        if(uObj.size()>0){
            uObj[0].IsActive = false;
            uObj[0].IsRegistered__c=false;
            update uObj[0];
        }
        }
    }
    
}