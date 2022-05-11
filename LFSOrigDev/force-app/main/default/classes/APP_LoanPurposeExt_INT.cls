/*
 * @Description: Controller for Loan Purpose (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: OCT-24-2013
 * @History:
   =====================================================================
       10-24-13: Created - Mike
       01-23-14: Refactored - Mike
       03-28-14: Finalized Refinance feature - Mat
       11-25-14 DBHZL-54 Eligibility Copy & Acknowledgements -Vijay   
       2015-06-17	DBHZL386 Retrieve Payoff Quote - Tony Xu
   =====================================================================
 */
public class APP_LoanPurposeExt_INT extends APP_CommonExt {

    public String Mode                      {get;set;}
    public String redirectTo                {get;set;}
    public Integer selectedRow              {get;set;}

    public List<Loan_Purpose__c> loanListToDel = new List<Loan_Purpose__c>();
    
    //Added By Vijay
    public string region{get;set;}
    
    //===============================================================
    //                       Disbursement Variables
    //===============================================================
    public DisbursementWrapper currentDisbursementWrapper {get; set;}
    public Boolean bDisplayDisbursementPopup {get; set;}     
    public Boolean bAccountNumberOK {get; set;}  
    public List<Disbursement__c> upsertDisbursementList {get; set;}
    public List<Disbursement__c> deleteDisbursementList {get; set;}
    public Id recTypeIdRefinance {get; set;} 
    public Map<Integer, Loan_Purpose__c> externalIdLoanPurposeMap {get;set;}
    public String sErrorMessage {get; set;}
    
    //DBHZL386
    public String retrievalDate                                     {get;set;}
    public Decimal validLPAmount                                    {get;set;}  //ADDED RCADAPAN @ 08-MAR-2016 for TQLQW-29
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Main Controller class used for all initializations
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-1-2013
     *  Input: None
     *  Return: void
     */
    public APP_LoanPurposeExt_INT(ApexPages.StandardController applicationController){
        super(applicationController);
        
        Mode = ApexPages.currentPage().getParameters().get('mode');
        //Added by Vijay
        region=ApexPages.currentPage().getParameters().get('country');
        if(this.application.Id!=null){
            this.productId = this.application.Product_Id__c;
        }
        
        //DBHZL386
        retrievalDate = Date.today().format();
        
        totAmount = 0;
        loanWrapList = new List<loanWrapper>();
        List<Loan_Purpose__c> temporaryLoanPurposeList = retrieveLoanPurposeList();
        system.debug('@@@temporaryLoanPurposeList: ' + temporaryLoanPurposeList);

        // Disbursement Refinance
        bDisplayDisbursementPopup = false;
        recTypeIdRefinance = [select Id from RecordType where SObjectType = 'Disbursement__c' and Name = 'Re-Finance' limit 1].Id;
        initializeDisbursement();
        externalIdLoanPurposeMap = new Map<Integer, Loan_Purpose__c>(); 
        upsertDisbursementList = new List<Disbursement__c>();
        deleteDisbursementList = new List<Disbursement__c>();
        //List<Disbursement__c> tempDisbursementList = retrieveRefinanceDisbursementList();
        List<Disbursement__c> tempDisbursementList = retrieveDisbursementList();
        system.debug('@@@tempDisbursementList: ' + tempDisbursementList);
        sErrorMessage = '';
        // Disbursement Refinance
        
        if(!temporaryLoanPurposeList.isEmpty()){
            if(this.application.Loan_Term__c != null){
                loanTermSelected = this.application.Loan_Term__c;
            }
            if(this.application.Payment_Frequency__c != null){
                loanFrequencySelected = this.application.Payment_Frequency__c;  
            }
            
            loanWrapList = new List<loanWrapper>();
            for(Loan_Purpose__c lp: temporaryLoanPurposeList) {
                loanWrapper lw = new loanWrapper();
                lw.loan = lp;

                // Refinance - Update the LoanWrapperList with existing Disbursement record/s
                if (!tempDisbursementList.isEmpty()) {
                    for (Disbursement__c disb : tempDisbursementList) {
                        if (disb.Loan_Purpose__c == lp.Id) {
                            lw.disbursement = disb;
                            break;
                        }
                    }                    
                }
                // Refinance

                loanWrapList.add(lw);
                if(lp.Loan_Amount__c != null){
                    totAmount += lp.Loan_Amount__c;
                }
            }
            refreshLoanCount();
            loanPurposeSize = temporaryLoanPurposeList.size();
        } else {
            loanWrapList = new List<loanWrapper>();
            loanPurposeSize = 0;
            addLoanPurpose();
        }
        
        loanValidationResults = true;
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //=============================================================== 
    /*  Description: Remove selected Loan Purpose record
     *  Author: Mike Lasala
     *  Date Created: JAN-23-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void removethisLoan(){
        if(!loanWrapList.isEmpty()){
            for(loanWrapper loa: loanWrapList){
                if(selectedRow == loa.rowCount && loa.loan.Id != null){
                    loanListToDel.add(loanWrapList.get(selectedRow).loan);
                    // To delete the related Disbursement record
                    if (loa.disbursement.Id != null) {
                        deleteDisbursementList.add(loanWrapList.get(selectedRow).disbursement);
                    }
                }
            }

            loanWrapList.remove(selectedRow);
            loanPurposeSize--;
            calculateLoanAmountTotal();
            if(loanPurposeSize==0){
                addLoanPurpose();
            }
            refreshLoanCount();
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
    
    /*  Description: Validate loan purpose records to upsert
     *  Author: Mike Lasala
     *  Date Created: JAN-23-2014
     *  Input Parameters: None
     *  Return: Boolean
     */
    public boolean validateFields() {
        system.debug('###validateFields()');
        List<Loan_Purpose__c> loanList = new List<Loan_Purpose__c>();
        List<Disbursement__c> disbursementList = new List<Disbursement__c>();
        totAmount = 0;
        loanTermNotValid = false;
        paymentNotValid = false;
        loanAmountNotValid = false;
        loanValidationResults = true;
                
        Id onrId = parentONRId();
        
        calculateLoanAmountTotal();
        
        if(loanTermSelected == null || loanTermSelected == ''){
            loanTermNotValid = true;
            loanValidationResults = false;
        }
        if(loanFrequencySelected == null || loanFrequencySelected == ''){
            paymentNotValid = true;
            loanValidationResults = false;
        }

        //Start - UPDATED RCADAPAN 08-MAR-2016 for TQLQW-29 - Reduce Total Loan Amount to 2 Grand for NZ Applications
        validLPAmount = GEN_OriginationsConstants.AU_VALID_LOAN_TOTAL_AMOUNT;
        if(this.application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
            validLPAmount = GEN_OriginationsConstants.NZ_VALID_LOAN_TOTAL_AMOUNT;
        }

        if(totAmount < validLPAmount){
            loanAmountNotValid = true;
            loanValidationResults = false;
        }
        //End TQLQW-29
        
        for(loanWrapper lp: loanWrapList){
            if(lp.validateLoan()) {
                if(lp.loan.Application__c == null){
                    lp.setLoanApplicationAndONR(this.application.Id, onrId);
                }
                loanList.add(lp.loan);
                // Map the ExternalId to Loan Purpose
                disbursementList.add(lp.disbursement);
                externalIdLoanPurposeMap.put(lp.rowCount, lp.loan);
            } else {
                loanValidationResults = false;
            }
        }

        Boolean bError = validateLoanPurposeRefinance();
        if (bError) {
            sErrorMessage = 'Refinance cannot be the first Loan Purpose';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, sErrorMessage));
            loanValidationResults = false;
        }
        
        if(loanValidationResults){
            
            if(loanTermSelected != null){
                this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*
                (loanTermSelected.ToLowerCase().contains('months')?1:12);

                this.application.Loan_Term__c = loanTermSelected;
            }
            if(Util.nullCheck(loanFrequencySelected)){   //05.14.15 Mike Lasala: Code Scan fix
                this.application.Payment_Frequency__c = loanFrequencySelected;  
            }
            if(totAmount != 0){
                this.application.Total_Loan_Amount__c = totAmount;  
            }

            // Use Map upsert instead of List upsert to preserve mapping information (ID and Loan_Purpose__c) 
            if(!externalIdLoanPurposeMap.isEmpty()){
                try{
                    upsert externalIdLoanPurposeMap.values();
                    system.debug('@@@ upsert externalIdLoanPurposeMap');
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));    
                }
            }  

            // Associate Disbursement to corresponding Loan Purpose
            for(loanWrapper lw: loanWrapList) {
                if (lw.disbursement != null && lw.loan.Value__c == 'Refinance') {
                    if (externalIdLoanPurposeMap.containsKey(lw.rowCount)) {
                        lw.disbursement.Loan_Purpose__c = externalIdLoanPurposeMap.get(lw.rowCount).Id; 
                        lw.disbursement.Amount__c = externalIdLoanPurposeMap.get(lw.rowCount).Loan_Amount__c;  
                        upsertDisbursementList.add(lw.disbursement);  
                    }
                }
            }

            if (!upsertDisbursementList.isEmpty()) {
                try {
                    System.debug('upsertDisbursementList--->'+upsertDisbursementList);
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Disbursement__c.SObjectType.getDescribe().isCreateable()) {
                        upsert upsertDisbursementList;
                    //}
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_LoanPurposeExt_INT', 'Disbursement_c', 'Class', String.valueOf(this.application.Id));    
                }
            }

            SavePoint sp = Database.setSavePoint();
            
            if(!loanListToDel.isEmpty()){
                try{
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Loan_Purpose__c.sObjectType.getDescribe().isDeletable()){
                        delete loanListToDel;
                    }
                    */
                    delete loanListToDel;
                }
                catch(DMLException e){
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
                }
            }

            // Delete related disbursement record/s
            if(!deleteDisbursementList.isEmpty()){
                try{
                    delete deleteDisbursementList;
                }
                catch(DMLException e){
                    setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
                }
            }            
            
            try {                   
                update this.application;
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
            }
            
            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_LoanPurposeExt_INT', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
            }
        }
        return loanValidationResults;
    }
    
    /*  Description: Page Redirection to Next only used in Post submit
     *  Author: Fel Saliba
     *  Date Created: Jyly-11-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference redirectNext(){
        
        PageReference ref = Page.APP_JointPersonalDetails_INT;
        ref.getParameters().put('id', this.application.Id);
        ref.setRedirect(true);          
        return ref;
    }
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        loanValidationResults = true;
        
        if(redirectTo == 'Save' || redirectTo == 'Next'){
            validateFields();
        }
        
        PageReference ref;
        if(loanValidationResults){
            if(redirectTo == 'Back'){
                ref = Page.APP_ProductEligibility_INT;
            } else if(redirectTo == 'Next'){
                ref = Page.APP_JointPersonalDetails_INT;
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
    
    //===============================================================
    //                       FIELD METHODS
    //===============================================================
    /*  Description: Wrapper class for Disbursement
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     */
    public class DisbursementWrapper {
        public Disbursement__c disbursement {get;set;}
        public Integer counter {get;set;} 
        public Decimal netPayOffDue {get;set;}

        public DisbursementWrapper() {  
            this.disbursement =  new Disbursement__c();     
        }
    }  

    /*  Description: Method to initialize the current disbursement wrapper
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameters: None
     *  Return: None
     */
    public void initializeDisbursement() {
        // Initialize the current disbursement wrapper
        currentDisbursementWrapper = new DisbursementWrapper(); 
        if (currentDisbursementWrapper.disbursement.Application__c == null) {
            currentDisbursementWrapper.disbursement.Application__c = this.application.Id;            
        }
        
        if (this.application.Application_Type__c == 'Single') {
          currentDisbursementWrapper.disbursement.Applicable_Party__c = 'Applicant 1';
        }
        currentDisbursementWrapper.disbursement.RecordTypeId = recTypeIdRefinance;    
    }      

    /*  Description: Method to validate all disbursement fields
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: N/A
     *  Return: Boolean (Passed or failed validation)
     */
    public Boolean doFieldsValidation() {
        // Check for fields validation
        Boolean bOk = true;

        if (currentDisbursementWrapper.disbursement.Payee__c == null || currentDisbursementWrapper.disbursement.Payee__c == '') {
            currentDisbursementWrapper.disbursement.Payee__c.addError('Invalid value.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Applicable_Party__c == null || currentDisbursementWrapper.disbursement.Applicable_Party__c == '') {
            currentDisbursementWrapper.disbursement.Applicable_Party__c.addError('Invalid value.');        
            bOk = false;
        }
        
        if ((currentDisbursementWrapper.disbursement.Applicable_Party__c == GEN_OriginationsConstants.BOTH || currentDisbursementWrapper.disbursement.Applicable_Party__c == GEN_OriginationsConstants.APPLICANT_2) &&
             this.application.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE) {
            currentDisbursementWrapper.disbursement.Applicable_Party__c.addError('You must select Applicant 1 as Applicable Party for single application.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == null || currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == '' || currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == '--None--') {
            currentDisbursementWrapper.disbursement.Disbursement_Account_type__c.addError('Invalid value.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == null || currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == '' || currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == '--None--') {
            currentDisbursementWrapper.disbursement.Disbursement_Outcome__c.addError('Invalid value.');     
            bOk = false;
        }

        //if (currentDisbursementWrapper.disbursement.Bank_Acc_No__c == null || currentDisbursementWrapper.disbursement.Bank_Acc_No__c == '') {
        //    currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError('Invalid value.');      
        //    bOk = false;
        //} 
        ////Added by Lavanya as a part of Jira: 1316
        //if ( currentDisbursementWrapper.disbursement.Bank_Acc_No__c!= null && !currentDisbursementWrapper.disbursement.Bank_Acc_No__c.isNumeric())
        //{
        //	currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError('Invalid value.');
        //	bOk = false;
        //}

        if (currentDisbursementWrapper.disbursement.Interest_Rate__c == null) {
            currentDisbursementWrapper.disbursement.Interest_Rate__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Payout_Effective_Date__c == null) {
            currentDisbursementWrapper.disbursement.Payout_Effective_Date__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Principal_Amount__c == null) {
            currentDisbursementWrapper.disbursement.Principal_Amount__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Interest_Due__c == null) {
            currentDisbursementWrapper.disbursement.Interest_Due__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Late_Fees_Due__c == null) {
            currentDisbursementWrapper.disbursement.Late_Fees_Due__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c == null) {
            currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c == null) {
            currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c.addError('Invalid value.');      
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Charge_Off_Amount__c == null) {
            currentDisbursementWrapper.disbursement.Charge_Off_Amount__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Insurance_Rebate__c == null) {
            currentDisbursementWrapper.disbursement.Insurance_Rebate__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Early_Termination_Fee__c == null) {
            currentDisbursementWrapper.disbursement.Early_Termination_Fee__c.addError('Invalid value.');        
            bOk = false;
        }           
        return bOk;
    }

    /*  Description: Method to save disbursement record in memory 
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public PageReference saveDisbursement() {
        // Save the disbursement with the associated Loan Purpose
        Boolean bNew = true;
        /**
        if(currentDisbursementWrapper.disbursement.Retrieved_Payout_Amount__c > 0){
        	
        	Boolean bOK = true;	        
	        if (currentDisbursementWrapper.disbursement.Interest_Rate__c == null) {
	            currentDisbursementWrapper.disbursement.Interest_Rate__c.addError('Please provide Interest Rate');        
	            bOk = false;
	        }  
	        
	        if(bok){
	        	for (loanWrapper loan : loanWrapList) {
                    if (loan.rowCount == selectedRow) {
                        loan.disbursement = currentDisbursementWrapper.disbursement;                        
                        currentDisbursementWrapper.counter = loan.rowCount;
                        
                        Decimal netPayOffDue = 0;
                        netPayOffDue += currentDisbursementWrapper.disbursement.Retrieved_Payout_Amount__c;                        
                        currentDisbursementWrapper.netPayOffDue = netPayOffDue;
                    }  
                }
                bDisplayDisbursementPopup = false;
	        }
        }else{**/
	        GEN_RefinanceUtility refinanceUtil = new GEN_RefinanceUtility();
	        String bAccountNumberOK = refinanceUtil.validateAppAccountNumber(currentDisbursementWrapper.disbursement.Bank_Acc_No__c, this.application.Id);
	        currentDisbursementWrapper.counter = selectedRow;
	        Boolean bOK = doFieldsValidation();
	        if (bOk) {
	            if (bAccountNumberOK == null) {
	                for (loanWrapper loan : loanWrapList) {
	                    if (loan.rowCount == selectedRow) {
	                        loan.disbursement = currentDisbursementWrapper.disbursement;                        
	                        currentDisbursementWrapper.counter = loan.rowCount;
	                        
	                        Decimal netPayOffDue = 0;
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Principal_Amount__c;
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Interest_Due__c;
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Late_Fees_Due__c; 
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c; 
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c;
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Charge_Off_Amount__c;
	                        netPayOffDue -= currentDisbursementWrapper.disbursement.Insurance_Rebate__c;
	                        netPayOffDue += currentDisbursementWrapper.disbursement.Early_Termination_Fee__c;
	                        
	                        currentDisbursementWrapper.netPayOffDue = netPayOffDue;
	                    }  
	                }
	                bDisplayDisbursementPopup = false; 
	            } else {
	                currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError(bAccountNumberOK);
	            }
	        }
        //}
        return null;
    }    

    /*  Description: Method to display popup window for disbursement 
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public PageReference showDisbursement() {
        // Display the dynamic pop up window for Refinance
        initializeDisbursement();
        bDisplayDisbursementPopup = true;     
        return null;
    }        

    /*  Description: Method to hide popup window for disbursement 
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public void cancelDisbursement() {
        // Close the dynamic pop up window for Refinance
        bDisplayDisbursementPopup = false; 
        //return null;
    } 

    /*  Description: Method to display/edit selected disbursement record
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: None
     *  Return: None
     */
    public PageReference editDisbursement() {
        // Edit the selected Refinace disbursement record
        for(loanWrapper lw: loanWrapList) {
            if (lw.loan.Value__c == 'Refinance' && lw.rowCount == selectedRow) {
                currentDisbursementWrapper.disbursement = lw.disbursement;
                currentDisbursementWrapper.counter = selectedRow;
                break;
            }
        }
        bDisplayDisbursementPopup = true;     
        return null;
    }   

    /*  Description: Method to get the Loan Purpose size
     *  Author: Mat Isidro
     *  Date Created: March 26, 2014
     *  Input Parameter: None
     *  Return: None
     */
    public Integer getloanPurposeSize() {
        return loanPurposeSize;
    }

    /*  Description: Method to validate the refinance counters
     *  Author: Mat Isidro
     *  Date Created: March 27, 2014
     *  Input Parameter: None
     *  Return: Boolean (bIsAllRefinance OR bIsRefinanceOnlyFirst)
     */
    Boolean validateLoanPurposeRefinance() {
        Boolean bIsAllRefinance = false;
        Boolean bIsRefinanceOnlyFirst = false;
        Boolean bIsRefinanceOver = false;
        Integer nrefinanceCount = 0;

        for (loanWrapper lp: loanWrapList) {
            if (lp.rowCount == 0) {
                if (lp.loan.Value__c == 'Refinance') {
                    nRefinanceCount++;
                    bIsRefinanceOnlyFirst = true;
                } else {
                    bIsRefinanceOnlyFirst = false;
                } 
            } else {
                if (lp.loan.Value__c == 'Refinance') {
                    nRefinanceCount++;
                }
            }
        }  

        if (nRefinanceCount > 3) {
            bIsRefinanceOver = true;                
        }

        if (nRefinanceCount == loanWrapList.size()) {
            bIsAllRefinance = true;            
        } 

        if (nRefinanceCount == 1 && loanWrapList.size() == 1 && bIsRefinanceOnlyFirst) {
            bIsRefinanceOnlyFirst = true;
        } 
        return (bIsAllRefinance || bIsRefinanceOnlyFirst);
    }
    
    /*  Description: Method to retrieve payoff figure from ICBS DBHZL386
     *  Author: Tony Xu
     *  Date Created: 2015-02-27
     *  Input Parameter: None
     *  Return: None
    */
     
     public void retrievePayoff(){
     	system.debug('***********txu DEBUG*********'+currentDisbursementWrapper);
            //This is a new disbursement record
            //Then Check if Account Number is provided
            String bankAccountNumber;

            if(brand.Country__c == GEN_OriginationsConstants.AU_REGION){
                bankAccountNumber = currentDisbursementWrapper.disbursement.Bank_Acc_No__c;
            } else {
                bankAccountNumber = currentDisbursementWrapper.disbursement.Bank_Acc_No_NZ__c;
            }

            //if(currentDisbursementWrapper.disbursement.Bank_Acc_No__c != null && currentDisbursementWrapper.disbursement.Bank_Acc_No__c != ''){
          	if(bankAccountNumber != null && bankAccountNumber != ''){
	            system.debug('************TXU DEBUG: New Disbursement');
	                
                try{
                	system.debug('***********TXU DEBUG**********'+ApexPages.currentPage());
                    //IS_GeneratePayoffFigure.generatePayoffFigureRequest(application.Id, currentDisbursementWrapper.disbursement.Bank_Acc_No__c, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                    IS_GeneratePayoffFigure.generatePayoffFigureRequest(application.Id, bankAccountNumber, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                	
                } catch(Exception e){     
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));  
                }
	                
	        }else{
               system.debug('********ERR: NO ACCOUNT NUMBER******');
                if(brand.Country__c == GEN_OriginationsConstants.AU_REGION){
                    currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError('Please provide Account Number for the retrieval');
                } else {
                    currentDisbursementWrapper.disbursement.Bank_Acc_No_NZ__c.addError('Please provide Account Number for the retrieval');
                }
          	}
     }

}