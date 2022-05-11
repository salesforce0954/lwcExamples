public without sharing class QuoteActionsManager {

    @AuraEnabled
    public static void cancelQuote(String quoteCancelDetails){
        QuoteCancelWrapper qcWrap = new QuoteCancelWrapper();
        String quoteId;
        if(String.isNotBlank(quoteCancelDetails))
        {
            qcWrap = (QuoteCancelWrapper)JSON.deserialize(quoteCancelDetails, QuoteCancelWrapper.class);
            quoteId = qcWrap.QuoteId;
        }
        if(String.isNotBlank(quoteId) && String.isNotBlank(qcWrap.PrimaryReason)){
            Quote__c qObj = new Quote__c();
            qObj.Id = quoteId;
            qObj.Quote_Stage__c = 'Manually Cancelled';
            qObj.Broker_reason_for_not_proceeding__c = qcWrap.PrimaryReason;
            qObj.Broker_other_reason__c = qcWrap.PrimaryReasonOther;
            qObj.Client_finance_need__c = qcWrap.ClientFinance;
            qObj.Client_other_finance_need__c = qcWrap.ClientFinanceOther;
            update qObj;
        }
    }	
}