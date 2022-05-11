/*
 * @Description: Main Controller for GE Loan Application
 * @Author: Jan Mark Domingo
 * @Date Created: OCT-1-2013
 * @History:
   =====================================================================
           10-OCT-13: Created - Mac
           10-OCT-13: Added goToCreateUser method - Jade
           10-OCT-13: Added variable and method for Timeout redirection - Mike
           10-OCT-13: Added variable for UI parameter and condition to redirect to Sales UI - Mike
           18-OCT-13: Added gotoNextPage method - Mike
           23-OCT-13: Updated- Added methods to retrieve related records based on the application Id
           25-NOV-13: Added redirection to Joint Application pages and removed Sales/Staff UI variables and conditions - Mike
           31-JAN-14: Refactored - Mike
   =====================================================================
 */
public with sharing class APP_MainExt extends APP_CommonExt {           
        
        //public List<Admin_Settings__c> timeoutSettings  {get;set;}
        public String applicantFirstName                {get;set;}
        public String redirectTo                        {get;set;}
        public String result                            {get;set;}
        transient public Boolean isJoint                {get;set;}
        public boolean isDataComplete                   {get;set;}//added as part of defect 1144
        public boolean isSoftQuoteApp                   {get;set;}//Added for  NZ Soft quote  checks
        public String applicationId                      {get;set;}  //application id
        public String prodId;

        //===============================================================
        //                       CONSTRUCTORS
        //===============================================================
        /*  Description: Main Controller class used for all initializations
         *  Author: Jan Mark Domingo
         *  Date Created: OCT-1-2013
         *  Input: None
         *  Return: void
         */
        public APP_MainExt(ApexPages.StandardController applicationController){
            try{
                super(applicationController);
                isDataComplete=false;//added as part of defect 1144                 
                prodId = ApexPages.currentPage().getParameters().get('prodId');
                
                if(prodId != null){
                        this.productId = prodId;
                }                
                List<Loan_Purpose__c> temporaryLoanPurposeList = new List<Loan_Purpose__c>();
                
                if(this.application.Id!=null) {
                    this.productId = this.application.Product_Id__c;
                    isJoint = isJoint();
                    isDataComplete=UserUtility.checkApplicationStatus(this.application.Id);//added as part of defect 1144
                }
                initializeLoanPurposes();
                
                /**TXU ADDED FOR DEBUG START**/
                
                system.debug('HEADER'+ApexPages.currentPage().getHeaders());
               
                System.debug('HTTP_CLIENT_IP' + ApexPages.currentPage().getHeaders().get('HTTP_CLIENT_IP'));
                System.debug('X-PRS-ClientIP is' + ApexPages.currentPage().getHeaders().get('X-PRS-ClientIP'));
                System.debug('X-Salesforce-SIP is' + ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
    
                /**END**/                
                //Added for Softquote Applications 
               applicationId = ApexPages.currentPage().getParameters().get('Id');
                 system.debug('check the app Id'+applicationId);
                isSoftQuoteApp= false;
                  if(applicationId != null){

                   for( Quote__c quoteApp : [SELECT Id,Application__c, Quote_Stage__c 
                                  FROM Quote__c where Application__c=:applicationId]){
                                  
                             if(quoteApp != null &&  quoteApp.Application__c != null){
                                     isSoftQuoteApp=true;
                            }              
                       } 
                  }
                
            }
            catch(VisualforceException e){
                    Util.addMessage(ApexPages.Severity.ERROR, Label.Application_ID_Error);
            }
        }
       
        /*  Description: Retrieve/Create parentONR Id
     *  Author: Mike Lasala
     *  Date Created: JAN-24-2014
     *  Input Parameters: None
     *  Return: Id
     */
    public Id parentONRId(){
        ONR__c parentONR;
        
        List<ONR__c> onrList = [SELECT  Id 
                                FROM    ONR__c 
                                WHERE   Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                AND     recordType.Name =: GEN_OriginationsConstants.ONR_GENERAL
                                AND     Application__c =: this.application.Id
                                LIMIT   1];
                             
        if(onrList.size()<1){
            //create new onr based on meta onr if there is no existing ONR yet
            List<Meta_ONR__c> metaONR = [SELECT GeId__c
                                         FROM   Meta_onr__c 
                                         WHERE  Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                         AND    Onr_type__c =: GEN_OriginationsConstants.ONR_GENERAL];
            
            Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c; 
            Map<String,Schema.RecordTypeInfo> onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
            Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();
            
            if(!metaONR.isEmpty()){
                parentONR = new ONR__c(Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE, 
                                       RecordTypeId = onrGeneral,
                                       GeId__c = metaONR[0].geId__c,
                                       Application__c = this.application.Id);
                insert parentONR;
            }
        } else {
            parentONR = onrList.get(0);
        }
        
        return parentONR.Id;
    }
        
    /*  Description: Method called in validating Multiple Loan Purpose
     *  Author: Fel Saliba
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: N/A
    */ 
    public boolean validateFields(){
        List<Loan_Purpose__c> loanList = new List<Loan_Purpose__c>();
        totAmount = 0; 
        loanTermNotValid = false;
        paymentNotValid = false;
        loanAmountNotValid = false;
        this.loanValidationResults = true;
        
        Id onrId = parentONRId();

        calculateLoanAmountTotal();
        
        if(loanTermSelected == null || loanTermSelected == ''){
            loanTermNotValid = true;
            loanValidationResults = false;
        }
        loanFrequencySelected = 'Monthly';
        if(totAmount < 3000){
            loanAmountNotValid = true;
            loanValidationResults = false;
        }
        
        for(loanWrapper lp: loanWrapList){
            if(lp.Loan.Value__c == 'Please Select'){
                            lp.loanPurposeNotValid = true;
                            this.loanValidationResults = false;
            }
            else{ 
                if(lp.validateLoan()) {
                    if(lp.loan.Application__c == null){
                        lp.setLoanApplicationAndONR(this.application.Id, onrId);
                    }
                    loanList.add(lp.loan);
                } else {
                    this.loanValidationResults = false;
                }
            }
        }
            
        if(this.loanValidationResults){
            this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.substring(0,1))*12;
            this.application.Payment_Frequency__c = loanFrequencySelected;
            this.application.Total_Loan_Amount__c = totAmount;
                
            if(!loanList.isEmpty()){
                try{
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Loan_Purpose__c.SObjectType.getDescribe().isCreateable()) {
                        upsert loanList;
                    //}
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_MainExt', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
                }
            }
                        
            try {                   
                update this.application;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_MainExt', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
            }
        }
        return this.loanValidationResults;
    }
        
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-31-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        loanValidationResults = true;
        System.debug('###save: ' + redirectTo);
        if(redirectTo == 'register' || redirectTo == 'Save'){
            validateFields();
        }
                
        PageReference ref;
        if(loanValidationResults){
            if(redirectTo == 'Refer'){
                ref = Page.APP_ReferredResponse;
            } else if(redirectTo == 'Eligibility'){
                ref = Page.APP_Eligibility;
            } else if(redirectTo == 'Income'){
                ref = Page.APP_JointIncome;
            } else if(redirectTo == 'Expense'){
                ref = Page.APP_JointExpenses;
            } else if(redirectTo == 'Personal'){
                ref = Page.APP_JointPersonalDetails;
            } else if(redirectTo == 'Assets'){
                ref = Page.APP_JointAssets;
            } else if(redirectTo == 'Debt'){
                ref = Page.APP_JointDebtAndLiabilities;
            } else if(redirectTo == 'Timeout'){
                ref = Page.APP_Timeout;           
            }else if(redirectTo == 'createUserAccount'){
                List<User> userNew = new List<User>();
                // Code Scan Fix: Adrian Recio - Hard Coded Ids
                //String profileId = '00eO0000000DrNu';
                if(this.applicant != null){
                    Applicant__c applicantPrimary = this.applicant;
                    if(applicantPrimary.Is_Primary_Applicant__c == true){
                        userNew = [SELECT       AppId__c 
                                   FROM         User 
                                   WHERE        AppId__c = :applicantPrimary.Application__c];
                    }
                }
                
                if(!userNew.isEmpty()){
                        ref = Page.APP_Register;
                } else {
                        return null;
                }
            }else if(redirectTo == 'calculateLoan'){
                if(UserInfo.getUserType() =='Guest'){
                    Util.addMessage(ApexPages.Severity.Error, ': Please save application and register');
                    return null;
                }
            }else{
                return null;
            }
            
            if(redirectTo != 'Timeout' || redirectTo != 'logout'){
                    ref.getParameters().put('id', this.application.Id);
                    ref.getParameters().put('aId', String.valueOf(this.applicant.Id));
            }
            ref.setRedirect(true);
            return ref;
        } else {
            return null;
        }
    }

     /*  Description: Redirect to APP_Register page
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference register(){

        PageReference pageRef = Page.APP_Register;
        pageRef.getParameters().put('Id',this.application.Id);
        pageRef.setRedirect(true);

        return pageRef;
    }

    /*  Description: Redirect to  logoutPage
     *  Author: Jade Serrano
     *  Date Created: 09-APR-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }
        
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /* Description: Method to call the class that handles the delete of Applicant 2.
     *  Author: Fel Saliba
     *  Date Created: JAN-30-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference deleteApplicant(){        
        IS_ApplicationDTO applicationDTO  = new IS_ApplicationDTO();
        applicationDTO.app = application;
        applicationDTO.applicant = applicant;
        applicationDTO.applicant2 = applicant2;
        
        APP_RemoveSecondApplicant removeApplicant = new APP_RemoveSecondApplicant();
        removeApplicant.deleteApplicantRecord(applicationDTO);      

        PageReference ref;
        ref = Page.APP_Main;
        ref.getParameters().put('id', String.valueOf(this.application.Id));
        ref.setRedirect(true);
        return ref;                   
    }

    /* Description: Method to call the class that handles the delete of Applicant 2.
     *  Author: Fel Saliba
     *  Date Created: JAN-30-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference addApplicant2(){        
        IS_ApplicationDTO applicationDTO  = new IS_ApplicationDTO();
        applicationDTO.app = application;
        applicationDTO.applicant2 = applicant2;
        
        try{
            //update Application
            applicationDTO.app.Application_Type__c = 'Joint';
            applicationDTO.app.Status__c = 'New';
            update applicationDTO.app;

            //insert new applicant
            applicationDTO.applicant2.Application__c = application.Id;
            insert applicationDTO.applicant2;   
        }
        catch(Exception e){
            Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_MainExt', 'Applicant__c', 'Class');
        }

        PageReference ref;
        ref = Page.APP_Eligibility;
        ref.getParameters().put('id', String.valueOf(this.application.Id));
        ref.setRedirect(true);
        return ref;                   
    }
    /*  Description: Timeout getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getTimeOut(){
      return AS_TIMEOUT;
    }
    
    /*  Description: Warning getter
     *  Author: Adrian Recio
     *  Date Created: APRIL-01-2014
     *  Input: None
     *  Return: integer
     */
    public integer getWarning(){
      return AS_WARNING;
    }
   
}