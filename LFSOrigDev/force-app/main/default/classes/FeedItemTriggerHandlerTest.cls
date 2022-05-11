/*
Author: Mat Isidro	Cloud Sherpas
Created Date: March 25, 2014
Description: Apex test class for FeedItemTriggerHandler
*/
@isTest
private class FeedItemTriggerHandlerTest {
	
	@isTest static void test_method_one() {
		// Implement test code
		FeedItem fi = new FeedItem();
		fi.Type = 'ContentPost';

    	test.startTest();   
        try {
			insert fi;
        }
        catch(DmlException e) {
        	String sErrorMessage = e.getDmlMessage(0);
            system.assert(sErrorMessage.contains('You are not allowed to upload a document in the chatter feed.'));
        }
    	test.stopTest();		
	}
	
}