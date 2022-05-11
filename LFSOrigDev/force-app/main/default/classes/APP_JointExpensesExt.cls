/*
 * @Description: Expense Page for GE Customer UI
 * @Author: Dan Crisologo
 * @Date Created: OCTOBER-01-2013
 * @History:
   =====================================================================
        OCT-1 (Dan): Created.
        OCT-9 (Mike): Added variable for UI parameter and condition to redirect to Sales UI
        OCT-10 (Mike): Added variable and method for Timeout redirection
        NOV-25 (Mike): Updated code to latest
        DEC-03 (Mike): Removed Applicant 2
        JAN-13 (Mike): Added Applicant 2
        FEB-11 (Mike): Added tab level errors - Mike
        MAR-31 (Mat) : Refactoring of Admin Settings custom settings      
        APR-1-14(Adrian): Added warning and timeout getter methods  
   =====================================================================
 */ 
public class APP_JointExpensesExt extends APP_CommonExt {

    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public MyBudgetsExpenseWrapper expenseWrapper   {get;set;}  //Applicant 1 expense record
    public MyBudgetsExpenseWrapper expense2Wrapper  {get;set;}  //Applicant 2 expense record
    public String Mode                              {get;set;}  //Identifier whether coming from edit application or edit expense
    public String redirectTo                        {get;set;}  //Pagereference identifier
    public Boolean isJoint                          {get;set;}  //Single/Joint identifier

    public List<MyBudgetsExpenseWrapper> expenseWrapperList = new List<MyBudgetsExpenseWrapper>();  //List of expense records
    public Boolean expenseValidationResults;    //Validation flag
    
    //Better Start fields
    public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}
    public Boolean isBetterStart {get;set;}
    //Added as part of Soft quote Changes
    public Boolean isSoftQuoteFlow {get;set;}
    public Boolean isSoftQuoteEnabled {get;set;}
    public Boolean isBrokerQuote {get;set;}
    
    
    public string iPayExpenses{
        get{
            return iPayExpenses = GEN_OriginationsConstants.EXPENSE_PAY_OPTION_YES;
        }
        set;
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
    
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================
    
    /*  Description: Main Controller class used for all initializations
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: None
     *  Return: void
     */
    public APP_JointExpensesExt(ApexPages.StandardController applicationController) { 
        super(applicationController);
        
        //Soft Quote changes 2020 For Pre-populating fields: START
        isSoftQuoteFlow = false;
        isBrokerQuote = false;
        Id applicationId = (Id) ApexPages.currentPage().getParameters().get('Id');
        isSoftQuoteEnabled = SoftQuoteUtil.checkIfSoftQuoteEnabled(applicationId);
        
        if(isSoftQuoteEnabled){
            List<Quote__c> quoteList = [SELECT Id,Broker_ID__c FROM Quote__c
                                     WHERE Application__c =:  applicationId];
            if(quoteList.size() == 1){
               isSoftQuoteFlow =true;
               if(quoteList[0].Broker_ID__c != null){
                    isBrokerQuote = true;
                }
            }
        }
        Set<Id> applicantIds = new Set<Id>();
        
        if(!this.applicantList.isEmpty()){
            
            isJoint = isJoint();
            
            for(Applicant__c a: this.applicantList){
                applicantIds.add(this.applicantList[0].Id);
            }
            
            //Retrieve expense records of applicant/s
            List<Expense__c> oldExpense = retrieveAllExpenses(applicantIds);
            
            if(!oldExpense.isEmpty()){
               // Integer i = 0;

                //Assign expense records to wrapper list
                for(Expense__c e: oldExpense){
                    expenseWrapperList.add(new MyBudgetsExpenseWrapper(e, this.applicantList.get(0)));
                    //i++;
                    recomputeTotalExpense();
                }
            }else{
                //Instantiate new wrapper records
               // for(Applicant__c a: this.applicantList){
                    expenseWrapperList.add(new MyBudgetsExpenseWrapper(this.applicantList[0]));
               // }
            }
            
            expenseWrapper = expenseWrapperList.get(0);
            
           /** if(this.applicantList.size()>1){
                if(expenseWrapperList.size() > 1){
                    expense2Wrapper = expenseWrapperList.get(1);  
                }else{
                    expenseWrapperList.add(new MyBudgetsExpenseWrapper(applicantList.get(1)));
                    expense2Wrapper = expenseWrapperList.get(1);
                }
            } */
        }
        initializeLoanPurposes();
        
        // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
        isBSOfferActive = false;
        isBSOfferNZActive = false;
        bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        isBSOfferNZActive = bsoffer.BetterStartNZActive__c;
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Compute total expense
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: void
     */
   public void recomputeTotalExpense(){ 
        for(MyBudgetsExpenseWrapper mbew: expenseWrapperList){
            //DBHZL-36: Added the condition to call this method for NZ if living expenses and living expesnes internal are not passed
            if((mbew.expense.Living_Exp__c != null && mbew.expense.Living_Exp_Int__c != null && this.brand.country__c == GEN_OriginationsConstants.AU_REGION) || 
            (mbew.expense.Rent_Board_Pay_Amt__c != null && mbew.expense.Rent_Board_Pay_Int__c != null && this.brand.country__c == GEN_OriginationsConstants.NZ_REGION)){
                Boolean isRent = false;
                if(mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
                   mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
                   mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
                        isRent = true;
                }
                mbew.computeTotalExpense(isRent, this.brand.country__c);
                mbew.totalExpense = mbew.expense.Total_Exp__c;
            } else {
                mbew.totalExpense = 0;
            }
        }
    } 
    
    public void clearRentFields(){ 
        for(MyBudgetsExpenseWrapper mbew: expenseWrapperList){
            if(mbew.applicant.Res_Status__c!=GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
               mbew.applicant.Res_Status__c!=GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
               mbew.applicant.Res_Status__c!=GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
                    mbew.clearRentFields();
            }
        }
    }

    /*  Description: Validate expense record to upsert
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: void
     */
    public Boolean validateFields() {
        List<Expense__c> expenseList = new List<Expense__c>();
        String errorMessage = '';
        expenseValidationResults = true;
        recomputeTotalExpense();
        system.debug('My Expenses *** ' + expenseWrapperList);

        //this.applicantList.clear();       //MLASALA 09-SEPT-2015 commented out because unnecessary

       for(MyBudgetsExpenseWrapper mbew : expenseWrapperList){
            //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
            //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
            //Cause is still unknown
            if(String.valueOf(mbew.expense.Id) == ''){
                mbew.expense.Id = null;
            }

            if(this.applicantList.size()==1 || this.applicantList.size()==2){
                Boolean yNOption = false;
                if(mbew.yesNoOption == 'True'){
                    yNOption = true;
                }else{
                    yNOption = false;
                }            
                mbew.expense.I_Pay_All_Exp__c = yNOption;
                mbew.isCustomer = isCustomer();
            }
            
            //As per Discussion with Simon (BA DBHZL36), for NZ Customer UI we always default Pay All Exp to true, so the calculation
            //will be base on that. If later changed by staff UI then the calculation will start again.
            //if(this.brand.country__c == GEN_OriginationsConstants.NZ_REGION)
                //mbew.expense.I_Pay_All_Exp__c = true;

            expenseList.add(mbew.expense);
            mbew.applicant.Total_Expense__c = mbew.totalExpense;
                        
            Boolean isRent = false;
            if(mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
               mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
               mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
                    isRent = true;
            }
            
            if(mbew.validateExpense(isRent, this.brand.country__c)) {
                mbew.computeTotalExpense(isRent, this.brand.country__c);
                //this.applicantList.add(mbew.applicant);       //MLASALA 09-SEPT-2015 commented out because applicantList already has the applicants
            } else {
                expenseValidationResults = false;
                
                //Identify which applicant/s has errors if joint
                if(this.applicantList.size()>1){
                    if(mbew.applicant == this.applicant){
                        errorMessage = '1 tab'; 
                    } else if(mbew.applicant == this.applicant2){
                        if(errorMessage != ''){
                            errorMessage = '1 and 2 tabs';  
                        } else {
                            errorMessage = '2 tab';
                        } 
                    }
                }
            }
        }
        
        if(expenseValidationResults){
            //Successful validation
            try {
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Expense__c.SObjectType.getDescribe().isCreateable()) {
                if(this.applicantList.size()>1){
                system.debug('Entered Applicant 2$');
                Expense__c exp = new Expense__c();
                 exp.Applicant__c = this.applicant2.id;
                 expenseList.add(exp);  
                 system.debug('expense list$$'+expenseList);
                }
                    upsert expenseList;
                //}
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointExpenseExt', 'Expense__c', 'Class', String.valueOf(this.application.Id));    
            }

            try {
              if(this.applicantList.size()>1){
                
                this.applicant2.Res_Status__c= this.applicant.Res_Status__c;
              }
                update applicantList;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointExpenseExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));    
            }
        } else {
            //Display error if joint
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return this.expenseValidationResults;
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
           
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        // Check application status before any updates and redirect
        List<Application__c>applicationVar = [Select Id, Status__c from Application__c where Id = :application.Id];
        
        // Validate that application is not yet submitted
        if(applicationVar.size()>0){
            if(applicationIsSubmitted(applicationVar[0])){
                Util.addMessage(ApexPages.Severity.ERROR, 'Sorry this application has already been submitted and the application details are not editable.');
                return null;
            }
        }
        
        this.expenseValidationResults = true;
        
        //BEGIN MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
        //Added back redirection
        if(redirectTo == 'Save' || 
           redirectTo == 'Back'){
            validateFields();
        }else if(redirectTo == 'Timeout'){
            this.loanValidationResults = true;
        }
        
        PageReference ref;
        if(this.expenseValidationResults && this.loanValidationResults){
            if(redirectTo == 'Save'){
                UserUtility userUtility = new UserUtility();
                ref = userUtility.createCommunityUser(this.application, this.applicant);
            } else if(redirectTo == 'Timeout'){
                ref = Page.APP_Timeout;
            } else if(redirectTo == 'Back'){
                ref = backPage();
            }
            //END MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
            
            ref.setRedirect(true);            
            return ref;
        } else {
            return null;
        }
    }

}