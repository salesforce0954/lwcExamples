/*
Author: Adrian Recio Cloud Sherpas
Created Date: March 27, 2014
Description: Income Capacity events
*/
trigger IncomeCapacityTrigger on Income_Capacity__c (after update, after insert, after delete) {
    IncomeCapacityTriggerHandler iHandler = new IncomeCapacityTriggerHandler();

    //**************************************************// 
    // Uncomment the snippet if before insert           //
    // and update conditions is needed in this trigger  //
    //**************************************************//
    
    // Before insert and update condition
    /*if(Trigger.isBefore && Trigger.isInsert) {        
        iHandler.onBeforeInsert(Trigger.new);   
    }else if(Trigger.isBefore && Trigger.isUpdate) {        
        iHandler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);  
    }*/


    // After insert, update, and delete condition
    if(Trigger.isAfter && Trigger.isInsert) {       
        iHandler.onAfterInsert(Trigger.new, Trigger.newMap);    
    }else if(Trigger.isAfter && Trigger.isUpdate) {     
        iHandler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);   
    }else if(Trigger.isAfter && Trigger.isDelete) {     
        iHandler.onAfterDelete(Trigger.old, Trigger.oldMap);    
    }
}