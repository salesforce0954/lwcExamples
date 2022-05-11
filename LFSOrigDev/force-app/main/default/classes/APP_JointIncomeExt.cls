/*
 * @Description: Joint Income Page controller for GE Customer UI
 * @Author: Fel Saliba
 * @Date Created: OCTOBER-11-2013
 * @History:
   =====================================================================
        OCT-11 (Fel): Created.
        NOV-25 (Mike): Update code to latest
        FEB-11 (Mike): Added tab level errors - Mike
        FEB-17-14: Added previous employer month field validation
        MAR-31 (Mat) : Refactoring of Admin Settings custom settings  
        APR-1-14(Adrian): Added warning and timeout getter methods
        11-05-14: Modified code for DBHZL34    - Tony Xu
   =====================================================================
 */ 
public class APP_JointIncomeExt extends APP_CommonExt{    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================    
    //Applicant 1
    public List<MyBudgetsIncomeWrapper> incomeAddList   {get;set;}  //Income record list
    public Integer incomeListSize                       {get;set;}  //Income record list size
    public Boolean invalidPreEmployerMonth              {get;set;}  //Previous employer month flag
    public Boolean previousEmpStatusValid               {get;set;}  //Previous Employment Status Validation flag
    public Boolean previousEmpNameValid                 {get;set;}  //Previous Employment name validation flag
    public Boolean previousEmpYearValid                 {get;set;}  //Previous employement year validation flag
    public Boolean previousEmpMonthValid                {get;set;}  //Previous Employment month validation flag
    public Boolean isIncomeRedundancyValid              {get;set;}
    public Boolean isIncomeRedundancyValidA2            {get;set;}
    
    //Applicant 2
    public List<MyBudgetsIncomeWrapper> incomeAddList2  {get;set;}  //Income record list
    public Integer incomeList2Size                      {get;set;}  //Income record list size
    public Boolean invalidPreEmployerMonth2             {get;set;}  //Previous employer month flag
    public Boolean previousEmpStatusValid2              {get;set;}  //Previous Employment Status Validation flag
    public Boolean previousEmpNameValid2                {get;set;}  //Previous Employment name validation flag
    public Boolean previousEmpYearValid2                {get;set;}  //Previous employement year validation flag
    public Boolean previousEmpMonthValid2               {get;set;}  //Previous Employment month validation flag
    
    public String redirectTo                            {get;set;}  //Pagereference identifier
    public Integer selectedRow                          {get;set;}  //Specific row/record to be deleted
    public Integer selectedList                         {get;set;}  //Applicant 1/2 list identifer
    public String applicantTab                          {get;set;}  //apex:tab value
    public Boolean employmentStatusValid                {get;set;}  //Applicant 1 primary employment status flag
    public Boolean employmentStatusValid2               {get;set;}  //Applicant 2 primary employment status flag
    public Integer appSize                              {get;set;}  //Number of applicants
    public Boolean applicant2IncomeExempt               {get;set;}  //Income exemption indicator if joint application
    public List<Income__c> incomeListToDel = new List<Income__c>(); //Income record list for deletion
    public Boolean incomeValidationResults;                         //Validation flag
    public Decimal totalIncome;                                     //Applicant 1 total income value
    public Decimal totalIncome2;                                    //Applicant 2 total income value
    public String country;                                          //Country of the Brand that get passed to MyBudgetsIncomeWrapper Added by Tony Xu for DBHZL34
    
    //Better Start fields
    public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}
    public Boolean isBetterStart {get;set;}
    public Boolean isSoftQuoteFlow {get;set;}
    public Boolean isBrokerQuote {get;set;}
    public Boolean isNZOccupationQuote {get;set;}
    
    public String confirmIncomeChanges {get;set;}
    public String confirmIncomeChangesA2 {get;set;}
    
    public String confirmincomechange1 {get;set;}
    public String confirmincomechange2 {get;set;}
    
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
    
    public APP_JointIncomeExt(ApexPages.StandardController applicationController) {
        super(applicationController);
        isSoftQuoteFlow = false;
        isBrokerQuote = false;
        isNZOccupationQuote = false;
        totalIncome = 0;
        selectedList = 1;   //Set list to Applicant 1
        //Added by Tony Xu for DHBZL34
        country = brand.country__c;

        Id applicationId = (Id) ApexPages.currentPage().getParameters().get('Id');
        Boolean isSoftQuoteEnabled = SoftQuoteUtil.checkIfSoftQuoteEnabled(applicationId);
        if(isSoftQuoteEnabled){
            List<Quote__c> quoteList = [SELECT Broker_ID__c,Occupation__c,Region__c
                                          FROM Quote__c
                                         WHERE Application__c =:  applicationId];
            if(quoteList.size() == 1){  
                if(quoteList[0].Broker_ID__c != null){
                    isBrokerQuote = true;
                }
                if(quoteList[0].Occupation__c != null && quoteList[0].Region__c=='NZ'){
                    isNZOccupationQuote = true;
                }
            }
        }   
        List<Income__c> oldIncome = retrieveIncomeList(this.applicant.Id);

        //Added as part of Soft quote Changes
        List<Income__c> quoteIncome = createIncomeList(this.applicant.Id);  
        
        if(country != 'AU'){
            if(this.applicant.Income_Redundancy__c == true){
            confirmincomechange1 = 'YES';
            confirmIncomeChanges = 'YES';
            }else if(this.applicant.Income_Redundancy__c == false && oldIncome.size() > 0){
            confirmincomechange1 = 'NO';
            confirmIncomeChanges = 'NO';
            }
        }
        //Retrieve income records of applicant 1
        if(!oldIncome.isEmpty()){
            //Set income wrapper for applicant 1
            incomeAddList = new List<MyBudgetsIncomeWrapper>();
            for(Income__c i:oldIncome){
                MyBudgetsIncomeWrapper mbiw = new MyBudgetsIncomeWrapper(i, this.applicant, true, country); //Modified by Tony Xu for DBHZL34
                mbiw.income = i;
                incomeAddList.add(mbiw);
                if(i.Total_Income__c != null){
                    totalIncome += i.Total_Income__c;
                }
            }
            refreshCount();
            incomeListSize = oldIncome.size(); 
        }else if(!quoteIncome.isEmpty()){
            isSoftQuoteFlow = true;
            incomeAddList = new List<MyBudgetsIncomeWrapper>();
            for(Income__c i:quoteIncome){
                MyBudgetsIncomeWrapper mbiw = new MyBudgetsIncomeWrapper(i, this.applicant, true, country); 
                mbiw.income = i;
                incomeAddList.add(mbiw);
                if(i.Total_Income__c != null){
                    totalIncome += i.Total_Income__c;
                }
            }
            refreshCount();
            incomeListSize = quoteIncome.size(); 
        
        } else {
            //Instantiate new wrapper records
            incomeAddList = new List<MyBudgetsIncomeWrapper>();
            incomeListSize = 0;
            //Added to backlog 06/23 mlasala
            //if(!this.applicant.Income_Exempt__c){
                addIncome();
            //}
        }
        
        incomeList2Size = 0;
        
        if(this.applicantList.size()>1){
            totalIncome2 = 0;
            selectedList = 2;   //Set list to Applicant 2
            
            //applicant2IncomeExempt = this.applicant2.Income_Exempt__c;
            
            
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
                    MyBudgetsIncomeWrapper mbiw = new MyBudgetsIncomeWrapper(i, this.applicant2, true, country);   //Modified by Tony Xu for DBHZL34
                    mbiw.income = i;
                    incomeAddList2.add(mbiw);
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
                //Added to backlog 06/23 mlasala
                //if(!applicant2IncomeExempt){
                    addIncome();
                //}
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
        
        appSize = this.applicantList.size();
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
    /*  Description: Add new Income for Applicant 1 record
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
        incomeWrapperList.add(new MyBudgetsIncomeWrapper(applicant, true, country));
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

    /*  Description: Remove all income
     *  Author: Mike Lasala
     *  Date Created: JUN-17-2014
     *  Input Parameters: None
     *  Return: void
     *  Added to backlog 06/23 mlasala
     */
    //public void removeAllIncome(){
    //    if(selectedList == 1){
    //        removeAllIncomeFromList(incomeAddList, this.applicant.Income_Exempt__c);
    //    } else if(selectedList == 2){
    //        removeAllIncomeFromList(incomeAddList2, applicant2IncomeExempt);
    //    } else {
        
    //    }
    //}

    /*  Description: Remove all income per list
     *  Author: Mike Lasala
     *  Date Created: JUN-17-2014
     *  Input Parameters: List<MyBudgetsIncomeWrapper>, Boolean, Integer
     *  Return: void
     *  Added to backlog 06/23 mlasala
     */
    //public void removeAllIncomeFromList(List<MyBudgetsIncomeWrapper> incomeWrapperList, Boolean isExempt){
    //    if(isExempt){
    //        if(!incomeWrapperList.isEmpty()){
    //            for(MyBudgetsIncomeWrapper inc: incomeWrapperList){
    //                //MLASALA 02/05/14: Id is being set to null for creation of records to work. 
    //                //If not set to null, Id is equating to an empty string which returns an error that states the invalid type of Id
    //                //Cause is still unknown
    //                if(String.valueOf(inc.income.Id) != ''){
    //                    incomeListToDel.add(inc.income);
    //                }
    //            }
    //        }
    //        incomeWrapperList.clear();
    //    } else {
    //        addIncome();
    //    }
    //}

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
        if(highestIncome>0){
            apl.Additional_Income__c = totalIncome - highestIncome;
            apl.Total_Income__c = totalIncome;
        } else {
            apl.Additional_Income__c = 0;
            apl.Total_Income__c = 0;
        }
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
        
        isIncomeRedundancyValid = false;
        isIncomeRedundancyValidA2 = false;

        List<MyBudgetsIncomeWrapper> finalIncomeAddList = new List<MyBudgetsIncomeWrapper>();
        List<Income__c> incomeList = new List<Income__c>();
        Decimal applicantTotalIncome = 0;
        Decimal applicantTotalIncome2 = 0;
        String errorMessage = '';
        incomeValidationResults = true;
        
        //Added by Tony Xu for DBHZL34
        Boolean validatePrevEmpInfoApp1 = true; //Check whether a validation is needed for applicant 1
        Boolean validatePrevEmpInfoApp2 = true; //Check whether a validation is needed for applicant 2
      
     if(country != 'AU'){  
        if(confirmincomechange1 == 'YES' && confirmIncomeChanges == 'YES'){
           this.applicant.Income_Redundancy__c = true;
        }else{
           this.applicant.Income_Redundancy__c = false;
        }
     }   
     
     if(country != 'AU'){
        if(confirmincomechange1 == ''){
          incomeValidationResults = false;
          isIncomeRedundancyValid = true;
        }
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
        
        //if(!applicant.Income_Exempt__c){
            if(!incomeAddList.isEmpty()){
                for(MyBudgetsIncomeWrapper incWrap: incomeAddList){
                    finalIncomeAddList.add(incWrap);
                    system.debug('******TXU DEBUG*******:'+incWrap.income.Total_Income__c);
                    if(incWrap.income.Total_Income__c != null){
                        applicantTotalIncome = applicantTotalIncome + incWrap.income.Total_Income__c;
                    }
                    
                    //Added for DBHZL34
                    if(incWrap.income.Income_Source__c != 'Net Salary/Wages' && incWrap.income.Income_Source__c != 'Self Employed'){
                        validatePrevEmpInfoApp1 = false;
                    }else if((Util.nullCheck(String.valueOf(incWrap.income.Years_With_Employer__c)) || incWrap.income.Years_With_Employer__c != 00) && incWrap.income.Years_With_Employer__c >= 2){
                        validatePrevEmpInfoApp1 = false;
                    }
                    
                    if(incWrap.income.Years_With_Employer__c == 0 && incWrap.income.Months_With_Employer__c == 1){
                        incWrap.income.Prev_Emp_Bus_Name__c = this.applicant.Prev_Emp_Bus_Name__c;
                    }
                }
            }
        //}
        
        if(this.applicantList.size()>1){
            //this.applicant2.Income_Exempt__c = applicant2IncomeExempt;
         
         if(country != 'AU'){  
            if(confirmincomechange2 == 'YES'){
              this.applicant2.Income_Redundancy__c = true;
             }else{
              this.applicant2.Income_Redundancy__c = false;
             }
          }  
            
            //if(!applicant2IncomeExempt){
                if(!incomeAddList2.isEmpty()){
                    for(MyBudgetsIncomeWrapper incWrap: incomeAddList2) {
                        finalIncomeAddList.add(incWrap);
                        if(incWrap.income.Total_Income__c != null){
                            applicantTotalIncome2 = applicantTotalIncome2 + incWrap.income.Total_Income__c;
                        }
                        
                        //Added for DBHZL34
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
            //}
        }else{
            validatePrevEmpInfoApp2=false;
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
       if(country != 'AU'){
        if(this.applicantList.size() > 1 && confirmincomechange2 == ''){
                  isIncomeRedundancyValidA2 = true;
                  incomeValidationResults = false;
         }
        }
        /**
            Added by Tony Xu for DBHZL34
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
                      ErrorHandlerException.recordException(e.getMessage() + e.getStackTraceString(), 'APP_JointIncomeExt', 'Income__c', 'Class', String.valueOf(this.application.Id));
                  }
            }
            
            //BEGIN MLASALA 07-JUL-16 DEFECT 1030 FIX
            //Overrides total income value to 0
            //setApplicantTotalIncome(this.applicant, applicantTotalIncome, highestIncome(incomeAddList));
            
            //if(this.applicantList.size()>1){
            //    setApplicantTotalIncome(this.applicant2, applicantTotalIncome2, highestIncome(incomeAddList2));
            //}
            //END MLASALA 07-JUL-16 DEFECT 1030 FIX
            
            try{
                update this.applicantList;
            } catch(DMLException e){          
                ErrorHandlerException.recordException(e.getMessage() + e.getStackTraceString(), 'APP_JointIncomeExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));
            }
        } else {
            if(this.applicantList.size()>1){
                Util.addMessage(ApexPages.Severity.ERROR, 'Applicant '+errorMessage+' has errors');
            }
        }
        return incomeValidationResults;
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
        
        incomeValidationResults = true;
        
        //BEGIN MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
        //Added back redirection
        if(redirectTo == 'Save' || 
           redirectTo == 'POI' || 
           redirectTo == 'Back'){
            validateFields();
        }else if(redirectTo == 'Timeout'){
            this.loanValidationResults = true;
        }
        
        PageReference ref;
        if(incomeValidationResults){
            if(this.loanValidationResults){
                if(redirectTo == 'Save'){
                    UserUtility userUtility = new UserUtility();
                    ref = userUtility.createCommunityUser(this.application, this.applicant);
                } else if(redirectTo == 'Timeout'){
                    ref = Page.APP_Timeout;
                } else if(redirectTo == 'Back'){
                    ref = backPage();
                }
                //END MLASALA 20-SEPT-16 TQLQW-483 Gen 2 App form
                
                if(redirectTo != 'Timeout'){
                    ref.getParameters().put('id', this.application.Id);
                }
                
                ref.setRedirect(true);
                return ref;
            }
            else{
                return null;
            }
        } else {
            return null;
        }
    }
}