/**
    Author: Fel Saliba Cloud Sherpas
    Created Date: April 23, 2014
    Description: Trigger for Loan Purpose Object
**/

trigger LoanPurposeTrigger on Loan_Purpose__c (after update, after undelete) {

    //instantiate handler class.
    LoanPurposeTriggerHandlerClass handler = new LoanPurposeTriggerHandlerClass();
    
    //create list of loan purpose records.
    List<Loan_Purpose__c> lpList = new List<Loan_Purpose__c>();
    
    if(Trigger.isUpdate){
        
        if(Trigger.isAfter){
             for(Loan_Purpose__c lp:Trigger.new){
                
                Loan_Purpose__c oldLP = Trigger.oldMap.get(lp.ID);
                
                //check if old value is equal to Refinance
                if(oldLP.Value__c == GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE 
                    && lp.Value__c != GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE){
                    //add the loan purpose record in the list
                    lpList.add(lp);
                }
             }
             //check list if empty
             if(!lpList.isEmpty()){
                 //pass the list in a method inside the handler class.
                 handler.deleteDisbursementRefinance(lpList);
             }            
        }
    }

    if(Trigger.isUndelete){
        AccessControlTriggerHandler act = new AccessControlTriggerHandler();
        act.blockUndelete(Trigger.new);
    }
}