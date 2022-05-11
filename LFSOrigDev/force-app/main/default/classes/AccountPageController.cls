/**
* @author Original: Dan Crisologo
* @date Original: 21 Feb 2013 
* @description New account page class test
*/

public with sharing class AccountPageController {

    public List<Account> accList {get; set;}

    //Genesis variables
    public Map<Id, Billing_Genesis__c> mapPersonalLoan ;
    public List<Billing_Genesis__c> listPersonalLoan{get; set;}
    public Billing_Genesis__c chosenPersonalLoan {get; set;}
    public String chosenPersonalLoanId {get; set;}
    
    //ICBS variables
    public Map<Id, Billing_ICBS__c> mapAutoLoan;
    public List<Billing_ICBS__c> listAutoLoan{get; set;}
    public Billing_ICBS__c chosenAutoLoan {get; set;}
    public String chosenAutoLoanId {get; set;}
    
    //table visibility flag
    public Boolean showPersonalLoan{get; set;}
    public Boolean showAutoLoan{get; set;}
    
    private Id customerId;
    public date cBGDate;
    public date cBIDate;

    public AccountPageController (){
        
        String oppId = ApexPages.currentPage().getParameters().get('oppid');
          
        this.mapPersonalLoan = new Map<Id, Billing_Genesis__c>();
        this.listPersonalLoan = new List<Billing_Genesis__c>();
        this.chosenPersonalLoan = new Billing_Genesis__c();
        
        this.mapAutoLoan = new Map<Id, Billing_ICBS__c>();
        this.listAutoLoan = new List<Billing_ICBS__c>();
        this.chosenAutoLoan = new Billing_ICBS__c();
        
        this.showPersonalLoan = false;
        this.showAutoLoan = false;
        
        for(Opportunity o: [SELECT Account.Id FROM Opportunity WHERE Id =: oppId]){
            this.customerId = o.Account.Id;
        }

        loadPersonalLoans();
        loadAutoLoans();

    }
        
    public void loadPersonalLoans(){
        //get the latest created date
        for(Billing_Genesis__c b:[SELECT CreatedDate
                                         FROM Billing_Genesis__c
                                         WHERE Account__c =: this.customerId
                                         ORDER BY CreatedDate DESC LIMIT 1]){
            cBGDate = b.CreatedDate.date();
        }
        for(Billing_Genesis__c bi: [SELECT  Id,
                                            CreatedDate,
                                            Account_Number__c,
                                            Contract_Date__c,
                                            Maturity_Date__c,
                                            Opening_Balance__c,
                                            Current_Balance__c,
                                            Interest_Rate__c,
                                            Monthly_Installment__c,
                                            Delinquency_1_14__c,
                                            Delinquency_15__c,
                                            Delinquency_30__c,
                                            Goods_Financed_Goods__c,
                                            Next_Amount_Due__c,
                                            Last_Amount_Paid__c,
                                            Credit_Score__c,
                                            Balloon_Payment_Ball_Resid_l__c
                                       FROM Billing_Genesis__c
                                      WHERE Account__c =: this.customerId
                                   ORDER BY CreatedDate DESC]) {
             //filter records by latest created date
            // if(bi.CreatedDate.date() == cBGDate)
             {
                 mapPersonalLoan.put(bi.Id, bi);
                 listPersonalLoan.add(bi);
             }
         }

    }
    
    public void loadAutoLoans(){
        //get the latest created date
        for(Billing_ICBS__c bicb: [SELECT CreatedDate
                                          FROM Billing_ICBS__c
                                          WHERE Account__c =: this.customerId
                                          ORDER BY CreatedDate DESC LIMIT 1]){
            cBIDate = bicb.CreatedDate.date();
        }
        for(Billing_ICBS__c bicbs: [SELECT  Id,
                                            CreatedDate,
                                            Account_Number__c,
                                            Contract_Date__c,
                                            maturity_date__c,
                                            Note_Amount__c,
                                            Principle_balance__c,
                                            Interest_Rate__c,
                                            Payment_amount__c,
                                            Times_past_due_CY1__c,
                                            Times_past_due_CY2__c,
                                            Times_past_due_CY3__c,
                                            Next_Payment_Amount__c,
                                            Credit_Score__c,
                                            Due_Date__c,
                                            Date_last_Transaction__c
                                       FROM Billing_ICBS__c
                                      WHERE Account__c =: this.customerId
                                   ORDER BY CreatedDate DESC]) {
             //filter records by latest created date
             //if(bicbs.CreatedDate.date() == cBIDate)
             {
                 mapAutoLoan.put(bicbs.Id, bicbs);
                 listAutoLoan.add(bicbs);
             }
         }

    }
    
    public void repopulateChosenPersonalLoan() {
        this.chosenPersonalLoan = mapPersonalLoan.get(chosenPersonalLoanId);
        showPersonalLoan = true;
    }
    
    public void repopulateChosenAutoLoan() {
        this.chosenAutoLoan = mapAutoLoan.get(chosenAutoLoanId);
        showAutoLoan = true;
    }

}