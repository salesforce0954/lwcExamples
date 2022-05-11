@RestResource(urlMapping='/api/quoteResponse/*')
global without sharing class WS_SoftQuoteResponse{

    @HttpPost
    global static quoteResponseWrapper checkQuoteStatus() {
    
     boolean softQuoteCheck= SoftQuoteUtil.checkSoftQuoteOrgEnabled();
     quoteResponseWrapper qRes = new quoteResponseWrapper();
      if(softQuoteCheck){
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        
       
        //Read the parameters   
        quoteWrapper rw = (quoteWrapper)JSON.deserialize(requestString,quoteWrapper.class);
        String qId=rw.quoteId;
        
        List<quote__c> qList = new List<quote__c>();
        
        if(qId <> ''){
          try{  
            for(quote__c q:[SELECT Id,Name,First_Name__c,Quote_Stage__c,Quote_Secured_Rate__c,
                        Quote_Rate__c,Response_Code__c, Loan_Amount__c, Loan_Term__c,
                        Loan_Purpose__c, Other_Loan_Purpose__c, Sub_Type__c
                            FROM quote__c 
                            WHERE 
                           ID =: qId]){
                           
               if (q.Response_Code__c <> null){
                    qRes.quoteNumber=q.Name;
                    qRes.quoteRate=q.Quote_Rate__c;
                    qRes.quoteSecuredRate=q.Quote_Secured_Rate__c;
                    qRes.quoteStatus=q.Quote_Stage__c;
                    qRes.firstName=q.First_Name__c;
                    qRes.loanAmount = q.Loan_Amount__c;
                    qRes.loanTerm = q.Loan_Term__c;
                    qRes.loanPurpose = q.Loan_Purpose__c;
                    qRes.otherLoanPurpose = q.Other_Loan_Purpose__c;
                    qRes.encryptedQuoteID = EncryptionManager.encryptQuoteId(q.Id);
                    qRes.subType = q.Sub_Type__c;
                 }
                 else{
                        
                    qRes.quoteNumber=q.Name;
                    qRes.quoteStatus=q.Quote_Stage__c;
                    qRes.encryptedQuoteID = EncryptionManager.encryptQuoteId(q.Id);
                    qRes.firstName=q.First_Name__c;
                    qRes.loanAmount = q.Loan_Amount__c;
                    qRes.loanTerm = q.Loan_Term__c;
                    qRes.loanPurpose = q.Loan_Purpose__c;
                    qRes.otherLoanPurpose = q.Other_Loan_Purpose__c;
                     
                 }
              }
              
            }
            catch(Exception e){
                 qRes.operationStatus= GEN_OriginationsConstants.Soft_Quote_Service_Error;
               
               }     
        
        }
        else{
          
            qRes.operationStatus=GEN_OriginationsConstants.Soft_Quote_ID_Invalid;
                    
        }
        
        }
        else{
        
            qRes.operationStatus=GEN_OriginationsConstants.Soft_Quote_Service_Error ;
        } 
        return qRes;
        
        }

        Public class quoteWrapper{
            public String quoteID;
                   
             public quoteWrapper parse(String json){
                return (quoteWrapper) System.JSON.deserialize(json, quoteWrapper.class);
            }
            
         }
       global class quoteResponseWrapper{
            public String quoteNumber;
            public Decimal quoteRate;
            //Added Secured Interest rate 
            public Decimal quoteSecuredRate;
            public Decimal loanAmount;
            public String loanTerm;
            public String quoteStatus;
            public String firstName;
            public String operationStatus;       
            public String encryptedQuoteID;
            public String loanPurpose;
            public String otherLoanPurpose;
           public String subType;
             public quoteResponseWrapper(){}
            }
            
  }