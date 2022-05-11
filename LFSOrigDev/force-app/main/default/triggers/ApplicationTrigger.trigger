/**
    Author: Fel Saliba Cloud Sherpas
    Created Date: Jan 22, 2014
    Description: Trigger for Application Object
    Change: 2016-02-26 TOM CHANGE - Tony XU
**/

trigger ApplicationTrigger on Application__c (before insert, before update, after insert, after update, after undelete) {

    AppTriggerClass.executeTriggerEvents(trigger.isBefore, trigger.isAfter, trigger.isInsert, 
                                         trigger.isUpdate,trigger.isDelete, trigger.new, 
                                         trigger.newMap, trigger.old, trigger.oldMap );

}