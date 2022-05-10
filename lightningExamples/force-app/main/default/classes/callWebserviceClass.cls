public class callWebserviceClass {
    private string cKey ='3MVG9cHH2bfKACZZu0INFH_E5U_UqqP8_Nf6NtPdEfq6TCPIsZHVSpc88ikPnZPE_z4wPbOxxgZLa9tgse76e';
    private string cSecret = '1BA93F5DAA2B4AA3B2A4B44C5E8CEBA93E1364D9A2947805960BF118B69D4B5A';
    private string uName = 'salesforce0954@gmail.com';
    private string passwd = 'Swinburne$*0909jfpZfLavbGWQI8qFuyT3WkFQ';
    
   
   
    public class responseWrapper {
        public string id;
        public string access_token;
        public string instance_url;
    }
    public string getRequestToken() {
        //string reqBody = '?grant_type=password&client_id=' + cKey + '&client_secret=' + cSecret + '&username=' + uName + '&password=' + passwd;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody('callout:suneellwcApp');
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse hresp = h.send(req);
        system.debug('Response ** '+hresp.getBody());
        
       responseWrapper wResp = (responseWrapper) JSON.deserialize(hresp.getBody(), responseWrapper.class);
        system.debug('Instance url' + wResp.instance_url);
        system.debug('session id' + wResp.access_token);
        return wResp.access_token;
    }
    
            @future(callout = true)
            public static void getConList(Set<id> conIdSet) {
                String accToken;
                string responseBody;
                string endPoint = 'https://suneellwc-dev-ed.my.salesforce.com/services/apexrest/createContactRecord';
                callWebserviceClass obj = new callWebserviceClass();
                accToken = obj.getRequestToken();
                system.debug('access token' + accToken);
                if (accToken != '') {
                    for (Contact con: [SELECT id, firstName, lastName, email from contact where id in: conIdSet]) {
                         system.debug('JSON' + JSON.serialize(con));
                        Http h1 = new Http();
                        HttpRequest req1 = new HttpRequest();
                        req1.setHeader('Authorization', 'Bearer ' + accToken);
                        req1.setHeader('Content-Type', 'application/json');
                        req1.setMethod('POST');
                        req1.setBody(JSON.serialize(con));
                        req1.setEndpoint('callout:suneellwcApp/services/apexrest/createContactRecord');
                      // req1.setEndpoint(endPoint);
                        HttpResponse hresp1 = h1.send(req1);
                        system.debug('hresp1' + hresp1);
                    }
                }
                
        }
}