/*
 * @Description: Joint Debt and Liabilites Class for GE Customer UI
 * @Author: Fel Saliba
 * @Date Created: OCTOBER-01-2013
 * @History:
   =====================================================================
        OCT-01-13 (Fel): Created.
        OCT-02-13 (Fel): Added computation for Total Debt.
        OCT-09-13 (Mike): Added variable for UI parameter and condition to redirect to Sales UI
        OCT-10-13 (Mike): Added variable and method for Timeout redirection
        NOV-25-13 (Mike): Updated code to latest
        DEC-03-13 (Mike): Removed Applicant 2
        JAN-13-14 (Mike): Removed in the name of logic
        MAR-25-14 (Mike): Added debts exemption
        MAR-31-14 (Mat) : Refactoring of Admin Settings custom settings
        APR-1-14(Adrian): Added warning and timeout getter methods   
   =====================================================================
 */ 
public class APP_JointDebtAndLiabilitiesExt extends APP_CommonExt{ 
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<MyBudgetsDebtWrapper> debtAddList   {get;set;}  //Debt record list
    public Integer debtListSize                     {get;set;}  //Debt record list size
    public String redirectTo                        {get;set;}  //Pagereference identifier
    public Integer selectedRow                      {get;set;}  //Specific row/record to be deleted
    public Boolean isCustomer                       {get;set;}  //Customer/Staff identifier
    
    public List<Liability__c> debtListToDel = new List<Liability__c>();     //Debt record list for deletion
    public Decimal totalDebt;                                               //Total debt value
    //MLASALA 12-SEPT-16 TQLQW-483 - Gen 2 App form 
    //Added get set
    public Boolean debtValidationResults            {get;set;}              //Validation flag

    //Better Start fields
    public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}
    public Boolean isBetterStart {get;set;}
    //Soft quote fields
     public Boolean isSoftQuoteApp {get;set;}
    public String confirmLumpSum {get;set;}
    public String confirmLumSumpFlag {get;set;}
    public Boolean confirmRepayFlag {get;set;}
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
    
    public APP_jointDebtAndLiabilitiesExt(ApexPages.StandardController applicationController) {
        super(applicationController);
        
        totalDebt = 0;
        isCustomer = isCustomer();
        //Soft Changes 2020: Start
        isSoftQuoteApp = false;
        String appId =this.application.Id;
        List<Quote__c> quoteList = new  List<Quote__c>();
        quoteList =[select id,Application__c from Quote__c where Application__c = :appId];
        if(quoteList.size() > 0){
           isSoftQuoteApp = true; 
        }
        //Soft Changes 2020: End
        
        List<Liability__c> oldDebts = new List<Liability__c>();
        //Retrieve debt records of applicant/s
        oldDebts = retrieveDebtList(this.applicant.Id);
        
        if(applicant.is_Lump_Sum_Debt__c == true){
         confirmLumpSum = 'YES';
         confirmLumSumpFlag = 'YES';
        }else if(applicant.is_Lump_Sum_Debt__c == false && oldDebts.size() > 0){
         confirmLumpSum = 'NO';
         confirmLumSumpFlag = 'NO';
        }
        
        
        if(this.applicantList.size() > 1){
            oldDebts.addAll(retrieveDebtList(this.applicant2.Id));
        }

        if(!oldDebts.isEmpty()){
            //Set data to Debt wrapper
            debtAddList = new List<MyBudgetsDebtWrapper>();            
            for(Liability__c l:oldDebts){
                MyBudgetsDebtWrapper mbdw = new MyBudgetsDebtWrapper(l);
                mbdw.debt = l;
                debtAddList.add(mbdw);
                
                if(l.Total_Debts__c != null){
                    totalDebt += l.Total_Debts__c;
                }
            }           
            debtListSize = oldDebts.size();
            refreshCount();
        } else {
            //Instantiate new wrapper records
            debtAddList = new List<MyBudgetsDebtWrapper>();
            debtListSize=0;
            if(!this.applicant.Debts_Exempt__c){
                addDebt();
            }
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
    /*  Description: Add new Liability record for Applicant 1
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addDebt(){
        debtAddList.add(new MyBudgetsDebtWrapper(this.applicant));
        debtListSize++;
        refreshCount();
    }
    
    /*  Description: Remove selected Income record
     *  Author: Mike Lasala
     *  Date Created: JAN-15-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void removethisDebt(){
        for(MyBudgetsDebtWrapper deb: debtAddList){
            //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
            //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
            //Cause is still unknown
            if(String.valueOf(deb.debt.Id) != ''){
                if(selectedRow == deb.rowCount && deb.debt.Id != null){
                    debtListToDel.add(debtAddList.get(selectedRow).debt);
                    break;
                }
            }
        }
        debtAddList.remove(selectedRow);
        debtListSize--;
        getTotalDebt();
        if(debtListSize==0){
            addDebt();
        }
        refreshCount();
    }
    
    /*  Description: Remove all debts
     *  Author: Mike Lasala
     *  Date Created: MAR-25-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void removeAllDebts(){
        if(this.applicant.Debts_Exempt__c){
            if(!debtAddList.isEmpty()){
                for(Integer i = 0; i<debtListSize; i++){
                    //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                    //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                    //Cause is still unknown
                    if(String.valueOf(debtAddList.get(i).debt.Id) != ''){
                        if(debtAddList.get(i).debt.Id!=null) {
                            debtListToDel.add(debtAddList.get(i).debt);
                        }
                    }
                }
            }
            debtAddList.clear();
            debtListSize = 0;
        } else {
            addDebt();
        }
        getTotalDebt();
    }

    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-15-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshCount(){
        Integer i = 0;
        for(MyBudgetsDebtWrapper deb: debtAddList){
            deb.rowCount = i;
            i++;
        }
        getTotalDebt();
    }
    
    /*  Description: Validate Liability records to upsert
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public boolean validateFields() {
        debtValidationResults = true;
        List<Liability__c> debtList = new List<Liability__c>();
        Decimal applicantTotalDebts = 0;
        Decimal totalDebts = 0;
        
        if(!this.applicant.Debts_Exempt__c){
            for(MyBudgetsDebtWrapper debtWrap: debtAddList) {
                
                //setting up hidden fields from the Customer UI that are used in Staff UI.
                if(debtWrap.validateDebt(isCustomer,this.brand.country__c)) {
                    if(debtWrap.debt.type_of_credit_card__c == GEN_OriginationsConstants.FIN_INTSTITUTION_KIWI_BANK)
                        debtWrap.debt.Financier_Name__c = GEN_OriginationsConstants.FIN_INTSTITUTION_KIWI_BANK;
                    if(debtWrap.debt.Acknowledge_Payout__c){
                        debtWrap.debt.Consolidate_Debt_Reduce_Limit__c = GEN_OriginationsConstants.DEBT_CONSOLIDATE;
                    }
                    debtWrap.debt.Total_Debts__c = debtWrap.getDebtTotalAmount(this.brand.country__c);
                    debtWrap.clearDebtFields();
                    System.debug('###debtWrap.debt.Total_Debts__c: ' + debtWrap.debt.Total_Debts__c);
                    applicantTotalDebts = applicantTotalDebts + debtWrap.debt.Total_Debts__c;
                    //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                    //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                    //Cause is still unknown
                    if(String.valueOf(debtWrap.debt.Id) == ''){
                        debtWrap.debt.Id = null;
                    }
                    debtList.add(debtWrap.debt);
                } else {
                    debtValidationResults = false;
                }
            }
        } else {
            debtAddList.clear();
        }

        //insert all debts if results are valid
        if(debtValidationResults) {
            
            if(!debtList.isEmpty()){
                try {
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Liability__c.SObjectType.getDescribe().isCreateable()) {
                        upsert debtList;
                    //}
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));          
                }
            }
            
            Savepoint sp = Database.setSavepoint();
            
            if(debtListToDel.size()>0) {          
                try {           
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Liability__c.sObjectType.getDescribe().isDeletable()){
                        delete debtListToDel;
                    } 
                    */
                    delete debtListToDel;      
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));          
                }           
            }
            
            try {
                applicant.Total_Debts__c = applicantTotalDebts;
                if(confirmLumSumpFlag == 'YES'){
                applicant.is_Lump_Sum_Debt__c = true;
                }else{
                applicant.is_Lump_Sum_Debt__c = false;
                }
                update applicant;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }            
        }
        
        return debtValidationResults;
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
        
        debtValidationResults = true;
        
        //BEGIN MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
        //Added back redirection
        if(redirectTo == 'Save' || 
           redirectTo == 'Back'){
            validateFields();
        }else if(redirectTo == 'Timeout'){
            this.loanValidationResults = true;
        }
        
        PageReference ref;
        if(debtValidationResults && this.loanValidationResults){
            if(redirectTo == 'Save'){
                //BEGIN MLASALA 12-SEPT-16 TQLQW-483 - Gen 2 App form
                //Remove redirection to APP_Main
                //UserUtility userUtility = new UserUtility();
                //ref = userUtility.createCommunityUser(this.application, this.applicant);
                
                return null;
                //END MLASALA 12-SEPT-16 TQLQW-483 - Gen 2 App form
            } else if(redirectTo == 'Timeout'){
                ref = Page.APP_Timeout;
            } else if(redirectTo == 'Back'){
                ref = backPage();
            }
            //END MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
            
            ref.getParameters().put('id', this.application.Id);
            ref.setRedirect(true);
            return ref;
        } else {
            return null;
        }
    }
    
    /* Description: Get the Total Debt of the applicant.
     *  Author: Fel Saliba
     *  Date Created: OCT-2-2013
     *  Input Parameters: None
     *  Return: N/A
     */    
    public void getTotalDebt() {
       if(!debtAddList.isEmpty()){
            totalDebt = 0;
            for(MyBudgetsDebtWrapper mbdw: debtAddList) {
                if((mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT) && mbdw.debt.Card_Overdraft_Bal_Amt__c !=  null ) {
                    totalDebt = totalDebt + mbdw.getDebtTotalAmount(this.brand.country__c);
                }else if(mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE && mbdw.debt.Mortgage_Bal_Amt__c != null ) {
                    totalDebt = totalDebt + mbdw.getDebtTotalAmount(this.brand.country__c);
                } else if((mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN) && mbdw.debt.Car_Personal_Bal_Amt__c != null ) {
                    totalDebt = totalDebt + mbdw.getDebtTotalAmount(this.brand.country__c);
                } 
                else if(mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER){
                    totalDebt = totalDebt + mbdw.getDebtTotalAmount(this.brand.country__c);
                }
                else {
                    totalDebt = totalDebt + 0;
                }  
            }
       }
    }
}