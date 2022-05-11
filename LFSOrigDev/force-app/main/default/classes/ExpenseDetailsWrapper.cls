/**
 * Class used to get the details related to Expenses from the Application form in the 
 * broker portal
 */
public with sharing class ExpenseDetailsWrapper {
    
    @AuraEnabled
    public String ResidentialStatus {get;set;}

    @AuraEnabled 
    public Decimal RentBoardPayments {get;set;}

    @AuraEnabled 
    public String PaymentFrequency {get;set;}

    @AuraEnabled 
    public String LandlordName {get;set;}

    @AuraEnabled 
    public String DoYouPayAllExpenses {get;set;}

    @AuraEnabled 
    public String LivingExpenses {get;set;}  

    @AuraEnabled 
    public String LivingExpensesFreq {get;set;} 
    
    @AuraEnabled 
    public String FoodFrequency {get;set;}

    @AuraEnabled 
    public String InsuranceFrequency {get;set;}

    @AuraEnabled 
    public String UtilitiesFrequency {get;set;}

    @AuraEnabled 
    public String TransportFrequency {get;set;}

    @AuraEnabled 
    public String EducationFrequency {get;set;}

    @AuraEnabled 
    public String PersonalFrequency {get;set;}

    @AuraEnabled 
    public Decimal FoodExpense {get;set;}

    @AuraEnabled 
    public Decimal InsuranceExpense {get;set;}

    @AuraEnabled 
    public Decimal UtilitiesExpense {get;set;}

    @AuraEnabled 
    public Decimal TransportExpense {get;set;}

    @AuraEnabled 
    public Decimal EducationExpense {get;set;}

    @AuraEnabled 
    public Decimal PersonalExpense {get;set;}


     public ExpenseDetailsWrapper(){

    }
}