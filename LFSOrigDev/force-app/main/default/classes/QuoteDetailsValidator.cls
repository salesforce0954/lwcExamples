/**
 * Name:  QuoteDetailsValidator
 * Description: This class is used to validate the quote details as received against
 *              some of the business rules. This is applicable for both quote 
 *              create and update.
 * Date: 17-MAR-2020
 */
public without sharing class QuoteDetailsValidator {

    //Constructor 
    public QuoteDetailsValidator() {}
    
    
    //Method to be invoked by the Master Trigger
    public void runCustomValidations(List<Quote__c> quoteList){
            Boolean isValidationSuccessful = false;
            for(Quote__c quoteObj : quoteList){
                //1. Validate the Broker Details mentioned on the quote
                if(quoteObj.Channel__c == 'Broker' && quoteObj.Region__c == 'AU' && quoteObj.Broker_ID__c != null){
                    //Get the Broker Record Type Id
                    
                    List<Contact> brokerList = [SELECT Id
                                                FROM Contact
                                                WHERE Broker_ID__c =: quoteObj.Broker_ID__c AND 
                                                    RecordTypeId IN (SELECT Id 
                                                                        FROM RecordType
                                                                        WHERE DeveloperName = 'APAC_Contact' AND
                                                                            sObjectType = 'Contact')];
                    if(brokerList.size() <> 1){
                        quoteObj.addError('Broker ID provided is not valid.');
                    }
                } 
                
                //Validate Date of Birth Format
            if(quoteObj.Date_of_Birth__c != null){
                        try{
                            //Parsing the date will get the date into the current Local format i.e. DD/MM/YYYY
                            //If the date is not in that format, an exception is thrown
                            Date dateOfBirth = Date.parse(quoteObj.Date_of_Birth__c);
                        
                        }catch(Exception e){
                            quoteObj.addError('Date of Birth should be in DD/MM/YYYY format.');
                        }
                }
                //Validate Driver's License Issue & Expiry Date Formats for NZ
                if(quoteObj.Region__c == 'NZ' && quoteObj.Driver_s_Licence_Number__c != null && quoteObj.Driver_s_License_Expiry_Date__c != null){
                    try{
                        //Parsing the date will get the date into the current Local format i.e. DD-MM-YYYY
                        //If the date is not in that format, an exception is thrown
                        Date dlExpiryDate = Date.parse(quoteObj.Driver_s_License_Expiry_Date__c);
                    }catch(Exception e){
                        quoteObj.addError('Expiry Date related to Drivers License should be in DD/MM/YYYY format.');
                    }
                }
            }
    }
    public void checkCreditScore(List<Quote__c> quoteValues){
        List<Quote__c> qList = new List<Quote__c>();
        
        for(Quote__c qt: quoteValues){
            if(qt.Credit_Score__c !=null || qt.Credit_Score__c !='' ){
                qList.add(qt);
            }
        }
        
        if(!qList.isEmpty()){
            QuoteRUL_Engine.runPricingEngine(qList);
            //Add Comparision Rate Calculation here
            for(Quote__c quoteObj : qList){
                System.debug('QOBJ AFTER RUL ENGINE: '+quoteObj);
                if(quoteObj.Response_Code__c == 'QIR'){
                    QuoteMonthlyRepaymentCalculator.getMonthlyRepayment(quoteObj);
                    ComparisionRateCalculator.getRate(quoteObj);
                }
            }
            
        
        }
        
    
    }
    // Create Quote Product line Items,  once the Quote record is created
    public void createQuoteProductLineItems(List<Quote__c> qList){
     List<Quote_Product_Item__c> qProdList = new List<Quote_Product_Item__c>();
     List<Product_Version__c> latitudeProdVersion = new List<Product_Version__c>();
     List<Product_Version__c> gemProdVersion = new List<Product_Version__c>();
     List<Product_Version__c> kiwiProdVersion = new List<Product_Version__c>();
     Quote_Product_Item__c  pItem = new Quote_Product_Item__c ();
        
       // Get the Product versions for the Personal loan prodcuts and prepare Map
      Map<String,Id> quotePvMap = new Map<String,Id>();
        for (Product_Version__c pv:[Select Id,Name, End_Date__c,Product_name__c, GEProduct__c,Type__c, Start_Date__c 
                                    from Product_Version__c 
                                    where 
                                    Type__c='Personal Loan'] ){
                 quotePvMap.put(pv.Product_name__c,pv.Id);                   
        
        }        
        for(Quote__c qObj : qList){
        
               if(qObj.Id <> null && quotePvMap.containsKey(qObj.Product__c)){
                       pItem = new Quote_Product_Item__c(Quote__c= qObj.Id, Product_Version__c = quotePvMap.get(qObj.Product__c));
                       qProdList.add(pItem);
                } 
               
            }
            if(qProdList.size() > 0){
                insert qProdList;
            }
    
    
    }
    
    // Inovke the Quote Submit calls 
    public void invokeQuoteSubmit(List<Quote__c> qList){
        
        if(qList.size() >0){
          for(Quote__c qObj : qList){
           IS_QuoteSubmitUpdate.quoteInputRequest(qObj.Id, qObj.Channel__c);
          } 
        }
     } 
    
     /**
      * Name: invokeRateUpdate
      * Description: Invoke the DP service to update the interest rate calculated in Salesforce.
      */
    public void invokeRateUpdate(List<Quote__c> qList){
        
        if(qList.size() >0){
            for(Quote__c qObj : qList){
                IS_QuoteSubmitPartialUpdate.quoteInputRequest(qObj.Id, qObj.Channel__c);
            } 
        } 
    } 
}