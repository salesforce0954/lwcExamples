/*
Author: Madhusudhan Seethala
Created Date: May 29 2020
Description: Engine to run the offer rules based on Quote Object
*/
public without sharing class QuoteRUL_Engine {

       
    private static List<Quote__c> getAllQuotes(List<ID> quoteIDList) {
        
        String query = buildQueryString('Quote__c', true, quoteIDList);     

        System.debug('## query=['+query+']');

        List<Quote__c> quoteList = new List<Quote__c>();
        try {
            quoteList = database.query(query);
        } catch (QueryException e){
            System.debug('## Unable to query Quote__c - query=['+query+']');
            throw new RUL_ErrorDataException('Unable to query Quote__c - query=['+query+']');
        }

        return quoteList;
    }

    private static String buildQueryString(String objectName, Boolean isOffers, List<Id> objectIdList){
        //Build query string
        String query = 'SELECT';
        //Get Application fields
        Map<String, Schema.SObjectField> appFields = Schema.getGlobalDescribe().get('Quote__c').getDescribe().fields.getMap();
       
        for(String s : appFields.keySet()){
            //Add Application relationship if call is from Offers
            query += ' ' + s + ',';
        }
        // Strip off the last comma if it exists.
        if(query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        //Append object name
        query += ' FROM '+objectName;
        //Append query filter
        query += ' WHERE Id IN (';
        for(String s : objectIdList) {
            query += '\'' + s + '\',';
        }
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        //Close query filter
        query += ')';
        System.debug('$$$ query: ['+query+']');
        return query;
    }
    
  public static Map<ID, Product_Version__c> getProductVersionsFromQuote(List<SObject> objectList){
        Map<ID, Product_Version__c> prodVerToQuote = new Map<ID, Product_Version__c>();
      
        //get all the quote Ids
        List<ID> quoteIdList = new List<ID>();
        Boolean isAppResponse = false;
        if(!objectList.isEmpty()){
            for(SObject o : objectList){
                    Quote__c a = (Quote__c)o;
                    quoteIdList.add(a.Id);
                }
            }
            System.debug('quoteIdList in RUL: '+quoteIdList);
            System.debug('Current User: '+UserInfo.getUserId());
            System.debug('Current User Profile: '+UserInfo.getProfileId());
            System.debug('Quote__c field: '+Schema.sObjectType.Quote_Product_Item__c.fields.Quote__c.isAccessible());
            System.debug('Product_Version__c field: '+Schema.sObjectType.Quote_Product_Item__c.fields.Product_Version__c.isAccessible());
            System.debug('Product_Version__r.name field: '+Schema.sObjectType.Product_Version__c.fields.Name.isAccessible());
            System.debug('Product_Version__r.Type__c field: '+Schema.sObjectType.Product_Version__c.fields.Type__c.isAccessible());
            
            
        //find all the product versions via the product item
        List<Quote_Product_Item__c> prodItemList = [SELECT  id,
                                                            Quote__c,
                                                            Product_Version__c,
                                                            Product_Version__r.name
                                                    FROM    Quote_Product_Item__c
                                                    WHERE   Quote__c IN: quoteIdList
                                                    AND    Product_Version__r.Type__c = 'Personal Loan'];
        
        if(prodItemList==null || prodItemList.size()==0) {
            System.debug('## No Persoanl Loan Product Versions found.');
            throw new RUL_ErrorDataException('No Persoanl Loan Product Versions found.');
        }

        for(Quote_Product_Item__c pi : prodItemList) {
            if(!objectList.isEmpty()){
                    prodVerToQuote.put(pi.Quote__c, pi.Product_Version__r);
                }
        }
      return prodVerToQuote;
    }
    
    public static Map<ID, List<Rule_Set__c>> getRuleSetsFromProductVersionMap(List<Product_Version__c> prodVersionList, String ruleSetType) {
        Map<ID, List<Rule_Set__c>> ruleSetListByProdVersion = new Map<ID, List<Rule_Set__c>>();
        
        List<Rule_Set__c> ruleSetList = [ SELECT  id,
                                                    Product_Version__c,
                                                    (SELECT id FROM Rules__r ORDER BY order__c ASC)
                                            FROM    Rule_Set__c
                                            WHERE   Product_Version__c IN: prodVersionList 
                                            AND     Type__c =: ruleSetType];
                                           
        for(Rule_Set__c ruleSet : ruleSetList) {
            List<Rule_Set__c> rsList = ruleSetListByProdVersion.get(ruleSet.Product_Version__c);
            if(rsList==null) {
                rsList = new List<Rule_Set__c>();
                ruleSetListByProdVersion.put(ruleSet.Product_Version__c, rsList);
            }
            rsList.add(ruleSet);
        }

        if(ruleSetListByProdVersion==null || ruleSetListByProdVersion.size() == 0) {
            System.debug('## No RuleSets Found - This could be ok.');
        }

        return ruleSetListByProdVersion;
    }
    
     public static void runPricingEngineAsync(List<Id> quoteIdList){
        try {
            
            
            //Query quote records
           List<Quote__c> quoteList = getAllQuotes(quoteIdList);
            
            //Run pricing engine to get interest rate
            quoteList = runPricingEngine(quoteList);
            
            //Update application (BAU)
            if(quoteList.size() > 0){
                update(quoteList);
            }
            //END MLASALA 03-JUN-16
        }
        catch(Exception e) {
            ErrorHandlerException.recordException(e.getMessage() + ': ' + e.getStackTraceString(), 'runPricingEngineAsync', 'Rules', 'QuoteRUL_Engine', null); 
        }
    }
    
     public static List<Quote__c> runPricingEngine(List<Quote__c> qList){
        //Checks if parameter has values
        if(qList == null || qList.isEmpty()){
            System.debug('$$$ No Quotes have been passed in.');
            throw new RUL_ErrorDataException('No Quotes have been passed in.');
        }
        // 1. Get all the quotes 
      
        //2. Get Personal Loan Product Version related to Quote
        Map<ID, Product_Version__c> prodVerToQuote = getProductVersionsFromQuote(qList);
        //3. Get Rule Sets by Product Version
        Map<ID, List<Rule_Set__c>> ruleSetListByProdVersion = getRuleSetsFromProductVersionMap(prodVerToQuote.values(), 'Pricing');

        system.debug('Rule set values:' + ruleSetListByProdVersion);

        //4. Get Rules & Conditions for each Rule Set 
        List<Rule_Set__c> allRuleSets = new List<Rule_Set__c>();
        for(List<Rule_Set__c> rsList : ruleSetListByProdVersion.values()) {
            allRuleSets.addAll(rsList);
        }
        Map<ID, List<Rule__c>> rulesByRuleSet = RUL_Engine.getRulesFromRuleSet(allRuleSets);
        //5. Iterate through each Rule Set and run engine
        List<Quote__c> quoteToUpdate = new List<Quote__c>();
        //To be used for getting interest rate from map's key
        Map<Id, Quote__c> rateCardMap = new Map<Id, Quote__c>();
        // To retrieve the Secured Rate card
        Map<Id, Quote__c> rateCardSecuredMap = new Map<Id, Quote__c>();
        
        for(Quote__c qObj:qList){   
                Product_Version__c prodVersion = prodVerToQuote.get(qObj.id);
                List<Rule_Set__c> ruleSetList = ruleSetListByProdVersion.get(prodVersion.id);
                if(prodVersion==null) {
                    continue;
                 }
                 
                    system.debug('Pricing Rule Set:' + ruleSetList);

                      for(Rule_Set__c ruleSet : ruleSetList) {
                        
                        List<Rule__c> ruleList = rulesByRuleSet.get(ruleSet.id);

                            system.debug('Pricing Rules:' + ruleList);
                            if(ruleList==null || ruleList.size()==0) {
                                 //skip blank ruleset
                                continue;
                            }// End If
            
                          rateCardMap= createRateCardQuote(qObj.Channel__c,qObj,ruleList);
                          rateCardSecuredMap= createRateSecuredCardQuote(qObj.Channel__c,qObj,ruleList);
                           System.debug('quoteId in unsecured map: '+rateCardMap);
                           System.debug('quoteId in secured map: '+rateCardSecuredMap);
                       }   
         }
         


        if(!rateCardMap.keySet().isEmpty()){
            quoteToUpdate.addAll(getInterestRate(rateCardMap, GEN_OriginationsConstants.QUOTE_UNSECURED));
            quoteToUpdate.addAll(getInterestRate(rateCardSecuredMap, GEN_OriginationsConstants.QUOTE_SECURED));
            System.debug('$$$ applicationsToUpdate: '+quoteToUpdate.size());
        }
      return quoteToUpdate;
      
    }
    
    // Get the Secured ratecards
    public static Map<Id,Quote__c> createRateSecuredCardQuote(String channel, sObject record, List<Rule__c> ruleSets){
        Map<Id,Quote__c> ratecardSecuredQuoteMap = new Map<Id,Quote__c>();
        
        
        for (Rule__c rule:ruleSets){
            if(channel == GEN_OriginationsConstants.QUOTE_CHANNEL_BROKER && rule.Name== GEN_OriginationsConstants.QUOTE_BROKER_SECURED_RATE) {
                ratecardSecuredQuoteMap.put(rule.Rate_Card__c,(Quote__c)record);                
            }
            else if(channel != GEN_OriginationsConstants.QUOTE_CHANNEL_BROKER && rule.Name== GEN_OriginationsConstants.QUOTE_SALES_SECURED_RATE){
                 ratecardSecuredQuoteMap.put(rule.Rate_Card__c,(Quote__c)record);
            }
            
            
        }      
    
    return ratecardSecuredQuoteMap;    
    }
    
// Get the Unsecured/secured ratecards
   public static Map<Id,Quote__c> createRateCardQuote(String channel, sObject record, List<Rule__c> ruleSets){
        Map<Id,Quote__c> ratecardQuoteMap = new Map<Id,Quote__c>();
        
        
        for (Rule__c rule:ruleSets){
            if(channel == GEN_OriginationsConstants.QUOTE_CHANNEL_BROKER && rule.Name== GEN_OriginationsConstants.QUOTE_BROKER_UNSECURED_RATE) {
                ratecardQuoteMap.put(rule.Rate_Card__c,(Quote__c)record);               
            }
            else if(channel != GEN_OriginationsConstants.QUOTE_CHANNEL_BROKER && rule.Name== GEN_OriginationsConstants.QUOTE_SALES_UNSECURED_RATE){
                 ratecardQuoteMap.put(rule.Rate_Card__c,(Quote__c)record);
            }
            System.debug('quoteId in secured map: '+ratecardQuoteMap);
        }      
    
    return ratecardQuoteMap;    
    }
    
    public static List<Quote__c> getInterestRate(Map<Id, Quote__c> rateCardQuoteMap, String rateCardCheck){

        List<Quote__c> quoteList = new List<Quote__c>();
        //Retrieve Rates based on map's keyset
        if(!rateCardQuoteMap.keySet().isEmpty()){
            Map<Id,Rate_Card__c> rateMap = new Map<Id,Rate_Card__c>([Select Id, 
                                                            (SELECT Credit_Score__c, 
                                                                    Rate__c, 
                                                                    Principal_Minimum__c, 
                                                                    Principal_Maximum__c, 
                                                                    Rate_Card__r.Start_Date__c, 
                                                                    Rate_Card__r.End_Date__c, 
                                                                    Rate_Card__r.Channel__c 
                                                                    from Rates__r) 
                                                          from Rate_Card__c 
                                                          where Id IN: rateCardQuoteMap.keySet()]);

            System.debug('$$$ rateCardQuoteMap.keySet(): '+rateCardQuoteMap.keySet());
                String quoteId = '';

                List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();

                for(Id i: rateCardQuoteMap.keySet()){

                    Quote__c rateQuote = rateCardQuoteMap.get(i);
                    Quote__c origQuote;
                    Decimal totalLoanAmount = rateQuote.Loan_Amount__c != null ? rateQuote.Loan_Amount__c : 0;
                    
                   
                    Decimal capacity = 0;
                    Decimal oldRefinanceIntR;
                    Decimal oldRefinanceRefAmount;
                    
                    capacity = totalLoanAmount;
                    
                    system.debug('$$$ Capacity: ' + capacity);
                    system.debug('$$$ Country: ' + rateQuote.Region__c);
                    system.debug('$$$ totalLoanAmount:' + totalLoanAmount);                   
                    system.debug('$$$ Channel:' + rateQuote.Channel__c);                    
                                    
                        List<Rate__c> rateList = new List<Rate__c>();
                        System.debug('$$$ rateList: '+rateList.size());

                        // Pull rate list for application
                        Rate_Card__c rcVar = rateMap.get(i);
                        if(rcVar!=null){
                            rateList = rcVar.Rates__r;
                        }

                        for(Rate__c r: rateList){
                            system.debug('$$$ Principal_Minimum__c: ' + r.Principal_Minimum__c);
                            system.debug('$$$ Principal_Maximum__c: ' + r.Principal_Maximum__c);
                            system.debug('$$$ rate Creditscore' + r.Credit_Score__c);
                            system.debug('$$$ Quote ratecard: ' + rateQuote.Credit_Score__c);
                            system.debug('$$$ capacity : ' + capacity);
                            system.debug('$$$ emptycheck: ' + quoteId );
                            system.debug('$$$ rate card enddate: ' + r.Rate_Card__r.End_Date__c);
                            system.debug('$$$ ratecard startdate: ' +  r.Rate_Card__r.Start_Date__c);
                            system.debug('$$$ quote modified date: ' + rateQuote.LastModifiedDate );
                            //Isolate rate card which satisfies all the quote's crtieria
                            if(r.Credit_Score__c == rateQuote.Credit_Score__c && 
                               r.Principal_Minimum__c <= capacity && 
                               r.Principal_Maximum__c >= capacity && 
                               r.Rate_Card__r.Start_Date__c <= rateQuote.LastModifiedDate &&
                               r.Rate_Card__r.End_Date__c >= rateQuote.LastModifiedDate &&
                               quoteId != String.valueOf(rateQuote.Id)){
    
                                        system.debug('$$$ Qualified Rate:' + r);
                                       //Added the Secured/Unsecured Rate check to update the respective fields.
                                       if(rateCardCheck == GEN_OriginationsConstants.QUOTE_UNSECURED){
                                            rateQuote.Quote_Rate__c = r.Rate__c;
                                       }else if(rateCardCheck == GEN_OriginationsConstants.QUOTE_SECURED){
                                            rateQuote.Quote_Secured_Rate__c = r.Rate__c;
                                       }
                                      
                                        
                                    }
                               
                           }
                       quoteList.add(rateQuote);
                       quoteId = rateQuote.Id;
                       
                      }// End for
                      
                      if(!debugLogList.isEmpty()){
                    try{
                        insert debugLogList;
                    } catch(DMLException e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'QuoteRUL_Engine__c', 'Debug_Log__c', 'Class');
                    }
                }
                            
                 }// End If
                  
                  
                 
           return quoteList; 
        }
               
}