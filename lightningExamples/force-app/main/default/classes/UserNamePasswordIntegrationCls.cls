public class UserNamePasswordIntegrationCls {
    
    public string leadSearchName {get;set;}
    public List<leadResponse> leadResponseList {get;set;}
    public string accessToken {get;set;}
    public string instanceURL {get;set;}
    
    public string accountId {get;set;}
    
    public string leadFirstName {get;set;}
    public string leadLastName {get;set;}
    public string leadCompanyName {get;set;}
    public string leadEmail {get;set;}
    public string leadPhoneNumber {get;set;}
    public string leadCreateMessage {get;set;}
    public List<String> externalIds {get;set;}
    public string storeIds;
    
    public UserNamePasswordIntegrationCls(){
        leadResponseList = new List<leadResponse>();
    }
    public void requestAccessToken(){
       List<Integration_Setup__c> integrationSetUpList = [Select id,Server_Name__c,Server_User_Name__c,Server_Password__c,clientId__c,clientSecret__c from Integration_Setup__c];
        if(integrationSetUpList != null && integrationSetUpList.size() > 0){
            string accesstokenEndpoint = 'https://login.salesforce.com/services/oauth2/token';
            accesstokenEndpoint = accesstokenEndpoint+'?grant_type=password';
            accesstokenEndpoint = accesstokenEndpoint+'&client_id='+integrationSetUpList[0].clientId__c;
            accesstokenEndpoint = accesstokenEndpoint+'&client_secret='+integrationSetUpList[0].clientSecret__c;
            accesstokenEndpoint = accesstokenEndpoint+'&username='+integrationSetUpList[0].server_User_Name__c;
            accesstokenEndpoint = accesstokenEndpoint+'&password='+integrationSetUpList[0].server_Password__c;
            
            Http h = new Http();
            HttpRequest hreq = new HttpRequest();
            hreq.setEndpoint(accesstokenEndpoint);
            hreq.setMethod('POST');
            blob authorizeHeader = Blob.valueOf(integrationSetUpList[0].server_User_Name__c+':'+integrationSetUpList[0].server_Password__c);
            string authorizationvalue = 'BASIC'+EncodingUtil.base64Encode(authorizeHeader);
            hreq.setHeader('Authorization',authorizationvalue);
            HttpResponse hres = h.send(hreq);
            
            system.debug('***hres.getBody()'+hres.getBody());

            JSONParser parser = JSON.createParser(hres.getBody());
            while(parser.nextToken() !=NULL){
                if((parser.getCurrentToken() == JSONTOKEN.FIELD_NAME) && parser.getText()=='access_token'){
                 parser.nextToken();
                 accessToken = parser.getText();
               }
                if((parser.getCurrentToken() == JSONTOKEN.FIELD_NAME) && parser.getText()=='instance_url'){
                    parser.nextToken();
                    instanceurl = parser.getText();
                }
                 if((parser.getCurrentToken() == JSONTOKEN.FIELD_NAME) && parser.getText()=='Id'){
                 system.debug('Entered');
                    parser.nextToken();
                    storeIds = parser.getText();
                    system.debug('StoreIds '+storeIds);
                   // externalIds.add(storeIds);
                    //system.debug('External Id values '+externalIds);
                }
             } 
        }
    }
    public void requestLeadDetails(){
        requestAccessToken();
        string leadGetEndpoint = instanceurl+'/services/apexrest/LeadService/name='+leadSearchName;
        system.debug('Get lead details endpoint '+leadGetEndpoint);
        
        http h = new http();
        httpRequest hreq = new HttpRequest();
        hreq.setEndpoint(leadGetEndpoint);
        hreq.setMethod('GET');
        hreq.setHeader('Authorization','Bearer '+accessToken);
        hreq.setHeader('Content-type','application/json');
        
        HttpResponse res = h.send(hreq);
        system.debug('Response '+res.getBody());
        system.debug('Status code '+res.getStatusCode());
        if(res.getStatusCode() == 200){
            leadResponseList = (list<leadResponse>)JSON.deserialize(res.getBody(), list<leadResponse>.class);
        }
        system.debug('Lead Response List '+leadResponseList);
        
        JSONParser parser = JSON.createParser(res.getBody());
        while(parser.nextToken() !=NULL){
                
                 if((parser.getCurrentToken() == JSONTOKEN.FIELD_NAME) && parser.getText()=='Id'){
                 system.debug('Entered');
                 parser.nextToken();

                   accountId = parser.getText();
                   system.debug('Account Id '+accountId);
                }
             } 


    }
    
    public void deleteLead(){
    system.debug('Entered Delete');
    requestAccessToken();
        string leadGetEndpoint = instanceurl+'/services/apexrest/LeadService/'+accountId;
        system.debug('Get lead details endpoint '+leadGetEndpoint);
        
        http h = new http();
        httpRequest hreq = new HttpRequest();
        hreq.setEndpoint(leadGetEndpoint);
        hreq.setMethod('DELETE');
        hreq.setHeader('Authorization','Bearer '+accessToken);
        hreq.setHeader('Content-type','application/json');
        
        HttpResponse res = h.send(hreq);
        system.debug('Response Delete '+res.getBody());
    }
    
     public void updateLeadEmail(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('newEmail',leadEmail);   
        gen.writeEndObject();
        system.debug('Gen==> '+gen.getAsString());
        string requestJson = gen.getAsString();
        requestAccessToken();
        string leadPatchEndpoint = instanceurl+'/services/apexrest/LeadService/'+accountId;
        http h = new http();
        httpRequest hreq = new HttpRequest();
        hreq.setEndpoint(leadPatchEndpoint);
        hreq.setMethod('PATCH');
        hreq.setBody(requestJson);
        hreq.setHeader('Authorization','Bearer '+accessTOken);
        hreq.setHeader('Content-Type','application/json');
        HttpResponse res = h.send(hreq);
        leadCreateMessage = res.getBody();
        system.debug('Lead Create Message '+leadCreateMessage);
    } 
    
    public void createLead(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('fname',leadFirstName);
        gen.writeStringField('lname',leadLastName);
        gen.writeStringField('cname',leadCompanyName);
        gen.writeStringField('leademail',leadEmail);
        gen.writeStringField('leadphoneNumber',leadPhoneNumber);        
        gen.writeEndObject();
        system.debug('Gen==> '+gen.getAsString());
        string requestJson = gen.getAsString();
        requestAccessToken();
        string leadCreateEndpoint = instanceurl+'/services/apexrest/LeadService/';
        http h = new http();
        httpRequest hreq = new HttpRequest();
        hreq.setEndpoint(leadCreateEndpoint);
        hreq.setMethod('POST');
        hreq.setBody(requestJson);
        hreq.setHeader('Authorization','Bearer '+accessTOken);
        hreq.setHeader('Content-Type','application/json');
        HttpResponse res = h.send(hreq);
        leadCreateMessage = res.getBody();
        system.debug('Lead Create Message '+leadCreateMessage);
    }
    
  
    
    public class leadResponse{
        public string id {get;set;}
        public string  Name {get;set;}
        public string Email {get;set;}
        public string Phone {get;set;}
        public string Company {get;set;}
        public string MobilePhone {get;set;}
    }
}