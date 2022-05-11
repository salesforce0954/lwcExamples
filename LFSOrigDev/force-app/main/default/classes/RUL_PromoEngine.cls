/* @Description: Promo engine
 * @Author: Mike Lasala
 * @Date Created: 23-AUG-2016
 */
public class RUL_PromoEngine{
    
    public static Boolean isFirstRun = true;
    public static Map<Id, Application__c> applicationMap = new Map<Id, Application__c>();
    public static Decimal upsellAmount;
    
    /*  Description: Retrieves all data needed and execution for the promo engine
     *  Author: Mike Lasala
     *  Date Created: 23-AUG-2016
     *  Input Parameters: List<Application__c>
     *  Return: Map<Id, Application__c>
     */
    public static Map<Id, Application__c> runPromoEngine(List<Application__c> appList){
        System.debug('$$$ RUL_PromoEngine.runPromoEngine');
        
        Set<String> promoIds = new Set<String>();
        String brands = '';
        Set<Id> applicationIds = new Set<Id>();
        Set<String> activeBrands = new Set<String>();
        
        //Get active picklist values (to filter only NZ)
        //Brands__c picklist is using global picklists
        Schema.DescribeFieldResult fieldResult = Promo__c.Brands__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            activeBrands.add(p.getValue());
        }
        
        Map<Id, String> tempPromoIdMap = new Map<Id, String>();
        
        for(Application__c a: appList){
            
            //Validate if application brand is among active brands in promo
            //and Promotional Campagin = Special Promotion or blank
            if(activeBrands.contains(a.Brand_String__c) && 
               (a.Promotional_Campaign__c == 'Special Promotion' || 
				a.Promotional_Campaign__c == null)){
					
                //Add promos id/s and brand/s to be used as a filter for promos
                if(a.Promo_ID__c != null){
                    promoIds.add(a.Promo_ID__c);
                }
                
                brands += a.Brand_String__c+';';
                applicationIds.add(a.Id);
            }
        }
        System.debug('$$$ applicationIds: '+applicationIds);
        
        if(!applicationIds.isEmpty()){
            System.debug('$$$ promoIds: '+promoIds);
            
            brands = removeLastCharacter(brands, ';');
            System.debug('$$$ brands: '+brands);
            
            Map<Id, Promo__c> promoMap = new Map<Id, Promo__c>();
            Set<Id> activePromoIds = new Set<Id>();
            Set<Id> promosWithNoRules = new Set<Id>();
            
            //2. GET PROMOS
            for(Promo__c p: getPromos(promoIds, brands)){
                
                //Add promo record id/s to be used as a filter for rules
                activePromoIds.add(p.Id);
                
                //Put promo record in map for application processing
                promoMap.put(p.Id, p);
                
                promosWithNoRules.add(p.Id);
            }
            System.debug('$$$ activePromoIds: '+activePromoIds);
            
            Map<String, Set<String>> objectMap = new Map<String, Set<String>>();
            Map<Id, List<Rule__c>> promoRulesMap = new Map<Id, List<Rule__c>>();
            List<Application__c> nonEligibleApplications = new List<Application__c>();
            
            if(!activePromoIds.isEmpty()){
                
                //3. GET RULES AND CONDITIONS
                for(Rule__c r: getRulesConditions(activePromoIds)){
                    
                    //Build map with promo as key, rules and conditions as values to be used for comparison
                    if(promoRulesMap.containsKey(r.Rule_Set__r.Promo__c)){
                        promoRulesMap.get(r.Rule_Set__r.Promo__c).add(r);
                    } else {
                        List<Rule__c> tempList = new List<Rule__c>();
                        tempList.add(r);
                        promoRulesMap.put(r.Rule_Set__r.Promo__c, tempList);
                    }
                    
                    //Build map with sObject as key, set of string as values to be used for building dynamic query
                    for(Condition__c c: r.Conditions__r){
                        if(objectMap.containsKey(c.LHS_Object_Name__c)){
                            objectMap.get(c.LHS_Object_Name__c).add(c.LHS_Field_Name__c);
                        } else {
                            Set<String> tempList = new Set<String>();
                            tempList.add(c.LHS_Field_Name__c);
                            objectMap.put(c.LHS_Object_Name__c, tempList);
                        }
                    }
                }
                // System.debug('$$$ promoRulesMap: '+promoRulesMap);
                // System.debug('$$$ objectMap: '+objectMap);
                
            } else {    //Entered promo code does not exist
                
                for(Application__c a: appList){
                    
                    //Flush promo id to remove filter in query
                    a.Promo_Id__c = null;
                    nonEligibleApplications.add(a);
                }
            }
            
            List<Application__c> applicationList = new List<Application__c>();
            Map<Id, List<Applicant__c>> applicantMap = new Map<Id, List<Applicant__c>>();
            
            if(!objectMap.keySet().isEmpty() || 
               !promosWithNoRules.isEmpty()){
                
                //4. REQUERY APPLICATION AND RELATED OBJECTS TO BE USED FOR COMPARISON
                //MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
		//MLASALA 17-OCT-16 Added fields used in upsell/insurance page
                //Added Promo_Online_Message__c,Channel__c
                String applicationQueryString = 'SELECT Id,Initial_Submit_Date__c,Offered_Interest_Rate__c,Offered_Establishment_Fee__c,Status__c,'+
                                                'Response_Code__c,Submission_Status__c,Promo_ID__c,Promotional_Campaign__c,Brand_String__c,'+
                                                'Promo_Ineligible__c,Promo_Online_Message__c,Channel__c,Adjusted_Interest_Fee_Locked__c,'+
                                                'Adjusted_Interest_Rate_Locked__c,Total_Loan_Amount__c,Total_Insurance_Premium__c,'+
                                                'Offered_PPSR_Search_Fee__c,Offered_PPSR_Registration_Fee__c,Total_Loan_Amount_Refinance__c,'+
                                                'Brokerage_Fee__c,Offered_Monthly_Loan_Service_Fee__c,Loan_Term_Months__c,Payment_Frequency__c,'+
                                                'Offered_Repayments__c';
                
                String applicantQueryString = 'SELECT Id,Application__c';
                
                //Iterate over each sObject
                for(String o: objectMap.keySet()){
                    
                    if(o == 'Application__c'){
                        
                        //Add fields
                        applicationQueryString += addFields(objectMap.get(o));
                        
                    } else if(o == 'Loan_Purpose__c'){
                        
                        //Add subquery
                        applicationQueryString += buildSubQueryString(objectMap.get(o), o.replace('__c', '__r'));
                        
                    } else if(o == 'Applicant__c'){
                        
                        //Add fields
                        applicantQueryString += addFields(objectMap.get(o));
                        
                    } else if(o == 'Income__c'){
                        
                        //Add subquery
                        applicantQueryString += buildSubQueryString(objectMap.get(o), o.replace('__c', 's__r'));
                    }
                }
                
                //Close off query string
                applicationQueryString = closeQueryString(applicationQueryString, 'Application__c', 'Id', applicationIds);
                applicantQueryString = closeQueryString(applicantQueryString, 'Applicant__c', 'Application__c', applicationIds);
                
                //Retrieve applications
                applicationList = Database.query(applicationQueryString); 
                // System.debug('$$$ applicationList: '+applicationList);
                
                //Retrieve applicants
                for(Applicant__c a: Database.query(applicantQueryString)){
                    //Map each applicant per application
                    if(applicantMap.containsKey(a.Application__c)){
                        applicantMap.get(a.Application__c).add(a);
                    } else {
                        List<Applicant__c> tempList = new List<Applicant__c>();
                        tempList.add(a);
                        applicantMap.put(a.Application__c, tempList);
                    }
                }
                // System.debug('$$$ applicantMap: '+applicantMap);
            }
            
            if(!applicationList.isEmpty()){
                
                for(Application__c application: applicationList){
                    
                    //Build map of application children (loan purpose and applicant) and grandchild (income) records
                    Map<String, List<SObject>> applicationChildrenMap = buildChildrenMap(objectMap.keySet(), application, applicantMap);
                    // System.debug('$$$ applicationChildrenMap: '+applicationChildrenMap);
                    
                    if(!promoRulesMap.keySet().isEmpty() || 
                       !promosWithNoRules.isEmpty()){
                        
                        Promo__c finalPromo;
                        
                        //5. ASSESS APPLICATION ELIGIBLITY
                        List<Id> eligiblePromoIds = promoEligibility(application, promoRulesMap, applicationChildrenMap);
                        System.debug('$$$ promosWithNoRules: '+promosWithNoRules);
                        
                        for(Id i: promosWithNoRules){
                            //if promo does not have rules, automatic eligibility
                            if(promoRulesMap.get(i) == null){
                                eligiblePromoIds.add(promoMap.get(i).Id);
                            }
                        }
                        System.debug('$$$ eligiblePromoIds: '+eligiblePromoIds);
                        
                        //Single promo eligiblity
                        if(eligiblePromoIds.size() == 1){
                            
                            finalPromo = promoMap.get(eligiblePromoIds.get(0));
                            
                        } else if(eligiblePromoIds.size() > 1){    //Multiple promo eligibility
                            
                            Date recentDate;
                            DateTime createdDateTime;
                            
                            for(Id promoId: eligiblePromoIds){
                                Promo__c promo = promoMap.get(promoId);
                                System.debug('$$$ promo: '+promo);
                                System.debug('$$$ recentDate: '+recentDate);
                                
                                if(recentDate == null){
                                	recentDate = promo.Promo_Start__c;
                                }
                                
                                if(createdDateTime == null){
                                    createdDateTime = promo.CreatedDate;   
                                }
                                
								//If promo start and created date is not equal, get latest start date
                                if(recentDate != createdDateTime.date()){
                                    //Get most recent promo for multiple promo eligbility
                                    if(recentDate <= promo.Promo_Start__c){
                                        recentDate = promo.Promo_Start__c;
                                        finalPromo = promo;
                                    }
                                } else {	//promo start and created date is equal, get latest created date
                                    //Get most recent promo for multiple promo eligbility
                                    if(createdDateTime <= promo.createdDate){
                                        createdDateTime = promo.createdDate;
                                        finalPromo = promo;
                                    }
                                }
                            }
                        } else {    //No promo eligiblity
                            
                            //Identify whether application has a promo id before flushing
                            // if(!tempPromoIdMap.containsKey(application.Id)){
                            if(application.Promo_ID__c != null){
                                tempPromoIdMap.put(application.Id, application.Promo_ID__c);
                                System.debug('$$$ tempPromoIdMap: '+tempPromoIdMap);
                            }
                            
                            //Flush promo id
                            application.Promo_ID__c = null;
                            nonEligibleApplications.add(application);
                            
                            //Add promo message
                            if(!isFirstRun){
                                
                                if(application.Promotional_Campaign__c == 'Special Promotion'){
                                    application.Promotional_Campaign__c = null;
                                }
                                
                                //Only add messaging if promo id exists
                                if(tempPromoIdMap.get(application.Id) != null){
                                    application.Promo_Message__c = 'Application does not meet promo criteria and regular lending policies and pricing apply';
                                    
                                    //BEGIN MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                                    //Only add online messaging for customer ui apps
                                    if(application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE){
                                        application.Promo_Online_Message__c = 'Oops, that promotion doesn\'t seem to fit with your application. So we\'ll contact you directly.';
                                    }
                                    //END MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                                }
                                
                                application.Offered_Interest_Rate__c = null;
                                application.Offered_Establishment_Fee__c = null;
                                application.Promo_Blending__c = false;
                                
                                applicationMap.put(application.Id, application);
                            }
                        }
                        
                        if(finalPromo != null){
                            System.debug('$$$ finalPromo: '+finalPromo);
                            
                            //6.A APPLY PROMO TO APPLICATION
                            applicationMap.put(application.Id, applyPromoFeatures(application, finalPromo));
                        }
                    }
                }
            }
            System.debug('$$$ nonEligibleApplications: '+nonEligibleApplications);
            System.debug('$$$ isFirstRun: '+isFirstRun);
            
            //6.B RE-RUN ENGINE ONCE IF ANY APPLICATION DID NOT PASS PROMO ELIGIBILITY
            if(!nonEligibleApplications.isEmpty() && 
               isFirstRun){
                
                isFirstRun = false;
                runPromoEngine(nonEligibleApplications);
            }
        }
        System.debug('$$$ applicationMap: '+applicationMap);
        return applicationMap;
    }
    
    /*  Description: Get promo records based on parameters
     *  Author: Mike Lasala
     *  Date Created: 15-SEPT-2016
     *  Input Parameters: Set<String> (promo ids)
                          String (brands)
     *  Return: List<Promo__c>
     */
    public static List<Promo__c> getPromos(Set<String> promoIds, String brands){
        //Build query string
        String queryString = 'SELECT ';
        
        //Add fields based on field set
        for(Schema.FieldSetMember f: SObjectType.Promo__c.FieldSets.Promo_Commons.getFields()){
            queryString += f.getFieldPath()+',';
        }
        
        queryString = removeLastCharacter(queryString, ',');
        
        //null = applicable to all brands
        //includes = applicable to selected brands
        queryString += ' FROM Promo__c WHERE Promo_End__c >= TODAY AND (Brands__c = null';
        
        if(brands != ''){
            queryString += ' OR Brands__c INCLUDES (:brands)';
        }
        
        queryString += ')';
        
        //Add filter if parameter is not empty
        if(!promoIds.isEmpty()){
            
            //Construct filter
            queryString += ' AND Promo_ID__c IN (';
            
            //Add set of ids
            for(String s: promoIds){
                queryString += '\''+s+'\',';
            }
            
            queryString = removeLastCharacter(queryString, ',');
            
            //Close filter
            queryString += ')';
        } else {
            queryString += ' AND DM__c = false';
        }
        
        queryString += ' AND Active__c = true';
        // System.debug('$$$ queryString: '+queryString);
        List<Promo__c> promoList = Database.query(queryString);
        return promoList;
    }
    
    /*  Description: Get rules and conditions based on parameter
     *  Author: Mike Lasala
     *  Date Created: 15-SEPT-2016
     *  Input Parameters: Set<Id> (promo record ids)
     *  Return: List<Rule__c>
     */
    public static List<Rule__c> getRulesConditions(Set<Id> promoIds){
        
        List<Rule__c> ruleList = [SELECT  Name, 
                                          Order__c, 
                                          Rule_Set__r.Promo__c, 
                                          (SELECT Order__c, 
                                           Type__c, 
                                           LHS_Object_Name__c, 
                                           LHS_Field_Name__c, 
                                           Operation__c, 
                                           Free_Text__c, 
                                           Conjunction_to_Previous__c
                                           FROM   Conditions__r 
                                           WHERE Free_Text__c != null
                                           ORDER BY Order__c ASC)
                                  FROM    Rule__c 
                                  WHERE   Rule_Set__r.Promo__c IN: promoIds
                                  AND     IsActive__c = true
                                  ORDER BY Order__c ASC];
        return ruleList;
    }
    
    /*  Description: Close dynamic query based on parameters
     *  Author: Mike Lasala
     *  Date Created: 15-SEPT-2016
     *  Input Parameters: String
                          Set<Id> (record ids)
     *  Return: String
     */
    public static String closeQueryString(String selectStatement, String sourceObject, String filterField, Set<Id> idSet){
        
        //Add sobject and id filter
        selectStatement += ' FROM '+sourceObject+' WHERE '+filterField+' IN (';
        
        //Add set of record ids
        for(Id i: idSet){
            selectStatement += '\''+i+'\',';
        }
        
        selectStatement = removeLastCharacter(selectStatement, ',');
        
        //Close query
        selectStatement += ')';
        System.debug('$$$ closeQueryString: '+selectStatement);
        return selectStatement;
    }
    
    /*  Description: Build dynamic subquery based on parameters
     *  Author: Mike Lasala
     *  Date Created: 15-SEPT-2016
     *  Input Parameters: Set<String> (fields set)
                          String (object)
                          Set<Id>
     *  Return: String
     */
    public static String buildSubQueryString(Set<String> fieldSets, String objectString){
        //Build query string
        String subQuery = ',(SELECT Id';
        subQuery += addFields(fieldSets);
        subQuery += ' FROM ';
        subQuery += objectString;
        subQuery += ')';
        // System.debug('$$$ subQuery '+objectString+': '+subQuery);
        return subQuery;
    }
    
    /*  Description: Build map with sObject type as key and List<sObject> as values
     *  Author: Mike Lasala
     *  Date Created: 15-SEPT-2016
     *  Input Parameters: Set<String>
                          Application__c
                          Map<Id, List<Applicant__c>>
     *  Return: Map<String, List<SObject>>
     */
    public static Map<String, List<SObject>> buildChildrenMap(Set<String> sObjectSet, 
                                                              Application__c application, 
                                                              Map<Id, List<Applicant__c>> applicantMap){
        
        Map<String, List<SObject>> childrenMap = new Map<String, List<SObject>>();
        
        //Iterate over sObjects
        for(String objectString: sObjectSet){
            
            if(objectString != 'Application__c'){
                
                List<SObject> sObjectList = new List<SObject>();
                
                if(objectString == 'Loan_Purpose__c'){
                    
                    sObjectList = application.Loan_Purpose__r;
                    
                } else if(objectString == 'Applicant__c'){
                    
                    sObjectList = applicantMap.get(application.Id);
                    
                } else if(objectString == 'Income__c'){
                    
                    for(Applicant__c applicant: applicantMap.get(application.Id)){
                        sObjectList = applicant.Incomes__r;
                    }
                }
                
                //Map each sObject type
                childrenMap.put(objectString.toUpperCase(), sObjectList);
            }
        }
        return childrenMap;
    }
    
    /*  Description: Iterate over promos, assess rules and conditions against application and children data
     *  Author: Mike Lasala
     *  Date Created: 16-SEPT-2016
     *  Input Parameters: Application__c
                          Map<Id, List<Rule__c>>
                          Map<String, List<SObject>>
     *  Return: List<Id>
     */
    public static List<Id> promoEligibility(Application__c application, 
                                                  Map<Id, List<Rule__c>> promoRulesMap, 
                                                  Map<String, List<SObject>> childrenMap){
        List<Id> eligiblePromoIds = new List<Id>();
        
        //Iterate over promos
        for(Id promoId: promoRulesMap.keySet()){
            System.debug('$$$ promoEligibility promo : '+promoId+'==================================================');
            
            Boolean isEligible = false;
            
            //Iterate over rules for each promo
            for(Rule__c rule: promoRulesMap.get(promoId)){
                System.debug('$$$ promoEligibility rule : '+rule.Name+'----------------------------------------------------------------------------------------------------');
                
                //Minimum employment years and months variables
                Integer recordYearCount = 0;
                Integer recordMonthCount = 0;
                Integer comparativeYearCount = 0;
                Integer comparativeMonthCount = 0;
                
                //Iterate over conditions for each rule
                for(Condition__c condition: rule.Conditions__r){
                    //System.debug('$$$ condition: '+condition);
                    
                    //Only for conditions that does not concern time comparative
                    if(!condition.LHS_Field_Name__c.containsIgnoreCase('years') && 
                       !condition.LHS_Field_Name__c.containsIgnoreCase('months')){
                        
                        //Check previous condition
                        if(condition.Conjunction_to_Previous__c=='AND'){
                            
                            if(!isEligible){
                                
                                //Rule fail because all conditions need to be met
                                break;
                            } else {
                                
                                //Reset variable for current condition
                                isEligible = false;
                            }
                        } else if(condition.Conjunction_to_Previous__c=='OR'){
                            
                            if(isEligible){
                                
                                //Don't need to continue processing, rule is true already
                                break;
                            }
                        }
                    }
                    
                    Object objectValue = null;
                    
                    //For application object
                    if(condition.LHS_Object_Name__c.toUpperCase() == 'APPLICATION__C'){
                        
                        //Get object value
                        objectValue = application.get(condition.LHS_Field_Name__c);
                        
                        //BEGIN MLASALA 17-OCT-16 If on upsell/insurance page, recreate formula fields used for comparison
                        if(upsellAmount != null &&
                           (condition.LHS_Field_Name__c == 'Total_Loan_Amount_New_Cash_Without_Fees__c' || 
                            condition.LHS_Field_Name__c == 'Total_Loan_Amount_with_Insurance__c')){
                            
                            System.debug('$$$ upsellAmount: '+upsellAmount);
                            
                            if(condition.LHS_Field_Name__c == 'Total_Loan_Amount_New_Cash_Without_Fees__c'){
                                objectValue = upsellAmount - application.Total_Loan_Amount_Refinance__c;
                            } else if(condition.LHS_Field_Name__c == 'Total_Loan_Amount_with_Insurance__c'){
                                objectValue = upsellAmount + application.Total_Insurance_Premium__c +
                                              application.Offered_Establishment_Fee__c + application.Offered_PPSR_Search_Fee__c +
                                              application.Offered_PPSR_Registration_Fee__c + application.Brokerage_Fee__c;
                            }
                        }
                        //END MLASALA 17-OCT-16 If on upsell/insurance page, recreate formula fields used for comparison
                        
                        //Compare conditon value
                        isEligible = compareParentObjectValues(condition, objectValue);
                        
                    } else {    //For child and grandchild objects
                        
                        //Iterate over key of sObjects
                        for(String childObject: childrenMap.keySet()){
                            // System.debug('$$$$ childObject: '+childObject);
                            
                            //Get list of each sObject
                            List<SObject> comparativeObjectList = childrenMap.get(condition.LHS_Object_Name__c.toUpperCase());
                            
                            //Iterate over list of records
                            for(SObject childRecord: comparativeObjectList){
                                // System.debug('$$$$ childRecord: '+childRecord);
                                
                                //Prevent duplicate iterations
                                if(childObject == condition.LHS_Object_Name__c){
                                    
                                    //Get object value
                                    objectValue = childRecord.get(condition.LHS_Field_Name__c);
                                    
                                    //Conditions that does not concern time comparative
                                    if(!condition.LHS_Field_Name__c.containsIgnoreCase('years') && 
                                       !condition.LHS_Field_Name__c.containsIgnoreCase('months')){
                                        
                                        //Get condition value
                                        Object freeTextField = condition.Free_Text__c.toUpperCase();
                                        
                                        //Identify whether condition value is equal or contains object value
                                        isEligible = compareMultiPicklist(String.valueOf(objectValue), String.valueOf(freeTextField));
                                        
                                        //If true, no need to process further
                                        if(isEligible){
                                            break;
                                        }
                                        
                                    } else {        //time comparative conditions
                                        
                                        if(condition.LHS_Field_Name__c.containsIgnoreCase('years')){
                                            
                                            //Summate record years for mutliple records
                                            if(childRecord.get(condition.LHS_Field_Name__c) != null){
                                                recordYearCount += Integer.valueOf(childRecord.get(condition.LHS_Field_Name__c));
                                            }
                                            
                                            //Summate condition total years once
                                            if(comparativeYearCount == 0){
                                                comparativeYearCount += Integer.valueOf(condition.Free_Text__c);
                                            }
                                        }
                                        
                                        if(condition.LHS_Field_Name__c.containsIgnoreCase('months')){
                                            
                                            //Summate record months for mutliple records
                                            if(childRecord.get(condition.LHS_Field_Name__c) != null){
                                                recordMonthCount += Integer.valueOf(childRecord.get(condition.LHS_Field_Name__c));
                                            }
                                            
                                            //Summate condition total months once
                                            if(comparativeMonthCount == 0){
                                               comparativeMonthCount += Integer.valueOf(condition.Free_Text__c);
                                            }
                                        }
                                        
                                        //Compare calculated total months of all records against calculated total months of condition
                                        isEligible = compareMonths(condition,
                                                                   recordYearCount, 
                                                                   recordMonthCount, 
                                                                   comparativeYearCount, 
                                                                   comparativeMonthCount);
                                    }
                                }
                            }
                        }
                    }
                    System.debug('$$$ promoEligibility isEligible: '+isEligible);
                }
                //Stop proccessing if a rule is not satisfied
                if(!isEligible){
                    break;
                }
            }
            
            if(isEligible){
                eligiblePromoIds.add(promoId);
            }
        }
        return eligiblePromoIds;
    }
    
    /*  Description: Apply promo interest rate/reduction and/or establishment fee to application
     *  Author: Mike Lasala
     *  Date Created: 16-SEPT-2016
     *  Input Parameters: 
     *  Return: Application__c
                Promo__c
     */
    public static Application__c applyPromoFeatures(Application__c application, Promo__c promo){
        System.debug('$$$ applyPromoFeatures date: '+application.Initial_Submit_Date__c.date()+' < '+promo.Promo_End__c);
        System.debug('$$$ Promo_Ineligible__c: '+application.Promo_Ineligible__c);
        
        if(!application.Promo_Ineligible__c){
            
            //Validate if application submit date is before or equal to promo end date
            if(application.Initial_Submit_Date__c.date() <= promo.Promo_End__c){
                application.Promo_Message__c = null;
                application.Promotional_Campaign__c = 'Special Promotion';
                application.Interest_Reduction__c = null;
                application.Promo_Blending__c = promo.Blending_Applies__c;
                application.Promo_Online_Message__c = null;
                
                //By pass if rate reduction is applied
                if(!application.Adjusted_Interest_Rate_Locked__c){
	                
	                //If margin reduction, populate application interest reduction
	                if(promo.Margin_Reduction__c){
	                    
	                    if(promo.Interest_Rate__c != null){
	                        application.Interest_Reduction__c = promo.Interest_Rate__c;
	                        application.Offered_Interest_Rate__c = null;
	                    }
	                } else {    //Replace application rate
	                
	                    if(promo.Interest_Rate__c != null){
	                        application.Offered_Interest_Rate__c = promo.Interest_Rate__c;
	                    } else {
	                        application.Offered_Interest_Rate__c = null;
	                    }
	                }
                }
                
                //By pass if fee reduction is applied
                if(!application.Adjusted_Interest_Fee_Locked__c){
                   	
                   	if(promo.Establishment_Fee__c != null){
                       	//Replace application establishment fee
                        application.Offered_Establishment_Fee__c = promo.Establishment_Fee__c;
                   	} else {
                   	    application.Offered_Establishment_Fee__c = null;
                   	}
                }
                
                //Replace promo id with eligble promo and promo messaging
                if(application.Promo_ID__c != null && 
                   application.Promo_ID__c != promo.Promo_ID__c){
                    
                    application.Promo_ID__c = promo.Promo_ID__c;
                    application.Promo_Message__c = 'Application does not meet promo criteria but will qualify for different promo which has been updated';
                    
                    //BEGIN MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                    //Only add online messaging for customer ui apps
                    if(application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE){
                        application.Promo_Online_Message__c = 'Oops, that promotion doesn\'t seem to fit with your application. But don\'t worry, we have assessed and found another promotion for you.';
                    }
                    //END MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                }
                
                if(application.Promo_ID__c == null){
                    application.Promo_ID__c = promo.Promo_ID__c;
                }
                System.debug('$$$ applyPromoFeatures app rate: '+application.Offered_Interest_Rate__c+', fee: '+application.Offered_Establishment_Fee__c);
            }
        } else {
            application.Promo_Message__c = null;
            application.Promotional_Campaign__c = null;
            application.Interest_Reduction__c = null;
            application.Offered_Interest_Rate__c = null;
            application.Promo_ID__c = null;
            application.Promo_Blending__c = false;
            
            //MLASALA 05-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
            application.Promo_Online_Message__c = null;
        }
        return application;
    }
    
    /*  Description: Compares field value from parent object (single) against free text value on condition
     *  Author: Mike Lasala
     *  Date Created: 13-SEPT-2016
     *  Input Parameters: Condition__c
                          Object (comparative value)
     *  Return: Boolean
     */
    public static Boolean compareParentObjectValues(Condition__c condition, Object objectFieldValue){
        
        Boolean isValid = false;
        
        String objectFieldString = String.valueOf(objectFieldValue).toUpperCase();
        // Decimal objectFieldNumber = Decimal.valueOf(String.valueOf(objectFieldValue));
        
        //Get condition comparative value
        String conditionFieldString = String.valueOf(condition.Free_Text__c).toUpperCase();
        // Decimal conditionFieldNumber = Decimal.valueOf(String.valueOf(conditionFieldString));
        System.debug('$$$ compareParentObjectValues '+condition.LHS_Object_Name__c+'.'+condition.LHS_Field_Name__c+': '+objectFieldString+' '+condition.Operation__c+' '+conditionFieldString);
        
        if(condition.Operation__c == '='){
            if(objectFieldString == conditionFieldString){
                isValid = true;
            }
        } else if(condition.Operation__c == '!='){
            if(objectFieldString !=  conditionFieldString){
                isValid = true;
            }
        } else if(condition.Operation__c == '>'){ 
            if(Decimal.valueOf(objectFieldString) > Decimal.valueOf(conditionFieldString)){
                isValid = true;
            }
        } else if(condition.Operation__c == '<'){ 
            if(Decimal.valueOf(objectFieldString) < Decimal.valueOf(conditionFieldString)){
                isValid = true;
            }
        } else if(condition.Operation__c == '>='){ 
            if(Decimal.valueOf(objectFieldString) >= Decimal.valueOf(conditionFieldString)){
                isValid = true;
            }
        } else if(condition.Operation__c == '<='){ 
            if(Decimal.valueOf(objectFieldString) <= Decimal.valueOf(conditionFieldString)){
                isValid = true;
            }
        }
        
        //Comparative for multi select picklists
        if(conditionFieldString.contains(';')){
            isValid = compareMultiPicklist(objectFieldString, conditionFieldString);
        }
        return isValid;
    }
    
    /*  Description: Checks if the field value is present in a mutli picklist
     *  Author: Mike Lasala
     *  Date Created: 14-SEPT-2016
     *  Input Parameters: String (source value)
                          String (comparative value)
     *  Return: Boolean
     */
    public static Boolean compareMultiPicklist(String sourceValue, String comparativeValue){
        Boolean isValid = false;
        
        sourceValue = sourceValue.toUpperCase();
        comparativeValue = comparativeValue.toUpperCase();
        
        //Check if comparative value contains more than 1 value
        if(comparativeValue.contains(';')){
            
            //Iterate over values and check if it contains the source value 
            for(String str: comparativeValue.split(';')){
                
                if(sourceValue.contains(str)){
                    
                    isValid = true;
                    break;
                }
            }
            System.debug('$$$ compareMultiPicklist: '+sourceValue+' IN: '+comparativeValue);
        
        } else {    //Single value
        
            if(sourceValue == comparativeValue){
                isValid = true;
            }
            System.debug('$$$ compareSinglePicklist: '+sourceValue+' = '+comparativeValue);
        }
        return isValid;
    }

    /*  Description: Compares total years and months from source object against free text value on condition
     *  Author: Mike Lasala
     *  Date Created: 14-SEPT-2016
     *  Input Parameters: Condition
                          Integer (years)
                          Integer (months)
                          Integer (years comparative)
                          Integer (months comparative)
     *  Return: Boolean
     */
    public static Boolean compareMonths(Condition__c condition, 
                                        Integer years, 
                                        Integer months, 
                                        Integer yearsComparative, 
                                        Integer monthsComparative){
        Boolean isValid = false;
        
        //Get total months of years
        Integer totalMonths = (years*12) + months;
        Integer totalMonthsComparative = (yearsComparative*12) + monthsComparative;
        System.debug('$$$ compareMonths: '+totalMonths+' >= '+totalMonthsComparative);
        
        if(totalMonths >= totalMonthsComparative){
            isValid = true;
        }
        return isValid;
    }
    
    /*  Description: Adds each item from a list of string to a single string
     *  Author: Mike Lasala
     *  Date Created: 13-SEPT-2016
     *  Input Parameters: Set<String>
     *  Return: String
     */
    public static String addFields(Set<String> fieldList){
        String fieldsString = '';
        
        //Iterate over each field and add to query
        for(String f: fieldList){
            fieldsString += ','+f;
        }
        return fieldsString;
    }
    
    /*  Description: Removes last character from a string
     *  Author: Mike Lasala
     *  Date Created: 13-SEPT-2016
     *  Input Parameters: String
                          String (condition)
     *  Return: String
     */
    public static String removeLastCharacter(String queryString, String condition){
        //Strip off the last character if it exists
        if(queryString != '' && 
           queryString.subString(queryString.length()-1,queryString.length()) == condition){
            
            queryString = queryString.subString(0,queryString.length()-1);
        }
        return queryString;
    }
}