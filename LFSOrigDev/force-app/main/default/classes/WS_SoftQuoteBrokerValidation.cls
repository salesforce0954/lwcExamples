@RestResource(urlMapping='/api/SoftQuoteBroker/*')
global without sharing class WS_SoftQuoteBrokerValidation{

@HttpPost
global static brokerQuoteResponse checkBrokerID() {
   boolean softQuoteCheck= SoftQuoteUtil.checkSoftQuoteOrgEnabled();
   brokerQuoteResponse res = new brokerQuoteResponse();  
      if(softQuoteCheck){ 

        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
         Contact brokerContact;
        Id brokerRecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(GEN_OriginationsConstants.BROKER_RECORD_TYPE_APAC).RecordTypeId;
       
        //Read the parameters   
        brokerQuoteWrapper rw = (brokerQuoteWrapper)JSON.deserialize(requestString,brokerQuoteWrapper.class);
        
        String responseDescription;
        String brokerId=rw.brokerId;
        
        if(brokerId == ''){
            res.status    = GEN_OriginationsConstants.Soft_Quote_WS_Retry;
            res.responseDesc = GEN_OriginationsConstants.Soft_Quote_Broker_Msg_Empty;
        
        }
      
        else{
             try{
            List<Contact> brokerList = [Select Id, Name, Broker_ID__c From Contact Where Broker_ID__c = :brokerId 
                                            and Contact_Accreditation_Status__c = : GEN_OriginationsConstants.ELIGIBITIY_BROKER_STATUS_ACTIVE 
                                            and (Broker_Product__c Like '%PL%' OR Broker_Product__c Like '%Motor Solutions%'  ) 
                                            and recordTypeId = :brokerRecordTypeId Limit 1];  
                    if(brokerList.size() >0 && brokerList[0].Id != null ){
                        brokerContact = brokerList[0] ;
                          res.status    = GEN_OriginationsConstants.Soft_Quote_WS_Success;
                        res.responseDesc = GEN_OriginationsConstants.Soft_Quote_Broker_Message_Success;
                       
                    }else{
                       res.status    = GEN_OriginationsConstants.Soft_Quote_Broker_Not_Found; 
                       res.responseDesc =GEN_OriginationsConstants.Soft_Quote_Broker_Message_Failure;
                    }   
             } 
             catch(Exception e){
                 res.status    = GEN_OriginationsConstants.Soft_Quote_WS_Retry;
                 res.responseDesc =GEN_OriginationsConstants.Soft_Quote_Service_Error;
           }  
         }  
       }
       else{
           res.status    = GEN_OriginationsConstants.Soft_Quote_WS_Retry;
           res.responseDesc =GEN_OriginationsConstants.Soft_Quote_Service_Error;
       } 
        return res;

    }

    Public class brokerQuoteWrapper{
        public String brokerID;
               
         public brokerQuoteWrapper parse(String json){
            return (brokerQuoteWrapper) System.JSON.deserialize(json, brokerQuoteWrapper.class);
        }
        
     }
  Global class brokerQuoteResponse{
        public String responseDesc;
        public String status;
               
         public brokerQuoteResponse(){
           
        }
        
     }
  
}