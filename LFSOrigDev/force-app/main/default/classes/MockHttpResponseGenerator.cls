@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        String xmlResponse = '<?xml version="1.0"?>'
            +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap:Body xmlns:m="http://schemas.xmlsoap.org/soap/envelope/">'
            +'</soap:Body> </soap:Envelope>';
                     
        HttpResponse httpResponse= new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody(xmlResponse );
        return httpResponse;
    }
}