@RestResource(urlMapping='/api/SoftQuote/*')
global without sharing class WS_SoftQuoteDuplicateCheck{

   
    @HttpPost
    global static DuplicateResponse checkQuoteDuplication() {
      boolean softQuoteCheck= SoftQuoteUtil.checkSoftQuoteOrgEnabled();
      DuplicateResponse DupRes = new DuplicateResponse();  
      if(softQuoteCheck){
            RestRequest req = RestContext.request;
            system.debug('complete req'+req );
            Blob body = req.requestBody;
            String requestString = body.toString();
           
            //Read the parameters   
            DuplicateQuoteWrapper rw = (DuplicateQuoteWrapper)JSON.deserialize(requestString,DuplicateQuoteWrapper.class);
            String responseDescription ='';
            String emailAddress=rw.emailAddress;
            String dateOfBirth= rw.dateOfBirth;
            String mobileNumber= rw.mobileNumber;
            String brokerId= rw.brokerID;
            String declinedStatus='Declined';
            String expiredStatus='Expired';
            Map<String, String> emailMobileDOBMap= new Map<String, String>();
            List<quote__c> qList = new List<quote__c>();
                //Query to get all the quotes based on email address and mobile number
                       
           if(emailAddress !='' && mobileNumber!='' && dateOfBirth!=''){
               
           
             try{
             String soqlQuery = 'SELECT Id,Broker_ID__c,Date_of_Birth__c,Mobile_Number__c,Email_ID__c ,Quote_Stage__c FROM Quote__c ';
                
                 
                 if(String.isEmpty(brokerId)){                
                      soqlQuery +=  'WHERE ( Quote_Stage__c !=  \'' +String.escapeSingleQuotes(declinedStatus)+ '\' AND Quote_Stage__c !=  \'' +String.escapeSingleQuotes(expiredStatus)+ '\' ) AND Broker_ID__c = null AND ( Email_ID__c = \'' +emailAddress+ '\' ';
                     soqlQuery += ' AND Mobile_Number__c= \'' +String.escapeSingleQuotes(mobileNumber)+ '\' )';
                }else if(!String.isEmpty(brokerId)){
                     soqlQuery +=  'WHERE ( Quote_Stage__c !=  \'' +String.escapeSingleQuotes(declinedStatus)+ '\' AND Quote_Stage__c !=  \'' +String.escapeSingleQuotes(expiredStatus)+ '\' ) AND ( Email_ID__c = \'' +emailAddress+ '\' ';
                     soqlQuery += ' AND Mobile_Number__c= \'' +String.escapeSingleQuotes(mobileNumber)+ '\' )';
                     soqlQuery += ' AND Broker_ID__c= \'' +String.escapeSingleQuotes(brokerId)+ '\' ';
                }               
                
              
                soqlQuery += ' ORDER BY CreatedDate DESC';
                qList = Database.query(soqlQuery);  
                system.debug('quote list++++++++'+qList.size());            
                                                 
                    if (qList.size() > 0) {
                         for(quote__c qMap:qList){
                                //concatination of mobile and email to form Key          
                                String emailMobile= qMap.Mobile_Number__c+qMap.Email_ID__c;   
                                system.debug('SOQL++++++++'+qMap);   
                                //Map the Key and value with DOB and Email, Mobile
                                emailMobileDOBMap.put(qMap.Mobile_Number__c+qMap.Email_ID__c,qMap.Date_of_Birth__c);
                                  system.debug('Checking map '+emailMobileDOBMap);        
                                         if(emailMobileDOBMap.containsKey(emailMobile) && emailMobileDOBMap.get(emailMobile) == dateOfBirth){
                                              DupRes.quoteStatus = qMap.Quote_Stage__c;
                                              DupRes.responseDescription = GEN_OriginationsConstants.SOFT_QUOTE_DUPLICATE_MSG_SUCCESS;
                                              system.debug('Checking inside loop1'+emailMobileDOBMap.containsKey(emailMobile)); 
                                              return DupRes;
                                              
                                          }  
                                          else if(emailMobileDOBMap.get(emailMobile) != dateOfBirth){
                                           system.debug('Checking inside loop2'+emailMobileDOBMap.containsKey(emailMobile)); 
                                           
                                            DupRes.responseDescription =GEN_OriginationsConstants.SOFT_QUOTE_DUPLICATE_MSG_NOT_FOUND;
                                             
                                          }         
                       }
                    }                                       
                    else{
                         DupRes.responseDescription =GEN_OriginationsConstants.SOFT_QUOTE_DUPLICATE_MSG_NOT_FOUND;
                    }  
                   
               }
                catch(Exception e){
                 DupRes.responseDescription =GEN_OriginationsConstants.SOFT_QUOTE_SERVICE_ERROR;
               }
                         
           
         }
      
      
      }  
      else{
          DupRes.responseDescription =GEN_OriginationsConstants.SOFT_QUOTE_SERVICE_ERROR;
      }  
    
     return DupRes; 
             
    }

    Public class DuplicateQuoteWrapper{
        public String emailAddress;
        public String mobileNumber;
        public String dateOfBirth;
        public String brokerID;
        
         public DuplicateQuoteWrapper parse(String json){
            return (DuplicateQuoteWrapper) System.JSON.deserialize(json, DuplicateQuoteWrapper.class);
        }
        
     }
     
      Global class DuplicateResponse{
        public String quoteStatus;
        public String responseDescription;
       
        public DuplicateResponse(){}
        
        
     }
     
       
  
}