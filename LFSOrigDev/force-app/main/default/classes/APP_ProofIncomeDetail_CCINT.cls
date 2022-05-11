/*
 *Author: Adrian Recio Cloud Sherpas
 *Created Date: February 20, 2014
 *Description: Controller Class for APP_ProofIncomeDetail_INT Component 
 *@History:
   =====================================================================
       05-08-15: Added Picklist values for Part time/Full time employment type for AU applications - Marvin David
   =====================================================================
 */
 
public with sharing class APP_ProofIncomeDetail_CCINT {


    // Class Variable Declaration
    public List<Income_Capacity__c> icEditList;
    public Integer counterVar;
    public String indexValue {get; set;}
    public List<icListWithIndex> icEditIndexList {get; set;}
    public Boolean saveFired{get; set;}
    public Boolean isVerifier {get; set;}
    public String recordTypeName {get; set;}
    public Decimal totalLevy;
    public Id taxIncomeRecordTypeId;
    public Decimal startAmount; //ADDED BY DYU 27-AUG-2015 PMIHM 1940
    public List<Application__c> appVer {get;set;}
   public List<Income__c> incVer {get;set;}
   public Boolean fromCalculatorCheck{get;set;}
    
     
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Class constructor
     */
    public APP_ProofIncomeDetail_CCINT(){
        indexValue = '0';
        //buildIcList();
        //Stage 2 - POI Automation - Added By Suneel - 17/07/2020
        isVerifier = true;      
    }
        
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Getter method for income capacity list
     */
    public List<Income_Capacity__c> geticEditList(){
        //return icEditList;
        return null;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Setter method for income capacity list
     */
    public void seticEditList(List<Income_Capacity__c> icEditListPar){
        icEditList = icEditListPar;
        buildIcList();  
        if(!fromCalculatorCheck) {      
            populateVerifier(icEditList[Integer.valueOf(indexValue)]);
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Getter mthod fo countervar
     */
    public Integer getCounterVar() {
        return counterVar;
    }

    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Setter method for countervar
     */
    public void setCounterVar(Integer attributeVar) {
        if(attributeVar!=null){
            Integer dummyVar = attributeVar * 1; 
            counterVar = dummyVar;
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Wrapper class that contains income capacity with it's corresponding index
     */
    public class icListWithIndex{
        public Income_Capacity__c icVar{get; set;}
        public Integer index{get; set;}
        public boolean specialMOCHasError{get; set;}
        public Application__c app {get;set;}
        public List<Income__c> inc {get;set;}
        //public List<Income_Capacity__c> incap {get;set;}
        public icListWithIndex(Income_Capacity__c icVarPar,Integer indexPar,Boolean saveFiredPar){
            icVar = icVarPar;
            index = indexPar;
            // set error boolean for method of calculation select 
            // list if constructor is called after a save event
           
            /*
     *Author: Suneel Desiraju
     *Created Date: January 23,2021
     *Project : POI Automation
     *Description: Populate Method of verification as "Verifier" when the verifier amount is recieved from Activate.
     */
             
          //  populateVerifier(app,inc,icVar);
            
            /*End*/
            
            if(icVar!=null){
                if(icVar.Method_of_Calculation__c==null && saveFiredPar==true){
                    specialMOCHasError = true;
                }
            }else{
                Util.addMessage(ApexPages.Severity.ERROR, 'An error has occured: Income Capacity is null');
            }
        }
    }
    
  /* public static Boolean validateVerifier(Income_Capacity__c icVar){
        Boolean hasErr = false;
           List<Income_Capacity__c> results = [Select Method_of_Verification__c  from Income_Capacity__c where income__r.applicant__r.application__r.UID__c='3009221015372' and Method_of_Verification__c ='Verifier'];
        if(results.size() > 1){
          icVar.Method_Of_Verification__c.addError('Only one Verifier is allowed');
          hasErr = true;
        }               
        return hasErr;

   }*/
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: 
     */
    public void buildIcList(){
        icEditIndexList = new List<icListWithIndex>();
        Integer indexVar = 0;
        for(Income_Capacity__c icVal:icEditList){
            icEditIndexList.add(new icListWithIndex(icVal,indexVar,saveFired));
            indexVar++;              
        }               
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Main method that passes Income Capacity 
                   calulcation to main income calculation method
     */
    public void calculateValues(){
        incomeCalculation(icEditList[integer.valueOf(indexValue)]);
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that returns integer frequency of payment 
                   value based on string value passed to it. 
                   Value is base on a span of 1 year.
     */
    public integer intervalCount(String intVar, Boolean isNZ){
        if(intVar=='Weekly'){return 52;}    
        else if(intVar=='Fortnightly'){return 26;}  
        else if(intVar=='Monthly'){return 12;}
        else if(intVar=='Bi-Monthly'){if(isNZ)return 6; else return 24;}
        else if(intVar=='Yearly'){return 1;}
        return 0;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that set null or negative value to zero.
     */
    public Decimal resetNullToZero(Decimal nullVariable){
        if(nullVariable == null || nullVariable<0){
            return 0;
        }else{
            return nullVariable;
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method to calculate rental income
     */
    public decimal calculateRentalIncome(Income_Capacity__c icVal,Decimal incomeValue){
       Decimal rentalIncome = 0;
       Decimal rentalPercent = 0;
    
       if(isNZ(icVal.RecordType.Name)){
            rentalPercent = 0.8;
       } else {
            rentalPercent = 0.9;
       }

       icVal.Rental_Income_per_ppty_owners__c = 0;
       rentalIncome = incomeValue;
       
       if(icVal.Method_of_Verification__c == 'Lease Agreement' ||
          icVal.Method_of_Verification__c == 'Verbal' ||
          icVal.Method_of_Verification__c == 'Verbal - Fax Request' || 
          icVal.Method_of_Verification__c == 'Policy Exception' ||
          // Update by: Adrian Recio
          // Added Rental Statement and Bank Statement Conditions
          icVal.Method_of_Verification__c == 'Rental Statement' || 
          icVal.Method_of_Verification__c == 'Bank Statement'){
            
            rentalIncome = incomeValue * rentalPercent;
       }
       
       if(!isNZ(icVal.RecordType.Name) && icVal.No_of_Property_Owners__c!=null){
            rentalIncome = rentalIncome/Integer.valueOf(icVal.No_of_Property_Owners__c);
       }
        
        icVal.Rental_Income_per_ppty_owners__c = rentalIncome;
               
       return rentalIncome;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that performs net income computation 
                   based on the calculation type selected by the user.
     */
    public void incomeCalculation(Income_Capacity__c icVal){
        
        // Reset all total values to zero 
        resetComputation(icVal);
        
        if(icVal.Previous_Employer_Name__c == null || icVal.Previous_Employer_Name__c == ''){
            // Validate Document Date
            APP_ProofIncomeDetail_CCINT.validateDocDate(icVal, isNZ(icVal.RecordType.Name));
            
            // If method of verification is Tax Return or Profit & Loss
            if(icVal.Method_of_Verification__c == 'Tax Return' || icVal.Method_of_Verification__c == 'Profit & Loss' || 
               icVal.Method_of_Verification__c == 'Individual Tax Return'){     //MLASALA 28-JUL-16
                   
                Decimal incomeValue = 0;
                
                // Pull income source value based on verification type
                if(icVal.Method_of_Verification__c == 'Tax Return'  || 
                   icVal.Method_of_Verification__c == 'Individual Tax Return'){     //MLASALA 28-JUL-16
                       
                    incomeValue = resetNullToZero(icVal.Taxable_Income__c);
                }else{
                    incomeValue = resetNullToZero(icVal.Net_Profit_Before_Tax__c);
                }
                
                // Populate Tax Return or Profit & Loss Values
                icVal.Less_Tax__c = taxValue(icVal,incomeValue); 
                icVal.EQUALS_ADJUSTED_INCOME__c = incomeValue; 
                icVal.ADJUSTED_INCOME_YEARLY__c = (resetNullToZero(icVal.EQUALS_ADJUSTED_INCOME__c) - resetNullToZero(icVal.Less_Tax__c)) + 
                                                      resetNullToZero(icVal.plus_Depreciation__c)  + 
                                                      resetNullToZero(icVal.plus_Interest__c) + 
                                                      resetNullToZero(icVal.plus_Personal_Superannuation__c);
                                                      
                icVal.Net_Monthly_Income__c = resetNullToZero(icVal.ADJUSTED_INCOME_YEARLY__c/12);
                
                icVal.Annualised_Net_Income__c = icVal.ADJUSTED_INCOME_YEARLY__c;
                icVal.Annualised_Net_Income_per_Month__c = icVal.Net_Monthly_Income__c;
                            
            }else{
                Decimal incomeValue = 0;
                Integer intervalCount = 0;  
                
                // If Salary Sacrifice pull lowest income source
                if(icVal.Salary_Sacrifice__c == 'Yes'){
                    intervalCount = interValCount(icVal.SS_Frequency_of_Payment__c, isNZ(icVal.RecordType.Name));
                    incomeValue = pullLowestIncomeSource(icVal) + resetNullToZero(icVal.Salary_Sacrifice_Income_Portion__c);
                }else{
                    intervalCount = interValCount(icVal.Frequency_of_Payment__c, isNZ(icVal.RecordType.Name));
                    incomeValue = pullLowestIncomeSource(icVal);
                }
                
                // Net Income Calculation Condition         
                if(icVal.Method_of_Calculation__c == 'Net Income' || icVal.Salary_Sacrifice__c == 'Yes'){
                        // Rental Income Calculation valid only for rental employment type and verification method
                        if((icVal.Employment_Type__c == 'Rental Income Agency' || icVal.Employment_Type__c == 'Rental Income Private' || 
                            icVal.Employment_Type__c == 'Rental Income') && 
                           (icVal.Method_of_Verification__c == 'Lease Agreement' || icVal.Method_of_Verification__c == 'Verbal' ||
                            icVal.Method_of_Verification__c == 'Verbal - Fax Request' || icVal.Method_of_Verification__c == 'Bank Statement' || 
                            icVal.Method_of_Verification__c == 'Rental Statement' || icVal.Method_of_Verification__c == 'Policy Exception'
                            ||  icVal.Method_of_Verification__c == 'Proviso')){
                            incomeValue = calculateRentalIncome(icVal,incomeValue);
                        }
                        
                        // Populate Net Income Values
                        icVal.Minimum_Income_Used__c = incomeValue;
                        icVal.Annualised_Net_Income__c = icVal.Minimum_Income_Used__c * intervalCount;
                        icVal.Annualised_Net_Income_per_Month__c = icVal.Annualised_Net_Income__c/12;
                // Net YTD Calculation Condition
                }else if(icVal.Method_of_Calculation__c == 'Net YTD'){
                        // Validate YTD Dates Before calculation
                        Boolean hasDateError = APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal);
                        if(hasDateError==false){

                            if(icVal.Employment_Type__c == 'Rental Income'){
                                incomeValue = calculateRentalIncome(icVal,incomeValue);
                            }
                            // Populate Net ytd values
                            icVal.Net_YTD__c = incomeValue;
                            icVal.Annualised_Net_Income__c = ytdValue(icVal,icVal.Net_YTD__c);
                            icVal.Annualised_Net_Income_per_Month__c = icVal.Annualised_Net_Income__c/12;
                        }
                // Gross Income, Base Gross Income and Gross Taxable Income Calculation Condition
                }else if(icVal.Method_of_Calculation__c == 'Gross Income' 
                        || icVal.Method_of_Calculation__c == 'Base Gross Income' 
                        || icVal.Method_of_Calculation__c == 'Gross Taxable Income'){
                        // Populate Gross income values

                        if(icVal.Employment_Type__c == 'Rental Income'){
                            incomeValue = calculateRentalIncome(icVal,incomeValue);
                        }

                        icVal.Minimum_Income_Used__c = incomeValue;
                        icVal.Annualised_Gross_Income__c = icVal.Minimum_Income_Used__c * intervalCount;
                        icVal.Less_Tax__c = taxValue(icVal,icVal.Annualised_Gross_Income__c);
                        icVal.Annualised_Net_Income__c = icVal.Annualised_Gross_Income__c - icVal.Less_Tax__c;
                        icVal.Annualised_Net_Income_per_Month__c = icVal.Annualised_Net_Income__c / 12;
                // Gross YTD Calculation Condition
                }else if(icVal.Method_of_Calculation__c == 'Gross YTD'){
                        // Validate YTD Dates Before calculation
                        Boolean hasDateError = APP_ProofIncomeDetail_CCINT.validateYtdDate(icVal);
                        if(hasDateError == false){

                            if(icVal.Employment_Type__c == 'Rental Income'){
                                incomeValue = calculateRentalIncome(icVal,incomeValue);
                            }
                            // Populate Gross YTD values
                            icVal.Gross_YTD__c = incomeValue;
                            icVal.Gross_Annualised_per_annum__c = ytdValue(icVal,icVal.Gross_YTD__c);
                            icVal.Gross_Annualised_per_month__c = icVal.Gross_Annualised_per_annum__c/12;
                            icVal.Less_Tax__c = taxValue(icVal,icVal.Gross_Annualised_per_annum__c);
                            icVal.Annualised_Net_Income__c = icVal.Gross_Annualised_per_annum__c - icVal.Less_Tax__c;
                            icVal.Annualised_Net_Income_per_Month__c = icVal.Annualised_Net_Income__c/12;
                        }   
                }
            }
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that computes yearTodate income 
                   based on a given salary start and finish date.
     */
    public Decimal ytdValue(Income_Capacity__c icVal, Decimal givenSalary){
        Integer addDays = 1;

        if(isNZ(icVal.RecordType.Name)){
            addDays = 0;
        }

        Decimal noOfDaysGross = icVal.YTD_Start_Date__c.daysBetween(icVal.YTD_Finish_Date__c)+addDays;
        Decimal noOfWeeksGross = noOfDaysGross / 7;
        Decimal avgperWeekGross =  givenSalary / noOfWeeksGross; 
        Decimal ytdValue = 0;

        if(isNZ(icVal.RecordType.Name)){
            ytdValue = avgperWeekGross*52;
        } else {
            ytdValue = (avgperWeekGross*52)+(avgperWeekGross/7);
        }
        
        system.debug('$$$ noOfDaysGross:' + noOfDaysGross);
        system.debug('$$$ noOfWeeksGross:' +noOfWeeksGross);
        system.debug('$$$ avgperWeekGross:' +avgperWeekGross);
        system.debug('$$$ ytdValue:' +ytdValue);
        return ytdValue;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that computes tax value based on a given salary
     */
    public Decimal taxValue(Income_Capacity__c icVal,Decimal givenSalary){
        
        Decimal taxValue = 0;
        
        system.debug('Tax Income Id:' + icVal.Tax_Income__c);
        
        if(icVal.RecordTypeId != null){
            taxIncomeRecordTypeId = Schema.Sobjecttype.Tax_Income_Line_Item__c.getRecordTypeInfosByName().get(icVal.RecordType.Name).getRecordTypeId();
        } else {
            taxIncomeRecordTypeId = Schema.Sobjecttype.Tax_Income_Line_Item__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.AU_REGION).getRecordTypeId();
        }
        System.debug('$$$ taxIncomeRecordTypeId: '+taxIncomeRecordTypeId);
        
        if(icVal.Tax_Income__c!=null){
           List<Tax_Income__c> tiList = [Select Id, 
                                               Medicare__c, 
                                               Tax_Year__c, 
                                               ACC_Earners_Levy__c, 
                                               ACC_Earners_Levy_Cap__c,
                                               Student_Loan_Rate__c,
                                               Student_Loan_Threshold__c 
                                        from   Tax_Income__c 
                                        where Id = :icVal.Tax_Income__c]; 

           List<Tax_Income_Line_Item__c> mainRangeList = [Select Id,Starting_Amount__c,Max__c,Plus_Every__c 
                                                          from Tax_Income_Line_Item__c 
                                                          where Tax_Income__c = :icVal.Tax_Income__c 
                                                          and Starting_Amount__c<=:givenSalary 
                                                          and Max__c >=:givenSalary 
                                                          and RecordTypeId =: taxIncomeRecordTypeId limit 1];
           
           // If zero matches pull infinite max range
           if(mainRangeList.size()==0){
                mainRangeList = [Select Id,Starting_Amount__c,Max__c,Plus_Every__c 
                                        from Tax_Income_Line_Item__c 
                                        where Tax_Income__c = :icVal.Tax_Income__c 
                                        and Starting_Amount__c<=:givenSalary 
                                        and Max__c = 0 
                                        and RecordTypeId =: taxIncomeRecordTypeId limit 1];
           }
           
           if(tiList.size()>0){
               for(Tax_Income_Line_Item__c tiLItemVar: mainRangeList){
                    Decimal subMaxRange = tiLItemVar.Starting_Amount__c; //- 1 //Updated BY DYU 27-AUG-2015 PMIHM 1940
                    Decimal taxAmount = 0;
                    Decimal mediCareLevi = 0;
                    Decimal kiwiSaver = 0;
                    Decimal studentLoan = 0; 
                   //Decimal startAmount = tiLItemVar.Starting_Amount__c - 1; //Removed BY DYU 27-AUG-2015 PMIHM 1940
                    totalLevy = 0;
                    
                    if(!isNZ(icVal.RecordType.Name)){
                        taxAmount = computeTaxAmount(subMaxRange,icVal.Tax_Income__c, isNZ(icVal.RecordType.Name), null).round(RoundingMode.UP);
                        mediCareLevi = (tiList[0].Medicare__c * 0.01) * givenSalary;
                        system.debug('mediCare Value:' + tiList[0].Medicare__c);
                        system.debug('mediCarLevi:' + mediCareLevi);
                    } else {
                        taxAmount = computeTaxAmount(subMaxRange,icVal.Tax_Income__c, isNZ(icVal.RecordType.Name), tiList.get(0).ACC_Earners_Levy__c);
                        Integer intervalCount = interValCount(icVal.Frequency_of_Payment__c, isNZ(icVal.RecordType.Name));
                        Decimal kiwiPercent = 0;
                        
                        if(icVal.Kiwi_Saver__c != null && intervalCount != 0){
                            kiwiPercent = Decimal.valueOf(icVal.Kiwi_Saver__c.subString(0, icVal.Kiwi_Saver__c.length() - 1));
                            if(kiwiPercent > 0){
                                kiwiSaver = givenSalary * (kiwiPercent / 100);
                            }
                        }
                        
                        if(icVal.Student_Loan__c == 'Yes' && givenSalary > tiList.get(0).Student_Loan_Threshold__c){
                            studentLoan = (givenSalary - tiList.get(0).Student_Loan_Threshold__c) * (tiList.get(0).Student_Loan_Rate__c / 100);
                        }
                        if(subMaxRange < 0){
                            subMaxRange = 0;
                        }
                        
                        if(tiList.get(0).ACC_Earners_Levy__c != null){
                            totalLevy += ((givenSalary - (subMaxRange)) * (tiList.get(0).ACC_Earners_Levy__c / 100)).setScale(2);
                            System.debug('$$$ totalLevy: '+totalLevy+' (main range)');
                        }
                        System.debug('$$$ kiwiSaver: '+kiwiSaver);
                        System.debug('$$$ studentLoan: '+studentLoan);
                                                
                        System.debug('$$$ Levy Cap: '+totalLevy+' > '+tiList.get(0).ACC_Earners_Levy_Cap__c);
                        if(totalLevy > tiList.get(0).ACC_Earners_Levy_Cap__c){
                            totalLevy = tiList.get(0).ACC_Earners_Levy_Cap__c;
                            System.debug('$$$ Set Levy Cap: '+totalLevy+' = '+tiList.get(0).ACC_Earners_Levy_Cap__c);
                        }
                        
                        if(startAmount < 0){
                            startAmount = 0;
                        }
                    }
                    system.debug('Tax Amount:' + taxAmount);
                    system.debug('Plus every:' + tiLItemVar.Plus_Every__c);
                    system.debug('start amount:' + tiLItemVar.Starting_Amount__c);
                    system.debug('given salary:' + givenSalary);
                    
                    Decimal rangeTax = ((givenSalary - (startAmount)) * tiLItemVar.Plus_Every__c) + taxAmount;
                    system.debug('$$$ rangeTax: ' + ((givenSalary - (tiLItemVar.Starting_Amount__c - 1)) * tiLItemVar.Plus_Every__c).setScale(0));
                    taxValue = mediCareLevi + rangeTax + kiwiSaver + studentLoan + totalLevy;
                    
                    system.debug('Given:' + givenSalary);
                    system.debug('taxRange:' + rangeTax);
                    system.debug('taxValue:' + taxValue);
                    system.debug('taxAmount:' + taxAmount);
               }
           }
           
        }else{
            return 0;
        }
        return taxValue;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that pulls lowest income source 
                   based on income fields present in an 
                   Income Capacity records
     */
    public Decimal pullLowestIncomeSource(Income_Capacity__c icVal){
        Decimal lowestIncomeSource = 0;
        List<Decimal>valueList = new List<Decimal>();
        
        if(icVal.Income_1__c != 0 && icVal.Income_1__c!=null){
            valueList.add(icVal.Income_1__c);
        }
        if(icVal.Income_2__c!=0 && icVal.Income_2__c!=null){
            valueList.add(icVal.Income_2__c);
        }
        if(icVal.Income_3__c!=0 && icVal.Income_3__c!=null){
            valueList.add(icVal.Income_3__c);
        }
        if(icVal.Payslip_1_Income__c!=0 && icVal.Payslip_1_Income__c!=null){
            valueList.add(icVal.Payslip_1_Income__c);
        }
        if(icVal.Payslip_2_Income__c!=0 && icVal.Payslip_2_Income__c!=null){
            valueList.add(icVal.Payslip_2_Income__c);
        }
        if(icVal.Lowest_Income_Deposit__c!=0 && icVal.Lowest_Income_Deposit__c!=null){
            valueList.add(icVal.Lowest_Income_Deposit__c);
        }   
        if(icVal.Net_Income_Salary_Sacrifice__c!=0 && icVal.Net_Income_Salary_Sacrifice__c!=null){
            valueList.add(icVal.Net_Income_Salary_Sacrifice__c);
        }
        
        if(valueList.size()>0){
            lowestIncomeSource = valueList[0];
            for(Decimal deciVar: valueList){
                if(deciVar<lowestIncomeSource){
                    lowestIncomeSource = deciVar;
                }
            }
        }
        return lowestIncomeSource;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that computes total tax amount based 
                   on the tax range a given gross income falls.
     */
    public Decimal computeTaxAmount(Decimal subMaxRange,Id parentTaxIncome, Boolean isNZ, Decimal accLevy){
        startAmount = 0; //Added BY DYU 27-AUG-2015 PMIHM 1940

        // Cancel negative values
        if(subMaxRange<0){
            subMaxRange = 0;
        }
        
        // Pull Sub Range
        //BEGIN Updated BY DYU 27-AUG-2015 PMIHM 1940
        List<Tax_Income_Line_Item__c> subRangeList = [Select Id,Starting_Amount__c,Max__c,Plus_Every__c 
                                                             from Tax_Income_Line_Item__c 
                                                             where Max__c < :subMaxRange and Max__c!=0 
                                                             and Tax_Income__c = :parentTaxIncome 
                                                             and RecordTypeId =: taxIncomeRecordTypeId 
                                                             order by Max__c ASC];
        //END BY DYU 27-AUG-2015 PMIHM 1940
        Decimal taxAmountVal = 0;
        
        for(Tax_Income_Line_Item__c tiLItem: subRangeList ){
            //BEGIN Updated BY DYU 27-AUG-2015 PMIHM 1940
            if(tilItem.Max__c > startAmount)
                startAmount = tilItem.Max__c;
            //END BY DYU 27-AUG-2015 PMIHM 1940
            taxAmountVal = ((tiLItem.Max__c - tiLItem.Starting_Amount__c)* tiLItem.Plus_Every__c) + taxAmountVal;
            system.debug('Max Value:' + tiLItem.Max__c);
            system.debug('Total Amount:' + taxAmountVal);
            
            if(isNZ){
                taxAmountVal = taxAmountVal.setScale(0);
                System.debug('$$$ taxAmountVal: '+taxAmountVal+' iteration');
                if(accLevy != null){
                    totalLevy = ((tiLItem.Max__c - tiLItem.Starting_Amount__c) * (accLevy / 100)).setScale(1) + totalLevy;
                    System.debug('$$$ totalLevy: '+totalLevy+' iteration');
                }
            }
        }
        
        return taxAmountVal;
    }
    
   
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: March 5, 2014
     *Description: Determine financial start date based on a given date 
     */
     public static Date financialStartDate(Date stdVar, Boolean isNZReg){
        if(stdVar!=null){
            Integer yearValue;
            Integer monthValue = stdVar.month();
            Integer monthValueByReg = 0;

            if(isNZReg==true){
                monthValueByReg = 4;
            }else{
                monthValueByReg = 7;
            }

            if(monthValue < monthValueByReg){
                yearValue = stdVar.addYears(-1).year();
            }else{
                yearValue = stdVar.year();
            }
            
            if(isNZReg==true){
                // NZ Financial start date is 1/4/XXXX (April 1)
                return Date.newInstance(yearValue, 4, 1);
            }else{
                // AU Financial start date is 1/7/XXXX (July 1)
                return Date.newInstance(yearValue, 7, 1);
            }
        }
        
        return null;
     }
     
     /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: March 5, 2014
     *Description: Datermine financial end date based on a given date
     */
     public static Date financialFinishDate(Date ftdVar, Boolean isNZReg){
        if(ftdVar!=null){
            Integer yearValue;
            Integer monthValue = ftdVar.month();
            Integer monthValueByReg = 0;

            if(isNZReg==true){
                monthValueByReg = 4;
            }else{
                monthValueByReg = 7;
            }

            if(monthValue < monthValueByReg){
                yearValue = ftdVar.year();
            }else{
                yearValue = ftdVar.addYears(1).year() ;
            }
            
            if(isNZReg==true){
                // NZ Financial finish date is 31/3/XXXX (March 31)
                return Date.newInstance(yearValue, 3, 31);
            }else{
                // AU Financial finish date is 30/6/XXXX (June 30)
                return Date.newInstance(yearValue, 6, 30);
            }
            
        }
        
        return null;
     }
     
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that performs year to date fields
     */
     public static Boolean validateYtdDate(Income_Capacity__c icVal){
        
        Boolean hasError = false;
        Boolean isNZReg = isNZ(icVal.RecordType.Name);
        // Determine financial start and end dates
        Date startDateFY = APP_ProofIncomeDetail_CCINT.financialStartDate(icVal.YTD_Start_Date__c,isNZReg);
        Date endDateFY = APP_ProofIncomeDetail_CCINT.financialFinishDate(icVal.YTD_Start_Date__c,isNZReg);
           
     
        system.debug('YTD Date Is NZ:' + isNZReg);
        system.debug('Start date calulcated:' + startDateFY);
        system.debug('End date calulcated:' + endDateFY);
        system.debug('Val Start date calulcated:' + icVal.YTD_Start_Date__c);
        system.debug('Val End date calulcated:' + icVal.YTD_Finish_Date__c);
       
        
        if(icVal.YTD_Start_Date__c!=null && icVal.YTD_Finish_Date__c!=null){
            if(icVal.YTD_Start_Date__c>Date.today()){
                icVal.YTD_Start_Date__c.addError('Future Date Entered. Please re-enter.');
                hasError = true;
            // TQLQW-357 [PL - AU & NZ] Salesforce Income Calculator Changes - Modified by MDAVID -05/26/2016
            }else if(isNZReg == true) {
                if(icVal.YTD_Finish_Date__c>Date.today()){
                    icVal.YTD_Finish_Date__c.addError('Future Date Entered. Please re-enter.');
                    hasError = true;
                }
            }else if(icVal.YTD_Start_Date__c > icVal.YTD_Finish_Date__c){
                icVal.YTD_Start_Date__c.addError('Start date cannot be greater than finish date.');
                hasError = true;
            }else if(icVal.YTD_Start_Date__c.addMonths(2)>icVal.YTD_Finish_Date__c){
                icVal.YTD_Finish_Date__c.addError('Duration less than 2 Months.You cannot select YTD option');
                hasError = true;
            }else if(!(startDateFY <= icVal.YTD_Start_Date__c && endDateFY >= icVal.YTD_Finish_Date__c)){
                icVal.YTD_Start_Date__c.addError('Start and End Date should not be across financial years.');
                icVal.YTD_Finish_Date__c.addError('Start and End Date should not be across financial years.');
                hasError = true;
            }
        }else{
            hasError = true;
        }
        return hasError;
     }
      
     /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Method that validate document date order
     */
     public static Boolean validateDocDate(Income_Capacity__c icVal, Boolean nz){

        // Variable Declaration 
        Date earliestDocDate;  // Earliest dated payslip/income
        List<Date>dateList = new List<Date>();  // List of payslip/income 
        Boolean hasDateError = false; // Flag variable if there is an error/satisfied validation
        Date dateTodayVar = System.today();

        // If there are errors, return flag set to true
        if(hasDateError){
            return hasDateError;
        }
        
        // Build payslip/income list for interval validation
        if(icVal.Method_of_Verification__c == 'Payslip'){
            if(icVal.Payslip_1_DD__c!=null){
                dateList.add(icVal.Payslip_1_DD__c);
            }
            if(icVal.Payslip_2_DD__c!=null){
                dateList.add(icVal.Payslip_2_DD__c);
            }
            if(icVal.Payslip_3_DD__c!=null){
                dateList.add(icVal.Payslip_3_DD__c);
            }
        }else{
            if(!icVal.Is_e_POI__c){ // ADDEd by RCADAPAN for TQLQW-534 @ 24-OCT-2016
                if(icVal.Income_1_DD__c!=null){
                    dateList.add(icVal.Income_1_DD__c);
                }
                if(icVal.Income_2_DD__c!=null){
                    dateList.add(icVal.Income_2_DD__c);
                }
                if(icVal.Income_3_DD__c!=null){
                    dateList.add(icVal.Income_3_DD__c);
                }
            }
        }
             
        // If date count is more than 1 perform interval validation
        if(dateList.size()>1){
            // Validate date if region is AU or region is AU and Employment Type is Casual and Method of Verification is Payslip
            earliestDocDate = dateList[0];
            dateList.remove(0);
 
            for(Date dateVar: dateList){
                system.debug('Current Date:' + dateVar);
                system.debug('Minimum Date:' + earliestDocDate);

                if(dateVar<=earliestDocDate){
                    hasDateError = true;
                }else if(icVal.Frequency_of_Payment__c == 'Weekly' && earliestDocDate.daysBetween(dateVar) != 7){
                    hasDateError = true;
                }else if(icVal.Frequency_of_Payment__c == 'Fortnightly' && earliestDocDate.daysBetween(dateVar) != 14){
                    hasDateError = true;
                }else if(icVal.Frequency_of_Payment__c == 'Monthly' && earliestDocDate.monthsBetween(dateVar) != 1){
                    hasDateError = true;
                }else if(icVal.Frequency_of_Payment__c == 'Bi-Monthly' && earliestDocDate.daysBetween(dateVar) != 15){
                    hasDateError = true;
                }else if(icVal.Frequency_of_Payment__c == 'Yearly' && earliestDocDate.monthsBetween(dateVar) != 12){
                    hasDateError = true;
                }
              
                earliestDocDate = dateVar;
                system.debug('Has Error:' + hasDateError);
            }
        }

        if(hasDateError){
            if(icVal.Method_of_Verification__c == 'Payslip'){
                icVal.Payslip_1_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
                icVal.Payslip_2_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
                icVal.Payslip_3_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
            }else{
                icVal.Income_1_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
                icVal.Income_2_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
                icVal.Income_3_DD__c.addError('Document Date should be consecutive dates based on frequency of payment.');
            }
        }

        // Initial Date Validation specific to NZ
        // This validation will apply for Payslip and Bank Statement verification types
        // Validation will ensure that there are no future dates and date is dated correctly based on frequency of payment
        if(nz && icVal.Method_of_Verification__c == 'Bank Statement'){
            string bankMsg = 'Income should be dated starting sixty days back up to date today.';
            if(icVal.Income_1_DD__c!=null){
                if((math.abs(dateTodayVar.daysBetween(icVal.Income_1_DD__c)) > 60 && dateTodayVar>icVal.Income_1_DD__c) || dateTodayVar<icVal.Income_1_DD__c){
                    icVal.Income_1_DD__c.addError(bankMsg);
                    hasDateError = true;
                }
            }

            if(icVal.Income_2_DD__c!=null){
                if((math.abs(dateTodayVar.daysBetween(icVal.Income_2_DD__c)) > 60 && dateTodayVar>icVal.Income_2_DD__c) || dateTodayVar<icVal.Income_2_DD__c){
                    icVal.Income_2_DD__c.addError(bankMsg);
                    hasDateError = true;
                }
            }

            if(icVal.Income_3_DD__c!=null){
                if((math.abs(dateTodayVar.daysBetween(icVal.Income_3_DD__c)) > 60 && dateTodayVar>icVal.Income_3_DD__c) || dateTodayVar<icVal.Income_3_DD__c){
                    icVal.Income_3_DD__c.addError(bankMsg);
                    hasDateError = true;
                }
            }

            if(icVal.Lowest_Income_Deposit_DD__c!=null){
                if((math.abs(dateTodayVar.daysBetween(icVal.Lowest_Income_Deposit_DD__c)) > 60 && dateTodayVar>icVal.Lowest_Income_Deposit_DD__c) || dateTodayVar<icVal.Lowest_Income_Deposit_DD__c){
                    icVal.Lowest_Income_Deposit_DD__c.addError(bankMsg);
                    hasDateError = true;
                }
            }
        }

        if(nz && icVal.Method_of_Verification__c == 'Payslip'){

            if(icVal.Frequency_of_Payment__c == 'Weekly'){
                string weekPayMsg = 'Payslip should be dated starting thirty days back up to date today.';
                if(icVal.Payslip_1_DD__c!=null){
                    system.debug('Days Between:' + dateTodayVar.daysBetween(icVal.Payslip_1_DD__c));
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_1_DD__c)) > 30 && dateTodayVar>icVal.Payslip_1_DD__c) || dateTodayVar<icVal.Payslip_1_DD__c){
                        icVal.Payslip_1_DD__c.addError(weekPayMsg);
                        hasDateError = true;
                    }
                }

                if(icVal.Payslip_2_DD__c!=null){
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_2_DD__c)) > 30 && dateTodayVar>icVal.Payslip_2_DD__c) || dateTodayVar<icVal.Payslip_2_DD__c){
                        icVal.Payslip_2_DD__c.addError(weekPayMsg);
                        hasDateError = true;
                    }
                }

                if(icVal.Payslip_3_DD__c!=null){
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_3_DD__c)) > 30 && dateTodayVar>icVal.Payslip_3_DD__c) || dateTodayVar<icVal.Payslip_3_DD__c){
                        icVal.Payslip_3_DD__c.addError(weekPayMsg);
                        hasDateError = true;
                    }
                }
            }

            if(icVal.Frequency_of_Payment__c == 'Fortnightly' || icVal.Frequency_of_Payment__c == 'Monthly'){
                string monthFortPayMsg = 'Payslip should be dated starting sixty days back up to date today.';
                if(icVal.Payslip_1_DD__c!=null){
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_1_DD__c)) > 60 && dateTodayVar>icVal.Payslip_1_DD__c) || dateTodayVar<icVal.Payslip_1_DD__c){
                        icVal.Payslip_1_DD__c.addError(monthFortPayMsg);
                        hasDateError = true;
                    }
                }
                
                if(icVal.Payslip_2_DD__c!=null){
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_2_DD__c)) > 60 && dateTodayVar>icVal.Payslip_2_DD__c) || dateTodayVar<icVal.Payslip_2_DD__c){
                        icVal.Payslip_2_DD__c.addError(monthFortPayMsg);
                        hasDateError = true;
                    }
                }

                if(icVal.Payslip_3_DD__c!=null){
                    if((math.abs(dateTodayVar.daysBetween(icVal.Payslip_3_DD__c)) > 60 && dateTodayVar>icVal.Payslip_3_DD__c) || dateTodayVar<icVal.Payslip_3_DD__c){
                        icVal.Payslip_3_DD__c.addError(monthFortPayMsg);
                        hasDateError = true;
                    }
                }
            }
        }
        
        return hasDateError;
     }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets sub fields when Employment Type is selected
     */
    public void empTypeClear(){
        icEditList[integer.valueOf(indexValue)].Method_of_Verification__c = null;
        icEditList[integer.valueOf(indexValue)].Salary_Sacrifice__c = 'No';
        icEditList[integer.valueOf(indexValue)].Frequency_of_Payment__c = null;
        icEditList[integer.valueOf(indexValue)].Method_of_Calculation__c = null;
        icEditList[integer.valueOf(indexValue)].Student_Loan__c = 'No';
        icEditList[integer.valueOf(indexValue)].Kiwi_Saver__c = '0%';
        //TQLQW-357 [PL - AU & NZ] Salesforce Income Calculator Changes - Added by MDAVID -06/08/2016
        icEditList[integer.valueOf(indexValue)].Overtime_Shift_Allowance__c = 'No';
        icEditList[integer.valueOf(indexValue)].Salary_Sacrifice_Items_itemized__c = null;
        icEditList[integer.valueOf(indexValue)].Is_e_POI__c = false; // Added by RCADAPAN for TQLQW-534 @ 24-OCT-2016
        // Set save fired boolean to false so that 
        // errors will disappear for components that can't use addError in visualforce
        // specifically for the select list visualforce tag.
        saveFired = false;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets sub fields when Method of Verification is selected
     */
    public void metVerClear(){
        icEditList[integer.valueOf(indexValue)].Salary_Sacrifice__c = 'No';               
        icEditList[integer.valueOf(indexValue)].Method_of_Calculation__c = null;
        icEditList[integer.valueOf(indexValue)].Frequency_of_Payment__c = null;      
        icEditList[integer.valueOf(indexValue)].Student_Loan__c = 'No';
        icEditList[integer.valueOf(indexValue)].Kiwi_Saver__c = '0%';
        //TQLQW-357 [PL - AU & NZ] Salesforce Income Calculator Changes - Added by MDAVID -05/31/2016
        icEditList[integer.valueOf(indexValue)].Overtime_Shift_Allowance__c = 'No';
        icEditList[integer.valueOf(indexValue)].Salary_Sacrifice_Items_itemized__c = null;
        icEditList[integer.valueOf(indexValue)].Is_e_POI__c = false; // Added by RCADAPAN for TQLQW-534 @ 24-OCT-2016
        if(isNZ(icEditList[integer.valueOf(indexValue)].RecordType.Name)){
            icEditList[integer.valueOf(indexValue)].YTD_Two_Months__c = 'Yes';
        }
        resetValues();
    }
        
        
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets sub fields when Salary Sacrifice is selected
     */
    public void sacrificeClear(){
        icEditList[integer.valueOf(indexValue)].Method_of_Verification__c = null;
        icEditList[integer.valueOf(indexValue)].Frequency_of_Payment__c = null;
        icEditList[integer.valueOf(indexValue)].Method_of_Calculation__c = null;
        icEditList[integer.valueOf(indexValue)].SS_Frequency_of_Payment__c = null;
        saveFired = false;
        resetValues();
    }
    
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets income and total fields
     */
    public void resetValues(){
        resetComputation(icEditList[integer.valueOf(indexValue)]);
        resetIncome(icEditList[integer.valueOf(indexValue)]);
        resetVerificationFields(icEditList[integer.valueOf(indexValue)]);
        
        // Set save fired boolean to false so that 
        // errors will disappear for components that can't use addError in visualforce
        // specifically for the select list visualforce tag.
        saveFired = false;
    }
        
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets income fields
     */
    public void resetIncome(Income_Capacity__c icVal){
        // YTD Date Fields
        icVal.YTD_Start_Date__c = null;
        icVal.YTD_Finish_Date__c = null;
        
        // Income Fields
        icVal.Income_1__c = 0;
        icVal.Income_2__c = 0;
        icVal.Income_3__c = 0;
        icVal.Payslip_1_Income__c = 0;
        icVal.Payslip_2_Income__c = 0;
        icVal.Payslip_3_Income__c = 0;
        icVal.Lowest_Income_Deposit__c = 0;
        
        // Salary Sacrifice Income Fields
        icVal.Net_Income_Salary_Sacrifice__c = 0;
        icVal.Salary_Sacrifice_Income_Portion__c = 0;
        
        // Tax Return and Profit & Loss Income Fields
        icVal.Taxable_Income__c = 0;
        icVal.Net_Profit_Before_Tax__c = 0;
        icVal.plus_Depreciation__c = 0;
        icVal.plus_Interest__c = 0;
        icVal.plus_Personal_Superannuation__c = 0;

        // Document Date Fields
        icVal.Income_1_DD__c = null;
        icVal.Income_2_DD__c = null;
        icVal.Income_3_DD__c = null;
        icVal.Payslip_1_DD__c = null;
        icVal.Payslip_2_DD__c = null;
        icVal.Payslip_3_DD__c = null;
        icVal.Lowest_Income_Deposit_DD__c = null;
        
        // Rental Fields
        icVal.No_of_Property_Owners__c = null;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets total fields
     */
    public void resetComputation(Income_Capacity__c icVal){
        // Total Fields
        icVal.Rental_Income_per_ppty_owners__c = 0;
        icVal.Gross_YTD__c = 0;
        icVal.Net_YTD__c = 0;
        icVal.Minimum_Income_Used__c = 0;
        icVal.Annualised_Net_Income__c = 0;
        icVal.Annualised_Net_Income_per_Month__c = 0;
        icVal.Less_Tax__c = 0;
        icVal.Annualised_Gross_Income__c = 0;   
        icVal.Gross_Annualised_per_annum__c = 0;
        icVal.Gross_Annualised_per_month__c = 0;
        
        // Tax Return and Profit & Loss Fields
        icVal.EQUALS_ADJUSTED_INCOME__c = 0;
        icVal.Less_Tax__c = 0;
        icVal.ADJUSTED_INCOME_YEARLY__c = 0;
        icVal.Net_Monthly_Income__c = 0;
        
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 20, 2014
     *Description: Resets verification fields
     */
    public void resetVerificationFields(Income_Capacity__c icVal){
        icVal.authorised_person_spoken__c = null;
        icVal.Position_Within_Business__c = null;
        icVal.Business_phone_number__c = null;
        icVal.Business_number_confirmed__c = null;
        icVal.How_Business_number_confirmed__c = null;
        icVal.Employment_and_Occupation_Confirmed__c = null;
        icVal.Customer_in_Probation__c = null;
        icVal.Start_Date_of_Employment__c = null;
    }
     
    /*Description: 
     *Author: Adrian Recio
     *Created Date: February 20, 2014
     *Description: If current date month is between January to June returns true else returns false
     */
    public Boolean validateCurrentTaxDate(){
        Integer currentMonth = Date.today().month();
        if(currentMonth>=1 && currentMonth<=6){
            return true;
        }
        return false;
    }
            
    /*Description: 
     *Author: Adrian Recio
     *Created Date: February 20, 2014
     *Description: Pulls all Tax Income values and 
                   converts it to select list option
     */
    public List<SelectOption> getFinancialYear(){
            Boolean taxMonth = validateCurrentTaxDate();
            Integer taxYearRecent;
            Integer taxYearLast;

            if(taxMonth == true){
                taxYearLast = Date.today().addYears(-2).year();
                taxYearRecent = Date.today().year();
            }else{
                taxYearLast = Date.today().addYears(-1).year();
                taxYearRecent = Date.today().addYears(1).year();
            }
        
            List<SelectOption> options = new List<SelectOption>();
            //options.add(new SelectOption('','--None--'));
            List<Tax_Income__c>tiList = [Select Id, Tax_Year__c from Tax_Income__c order by Tax_Year__c DESC];  
            for(Tax_Income__c tIVar: tiList){
                if(taxYearRecent >= Integer.valueOf(tIVar.Tax_Year__c) && taxYearLast <= Integer.valueOf(tIVar.Tax_Year__c)){
                    options.add(new SelectOption(string.valueOf(tIVar.Id),string.valueOf(tIVar.Tax_Year__c)));
                    
                    if(icEditList[integer.valueOf(indexValue)].Tax_Income__c == null && (Integer.valueOf(tIVar.Tax_Year__c) == (taxYearRecent - 1))){
                        icEditList[integer.valueOf(indexValue)].Tax_Income__c   = tIVar.Id;
                    }
                }
            }
            
            
            return options;
    }
    
    public void specialMainFieldReset(){
        icEditList[integer.valueOf(indexValue)].Method_of_Calculation__c = null;
        resetValues();
    }
    
    /*Description: 
     *Author: Adrian Recio
     *Created Date: February 20, 2014
     *Description: 
     */
    public List<SelectOption> getPayslipOther(){
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            options.add(new SelectOption('Net YTD','Net YTD'));

            return options;
    }
     /*
     *Author: Marvin David
     *Created Date: August 5, 2015
     *Description: Picklist values for Part time/Full time/Casual  employment type for payslip method for AU applications
     */
    public List<SelectOption> getPayslipPermanentAU(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         options.add(new SelectOption('Base Gross Income','Base Gross Income'));
         return options;

    }
     /*
     *Author: Fel Saliba
     *Created Date: July 28, 2014
     *Description: Picklist values for Part time/Full time  employment type for payslip method for NZ applications
     */
    public List<SelectOption> getPayslipPermanentNZ(){      //Modified for PMIHM 1940 - Marvin David
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net Income','Net Income'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         options.add(new SelectOption('Base Gross Income','Base Gross Income'));
         return options;

    }

    /*Description: 
     *Author: Fel Saliba
     *Created Date: July 28, 2014
     *Description: Picklist values for Part time/Full time  employment type for payslip method
     */
    public List<SelectOption> getPayslipPermanent(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net Income','Net Income'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         options.add(new SelectOption('Base Gross Income','Base Gross Income'));
         return options;

    }
    
    /*Description: 
     *Author: Fel Saliba
     *Created Date: July 28, 2014
     *Description: Picklist values for Overtime Shift Allowance employment type with 2 months ytd for payslip method
     */
    public List<SelectOption> getOvershiftTwoMonthsYes(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         return options;

    }
    /*Description: 
     *Author: Fel Saliba
     *Created Date: July 28, 2014
     *Description: Picklist values for Overtime Shift Allowance employment type without 2 months ytd employment type for payslip method
     */
    public List<SelectOption> getOvershiftTwoMonthsNo(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net Income','Net Income'));
         return options;
    }

    /*Description: 
     *Author: Mike Lasala
     *Created Date: June 11, 2015
     *Description: Picklist values for Permanent Full/Part Time employment type Summary of Earnings from NZ IRD method of verification
     */
    public List<SelectOption> getPermanentIRDSummary(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net Income','Net Income'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         return options;
    }
    
    /*Description: 
     *Author: Marvin David
     *Created Date: May 31, 2016
     *Description: Picklist values if Overtime Shift Allowance is Yes
     */
    public List<SelectOption> getOvertimeShiftAllowanceAU(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Net YTD','Net YTD'));
         options.add(new SelectOption('Net Income','Net Income'));
         return options;
    }

    /*Description: Boolean to identify whether brand is NZ 
     *Author: Michael Lasala
     *Created Date: November 07, 2014
     */
     /*
     public Boolean isNZ(String incomeCapacityRecordTypeName){
        Boolean flag = false;
        
        System.debug('$$$ incomeCapacityRecordTypeName: '+incomeCapacityRecordTypeName);
        
        if(incomeCapacityRecordTypeName != null && incomeCapacityRecordTypeName == GEN_OriginationsConstants.NZ_REGION){
            flag = true;
        }

        return flag;
     }
     */
 
     /*Description: Boolean to identify whether brand is NZ
     *Author: Adrian Recio
     *Created Date: July 21, 2015
     */
     public static Boolean isNZ(String incomeCapacityRecordTypeName){
        Boolean flag = false;
        
        System.debug('$$$ incomeCapacityRecordTypeName: '+incomeCapacityRecordTypeName);
        
        if(incomeCapacityRecordTypeName != null && incomeCapacityRecordTypeName == GEN_OriginationsConstants.NZ_REGION){
            flag = true;
        }

        return flag;
     }
     
      /*
     *Author: Suneel Desiraju
     *Created Date: January 23,2021
     *Project : POI Automation
     *Description: Populate Method of verification as "Verifier" when the verifier amount is recieved from Activate.
     */
//     public static void populateVerifier(Application__c app,List<Income__c> inc,Income_Capacity__c icVar)
       public static void populateVerifier(Income_Capacity__c icVar){
         Application__c app;
         String applicantMode = ApexPages.currentPage().getParameters().get('applicantMode');
         List<Applicant__c> appList;
         List<Income__c> incJointListA1;
         List<Income__c> incJointListA2;
         
         try{
         Id id = ApexPages.currentPage().getParameters().get('id');                 
         app = [select id,Brand_Country__c,isRemainingCapacityNegative__c,EVerifier_Request_Date_Applicant_1__c,EVerifier_Request_Date_Applicant_2__c,EVerifier_Income_Applicant_1__c,Application_Type__c,EVerifier_Income_Applicant_2__c,Unsecured_Limit__c,Final_Approved_Date__c,isPOIVerified__c from Application__c where id = :id];
         //inc  = [select Emp_Bus_Name__c,Income_Source__c,Applicant__r.isAlertVerified__c from Income__c where Applicant__c in (select id from Applicant__c where Application__c = :id)];
         appList = [select isPOIVerified__c,POI_Financial_Situation_Verified__c,isAlertVerified__c,application__r.EVerifier_Alert_Applicant_1__c,application__r.EVerifier_Alert_Applicant_2__c from Applicant__c where Application__c =:id];
       
         incJointListA1 = [select Emp_Bus_Name__c,Income_Source__c,Applicant__r.isAlertVerified__c from Income__c where Applicant__c =: appList[0].id];
         if(appList.size() > 1){
         incJointListA2 = [select Emp_Bus_Name__c,Income_Source__c,Applicant__r.isAlertVerified__c from Income__c where Applicant__c =: appList[1].id];
         }
        }catch(Exception e){}
         APP_ProofIncomeDetail_CCINT pid = new APP_ProofIncomeDetail_CCINT();
         
         Set<String> incomeSources = new Set<String>{'My permanent - full time job','My permanent - part time job',
         'My contracting job','My self-employed business'};
         
       
       
        // for(Application__c app : ar){
                
                  for(Income__c incList : incJointListA1){
                  integer count = 0;
                  integer incSourceRes;
                           for(integer i=0; i<incJointListA1.size();i++){
                                                        
                             if(incomeSources.contains(incJointListA1[i].Income_Source__c)){
                             count ++;
                             incSourceRes = count;                                                  
                              if(app.Application_Type__c == 'Single' && app.Brand_Country__c == 'AU' && incSourceRes == 1 && (app.isRemainingCapacityNegative__c == false || (app.isRemainingCapacityNegative__c == true && appList[0].POI_Financial_Situation_Verified__c == true) )){
                                    //For Single Applicant
                                    if(
                                    (
                                    icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c || 
                                    icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c || 
                                    icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA1[i].Emp_Bus_Name__c || 
                                    icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA1[i].Emp_Bus_Name__c
                                    )                                 
                                    && app.EVerifier_Income_Applicant_1__c != null && incList.applicant__r.isAlertVerified__c == false
                                    ){
                                            
                                            if(icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Full Time';
                                            }else if(icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Fixed Term Contract';
                                            }else if(icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Part Time';
                                            }else if(icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Self Employed';
                                            }
                                            icVar.Method_Of_Verification__c = 'Verifier';
                                            icVar.Overtime_Shift_Allowance__c = 'No';
                                            icVar.Method_of_Calculation__c = 'Net Income';
                                            icVar.Frequency_of_Payment__c = 'Monthly';     
                                            icVar.Income_1__c =   app.EVerifier_Income_Applicant_1__c;     
                                            icVar.Income_1_DD__c = app.EVerifier_Request_Date_Applicant_1__c;
                                            pid.incomeCalculation(icVar);
                                                                                            
                                       }  
                                      }
                                    }  //End of Income Sources condition
                                            }    //End of Income size for loop 
                           }
                         
                           //Joint Applicant
                           
                            if(app.Application_Type__c == 'Joint' && app.Brand_Country__c == 'AU' ){
                            system.debug('Entered Joint Application');
                                       
                            //Applicant Mode 1
                            for(Income__c inca1: incJointListA1 ){
                                          integer countA1 = 0;
                                         integer incSourceResA1;
                                for(integer i=0; i<incJointListA1.size();i++){
                                                        
                                     if(incomeSources.contains(incJointListA1[i].Income_Source__c)){
                                     countA1 ++;
                                     incSourceResA1 = countA1;   
                                       if(
                                         (
                                           icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c || 
                                           icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c ||                                             
                                           icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA1[i].Emp_Bus_Name__c || 
                                           icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA1[i].Emp_Bus_Name__c
                                           )  
                                           && app.EVerifier_Income_Applicant_1__c != null && applicantMode == '1' && appList[0].isAlertVerified__c == false  
                                           && incSourceResA1 == 1  && (app.isRemainingCapacityNegative__c == false || (app.isRemainingCapacityNegative__c == true && appList[0].POI_Financial_Situation_Verified__c == true) )                              
                                         ){
                                               system.debug('Main Entrance for Applicant 1');
                                            if(icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Full Time';
                                            }else if(icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Fixed Term Contract';
                                            }else if(icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Part Time';
                                            }else if(icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA1[i].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Self Employed';
                                            }
                                                icVar.Method_Of_Verification__c = 'Verifier';
                                                icVar.Overtime_Shift_Allowance__c = 'No';
                                                icVar.Method_of_Calculation__c = 'Net Income';
                                                icVar.Frequency_of_Payment__c = 'Monthly';                                  
                                                icVar.Income_1__c =   app.EVerifier_Income_Applicant_1__c;
                                                icVar.Income_1_DD__c = app.EVerifier_Request_Date_Applicant_1__c;
                                                pid.incomeCalculation(icVar);
                                                }
                                           }
                                       }
                                    }
                                    
                                       //Applicant Mode 2
                                       for(Income__c inca2: incJointListA2 ){
                                          integer countA2 = 0;
                                         integer incSourceResA2;
                           for(integer j=0; j<incJointListA2.size();j++){
                                                        
                             if(incomeSources.contains(incJointListA2[j].Income_Source__c)){
                             countA2 ++;
                             incSourceResA2 = countA2;
                                        
                                       if(
                                       (icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA2[j].Emp_Bus_Name__c || 
                                           icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA2[j].Emp_Bus_Name__c ||                                           
                                           icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA2[j].Emp_Bus_Name__c || 
                                           icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA2[j].Emp_Bus_Name__c
                                           ) 
                                            && app.EVerifier_Income_Applicant_2__c!= null && applicantMode == '2' && appList[1].isAlertVerified__c == false
                                            && incSourceResA2 == 1 && (app.isRemainingCapacityNegative__c == false || (app.isRemainingCapacityNegative__c == true && appList[1].POI_Financial_Situation_Verified__c == true) )  
                                         ){
                                                  system.debug('Main Entrance for Applicant 2');     
                                           if(icVar.Income_Detail__c == 'My permanent - full time job' + ' ' + incJointListA2[j].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Full Time';
                                            }else if(icVar.Income_Detail__c == 'My contracting job' + ' ' + incJointListA2[j].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Fixed Term Contract';
                                            }else if(icVar.Income_Detail__c == 'My permanent - part time job' + ' ' + incJointListA2[j].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Permanent Part Time';
                                            }else if(icVar.Income_Detail__c == 'My self-employed business' + ' ' + incJointListA2[j].Emp_Bus_Name__c){
                                            icVar.Employment_Type__c = 'Self Employed';
                                            }
                                                        icVar.Method_Of_Verification__c = 'Verifier';
                                                        icVar.Overtime_Shift_Allowance__c = 'No';
                                                        icVar.Method_of_Calculation__c = 'Net Income';
                                                        icVar.Frequency_of_Payment__c = 'Monthly'; 
                                                        icVar.Income_1__c =   app.EVerifier_Income_Applicant_2__c;
                                                        icVar.Income_1_DD__c = app.EVerifier_Request_Date_Applicant_2__c;
                                                        pid.incomeCalculation(icVar);
                                                           } // End of Income sources if condition
                                                         } //End of Income sources condition
                                                      } //End of incJointListA2 size for Loop
                                                    } //End of incJointListA2  for loop
                                                  } //End of Joint Application If condition
                                                        
                                               // }
                                             
                                            
                        
                                            

                                          }    
                                          }
                                          /** End */