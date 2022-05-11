@isTest
global class MockCallOutClass implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getJSONBody());
        res.setStatusCode(200);
        return res;
    }
    global string getJSONBody(){
    
    //You need to structure you'r sample JSON reponse into a String. In this reponse you'll need to specify values that you'll be using to do an Assert at the end of TestBatchClass
    String json = '{'+
		'\"kind\": \"someKind\",'+
		'\"etag\": \"\\\"jSwUP5mXUGwzAFbnLazODtWp_hU/xkmGPffByZklbXyXQDh4klvmhzo\\\"\",'+
		'\"pageInfo\": {'+
		'\"totalResults\": 1,'+
		'\"resultsPerPage\": 1'+
		'},'+
		'\"items\": ['+
		'{'+
		'\"kind\": \"someKind\",'+
		'\"etag\": \"\\\"jSwUP5mXUGwzAFbnLazODtWp_hU/YXgdzso7M5zhQmxu42URIvfh6VE\\\"\",'+
		'\"id\": \"someID\",'+
		'\"statistics\": {'+
		'\"viewCount\": \"87896\",'+
		'\"commentCount\": \"8\",'+
		'\"subscriberCount\": \"657\",'+
		'\"hiddenSubscriberCount\": false,'+
		'\"videoCount\": \"93\"'+
		'}'+
		'}'+
		']'+
		'}';
    return json;
    }
}