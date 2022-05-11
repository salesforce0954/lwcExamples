/*
    Author: Dandreb Crisologo (Cloud Sherpas)
    Created Date: April 30, 2014
    Description: Trigger to validate Start and End date of the product version
*/
trigger ValidateProductVersion on Product_Version__c(before insert, before update, after undelete) {

    if((trigger.isBefore && (trigger.isUpdate || trigger.isInsert)) ||
       (trigger.isAfter && trigger.isUndelete)) {
        ValidateProductVersionTriggerHandler.validateStartEndDate(trigger.new, trigger.isInsert);
    }

}