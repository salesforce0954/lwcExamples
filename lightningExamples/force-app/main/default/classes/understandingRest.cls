public class understandingRest{

   public string leadSearchName {get;set;}
    public List<leadResponse> leadResponseList {get;set;}
    public string accessToken {get;set;}
    public string instanceURL {get;set;}
    
    public string leadFirstName {get;set;}
    public string leadLastName {get;set;}
    public string leadCompanyName {get;set;}
    public string leadEmail {get;set;}
    public string leadPhoneNumber {get;set;}
    public string leadCreateMessage {get;set;}
    public List<String> externalIds {get;set;}
    public string storeIds;
   
    public void requestLeadDetails(){
       // requestAccessToken();
       // string leadGetEndpoint = instanceurl+'/services/apexrest/LeadService/name='+leadSearchName;
      //  system.debug('Get lead details endpoint '+leadGetEndpoint);
        
        http h = new http();
        httpRequest hreq = new HttpRequest();
        hreq.setEndpoint('callout:suneellwcApp/services/apexrest/LeadService');
        hreq.setMethod('GET');
        //hreq.setHeader('Authorization','Bearer '+accessToken);
        hreq.setHeader('Content-type','application/json');
        
        HttpResponse res = h.send(hreq);
        system.debug('Response '+res.getBody());
        system.debug('Status '+res.getStatusCode());
        if(res.getStatusCode() == 200){
            leadResponseList = (list<leadResponse>)JSON.deserialize(res.getBody().replaceAll('__c','Tempc'), list<leadResponse>.class);
        }
        system.debug('Lead Response List '+leadResponseList);
        
        JSONParser parser = JSON.createParser(res.getBody());
      /**  while(parser.nextToken() !=NULL){
                
                 if((parser.getCurrentToken() == JSONTOKEN.FIELD_NAME) && parser.getText()=='NumberofLocations__c'){
                 system.debug('Entered');
                    parser.nextToken();
                    storeIds = parser.getText();
                  
                }
             } */
             
             List<Account_External__c> actExtList = new List<Account_External__c>();
             
             for(LeadResponse lr: leadResponseList){
               
                Account_External__c accExt = new Account_External__c();
                accExt.Account_Name__c = lr.Name;
                accExt.Email__c = lr.Email;
                accExt.Phone__c = lr.Phone;
                accExt.External_ID__c = lr.Id;
                accExt.NumberOfLocations__c = lr.NumberOfLocationsTempc;
                actExtList.add(accExt);
                system.debug('Acc Ext '+actExtList);
             }
               insert actExtList; 

    }
    
     public class leadResponse{
        public string id {get;set;}
        public string  Name {get;set;}
        public string Email {get;set;}
        public string Phone {get;set;}
        public string Company {get;set;}
        public string MobilePhone {get;set;}
        public integer NumberofLocationsTempc {get;set;}
        
    }

}