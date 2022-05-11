/* @Description: Controller for Proof of Income (Staff UI)
 * @Author: Adrian Recio
 * @Date Created: 18-02-2014
 * @History:
   =====================================================================
       18-02-14: Created - Adrian
   =====================================================================
 */ 
public with sharing class APP_ProofIncomeExt_INT extends APP_CommonExt{

    // Class Variable Declaration
    public Set<Id>incomeSet1;
    public Set<Id>incomeSet2;
    public List<Income_Capacity__c>icList1{get; set;}
    public List<Income_Capacity__c>icList2{get; set;}
    transient public List<Income_Capacity__c>icList1ReadOnly{get; set;}
    transient public List<Income_Capacity__c>icList2ReadOnly{get; set;}
    public Boolean showEdit{get; set;}
    public Boolean saveFired{get; set;}
    // ODDS-12370: Code changes start as part of NZ eopi 
    public Boolean ePOI_Eligible_NZ{get; set;}
    public Boolean ePOI_Eligible_NZ_Secondary{get; set;}
     // ODDS-12370: Code changes end as part of NZ eopi 
     
     //POI Automation Stage 2 -- Added by Suneel -- 17/07/2020
     public String id {get;set;}
     public Application__c ar{get;set;}
    
    /*  Description: Class constructor
     *  Author: Adrian Recio
     *  Date Created: 19-FEB-2014
     *  Parameter ApexPages.StandardController
     *  Return: na
     */
    public APP_ProofIncomeExt_INT(ApexPages.StandardController applicationController) {
        super(applicationController);
        ePOI_Eligible_NZ= false;
        ePOI_Eligible_NZ_Secondary= false;
        this.applicantList = [SELECT    Id, 
                                        Is_Primary_Applicant__c,
                                        Is_e_POI_Eligible__c,
                                        isPOIVerified__c,
                                        Verify_POI_Check_Record_Count__c
                              FROM      Applicant__c 
                              WHERE     Application__c =: applicationController.getRecord().Id];
        
        queryIncomeCapacityByApplicantIncome();
        validateMode();
        // ODDS-12370: Code changes start as part of NZ eopi 
        checkEpoiEligibilityNZ(applicationController.getRecord().Id);
        //Stage 2 - POI Automation - Added By Suneel - 17/07/2020
        id = ApexPages.currentPage().getParameters().get('id');
        try{
       ar = [select Remaining_Capacity__c,EVerifier_Alert_Applicant_1__c,EVerifier_Alert_Applicant_2__c,EVerifier_Income_Applicant_1__c,EVerifier_Income_Applicant_2__c,EVerifier_Request_Date_Applicant_1__c,EVerifier_Request_Date_Applicant_2__c from Application__c where id = :id];
        }catch(Exception e){}
    }
    
   
    // ODDS-12370: Code changes start as part of NZ eopi 
    /*  Description: Method to show EPOI eligibility for eligible NZ customers
     *  Author: Madhusudhan Seethala
     *  Date Created: 05-Mar-2019
     *  Parameter  Application ID
     *  Return na 
     */
    public void checkEpoiEligibilityNZ(ID appId){
    
       if( string.isNotBlank(appId) )
        {
          
          for(Applicant__c app:[SELECT Id, Application__c,Is_Primary_Applicant__c,Primary_Employment_Status__c
                                , Is_e_POI_Eligible__c ,(select Id, Income_Source__c from Incomes__r)
                                FROM 
                                Applicant__c 
                                Where 
                                Application__c=: appId
                                AND RecordType.name='NZ']){
                                
           
                for(Income__c appInc:app.Incomes__r){
                   
                   if(app.Is_Primary_Applicant__c == true && ePOI_Eligible_NZ== false){
                       
                        if((app.Primary_Employment_Status__c == 'Full Time' || app.Primary_Employment_Status__c == 'Part Time'
                        || app.Primary_Employment_Status__c == 'Casual' || app.Primary_Employment_Status__c == 'Seasonal' || 
                            app.Primary_Employment_Status__c == 'Temporary' ) && (appInc.Income_Source__c=='Net Salary/Wages') )
                            {
                                ePOI_Eligible_NZ= true;
                             
                            }
                        else if((app.Primary_Employment_Status__c == 'Full Time' || app.Primary_Employment_Status__c == 'Part Time'
                                ||app.Primary_Employment_Status__c == 'Other' ) && 
                           (appInc.Income_Source__c=='Rental Income') )
                           {
                                ePOI_Eligible_NZ= true;
                            }
                        
                        else{
                           
                            ePOI_Eligible_NZ= false;
                        }
                   }
                   else
                   if(app.Is_Primary_Applicant__c == false && ePOI_Eligible_NZ_Secondary == false) {
                       
                       if((app.Primary_Employment_Status__c == 'Full Time' || app.Primary_Employment_Status__c == 'Part Time'
                        || app.Primary_Employment_Status__c == 'Casual' || app.Primary_Employment_Status__c == 'Seasonal' || 
                            app.Primary_Employment_Status__c == 'Temporary' ) && (appInc.Income_Source__c=='Net Salary/Wages') )
                            {
                                ePOI_Eligible_NZ_Secondary= true;
                             
                            }
                        else if((app.Primary_Employment_Status__c == 'Full Time' || app.Primary_Employment_Status__c == 'Part Time'
                                ||app.Primary_Employment_Status__c == 'Other' ) && 
                           (appInc.Income_Source__c=='Rental Income') )
                           {
                                ePOI_Eligible_NZ_Secondary= true;
                            }
                        
                        else{
                           
                            ePOI_Eligible_NZ_Secondary= false;
                        }
                   } 
                    
                      
              }
        system.debug('VAlue of EpoiNz ++++++'+ePOI_Eligible_NZ);
        } 
      }  
    
    }
    // ODDS-12370: Code changes end as part of NZ eopi 
    /*  Description: Method toggle edit visibility based on requestedDocumentMode url parameter
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter na 
     *  Return na 
     */
    public void validateMode(){
        if(ApexPages.currentPage().getParameters().get('requestedDocumentMode')=='Edit'){
            showEdit = true;
        }else{
            showEdit = false;
        }
    }
    
    /*  Description: Method to refresh page and show edit mode for applicant 2
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference renderEdit1(){
        pageReference pgRef = Page.APP_ProofIncome_INT;
        pgRef.getParameters().put('requestedDocumentMode', 'Edit');
        pgRef.getParameters().put('applicantMode', '1');
        pgRef.getParameters().put('Id', application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Method to refresh page and show edit mode for applicant 2
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference renderEdit2(){
        pageReference pgRef = Page.APP_ProofIncome_INT;
        pgRef.getParameters().put('requestedDocumentMode', 'Edit');
        pgRef.getParameters().put('applicantMode', '2');
        pgRef.getParameters().put('Id', application.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Method used to pull visibility of applicant proof of income for edit
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public Boolean getApplicantMode(){
        string applicantMode = ApexPages.currentPage().getParameters().get('applicantMode');
        if(applicantMode=='2'){
                return false;
        }
        return true;
    }
        
    /*  Description: Method to redirect to main page
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2014
     *  Parameter 
     *  Return: 
     */
    public pageReference redirectMain(){
        pageReference pgRef = Page.APP_ApplicationMain_INT;
        pgRef.getParameters().put('Id', application.Id);
        pgRef.getParameters().put('tab','decisionTab');
        pgRef.getParameters().put('subTab','proofIncomeTab');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*  Description: Method that pulls income capacity 
                     records based on applicant's income records
     *  Author: Adrian Recio
     *  Date Created: 19-FEB-2014
     *  Parameter NA
     *  Return: NA
     */
    @TestVisible private void queryIncomeCapacityByApplicantIncome(){
        
        // Instantiate Applicant 1 and 2 Income Map
        Map<Id,Income__c> applicantIncomeMap1 = new Map<Id,Income__c>();
        Map<Id,Income__c> applicantIncomeMap2 = new Map<Id,Income__c>();
        
        // Retrieve applicant 1 income
        applicantIncomeMap1 = retrieveIncomeMap(this.applicant.Id);
        
        // If applicant count is more than 1 pull income details for applicant 2
        if(this.applicantList.size()>1){
            // Retrieve applicant 2 income
            applicantIncomeMap2 = retrieveIncomeMap(this.applicant2.Id);    
        }

        // Pull Income record key set
        incomeSet1 = applicantIncomeMap1.keySet();
        incomeSet2 = applicantIncomeMap2.keySet();
        
        // Pull income capacacity records under applicant 1 and 2 income records
        List<Income_Capacity__c> icMainList = pullIncomeCapacityRecords('Income__c In :incomeSet1 or Income__c In :incomeSet2');
        
        // Build Income Capacity Map where Id is it's parent income
        Map<Id, List<Income_Capacity__c>> icMap = buildIncomeCapacityMapByIncome(icMainList);
        
        icList1 = new List<Income_Capacity__c>();
        icList2 = new List<Income_Capacity__c>();
        
        icList1ReadOnly = new List<Income_Capacity__c>();
        icList2ReadOnly = new List<Income_Capacity__c>();

        for(Id iVar: incomeSet1){
            
            if(!icMap.get(iVar).isEmpty()){
                for(Income_Capacity__c ic: icMap.get(iVar)){
                    icList1.add(ic);
                    if(ic.Employment_Type__c != null && ic.Method_of_Verification__c != null){
                        icList1ReadOnly.add(ic);
                    }
                }
            }
        }
        
        for(Id iVar: incomeSet2){
            
            if(!icMap.get(iVar).isEmpty()){
                for(Income_Capacity__c ic: icMap.get(iVar)){
                    icList2.add(ic);
                    if(ic.Employment_Type__c != null && ic.Method_of_Verification__c != null){
                        icList2ReadOnly.add(ic);
                    }
                }
            }
        }
    }
    
    /*  Description: Build Income Capacity Map where Id is it's parent income
     *  Author: Adrian Recio
     *  Date Created: 19-FEB-2014
     *  Parameter List<Income_Capacity__c>icMainList
     *  Return: Map<id, Income_Capacity__c>icMap
     */
    public Map<Id, List<Income_Capacity__c>> buildIncomeCapacityMapByIncome(List<Income_Capacity__c>icMainList){
        Map<Id, List<Income_Capacity__c>> icMap = new Map<Id, List<Income_Capacity__c>>();
        for(Income_Capacity__c icVar:icMainList){
            
            if(icMap.containsKey(icVar.Income__c)){
                icMap.get(icVar.Income__c).add(icVar);
            } else {
                List<Income_Capacity__c> tempList = new List<Income_Capacity__c>();
                tempList.add(icVar);
                icMap.put(icVar.Income__c, tempList);
            }
        }
        
        return icMap;
    }
    
    /*  Description: Pull IncomeCapacity Field Set
     *  Author: Adrian Recio
     *  Date Created: 19-FEB-2014
     *  Parameter String queryCondition
     *  Return: List<Income_Capacity__c>
     */
    public List<Income_Capacity__c> pullIncomeCapacityRecords(string queryCondition){
        
        // Build query string
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : this.getIncomeCapacityFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Income_Capacity__c where ' + queryCondition;
        
        return Database.query(query);
    }
    
    /*  Description: Pull IncomeCapacity Field Set
     *  Author: Adrian Recio
     *  Date Created: 19-FEB-2014
     *  Parameter na
     *  Return: List<Schema.FieldSetMember>
     */
    public List<Schema.FieldSetMember> getIncomeCapacityFields() {
        return SObjectType.Income_Capacity__c.FieldSets.ProofOfIncome.getFields();
    }
    
    /*  Description: Save income capacity records
     *  Author: Adrian Recio
     *  Date Created: 20-FEB-2014
     *  Parameter na
     *  Return: pageReference
     */
    
    public pageReference saveIncomeCapacity(){
        if(getApplicantMode() == true){
            Boolean validationStatus1 = validateIncome(icList1);
            if(validationStatus1 == false){
                try{
                    update icList1;     
                }catch(exception e){
                    system.debug('Error in Income Capacity 1 Update:' + string.valueOf(e));
                }

                try {
                    updateAndSetApplicationOutOfSync(this.application);
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ProofIncomeExt_INT', 'Application__c', 'Class', String.valueOf(this.application.Id));
                }

                return redirectMain();
            }
        }else{
            Boolean validationStatus2 = validateIncome(icList2);
            if(validationStatus2 == false){
                try{    
                    update icList2;
                }catch(exception e){
                    system.debug('Error in Income Capacity 2 Update:' + string.valueOf(e));
                }

                try {
                    updateAndSetApplicationOutOfSync(this.application);
                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ProofIncomeExt_INT', 'Application__c', 'Class', String.valueOf(this.application.Id));
                }

                return redirectMain();
            }
        }
            
        return null;
    }
    
    /*  Description: Method used to perform income capacity validations
     *  Author: Adrian Recio
     *  Date Created: 20-FEB-2014
     *  Parameter List<Income_Capacity__c>()
     *  Return: Boolean
     */
     public Boolean validateIncome(List<Income_Capacity__c>icList){
        
        Boolean hasErrors = false;
        saveFired = true; // Set save fired boolean to true so that 
                          // errors will appear for components that can't use addError in visualforce
                          // specifically for the select list visualforce tag.
        
        //List<Income_Capacity__c> validateEmploymentContractList = new List<Income_Capacity__c>();
        Map<Id, List<Income_Capacity__c>> validateEmploymentContractMap = new Map<Id, List<Income_Capacity__c>>();
        
        for(Income_Capacity__c icVar: icList){
            //Stage 2 POI Automation
           /** if(icVar.Method_of_Verification__c == 'Verifier' && ar.isPOIVerified__c == false){
               icVar.Method_of_Verification__c.addError('Cannot select Verifier if alert types defined in the POI tab');
                hasErrors = true;
            } */
            //End
            // Validate Employment Type
            if(icVar.Employment_Type__c == null){
                icVar.Employment_Type__c.addError('Required');
                hasErrors = true;
            }

            // Validate Method of Verification
            if(icVar.Method_of_Verification__c == null){
                icVar.Method_of_Verification__c.addError('Required');
                hasErrors = true;
            }

            // Validate Method of Calculation
            IF(!(icVar.Method_of_Verification__c == 'Payslip' || 
                 icVar.Salary_Sacrifice__c=='Yes' || 
                 icVar.Method_of_Verification__c == 'Tax Return' || 
                 icVar.Method_of_Verification__c == 'Profit & Loss' || 
                 icVar.Method_of_Verification__c == 'Individual Tax Return')){      //MLASALA 28-JUL-16
                 
                if(icVar.Method_of_Calculation__c == null ){
                    icVar.Method_of_Calculation__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            if(!(icVar.Method_of_Verification__c != 'Payslip' || 
               icVar.Salary_Sacrifice__c=='Yes' || 
               icVar.Method_of_Verification__c == 'Tax Return' || 
               icVar.Method_of_Verification__c == 'Profit & Loss' || 
               icVar.Method_of_Verification__c == 'Individual Tax Return')){      //MLASALA 28-JUL-16
               
                if(icVar.Method_of_Calculation__c == null){
                    icVar.Method_of_Calculation__c.addError('Required');
                    hasErrors = true;
                }
            }

            // Validate Frequency of payment
            IF(!(icVar.Salary_Sacrifice__c=='Yes' || 
                 icVar.Method_of_Verification__c == 'Tax Return' || 
                 icVar.Method_of_Verification__c == 'Profit & Loss' || 
                 icVar.Method_of_Verification__c=='PAYG Summary' || 
                 icVar.Method_of_Verification__c == 'Letter from Accountant' || 
                 icVar.Method_of_Calculation__c == 'Net YTD' || 
                 icVar.Method_of_Verification__c == 'Individual Tax Return')){      //MLASALA 28-JUL-16
                 
                if(icVar.Frequency_of_Payment__c == null){
                    icVar.Frequency_of_Payment__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            // Validate ytd two months
            IF(icVar.Employment_Type__c=='Overtime Shift Allowance' && 
               icVar.Method_of_Verification__c == 'Payslip' && 
               icVar.Salary_Sacrifice__c != 'Yes'){
                if(icVar.YTD_Two_Months__c == null){
                    icVar.YTD_Two_Months__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            
            // Validate Salary Sacrifice
            IF( icVar.Method_of_Verification__c == 'Payslip' || 
                icVar.Method_of_Verification__c == 'Verbal' || 
                icVar.Method_of_Verification__c == 'Verbal - Fax Request' || 
                icVar.Method_of_Verification__c == 'Letter from Employer' ||
                icVar.Method_of_Verification__c == 'Policy Exception'){
                if(icVar.Salary_Sacrifice__c == null){
                    icVar.Salary_Sacrifice__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            // Validate Salary Sacrifice Sub Fields
            IF(icVar.Salary_Sacrifice__c=='Yes'){
                if(icVar.SS_Frequency_of_Payment__c == null){
                    icVar.SS_Frequency_of_Payment__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Income_1_DD__c == null){
                    icVar.Income_1_DD__c.addError('Required');
                    hasErrors = true;
                }

                if(icVar.Net_Income_Salary_Sacrifice__c == null){
                    icVar.Net_Income_Salary_Sacrifice__c.addError('Required');
                    hasErrors = true;
                }
                if(icVar.Salary_Sacrifice_Income_Portion__c == null){ 
                    icVar.Salary_Sacrifice_Income_Portion__c.addError('Required');
                    hasErrors = true;
                }
                if (!isNZ(icVar.RecordType.Name)) {
                    if(icVar.Salary_Sacrifice_Items_itemized__c == null){ 
                        icVar.Salary_Sacrifice_Items_itemized__c.addError('Required');
                        hasErrors = true;
                    }
                    if(icVar.Salary_Sacrifice_Items_itemized__c == 'Yes'){ 
                        if(icVar.Salary_Sacrifice_Items_being_added__c == null){ 
                            icVar.Salary_Sacrifice_Items_being_added__c.addError('Required');
                            hasErrors = true;
                        }
                    }
                }
            }
            
            if (!isNZ(icVar.RecordType.Name)) {
                IF(icVar.Salary_Sacrifice__c=='No'){
                    if(icVar.Overtime_Shift_Allowance__c == null){ 
                        icVar.Overtime_Shift_Allowance__c.addError('Required');
                        hasErrors = true;
                    }
                }
                //Validate free textbox fields
                IF(icVar.Salary_Sacrifice_Items_itemized__c=='No'){ 
                    if(icVar.Verbal_Confirmation_with_Customer__c == null){
                        icVar.Verbal_Confirmation_with_Customer__c.addError('Required');
                        hasErrors = true;
                    }
                }
                IF(icVar.Method_of_Verification__c == 'Other (please specify)'){
                    if(icVar.Other_Method_of_Verification__c == null){
                        icVar.Other_Method_of_Verification__c.addError('Required');
                        hasErrors = true;
                    }
                }
                IF(icVar.Employment_Type__c == 'Fixed Term Contract' && icVar.Method_of_Verification__c != 'Verifier'){
                    if(icVar.Employer_Contract_End_Date_Confirmation__c == null){
                        icVar.Employer_Contract_End_Date_Confirmation__c.addError('Required');
                        hasErrors = true;
                    }
                }
            }
            
            // Validate Tax Return and Profit and Loss
            IF(icVar.Method_of_Verification__c == 'Tax Return' || 
               icVar.Method_of_Verification__c == 'Individual Tax Return'){      //MLASALA 28-JUL-16
               
                if(icVar.Taxable_Income__c == null){
                    icVar.Taxable_Income__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            IF(icVar.Method_of_Verification__c == 'Profit & Loss'){
                if(icVar.Net_Profit_Before_Tax__c == null){
                    icVar.Net_Profit_Before_Tax__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            IF(icVar.Method_of_Verification__c == 'Tax Return' || icVar.Method_of_Verification__c == 'Profit & Loss' || 
               icVar.Method_of_Verification__c == 'Individual Tax Return'){      //MLASALA 28-JUL-16
                 
                if(icVar.Tax_Income__c == null){
                    icVar.Tax_Income__c.addError('Required');
                    hasErrors = true;
                }
                if(icVar.plus_Depreciation__c == null){
                    icVar.plus_Depreciation__c.addError('Required');
                    hasErrors = true;
                }
                if(icVar.plus_Interest__c == null){
                    icVar.plus_Interest__c.addError('Required');
                    hasErrors = true;
                }
                if(icVar.plus_Personal_Superannuation__c == null){
                    icVar.plus_Personal_Superannuation__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            
            // Validate Income Source
            
            IF((icVar.Method_of_Calculation__c == 'Net Income' || 
                icVar.Method_of_Calculation__c == 'Net YTD' ||
                icVar.Method_of_Calculation__c == 'Gross Income' ||
                icVar.Method_of_Calculation__c == 'Gross Taxable Income' ||
                icVar.Method_of_Calculation__c == 'Gross YTD') && icVar.Method_of_Verification__c != 'Bank Statement'){
                
                if(icVar.Income_1__c == null && icVar.Method_of_Verification__c !='Payslip'){
                    icVar.Income_1__c.addError('Required');
                    hasErrors = true;
                }
            
                if(icVar.Income_1_DD__c == null && icVar.Method_of_Verification__c !='Payslip'){
                    icVar.Income_1_DD__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Employment_Type__c == 'Centrelink' && 
                   (icVar.Method_of_Verification__c =='Centrelink Statement' ||
                    icVar.Method_of_Verification__c =='Verbal' ||
                    icVar.Method_of_Verification__c =='Verbal - Fax Request')){
                    if(icVar.Income_2__c==null){
                        icVar.Income_2__c.addError('Required');
                        hasErrors = true;
                    }
                }

                if(icVar.Payslip_1_Income__c == null && icVar.Method_of_Verification__c =='Payslip'){
                    icVar.Payslip_1_Income__c.addError('Required');
                    hasErrors = true;
                }
            
                if(icVar.Payslip_1_DD__c == null && icVar.Method_of_Verification__c =='Payslip' ){
                    icVar.Payslip_1_DD__c.addError('Required');
                    hasErrors = true;
                }
            
                if(icVar.Payslip_2_Income__c == null && ((icVar.Method_of_Verification__c =='Payslip' && 
                                                         icVar.Employment_Type__c =='Overtime Shift Allowance' && 
                                                         icVar.Method_of_Calculation__c == 'Net Income') ||
                                                         ((icVar.Employment_Type__c=='Casual' ||
                                                           icVar.Employment_Type__c=='Fixed Term Contract') &&
                                                          icVar.Method_of_Verification__c=='Payslip' && 
                                                          icVar.Method_of_Calculation__c=='Net YTD' && 
                                                          isNZ(icVar.RecordType.Name)))){
                    icVar.Payslip_2_Income__c.addError('Required');
                    hasErrors = true;
                }
            
                if(icVar.Payslip_2_DD__c == null && ((icVar.Method_of_Verification__c =='Payslip' && 
                                                         icVar.Employment_Type__c =='Overtime Shift Allowance' && 
                                                         icVar.Method_of_Calculation__c == 'Net Income') ||
                                                         ((icVar.Employment_Type__c=='Casual' ||
                                                           icVar.Employment_Type__c=='Fixed Term Contract') && 
                                                          icVar.Method_of_Verification__c=='Payslip' && 
                                                          icVar.Method_of_Calculation__c=='Net YTD' && 
                                                          isNZ(icVar.RecordType.Name)))){
                    icVar.Payslip_2_DD__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Payslip_3_Income__c == null && ((icVar.Employment_Type__c=='Casual' ||
                                                         icVar.Employment_Type__c=='Fixed Term Contract') && 
                                                         icVar.Method_of_Verification__c=='Payslip' && 
                                                         icVar.Method_of_Calculation__c=='Net YTD' && 
                                                         isNZ(icVar.RecordType.Name))){
                    icVar.Payslip_3_Income__c.addError('Required');
                    hasErrors = true;
                }
            
                if(icVar.Payslip_3_DD__c == null && ((icVar.Employment_Type__c=='Casual' ||
                                                      icVar.Employment_Type__c=='Fixed Term Contract') && 
                                                    icVar.Method_of_Verification__c=='Payslip' && 
                                                    icVar.Method_of_Calculation__c=='Net YTD' && 
                                                    isNZ(icVar.RecordType.Name))){
                    icVar.Payslip_3_DD__c.addError('Required');
                    hasErrors = true;
                }

                // Validate Document Date
                if(APP_ProofIncomeDetail_CCINT.validateDocDate(icVar, isNZ(icVar.RecordType.Name))){
                    hasErrors = true;
                }
            }
            
            
            // Validate Base Gross Income
            IF(icVar.Method_of_Calculation__c == 'Base Gross Income'){
                if (isNZ(icVar.RecordType.Name)) {
                    if(icVar.YTD_Income_show__c == null){
                        icVar.YTD_Income_show__c.addError('Required');
                        hasErrors = true;
                    }
                }
                if(icVar.Method_of_Verification__c !='Payslip'){
                    
                    if(icVar.Income_1__c==null){
                        icVar.Income_1__c.addError('Required');
                        hasErrors = true;
                    }
                    
                    if(icVar.Income_1__c==null){
                        icVar.Income_1_DD__c.addError('Required');
                        hasErrors = true;
                    }
                }
                
                if(icVar.Method_of_Verification__c !='Payslip' && icVar.YTD_Income_show__c=='No'){
                    if(icVar.Income_2__c==null){
                        icVar.Income_2__c.addError('Required');
                        hasErrors = true;
                    }
                    
                    if(icVar.Income_2_DD__c==null){
                        icVar.Income_2_DD__c.addError('Required');
                        hasErrors = true;
                    }
                }
            
                if(icVar.Method_of_Verification__c =='Payslip'){
                    if(icVar.Payslip_1_Income__c == null){
                        icVar.Payslip_1_Income__c.addError('Required');
                        hasErrors = true;
                    }
                    
                    if(icVar.Payslip_1_DD__c == null){
                        icVar.Payslip_1_DD__c.addError('Required');
                        hasErrors = true;
                    }

                    if(icVar.YTD_Income_show__c=='No'){
                        if(icVar.Payslip_2_Income__c == null){
                            icVar.Payslip_2_Income__c.addError('Required');
                            hasErrors = true;
                        }
                        
                        if(icVar.Payslip_2_DD__c == null){
                            icVar.Payslip_2_DD__c.addError('Required');
                            hasErrors = true;
                        }
                    }
                }
            
                if( icVar.Method_of_Verification__c =='Payslip' && 
                                                         icVar.Employment_Type__c =='Overtime Shift Allowance' && 
                                                         icVar.Method_of_Calculation__c == 'Net Income'){
                    if(icVar.Payslip_2_Income__c == null){
                        icVar.Payslip_2_Income__c.addError('Required');
                        hasErrors = true;
                    }
                    
                    if(icVar.Payslip_2_DD__c == null){
                        icVar.Payslip_2_DD__c.addError('Required');
                        hasErrors = true;
                    }
                }
                
                // Validate Document Date
                if(APP_ProofIncomeDetail_CCINT.validateDocDate(icVar, isNZ(icVar.RecordType.Name))){
                    hasErrors = true;
                }
            }
            
            // Validate Bank Statement and Net Income
            IF(icVar.Method_of_Verification__c == 'Bank Statement' && icVar.Method_of_Calculation__c == 'Net Income'){
                IF(icVar.Employment_Type__c=='Rental Income Private' ||
                   icVar.Employment_Type__c=='Permanent full time' || 
                   icVar.Employment_Type__c=='Permanent part time' || 
                   icVar.Employment_Type__c=='Overtime Shift Allowance' || 
                   icVar.Employment_Type__c=='Maintenance' || 
                   icVar.Employment_Type__c == 'Self Employed' || 
                   icVar.Employment_Type__c == 'ACC' ||
                   icVar.Employment_Type__c == 'Superannuation' ||
                   icVar.Employment_Type__c == 'Working for Family Members' || 
                   icVar.Employment_Type__c == 'Commission' ||
                   icVar.Employment_Type__c == 'Seasonal Worker' || 
                   icVar.Employment_Type__c == 'Government Benefit' || 
                   icVar.Employment_Type__c == 'Temporary Employment'){
                   
                   if(icVar.Income_1__c == null){
                     icVar.Income_1__c.addError('Required');
                     hasErrors = true;
                   }
                   if(icVar.Income_2__c == null && !icVar.Is_e_POI__c){
                     icVar.Income_2__c.addError('Required');
                     hasErrors = true;
                   }
                   if(icVar.Income_1_DD__c == null){
                     icVar.Income_1_DD__c.addError('Required');
                     hasErrors = true;
                   }
                   if(icVar.Income_2_DD__c == null  && !icVar.Is_e_POI__c){
                     icVar.Income_2_DD__c.addError('Required');
                     hasErrors = true;
                   }
                }
                
                IF(icVar.Employment_Type__c=='Rental Income Private'){
                   if(icVar.Income_3__c == null){
                     icVar.Income_3__c.addError('Required');
                     hasErrors = true;
                   }
                   if(icVar.Income_3_DD__c == null){
                     icVar.Income_3_DD__c.addError('Required');
                     hasErrors = true;
                   }
                }
                
                IF(icVar.Employment_Type__c=='Casual' || 
                  icVar.Employment_Type__c=='Fixed Term Contract' || 
                  icVar.Employment_Type__c=='Family Business' || 
                  icVar.Employment_Type__c=='Self Funded Retirees'){
                    
                  if(icVar.Lowest_Income_Deposit__c == null){
                     icVar.Lowest_Income_Deposit__c.addError('Required');
                     hasErrors = true;
                   }
                   if(icVar.Lowest_Income_Deposit_DD__c == null){
                     icVar.Lowest_Income_Deposit_DD__c.addError('Required');
                     hasErrors = true;
                   }
                }
            
                // Validate Document Date
                if(APP_ProofIncomeDetail_CCINT.validateDocDate(icVar, isNZ(icVar.RecordType.Name))){
                    hasErrors = true;
                }
            }
            
            // Validate Rental
            if((icVar.Employment_Type__c == 'Rental Income Private' || 
                icVar.Employment_Type__c == 'Rental Income Agency' ||
                icVar.Employment_Type__c== 'Rental Income') &&
                (icVar.Method_of_Verification__c == 'Rental Statement' || 
                 icVar.Method_of_Verification__c == 'Bank Statement' || 
                 icVar.Method_of_Verification__c == 'Lease Agreement') && 
                icVar.Method_of_Calculation__c == 'Net Income'){
                    
               if(icVar.Income_1__c == null){
                 icVar.Income_1__c.addError('Required');
                 hasErrors = true;
               }
               if(icVar.Income_1_DD__c == null){
                 icVar.Income_1_DD__c.addError('Required');
                 hasErrors = true;
               }
               
               if(icVar.Method_of_Verification__c == 'Rental Statement' || 
                  icVar.Method_of_Verification__c == 'Bank Statement'){
                   if(icVar.Income_2__c == null){
                     icVar.Income_2__c.addError('Required');
                     hasErrors = true;
                   }
                   
                   if(icVar.Income_2_DD__c == null){
                     icVar.Income_2_DD__c.addError('Required');
                     hasErrors = true;
                   }
                   
                   if(icVar.Income_3__c == null){
                     icVar.Income_3__c.addError('Required');
                     hasErrors = true;
                   }
                   
                   if(icVar.Income_3_DD__c == null){
                     icVar.Income_3_DD__c.addError('Required');
                     hasErrors = true;
                   }
               }
               
               if(icVar.No_of_Property_Owners__c == null){
                 icVar.No_of_Property_Owners__c.addError('Required');
                 hasErrors = true;
               }
            }
            
            // Validate YTD
            if(icVar.Method_of_Calculation__c=='Net YTD' || icVar.Method_of_Calculation__c=='Gross YTD'){
                if(icVar.YTD_Start_Date__c == null){
                    icVar.YTD_Start_Date__c.addError('Required');
                    hasErrors = true;
                }
                if(icVar.YTD_Finish_Date__c == null){
                    icVar.YTD_Finish_Date__c.addError('Required');
                    hasErrors = true;
                }
                if(APP_ProofIncomeDetail_CCINT.validateYtdDate(icVar) == true){
                    hasErrors = true;
                }
            }
            
            // Validate Gross Income
            IF(icVar.Method_of_Calculation__c=='Gross Income' || 
               icVar.Method_of_Calculation__c=='Base Gross Income' || 
               icVar.Method_of_Calculation__c=='Gross Taxable Income' || 
               icVar.Method_of_Calculation__c=='Gross YTD'){
               
               if(icVar.Tax_Income__c == null){
                    icVar.Tax_Income__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            // Verbal Validation
            IF(icVar.Method_of_Verification__c=='Verbal' && (icVar.Method_of_Calculation__c!=null || icVar.Salary_Sacrifice__c=='Yes')){
                if(icVar.authorised_person_spoken__c == null){
                    icVar.authorised_person_spoken__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Position_Within_Business__c == null){
                    icVar.Position_Within_Business__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Business_phone_number__c == null){
                    icVar.Business_phone_number__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Business_number_confirmed__c == null){
                    icVar.Business_number_confirmed__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.How_Business_number_confirmed__c == null){
                    icVar.How_Business_number_confirmed__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Employment_and_Occupation_Confirmed__c== null){
                    icVar.Employment_and_Occupation_Confirmed__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Customer_in_Probation__c== null){
                    icVar.Customer_in_Probation__c.addError('Required');
                    hasErrors = true;
                }
                
                if(icVar.Start_Date_of_Employment__c== null){
                    icVar.Start_Date_of_Employment__c.addError('Required');
                    hasErrors = true;
                }
            }
            
            //Special NZ rules
            if((icVar.Employment_Type__c == 'Self Employed' || 
                icVar.Employment_Type__c == 'ACC' || 
                icVar.Employment_Type__c == 'Working for Family Members' || 
                icVar.Employment_Type__c == 'Commission' || 
                icVar.Employment_Type__c == 'Government Benefit' || 
                icVar.Employment_Type__c == 'Temporary Employment') && 
                icVar.Method_of_Calculation__c == 'Net Income' && 
               (icVar.Method_of_Verification__c == 'Financial Statement' || 
                icVar.Method_of_Verification__c == 'Summary of Earnings from NZ IRD' || 
                icVar.Method_of_Verification__c == 'ACC Statement')){
                    
               if(icVar.Income_1__c == null){
                 icVar.Income_1__c.addError('Required');
                 hasErrors = true;
               }
               if(icVar.Income_1_DD__c == null){
                 icVar.Income_1_DD__c.addError('Required');
                 hasErrors = true;
               }
            }
            System.debug('icVar.RecordType.Name-->'+icVar.RecordType.Name);
            if(isNZ(icVar.RecordType.Name) && 
               icVar.Income__r.Years_With_Employer__c == 0 && 
               icVar.Income__r.Months_With_Employer__c == 1){

                if(validateEmploymentContractMap.containsKey(icVar.Income__c)){
                    validateEmploymentContractMap.get(icVar.Income__c).add(icVar);
                } else {
                    List<Income_Capacity__c> tempList = new List<Income_Capacity__c>();
                    tempList.add(icVar);
                    validateEmploymentContractMap.put(icVar.Income__c, tempList);
                }
            }
        }
        System.debug('validateEmploymentContractMap-->'+validateEmploymentContractMap);
        if(!validateEmploymentContractMap.keySet().isEmpty()){
            Boolean hasEmploymentContract = false;
            
            //Added by FSaliba 13/1/2015 DEFECT ID: 15 fix
            Boolean hasInvalidPaymentFreq = false;
            
            Set<String> validMethodOfVer = new Set<String>();
            validMethodOfVer.add('Payslip');
            validMethodOfVer.add('Bank Statement');
            validMethodOfVer.add('Contract');
            
            for(Id incomeId: validateEmploymentContractMap.keySet()){
                for(Income_Capacity__c ic: validateEmploymentContractMap.get(incomeId)){
                    if(validMethodOfVer.contains(ic.Method_of_Verification__c) == false){
                        hasEmploymentContract = true;
                    }
                    else if(ic.Method_of_Verification__c == 'Payslip' 
                            && ic.Frequency_of_Payment__c != 'Weekly' 
                            && ic.Frequency_of_Payment__c != 'Fortnightly'){
                            hasInvalidPaymentFreq = true;                           
                    }
                }
            }
            
            if(hasEmploymentContract){
                hasErrors = true;
                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured: Contract, Payslip or Bank Statement is required for Income with less than 1 month of employment');
            }
            //Added by FSaliba 13/1/2015 DEFECT ID: 15 fix
            if(hasInvalidPaymentFreq ){
                hasErrors = true;
                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured: Payslip is only accepted if frequency of payment is either Weekly or Fortnightly');
            }
        }
        
        return hasErrors;
     }
     
    /*
     *Author: Adrian Recio
     *Created Date: May 29, 2015
     *Description: Income Capacity Region Checker based on recordtype name
     */
     public Boolean isNZ(String incomeCapacityRecordTypeName){
        Boolean flag = false;
        
        if(incomeCapacityRecordTypeName != null && incomeCapacityRecordTypeName == GEN_OriginationsConstants.NZ_REGION){
            flag = true;
        }

        return flag;
     }
}