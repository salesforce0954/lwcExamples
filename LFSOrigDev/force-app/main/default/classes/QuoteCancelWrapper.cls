public with sharing class QuoteCancelWrapper {
    
    @AuraEnabled public String PrimaryReason {get;set;}

    @AuraEnabled public String PrimaryReasonOther {get;set;}

    @AuraEnabled public String ClientFinanceOther {get;set;}

    @AuraEnabled public String ClientFinance {get;set;}

    @AuraEnabled public String QuoteId {get;set;}

}