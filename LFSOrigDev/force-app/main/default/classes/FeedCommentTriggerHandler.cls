/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 24, 2014
Description: Apex class for FeedCommentTrigger
*/
public with sharing class FeedCommentTriggerHandler {
	
	public static void disableDocumentUpload(List<FeedComment> feedCommentList) {
		for (FeedComment fc : feedCommentList) {
			if (fc.CommentType == 'ContentComment') {
				fc.addError('You are not allowed to upload a document in the chatter feed.');
			}
		}		
	}
	
}