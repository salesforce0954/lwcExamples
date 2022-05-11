/*
Author: Andrew Manetakis (Cloud Sherpas)
Created Date: Dec 18, 2013
Description: Wrapper for all the data required for web service callouts
Update: 2015-08-12 Tony Xu Added Risk Referral Workflow PMIHM-1307
*/
public class IS_ApplicationDTO {

    public Application__c app {get; set;} 
    
    //Customer Search data
    public List<Applicant_CLV__c> applicantCLVs {get; set;}
    public Applicant_Search__c appSearch {get; set;}
    public List<Related_Document__c> acceptanceDocuments {get;set;}

    //Application-Related data
    public List<Loan_Purpose__c> loanPurList {get; set;} 
    public List<ONR__C> onrList {get; set;} 
    public List<Collateral__c> collateralList {get; set;} 
    public List<Product_Item__c> insuranceList {get; set;} 
    public List<Personal_Reference_Check__c> personalReferenceList {get; set;} 
    
    public List<Disbursement__c> disbursementList {get; set;}
    public List<Debit__c> applicationDebits {get; set;}
    public List<Fees_Charges__c> feesAndCharges {get; set;}
    public List<Disbursement_Plan__c> disbursementPlanList {get;set;}
    public List<Compliance_Check__c> complianceCheckList{get;set;}
    public List<Debit__c> applicationAllDebits {get;set;}
    
    //Application-lookup data
    public GEProduct__c product {get; set;} 
    public Contact brokerDetails {get; set;}
    public Branch__c branch {get; set;}
    public User applicationOwner {get; set;}
    
    //Applicant 1
    public Applicant__c applicant {get; set;} 
    public List<Income__c> incList {get; set;} 
    public List<Asset__c> assetList {get; set;}  
    public List<Liability__c> debtList {get; set;} 
    public List<Expense__c> expenseList {get; set;} 
    public List<AML__c> amlList {get; set;}
    public List<Applicant_CLV__c> clvList {get; set;}
    
    //Applicant 2
    public Applicant__c applicant2 {get; set;} 
    public List<Income__c> incList2 {get; set;} 
    public List<Asset__c> assetList2 {get; set;} 
    public List<Liability__c> debtList2 {get; set;} 
    public List<Expense__c> expenseList2 {get; set;} 
    public List<AML__c> amlList2 {get; set;}
    public List<Applicant_CLV__c> clvList2 {get; set;}
    
    
    //Tony Xu Risk Referral Workflow PMIHM-1307  Start
    public List<Workflow__c> workflowList {get;set;}
    //====END=====//
    
    // Added Quote Object for Soft Quote
    public Quote__c quote  {get; set;}
    
    public IS_ApplicationDTO() {
        
    }
}