/*
Author: August Del Rosario Cloud Sherpas
Created Date: January 21, 2014
Description: Trigger for VerifiedType field
*/
trigger AMLVerifiedType on AML__c (before insert,before update, after undelete) {
	
	//AMLVerifiedTypeHandler Handler = new AMLVerifiedTypeHandler(); 
	
	// Code Scan Fix: Adrian Recio - Empty Condition
	/*
	if(trigger.isBefore){
		if(trigger.isInsert){
			//Handler.insertVerifiedType(trigger.new);
		}
		if(trigger.isUpdate){
			//Handler.insertVerifiedType(trigger.new);
		}
    }
	*/

 	if(Trigger.isUndelete){
		AccessControlTriggerHandler act = new AccessControlTriggerHandler();
        act.blockUndelete(Trigger.new);
    }
}