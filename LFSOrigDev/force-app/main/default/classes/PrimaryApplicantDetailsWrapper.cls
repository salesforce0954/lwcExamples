public with sharing class PrimaryApplicantDetailsWrapper {
    
    // Consent & Loan Details
    @AuraEnabled public ConsentDetailsWrapper loanDetails {get;set;}

    //Personal Details
     @AuraEnabled public PersonalInformationWrapper personalDetails {get;set;}

    //Joint Personal Details
     @AuraEnabled public PersonalInformationWrapper personalDetailsJoint {get;set;}

     //Employment Details
    @AuraEnabled public  EmploymentDetailsWrapper employmentDetails {get;set;}

    //Joint Employment Details
    @AuraEnabled public  EmploymentDetailsWrapper employmentDetailsJoint {get;set;}

    // Expense Details
    @AuraEnabled public ExpenseDetailsWrapper expenseDetails {get;set;}

    // Joint Expense Details
    @AuraEnabled public ExpenseDetailsWrapper expenseDetailsJoint {get;set;}

    // Asset Details
    @AuraEnabled public AssetDetailsWrapper assetDetails {get;set;}

    // Debt Details
    @AuraEnabled public DebtDetailsWrapper debtDetails {get;set;}



    
    public PrimaryApplicantDetailsWrapper(){

    }
}