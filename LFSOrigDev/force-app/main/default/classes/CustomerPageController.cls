/*
Author: Michael Lasala Cloud Sherpas
Created Date: 2/15/2013
Description: Customer Page on GEPlayPage2
*/

public with sharing class CustomerPageController{
    
    public List<Task> taskList {get; set;}
    public String custId {get; set;}
    public String phoneNo {get; set;}
    public String DoB {get; set;}
    public String mobileNo {get; set;}
    public String emailAddress {get; set;}
    public String personAddress {get; set;}
    public String spouseFName {get; set;}
    public String accomCode {get; set;}
    public String spouseLName {get; set;} 
    //Added by Tony Xu for displaying the following three fields
    public String offerStartDate {get;set;}
    public String originalLoanOwner {get;set;}
    public String offerAmount {get;set;}
    public String offerExpiryDate {get; set;}
    public String externalPartyPhotoURL {get;set;} //Added by Afreen for displaying 
    public Attachment picStarterConvAttach {get; set;}   //Added by Afreen for displaying 
    public Opportunity opp{get; set;} // Afreen
    public Id accId;
    
    public CustomerPageController(){
        opp = new Opportunity();
        //Variable Declaration
        String oppURL = ApexPages.currentPage().getParameters().get('oppid');
        taskList = [SELECT Id, CreatedDate, OwnerId, Call_Outcome__c, Description FROM Task WHERE WhatId =: oppURL ORDER BY CreatedDate DESC LIMIT 15];
        
        List<Opportunity> oppVar = [SELECT Account.Name, Account.CLV_Customer_ID__c,
                                    Account.PersonHomePhone, Account.Date_of_Birth__pc, 
                                    Account.PersonMobilePhone, Account.PersonEmail,
                                    Account.PersonMailingStreet, Account.PersonMailingCity, 
                                    Account.PersonMailingState, Account.PersonMailingCountry, Account.PersonMailingPostalCode,
                                    Account.Spouse_First_Name__pc, Account.Accommodation_Code__pc, Account.Spouse_Last_Name__pc,
                                    //Added by Tony Xu for displaying the following three fields
                                    Offer_Start_Date__c, Original_Loan_Owner__c, Promo_Loan_Offer_Amount__c,closeDate,
                                    //Added by Afreen for displaying the following three fields
                                    X3rd_Party_Photo__c, CallBack_Time__c, X3rd_Party_Lead_Source__c, X3rd_Party_Lead_Number__c,Loan_Purpose__c, Loan_Term__c, X3rd_Party_Photo_Tag__c,X3rd_Party_Lead_Status__c,
                                    //Added by RCADAPAN for TQLQW-489 to display X3rd Customer Address for Veda leads
                                    Account.X3rd_Customer_Address__c,
                                    (Select id, Name from Attachments where Name Like 'PicStarter Conversation%')
                                    FROM Opportunity WHERE Id =: oppURL limit 1];
            
            if(oppVar.size()!=0){  
                opp = oppVar[0];             
                this.custId = oppVar[0].Account.CLV_Customer_ID__c;
                this.phoneNo = oppVar[0].Account.PersonHomePhone;
                this.DoB = oppVar[0].Account.Date_of_Birth__pc;
                this.mobileNo = oppVar[0].Account.PersonMobilePhone;
                this.emailAddress = oppVar[0].Account.PersonEmail;
                this.offerStartDate = String.valueOf(oppVar[0].Offer_start_date__c != null ? oppVar[0].Offer_start_date__c.format() : '' );
                this.originalLoanOwner = oppVar[0].Original_Loan_Owner__c;
                this.offerAmount = String.valueOf(oppVar[0].Promo_Loan_Offer_Amount__c);
                this.externalPartyPhotoURL = oppVar[0].X3rd_Party_Photo__c;
                if(oppVar[0].Attachments.size() >0){
                     this.picStarterConvAttach      = oppVar[0].Attachments[0];
                }
               
                if(oppVar[0].closeDate != null)
                    this.offerExpiryDate = String.ValueOf(oppVar[0].closeDate);
                
                string addressStr = '';
                
                if(!(string.isBlank(oppVar[0].Account.PersonMailingStreet))){
                     addressStr = addressStr + oppVar[0].Account.PersonMailingStreet;
                }
                
                if(!(string.isBlank(oppVar[0].Account.PersonMailingCity))){
                    addressStr = addressStr + ', ' + oppVar[0].Account.PersonMailingCity;
                }
             
                if(!(string.isBlank(oppVar[0].Account.PersonMailingState))){
                    addressStr = addressStr + ', ' + oppVar[0].Account.PersonMailingState;
                }
                
                if(!(string.isBlank(oppVar[0].Account.PersonMailingPostalCode))){
                    addressStr = addressStr + ', ' + oppVar[0].Account.PersonMailingPostalCode;
                }
                
                if(!(string.isBlank(oppVar[0].Account.PersonMailingCountry))){
                    addressStr = addressStr + ', ' + oppVar[0].Account.PersonMailingCountry;
                }
                
                this.personAddress = addressStr; 
                
                //Added by RCADAPAN for TQLQW-489 to display X3rd Customer Address for Veda leads
                if(oppVar[0].X3rd_Party_Lead_Source__c == GEN_OriginationsConstants.MIRROR_VEDA_QUOTE){
                    this.personAddress = oppVar[0].Account.X3rd_Customer_Address__c;
                }
                
                this.spouseFName = oppVar[0].Account.Spouse_First_Name__pc;
                this.accomCode = oppVar[0].Account.Accommodation_Code__pc;
                this.spouseLName = oppVar[0].Account.Spouse_Last_Name__pc;
            }// End If*/
    }  
    
    
}