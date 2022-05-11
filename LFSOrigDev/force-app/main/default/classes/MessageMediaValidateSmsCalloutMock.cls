@isTest
global with sharing class MessageMediaValidateSmsCalloutMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{    "callback_url": null,    "delivery_report": true,    "destination_number": "+61400000094",    "format": "SMS",    "message_expiry_timestamp": null,    "message_flags": [],    "message_id": "5c95a89d-307f-480e-bb9e-6734a8ca948f",    "metadata": {        "Product": "PL"    },    "scheduled": null,    "status": "delivered",    "content": "AU message test",    "source_number": "Latitude",    "rich_link": null,    "media": null,    "subject": null}');
        res.setStatusCode(200);
        return res; 
    }
}