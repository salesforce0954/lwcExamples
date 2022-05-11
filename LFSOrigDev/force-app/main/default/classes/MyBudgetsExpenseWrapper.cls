/* @Description: Wrapper class for Expense
 * @Author: Mike Lasala
 * @Date Created: JAN-29-2013
 * @History:
   =====================================================================
       01-29-14: Created - Mike
       02-14-14: Updated: Added validation for application residential status validation - Adrian
       04-10-15: Comment-out the validation that reference to PRS - DYU
   =====================================================================
 */
 
/*  Description: Wrapper class for the expense object
 *  Author: Dan Crisologo
 *  Date Created: SEPT-26-2013
 */
public class MyBudgetsExpenseWrapper{
    public Expense__c expense           {get;set;}
    public Applicant__c applicant       {get;set;}
    public String yesNoOption           {get;set;}
    public Decimal totalExpense         {get;set;}    
    //public Decimal totalOtherExpenses   {get;set;}      
    public Boolean amountValid          {get;set;}
    public Boolean intervalValid        {get;set;}
    public Boolean rentAmountValid      {get;set;}
    public Boolean rentIntervalValid    {get;set;}
    public Boolean yesNoValid           {get;set;}
    public Boolean errorLandlordName    {get;set;}
    public Boolean errorLandlordPhone   {get;set;}
    public String errorLandlordNameMsg  {get;set;}
    public Boolean errorDoYouPayAllExpenses  {get;set;}
    public String errorDoYouPayAllExpensesMsg  {get;set;}
    public String errorLandlordPhoneMsg {get;set;}
    public Boolean errorResidentialStat {get;set;}
    public Boolean isCustomer {get;set;}

    /*  Description: Wrapper constructor. creates new expense, refreshes validations
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public MyBudgetsExpenseWrapper(Applicant__c applicant){
        System.debug('!@#001');
        this.expense = new Expense__c(Applicant__c = applicant.Id);
        this.applicant = applicant;
        this.amountValid = true;
        this.intervalValid = true;
        this.rentAmountValid = true;
        this.rentIntervalValid = true;
        this.yesNoValid = true;
        this.errorLandlordName = false;
        this.errorLandlordPhone = false;
        this.errorLandlordNameMsg = '';
        this.errorDoYouPayAllExpenses = false;
        this.errorDoYouPayAllExpensesMsg = '';
        this.errorLandlordPhoneMsg = '';
        this.errorResidentialStat = false;
        this.totalExpense = 0;
        this.yesNoOption = 'Please Select';
        this.isCustomer = false;
    }

    public MyBudgetsExpenseWrapper(Expense__c existingExpense, Applicant__c applicant) {
        System.debug('!@#002');
        this.expense = existingExpense;
        this.applicant = applicant;
        this.amountValid = true;
        this.intervalValid = true;
        this.rentAmountValid = true;
        this.rentIntervalValid = true;
        this.yesNoValid = true;
        this.errorLandlordName = false;
        this.errorLandlordPhone = false;
        this.errorLandlordNameMsg = '';
        this.errorDoYouPayAllExpenses = false;
        this.errorDoYouPayAllExpensesMsg = '';
        this.errorLandlordPhoneMsg = '';
        this.errorResidentialStat = false;
        this.yesNoOption = String.valueOf(existingExpense.I_Pay_All_Exp__c);
        this.isCustomer = false;
        System.debug('!@#002yesNoOption: '+yesNoOption);
    }
    
    /*  Description: Validates all expense fields in the wrapper
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateExpense(Boolean isResidential, string region) {        
        Boolean validationResult = true;
    
        this.amountValid = true;
        this.intervalValid = true;
        this.rentAmountValid = true;
        this.rentIntervalValid = true;
        this.yesNoValid = true;
        this.errorLandlordName = false;
        this.errorLandlordPhone = false;
        this.errorLandlordNameMsg = '';
        this.errorLandlordPhoneMsg = '';
        this.errorDoYouPayAllExpenses = false;
        this.errorDoYouPayAllExpensesMsg = '';
        this.errorResidentialStat = false;

        if((expense.Living_Exp__c == null  || expense.Living_Exp__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }
       
       if(expense.Living_Exp__c > 0){ 
           if((expense.Living_Exp_Int__c == null || expense.Living_Exp_Int__c == 'None') && region != GEN_OriginationsConstants.NZ_REGION) {
                this.intervalValid = false;
                validationresult = false;
            } 
        }
        
        if((expense.Food_Groc_Entert__c == null  || expense.Food_Groc_Entert__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }
     if(expense.Food_Groc_Entert__c > 0){
        if((expense.Food_Groc_Interval__c == null || expense.Food_Groc_Interval__c == 'None') && region != GEN_OriginationsConstants.NZ_REGION) {
            this.intervalValid = false;
            validationresult = false;
        } 
       } 
       
       
        if((expense.Insurance_Expense__c == null  || expense.Insurance_Expense__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }
    
      if(expense.Insurance_Expense__c > 0){
        if((expense.Insurance_Expense_Interval__c == null || expense.Insurance_Expense_Interval__c == 'None') && region != GEN_OriginationsConstants.NZ_REGION) {
            this.intervalValid = false;
            validationresult = false;
        } 
       }

        if((expense.Utilities_Expense__c == null  || expense.Utilities_Expense__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }
        
        
     if(expense.Utilities_Expense__c > 0){
       if((expense.Utilities_Expense_Interval__c == null || expense.Utilities_Expense_Interval__c == 'None')  && region != GEN_OriginationsConstants.NZ_REGION) {
            this.intervalValid = false;
            validationresult = false;
        }
       } 

        if((expense.Transport_Expense__c == null  || expense.Transport_Expense__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }
      
       if(expense.Transport_Expense__c > 0){
        if((expense.Transport_Expense_Interval__c == null || expense.Transport_Expense_Interval__c == 'None')  && region != GEN_OriginationsConstants.NZ_REGION) {
            this.intervalValid = false;
            validationresult = false;
        } 
       }

        if((expense.Education_and_child_Expense__c == null  || expense.Education_and_child_Expense__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }

       if(expense.Education_and_child_Expense__c > 0){
            if((expense.Education_and_child_Expense_Interval__c == null || expense.Education_and_child_Expense_Interval__c == 'None')  && region != GEN_OriginationsConstants.NZ_REGION) {
                this.intervalValid = false;
                validationresult = false;
            } 
        }

        if((expense.Personal_Other_Expense__c == null  || expense.Personal_Other_Expense__c < 0) && region != GEN_OriginationsConstants.NZ_REGION ) {
            this.amountValid = false;
            validationresult = false;
        }

      if(expense.Personal_Other_Expense__c > 0){
       if((expense.Personal_Other_Expense_Interval__c == null || expense.Personal_Other_Expense_Interval__c == 'None')  && region != GEN_OriginationsConstants.NZ_REGION) {
            this.intervalValid = false;
            validationresult = false;
        } 
      }
        //updated by DYU 06-04-2015 udpated the validation which will only validate for single application
        /**Commented by TXU 2015-08-10 This is result in Failing of Expense page in Customer UI for NZ
        if(yesNoOption == 'Please Select' && isCustomer && region != GEN_OriginationsConstants.NZ_REGION && isJoint == false){
            errorDoYouPayAllExpenses = true;
            errorDoYouPayAllExpensesMsg = 'Error: Please choose a value.';
            validationresult = false;
        }**/
        if(isResidential) {

            if(expense.Rent_Board_Pay_Amt__c == null || expense.Rent_Board_Pay_Amt__c < 0) {
                this.rentAmountValid = false;
                validationresult = false;
            }

            if(expense.Rent_Board_Pay_Int__c == null || expense.Rent_Board_Pay_Int__c == 'None') {
                this.rentIntervalValid = false;
                validationresult = false;
            }
        }else if(region == GEN_OriginationsConstants.AU_REGION){
            clearRentFields();
        }
        

        if(applicant.Res_Status__c == GEN_OriginationsConstants.RESIDENTIAL_STATUS_RENTING){
            if(expense.Agent_Landlord_Name__c == null || expense.Agent_Landlord_Name__c == ''){
                if (region != GEN_OriginationsConstants.NZ_REGION) {
                   
                    this.errorLandlordName = true;
                    this.errorLandlordNameMsg = 'Error: Please enter Agent / Landlord name.';
                    validationresult = false;
                }
            }
            //Updated by DYU 04-10-15 - comment-out the PRS validation
            /*else if(expense.Agent_Landlord_Name__c != null || expense.Agent_Landlord_Name__c != ''){
                this.errorLandlordName = true;
                this.errorLandlordNameMsg = 'Error: Agent / Landlord Name must be less than 30 characters.';
                validationresult = false;
            }*/
        } else {
            expense.Agent_Landlord_Name__c = null;
        }

        if(applicant.Res_Status__c == 'Please Select') {
            this.errorResidentialStat = true;
            validationresult = false;
        }  

        return validationresult;
    }
    
    /*  Description: Computes total assets based on asset interval
     *  Author: Dan Crisologo
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public void computeTotalExpense(Boolean isResidential, string region) {
        Decimal totalExpense = 0;
        if(region != GEN_OriginationsConstants.NZ_REGION){
          
           if(expense.Living_Exp__c != null){
            if(this.expense.Living_Exp_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense = (expense.Living_Exp__c * 52) / 12;
            } else if (expense.Living_Exp_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense = (expense.Living_Exp__c * 26 ) / 12;
            } else if (expense.Living_Exp_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense = expense.Living_Exp__c;
            } else if (expense.Living_Exp_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense = expense.Living_Exp__c / 3;
            } else if (expense.Living_Exp_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense = expense.Living_Exp__c / 12;
            }    
           } 
            
            //Food Groc and Entertainment
            if(expense.Food_Groc_Entert__c != null){
                if(this.expense.Food_Groc_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense += (expense.Food_Groc_Entert__c* 52) / 12;
                }else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense += (expense.Food_Groc_Entert__c * 26 ) / 12;
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense += expense.Food_Groc_Entert__c;
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {              
                   totalExpense += expense.Food_Groc_Entert__c / 3;              
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {              
                   totalExpense += expense.Food_Groc_Entert__c / 12;              
                }    
              }

            // Insurance Expenses
             if(expense.Insurance_Expense__c != null){
                if(this.expense.Insurance_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense += (expense.Insurance_Expense__c* 52) / 12;
                }else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense += (expense.Insurance_Expense__c * 26 ) / 12;
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense += expense.Insurance_Expense__c;
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {           
                   totalExpense += expense.Insurance_Expense__c / 3;             
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {           
                   totalExpense += expense.Insurance_Expense__c / 12;             
                }  
            } 
        
            // Utilities Expenses
         if(expense.Utilities_Expense__c != null){
            if(this.expense.Utilities_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Utilities_Expense__c* 52) / 12;
            }else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Utilities_Expense__c * 26 ) / 12;
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Utilities_Expense__c;
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Utilities_Expense__c / 3;
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Utilities_Expense__c / 12;
            }    
         }
            // Transport Expenses
          if(expense.Transport_Expense__c != null){
            if(this.expense.Transport_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Transport_Expense__c* 52) / 12;
            }else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Transport_Expense__c * 26 ) / 12;
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Transport_Expense__c;
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Transport_Expense__c / 3;
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Transport_Expense__c / 12;
            }   
        }    
            // Education and Child Expenses
         if(expense.Education_and_child_Expense__c  != null){ 
            if(this.expense.Education_and_child_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Education_and_child_Expense__c* 52) / 12;
            }else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Education_and_child_Expense__c * 26 ) / 12;
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Education_and_child_Expense__c;
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Education_and_child_Expense__c / 3;
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Education_and_child_Expense__c / 12;
            }   
         }
            // Personal / Other Expenses
          if(expense.Personal_Other_Expense__c != null){ 
            if(this.expense.Personal_Other_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Personal_Other_Expense__c* 52) / 12;
            }else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Personal_Other_Expense__c * 26 ) / 12;
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Personal_Other_Expense__c;
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Personal_Other_Expense__c / 3;
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Personal_Other_Expense__c / 12;
            }
           }  
        } else
        
        if(region != GEN_OriginationsConstants.AU_REGION){
          
           if(expense.Mortgage_Rent_Board__c != null){
            if(this.expense.Mortgage_Rent_Board_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense = (expense.Mortgage_Rent_Board__c* 52) / 12;
            } else if (expense.Mortgage_Rent_Board_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense = (expense.Mortgage_Rent_Board__c * 26 ) / 12;
            } else if (expense.Mortgage_Rent_Board_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense = expense.Mortgage_Rent_Board__c;
               system.debug('Mortgage Monthly$$$ '+totalExpense);
            } else if (expense.Mortgage_Rent_Board_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense = expense.Mortgage_Rent_Board__c / 3;
            } else if (expense.Mortgage_Rent_Board_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense = expense.Mortgage_Rent_Board__c / 12;
            }  
           } 
            
            //Food Groc and Entertainment
            if(expense.Secondary_Mortgage_Rent__c != null){
                if(this.expense.Secondary_Mortgage_Rent_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense += (expense.Secondary_Mortgage_Rent__c * 52) / 12;
                }else if (expense.Secondary_Mortgage_Rent_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense += (expense.Secondary_Mortgage_Rent__c  * 26 ) / 12;
                } else if (expense.Secondary_Mortgage_Rent_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense += expense.Secondary_Mortgage_Rent__c;
                  system.debug('Secondary Monthly$$$ '+totalExpense);
                } else if (expense.Secondary_Mortgage_Rent_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {              
                   totalExpense += expense.Secondary_Mortgage_Rent__c / 3;              
                } else if (expense.Secondary_Mortgage_Rent_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {              
                   totalExpense += expense.Secondary_Mortgage_Rent__c / 12;              
                }  
              }
 
            // Utilities Expenses
         if(expense.Property_rates__c != null){
            if(this.expense.Property_rates_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Property_rates__c * 52) / 12;
            }else if (expense.Property_rates_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Property_rates__c * 26 ) / 12;
            } else if (expense.Property_rates_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Property_rates__c;
              system.debug('Property Monthly$$$ '+totalExpense);
            } else if (expense.Property_rates_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Property_rates__c / 3;
            } else if (expense.Property_rates_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Property_rates__c / 12;
            }   
         }
            // Transport Expenses
          if(expense.Other_Property_Expenses__c != null){
            if(this.expense.Other_Property_Expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Other_Property_Expenses__c * 52) / 12;
            }else if (expense.Other_Property_Expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Other_Property_Expenses__c  * 26 ) / 12;
            } else if (expense.Other_Property_Expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Other_Property_Expenses__c;
               system.debug('Other Monthly$$$ '+totalExpense);
            } else if (expense.Other_Property_Expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Other_Property_Expenses__c / 3;
            } else if (expense.Other_Property_Expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Other_Property_Expenses__c / 12;
            }   
        }    
            // Education and Child Expenses
         if(expense.Any_Additional_expenses__c  != null){ 
            if(this.expense.Any_Additional_expenses_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Any_Additional_expenses__c * 52) / 12;
            }else if (expense.Any_Additional_expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Any_Additional_expenses__c * 26 ) / 12;
            } else if (expense.Any_Additional_expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Any_Additional_expenses__c;
                 system.debug('Additional Monthly$$$ '+totalExpense);
            } else if (expense.Any_Additional_expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Any_Additional_expenses__c / 3;
            } else if (expense.Any_Additional_expenses_Interval__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Any_Additional_expenses__c / 12;
            }   
         }
          
             //AU and NZ common fields            
            
             if(expense.Food_Groc_Entert__c != null){
                if(this.expense.Food_Groc_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense += (expense.Food_Groc_Entert__c* 52) / 12;
                }else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense += (expense.Food_Groc_Entert__c * 26 ) / 12;
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense += expense.Food_Groc_Entert__c;
                   system.debug('Food_Groc Monthly$$$ '+totalExpense);
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {              
                   totalExpense += expense.Food_Groc_Entert__c / 3;              
                } else if (expense.Food_Groc_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {              
                   totalExpense += expense.Food_Groc_Entert__c / 12;              
                }  
              }

            // Insurance Expenses
             if(expense.Insurance_Expense__c != null){
                if(this.expense.Insurance_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense += (expense.Insurance_Expense__c* 52) / 12;
                }else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense += (expense.Insurance_Expense__c * 26 ) / 12;
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense += expense.Insurance_Expense__c;
                    system.debug('Insurance Monthly$$$ '+totalExpense);
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {           
                   totalExpense += expense.Insurance_Expense__c / 3;             
                } else if (expense.Insurance_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {           
                   totalExpense += expense.Insurance_Expense__c / 12;             
                }  
            } 
        
            // Utilities Expenses
         if(expense.Utilities_Expense__c != null){
            if(this.expense.Utilities_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Utilities_Expense__c* 52) / 12;
            }else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Utilities_Expense__c * 26 ) / 12;
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Utilities_Expense__c;
                system.debug('Utilities Expenses Monthly$$$ '+totalExpense);
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Utilities_Expense__c / 3;
            } else if (expense.Utilities_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Utilities_Expense__c / 12;
            }   
         }
            // Transport Expenses
          if(expense.Transport_Expense__c != null){
            if(this.expense.Transport_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Transport_Expense__c* 52) / 12;
            }else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Transport_Expense__c * 26 ) / 12;
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Transport_Expense__c;
                 system.debug('Transport Expenses Monthly$$$ '+totalExpense);
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Transport_Expense__c / 3;
            } else if (expense.Transport_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Transport_Expense__c / 12;
            }   
        }    
            // Education and Child Expenses
         if(expense.Education_and_child_Expense__c  != null){ 
            if(this.expense.Education_and_child_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Education_and_child_Expense__c* 52) / 12;
            }else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Education_and_child_Expense__c * 26 ) / 12;
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Education_and_child_Expense__c;
                system.debug('Education and Child Expenses Expense Monthly$$$ '+totalExpense);
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Education_and_child_Expense__c / 3;
            } else if (expense.Education_and_child_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Education_and_child_Expense__c / 12;
            }  
         }
            // Personal / Other Expenses
          if(expense.Personal_Other_Expense__c != null){ 
            if(this.expense.Personal_Other_Expense_Interval__c ==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
               totalExpense += (expense.Personal_Other_Expense__c* 52) / 12;
            }else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
               totalExpense += (expense.Personal_Other_Expense__c * 26 ) / 12;
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
               totalExpense += expense.Personal_Other_Expense__c;
               system.debug('Personal Other Expenses Expense Monthly$$$ '+totalExpense);
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
               totalExpense += expense.Personal_Other_Expense__c / 3;
            } else if (expense.Personal_Other_Expense_Interval__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
               totalExpense += expense.Personal_Other_Expense__c / 12;
            } 
           }  
             
        } 
            
            
            
       if(region != GEN_OriginationsConstants.NZ_REGION){
        if(isResidential) {
            if(this.expense.Rent_Board_Pay_Amt__c != null){
                if(this.expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 52) / 12;
                  //expense.Rent_Board_Pay_Amt__c = (expense.Rent_Board_Pay_Amt__c * 52) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 26) / 12;
                  // expense.Rent_Board_Pay_Amt__c = (expense.Rent_Board_Pay_Amt__c * 26) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c);
                  // expense.Rent_Board_Pay_Amt__c = (expense.Rent_Board_Pay_Amt__c);
                   system.debug('Total Rent Monthly$$$ '+totalExpense);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 3);
                   //expense.Rent_Board_Pay_Amt__c = (expense.Rent_Board_Pay_Amt__c / 3);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 12);
                   //expense.Rent_Board_Pay_Amt__c = (expense.Rent_Board_Pay_Amt__c / 12);
                }
            }
        }
      } else if(region != GEN_OriginationsConstants.AU_REGION){
        if(isResidential) {
            if(this.expense.Rent_Board_Pay_Amt__c != null){
                if(this.expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 52) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 26) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c);
                   system.debug('Total Rent Monthly$$$ '+totalExpense);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 3);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 12);
                }
            }
        } else{
          if(this.expense.Rent_Board_Pay_Amt__c != null){
                if(this.expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 52) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c * 26) / 12;
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c);
                   system.debug('Total Rent Monthly$$$ '+totalExpense);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_QUARTER) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 3);
                } else if (expense.Rent_Board_Pay_Int__c==GEN_OriginationsConstants.PAYMENT_INTERVAL_YEAR) {
                   totalExpense = totalExpense + (expense.Rent_Board_Pay_Amt__c / 12);
                }
            }
        }
      } 
      
        system.debug('Total Expense $$$ '+totalExpense);
        this.expense.Total_Exp__c = totalExpense.setScale(2);
        
    }
    
    /*  Description: Clear rent fields values
     *  Author: Mike Lasala
     *  Date Created: APR-11-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    
     public void clearRentFields(){
        expense.Rent_Board_Pay_Amt__c = null;
        expense.Agent_Landlord_Name__c = null;
        expense.Agent_Landlord_Phone_Number__c = null;
        expense.Rent_Board_Pay_Int__c = ''; 
    }
}