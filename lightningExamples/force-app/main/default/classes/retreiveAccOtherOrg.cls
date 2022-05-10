public class retreiveAccOtherOrg {
    public static void getAccountInfo(){
        string accName;
        string accId;
        set<id> externalIds = new set<id>();
        DateTime accCreatedToday;
        Http h = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setMethod('GET');
        hreq.setEndPoint('callout:suneellwcApp/services/apexrest/accountRetreive');
        hreq.setHeader('content-type','application/json');
        HttpResponse hres= h.send(hreq);
        system.debug('Status code '+hres.getStatusCode());
        JsonParser jparse = json.createParser(hres.getBody());
        system.debug('Jparse Value '+hres.getBody());
        while(jparse.nextToken() != null){
            if(jparse.getCurrentToken() == JSONToken.FIELD_NAME){
                if(jparse.getText() == 'Name'){
                    jparse.nextToken();
                    accName = jparse.getText();
                }
                if(jparse.getText() == 'Id'){
                    jparse.nextToken();
                    accId = jparse.getText();
                    externalIds.add(accId);
                }
                if(jparse.getText() == 'CreatedToday'){
                    jparse.nextToken();
                    accCreatedToday = jparse.getDateTimeValue();
                }
            }
        }
        List<Account> accList;
        List<Account> insertList;
        List<Account> updateList;
        Account acc;
        Account updateAcc;
        Account u;
        Account updateu;
        try{
            accList = [select Name,External_Id__c,id from Account where External_Id__c in: externalIds];
            system.debug('Account size '+accList.size());
            
            if(accList.size() < 1){
                system.debug('Inserting new Account');
                acc = new Account();
                acc.External_Id__c = accId;
                acc.Name = accName;
                insert acc;
            }
            if(accList.size() >= 1){
                
                    system.debug('Updating existing Account'); 
                   
                 /**   updateAcc = [select name from Account where External_Id__c =: accId];
                    system.debug('Updated Name '+updateAcc.Name);
                    system.debug('account id '+accId);
                    updateAcc.Name = accName;
                
                update updateAcc; */
                
                for(Account a: accList){
                
                   a.Name = accName;
                   
                
                }
                update accList;
                
                
            }
        }catch(DMLException e){
            system.debug('Exception occurred '+e);
        }
        
        
       
        
    }
}