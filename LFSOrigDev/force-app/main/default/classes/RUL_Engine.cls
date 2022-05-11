/*
Author: Andrew Manetakis Cloud Sherpas
Created Date: Oct 30, 2013
Description: Engine to run the offer rules based on an Application Response
History:
   =====================================================================
       13-08-15: Updated PMIHM 1858 - Update the processRules method to do rate assignments before skip rules - DYU
       09-SEPT-15: WEEKLY CONTRACT PAYMENT ISSUE - MLASALA
       18-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
       16-SEPT-15: CPV3 Blended Rate calculation updates for 60 day cert AU - ARECIO
                   CPV3 Fix rate campaigns for NZ special promotion applications. - ARECIO
                   CPV3 Promo rate for NZ applications - ARECIO
*/
public with sharing class RUL_Engine {

    //@future       MLASALA: 17-SEPT-15 - COMMENTED OUT TO MOVE FROM ASYNC TO SYNC CALLS
    public static void runOfferEngineAsync(List<id> appResIdList) {
        try {
            runOfferEngine(appResIdList);
        }
        catch(Exception e) {
            ErrorHandlerException.recordException(e.getMessage() + ': ' + e.getStackTraceString(), 'runOfferEngineAsync', 'Rules', 'RUL_Engine', null); 
        }
    }

    public static void runOfferEngine(List<id> appResIdList) {
        
        System.debug('## Rules Engine Start ##');

        if(appResIdList==null || appResIdList.size()==0) {
            System.debug('## No IDs have been passed in.');
            throw new RUL_ErrorDataException('No IDs have been passed in.');
        }   

        String ids = '';
        for(ID appResId : appResIdList) {
            ids += appResId + ' ';
        }
        System.debug('## The following App Res Ids passed in = [' + ids + ']');


        //1 Get all the fields for the Application & Application Response
        List<Application_Response__c> appResList = getAllApplicationResponse(appResIdList);
        
        
        //2 find the product version linked to the Application Response of type Personal Loan
        Map<ID, Product_Version__c> prodVerToAppRes = getProductVersionsFromAppRes(appResList);

        //3 Get the rule sets by product version
        Map<ID, List<Rule_Set__c>> ruleSetListByProdVersion = getRuleSetsFromProductVersionMap(prodVerToAppRes.values(), 'Offers');

        //4 Get the rules & conditions for each rule set 
        List<Rule_Set__c> allRuleSets = new List<Rule_Set__c>();
        for(List<Rule_Set__c> rsList : ruleSetListByProdVersion.values()) {
            allRuleSets.addAll(rsList);
        }
        Map<ID, List<Rule__c>> rulesByRuleSet = getRulesFromRuleSet(allRuleSets);

        //5 iterate through each rule set and run engine on them
        List<Offer_Presented__c> offerPresentedToInsert = new List<Offer_Presented__c>();
        List<Application__c> applicationsToUpdate = new List<Application__c>();
        //Mike Lasala: To be used for getting interest rate from map's key
        //Map<Id, Application__c> rateCardMap = new Map<Id, Application__c>();
        for(Application_Response__c appRes : appResList) {
            Product_Version__c prodVersion = prodVerToAppRes.get(appRes.id);
            if(prodVersion==null) {
                continue;
            }
            List<Rule_Set__c> ruleSetList = ruleSetListByProdVersion.get(prodVersion.id);
            for(Rule_Set__c ruleSet : ruleSetList) {
                List<Rule__c> ruleList = rulesByRuleSet.get(ruleSet.id);
                if(ruleList==null || ruleList.size()==0) {
                    //skip blank ruleset
                    continue;
                }
                Map<String, SObject> objectMap = new Map<String, SObject>();
                objectMap.put('Application_Response__c'.toUpperCase(), appRes);
                objectMap.put('Application__c'.toUpperCase(), appRes.application__r);

                //TEMP DELETE THESE LINES AFTER CONDITION FIXED
                objectMap.put('Application Response'.toUpperCase(), appRes);
                objectMap.put('Application'.toUpperCase(), appRes.application__r);
                //END TEMP

                //Fsaliba - commented out we will be using DrAndOpWrapper
                //List <Offer_Presented__c> offersPresentedList = processRules(ruleList, appRes, objectMap, false);
                //offerPresentedToInsert.addAll(offersPresentedList);

                DrAndOpWrapper opList = processRules(ruleList, appRes, objectMap, false);
                offerPresentedToInsert.addAll(oplist.offersPresentedList);

                //Added by Fel Saliba 11/11/2014 - Deal reallocation logic
                //check if it is from application update and application brand is NZ
                if((appRes.application__r.Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_UPDATE 
                  || appRes.application__r.Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_SUBMIT)
                  && appRes.application__r.Brand_Country__c == 'NZ'){
                    System.debug('@@@Brand reallocation invoke');
                    DrAndOpWrapper dr = processRules(ruleList, appRes, objectMap, true);
                    appRes.Application__r.Need_Deal_Reallocation__c = dr.dealReallocate;
                    applicationsToUpdate.add(appRes.Application__r);
                    System.debug('$$$ Need_Deal_Reallocation__c: '+appRes.Application__r.Need_Deal_Reallocation__c+' == '+dr.dealReallocate);
                }
            }
        }

        //TODO: ADD ERROR HANDLING

        insert(offerPresentedToInsert);
        update(applicationsToUpdate);
    }

    public static DrAndOpWrapper processRules(List<Rule__c> ruleList, SObject record, Map<String, SObject> objectMap, Boolean forDealReallocation) {
        
        DrAndOpWrapper drAndOp = new DrAndOpWrapper();
        Boolean dealReallocate = false;
        List<Offer_Presented__c> offersPresentedList = new List<Offer_Presented__c>();
        //Mike Lasala: To be used on runPricingEngine method after all rules are processed
        Map<Id, Application__c> rateCardMap = new Map<Id, Application__c>();

        integer i = 0;
        for(Rule__C rule : ruleList) { 
            i++;
            System.debug('########## RULE No. ['+ i +'] - ' + rule);

            system.debug('Rule Id Val:' + rule.Id);

            boolean conditionPass = false;

            for(integer j = 0; j <  rule.Conditions__r.size(); j++) {
                Condition__c condition = rule.Conditions__r.get(j);
                System.debug('########## RULE No. ['+ i +'], condition no. [' + j + '] - ' + condition);

                if(j>0) {
                    //check previous condition
                    if(condition.Conjunction_to_Previous__c=='AND') {
                        if(conditionPass==false) {
                            //rule fail because all conditions need to be met
                            break;
                        } else {
                            //reset pass variable for current condition processing
                            conditionPass = false;
                        }
                    } else if(condition.Conjunction_to_Previous__c=='OR') {
                        if(conditionPass==true) {
                            //don't need to continue processing -> rule is true already
                            break;
                        }
                    } else {
                        System.debug('## Unsupported or missing conjunction. condition= [' + condition + ']');
                        throw new RUL_ErrorLogicException('Unsupported or missing conjunction. condition= [' + condition + ']');
                    }
                }
                
                //get LHS value
                SObject lhsObject = objectMap.get(condition.LHS_Object_Name__c.toUpperCase());
                if(lhsObject==null) {
                    System.debug('## LHS Object Not Found: ' + condition.LHS_Object_Name__c);
                    throw new RUL_ErrorDataException('LHS Object Not Found: ' + condition.LHS_Object_Name__c + ' for condition: ' + condition);
                }
                Object lhsVal = null;
                try {
                    lhsVal = lhsObject.get(condition.LHS_Field_Name__c.toUpperCase());
                } catch (System.SObjectException ex) {
                    System.debug('## LHS Field Error: ' + ex.getMessage());
                    throw new RUL_ErrorDataException('LHS Field Error: ' + ex.getMessage() + ' for condition: ' + condition);
                }

                //get RHS value
                Object rhsVal = null;
                if(condition.Type__c=='Free Text') {
                    rhsVal = condition.Free_Text__c.toUpperCase();
                } else if (condition.Type__c == 'Field') {
                    SObject rhsObject = objectMap.get(condition.RHS_Object_Name__c.toUpperCase());
                    if(lhsObject==null) {
                        System.debug('## RHS Object Not Found: ' + condition.RHS_Object_Name__c);
                        throw new RUL_ErrorDataException('RHS Object Not Found: ' + condition.RHS_Object_Name__c + ' for condition: ' + condition);
                    }
                    try {
                        rhsVal = rhsObject.get(condition.RHS_Field_Name__c.toUpperCase());
                    } catch (System.SObjectException ex) {
                        System.debug('## RHS Field Error: ' + ex.getMessage());
                        throw new RUL_ErrorDataException('RHS Field Error: ' + ex.getMessage() + ' for condition: ' + condition);
                    }
                }

                //compare it
                System.debug('## Comparison lhsVal=[' + lhsVal + '] rhsVal=[' + rhsVal + ']');
                if(lhsVal==null || rhsVal==null) {
                    //null values will be treated as a condition fail
                    String msg = 'Value Error: Rule=[' + rule.name + '] condition=['+condition.name+ '] lhs=[' + lhsVal + '] rhs=[' + rhsVal + ']';
                    System.debug(msg);
                    conditionPass=false;
                } else {
                    if(condition.Operation__c == '=') {
                        if(String.valueOf(lhsVal).toUpperCase()==String.valueOf(rhsVal).toUpperCase()) {
                            conditionPass = true;
                        }
                    } else if (condition.Operation__c == '!=') {
                        if(String.valueOf(lhsVal).toUpperCase()!=String.valueOf(rhsVal).toUpperCase()) {
                            conditionPass = true;
                        }
                    } else if (condition.Operation__c == '>') { 
                        if(Decimal.valueOf(String.valueOf(lhsVal)) > Decimal.valueOf(String.valueOf(rhsVal))) {
                            conditionPass = true;
                        }
                    } else if (condition.Operation__c == '<') { 
                        if(Decimal.valueOf(String.valueOf(lhsVal)) < Decimal.valueOf(String.valueOf(rhsVal))) {
                            conditionPass = true;
                        }
                    } else if (condition.Operation__c == '>=') { 
                        if(Decimal.valueOf(String.valueOf(lhsVal)) >= Decimal.valueOf(String.valueOf(rhsVal))) {
                            conditionPass = true;
                        }
                    } else if (condition.Operation__c == '<=') { 
                        if(Decimal.valueOf(String.valueOf(lhsVal)) <= Decimal.valueOf(String.valueOf(rhsVal))) {
                            conditionPass = true;
                        }
                    } 
                }

                System.debug('## conditionPass=[' + conditionPass + ']');
            }
            
            if(conditionPass == true && forDealReallocation == false) { 
                Offer_Presented__c offerPresented = new Offer_Presented__c();
                offerPresented.Offer__c = rule.Offer__c;
                offerPresented.Application_Response__c = record.Id;
                offersPresentedList.add(offerPresented);
            }

            if(forDealReallocation == true){
                System.debug('@@@Brand reallocation pass');
                dealReallocate = conditionPass;
                if(dealReallocate && conditionPass){
                    System.debug('$$$ rule '+i+': '+rule.Name);
                    break;
                }
            }

            //Mike Lasala: Put rate card id related to passed Rule and 
            //Application in map to be used in getting the interest rate
            if(conditionPass && rule.Rate_Card__c != null){
                system.debug('Rate assignment fired.');
                system.debug('Rate assignment fired:' + rule.Rate_Card__c);
                rateCardMap.put(rule.Rate_Card__c, (Application__c)record);
            }

            //BEGIN - DYU 12-AUG-2015 PMIHM 1858 - Move code to get the rate card before skipping - Start
            if(rule.stopOtherRulesIfPass__c == true && conditionPass==true && forDealReallocation == false) {
                //stop processing other rules here
                break;
            }
            //END - DYU 12-AUG-2015 PMIHM 1858
        }

        system.debug('Final Rate Card Value:' + rateCardMap);

        //return offersPresentedList;
        drAndOp.offersPresentedList = offersPresentedList;
        drAndOp.dealReallocate = dealReallocate;
        drAndOp.applicationRateCardMap = rateCardMap;
        return drAndOp;
    }

    public static Map<ID, List<Rule__c>> getRulesFromRuleSet(List<Rule_Set__c> ruleSetList) {
        Map<ID, List<Rule__c>> rulesByRuleSet = new Map<ID, List<Rule__c>>();



        List<Rule__C> ruleList = [  SELECT  id,
                                            name,
                                            Rule_Set__c,
                                            stopOtherRulesIfPass__c,
                                            IsActive__c,
                                            Offer__c,
                                            Rate_Card__c,
                                            (   SELECT  id, 
                                                        name,
                                                        Conjunction_to_Previous__c,
                                                        Free_Text__c,
                                                        LHS_Field_Name__c,
                                                        LHS_Object_Name__c,
                                                        Operation__c,
                                                        Order__c,
                                                        RHS_Field_Name__c,
                                                        RHS_Object_Name__c,
                                                        Type__c
                                                FROM    Conditions__r 
                                                ORDER BY order__C ASC
                                            )
                                    FROM    Rule__c
                                    WHERE   Rule_Set__c IN: ruleSetList
                                    AND     IsActive__c =   true
                                    ORDER BY order__c ASC];

        for(Rule__c r : ruleList) {
            List<Rule__c> rList = rulesByRuleSet.get(r.Rule_Set__c);
            if(rList==null) {
                rList = new List<Rule__C>();
                rulesByRuleSet.put(r.Rule_Set__c, rList);
            }
            rList.add(r);
        }                   

        return rulesByRuleSet;
    }

    public static Map<ID, List<Rule_Set__c>> getRuleSetsFromProductVersionMap(List<Product_Version__c> prodVersionList, String ruleSetType) {
        Map<ID, List<Rule_Set__c>> ruleSetListByProdVersion = new Map<ID, List<Rule_Set__c>>();
        
        //Mike Lasala: Commented out
        List<Rule_Set__c> ruleSetList = [   SELECT  id,
                                                    Product_Version__c,
                                                    (SELECT id FROM Rules__r ORDER BY order__c ASC)
                                            FROM    Rule_Set__c
                                            WHERE   Product_Version__c IN: prodVersionList 
                                            AND     Type__c =: ruleSetType];
                                            // *************************************************        
                                            //TODO: ADD START DATE & END DATE COMPARISON HERE!!! 
                                            // *************************************************

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

    //given the list off Application Responses returns a map of Applications to Personal Loan Product Versions.
    public static Map<ID, Product_Version__c> getProductVersionsFromAppRes(List<SObject> objectList){
        Map<ID, Product_Version__c> prodVerToAppRes = new Map<ID, Product_Version__c>();
        Map<ID, ID> appIdtoAppResId = new Map<ID, ID>();

        //get all the application Ids
        List<ID> appIdList = new List<ID>();
        Boolean isAppResponse = false;
        if(!objectList.isEmpty()){
            for(SObject o : objectList){
                Application_Response__c ar = new Application_Response__c();
                //Identify if sObject is Application_Response__c
                if(objectList.getSObjectType() == ar.getSObjectType()){
                    isAppResponse = true;
                    Application_Response__c apre = (Application_Response__c)o;
                    appIdList.add(apre.Application__c);
                    appIdtoAppResId.put(apre.Application__c, apre.id);
                } else {
                    Application__c a = (Application__c)o;
                    appIdList.add(a.Id);
                }
            }
        }

        //find all the product versions via the product item
        List<Product_Item__C> prodItemList = [  SELECT  id,
                                                            Application__c,
                                                            Product_Version__c,
                                                            Product_Version__r.name
                                                    FROM    Product_Item__c
                                                    WHERE   Application__c IN: appIdList
                                                    AND     (Product_Version__r.Type__c =: 'Personal Loan'
                                                    OR       Product_Version__r.Type__c =: 'Auto Loan')
                                                ];
        
        if(prodItemList==null || prodItemList.size()==0) {
            System.debug('## No Persoanl Loan Product Versions found.');
            throw new RUL_ErrorDataException('No Persoanl Loan Product Versions found.');
        }

        for(Product_Item__c pi : prodItemList) {
            if(!objectList.isEmpty()){
                if(isAppResponse){
            prodVerToAppRes.put(appIdtoAppResId.get(pi.application__c), pi.Product_Version__r);
                } else {
                    prodVerToAppRes.put(pi.Application__c, pi.Product_Version__r);
                }
            }
        }

        return prodVerToAppRes;
    }

    private static List<Application_Response__c> getAllApplicationResponse(List<ID> appResIDList) {
        
        String query = buildQueryString('Application_Response__c', true, appResIDList);     

        System.debug('## query=['+query+']');

        List<Application_Response__c> appResList = new List<Application_Response__c>();
        try {
            appResList = database.query(query);
        } catch (QueryException e){
            System.debug('## Unable to query Application_Response__c & Application__c - query=['+query+']');
            throw new RUL_ErrorDataException('Unable to query Application_Response__c & Application__c - query=['+query+']');
        }

        return appResList;
    }

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Method to build query string based on parameters (Offers or Pricing)
    Inputs: Source object name, 
            Offers/Pricing boolean, 
            List of Ids to be used as query filter
    Returns: String
    ------------------------------------------------------------*/
    private static String buildQueryString(String objectName, Boolean isOffers, List<Id> objectIdList){
        //Build query string
        String query = 'SELECT';
        //Get Application fields
        Map<String, Schema.SObjectField> appFields = Schema.getGlobalDescribe().get('Application__c').getDescribe().fields.getMap();
        //Only retrieve Application Response fields for Offers
        if(isOffers){
            //Get Application Response fields
            Map<String, Schema.SObjectField> appResFields = Schema.getGlobalDescribe().get('Application_Response__c').getDescribe().fields.getMap();
            //Grab the fields from the describe method and append them to the queryString one by one.
            for(String s : appResFields.keySet()){
               query += ' ' + s + ',';
            }
        }
        for(String s : appFields.keySet()){
            //Add Application relationship if call is from Offers
            query += isOffers ? ' Application__r.'+s+',' : ' ' + s + ',';
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
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Async call to Run Rule Engine on Pricing Rule Set
    Inputs: Application Ids
    Returns: Void
    ------------------------------------------------------------*/
    //@future
    public static void runPricingEngineAsync(List<Id> applicationIdList){
        try {
            
            //BEGIN MLASALA 03-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
            //Commented out and change logic to cater pricing engine without updating application
            // runPricingEngine(applicationIdList);
            
            //Query application and application response records
            List<Application__c> applicationList = getAllApplication(applicationIdList);
            
            //Run pricing engine to get interest rate
            System.debug('applicationList RUL Engine YY'+applicationList);
            applicationList = runPricingEngine(applicationList);
            System.debug('applicationList after YY '+applicationList);
            //Update application (BAU)
            if(applicationList.size() > 0){
                update(applicationList);
            }
            //END MLASALA 03-JUN-16
        }
        catch(Exception e) {
            ErrorHandlerException.recordException(e.getMessage() + ': ' + e.getStackTraceString(), 'runPricingEngineAsync', 'Rules', 'RUL_Engine', null); 
        }
    }
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Run Rule Engine on Pricing Rule Set
    Inputs: List<Application__c>
    Returns: List<Application__c>
    ------------------------------------------------------------*/
    //BEGIN MLASALA 03-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
    //Changed return type and parameter to cater pricing engine without updating application
    // public static void runPricingEngine(List<Id> applicationIdList){
    public static List<Application__c> runPricingEngine(List<Application__c> applicationList){
        
        //Commented out checking of old parameter
        // if(applicationIdList == null || applicationIdList.isEmpty()){
        //     System.debug('$$$ No IDs have been passed in.');
        //     throw new RUL_ErrorDataException('No IDs have been passed in.');
        // }
        
        //Checks if parameter has values
        if(applicationList == null || applicationList.isEmpty()){
            System.debug('$$$ No Applications have been passed in.');
            throw new RUL_ErrorDataException('No Applications have been passed in.');
        }
        
        //1. Get all the fields of Application
        // List<Application__c> applicationList = getAllApplication(applicationIdList);
        //2. Get Personal Loan Product Version related to Application
        Map<ID, Product_Version__c> prodVerToAppRes = getProductVersionsFromAppRes(applicationList);
        //3. Get Rule Sets by Product Version
        Map<ID, List<Rule_Set__c>> ruleSetListByProdVersion = getRuleSetsFromProductVersionMap(prodVerToAppRes.values(), 'Pricing');

        system.debug('Rule set values:' + ruleSetListByProdVersion);

        //4. Get Rules & Conditions for each Rule Set 
        List<Rule_Set__c> allRuleSets = new List<Rule_Set__c>();
        for(List<Rule_Set__c> rsList : ruleSetListByProdVersion.values()) {
            allRuleSets.addAll(rsList);
        }
        Map<ID, List<Rule__c>> rulesByRuleSet = getRulesFromRuleSet(allRuleSets);
        //5. Iterate through each Rule Set and run engine
        List<Application__c> applicationsToUpdate = new List<Application__c>();
        //To be used for getting interest rate from map's key
        Map<Id, Application__c> rateCardMap = new Map<Id, Application__c>();

        // Added by: Adrian Recio
        // Description: CPV3: Instantiate 60 day cert ICBS set
        // Date: 5/9/2016
        Set<String> icbsAccNumberSet = new Set<String>();
        // End

        // Added by: Adrian Recio
        // Description: CPV3: Query campaign interest rate
        // Date: 5/9/2016

        set<Id> oppAppSet = new set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();

        for(Application__c appVar: applicationList){
            if(appVar.Promotional_Campaign__c == 'Special Promotion'){
                oppAppSet.add(appVar.Id);
            }
        }

        if(oppAppSet.size()>0){
            oppList = [Select Id, Application__c, Campaign.Interest_Rate__c, 
                                CampaignId from Opportunity where Application__c IN :oppAppSet 
                                and Campaign.Interest_Rate__c>0 and Campaign.Promotional_Campaign__c = 'Special Promotion'
                                and Application__c!=null];
        }

        for(Opportunity oppVar: oppList){
            oppMap.put(oppVar.Application__c,oppVar);
        }

        system.debug('Campaign Opportunity:' + oppMap);  
        // End

        // Initiate Promo Map
        Map<Id, Application__c> promoMap = new Map<Id, Application__c>();
        Boolean promoEnginSuccess = true; // Promo Success flag

        // Pull promo rate if present 
        try{
            promoMap = RUL_PromoEngine.runPromoEngine(applicationList);
        } catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RUL_Engine__c', 'Debug_Log__c', 'Class');
            promoEnginSuccess = false;
        }

        system.debug('$$$ promoEnginSuccess:' + promoEnginSuccess);

        for(Application__c app: applicationList){
            // Rate calculation will apply to application types except for NZ 60 days applications
            if(!(app.Brand_Country__c=='NZ' && app.Promotional_Campaign__c=='60 Day Certificate')){

                // Pull Rate from Campaign Opportunity
                Opportunity pOppVar = oppMap.get(app.Id);

                // Pull Rate from Promo
                Application__c promoAppVar = promoMap.get(app.Id);
                Decimal promoRate = 0;
                if(promoAppVar!=null){
                    promoRate = promoAppVar.Offered_Interest_Rate__c;
                    
                    //MLASALA 26-SEPT-16 Moved promo fields mapping outside promo success condition
                    //to update values if it did not qualify for a/any promo
                    //or only establishment fee is applicable
                    // Map Promo Information to application
                    app.Promo_ID__c = promoAppVar.Promo_ID__c;
                    app.Promo_Message__c = promoAppVar.Promo_Message__c;
                    app.Promotional_Campaign__c = promoAppVar.Promotional_Campaign__c;
                    app.Offered_Establishment_Fee__c = promoAppVar.Offered_Establishment_Fee__c;
                    //Added interest rate reduction is promo engine is run before pricing engine
                    app.Interest_Reduction__c = promoAppVar.Interest_Reduction__c;
                    
                    //BEGIN MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                    //Added boolean if blending or direct promo rate will be applied
                    app.Promo_Blending__c = promoAppVar.Promo_Blending__c;
                    //Added online messaging
                    app.Promo_Online_Message__c = promoAppVar.Promo_Online_Message__c;
                    //END MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                }
                
                system.debug('$$$ Promo Campaign:' + pOppVar);
                system.debug('$$$ Promo Campaign Rate:' + app.Campaign_Rate__c);

                system.debug('$$$ Promo Engine App:' + promoAppVar);
                system.debug('$$$ Promo Engine Rate:' + promoRate);

                system.debug('$$$ App Country:' + app.Brand_Country__c);
                system.debug('$$$ App Campaign Type:' + app.Promotional_Campaign__c);

                system.debug('$$$ Total Refinance Amount:' + app.Total_Loan_Amount_Refinance__c);

                // Identify interest rate based on campaign rate. NZ ONLY.
                if( (pOppVar!=null || app.Campaign_Rate__c!=null) 
                    && app.Brand_Country__c=='NZ'){

                    // Assign Campaign Rate for the first time, 
                    // future re-calculations will use the rate assigned in app.Campaign_Rate__c
                    if(app.Campaign_Rate__c == null && pOppVar!=null){
                        app.Campaign_Rate__c = pOppVar.Campaign.Interest_Rate__c;
                    }

                    // If refinance exist, blend campaign rate with refinance interest rate
                    if(app.Total_Loan_Amount_Refinance__c>0){
                        promoMap.put(app.Id,new Application__c(Offered_Interest_Rate__c=app.Campaign_Rate__c));
                        rateCardMap.put(app.Id, app);
                        system.debug('Case: Blended Campaign Rate');
                    // If refinance doesn't exist, directly assign campaign rate as offered interest rate
                    }else{
                        app.Offered_Interest_Rate_Orig__c = app.Campaign_Rate__c;
                        app.Offered_Interest_Rate__c = app.Campaign_Rate__c;
                        applicationsToUpdate.add(app);
                        system.debug('Case: Fix Campaign Rate');
                    }
                // Identify interest rate based on promo rate. NZ ONLY.
                }else if( promoEnginSuccess &&
                          promoRate>0 && app.Brand_Country__c=='NZ'){
                    // If refinance exist and promo is blending, blend promo rate with refinance interest rate
                    if(app.Total_Loan_Amount_Refinance__c>0 && app.Promo_Blending__c==true){
                        rateCardMap.put(app.Id, app);
                        system.debug('Case: Blended Promo Rate');
                    // If refinance doesn't exist, directly assign promo rate as offered interest rate
                    }else{
                        app.Offered_Interest_Rate_Orig__c = promoRate;
                        app.Offered_Interest_Rate__c = promoRate;
                        applicationsToUpdate.add(app);
                        system.debug('Case: Fix Promo Rate');
                    }
                // Perform Matrix rate assignment for other applications including 
                // 60 days cert AU, normal app NZ and AU, normal campaign app NZ and AU, conditionally approved NZ and AU
                }else if(promoEnginSuccess && (promoRate==null || promoRate==0) && pOppVar==null){
                        if(app.Brand_Country__c=='AU' && app.Promotional_Campaign__c=='60 Day Certificate'){
                            icbsAccNumberSet.add(app.ICBS_Account_Number__c);
                        }
                    
                        Product_Version__c prodVersion = prodVerToAppRes.get(app.id);
                        if(prodVersion==null) {
                            continue;
                        }
                        List<Rule_Set__c> ruleSetList = ruleSetListByProdVersion.get(prodVersion.id);

                        system.debug('Pricing Rule Set:' + ruleSetList);

                        for(Rule_Set__c ruleSet : ruleSetList) {
                            List<Rule__c> ruleList = rulesByRuleSet.get(ruleSet.id);

                            system.debug('Pricing Rules:' + ruleList);
                            if(ruleList==null || ruleList.size()==0) {
                                //skip blank ruleset
                                continue;
                            }// End If
                            Map<String, SObject> objectMap = new Map<String, SObject>();
                            objectMap.put('Application__c'.toUpperCase(), app);
                            //TEMP DELETE THESE LINES AFTER CONDITION FIXED
                            objectMap.put('Application'.toUpperCase(), app);
                            //END TEMP
                            DrAndOpWrapper opList = processRules(ruleList, app, objectMap, false);
                            rateCardMap.putAll(opList.applicationRateCardMap);
                            System.debug('$$$ loop rateCardMap: '+rateCardMap.keySet());
                        } // End For               
                }// End Else
            }else if(app.Brand_Country__c=='NZ' && app.Promotional_Campaign__c == '60 Day Certificate'){
                app.Offered_Interest_Rate__c = app.Offered_Interest_Rate_Orig__c;
                applicationsToUpdate.add(app);
                system.debug('$$$ NZ reduction cancelled:' + app.Offered_Interest_Rate__c);
            }
        }

        System.debug('$$$ rateCardMap: '+rateCardMap.keySet());

        if(!rateCardMap.keySet().isEmpty()){
            // Added by: Adrian Recio
            // Description: CPV3: Query old ICBS Account Applications 
            //              for new sixty day cert apps sort by ICBS Id via map.
            // Date: 5/9/2016
            List<Application__c>appICBSList = new List<Application__c>();
            Map<string, Application__c> oldInterestRateMap = new Map<string, Application__c>();

            if(icbsAccNumberSet.size()>0){
                try{
                    appICBSList = [Select Id, Total_Loan_Amount__c, Total_Loan_Amount_Refinance__c, 
                                          Offered_Interest_Rate__c, Contract_Account_Number__c, Adjusted_Interest_Rate_Locked__c,
                                         (Select Id, Application__c, 
                                          Amount__c, Interest_Rate__c
                                          from Disbursements__r 
                                          WHERE Record_Type_Name__c = 'Re-Finance') 
                                          from Application__c where Contract_Account_Number__c IN :icbsAccNumberSet]; 
                }catch(Exception e){
                    system.debug('$$$ ICBS Account Query Failure:' + e.getMessage());
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RUL_Engine__c', 'Debug_Log__c', 'Class');
                }
            } 

            System.debug('$$$ oldappList: '+ appICBSList.size());

            Map<string, List<Disbursement__c>> icbsAppMap = new Map<string, List<Disbursement__c>>();
            // Build ICBS Applications by map
            for(Application__c appICBSVar : appICBSList){
                if(appICBSVar.Total_Loan_Amount_Refinance__c>0){
                    icbsAppMap.put(appICBSVar.Contract_Account_Number__c, appICBSVar.Disbursements__r);
                }     
                
                System.debug('$$$ icbs account: '+ appICBSVar.Contract_Account_Number__c);
                System.debug('$$$ icbs disbursement: '+ appICBSVar.Disbursements__r);

                oldInterestRateMap.put(appICBSVar.Contract_Account_Number__c, appICBSVar);
            }
            // End

            Map<Id, List<Disbursement__c>> applicationDisbursementMap = new Map<Id, List<Disbursement__c>>();
            //Retrieve Disbursement records for each Application to be used for getting blended rate (refinance)
            List<Disbursement__c> disbursementList = [SELECT    Id, 
                                                                Application__c, 
                                                                Amount__c, 
                                                                Interest_Rate__c 
                                                      FROM      Disbursement__c 
                                                      WHERE     Record_Type_Name__c = 'Re-Finance' 
                                                      AND       Application__c IN: rateCardMap.values()];
            System.debug('$$$ disbursementList: '+disbursementList.size());

            if(!disbursementList.isEmpty()){
                for(Disbursement__c d: disbursementList){
                    //Group Disbursement records per Application
                    if(applicationDisbursementMap.containsKey(d.Application__c)){
                        applicationDisbursementMap.get(d.Application__c).add(d);
                    } else {
                        List<Disbursement__c> tempList = new List<Disbursement__c>();
                        tempList.add(d);
                        applicationDisbursementMap.put(d.Application__c, tempList);
                    }
                }
            }

            // Added by Adrian Recio
            // Description: CVP 3: Create a final map which contains disbursement for sixty days and non sixty day cert app
            Map<Id, List<Disbursement__c>> finalDisbursementMap = new Map<Id, List<Disbursement__c>>();

            for(Id i: rateCardMap.keySet()){
                if(rateCardMap.get(i).ICBS_Account_Number__c!=null &&  
                   rateCardMap.get(i).Brand_Country__c=='AU' && 
                   rateCardMap.get(i).Promotional_Campaign__c=='60 Day Certificate'){ 
                    // Disbursement from old application takes over if it exist
                   if(icbsAppMap.get(rateCardMap.get(i).ICBS_Account_Number__c)!=null){
                     finalDisbursementMap.put(rateCardMap.get(i).Id, icbsAppMap.get(rateCardMap.get(i).ICBS_Account_Number__c));
                    // If not pull disbursement from new application
                   }else{
                     finalDisbursementMap.put(rateCardMap.get(i).Id, applicationDisbursementMap.get(rateCardMap.get(i).Id));
                   }
                }else{
                    finalDisbursementMap.put(rateCardMap.get(i).Id, applicationDisbursementMap.get(rateCardMap.get(i).Id));
                }
            }

            
            //Get interest rate based on map values
            //applicationsToUpdate.addAll(getInterestRate(rateCardMap, applicationDisbursementMap));
            applicationsToUpdate.addAll(getInterestRate(rateCardMap, finalDisbursementMap, oldInterestRateMap, promoMap));
            System.debug('$$$ applicationsToUpdate: '+applicationsToUpdate.size());
        }
        
        //Commented out, update will occur on method which called this
        //No update is used for customer ui upsell
        // update(applicationsToUpdate);
        return applicationsToUpdate;
        //END MLASALA 03-JUN-16
    }
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Get all Application fields
    Inputs: List of Application Ids to be processed
    Returns: List<Application>
    ------------------------------------------------------------*/
    // private static List<Application__c> getAllApplication(List<Id> applicationIdList) {
    public static List<Application__c> getAllApplication(List<Id> applicationIdList) {
        String query = buildQueryString('Application__c', false, applicationIdList);        
        List<Application__c> applicationList;
        try {
            applicationList = database.query(query);
            System.debug('$$$ getAllApplication() size: '+applicationList.size());
        } catch (QueryException e){
            System.debug('$$$ Unable to query Application__c - query: ['+query+']');
            throw new RUL_ErrorDataException('Unable to query Application__c - query: ['+query+']');
        }
        return applicationList;
    }
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Get all Application fields
    ------------------------------------------------------------*/
    public static Decimal higherSixtyDCRate(Decimal oldAppRate, Decimal newAppRate, Boolean hasRateReduction){
        if(hasRateReduction){
            if(oldAppRate!=null && newAppRate!=null){
                if(oldAppRate < newAppRate){
                    return oldAppRate;
                }
            }
        }
        return newAppRate;
    }

    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Get Interest Rate based on Rule's Rate Card 
    Inputs: Map with key of Rate Card Id and value of Application, 
            Map with key of Application Id and value of Disbursement records
    Update: Adrian Recio: Added conditionally assignment of campaign interest if application is created from campaign.
    Returns: List<Application>
    ------------------------------------------------------------*/
    public static List<Application__c> getInterestRate(Map<Id, Application__c> rateCardApplicationMap, Map<Id, List<Disbursement__c>> disbursementMap, 
                                                       Map<string, Application__c> oldInterestRateMap, Map<Id,Application__c> promoMap){

        List<Application__c> applicationList = new List<Application__c>();
        //Retrieve Rates based on map's keyset
        if(!rateCardApplicationMap.keySet().isEmpty()){
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
                                                          where Id IN: rateCardApplicationMap.keySet()]);

            System.debug('$$$ rateCardApplicationMap.keySet(): '+rateCardApplicationMap.keySet());

            //LM-4140 Changes - 7 December 2021 
            //Retrieve list of application ID
            Set<Id> setApplicationId = new Set<Id>();
            for(Application__c app: rateCardApplicationMap.values()) {
                setApplicationId.add(app.Id);
            }

            //Retrieve Disbursement records for each Application to be used for getting blended rate (refinance)
            List<Disbursement__c> disbursementList = [SELECT    Id, 
                                                                Application__c, 
                                                                Amount__c, 
                                                                Interest_Rate__c,
                                                                Record_Type_Name__c 
                                                      FROM      Disbursement__c 
                                                      WHERE     Application__c IN: setApplicationId
                                                      ORDER BY  CreatedDate ASC];

            //Put refinance disbursement in the map with application id as key
            Map<Id, Disbursement__c> mapApplicationRefinance = new Map<Id, Disbursement__c>();

            //check if it's inflight app or not
            //get the deployment date from custom settings, if application created date < deployment date, it is an inflight app
            // CHG0033885 is deployment code for 24 January 2022 release
            Date deploymentDate = Inflight_Settings__c.getValues('CHG0033885').Deployment_Date__c;

            for(Disbursement__c refinance: disbursementList) {
                if(refinance.Record_Type_Name__c == 'Re-Finance') {
                    mapApplicationRefinance.put(refinance.Application__c, refinance);
                }
            }                                          
            //End LM-4140 Changes - 7 December 2021 

            //if(!rateList.isEmpty()){

                //Used to prevent adding of duplicates in list
                String applicationId = '';

                List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();

                for(Id i: rateCardApplicationMap.keySet()){

                    Application__c rateApp = rateCardApplicationMap.get(i);
                    Application__c origApp;
                    Decimal totalLoanAmount = rateApp.Total_Loan_Amount__c != null ? rateApp.Total_Loan_Amount__c : 0;
                    Decimal totalRefinance = rateApp.Total_Loan_Amount_Refinance__c != null ? rateApp.Total_Loan_Amount_Refinance__c : 0;
                    Application__c appVar = promoMap.get(rateApp.Id);
                    Decimal promoRate = 0;
                    //MLASALA 27-SEPT-16 Added interest rate reduction variable for promo engine
                    Decimal interestReduction = rateApp.Interest_Reduction__c != null ? rateApp.Interest_Reduction__c : 0;
                    
                    if(appVar!=null){
                        promoRate = appVar.Offered_Interest_Rate__c;
                    }
                    Decimal capacity = 0;
                    Decimal oldRefinanceIntR;
                    Decimal oldRefinanceRefAmount;
                    
                    //Compute capacity to identify minimum and maximum range
                    // Added by: Adrian Recio
                    // Description: CPV3: Determine Total Loan Amount based on campaign type.
                    //              If sixty days application, add refinance amount.
                    //              If normal application, remove refinance amount.
                    // Date: 5/9/2016
                    if(rateApp.Brand_Country__c=='AU' && rateApp.Promotional_Campaign__c == '60 Day Certificate'){
                        
                        origApp = oldInterestRateMap.get(rateApp.ICBS_Account_Number__c);
                        if(origApp!=null){
                            oldRefinanceIntR = origApp.Offered_Interest_Rate__c;
                            oldRefinanceRefAmount = origApp.Total_Loan_Amount_Refinance__c;
                            capacity = (totalLoanAmount - totalRefinance) + (origApp.Total_Loan_Amount__c - origApp.Total_Loan_Amount_Refinance__c);
                        }// End If
                    }else{
                        capacity = totalLoanAmount - totalRefinance;
                    }// End Else
                    
                    Decimal offeredInterestRateOrig = rateApp.Offered_Interest_Rate_Orig__c != null ? rateApp.Offered_Interest_Rate_Orig__c : 0;
                    Decimal offeredInterestRate = rateApp.Offered_Interest_Rate__c != null ? rateApp.Offered_Interest_Rate__c : 0;
                    Decimal adjustedInterest = rateApp.Adjusted_Interest_Rate__c != null ? rateApp.Adjusted_Interest_Rate__c : 0;
                    
                    system.debug('$$$ Promotion Type:' + rateApp.Promotional_Campaign__c);
                    system.debug('$$$ Orig app: ' + origApp);
                    system.debug('$$$ Capacity: ' + capacity);
					system.debug('$$$ Promo rate: ' + promoRate);
                    system.debug('$$$ Country: ' + rateApp.Brand_Country__c);
                    system.debug('$$$ totalLoanAmount:' + totalLoanAmount);
                    system.debug('$$$ totalRefinance:' + totalRefinance);
                    system.debug('$$$ Business Source:' + rateApp.Business_Source__c);
                    system.debug('$$$ OldRefinanceIntRate:' + oldRefinanceIntR);
                    system.debug('$$$ oldRefinanceRefAmount:' + oldRefinanceRefAmount);
                    
                    // Check if app has promo rate and for blending if refinance is greater than 0
                    if(promoRate>0 && rateApp.Brand_Country__c=='NZ'&& totalRefinance>0){
                        rateApp.Offered_Interest_Rate_Orig__c = getBlendedRate(capacity, 
                                                                                 totalRefinance, 
                                                                                 promoRate, 
                                                                                 disbursementMap.get(rateApp.Id));
                        rateApp.Offered_Interest_Rate__c = rateApp.Offered_Interest_Rate_Orig__c;
                        System.debug('$$$ c Blended rate:' + rateApp.Offered_Interest_Rate__c);

                        Debug_Log__c debugLog = Util.createDebugLog(rateApp.Id, rateApp.Name, 'RUL_Engine', 'getInterestRate');
                        debugLog.Calculation_Log__c += 'Offered_Interest_Rate_Orig__c: '+offeredInterestRateOrig+' --> '+rateApp.Offered_Interest_Rate_Orig__c+'\n';
                        debugLog.Calculation_Log__c += 'Offered_Interest_Rate__c: '+offeredInterestRate+' --> '+rateApp.Offered_Interest_Rate__c+'\n';
                        debugLog.Calculation_Log__c += 'Adjusted_Interest_Rate__c: '+adjustedInterest+' --> '+rateApp.Adjusted_Interest_Rate__c+'\n';

                        applicationList.add(rateApp);
                        applicationId = rateApp.Id;
                        debugLogList.add(debugLog);

                    // Go to standard blending process based on matrix rate
                    }else{
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

                            //Isolate rate card which satisfies all the Application's crtieria
                            if(r.Credit_Score__c == rateApp.Credit_Score__c && 
                               r.Principal_Minimum__c <= capacity && 
                               r.Principal_Maximum__c >= capacity && 
                               r.Rate_Card__r.Start_Date__c <= rateApp.LastModifiedDate &&
                               r.Rate_Card__r.End_Date__c >= rateApp.LastModifiedDate &&
                               applicationId != String.valueOf(rateApp.Id)){

                                //Added by Mike Lasala 05/19/15 for calculation debugging
                                Debug_Log__c debugLog = Util.createDebugLog(rateApp.Id, rateApp.Name, 'RUL_Engine', 'getInterestRate');
                                system.debug('$$$ Qualified Rate:' + r);
                                
                                // Added by: Adrian Recio
                                // Description: CPV3: Do not blend rate if old application doesn't have refinance. If false, blend.
                                // Date: 5/9/2016
                                if(rateApp.Brand_Country__c=='AU' && rateApp.Promotional_Campaign__c == '60 Day Certificate'){
                                    Decimal dcFinalRate = 0;
                                    if(oldRefinanceRefAmount==null || oldRefinanceRefAmount==0 || totalRefinance <= 0){ 
                                        System.debug('$$$ 60 DC condition 1.1');
                                        dcFinalRate = r.Rate__c;
                                    }else{
                                        System.debug('$$$ 60 DC condition 1.2');

                                        /*
                                        LM-4140 Changes
                                        Added by: William Putra
                                        Description:Get the existing blended rate calculation logic removed for Australia region
                                        Date: 7/12/2021
                                        */
                                        if(rateApp.CreatedDate < deploymentDate) {
                                            dcFinalRate = getBlendedRate(capacity, 
                                            totalRefinance, 
                                            r.Rate__c, 
                                            disbursementMap.get(rateApp.Id));
                                        } else {
                                            Disbursement__c icbsRate = mapApplicationRefinance.get(rateApp.Id);
                                            dcFinalRate = icbsRate.Interest_Rate__c;
                                        }
                                    }

                                    system.debug('$$$ 60 DC new rate:' + dcFinalRate);
                                    // Get the higher rate from the new 60 dc rate and the old rate
                                    //rateApp.Offered_Interest_Rate_Orig__c = higherSixtyDCRate(oldRefinanceIntR, dcFinalRate, origApp.Adjusted_Interest_Rate_Locked__c);
                                    rateApp.Offered_Interest_Rate_Orig__c = dcFinalRate;
                                    rateApp.Offered_Interest_Rate__c = rateApp.Offered_Interest_Rate_Orig__c;
                                    system.debug('$$$ 60 DC final rate:' + rateApp.Offered_Interest_Rate_Orig__c);
                                //Set interest rate fields
                                //IF CURRENT ORIGINAL INTEREST RATE, CURRENT OFFERED INTEREST RATE AND CURRENT ADJUSTED INTEREST RATE = 0.00% and
                                //IF CURRENT ORIGINAL INTEREST RATE AND CURRENT OFFERED INTEREST RATE > 0 AND CURRENT ADJUSTED INTEREST RATE = 0.00%
                                }else if((offeredInterestRateOrig == 0 || offeredInterestRateOrig > 0) && 
                                   (offeredInterestRate == 0 || offeredInterestRate > 0) && adjustedInterest == 0){
                                    System.debug('$$$ condition 1');

                                    //Scenario 1 - FIRST TIME INTEREST RATE POPULATION W/O REFINANCE
                                    //Scenario 3 - NO RATE REDUCTION AND W/O REFINANCE
                                    if(totalRefinance <= 0){
                                        System.debug('$$$ condition 1.1');
                                        
                                        //MLASALA 27-SEPT-16 Added interest rate reduction variable for promo engine
                                        rateApp.Offered_Interest_Rate_Orig__c = r.Rate__c - interestReduction;
                                    } else {
                                        System.debug('$$$ condition 1.2');
                                        //Scenario 2 - FIRST TIME INTEREST RATE POPULATION W/REFINANCE
                                        //Scenario 4 - NO RATE REDUCTION AND W/REFINANCE
                                        //Get blended rate if with refinance
                                        if(rateApp.Brand_Country__c!='AU' || rateApp.CreatedDate < deploymentDate) {
                                            rateApp.Offered_Interest_Rate_Orig__c = getBlendedRate(capacity, 
                                                                                                totalRefinance, 
                                                                                                r.Rate__c, 
                                                                                                disbursementMap.get(rateApp.Id));
                                        } else {
                                            /*
                                            LM-4140 Changes
                                            Added by: William Putra
                                            Description:Get the existing blended rate calculation logic removed for Australia region
                                            Date: 7/12/2021
                                            */        
                                            Disbursement__c icbsRate = mapApplicationRefinance.get(rateApp.Id);
                                            rateApp.Offered_Interest_Rate_Orig__c = icbsRate.Interest_Rate__c; 
                                        }                                                                                                                              
                                    }
                                    
                                    rateApp.Offered_Interest_Rate__c = rateApp.Offered_Interest_Rate_Orig__c;
                                    //rateApp.Adjusted_Interest_Rate__c = 0.00;

                                } else if(offeredInterestRateOrig > 0 && 
                                          offeredInterestRate > 0 && 
                                          adjustedInterest > 0){
                                    System.debug('$$$ condition 2');

                                    //IF CURRENT ORIGINAL INTEREST RATE, CURRENT OFFERED INTEREST RATE AND CURRENT ADJUSTED RATE > 0.00%
                                    Decimal interestDifference = 0;

                                    //Scenario 5 - RATE REDUCTION AND W/O REFINANCE
                                    if(totalRefinance <= 0 && adjustedInterest > 0){
                                        System.debug('$$$ condition 2.1');
                                        
                                        //IF |ORIGINAL INTEREST RATE - RATE CARD interest rate| <= 0.03% 
                                        interestDifference = offeredInterestRateOrig - r.Rate__c;
                                        
                                        rateApp.Offered_Interest_Rate_Orig__c = r.Rate__c;

                                    } else if(totalRefinance > 0 && adjustedInterest <= 0){
                                        System.debug('$$$ condition 2.2');
                                        if(rateApp.Brand_Country__c!='AU' || rateApp.CreatedDate < deploymentDate) {
                                            //Scenario 6 - NO RATE REDUCTION AND W/REFINANCE
                                            Decimal blendedRate = getBlendedRate(capacity, 
                                                                                totalRefinance, 
                                                                                r.Rate__c, 
                                                                                disbursementMap.get(rateApp.Id));
                                                
                                            //IF |ORIGINAL INTEREST RATE - Blended interest rate| <= 0.03%
                                            interestDifference = offeredInterestRateOrig - blendedRate;
                                            
                                            //Populate ORIGINAL INTEREST RATE
                                            rateApp.Offered_Interest_Rate_Orig__c = blendedRate;
                                        } else {
                                            /*
                                            LM-4140 Changes
                                            Added by: William Putra
                                            Description:Get the existing blended rate calculation logic removed for Australia region
                                            Date: 7/12/2021
                                            */        
                                            Disbursement__c icbsRate = mapApplicationRefinance.get(rateApp.Id);
                                            rateApp.Offered_Interest_Rate_Orig__c = icbsRate.Interest_Rate__c;   
                                        }                                      
                                    } else if(totalRefinance > 0 && adjustedInterest > 0){
                                        System.debug('$$$ condition 2.3');

                                        //BEGIN MLASALA: 09-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
                                        //New Scenario: W/ RATE REDUCTION AND REFINANCE
                                        if(rateApp.Adjusted_Interest_Rate__c != null && 
                                           rateApp.Adjusted_Interest_Rate__c == rateApp.Offered_Interest_Rate__c){

                                            //Flush rate reduction fields
                                            rateApp.Adjusted_Interest_Rate_Locked__c = false;
                                            rateApp.Adjusted_Interest_Rate_Reason__c = '';
                                            rateApp.Adjusted_Interest_Rate__c = null;
                                            rateApp.Workflow_In_Progress__c = false;
                                            if(rateApp.Brand_Country__c!='AU' || rateApp.CreatedDate < deploymentDate) {
                                                rateApp.Offered_Interest_Rate_Orig__c = getBlendedRate(capacity, 
                                                                                                    totalRefinance, 
                                                                                                    r.Rate__c, 
                                                                                                    disbursementMap.get(rateApp.Id));
                                            } else {
                                                /*
                                                LM-4140 Changes
                                                Added by: William Putra
                                                Description:Get the existing blended rate calculation logic removed for Australia region
                                                Date: 7/12/2021
                                                */        
                                                Disbursement__c icbsRate = mapApplicationRefinance.get(rateApp.Id);
                                                rateApp.Offered_Interest_Rate_Orig__c = icbsRate.Interest_Rate__c; 
                                            }                                                                                                   
                                        }
                                        //END MLASALA: 09-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
                                    }

                                    System.debug('$$$ interestDifference: '+interestDifference);
                                    //if(interestDifference > 0.03){
                                        //System.debug('$$$ condition 2.3');
                                        
                                        //Populate OFFERED INTEREST RATE
                                        rateApp.Offered_Interest_Rate__c = rateApp.Offered_Interest_Rate_Orig__c;
                                        
                                        //Populate ADJUSTED INTEREST RATE
                                        //rateApp.Adjusted_Interest_Rate__c = 0.00;
                                    //}
                                }
                                debugLog.Calculation_Log__c += 'Offered_Interest_Rate_Orig__c: '+offeredInterestRateOrig+' --> '+rateApp.Offered_Interest_Rate_Orig__c+'\n';
                                debugLog.Calculation_Log__c += 'Offered_Interest_Rate__c: '+offeredInterestRate+' --> '+rateApp.Offered_Interest_Rate__c+'\n';
                                debugLog.Calculation_Log__c += 'Adjusted_Interest_Rate__c: '+adjustedInterest+' --> '+rateApp.Adjusted_Interest_Rate__c+'\n';

                                applicationList.add(rateApp);
                                applicationId = rateApp.Id;
                                debugLogList.add(debugLog);
                            }// End If
                            
                        }// End For
                    }// End Else
                }// End For
                
                //Added by Mike Lasala 05/19/15 for calculation debugging
                if(!debugLogList.isEmpty()){
                    try{
                        insert debugLogList;
                    } catch(DMLException e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RUL_Engine__c', 'Debug_Log__c', 'Class');
                    }
                }
            //}
        }
        return applicationList;
    }

   // Dummy Promo Get Interest Method
    public static Map<Id,Decimal> getPromoInterest(List<Application__c> appList){
        
        Map<Id,Decimal> promoMap = new Map<Id,Decimal>(); 
        if(appList[0].Brand_Country__c=='NZ' && appList[0].Promo_Id__c!=null){
        	promoMap.put(appList[0].Id,8.8);
        }
        return promoMap;
    }
    
    /*------------------------------------------------------------
    Author: Michael Lasala
    Company: Cloud Sherpas
    Description: Get Blended Rate
    Inputs: New Cash Amount, 
            Total Refinance Amount, 
            Interest Rate from Rate Card, 
            Refinance Disbursement list of Application
    Returns: Decimal
    ------------------------------------------------------------*/
    public static Decimal getBlendedRate(Decimal newCashAmount, Decimal refinanceAmount, Decimal interestRate, List<Disbursement__c> disbursementList){
        Decimal blendedRate = 0;
        //Check Refinance Amount value
        if(refinanceAmount > 0){
            if(!disbursementList.isEmpty()){
                Decimal totalAmount = 0;
                Decimal dividend = 0;
                totalAmount = newCashAmount != null ? newCashAmount : 0;
                System.debug('$$$ totalAmount (new cash amount): '+totalAmount);
                for(Disbursement__c d: disbursementList){
                    //Continue with records with Interest Rate
                    if(d.Interest_Rate__c != null){
                        Decimal amountRefinance = 0;
                        System.debug('$$$ amountRefinance computation: '+d.Amount__c+' * '+d.Interest_Rate__c / 100);
                        //Summate results to be used for dividend on computation
                        dividend += d.Amount__c * (d.Interest_Rate__c / 100);
                    }
                    //Summate amount to be used for divisor on computation
                    totalAmount += d.Amount__c != null ? d.Amount__c : 0;
                    System.debug('$$$ totalAmount += '+d.Amount__c);
                }
                System.debug('$$$ blended rate computation: (('+newCashAmount+' * '+interestRate / 100+') + ('+dividend+')) / '+totalAmount);
                //Blended rate calculation
                blendedRate = (((newCashAmount * (interestRate / 100)) + (dividend)) / totalAmount) * 100;
            }
        }
        System.debug('$$$ blendedRate: '+blendedRate+' '+blendedRate.setScale(2, RoundingMode.HALF_UP));
        return blendedRate.setScale(2, RoundingMode.HALF_UP);
    }
    
    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: Nov 11, 2014
    Description: An Object to hold the List of OfferPresented record and the Boolean for Deal Reallocaiton.
    */
    public class DrAndOpWrapper{

        public List<Offer_Presented__c> offersPresentedList; 
        public Boolean dealReallocate;
        public Map<Id, Application__c> applicationRateCardMap;

        public DrAndOpWrapper(){
            offersPresentedList = new List<Offer_Presented__c>();
            applicationRateCardMap = new Map<Id, Application__c>();
        }

    } 

}