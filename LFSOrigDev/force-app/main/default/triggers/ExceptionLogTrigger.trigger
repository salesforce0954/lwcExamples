/**
    Author: Dan Crisologo
    Created Date: June 16, 2014
    Description: Trigger for Exception Log object
**/
trigger ExceptionLogTrigger on ExceptionLog__c (after insert) {

    /*if(trigger.isAfter && trigger.isInsert) {
        ExceptionLogTriggerHandler.processRetryBatch(trigger.new);
    } */

}