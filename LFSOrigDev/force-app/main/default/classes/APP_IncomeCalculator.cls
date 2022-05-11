public with sharing class APP_IncomeCalculator {
    public List<Income_Capacity__c> icList{get;set;}

    public APP_IncomeCalculator() {
        icList = new List<Income_Capacity__c>{new Income_Capacity__c()};
    }
}