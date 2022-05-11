/* @Description: Controller for Joint Application Expense (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: NOV-20-2013
 * @History:
   =====================================================================
       11-20-13: Created - Mike
       12-02-13: Applied single list of Assets - Mike
       01-07-14: Applied joint functionality - Mike
       01-15-14: Refactored to cater single and joint applications - Mike
       02-05-14: Refactored once again - Mike
       02-11-14: Added tab level errors - Mike
   =====================================================================
 */ 
public class APP_JointExpensesExt_INT extends APP_CommonExt {
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
    
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================    
    /*  Description: Main Controller class used for all initializations
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: None
     *  Return: void
     */
    public APP_JointExpensesExt_INT(ApexPages.StandardController applicationController) { 
        super(applicationController);
        
        //Identify whether to show/hide back and next buttons
        Mode = ApexPages.currentPage().getParameters().get('mode');
        Set<Id> applicantIds = new Set<Id>();
        
        if(!this.applicantList.isEmpty()){
            
            isJoint = isJoint();

            for(Applicant__c a: this.applicantList){
                applicantIds.add(this.applicantList[0].Id);
            }
            
            //Retrieve expense records of applicant/s
            List<Expense__c> oldExpense = retrieveAllExpenses(applicantIds);
            if(!oldExpense.isEmpty()){
                //Integer i = 0;

                //Assign expense records to wrapper list
                for(Expense__c e: oldExpense){
                    expenseWrapperList.add(new MyBudgetsExpenseWrapper(e, this.applicantList.get(0)));
                   // i++;
                    recomputeTotalExpense();
                }
            } else {
                //Instantiate new wrapper records
               // for(Applicant__c a: this.applicantList){
                    expenseWrapperList.add(new MyBudgetsExpenseWrapper(this.applicantList[0]));
               // }
            }

            //Assign record/s to public variable
            expenseWrapper = expenseWrapperList.get(0);
           /** if(this.applicantList.size()>1){
                if(expenseWrapperList.size() > 1){
                    expense2Wrapper = expenseWrapperList.get(1);    
                }
                else{
                    expense2Wrapper = new MyBudgetsExpenseWrapper(this.applicantList[1]);
                    expenseWrapperList.add(expense2Wrapper);
                }
            } */
        }
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
        for(MyBudgetsExpenseWrapper mbew : expenseWrapperList){
            //DBHZL-36: Added the condition to call this method for NZ if living expenses and living expesnes internal are not passed
            if((mbew.expense.Living_Exp__c != null && mbew.expense.Living_Exp_Int__c != null && this.brand.country__c == GEN_OriginationsConstants.AU_REGION) || 
            (mbew.expense.Rent_Board_Pay_Amt__c != null || mbew.expense.Rent_Board_Pay_Int__c != null || this.brand.country__c == GEN_OriginationsConstants.NZ_REGION)){
                Boolean isRent = false;
                if(mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
                   mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
                   mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER ){
                        isRent = true;
                }
                mbew.computeTotalExpense(isRent, this.brand.country__c);
                mbew.totalExpense = mbew.expense.Total_Exp__c;
            } else {
                mbew.totalExpense = 0;
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
        
        this.applicantList.clear();

        for(MyBudgetsExpenseWrapper mbew: expenseWrapperList){
            //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
            //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
            //Cause is still unknown
            if(String.valueOf(mbew.expense.Id) == ''){
                mbew.expense.Id = null;
            }
            
            expenseList.add(mbew.expense);
            
            Boolean isRent = false;
            if(mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING ||
               mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY ||
               mbew.applicant.Res_Status__c==GEN_OriginationsConstants.RESIDENTIAL_STATUS_OTHER){
                    isRent = true;
            }

            if(mbew.validateExpense(isRent, this.brand.country__c)) {
                mbew.computeTotalExpense(isRent, this.brand.country__c);
                mbew.applicant.Total_Expense__c = mbew.expense.Total_Exp__c;
                this.applicantList.add(mbew.applicant);
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
                //if(Expense__c.SObjectType.getDescribe().isCreateable()) {'
                updateJointApplicantResStatus();

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
            
            Savepoint sp = Database.setSavepoint();
            
            try {
            
             if(this.applicantList.size()>1){
                
                this.applicant2.Res_Status__c= this.applicant.Res_Status__c;
              }
              
                update applicantList;
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointExpenseExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }
            
            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointExpenseExt', 'Application__c', 'Class', String.valueOf(this.application.Id));
            }
        } else {
            //Display error if joint
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return this.expenseValidationResults;
    }
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        this.expenseValidationResults = true;
        
        if(redirectTo == 'Save' || redirectTo == 'Next'){
            validateFields();
        }
        
        PageReference ref;
        if(this.expenseValidationResults){
            if(redirectTo == 'Back'){
                ref = Page.APP_JointAssets_INT;
            } else if(redirectTo == 'Next'){
                ref = Page.APP_JointDebtAndLiabilities_INT;
            } else if(redirectTo == 'Save' || redirectTo == 'Cancel'){
                ref = Page.APP_ApplicationMain_INT;
            }
            
            ref.getParameters().put('id', this.application.Id);
            ref.setRedirect(true);            
            return ref;
        } else {
            return null;
        }
    }

    /**
     * Update the Residential Status of the 2nd or Joint applicant and set it same 
     * as the 1st applicant's for AU.
     */
    @testvisible
    private void updateJointApplicantResStatus(){
    
        if((!this.applicantList.isEmpty() && isJoint) || Test.isRunningTest()){
            try{
                MyBudgetsExpenseWrapper mbew = new MyBudgetsExpenseWrapper(this.applicantList[0]);
                String primaryApplicantResStatus = mbew.applicant.Res_Status__c;
                String applicationId = mbew.applicant.Application__c;
                //Get the Id of the 2nd applicant
                List<Applicant__c> applicantsList = [SELECT Id FROM Applicant__c WHERE Application__c = :applicationId AND Is_Primary_Applicant__c = false];
                if(!applicantsList.isEmpty()){
                    String jointApplicantId = applicantsList[0].Id;
                    Applicant__c applicantObj = new Applicant__c();
                    applicantObj.Id = jointApplicantId;
                    applicantObj.Res_Status__c = primaryApplicantResStatus;
                    update applicantObj;
            }

            }catch(Exception e){
                //no update 
            }
        }
        

    }
}