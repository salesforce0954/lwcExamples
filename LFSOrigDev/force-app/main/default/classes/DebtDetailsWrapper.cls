public with sharing class DebtDetailsWrapper {

    @AuraEnabled public List<Debt> DebtInfo {get;set;}

    @AuraEnabled public Boolean NoDebts {get;set;}


    //Used to hold the Debt Information
    public class Debt {
        @AuraEnabled public String id {get;set;}

        @AuraEnabled public String DebtType {get;set;}

        @AuraEnabled public String FinInstitution {get;set;}

        @AuraEnabled public String RepaymentAmount {get;set;}

        @AuraEnabled public String RepaymentInterval {get;set;}

        @AuraEnabled public String AmountBorrowed {get;set;}

        @AuraEnabled public String BalanceRemaining {get;set;}

        @AuraEnabled public String PayOutNConsolidate {get;set;}

        @AuraEnabled public String CardLimit {get;set;}

        @AuraEnabled public String InterestRate {get;set;}
    }


    public DebtDetailsWrapper() {

    }
}