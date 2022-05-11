/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 21, 2014
Description: Apex class for FeedItemTrigger
*/
public class FeedItemTriggerHandler {
	
	public static void disableDocumentUpload(List<FeedItem> feedItemList) {
		for (FeedItem fi : feedItemList) {
			if(fi.type == 'ContentPost') {
				fi.addError('You are not allowed to upload a document in the chatter feed.');
			}
		}		
	}
	
}