@RestResource(urlMapping='/api/createQuoteNZ/*')
global without sharing class WS_SoftQuoteGenerationNZ{

   
    @HttpPost
    global static outputQuote createQuoteNZ() {
      boolean softQuoteCheck= SoftQuoteUtil.checkSoftQuoteOrgEnabled();
      Quote__c quoteObj = new Quote__c();
      outputQuote quoteRes = new outputQuote();  
      if(softQuoteCheck){
            RestRequest req = RestContext.request;
            system.debug('complete req'+req );
            Blob body = req.requestBody;
            String requestString = body.toString();
            try{
                quoteObj = (Quote__c)JSON.deserialize(requestString, Quote__c.Class);
                insert quoteObj ;
             }   
             catch(Exception e){
                 quoteRes.errors =GEN_OriginationsConstants.SOFT_QUOTE_SERVICE_ERROR;
                 quoteRes.success =false;
                 return quoteRes;
               }
            quoteRes.id= quoteObj.id;
            quoteRes.success =true;
         }
     
     return quoteRes; 
             
    }

      Global class outputQuote{
        public String id;
        public boolean success;
        public String errors;
       
        public outputQuote(){}
        
        
     }
     
       
  
}