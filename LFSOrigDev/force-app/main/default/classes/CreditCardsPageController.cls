/**
* @author Original: Dan Crisologo
* @date Original: 04 Mar 2013 
* @description Class to handle CreditCards Page
*/

public with sharing class CreditCardsPageController{
    
    //Vision Plus variables
    public String chosenCreditCardPlansId {get; set;}
    public String chosenCreditCardId {get; set;}
    public Billing_Vision_Plus__c chosenCreditCard {get; set;}
    public Plans__c chosenCreditCardPlans {get; set;}
    public Map<Id, Billing_Vision_Plus__c> mapCreditCard;
    public Map<Id, Plans__c> mapPlans;
    public List<Billing_Vision_Plus__c> listCreditCard {get; set;}
    public List<Plans__c> listPlans {get;set;}
    public List<Plans__c> tempList {get; set;}
    
    private Id customerId;
    public Date strCreatedDate;
    
    public CreditCardsPageController(){
        
        String oppId = ApexPages.currentPage().getParameters().get('oppid');
        
        this.chosenCreditCard = new Billing_Vision_Plus__c();
        this.mapCreditCard = new Map<Id, Billing_Vision_Plus__c>();
        this.mapPlans = new Map<Id, Plans__c>();
        this.listCreditCard = new List<Billing_Vision_Plus__c>();
        this.listPlans = new List<Plans__c>();
        
        tempList = new List<Plans__c>();
        
        for(Opportunity o: [SELECT Account.Id FROM Opportunity WHERE Id =: oppId]){
            this.customerId = o.Account.Id;
        }
        loadCreditCards();
    }
    
    //Credit Cards = Vision Plus
    public void loadCreditCards(){
        //get the latest created date
        for(Billing_Vision_Plus__c bv: [SELECT CreatedDate
                                                FROM Billing_Vision_Plus__c
                                                WHERE Account__c =: this.customerId
                                                ORDER BY CreatedDate DESC LIMIT 1]){
        strCreatedDate = bv.CreatedDate.date();
        }
        for(Billing_Vision_Plus__c bvp: [SELECT Id,
                                                CreatedDate,
                                                Account_Number__c,
                                                Account_Open_Date__c,
                                                Card_limit_TOT_CR_LMT__c,
                                                Card_Balance_MEMO_BAL__c,
                                                Cash_balance__c,
                                                YTD_Interest__c,
                                                Prior_YTD_Interest__c,
                                                Delinquency_01_24__c,
                                                Interest_Free_Balances__c,
                                                Last_payment_amount__c,
                                                Last_purchase_amount__c,
                                                Times_overlimit_Number__c,
                                                Repayment_Amount_month_1__c,
                                                Repayment_Amount_month_2__c,
                                                Repayment_Amount_month_3__c,
                                                Employer_Details__c,
                                                Dependants__c,
                                                Residence_status__c
                                          FROM  Billing_Vision_Plus__c 
                                          WHERE Account__c =: this.customerId]) {
            //filter records by latest created date
            //if(bvp.CreatedDate.date() == strCreatedDate)
            {
                mapCreditCard.put(bvp.Id, bvp);
                listCreditCard.add(bvp);
            }
                                       
        }
        
        
    }
    
    public void repopulateChosenCreditCard() {
        this.chosenCreditCard = mapCreditCard.get(chosenCreditCardId);
        Plans();
    }
    
    //Show all related plans records based on chosen credit card record
    public void Plans(){
        listPlans.clear();
        for(Plans__c p: [SELECT Id,
                                Balance__c,
                                Billing_Vision_Plus__c,
                                Date_Opened__c,
                                Description__c,
                                Expiring_Date__c,
                                Interest_Rate__c,
                                Number__c
                           FROM Plans__c
                           WHERE Billing_Vision_Plus__c =: chosenCreditCardId
                           ORDER BY Balance__c DESC]){
        listPlans.add(p);
        }
    }
}