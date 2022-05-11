public without sharing class ApplicationFormController {
    
    @AuraEnabled
    public static Quote__c getQuoteDetails(String quoteId){
        Quote__c quoteObj = new Quote__c();
        if(String.isNotBlank(quoteId)){                    
            BrokerDetailsWrapper brokerWrapper = BrokerSubmittedEntities.getBrokerId();
                    
                    
                     quoteObj = [SELECT Loan_Amount__c,Loan_Purpose__c,Loan_Term__c,Title__c,First_Name__c,Middle_Name__c,Last_Name__c,Gender__c,
                                        Date_of_Birth__c,Email_ID__c,Mobile_Number__c,Driver_s_Licence_Number__c,Property_Name__c,Residential_Unit_Number__c,
                                        Residential_Street_Number__c,Residential_Street_Name__c,Residential_Street_Type__c,Residential_Street_type_abbreviated_code__c,Residential_Suburb__c,
                                        Residential_State__c,Residential_Postcode__c,Residential_Country__c,Years_at_Residential_Address__c,Months_at_Residential_Address__c,
                                        Previous_Property_Name__c,Previous_Unit_Number__c,Previous_Street_Number__c,Previous_Street_Name__c,Previous_Street_Type__c,Previous_ResStreet_type_abbreviated_code__c,
                                        Previous_Suburb__c,Previous_City__c,Previous_State__c,Previous_Postcode__c,Previous_Country__c,Income_Source__c,Occupation__c,
                                        Years_at_Current_Employment__c,Months_at_Current_Employment__c,Residential_Status__c,Broker_ID__c,
                                        Brokerage_Fee__c,Quote_Stage__c,UID__c,Id,Name,Other_Loan_Purpose__c,Sub_Type__c 
                                 FROM   Quote__c
                                WHERE   id= :quoteId];
                    //The below check ensures that the quote id received in the request is actually by the logged in Broker 
                    // and not by some other party. If valid, return details else null     
                                          
                        if(quoteObj.Broker_ID__c != brokerWrapper.brokerId){
                            quoteObj = null;
                        }
                    
        }
        return quoteObj;
    }

    @AuraEnabled(cacheable=true)
    public static Better_Start_Offer__c getBetterStartOfferConfig() {
        return [SELECT ID, BetterStartAUActive__c FROM Better_Start_Offer__c LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static Brand__c getLatitudeBrandRecord() {
        return [SELECT ID, Loan_Term__c, Loan_Term_Better_Start__c FROM Brand__c WHERE Name='Latitude' LIMIT 1];
    }    
}