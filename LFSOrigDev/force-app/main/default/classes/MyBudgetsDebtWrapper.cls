/* @Description: Wrapper class for Debts
 * @Author: Dan Crisologo
 * @Date Created: DEC-09-2013
 * @History:
   =====================================================================
       12-09-13: Created - Dan
       01-30-14: Updated to latest methods - Mike
       04-09-15: Updated Defect 820 - Debt Category and Financial Institution is not required for NZ region
       05-29-15: Updated debts reduced credit limit calculation - Adrian 
   =====================================================================
 */ 

//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================

/*  Description: Wrapper class for the Liability(Debt) object
 *  Author: Fel Saliba
 *  Date Created: OCT-01-2013
 */
public class MyBudgetsDebtWrapper {    
    public Liability__c debt                {get;set;}
    public Applicant__c applicant       {get;set;}
    public Boolean categoryValid            {get;set;}
    public Boolean financierValid           {get;set;}
    public Boolean creditLimitValid         {get;set;}
    public Boolean cardOverdraftValid       {get;set;}
    public Boolean mortgageBalanceValid     {get;set;}
    public Boolean mortgageBorrowedValid    {get;set;}
    public Boolean carBalanceValid          {get;set;}
    public Boolean carRepayAmountValid      {get;set;}
    public Boolean carRepayIntervalValid    {get;set;}
    public Boolean carBorrowedAmountValid   {get;set;}
    public Boolean otherBalanceDescValid    {get;set;}
    public Boolean otherRepayAmountValid    {get;set;}
    public Boolean otherRepayIntervalValid  {get;set;}
    public Boolean applicantsValid          {get;set;}
    public Boolean consolidateValid         {get;set;}
    public Boolean typeOfDebt               {get;set;}
    public Boolean typeOfCreditCard         {get;set;}    
    public Boolean reducedCreditValid       {get;set;}
    public Boolean overdraftAPRValid        {get;set;}
    public Boolean mortgageRepayIntValid    {get;set;}
    public Boolean mortgageRepayValid       {get;set;}
    public String overdraftInvalidMsg       {get;set;}
    public Integer rowCount                 {get;set;}
    public Boolean isJoint                  {get;set;}
    /*  Description: Wrapper constructor, creates new income, refreshes validations
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public MyBudgetsDebtWrapper (Applicant__c applicant){
        this.debt = new Liability__c(Applicant__c = applicant.Id);
        this.categoryValid = true;
        this.financierValid = true;
        this.creditLimitValid = true;
        this.cardOverdraftValid = true;
        this.mortgageBalanceValid = true;
        this.mortgageBorrowedValid = true;
        this.carBalanceValid = true;
        this.carRepayAmountValid = true;
        this.carRepayIntervalValid = true;
        this.carBorrowedAmountValid = true;
        this.otherBalanceDescValid = true;
        this.otherRepayAmountValid = true;
        this.otherRepayIntervalValid = true;
        this.applicantsValid = true;
        this.consolidateValid = true;
        this.typeOfDebt = true;
        this.typeOfCreditCard = true;
        this.reducedCreditValid = true;
        this.overdraftAPRValid = true;
        this.mortgageRepayValid = true;
        this.mortgageRepayIntValid = true;
        this.overdraftInvalidMsg = '';
    }
    
    public MyBudgetsDebtWrapper (Liability__c oldLiability){
        this.debt = oldLiability;
        this.categoryValid = true;
        this.financierValid = true;
        this.creditLimitValid = true;
        this.cardOverdraftValid = true;
        this.mortgageBalanceValid = true;
        this.mortgageBorrowedValid = true;
        this.carBalanceValid = true;
        this.carRepayAmountValid = true;
        this.carRepayIntervalValid = true;
        this.carBorrowedAmountValid = true;
        this.otherBalanceDescValid = true;
        this.otherRepayAmountValid = true;
        this.otherRepayIntervalValid = true;
        this.applicantsValid = true;
        this.consolidateValid = true;
        this.typeOfDebt = true;
        this.typeOfCreditCard = true;        
        this.reducedCreditValid = true;
        this.overdraftAPRValid = true;
        this.mortgageRepayValid = true;
        this.mortgageRepayIntValid = true;
        this.overdraftInvalidMsg = '';
    }
    
    /*  Description: Validates all Liability fields in the wrapper
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateDebt(Boolean isCustomer, string region) {        
        Boolean validationResult = true;
    
        this.categoryValid = true;
        this.financierValid = true;
        this.creditLimitValid = true;
        this.cardOverdraftValid = true;
        this.mortgageBalanceValid = true;
        this.mortgageBorrowedValid = true;
        this.carBalanceValid = true;
        this.carRepayAmountValid = true;
        this.carRepayIntervalValid = true;
        this.carBorrowedAmountValid = true;
        this.otherBalanceDescValid = true;
        this.otherRepayAmountValid = true;
        this.otherRepayIntervalValid = true;
        this.applicantsValid = true;
        this.consolidateValid = true;
        this.typeOfDebt = true;
        this.typeOfCreditCard = true;        
        this.reducedCreditValid = true;
        this.overdraftAPRValid = true;
        this.mortgageRepayValid  = true;
        this.mortgageRepayIntValid = true; 
        this.overdraftInvalidMsg = '';

        if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
            if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT){
                if(region == GEN_OriginationsConstants.NZ_REGION && debt.type_of_credit_card__c == null){
                    this.typeOfCreditCard = false;
                    validationresult = false;
                }
            }
            if(debt.Credit_Limit_Amt__c==null || debt.Credit_Limit_Amt__c==0 || debt.Credit_Limit_Amt__c < 0) {
                this.creditLimitValid = false;
                validationresult = false;
            }
            if(debt.Card_Overdraft_Bal_Amt__c==null) {
                this.cardOverdraftValid = false;
                validationresult = false;
            }
            if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){
                if(debt.Reduced_Credit_Limit__c == null || debt.Reduced_Credit_Limit__c == 0 || debt.Reduced_Credit_Limit__c < 0){
                    this.reducedCreditValid  = false;
                    validationresult = false;
                }
            }
            if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT && region == 'AU'){
                if(debt.Overdraft_APR__c == null || debt.Overdraft_APR__c == 0){
                    validationresult = false;
                    this.overdraftAPRValid = false;
                    this.overdraftInvalidMsg = 'Error: Please enter Overdraft APR';
                }
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE) {
            if(debt.Mortgage_Bal_Amt__c==null || debt.Mortgage_Bal_Amt__c==0 || debt.Mortgage_Bal_Amt__c < 0) {
                this.mortgageBalanceValid = false;
                validationresult = false;
            }
            if(debt.Mortgage_Borrowed_Amt__c==null  || debt.Mortgage_Borrowed_Amt__c==0 || debt.Mortgage_Borrowed_Amt__c < 0) {
                this.mortgageBorrowedValid = false;
                validationresult = false;
            }
            if(debt.Mortgage_Repayment_Amt__c == null || debt.Mortgage_Repayment_Amt__c == 0 || debt.Mortgage_Repayment_Amt__c < 0){
                this.mortgageRepayValid = false;
                validationresult = false;
            }
            if(debt.Mortgage_Repayment_Interval__c == 'None' || debt.Mortgage_Repayment_Interval__c == null){
                this.mortgageRepayIntValid = false;
                validationresult = false;
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN  || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) {
            if(debt.Car_Personal_Bal_Amt__c==null || debt.Car_Personal_Bal_Amt__c==0 || debt.Car_Personal_Bal_Amt__c < 0) {
                this.carBalanceValid = false;
                validationresult = false;
            }
            if(debt.Car_Personal_Repay_Amt__c==null || debt.Car_Personal_Repay_Amt__c==0 || debt.Car_Personal_Repay_Amt__c < 0) {
                this.carRepayAmountValid = false;
                validationresult = false;
            }
            if(debt.Car_Personal_Repay_Int__c==null || debt.Car_Personal_Repay_Int__c=='None') {
                this.carRepayIntervalValid = false;
                validationresult = false;
            }
            if(debt.Car_Personal_Borrowed_Amt__c==null || debt.Car_Personal_Borrowed_Amt__c==0 || debt.Car_Personal_Borrowed_Amt__c < 0) {
                this.carBorrowedAmountValid = false;
                validationresult = false;
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER) {
            if((debt.Type_of_Debt__c == null || debt.Type_of_Debt__c == '') && region == GEN_OriginationsConstants.NZ_REGION){
                this.typeOfDebt = false;
                validationresult = false;
            }
            if(debt.Other_Borrowed_Amt__c==null || debt.Other_Borrowed_Amt__c < 0) {
                this.otherBalanceDescValid = false;
                validationresult = false;
            }
            if(debt.Other_Repay_Amt__c==null || debt.Other_Repay_Amt__c==0 || debt.Other_Repay_Amt__c < 0) {
                this.otherRepayAmountValid = false;
                validationresult = false;
            }
            if(debt.Other_Repay_Int__c==null || debt.Other_Repay_Int__c== 'None') {
                this.otherRepayIntervalValid = false;
                validationresult = false;
            }
        }
        return validationresult;
    }
    
    
    /*  Description: Check debt category to clear the value of unwanted fields
     *  Author: Fel Saliba
     *  Date Created: OCT-21-2013
     *  Input Parameters: None
     *  Return: Decimal 
     */
    public void clearDebtFields(){
        if(debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT && debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD && debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD && debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
            debt.Credit_Limit_Amt__c = null;
            debt.Card_Overdraft_Bal_Amt__c = null;    
            debt.Consolidate_Debt_Reduce_Limit__c = null;  
            debt.Reduced_Credit_Limit__c = null;
            if(debt.Debt_category__c != GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
                debt.Overdraft_APR__c = null;     
            }        
        }
        if((debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD) && debt.Consolidate_Debt_Reduce_Limit__c != GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){
                debt.Reduced_Credit_Limit__c = null;
                if(debt.Consolidate_Debt_Reduce_Limit__c == 'Please Select'){
                    debt.Overdraft_APR__c = null;
                    debt.Reduced_Credit_Limit__c = 0;
                }
        }
        if(debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE){
            debt.Mortgage_Bal_Amt__c = null;
            debt.Mortgage_Borrowed_Amt__c = null;
            debt.Mortgage_Repayment_Amt__c = null;
            debt.Mortgage_Repayment_Interval__c = null;
        }
        if(debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN && debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN && debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE){
            debt.Car_Personal_Bal_Amt__c = null;
            debt.Car_Personal_Repay_Amt__c = null;
            debt.Car_Personal_Repay_Int__c = null;
            debt.Car_Personal_Borrowed_Amt__c = null;
        }
        if(debt.Debt_Category__c != GEN_OriginationsConstants.DEBT_CATEGORY_OTHER){
            debt.Other_Borrowed_Amt__c = null;
            debt.Other_Repay_Amt__c = null;
            debt.Other_Repay_Int__c = null;
        }
    }
    
    /*  Description: Returns debt amount based on region
     *  Author: Fel Saliba
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: Decimal 
     */
    public Decimal getDebtAmount(string country) {
        system.debug('Brand country method in App common ' + country);
        if(country == GEN_OriginationsConstants.AU_REGION){
            system.debug('AU Method for debt calculation ' + getAUDebtAmount());
            return getAUDebtAmount();
        }
        else if(country == GEN_OriginationsConstants.NZ_REGION){
            system.debug('NZ Method for debt calculation ' + getNZDebtAmount());
            return getNZDebtAmount();
        }
        return 0;
    }
    
    /*  Description: Returns debt amount for AU
     *  Author: Fahad Akhtar
     *  Date Created: NOV-10-2014
     *  Input Parameters: None
     *  Return: Decimal 
     */
    public Decimal getAUDebtAmount() {
        system.debug('AU Method for debt calculation');     
        //MW-780 14/12/2020 Added By Suneel
        if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD){
        decimal repaymentPercent = GEN_OriginationsConstants.REPAYMENT_CALCULATION_THREE_PERCENT;
        if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                system.debug('if ' + repaymentPercent);
                if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                    system.debug('if if ' + debt.Credit_Limit_Amt__c * repaymentPercent);
                    return debt.Credit_Limit_Amt__c * repaymentPercent;
                }else{
                    system.debug('if else ' + GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT);
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                } 
            }else{
                system.debug('else');  
                if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                    return debt.Card_Overdraft_Bal_Amt__c * repaymentPercent;
                }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                }
            }
         } 
        //End MW-780       
        if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD) {
            if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                return debt.Credit_Limit_Amt__c * 0.03;
            }else{  
                return debt.Card_Overdraft_Bal_Amt__c * 0.03;
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
            if(debt.Overdraft_APR__c != null){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    return (debt.Credit_Limit_Amt__c * (debt.Overdraft_APR__c/100)) / 12;
                }else{
                    return (debt.Card_Overdraft_Bal_Amt__c * (debt.Overdraft_APR__c/100)) / 12;
                }
            }else{
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    return debt.Credit_Limit_Amt__c;
                }else{
                    return debt.Card_Overdraft_Bal_Amt__c;
                }
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE) {
            debt.Total_Debts__c = 0;
            if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Mortgage_Repayment_Amt__c * 52) / 12;
            }
            else if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Mortgage_Repayment_Amt__c * 26) / 12;
            }
            else if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Mortgage_Repayment_Amt__c;
            }
            return debt.Total_Debts__c;

        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) {
            debt.Total_Debts__c = 0;
            if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Car_Personal_Repay_Amt__c * 52) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Car_Personal_Repay_Amt__c * 26) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Car_Personal_Repay_Amt__c;
            }
            return debt.Total_Debts__c;
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER){
            debt.Total_Debts__c = 0;
            if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Other_Repay_Amt__c * 52) / 12;
            }
            else if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Other_Repay_Amt__c * 26) / 12;
            }
            else if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Other_Repay_Amt__c;
            }
            return debt.Total_Debts__c;
        }
        else {
            return 0;
        }
    } 
    
    /*  Description: Returns debt amount for NZ
     *  Author: Fahad Akhtar
     *  Date Created: NOV-10-2014
     *  Input Parameters: None
     *  Return: Decimal 
     */
    public Decimal getNZDebtAmount() {
      if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT) {
            decimal repaymentPercent = 0.0403;
            integer amount = 5;
            
            if(debt.Financier_List__c == 'Gem' && debt.Type_of_Credit_Card__c == 'Others'){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                   if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                    return (debt.Credit_Limit_Amt__c * repaymentPercent) + amount ;
                   }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }else if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return (debt.Card_Overdraft_Bal_Amt__c* repaymentPercent) + amount;
                }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }
                
            }
            
            if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
            decimal repaymentPercent = 0.0403;
            integer amount = 5;
            
            if(debt.Financier_List__c == 'Gem'){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                   if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                    return (debt.Credit_Limit_Amt__c * repaymentPercent) + amount ;
                   }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }else if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return (debt.Card_Overdraft_Bal_Amt__c* repaymentPercent) + amount;
                }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }
                
            }
      
  
     if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT) {
            decimal repaymentPercent = 0.0425;
            integer amount = 5;
            
            if(debt.Financier_List__c == 'CreditLine' && debt.Type_of_Credit_Card__c == 'Others'){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                 if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                    return (debt.Credit_Limit_Amt__c * repaymentPercent) + amount;
                }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }else if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return (debt.Card_Overdraft_Bal_Amt__c * repaymentPercent) + amount;
                }else{
                  return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                } 
                
            }
      }
      
         if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
            decimal repaymentPercent = 0.0425;
            integer amount = 5;
            
            if(debt.Financier_List__c == 'CreditLine'){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                 if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                    return (debt.Credit_Limit_Amt__c * repaymentPercent) + amount;
                }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                }else if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return (debt.Card_Overdraft_Bal_Amt__c * repaymentPercent) + amount;
                }else{
                  return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                } 
                
            }
      }
 
            if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT ) {
              decimal repaymentPercent = 0.05;
            
            
            if((debt.Financier_List__c == 'Kiwibank' || String.isEmpty(debt.Financier_List__c) == TRUE) && (debt.Type_of_Credit_Card__c == 'Others' || debt.Type_of_Credit_Card__c =='Kiwibank')){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                 return debt.Credit_Limit_Amt__c * repaymentPercent;
                 }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   }
                 }else  if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return debt.Card_Overdraft_Bal_Amt__c * repaymentPercent;
                   }else{
                   return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                
            }
    }
    
    if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
              decimal repaymentPercent = 0.05;
            
            
            if(debt.Financier_List__c == 'Kiwibank'){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                 return debt.Credit_Limit_Amt__c * repaymentPercent;
                 }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   }
                 }else  if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                   return debt.Card_Overdraft_Bal_Amt__c * repaymentPercent;
                   }else{
                   return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   } 
                
            }
    }
 
      if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) {
                decimal repaymentPercent = 0.038;
                
                if(debt.Financier_List__c != 'CreditLine' && debt.Financier_List__c != 'Gem' && debt.Financier_List__c != 'Kiwibank'){
                    if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                     return debt.Credit_Limit_Amt__c * repaymentPercent;
                    }else{
                    return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                   }
                   }else if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                    return debt.Card_Overdraft_Bal_Amt__c * repaymentPercent;
                    }else{
                     return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                    } 
                }
     }
         if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    return debt.Credit_Limit_Amt__c * 0.038;
                }else{
                    return debt.Card_Overdraft_Bal_Amt__c * 0.038;
                }
            
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE) {
            debt.Total_Debts__c = 0;
            if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Mortgage_Repayment_Amt__c * 52) / 12;
            }
            else if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Mortgage_Repayment_Amt__c * 26) / 12;
            }
            else if(debt.Mortgage_Repayment_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Mortgage_Repayment_Amt__c;
            }
            return debt.Total_Debts__c;

        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE) {
            debt.Total_Debts__c = 0;
            if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Car_Personal_Repay_Amt__c * 52) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Car_Personal_Repay_Amt__c * 26) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Car_Personal_Repay_Amt__c;
            }
            return debt.Total_Debts__c;
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER){
            debt.Total_Debts__c = 0;
            if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                debt.Total_Debts__c = (debt.Other_Repay_Amt__c * 52) / 12;
            }
            else if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                debt.Total_Debts__c = (debt.Other_Repay_Amt__c * 26) / 12;
            }
            else if(debt.Other_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                debt.Total_Debts__c = debt.Other_Repay_Amt__c;
            }
            return debt.Total_Debts__c;
        }
        else {
            return 0;
        }
     return 0;
        
    }           
    /*  Description: Returns debt total amount based on category
     *  Author: Russell Cadapan
     *  Date Created: OCT-01-2013
     *  Input Parameters: None
     *  Return: Decimal 
     */
    public Decimal getDebtTotalAmount(string country) {
        system.debug('Get debt total amount called');
        debt.Total_Debts__c = getDebtAmount(country);
        debt.Original_Total_Debt_Monthly__c = debt.Total_Debts__c;
        
        //Overdraft Category debt calculation
        if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OVERDRAFT){
            if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_CONSOLIDATE){
                debt.Acknowledge_Payout__c = true;
                debt.Total_Debts__c = 0;
                debt.Reduced_Credit_Limit__c = null;
            }
            else if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){ 
                debt.Acknowledge_Payout__c = false;
                if(debt.Reduced_Credit_Limit__c == null){
                    debt.Reduced_Credit_Limit__c = 0;
                }
                debt.Total_Debts__c = debt.Reduced_Credit_Limit__c * 0.038;
            }
            else {
                debt.Reduced_Credit_Limit__c =null;
            }
        }
        //Mortgage category debt calculation
        else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_MORTGAGE){
            if(debt.Acknowledge_Payout__c == true){
                debt.Total_Debts__c = 0;
            }
        }
        //Credit card and Store card debt calculation
        else if((debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) && country == 'AU'){
            if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_CONSOLIDATE){
                debt.Acknowledge_Payout__c = true;
                debt.Total_Debts__c = 0;
            }
            else if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){
                debt.Acknowledge_Payout__c = false;
                
                //BEGIN MLASALA: 07-DEC-2015 Total Debt amount is displaying incorrectly in old UI issue
                //if(debt.Credit_Limit_Amt__c != null && debt.Overdraft_APR__c!= null)
                if(debt.Credit_Limit_Amt__c != null){
                //END MLASALA: 07-DEC-2015 Total Debt amount is displaying incorrectly in old UI issue
                    if(debt.Reduced_Credit_Limit__c == null){
                        debt.Reduced_Credit_Limit__c = 0;
                    } 
                    decimal repaymentPercent = GEN_OriginationsConstants.REPAYMENT_CALCULATION_THREE_PERCENT;
                    if(debt.Type_of_Credit_Card__c == GEN_OriginationsConstants.FIN_INTSTITUTION_KIWI_BANK && country == GEN_OriginationsConstants.NZ_REGION){
                        repaymentPercent = GEN_OriginationsConstants.REPAYMENT_CALCULATION_FIVE_PERCENT;
                    }
                    debt.Total_Debts__c = debt.Reduced_Credit_Limit__c * repaymentPercent;

                    if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   

                }
            }
            else{
                debt.Reduced_Credit_Limit__c =0;
                debt.Overdraft_APR__c =0;
            }
        } else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT && country == 'NZ'){
            if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_CONSOLIDATE){
                debt.Acknowledge_Payout__c = true;
                debt.Total_Debts__c = 0;
            }else if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){
                debt.Acknowledge_Payout__c = false;
                 if(debt.Credit_Limit_Amt__c != null){
                    if(debt.Reduced_Credit_Limit__c == null){
                        debt.Reduced_Credit_Limit__c = 0;
                    } 
                    
                    decimal repaymentPercentGem = 0.0403;
                    decimal repaymentPercentCreditLine = 0.0425;
                    decimal repaymentPercentOthers = 0.038;
                    decimal repaymentPercentKiwi = 0.05;
                    integer amount = 5;
                   
                   if(debt.Financier_List__c == 'Gem' && debt.Type_of_Credit_Card__c == 'Others'){
                    debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentGem) + amount;
                     if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }else if(debt.Financier_List__c == 'CreditLine' && debt.Type_of_Credit_Card__c == 'Others'){
                   debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentCreditLine) + amount;
                    if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }else if((debt.Financier_List__c == 'Kiwibank' || String.isEmpty(debt.Financier_List__c) == TRUE) && (debt.Type_of_Credit_Card__c == 'Others' || debt.Type_of_Credit_Card__c =='Kiwibank')){
                        debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentKiwi);
                        if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                          return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                
                   }else if(debt.Financier_List__c != 'CreditLine' && debt.Financier_List__c != 'Gem' && debt.Financier_List__c != 'Kiwibank'){
                    debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentOthers);
                     if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }
                   
                 }

            }
       
        }else if((debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_STORE_CARD || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CHARGE_CARD) && country == 'NZ'){
            if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_CONSOLIDATE){
                debt.Acknowledge_Payout__c = true;
                debt.Total_Debts__c = 0;
            }else if(debt.Consolidate_Debt_Reduce_Limit__c == GEN_OriginationsConstants.DEBT_REDUCE_LIMIT){
                debt.Acknowledge_Payout__c = false;
                 if(debt.Credit_Limit_Amt__c != null){
                    if(debt.Reduced_Credit_Limit__c == null){
                        debt.Reduced_Credit_Limit__c = 0;
                    } 
                    
                    decimal repaymentPercentGem = 0.0403;
                    decimal repaymentPercentCreditLine = 0.0425;
                    decimal repaymentPercentOthers = 0.038;
                    decimal repaymentPercentKiwi = 0.05;
                    integer amount = 5;
                   
                   if(debt.Financier_List__c == 'Gem'){
                    debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentGem) + amount;
                     if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }else if(debt.Financier_List__c == 'CreditLine'){
                   debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentCreditLine) + amount;
                    if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }else if(debt.Financier_List__c == 'Kiwibank'){
                   debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentKiwi);
                    if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }else if(debt.Financier_List__c != 'CreditLine' && debt.Financier_List__c != 'Gem' && debt.Financier_List__c != 'Kiwibank'){
                    debt.Total_Debts__c = (debt.Reduced_Credit_Limit__c * repaymentPercentOthers);
                     if(country == GEN_OriginationsConstants.NZ_REGION && GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT > debt.Total_Debts__c)
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;   
                   }
                   
                 }

            }
       
        } 
        
        
        //car loan, personal loan, other computation
        else if(debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_OTHER || debt.Debt_Category__c == GEN_OriginationsConstants.DEBT_CATEGORY_HIRE_PURCHASE){
            debt.Original_Total_Debt_Monthly__c = debt.Total_Debts__c;

            if(debt.Acknowledge_Payout__c == true){
                debt.Total_Debts__c = 0;
            }
        }

        if(debt.Total_Debts__c < 0){
            debt.Total_debts__c = 0 ;
        }
        return debt.Total_Debts__c;
    } 
}