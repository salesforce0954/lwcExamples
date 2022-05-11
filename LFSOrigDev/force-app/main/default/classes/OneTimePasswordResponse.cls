global with sharing class OneTimePasswordResponse {
    
    public String status {get;set;}
    public Map<String,String> error {get;set;}
    public Map<String,String> data {get;set;}

    public OneTimePasswordResponse(){
        status = '';
        error = new Map<String,String>();
        data = new Map<String,String>();
    }

}