public class postalPinCodeLightning{

  
   
   
  @AuraEnabled
   public static List<postalWrapper> Pincode(string postOfficeBranchName){
    
         http h = new http();
         
         httpRequest hreq = new httpRequest();
         hreq.setMethod('GET');
         //hreq.setEndPoint('https://api.postalpincode.in/pincode/'+postalPincode);
         hreq.setEndPoint('https://api.postalpincode.in/postoffice/'+postOfficeBranchName);
         
         httpResponse hres = h.send(hreq);
         system.debug(hres.getBody());
         List<postalWrapper> response=(List<postalWrapper>)JSON.deserialize(hres.getBody(),List<postalWrapper>.class);
         system.debug('Response Size '+response.size());
         
          
        /**  for(postalWrapper res:response){
            system.debug('Message '+res.Message+' Status '+res.Status);
              for(PostOffice po:res.PostOffice){
                  system.debug('BranchType '+po.BranchType);
              }
          } */
          
           return response;
    }
    
    public class postalWrapper{
       @AuraEnabled
       public string Message {get;set;}
       @AuraEnabled
       public string Status {get;set;}
       @AuraEnabled
       public List<PostOffice> PostOffice {get;set;}
    }
    
    public class Postoffice{
       @AuraEnabled
       public string Name {get;set;}
       @AuraEnabled
       public string Description {get;set;}
       @AuraEnabled
       public string BranchType {get;set;}
       @AuraEnabled
       public string Pincode {get;set;}
       @AuraEnabled
       public string DeliveryStatus {get;set;}
       @AuraEnabled
       public string Circle {get;set;}
       @AuraEnabled
       public string District {get;set;}
       @AuraEnabled
       public string Division {get;set;}
       @AuraEnabled
       public string Region {get;set;}
       @AuraEnabled
       public string State {get;set;}
       @AuraEnabled
       public string Country {get;set;}
       
    }
}