/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 25, 2014
Description: Apex test class for FeedCommentTriggerHandler
*/
@isTest
private class FeedCommentTriggerHandlerTest {
	
	@isTest static void test_method_one() {
		// Implement test code
		FeedComment fc = new FeedComment();
		fc.CommentType = 'ContentComment';

    	test.startTest();   
        try {
			insert fc;
        }
        catch(DmlException e) {
        	String sErrorMessage = e.getDmlMessage(0);
            system.assert(sErrorMessage.contains('You are not allowed to upload a document in the chatter feed.'));
        }
    	test.stopTest();		
	}
	
}