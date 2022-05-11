public with sharing class ApplicationDetailsWrapper {
    
    public class AppListView{
        @AuraEnabled public String fullName{get; set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String applicationId{get;set;}
        @AuraEnabled public String applicantId{get;set;}
        @AuraEnabled public String brokerId{get;set;}
        @AuraEnabled public String applicationName{get;set;}
        @AuraEnabled public Decimal loanAmount{get;set;}
        @AuraEnabled public String loanTerm{get;set;}
        @AuraEnabled public String loanNumber{get;set;}
        @AuraEnabled public String loanPurpose{get;set;}
        @AuraEnabled public Boolean isOnlyDebtConsolidation{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String statusForDisplay{get;set;}
        @AuraEnabled public String statusDescription{get;set;}
        @AuraEnabled public Decimal offeredInterestRate{get;set;}
        @AuraEnabled public String applicationType {get;set;}
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String mobile{get;set;}
        @AuraEnabled public String brokerName{get;set;}
        @AuraEnabled public Boolean hasAnotherDebit{get;set;}
        @AuraEnabled public Boolean hasAnotherCredit{get;set;}
        @AuraEnabled public Boolean ddExist{get;set;}
        @AuraEnabled public Boolean dcExist{get;set;}        
        @AuraEnabled public Applicant__c secondaryApplicant{get;set;}
    }
}