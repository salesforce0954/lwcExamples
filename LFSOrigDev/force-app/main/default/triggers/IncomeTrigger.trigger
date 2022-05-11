/*
Author: Adrian Recio Cloud Sherpas
Created Date: February 18, 2014
Description: Main Trigger for Income Object
*/
trigger IncomeTrigger on Income__c (after insert, after update, before delete, after undelete) {
	
	IncomeTriggerHandler iHandler = new IncomeTriggerHandler();

	//**************************************************// 
	// Uncomment the snippet if before insert 			//
	// and update conditions is needed in this trigger	//
	//**************************************************//
	
	// Before insert and update condition
	/*if(Trigger.isBefore && Trigger.isInsert) {		
		iHandler.onBeforeInsert(Trigger.new, Trigger.newMap);	
	}else if(Trigger.isBefore && Trigger.isUpdate) {		
		iHandler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);	
	}*/
		
	// Before delete condition
	if(Trigger.isBefore && Trigger.isDelete) {		
		iHandler.onBeforeDelete(Trigger.old, Trigger.oldMap);	
	}
	
	// After insert and update condition
	if(Trigger.isAfter && Trigger.isInsert) {		
		iHandler.onAfterInsert(Trigger.new, Trigger.newMap);	
	}else if(Trigger.isAfter && Trigger.isUpdate) {		
		iHandler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);	
	}

	if(Trigger.isUndelete){
		AccessControlTriggerHandler act = new AccessControlTriggerHandler();
        act.blockUndelete(Trigger.new);
    }
}