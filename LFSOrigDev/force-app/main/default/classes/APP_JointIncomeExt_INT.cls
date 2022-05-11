/* @Description: Controller for Joint Application Income (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: NOV-19-2013
 * @History:
   =====================================================================
       11-19-13: Created - Mike
       01-14-14: Refactored to cater single and joint application - Mike
       02-17-14: Added previous employer month field validation - Adrian
       11-05-14: Modified code for DBHZL-34         - Tony Xu
   =====================================================================
 */ 
public with sharing class APP_JointIncomeExt_INT extends APP_CommonExt{
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    //Applicant 1
    public List<MyBudgetsIncomeWrapper> incomeAddList   {get;set;}  //Income record list
    public Integer incomeListSize                       {get;set;}  //Income record list size
    public Decimal totalIncome                          {get;set;}  //Total income value
    public Boolean invalidPreEmployerMonth              {get;set;}  //Previous employer month flag
    public Boolean previousEmpStatusValid               {get;set;}  //Previous Employment Status Validation flag
    public Boolean previousEmpNameValid                 {get;set;}  //Previous Employment name validation flag
    public Boolean previousEmpYearValid                 {get;set;}  //Previous employement year validation flag
    public Boolean previousEmpMonthValid                {get;set;}  //Previous Employment month validation flag
    public String confirmIncomeChanges                 {get;set;}
    
    public String confirmincomechange1                  {get;set;}
    public String confirmincomechange2                  {get;set;}
    
    //Applicant 2
    public List<MyBudgetsIncomeWrapper> incomeAddList2  {get;set;}  //Income record list
    public Integer incomeList2Size                      {get;set;}  //Income record list size
    public Decimal totalIncome2                         {get;set;}  //Total income value
    public Boolean invalidPreEmployerMonth2             {get;set;}  //Previous employer month flag
    public Boolean previousEmpStatusValid2              {get;set;}  //Previous Employment Status Validation flag
    public Boolean previousEmpNameValid2                {get;set;}  //Previous Employment name validation flag
    public Boolean previousEmpYearValid2                {get;set;}  //Previous employement year validation flag
    public Boolean previousEmpMonthValid2               {get;set;}  //Previous Employment month validation flag
    public String confirmIncomeChangesA2               {get;set;}
    
    public String Mode                                  {get;set;}  //Identifier whether coming from edit application or edit income
    public String redirectTo                            {get;set;}  //Pagereference identifier
    public Integer selectedRow                          {get;set;}  //Specific row/record to be deleted
    public Integer selectedList                         {get;set;}  //Applicant 1/2 list identifer
    public String applicantTab                          {get;set;}  //apex:tab value
    public Boolean employmentStatusValid                {get;set;}  //Applicant 1 primary employment status flag
    public Boolean employmentStatusValid2               {get;set;}  //Applicant 2 primary employment status flag
    
    public List<Income__c> incomeListToDel = new List<Income__c>();     //Income record list for deletion
    public Boolean incomeValidationResults;                             //Validation flag
    public Integer appSize                              {get;set;}
    public String country                               {get;set;}          //Added by Tony Xu for DBHZL34          
    public APP_JointIncomeExt_INT(ApexPages.StandardController applicationController) {
       super(applicationController);
        
        //To identify if back and next buttons should be displayed
        Mode = ApexPages.currentPage().getParameters().get('mode');
        
        if(!this.applicantList.isEmpty()){
            for(Applicant__c a: this.applicantList){
                if(a.Time_at_previous_employer_years__c == 0){
                    a.Time_at_previous_employer_years__c = null;
                }

                if(a.Time_at_previous_employer_months__c == 0){
                    a.Time_at_previous_employer_months__c = null;
                }
            }
        }
        appSize = this.applicantList.size();
        totalIncome = 0;
        selectedList = 1;   //Set list to Applicant 1
        
      
         if(country != 'AU'){
            if(this.applicant.Income_Redundancy__c == true){
            confirmincomechange1 = 'YES';
            confirmIncomeChanges = 'YES';
            }else if(this.applicant.Income_Redundancy__c == false){
            confirmincomechange1 = 'NO';
            confirmIncomeChanges = 'NO';
            }
        }
        
        //Added by Tony Xu for DBHZL34
        country = brand.country__c;
        //Retrieve income records of applicant 1
        List<Income__c> oldIncome = retrieveIncomeList(this.applicant.Id);
        
        if(!oldIncome.isEmpty()){
            //Set income wrapper for applicant 1
            incomeAddList = new List<MyBudgetsIncomeWrapper>();
            for(Income__c i:oldIncome){
                MyBudgetsIncomeWrapper mbiw = new MyBudgetsIncomeWrapper(i, this.applicant, false, country); //Modified by Tony Xu for DBHZL34
                mbiw.income = i;
                incomeAddList.add(mbiw);
                /**if(i.POI_Amount_Verified__c != null){
                    totalIncome += i.POI_Amount_Verified__c.setScale(2);
                } else */
                if(i.Total_Income__c != null){
                    totalIncome += i.Total_Income__c;
                }
            }
            refreshCount();
            incomeListSize = oldIncome.size(); 
        } else {
            //Instantiate new wrapper records
            incomeAddList = new List<MyBudgetsIncomeWrapper>();
            incomeListSize = 0;
            addIncome();
        }
        
        if(this.applicantList.size()>1){
            totalIncome2 = 0;
            selectedList = 2;   //Set list to Applicant 2

            //Retrieve income records of applicant 2
            List<Income__c> oldIncome2 = retrieveIncomeList(this.applicant2.Id);
            
              if(country != 'AU'){        
            if(this.applicant2.Income_Redundancy__c == true){
            confirmincomechange2 = 'YES';
            confirmIncomeChangesA2 = 'YES';
            }else if(this.applicant2.Income_Redundancy__c == false && oldIncome2.size() > 0){
            confirmincomechange2 = 'NO';
            confirmIncomeChangesA2 = 'NO';
            } 
        }  
            
            if(!oldIncome2.isEmpty()){
                //Set income wrapper for applicant 2
                incomeAddList2 = new List<MyBudgetsIncomeWrapper>();
                for(Income__c i:oldIncome2){
                    MyBudgetsIncomeWrapper mbiw = new MyBudgetsIncomeWrapper(i, this.applicant2, false, country); //Modified by Tony Xu for DBHZL34
                    mbiw.income = i;
                    incomeAddList2.add(mbiw);
                    /**if(i.POI_Amount_Verified__c != null){
                        totalIncome2 += i.POI_Amount_Verified__c.setScale(2);
                    } else */
                     if(i.Total_Income__c != null){
                        totalIncome2 += i.Total_Income__c;
                    }
                }
                refreshCount();
                incomeList2Size = oldIncome2.size(); 
            } else {
                //Instantiate new wrapper records
                incomeAddList2 = new List<MyBudgetsIncomeWrapper>();
                incomeList2Size = 0;
                addIncome();
            }
        }
        
        //Added by Tony Xu for DBHZL34
        previousEmpStatusValid = true;
        previousEmpNameValid = true;
        previousEmpYearValid = true;
        previousEmpMonthValid = true;
        previousEmpStatusValid2 = true;             
        previousEmpNameValid2 = true;
        previousEmpYearValid2 = true;
        previousEmpMonthValid2 = true;
        
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================    
    /*  Description: Add new Income record
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addIncome(){
        if(selectedList == 1){
            incomeListSize = addIncomeToList(incomeAddList, this.applicant, incomeListSize);
        } else if(selectedList == 2){
            incomeList2Size = addIncomeToList(incomeAddList2, this.applicant2, incomeList2Size);
        }

        refreshCount();
    }
    
    /*  Description: Add new Income record per list
     *  Author: Mike Lasala
     *  Date Created: APR-03-2013
     *  Input Parameters: List<MyBudgetsIncomeWrapper>, Applicant, Integer
     *  Return: Integer
     */
    public Integer addIncomeToList(List<MyBudgetsIncomeWrapper> incomeWrapperList, Applicant__c applicant, Integer listSize){
        incomeWrapperList.add(new MyBudgetsIncomeWrapper(applicant, false, country));
        listSize++;
        return listSize;
    }

    /*  Description: Remove selected Income record
     *  Author: Mike Lasala
     *  Date Created: DEC-11-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void removethisIncome(){        
        if(selectedList == 1){
            deleteIncomeFromList(incomeAddList);
            incomeListSize = incomeAddList.size();
        } else if(selectedList == 2){
            deleteIncomeFromList(incomeAddList2);
            incomeList2Size = incomeAddList2.size();
        }
        
        getTotalIncome();
        
        refreshCount();
    }

    /*  Description: Method to remove Income record from wrapper list
     *  Author: Mike Lasala
     *  Date Created: MAR-26-2014
     *  Input Parameters: List<MyBudgetsIncomeWrapper>
     *  Return: void
     */
    public void deleteIncomeFromList(List<MyBudgetsIncomeWrapper> incomeWrapperList){
        if(!incomeWrapperList.isEmpty()){
            for(MyBudgetsIncomeWrapper inc: incomeWrapperList){
                //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                //Cause is still unknown
                if(String.valueOf(inc.income.Id) != ''){
                    if(selectedRow == inc.rowCount && inc.income.Id != null){
                        incomeListToDel.add(incomeWrapperList.get(selectedRow).income);
                        break;
                    }
                }
            }
        }
        incomeWrapperList.remove(selectedRow);
        
        if(incomeWrapperList.isEmpty()){
            addIncome();
        }
    }

    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshCount(){
        List<MyBudgetsIncomeWrapper> tempList = new List<MyBudgetsIncomeWrapper>();
        
        //Set temporary list to selected income list (applicant 1/2)
        if(selectedList == 1){
            tempList = incomeAddList;
        } else if(selectedList == 2){
            tempList = incomeAddList2;
        }
        
        if(!tempList.isEmpty()){
            Integer i = 0;
            for(MyBudgetsIncomeWrapper inc: tempList){
                inc.rowCount = i;
                i++;
            }
        }
    }   
    
    /* Description: Get the Total Income of the applicant.
     *  Author: Fel Saliba
     *  Date Created: OCT-2-2013
     *  Input Parameters: None
     *  Return: N/A
     */    
    public void getTotalIncome() {
        if(selectedList == 1){
            totalIncome = getTotalIncomeByList(incomeAddList, totalIncome);
        } else if(selectedList == 2){
            totalIncome2 = getTotalIncomeByList(incomeAddList2, totalIncome2);
        }
    }
    
    /* Description: Get the Total Income per list
     *  Author: Mike Lasala
     *  Date Created: OCT-2-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public Decimal getTotalIncomeByList(List<MyBudgetsIncomeWrapper> incomeWrapperList, Decimal totIncome){
        totIncome = 0;
            
        for(MyBudgetsIncomeWrapper mbiw: incomeWrapperList) { 
            if(mbiw.income.Income_Amount__c != null && mbiw.income.Income_Interval__c != null && mbiw.income.Income_Interval__c != 'None'){
                mbiw.computeTotalIncome();
                totIncome = totIncome + mbiw.income.Total_Income__c;
            }
        }

        return totIncome;
    }

    public void setApplicantTab(){
        //refresh inputHidden on page on page load
    }
    
    /*  Description: Set applicant additional and total income
     *  Author: Mike Lasala
     *  Date Created: JAN-15-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public void setApplicantTotalIncome(Applicant__c apl, Decimal totalIncome, Decimal highestIncome){
        apl.Additional_Income__c = totalIncome - highestIncome;
        apl.Total_Income__c = totalIncome;
    }
    
    
    
    /*  Description: Return highest income
     *  Author: Mike Lasala
     *  Date Created: JAN-23-2014
     *  Input Parameters: None
     *  Return: Decimal
     */
    public Decimal highestIncome(List<MyBudgetsIncomeWrapper> tempIncomeList){
        List<Decimal> incomeValues = new List<Decimal>();
        
        if(!tempIncomeList.isEmpty()){
            for(MyBudgetsIncomeWrapper mbiw: tempIncomeList){
                if(mbiw.income.Total_Income__c != null){
                    incomeValues.add(mbiw.income.Total_Income__c);
                }
            }
            incomeValues.sort();
            
            return incomeValues.get(incomeValues.size()-1);
        } else {
            return 0;
        }
    }
    
    /*  Description: Validate income records to insert
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public boolean validateFields() {        
        invalidPreEmployerMonth = false;
        invalidPreEmployerMonth2 = false;
        employmentStatusValid = false;
        employmentStatusValid2 = false;
        
        //Added by Tony Xu for DBHZL34
        previousEmpStatusValid = true;              
        previousEmpNameValid = true;
        previousEmpYearValid = true;
        previousEmpMonthValid = true;
        previousEmpStatusValid2 = true;             
        previousEmpNameValid2 = true;
        previousEmpYearValid2 = true;
        previousEmpMonthValid2 = true;

        List<MyBudgetsIncomeWrapper> finalIncomeAddList = new List<MyBudgetsIncomeWrapper>();
        List<Income__c> incomeList = new List<Income__c>();
        Decimal applicantTotalIncome = 0;
        Decimal applicantTotalIncome2 = 0;
        String errorMessage = '';
        incomeValidationResults = true;
        
        //Added by Tony Xu for DBHZL34
        Boolean validatePrevEmpInfoApp1 = true; //Check whether a validation is needed for applicant 1 DBHZL34
        //Boolean validatePrevEmpInfoApp2 = true; //Check whether a validation is needed for applicant 2 DBHZL34
        Boolean validatePrevEmpInfoApp2 = false; //Check whether a validation is needed for applicant 2 DBHZL34
        
        
        if(!incomeAddList.isEmpty()){
            selectedList = 1;
            getTotalIncome();
            for(MyBudgetsIncomeWrapper incWrap: incomeAddList){
                finalIncomeAddList.add(incWrap);
                if(incWrap.income.Total_Income__c != null){
                    applicantTotalIncome = applicantTotalIncome + incWrap.income.Total_Income__c;
                }
                
                //Added by Tony Xu for DBHZL34
                //system.debug('income source: '+incWrap.income.Income_Source__c);
                if(incWrap.income.Income_Source__c != 'Net Salary/Wages' && incWrap.income.Income_Source__c != 'Self Employed'){
                    validatePrevEmpInfoApp1 = false;
                }else if((Util.nullCheck(String.valueOf(incWrap.income.Years_With_Employer__c)) || //05.14.15 Mike Lasala: Code Scan fix
                          incWrap.income.Years_With_Employer__c != 00) && 
                         incWrap.income.Years_With_Employer__c >= 2){
                    validatePrevEmpInfoApp1 = false;
                }
                
                if(incWrap.income.Years_With_Employer__c == 0 && incWrap.income.Months_With_Employer__c == 1){
                    incWrap.income.Prev_Emp_Bus_Name__c = this.applicant.Prev_Emp_Bus_Name__c;
                }
            }
        }
        
        if(this.applicantList.size()>1){
            validatePrevEmpInfoApp2 = true;
            if(!incomeAddList2.isEmpty()){
                selectedList = 2;
                getTotalIncome();
                for(MyBudgetsIncomeWrapper incWrap: incomeAddList2) {
                    finalIncomeAddList.add(incWrap);
                    if(incWrap.income.Total_Income__c != null){
                        applicantTotalIncome2 = applicantTotalIncome2 + incWrap.income.Total_Income__c;
                    }
                    
                    //Added by Tony Xu for DBHZL34
                    if(incWrap.income.Income_Source__c != 'Net Salary/Wages' && incWrap.income.Income_Source__c != 'Self Employed'){
                        validatePrevEmpInfoApp2 = false;
                    }else if((Util.nullCheck(String.valueOf(incWrap.income.Years_With_Employer__c)) || //05.14.15 Mike Lasala: Code Scan fix
                              incWrap.income.Years_With_Employer__c != 00) && 
                             incWrap.income.Years_With_Employer__c >= 2){
                        validatePrevEmpInfoApp2 = false;
                    }
                    
                    if(incWrap.income.Years_With_Employer__c == 0 && incWrap.income.Months_With_Employer__c == 1){
                        incWrap.income.Prev_Emp_Bus_Name__c = this.applicant2.Prev_Emp_Bus_Name__c;
                    }
                }
            }
        }

        //Consolidate both Income lists
        if(!finalIncomeAddList.isEmpty()){
            for(MyBudgetsIncomeWrapper incWrap: finalIncomeAddList) {
                if(incWrap.validateIncome()) {
                    incWrap.clearFields();
                    incWrap.computeTotalIncome();
                    
                    //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
                    //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
                    //Cause is still unknown
                    if(String.valueOf(incWrap.income.Id) == ''){
                        incWrap.income.Id = null;
                    }
                    
                    incomeList.add(incWrap.income);
                } else {
                    incomeValidationResults = false;
                    
                    //Identify which applicant/s has errors if joint
                    if(this.applicantList.size()>1){
                        if(incWrap.applicant == this.applicant){
                            errorMessage = '1 tab'; 
                        } else if(incWrap.applicant == this.applicant2){
                            if(errorMessage != ''){
                                errorMessage = '1 and 2 tabs';  
                            } else {
                                errorMessage = '2 tab';
                            } 
                        }   
                    }
                }
            }
        }
        
        //Validate applicant fields
        if(this.applicant.Primary_Employment_Status__c == 'None' || this.applicant.Primary_Employment_Status__c == null){
            employmentStatusValid = true;
            incomeValidationResults = false;
        }
        if(this.applicantList.size() > 1 && (this.applicant2.Primary_Employment_Status__c == 'None' || this.applicant2.Primary_Employment_Status__c == null)){
            employmentStatusValid2 = true;
            incomeValidationResults = false;
        }
        // Validate applicant previous employer month
        if(this.applicant.Time_at_previous_employer_months__c>11){
            invalidPreEmployerMonth = true;
            incomeValidationResults = false;
        }
        
        // Validate applicant2 previous employer month
        if(this.applicant2.Time_at_previous_employer_months__c>11){
            invalidPreEmployerMonth2 = true;
            incomeValidationResults = false;
        }
        
        /**
            Added by Tony xu for DBHZL34
            The following code is intend to validate the Previous Employment Section. Applicant must provide the following information where they have been employed at their current emploer for less than 2 years
            1. Previous Employement status
            2. Previous Employer name - only when previous employment status is not "other"
            3. Previous employment time (year/month) only when previous employement status is not "other"            
        **/
        if(this.country == 'NZ'){
            if(validatePrevEmpInfoApp1){
                if(this.applicant.Previous_Employment_Status__c == '' || this.applicant.Previous_Employment_Status__c == null){
                    previousEmpStatusValid = false;
                    incomeValidationResults = false;
                }else if((this.applicant.Prev_Emp_Bus_Name__c == null || this.applicant.Prev_Emp_Bus_Name__c == '') && this.applicant.Previous_Employment_Status__c != 'Other'){
                    previousEmpNameValid = false;
                    incomeValidationResults = false;
                }else if(this.applicant.Time_at_previous_employer_years__c == 00 && this.applicant.Time_at_previous_employer_months__c == 00 &&  this.applicant.Previous_Employment_Status__c != 'Other'){
                    previousEmpYearValid = false;
                    previousEmpMonthValid = false;
                    incomeValidationResults = false;    
                }else if(this.applicant.Time_at_previous_employer_years__c == null && this.applicant.Previous_Employment_Status__c != 'Other'){
                    previousEmpYearValid = false;
                    incomeValidationResults = false;
                }else if(this.applicant.Time_at_previous_employer_months__c == null && this.applicant.Previous_Employment_Status__c != 'Other'){
                    previousEmpMonthValid = false;
                    incomeValidationResults = false;
                }                   
            }
            
            if(validatePrevEmpInfoApp2){
                if(this.applicant2.Previous_Employment_Status__c == '' || this.applicant2.Previous_Employment_Status__c == null){
                    previousEmpStatusValid2 = false;
                    incomeValidationResults = false;
                }else if((this.applicant2.Prev_Emp_Bus_Name__c == null || this.applicant2.Prev_Emp_Bus_Name__c == '') && this.applicant2.Previous_Employment_Status__c != 'Other'){
                    previousEmpNameValid2 = false;
                    incomeValidationResults = false;
                }else if(this.applicant2.Time_at_previous_employer_years__c == 00 && this.applicant2.Time_at_previous_employer_months__c == 00 &&  this.applicant2.Previous_Employment_Status__c != 'Other'){
                    previousEmpYearValid2 = false;
                    previousEmpMonthValid = false;
                    incomeValidationResults = false;    
                }else if(this.applicant2.Time_at_previous_employer_years__c == null && this.applicant2.Previous_Employment_Status__c != 'Other'){
                    previousEmpYearValid2 = false;
                    incomeValidationResults = false;
                }else if(this.applicant2.Time_at_previous_employer_months__c == null && this.applicant2.Previous_Employment_Status__c != 'Other'){
                    previousEmpMonthValid2 = false;
                    incomeValidationResults = false;
                } 
            }
        }
                
        //insert all incomes if results are valid
        if(incomeValidationResults){
            try{
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Income__c.SObjectType.getDescribe().isCreateable()) {
                    upsert incomeList;
                //}
            } catch(Exception e){
                ErrorHandlerException.recordException(e.getMessage() + e.getStackTraceString(), 'APP_JointIncomeExt', 'Income__c', 'Class', String.valueOf(this.application.Id));
            } 
            
            Savepoint sp = Database.setSavePoint();
            
            if(!incomeListToDel.isEmpty()){
                  try{
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Income__c.sObjectType.getDescribe().isDeletable()){
                            delete incomeListToDel;
                        }
                        */
                        delete incomeListToDel;
                  } catch(DMLException e){
                      setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointIncomeExt', 'Income__c', 'Class', String.valueOf(this.application.Id));
                  }
            }                        
            setApplicantTotalIncome(this.applicant, applicantTotalIncome, highestIncome(incomeAddList));
            
              if(country != 'AU'){  
                if(confirmincomechange1 == 'YES' && confirmIncomeChanges == 'YES'){
                   this.applicant.Income_Redundancy__c = true;
                }else{
                   this.applicant.Income_Redundancy__c = false;
                }
     }   
            
            if(this.applicantList.size()>1){
            
             if(country != 'AU'){  
            if(confirmincomechange2 == 'YES'){
              this.applicant2.Income_Redundancy__c = true;
             }else{
              this.applicant2.Income_Redundancy__c = false;
             }
          }  
          
                setApplicantTotalIncome(this.applicant2, applicantTotalIncome2, highestIncome(incomeAddList2));
            }
            
            try{
                update this.applicantList;
            } catch(DMLException e){          
                setRollbackAndErrorHandler(sp, e.getMessage(), 'APP_JointIncomeExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }
            
            try {
                updateAndSetApplicationOutOfSync(this.application);
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_JointIncomeExt', 'Application__c', 'Class', String.valueOf(this.application.Id));
            }
        } else {
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return incomeValidationResults;
    }
   
    
    /*  Description: Page Redirection
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageRedirect(){
        incomeValidationResults = true;
        
        if(redirectTo == 'Save' || redirectTo == 'Next' || redirectTo == 'POI'){
            validateFields();
        }
        
        PageReference ref;
        if(incomeValidationResults){
            if(redirectTo == 'Back'){
                ref = Page.APP_JointPersonalDetails_INT;
            } else if(redirectTo == 'Next'){
                ref = Page.APP_JointAssets_INT;
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
}