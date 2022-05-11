/*
Author: Andrew Manetakis (Cloud Sherpas)
Created Date: Dec 18, 2013
Description: Represents a data validation error performed before a web service callout is made
*/
public with sharing class IS_ApplicationSubmitValidator extends IS_AbstractCommonValidator  implements IS_IValidator{
    public IS_ApplicationSubmitValidator() {
    }

    public List<IS_ValidationError> validate(IS_ApplicationDTO applicationDTO) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();

        //perform validations here
        //e.g. check if app.status != new
        if(applicationDTO.app.Total_Loan_Amount_New_Cash__c < 1000){
            IS_ValidationError ive = new IS_ValidationError('Validate Application', 'New Cash amount is less than $1000');

            validationErrors.add(ive);
        }
        
        //check Loan Purpose
        validationErrors.addAll(checkIfEmpty(applicationDTO.loanPurList,'Atleast 1 Loan Purpose is required'));
        
        //check Applicant 1 Asset 
        //validationErrors.addAll(checkIfEmpty(applicationDTO.assetList,'Atleast 1 Asset is required'));
        
        //check Applicant 1 Income
        validationErrors.addAll(checkIfEmpty(applicationDTO.incList,'Atleast 1 Income is required'));
        
        //check Applicant 1 Expense
        validationErrors.addAll(checkIfExpenseEmpty(applicationDTO.expenseList,'Atleast 1 Expense is required'));
        
        //check Applicant 1 Debt 
        //validationErrors.addAll(checkIfEmpty(applicationDTO.debtList,'Atleast 1 Debt is required'));
        
        //check if Joint
        if(applicationDTO.applicant2 != null){
            //check Applicant 2 Asset 
            //validationErrors.addAll(checkIfEmpty(applicationDTO.assetList2,'Atleast 1 Asset is required for Applicant 2'));
            
            //check Applicant 2 Income
            validationErrors.addAll(checkIfEmpty(applicationDTO.incList2,'Atleast 1 Income is required for Applicant 2'));
            
            //check Applicant 2 Expense
            validationErrors.addAll(checkIfEmpty(applicationDTO.expenseList2,'Atleast 1 Expense is required for Applicant 2'));
            
            //check Applicant 2 Debt 
            //validationErrors.addAll(checkIfEmpty(applicationDTO.debtList2,'Atleast 1 Debt is required for Applicant 2'));
        }
        
        
        return validationErrors; 
    }
    
    
    /**
        Author: Fel Saliba (Cloud Sherpas)
        Created Date: Jan 10, 2014
        Description: Methods that checks for related records (Asset, Income, Expense and Debt, Loan Purpose) 
    **/
    
    public List<IS_ValidationError> checkIfEmpty(List<SObject> objList, String errorMessage) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        
        if(objList != null){
            if(objList.isEmpty()){
               IS_ValidationError ive = new IS_ValidationError('Validate Applicantion', errorMessage);
               validationErrors.add(ive);           
            }
        }
        return validationErrors;
    }   
    
    public List<IS_ValidationError> checkIfExpenseEmpty(List<Expense__c> objList, String errorMessage) {
        List<IS_ValidationError> validationErrors = new List<IS_ValidationError>();
        
        if(objList != null){
            if(objList.isEmpty() || objList[0].Food_Groc_Entert__c == null){
               IS_ValidationError ive = new IS_ValidationError('Validate Applicantion', errorMessage);
               validationErrors.add(ive);           
            }
        }
        return validationErrors;
    }     
}