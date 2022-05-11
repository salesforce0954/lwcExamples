/*
 * @Description: Controller for the New Staff UI Wizard
 * @Author: Tony Xu 
 * @Date Created: 2015-11-04
 * @History:
   =====================================================================
       2015-11-04   Created - TXU
   =====================================================================
 */ 

global with sharing class APP_Wizard_Ext {
   
    public string IPAddress {get;set;}
    public Quote__c currentQuote {get;set;}
    public Boolean   isSoftQuoteApplication {get;set;}
    public String sqDate {get;set;}
    public String sqMonth {get;set;}
    public String sqYear {get;set;}
    public String sqExpDate {get;set;}
    public String sqExpMonth {get;set;}
    public String sqExpYear {get;set;}
    public String quoteId {get;set;}
    public Boolean preAddressEnable {get;set;}
    
    public APP_Wizard_Ext(){
        getIPAddress();
        //Added as part of Soft Quote 2020 changes
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('qid');
        isSoftQuoteApplication = false;
        System.debug('QID FOR STAFF: '+currentRecordId);
        System.debug('isSoftQuoteApplication: '+isSoftQuoteApplication);
        if(currentRecordId != null){
           
               currentQuote = [SELECT Id, Name, Quote_Privacy_Consent__c, Loan_Amount__c, Loan_Purpose__c, Sub_Type__c,
                                         Loan_Term__c,First_name__c,Last_Name__c,Middle_Name__c,Mobile_Number__c,Date_of_Birth__c,
                                         Months_at_Residential_Address__c,Years_at_Residential_Address__c,Gender__c,Drivers_Lic_Flag__c,
                                         Driver_s_Licence_Number__c,Driver_s_License_Issue_Date__c,Driver_s_License_Expiry_Date__c,
                                         Driver_s_License_Version__c,Title__c,Residential_Unit_Number__c,Residential_Suburb__c,Region__c,
                                         Residential_Street_Type__c,Residential_Street_Number__c,Residential_Street_Name__c,Residential_Status__c,
                                         Email_ID__c,Residential_State__c,Residential_Postcode__c,Residential_Country__c,Residential_City__c,
                                         Previous_City__c,Previous_Country__c,Previous_Postcode__c,Previous_State__c,Previous_Street_Name__c,
                                         Previous_Street_Number__c,Previous_Suburb__c,Previous_Unit_Number__c,Previous_Street_Type__c,Previous_Property_Name__c,
                                         Previous_ResStreet_type_abbreviated_code__c,Residential_Street_type_abbreviated_code__c,Property_Name__c,
                                         Brokerage_Fee__c,Occupation__c,Years_at_Current_Employment__c,Months_at_Current_Employment__c,
                                         Income_Source__c,Product__c,Broker_ID__c,Channel__c,UID__c,Other_Loan_Purpose__c
                                         FROM 
                                         Quote__c 
                                         WHERE Id= :currentRecordId];
               isSoftQuoteApplication = true;
               quoteId = currentQuote.Id;
               System.debug('ON LOAD SET QID: '+quoteId);

               String sqDOB= currentQuote.Date_of_Birth__c;
               if(sqDOB !=null && sqDOB !=''){
                   sqDOB = sqDOB.replaceAll('/', '');
                   sqDate = sqDOB.subString(0,2);
                   sqMonth = sqDOB.subString(2,4);
                   sqYear = sqDOB.subString(4,8);
               }
               String expDate= currentQuote.Driver_s_License_Expiry_Date__c;
               if(expDate !=null && expDate !=''){
                   expDate = expDate.replaceAll('/', '');
                   sqExpDate = expDate.subString(0,2);
                   sqExpMonth = expDate.subString(2,4);
                   sqExpYear = expDate.subString(4,8);
               }
               if(currentQuote.Years_at_Residential_Address__c <3 && currentQuote.Months_at_Residential_Address__c <12){
                   preAddressEnable =true;
               }
                                      
        
        
        } 
        System.debug('isSoftQuoteApplication 2: '+isSoftQuoteApplication);
    }    
    
     /*  Description: Get User's IP Address
     *  Author: Mike Lasala
     *  Date Created: 2015-11-04
     *  Input Parameters: None
     *  Return: String
     */ 
    public pageReference getIPAddress(){
        system.debug('CALLED');
    
       //  ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        system.debug(ApexPages.currentPage().getParameters());
       
        IPAddress = ApexPages.currentPage().getParameters().get('HTTP_CLIENT_IP');
             
        if (IPAddress == '' || IPAddress == null) {
            // get IP address when no caching (sandbox, dev, secure urls)
            IPAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        
        system.debug(IPAddress);
        return null;
    }  
    
    /*  Description: Submit the application to integration layer
     *  Author: Tony Xu
     *  Date Created: 2015-11-05
     *  Input Parameters: None
     *  Return: String
     */
    @RemoteAction
    global static List<IS_ValidationError> submitApplicaton(String applicationID){
        
        
        
        string requestedName = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c;
        List<IS_ValidationError> validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(applicationID,Util.getUser().Mock_Enable__c, requestedName, null);
        return validationErrors;
    }
    
    
    /*  Description: Create streaming api channel for monitoring application response
     *  Author: Tony Xu
     *  Date Created: 2015-11-06
     *  Input Parameters: None
     *  Return: None
     */
    @RemoteAction
    global static void addApplicationResponseTopic(){
        //Check if the push topic already exist, if we try to recreate a existing push topic with the same name it will error
        List<PushTopic> ptList = [Select Id, Name From PushTopic Where Name = 'ApplicationResponseInsert'];
        if(ptList.size() == 0){
            PushTopic appResponseTopic = new PushTopic();
            appResponseTopic.Name = 'ApplicationResponseInsert';
            appResponseTopic.Query = 'Select Id, Application__c from Application_Response__c';
            appResponseTopic.ApiVersion = 27.0;
            appResponseTopic.NotifyForFields = 'All';
            appResponseTopic.NotifyForOperationCreate = true;
            appResponseTopic.NotifyForOperationUpdate = false;
            insert appResponseTopic;
        }
    }
    
    /*  Description: Link softquotes to the application
     *  Author: Madhusudhan Seethala
     *  Date Created: 2020-08-09
     *  Input Parameters: Application ID, Quote ID
     *  Return: none
     */
    @RemoteAction
    global static void linkQuoteToApplicaton(String applicationID,String quoteId){
       
       if(applicationID <> null && quoteId <> null){
         if(SoftQuoteUtil.checkIfSoftQuoteEnabled(applicationId)){
            List<Quote__c> quoteList = new List<Quote__c>();
            quoteList = [SELECT Id,Application__c,Quote_Stage__c
                        FROM Quote__c
                        WHERE Id=: quoteId];
           System.debug('QUOTE LIST: '+quoteList);
            if(quoteList.size() == 1 ){    
                Quote__c quoteObj = new Quote__c();
                quoteObj.Id = quoteList[0].Id;
                quoteObj.Application__c = applicationId;
                quoteObj.Quote_Stage__c = 'Converted to Application';                
                update quoteObj;
            }
            
        }
      }
    }
    
    
}