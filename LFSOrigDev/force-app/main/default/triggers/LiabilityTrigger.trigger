/*
Author: Mike Lasala Cloud Sherpas
Created Date: June 26, 2014
Description: Trigger for Liability object
*/
trigger LiabilityTrigger on Liability__c (after undelete) {

	if(Trigger.isAfter){
		if(Trigger.isUndelete){
			AccessControlTriggerHandler act = new AccessControlTriggerHandler();
	        act.blockUndelete(Trigger.new);
	    }
    }
}