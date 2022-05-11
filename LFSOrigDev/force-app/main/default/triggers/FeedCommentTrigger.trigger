/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 24, 2014
Description: Trigger for FeedComment
*/
trigger FeedCommentTrigger on FeedComment (before insert) {
	if(trigger.isBefore && trigger.isInsert){
		if(trigger.isInsert){
			FeedCommentTriggerHandler.disableDocumentUpload(trigger.new);
		}
    }
}