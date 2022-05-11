/*
Author: Fel Saliba Cloud Sherpas
Created Date: April 23, 2014
Description: Class for Loan Purpose Triggers
*/

public with sharing class LoanPurposeTriggerHandlerClass{

    /** Method to delete Disbursement Records **/
    public void deleteDisbursementRefinance(List<Loan_Purpose__c> lpList){
        
        //loop on loan purpose list and put the Ids in a set
        Set<String> loanPurposeIds = new Set<String>();
        for(Loan_Purpose__c lp: lpList){
            loanPurposeIds.add(lp.Id);
        }
        
        //get the disbursement records containing the loan purpose Ids
        List<Disbursement__c> disbursementToDelete = new List<Disbursement__c>();
        disbursementToDelete = [Select Id from Disbursement__c where Loan_Purpose__c IN: loanPurposeIds];
        
        //check the list size
        if(!disbursementToDelete.isEmpty()){
            try{
                //delete the disbursement records.
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Disbursement__c.sObjectType.getDescribe().isDeletable()){
                    delete disbursementToDelete;
                }
                */
                delete disbursementToDelete;
            }
            catch(DMLException e){
                //log exception if there's any
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'LoanPurposeTriggerHandlerClass', 'Disbursement__c', 'Class');
            }
        }
    }
}