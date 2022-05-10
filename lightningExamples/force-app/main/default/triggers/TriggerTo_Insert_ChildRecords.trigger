trigger TriggerTo_Insert_ChildRecords on BPAY__c(before delete) {
    MyController.UpdateChildValues(Trigger.Old);
}