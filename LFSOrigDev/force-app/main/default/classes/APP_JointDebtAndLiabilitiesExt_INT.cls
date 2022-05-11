/* @Description: Controller for Joint Application Debts (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: NOV-20-2013
 * @History:
   =====================================================================
       11-20-13: Created - Mike
       12-02-13: Applied single list of Debts - Mike
       01-15-14: Refactored to cater single and joint application
       01-30-14: Refactored to cater component
       08-13-15: Set Auto Create Flag to FALSE after debt is updated - DY
       08-14-15: Remove code that automatically assign total debt based on applicant's total debt field - DY
   =====================================================================
 */ 
public with sharing class APP_JointDebtAndLiabilitiesExt_INT extends APP_CommonExt{
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<MyBudgetsDebtWrapper> debtAddList   {get;set;}  //Debt record list
    public Integer debtListSize                     {get;set;}  //Debt record list size
    public Decimal totalDebt                        {get;set;}  //Total debt value
    public String Mode                              {get;set;}  //Identifier whether coming from edit application or edit debt
    public String redirectTo                        {get;set;}  //Pagereference identifier
    public Integer selectedRow                      {get;set;}  //Specific row/record to be deleted
    
    public List<Liability__c> debtListToDel = new List<Liability__c>();     //Debt record list for deletion
    public Boolean debtValidationResults;                                   //Validation flag
    public Boolean isJoint;                                                 //Single/Joint identifier
    public String confirmLumpSum                   {get;set;}
    public String confirmLumSumpFlag                {get;set;}
    
    public APP_JointDebtAndLiabilitiesExt_INT(ApexPages.StandardController applicationController) {
       super(applicationController);
        //To identify whether to show/hide back and next buttons
        Mode = ApexPages.currentPage().getParameters().get('mode');
        isJoint = isJoint();
        totalDebt = 0;
        
        List<Liability__c> oldDebts = new List<Liability__c>();
        
        //Retrieve debt records of applicant/s
        oldDebts = retrieveDebtList(this.applicant.Id);
        if(this.applicantList.size() > 1){
            oldDebts.addAll(retrieveDebtList(this.applicant2.Id));
        }
        
        if(!oldDebts.isEmpty()){
            //Set data to Debt wrapper
            debtAddList = new List<MyBudgetsDebtWrapper>();            
            for(Liability__c l:oldDebts){
                MyBudgetsDebtWrapper mbdw = new MyBudgetsDebtWrapper(l);
                mbdw.debt = l;
                mbdw.isJoint = isJoint;
                debtAddList.add(mbdw);              
            }           
            debtListSize = oldDebts.size();
            refreshCount();
        } else {
            //Instantiate new wrapper records
            debtAddList = new List<MyBudgetsDebtWrapper>();
            debtListSize=0;
            addDebt();
        }
        debtValidationResults = true;
        
         if(applicant.is_Lump_Sum_Debt__c == true){
         confirmLumpSum = 'YES';
         confirmLumSumpFlag = 'YES';
        }else if(applicant.is_Lump_Sum_Debt__c == false && oldDebts.size() > 0){
         confirmLumpSum = 'NO';
         confirmLumSumpFlag = 'NO';
        }
        //BEGIN - DYU 14-AUG-2015 - REMOVE CODE TO DISPLAY CORRECT TOTAL DEBT AMOUNT
        /*if(this.applicant.Total_Debts__c != null){
            totalDebt = this.applicant.Total_Debts__c;
        }*/
        //END - DYU 14-AUG-2015 
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Add new Liability record
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addDebt(){
        MyBudgetsDebtWrapper mybudgDebt = new MyBudgetsDebtWrapper(this.applicant);
        mybudgDebt.isJoint = isJoint;
        debtAddList.add(mybudgDebt);
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
                system.debug('selected row: '+selectedRow+'--'+deb.rowCount+'--'+deb.debt.Id);
                if(selectedRow == deb.rowCount && deb.debt.Id != null){
                    debtListToDel.add(debtAddList.get(selectedRow).debt);
                    break;
                }
            }
        }

        try{
            debtAddList.remove(selectedRow);
        } catch(ListException e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));
        }
        
        debtListSize--;
        getTotalDebt();
        if(debtListSize==0){
            addDebt();
        }
        refreshCount();
    }
    
    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-15-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshCount(){
        system.debug('debtAddList: '+debtAddList.size());
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

        for(MyBudgetsDebtWrapper debtWrap: debtAddList) {
            
            //BEGIN - DYU 13-AUG-2015 - REMOVE FLAG IF DEBT IS ALREADY UPDATED
            debtWrap.debt.Debt_Auto_Created__c = false; 
            //END - DYU 13-AUG-2015

            if(debtWrap.debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT && 
               debtWrap.debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD && 
               debtWrap.debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD && 
               debtWrap.debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){

                debtWrap.debt.Type_of_Credit_Card__c = null;
            }
            system.debug('test credit card type: '+debtWrap.debt.Type_of_Credit_Card__c);
            if(debtWrap.debt.Type_of_Credit_Card__c == GEN_OriginationsConstants.FIN_INTSTITUTION_KIWI_BANK)
                debtWrap.debt.Financier_Name__c = GEN_OriginationsConstants.FIN_INTSTITUTION_KIWI_BANK;
                
            //if(debtWrap.debt.Debt_Category__c!='None' &&
            //   debtWrap.debt.Financier_Name__c!=null && debtWrap.debt.Financier_Name__c!=''){

                if(debtWrap.validateDebt(false, this.brand.country__c)) {
                    debtWrap.debt.Total_Debts__c = debtWrap.getDebtTotalAmount(this.brand.country__c);
                    debtWrap.clearDebtFields();
                    
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
            //}
        }
        system.debug('debt validation results: '+debtValidationResults);
        //insert all debts if results are valid
        if(debtValidationResults) {
            
            try {
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Liability__c.SObjectType.getDescribe().isCreateable()) {
                    upsert debtList;
                //}
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));          
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
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Liability__c', 'Class', String.valueOf(this.application.Id));
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
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }
            
            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointDebtAndLiabilitiesExt', 'Application__c', 'Class', String.valueOf(this.application.Id));
            }
            
        }
        
        return debtValidationResults;
    }
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        debtValidationResults = true;
        
        if(redirectTo == 'Save' || redirectTo == 'Next'){
            validateFields();
        }
        
        PageReference ref;
        if(debtValidationResults){
            if(redirectTo == 'Back'){
                ref = Page.APP_JointExpenses_INT;
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
    
    /* Description: Get the Total Debt of the applicant.
     *  Author: Fel Saliba
     *  Date Created: OCT-2-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public void getTotalDebt() {
       system.debug('Get total Debt method entry.');
       if(!debtAddList.isEmpty()){
            totalDebt= 0;
            for(MyBudgetsDebtWrapper mbdw: debtAddList) {
                if((mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) && mbdw.debt.Credit_Limit_Amt__c != null && mbdw.debt.Card_Overdraft_Bal_Amt__c != null){
                    system.debug('credit card');
                    totalDebt= totalDebt+ mbdw.getDebtTotalAmount(this.brand.country__c);
                }else if(mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
                    if(mbdw.debt.Overdraft_APR__c == null){
                        mbdw.debt.Overdraft_APR__c = 0;//updated as per defect 1161
                    }
                    
                    if(mbdw.debt.Credit_Limit_Amt__c != null && mbdw.debt.Overdraft_APR__c != null && mbdw.debt.Card_Overdraft_Bal_Amt__c != null){
                        system.debug('Over draft');
                        totalDebt= totalDebt+ mbdw.getDebtTotalAmount(this.brand.country__c);
                    }
                }else if(mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE && mbdw.debt.Mortgage_Repayment_Amt__c != null && (mbdw.debt.Mortgage_Repayment_Interval__c != null && mbdw.debt.Mortgage_Repayment_Interval__c != '' && mbdw.debt.Mortgage_Repayment_Interval__c != 'None' )) {
                    system.debug('Mortgage');
                    totalDebt= totalDebt+ mbdw.getDebtTotalAmount(this.brand.country__c);                    
                }else if((mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN || mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) && mbdw.debt.Car_Personal_Repay_Amt__c != null ) {
                    system.debug('Personal Loan');
                    totalDebt= totalDebt+ mbdw.getDebtTotalAmount(this.brand.country__c);
                    system.debug('Total debt ' + totalDebt);
                }else if(mbdw.debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER && mbdw.debt.Other_Repay_Amt__c != null){
                    system.debug('Others');
                    totalDebt= totalDebt + mbdw.getDebtTotalAmount(this.brand.country__c);
                } else {
                    totalDebt= totalDebt+ 0;
                }
            }
            totalDebt = totalDebt.setScale(2);
        }
    }
}