public without sharing class BrokerDetailsWrapper {
    @AuraEnabled public String brokerId         {get;set;}
    @AuraEnabled public String accessLevel         {get;set;}
    @AuraEnabled public String nominatedBrokerId         {get;set;}
    @AuraEnabled public Id accountId         {get;set;}
    @AuraEnabled public Id contactId         {get;set;}
    @AuraEnabled public String brokerType         {get;set;}

    public BrokerDetailsWrapper(){
        this.brokerId = null;
        this.accessLevel = null;
        this.nominatedBrokerId = null;
        this.accountId = null;
        this.contactId = null;
        this.brokerType = null;
    }

}