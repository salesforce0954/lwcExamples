public with sharing class EmploymentDetailsWrapper {

    
    @AuraEnabled public String EmploymentStatus {get;set;}

    @AuraEnabled public String PreviousEmploymentStatus {get;set;}

    @AuraEnabled public String PrevEmploymentYears {get;set;}

    @AuraEnabled public String PrevEmploymentMonths {get;set;}

    @AuraEnabled public List<Income> IncomeInfo {get;set;}


    public EmploymentDetailsWrapper() {

    }

    //Used to hold the Income Information
    public class Income {
        @AuraEnabled public String id {get;set;}

        @AuraEnabled public String IncomeFrom {get;set;}

        @AuraEnabled public String IncomeAmount {get;set;}

        @AuraEnabled public String IncomeFrequency {get;set;}

        @AuraEnabled public String Occupation {get;set;}

        @AuraEnabled public String EmployerName {get;set;}

        @AuraEnabled public String EmployerContact {get;set;}

        @AuraEnabled public String EmploymentYears {get;set;}

        @AuraEnabled public String EmploymentMonths {get;set;}

    }

    
}