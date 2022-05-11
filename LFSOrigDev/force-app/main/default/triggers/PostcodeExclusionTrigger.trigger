/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 11 Feb 2013 
* @description Trigger for Post Code Exclusion Object
*/

trigger PostcodeExclusionTrigger on Postcode_Exclusion__c (after insert, after update, before delete) {
	// Instantiate Trigger Logic handler class
	PostcodeExclusionTriggerHandler peTriggerHandler = new PostcodeExclusionTriggerHandler();

	if(Trigger.isInsert){
		
		if(Trigger.isAfter){
			peTriggerHandler.setPostCode(trigger.new, 'Insert');
		}// End If
	}// End If
	
		
			
	
	if(Trigger.isDelete){
		if(Trigger.isBefore){
			peTriggerHandler.setPostCode(trigger.old, 'Delete');
		}// End If
		
		
	}// End If
}// End PostcodeExclusionTrigger