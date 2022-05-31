public class searchPostalPinCode{

   public integer postalPincode {get;set;}
   public string postOfficeBranchName {get;set;}
   public List<postalWrapper> response {get;set;}
   public string postalMessage {get;set;}
      
    public void Pincode(){
    
         http h = new http();
         
         httpRequest hreq = new httpRequest();
         hreq.setMethod('GET');
         //hreq.setEndPoint('https://api.postalpincode.in/pincode/'+postalPincode);
         hreq.setEndPoint('https://api.postalpincode.in/postoffice/'+postOfficeBranchName);
         
         httpResponse hres = h.send(hreq);
         system.debug(hres.getBody());
          response=(List<postalWrapper>)JSON.deserialize(hres.getBody(),List<postalWrapper>.class);
          system.debug('Response Size '+response.size());
          if(response.size() > 0){
          system.debug('List entered');
            postalMessage = 'No postal code found in the database';
          }
          
        /**  for(postalWrapper res:response){
            system.debug('Message '+res.Message+' Status '+res.Status);
              for(PostOffice po:res.PostOffice){
                  system.debug('BranchType '+po.BranchType);
              }
          } */
          
           system.debug('Response '+response);
    }
    
    public class postalWrapper{
       public string Message {get;set;}
       public string status {get;set;}
       public List<PostOffice> PostOffice {get;set;}
    }
    
    public class Postoffice{
    
       public string Name {get;set;}
       public string Description {get;set;}
       public string BranchType {get;set;}
       public string Pincode {get;set;}
       public string DeliveryStatus {get;set;}
       public string Circle {get;set;}
       public string District {get;set;}
       public string Division {get;set;}
       public string Region {get;set;}
       public string State {get;set;}
       public string Country {get;set;}
       
    }
}