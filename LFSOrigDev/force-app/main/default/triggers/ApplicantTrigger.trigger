trigger ApplicantTrigger on Applicant__c (after undelete, before insert, before update) {
    if(Trigger.isUndelete){
        AccessControlTriggerHandler act = new AccessControlTriggerHandler();
        act.blockUndelete(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isInsert){
        ApplicantTriggerHandler.populateThirdPartyST(Trigger.new);
        ApplicantTriggerHandler.checkExternalApplicantEmail(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        ApplicantTriggerHandler.populateThirdPartyST(Trigger.new);
    }
}