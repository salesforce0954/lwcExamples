public class veriPhoneIntegration{

   public static veriPhoneWrapperClass invokeVeriPhone(string mobileNumber){
   
     string apiKey = 'BEE7BF6D16B742B7916A049E2E2A039D';
     string endPoint = 'https://api.veriphone.io/v2/verify?phone='+mobileNumber+'&key='+apiKey;
     
     //Http
     
     http h = new http();
     
     //HttpRequest
     
     httpRequest hreq = new httpRequest();
     hreq.setMethod('GET');
     hreq.setEndPoint(endPoint);
     
     //HttpResponse
     httpResponse hres = h.send(hreq);
     
     system.debug('Body '+hres.getBody() + 'status '+hres.getStatus());
     veriPhoneWrapperClass vwc = (veriPhoneWrapperClass)JSON.deserialize(hres.getBody(),veriPhoneWrapperClass.class);
     system.debug('VWC '+vwc.phone_valid);
     
     return vwc;
   }

   public class veriPhoneWrapperClass{
   
       public string status;
       public string phone;
       public boolean phone_valid;
       public string phone_region;
       public string country;
       public string country_code;
       public string country_prefix;
       public string international_number;
       public string local_number;
       public string e164;
       public string carrier;
   }

}