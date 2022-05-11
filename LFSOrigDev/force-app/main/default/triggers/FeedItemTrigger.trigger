/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 21, 2014
Description: Trigger for FeedItem
*/
trigger FeedItemTrigger on FeedItem (before insert) {
	if(trigger.isBefore && trigger.isInsert){
		if(trigger.isInsert){
			FeedItemTriggerHandler.disableDocumentUpload(trigger.new);
		}
    }
}