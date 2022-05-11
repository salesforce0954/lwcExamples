/* @Description: Wrapper class for Loan Purpose
 * @Author: Mike Lasala
 * @Date Created: JAN-31-2013
 * @History:
   =====================================================================
       01-31-14: Created - Mike
       03-27-14: Added Disbursement
   =====================================================================
 */
 
//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================
public class LoanWrapper{
    public Loan_Purpose__c loan         {get;set;}
    public Boolean loanPurNotValid      {get;set;}
    public Boolean loanPurposeNotValid  {get;set;}
    public Boolean amtNotValid          {get;set;}
    public Integer rowCount             {get;set;}
    public Disbursement__c disbursement {get; set;}
    
    public LoanWrapper(){
        this.loan = new Loan_Purpose__c();
        this.loanPurNotValid = false;
        this.loanPurposeNotValid = false;
        this.amtNotValid = false;
        this.disbursement = new Disbursement__c();
    }
    
    /*  Description: Validates all loan purpose fields in the wrapper
     *  Author: Mike Lasala
     *  Date Created: JAN-23-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    public Boolean validateLoan() {
        Boolean validationResult = true;
        
        this.loanPurNotValid = false;
        this.loanPurposeNotValid = false;
        this.amtNotValid = false;
        
        if(loan.Value__c == null || loan.Value__c == ''){
            this.loanPurposeNotValid = true;
            validationResult = false;
        }
        if(loan.Value__c == 'Other' && (loan.Other_Loan_Purpose__c == null || loan.Other_Loan_Purpose__c == '')){
            this.loanPurNotValid = true;
            validationResult = false;
        }           
        
        if(loan.Loan_Amount__c == null || loan.Loan_Amount__c == 0 || loan.Loan_Amount__c < 0){
            this.amtNotValid = true;
            validationResult = false;
        }
        
        if(loan.Value__c != 'Other'){
            this.loan.Other_Loan_Purpose__c = null;
        }
        
        return validationResult;
    }
    
    /*  Description: Sets application and onr id
     *  Author: Mike Lasala
     *  Date Created: JAN-23-2014
     *  Input Parameters: None
     *  Return: N/A
     */
    public void setLoanApplicationAndONR(Id applicationId, Id onrId){
        this.loan.Application__c = applicationId;
        this.loan.ONR__c = onrId;
    }
}