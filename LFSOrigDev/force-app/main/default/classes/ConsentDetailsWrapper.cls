public with sharing class ConsentDetailsWrapper {

    @AuraEnabled
    public String LoanTerm {get;set;}

    @AuraEnabled 
    public String Applicants {get;set;}

    @AuraEnabled 
    public Boolean PrivacyConsent {get;set;}

    @AuraEnabled 
    public Boolean ProductDisclosure {get;set;}

    @AuraEnabled 
    public Boolean ECommunication {get;set;}

    @AuraEnabled 
    public Boolean EIncome {get;set;}

    @AuraEnabled 
    public Boolean EIdentification {get;set;}

    @AuraEnabled 
    public Boolean MaxLimit {get;set;}

     @AuraEnabled 
     public List<Loan> LoanInfo {get;set;}

     @AuraEnabled 
     public String LoanAmountQuote {get;set;}

     @AuraEnabled 
     public String LoanPurposeQuote {get;set;}

     @AuraEnabled 
     public String OtherLoanPurposeQuote {get;set;}

     @AuraEnabled 
     public String ProductType {get;set;}     

    public ConsentDetailsWrapper() {

    }

    //Used to hold the Loan Information
    public class Loan {
        @AuraEnabled 
        public String id {get;set;}

        @AuraEnabled 
        public String loanAmount {get;set;}

        @AuraEnabled 
        public String loanPurpose {get;set;}

        @AuraEnabled 
        public String otherLoanPurpose {get;set;}
    }
}