/*
    Author: Mike Lasala (Cloud Sherpas)
    Created Date: June 12, 2014
    Description: Trigger to validate Start and End date of the meta compliance check
*/
trigger MetaComplianceCheckTriggerHandler on Meta_Compliance_Check__c (before insert, before update, after undelete) {

	if((trigger.isBefore && (trigger.isUpdate || trigger.isInsert)) ||
       (trigger.isAfter && trigger.isUndelete)) {
        MetaComplianceCheckTriggerHandler.validateStartEndDate(trigger.new);
    }

}