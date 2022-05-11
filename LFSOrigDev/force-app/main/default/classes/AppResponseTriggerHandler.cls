/*
Author: Michael Lasala Cloud Sherpas
Created Date: September 17, 2013
Description: Class to handle AppResponseTrigger Logic
* @History:
   =====================================================================
       09-20-13: Bulkified Trigger - Fel
       09-22-13: Added Exception Handling - Mac       
       12-19-13: Once application response is received, update the Application's submission status to "Response Received"
       23-03-15: Neha Desor : Changes for NFL Flag DBHZL-206
       05-19-15: Added debug logging - Mike
       06-11-15: Added application number prepopulation on opportunity on app submit whe GE Unique Id is populated - Adrian
       08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
       08-10-15: UNLOCKING AUTO LOAN TEMPLATE ISSUE - MLASALA
   =====================================================================
*/

public class AppResponseTriggerHandler{ 
    
    /**  Description: Method that populate date/time with seconds on applicaiton response records
     *  Author: Fahad Akhtar
     *  Date Created: 19-05-2014
     *  Input Parameters: Trigger.new - Application Response Entries
     *  Return: void
     */
    public void populateDateTimeOnAppRes(List<Application_Response__c> appReslist){
        for(Application_Response__c ap : appResList){
            ap.Response_Time__c = String.ValueOf(System.now());  
        }    
    }

    /**  Description: Method that populates the Fields on the Application from the App Response
     *  Author: Russell Cadapan
     *  Date Created: 11-04-13
     *  Input Parameters: Trigger.new - Application Response Entries
     *  Return: void
     */
    public void populateApplicationFields(List<Application_Response__c> appReslist){

        Set<String> applicationId = new Set<String>();
        // Added by Adrian Recio, map that will hold application Id and its ge Unique Id Populated based on app response
        Map<Id,String> geUniquePopMap = new Map<Id,String>();  
        List<Application__c> applicationList = new List<Application__c>();
        List<Application__c> applicationListToUpdate = new List<Application__c>();
        
        //Added as part of Epoi Changes ODS-12336
        List<Income_Capacity__c> IncomeCapListToUpdate = new List<Income_Capacity__c>();        
        Map<Id,Income_Capacity__c> IncomeCapAppMap = new Map<Id,Income_Capacity__c>();
        
        //Added as part of POI Automation phase 2
        List<Income_Capacity__c> IncomeCapListUpdate = new List<Income_Capacity__c>(); 
        List<Income_Capacity__c> JointIncomeCapListUpdate1 = new List<Income_Capacity__c>();  
        List<Income_Capacity__c> JointIncomeCapListUpdate2 = new List<Income_Capacity__c>();             
        Map<Id,Income_Capacity__c> IncomeCapMap = new Map<Id,Income_Capacity__c>();
        Map<Id,Income_Capacity__c> JointIncomeCapMap = new Map<Id,Income_Capacity__c>();
        List<Income_Capacity__c> ictyList ;
        List<Income_Capacity__c> ictyList2;
        List<Income__c> jointincomeList;
        List<Income__c> jointincomeList1;
        

        //Added by Mike Lasala 05/19/15 for calculation debugging
        List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();

        Map<Id, Application__c> applicationMap = new Map<Id, Application__c>();

        Boolean restartIndicator;
        
        //BEGIN MLASALA: 30-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        Boolean clvFlushIndicator = false;
        
        for(Application_Response__c ap: appResList){
            if(ap.Retrieve_Payoff_Response__c == false){
                applicationId.add(ap.Application__c);
    
                //Check whether restart indicator is active
                if(ap.Restart_Indicator__c == 1 || ap.Restart_Indicator__c == 2 || ap.Restart_Indicator__c == 3){
                    restartIndicator = true;
                    
                    if(ap.Restart_Indicator__c != 3){
                        clvFlushIndicator = true;
                    }
                } else {
                    restartIndicator = false;
                }
            }
        }

        if(restartIndicator){
            flushDecisions(applicationId);  //flush decisions
        }
        
        if(clvFlushIndicator){
            flushCLVs(applicationId);
        }
        //END MLASALA: 30-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        
        //Used fieldsets - Fel 
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Application__c.FieldSets.Application_Commons.getFields()) {
          query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Application__c where Id IN: applicationId';
        System.debug('Query ' + query);
        applicationList =  Database.query(query);

        
        
        for(Application__c a : applicationList){
            //BEGIN MLASALA: 08/10/15 - UNLOCKING AUTO LOAN TEMPLATE ISSUE
            //Moved block of code previously existing here
            applicationMap.put(a.Id, a);
            //END MLASALA: 08/10/15 - UNLOCKING AUTO LOAN TEMPLATE ISSUE
        }

        
        //List of application where in all insurance offers will be flushed                
        List<Application__c> appToReset = new List<Application__c>();
        
        //List of application where in all the insurance offers selected by applicant 2 will be flushed
        List<Application__c> appToRecalculate = new List<Application__c>();
        
        //Create Map of Application and Product Items
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItemsBySet(applicationId);

        Map<Id,List<Product_Item__c>> appProdItemMap = new Map<Id,List<Product_Item__c>>();
        for(Product_Item__c pi: offerCalculator.prodItems){
            if(appProdItemMap.containsKey(pi.Application__c)){
                appProdItemMap.get(pi.Application__c).add(pi);
            }else{
                appProdItemMap.put(pi.Application__c, new List<Product_Item__c> {pi});
            }
        }
        
        Set<String> nonRetryableErrors = new Set<String>(); 
        Set<String> retryableErrors = new Set<String>();
        List<ExceptionLog__c> exLogsToInsert = new List<ExceptionLog__c>();
        //Use retryAble ASYNC errors only
        for(Webservice_Message_Codes__c wmc : [Select Name, Retry__c from Webservice_Message_Codes__c where Synchronous__c = false]) {
            if(wmc.retry__c) {
                retryableErrors.add(wmc.Name);
            } else {
                nonRetryableErrors.add(wmc.Name);
            }
        }

        RecordType webserviceExceptionRecType = Util.getWebServiceRecordType();
        RecordType rtRiskReferral = [SELECT Id, Name,DeveloperName FROM RecordType WHERE SObjectType = 'Workflow__c' AND DeveloperName = 'Risk_Referral'];

        List<Id> applicationIdList = new List<Id>();
        
        Map<Id, Boolean> riskGradeMap = new Map<Id, Boolean>();
        
        //BEGIN MLASALA: 18-JAN-16 CAPINC0769842 INSURANCE FLUSHING ISSUE
        //Used for comparing if interest rate changed
        Map<Id, Decimal> oldInterestMap = new Map<Id, Decimal>();
        
        // Updated by Adrian Recio
        // Description: Added response check to ensure rate calculation happens for AU 60 day cert apps
        for(Application_Response__c ap: appResList){

            system.debug('Restart Indicator:' + restartIndicator);
            system.debug('App Country:' + applicationMap.get(ap.Application__c).Brand_Country__c);
            system.debug('App Promo Campaign:' + applicationMap.get(ap.Application__c).Promotional_Campaign__c);
            system.debug('App Adjustment Lock:' + applicationMap.get(ap.Application__c).Adjusted_Interest_Rate_Locked__c);
            system.debug('App Business Source:' + applicationMap.get(ap.Application__c).Business_Source__c);
            system.debug('App Score:' + applicationMap.get(ap.Application__c).Credit_Score__c);
            system.debug('App Offered Interest Rate:' + applicationMap.get(ap.Application__c).Offered_Interest_Rate__c);
            system.debug('AR Score:' + ap.Credit_Score__c);

            Boolean rateRecalc = false;

            // Check if there is a valid risk grade change
            if((applicationMap.get(ap.Application__c).Credit_Score__c == null && ap.Credit_Score__c != null) || 

               (applicationMap.get(ap.Application__c).Credit_Score__c != null && ap.Credit_Score__c != null && 
                applicationMap.get(ap.Application__c).Credit_Score__c != ap.Credit_Score__c) || 

               (applicationMap.get(ap.Application__c).Brand_Country__c=='AU' && 
                applicationMap.get(ap.Application__c).Promotional_Campaign__c=='60 Day Certificate' && 
                applicationMap.get(ap.Application__c).Offered_Interest_Rate__c == null && 
                applicationMap.get(ap.Application__c).Adjusted_Interest_Rate_Locked__c == false &&
                ap.Credit_Score__c!=null)){
                system.debug('Score Recalc');
                rateRecalc = true;
                applicationIdList.add(ap.Application__c);
            
            // Recalculate promo if us NZ, Restarted and not 60 DC and has score
            } else if(ap.Credit_Score__c!=null && restartIndicator && applicationMap.get(ap.Application__c).Brand_Country__c=='NZ' && 
                      applicationMap.get(ap.Application__c).Adjusted_Interest_Rate_Locked__c == false &&
                      applicationMap.get(ap.Application__c).Promotional_Campaign__c=='60 Day Certificate'){
                        system.debug('Promo Restart Recalc');
                        rateRecalc = true;
                        applicationIdList.add(ap.Application__c);
            }

            if(rateRecalc == true){
                //MLASALA: 18-JAN-16 CAPINC0769842 INSURANCE FLUSHING ISSUE
                applicationMap.get(ap.Application__c).Credit_Score__c = ap.Credit_Score__c;
                riskGradeMap.put(applicationMap.get(ap.Application__c).Id, true);
                oldInterestMap.put(applicationMap.get(ap.Application__c).Id, applicationMap.get(ap.Application__c).Offered_Interest_Rate__c);
            }else{
                riskGradeMap.put(applicationMap.get(ap.Application__c).Id, false);
            }
        }
        
        update applicationMap.values();
        System.debug('applicationIdList YY: '+applicationIdList);
        if(!applicationIdList.isEmpty()){
            //Run Pricing Rule engine
            RUL_Engine.runPricingEngineAsync(applicationIdList);
        }
        
        applicationMap.clear();
        applicationList.clear();

        applicationList = Database.query(query);

        for(Application__c a : applicationList){
            applicationMap.put(a.Id, a);
        }
        
        //Added as part of ODDS-12213
       
        
        
        for(Income_Capacity__c IncCap : [SELECT Id, Income_1__c, Income_1_DD__c, Is_e_POI__c, 
                                        Income__c,Income__r.Applicant__r.Primary_Employment_Status__c,Income__r.Applicant__r.Application__c,
                                        Method_of_Verification__c,Employment_Type__c,Overtime_Shift_Allowance__c,Frequency_of_Payment__c,
                                        Method_of_Calculation__c,Minimum_Income_Used__c,Annualised_Net_Income__c,Annualised_Net_Income_per_Month__c,
                                        Rental_Income_per_ppty_owners__c,Gross_YTD__c,Net_YTD__c,Less_Tax__c,Annualised_Gross_Income__c,Net_Monthly_Income__c,
                                        Gross_Annualised_per_annum__c,Gross_Annualised_per_month__c,EQUALS_ADJUSTED_INCOME__c,ADJUSTED_INCOME_YEARLY__c
                                        FROM 
                                        Income_Capacity__c 
                                        WHERE 
                                        Income__r.Applicant__r.Application__c IN: applicationId]){
                                
            IncomeCapAppMap.put(IncCap.Income__r.Applicant__r.Application__c, IncCap);
        }
       //Added as part of POI Automation Phase 2
       
    List<Income__c> incomeList = [select id,Applicant__r.Application__c from Income__c where Applicant__r.Application__c =: applicationId];

       for(Income_Capacity__c InCap : [SELECT Id, Income_Detail__c,Income__r.Emp_Bus_Name__c,Income_1_DD__c,Income_1__c, Is_e_POI__c, 
                                        Income__c,Income__r.Applicant__r.Primary_Employment_Status__c,Income__r.Applicant__r.Application__c,
                                        Method_of_Verification__c,Employment_Type__c,Overtime_Shift_Allowance__c,Frequency_of_Payment__c,
                                        Method_of_Calculation__c,Minimum_Income_Used__c,Annualised_Net_Income__c,Annualised_Net_Income_per_Month__c,
                                        Rental_Income_per_ppty_owners__c,Gross_YTD__c,Net_YTD__c,Less_Tax__c,Annualised_Gross_Income__c,Net_Monthly_Income__c,
                                        Gross_Annualised_per_annum__c,Gross_Annualised_per_month__c,EQUALS_ADJUSTED_INCOME__c,ADJUSTED_INCOME_YEARLY__c
                                        FROM 
                                        Income_Capacity__c 
                                        WHERE 
                                        Income__r.Applicant__r.Application__c IN: applicationId]){
                                        IncomeCapMap.put(InCap.Income__r.Applicant__r.Application__c,InCap);
                                        }
       
       //End
        for(Application_Response__c ap: appResList){

            //Added by Mike Lasala 05/19/15 for calculation debugging
            Debug_Log__c debugLog = Util.createDebugLog(applicationMap.get(ap.Application__c).Id, ap.Name, null, null);

            //This block covers the handling of application response with error response codes. 
            if(ap.Response_Code__c!=null) {
                if(retryableErrors.contains(ap.Response_Code__c) || nonRetryableErrors.contains(ap.Response_Code__c)) {

                    //if it is not for retry then it is automatically failed
                    String retryStatus = retryableErrors.contains(ap.Response_Code__c)? GEN_OriginationsConstants.RETRY_STATUS_PENDING : GEN_OriginationsConstants.RETRY_STATUS_FAILED; 

                    exLogsToInsert.add(new ExceptionLog__c( Exception__c = 'Response Code: [' + ap.Response_Code__c + '] - ' + ap.Response_Description__c,
                                                            Object_Name__c = applicationMap.get(ap.Application__c).Last_Webservice_Class_Invoked__c,
                                                            Origin__c = ErrorHandlerException.ORIGIN_CLASS, 
                                                            Status__c = ErrorHandlerException.STATUS_FAILED, 
                                                            Parameters__c = ap.Application__c,
                                                            Retry_Attempts__c = 0,
                                                            Retry_Status__c = retryStatus,
                                                            RecordTypeId = webserviceExceptionRecType.Id,
                                                            Webservice_Response_Code__c = ap.Response_Code__c,
                                                            Webservice_Requested_Name__c = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c,
                                                            Application__c = ap.Application__c)); //requested name will be defaulted to Sales

                    applicationMap.get(ap.Application__c).Response_Code__c = ap.Response_Code__c;
                    applicationMap.get(ap.Application__c).Response_Description__c = ap.Response_Description__c;

                    if(retryStatus==GEN_OriginationsConstants.RETRY_STATUS_PENDING) {
                        applicationMap.get(ap.Application__c).Last_Webservice_Operation_Status__c = GEN_OriginationsConstants.WS_STATUS_RETRYPENDING;
                    } else {
                        applicationMap.get(ap.Application__c).Last_Webservice_Operation_Status__c = GEN_OriginationsConstants.WS_STATUS_FAILED;
                    }

                    applicationListToUpdate.add(applicationMap.get(ap.Application__c));

                    //skip the rest of the logic since the app response is considered an error response
                    continue;
                } 
            }
                        
            /*--- Added by Fel Saliba 1/20/2013 ----
            ------Check for Appresoponse Changes---- */
            
            /***If Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Credit_Score__c, Max_Monthly_Capacity__c, Applicant 1 Eligibility < new Eligibility value 
            from the Application response are different to the existing values on the Application THEN call the Flush function***/
            //Boolean riskGrade = false;    
            Boolean triggerFlush = false;   
            if((applicationMap.get(ap.Application__c).Max_Capacity_Secured__c != null && applicationMap.get(ap.Application__c).Max_Capacity_Secured__c != ap.Max_Capacity_Secured__c) || 
               (applicationMap.get(ap.Application__c).Max_Capacity_Unsecured__c != null && applicationMap.get(ap.Application__c).Max_Capacity_Unsecured__c != ap.Max_Capacity_Unsecured__c) ||
               (applicationMap.get(ap.Application__c).Credit_Score__c != null && applicationMap.get(ap.Application__c).Credit_Score__c != ap.Credit_Score__c) ||
               (applicationMap.get(ap.Application__c).Max_Monthly_Capacity__c != null && applicationMap.get(ap.Application__c).Max_Monthly_Capacity__c != ap.Max_Monthly_Capacity__c)||
               (applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_1__c != null && applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_1__c != 0 && applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_1__c > ap.Insurance_Eligibility_Flag_Applicant_1__c)){
               
                //Added by Mike Lasala 05/19/15 for calculation debugging
                debugLog.Calculation_Log__c += 'Class: AppResponseTriggerHandler\nMethod: populateApplicationFields\n\n';
                debugLog.Calculation_Log__c += 'Total_Insurance_Premium__c: '+applicationMap.get(ap.Application__c).Total_Insurance_Premium__c+' --> 0\n\n';
                
                //reset Total Insurance Premium
                //applicationMap.get(ap.Application__c).Total_Insurance_Premium__c = 0;
                
                //applicationMap.get(ap.Application__c).Total_Loan_Amount__c = applicationMap.get(ap.Application__c).Total_Loan_Amount_without_Debt__c != null ? applicationMap.get(ap.Application__c).Total_Loan_Amount_without_Debt__c : 0;
               //Application__c app = applicationMap.get(ap.Application__c);
               
               triggerFlush = true;
               //Add the application in a list for update.           
               //applicationListToUpdate.add(app);
            }
            //check Applicant 2 eligibility values.
            else if(applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_2__c != null && applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_2__c != 0 && applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_2__c > ap.Insurance_Eligibility_Flag_Applicant_2__c){
                  
                  offerCalculator = new OFF_OfferFieldsCalculator();
                  offerCalculator.prodItems = appProdItemMap.get(applicationMap.get(ap.Application__c).Id);
                  
                   if(offerCalculator.prodItems.size()>1){                
                        Boolean isLifeSingle       = false;
                        Boolean isDisabilitySingle = false;
                        Boolean isIUISingle        = false;
                        for(Product_Item__c pi: offerCalculator.prodItems){
                            if(pi.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                                    isLifeSingle = true;                        
                            }
                            else if(pi.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                                    isDisabilitySingle = true;
                            }
                            else if(pi.Product_Name__c == GEN_OriginationsConstants.INVOLUNTARY_UNEMPLOYMENT_INSURANCE){
                                    isIUISingle = true;
                            }                   
                        }
                        
                        //get the new Total Insurance premium value.
                        System.debug('application --->'+ applicationMap.get(ap.Application__c)); 

                        //Added by Fel Saliba 12/16/2014 - Check for the country of origin first.
                        Decimal premium = 0;
                        if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                            RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
                            premium = rul.getIndividualPremium(applicationMap.get(ap.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,false,false,false);
                        }
                        else if(applicationMap.get(ap.Application__c).Brand_Country__c == 'NZ'){
                            RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
                            rulNZ.calculateInsurnaceNZ(applicationMap.get(ap.Application__c),
                                       isLifeSingle,
                                       isDisabilitySingle,
                                       isIUISingle,
                                       false,
                                       false,
                                       false);
                            premium = rulNZ.totalInsurancePremium;
                        }

                        applicationMap.get(ap.Application__c).Total_Insurance_Premium__c = premium > 0 ? premium : 0;
                        
                        System.debug('insPrem --->'+ applicationMap.get(ap.Application__c).Total_Insurance_Premium__c); 
                        appToRecalculate.add(applicationMap.get(ap.Application__c));
                        
                        //Added by Mike Lasala 05/19/15 for calculation debugging
                        debugLog.Calculation_Log__c += 'Class: AppResponseTriggerHandler\nMethod: populateApplicationFields\n\n';
                        debugLog.Calculation_Log__c += 'Total_Insurance_Premium__c: '+applicationMap.get(ap.Application__c).Total_Insurance_Premium__c+' --> '+premium+'\n\n';

                        //for checking only.
                        //ErrorHandlerException.recordException(String.valueOf(applicationMap.get(ap.Application__c).Offered_Repayments__c), String.valueOf(applicationMap.get(ap.Application__c).Total_Insurance_Premium__c) , 'test', string.valueOf(amount), applicationMap.get(ap.Application__c).Id);
                   }            
            }
            system.debug('Checking before Out of Sync'); 

            //clear the "out of sync flag"         
            //Commented as part of Out of Sync Testing   
            if(ap.type__c != rtRiskReferral.Name 
               && applicationMap.get(ap.Application__c).Last_Webservice_Operation_Invoked__c != GEN_OriginationsConstants.SERVICENAME_VERIFYAML
               && applicationMap.get(ap.Application__c).Last_Webservice_Operation_Invoked__c != GEN_OriginationsConstants.SERVICENAME_VERIFYPOI 
               && !triggerFlush) {
                       
                applicationMap.get(ap.Application__c).out_of_sync__c = false;
                applicationMap.get(ap.Application__c).Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_RESPONSE_RECEIVED;
            }
            system.debug('Checking Out of Sync'+applicationMap.get(ap.Application__c).out_of_sync__c);           
            Decimal maxMonthlyCapacity = ap.Max_Monthly_Capacity__c != null ? ap.Max_Monthly_Capacity__c : 0;
            Decimal emiServiceFee = applicationMap.get(ap.Application__c).EMI_with_Service_Fee__c != null ? applicationMap.get(ap.Application__c).EMI_with_Service_Fee__c : 0;

            //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            //Flush error message if capacity is null
            if(ap.Max_Monthly_Capacity__c == null){
            
                applicationMap.get(ap.Application__c).Insurance_Error_Message__c = '';
            
            } else {

                //Identify remaining capacity is negavetive and if application has insurance
                //BEGIN MLASALA: 18-JAN-16 CAPINC0769842 INSURANCE FLUSHING ISSUE
                //Added condition to check if capacity is positive and interest changed
                if(((maxMonthlyCapacity - emiServiceFee) <= 0 || 
                     ((maxMonthlyCapacity - emiServiceFee) > 0 && 
                     riskGradeMap.get(applicationMap.get(ap.Application__c).Id) && 
                     applicationMap.get(ap.Application__c).Offered_Interest_Rate__c != oldInterestMap.get(ap.Application__c))) && 
                    (applicationMap.get(ap.Application__c).Total_Insurance_Premium__c != null && 
                    applicationMap.get(ap.Application__c).Total_Insurance_Premium__c != 0)){
                    //END MLASALA: 18-JAN-16 CAPINC0769842 INSURANCE FLUSHING ISSUE
                    
                    //Add the id of the application in a set to be used in deleting insurance.
                    appToReset.add(applicationMap.get(ap.Application__c));

                    //Populate insurance info message
                    applicationMap.get(ap.Application__c).Insurance_Error_Message__c = util.updateInsuranceInfoMessage(applicationMap.get(ap.Application__c).Id, 
                                                                                                                        applicationMap.get(ap.Application__c).Insurance_Error_Message__c, 
                                                                                                                        GEN_OriginationsConstants.NEGATIVE_CAPACITY_INSURANCE_INFO_MESSAGE);

                    debugLogList.add(Util.createInsuranceActivity(applicationMap.get(ap.Application__c).Id, 
                                                                  'Flush', 
                                                                  GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                                  'System', 
                                                                  applicationMap.get(ap.Application__c).Total_Insurance_Premium__c, 
                                                                  0));

                    //Set total insurance premium = 0
                    applicationMap.get(ap.Application__c).Total_Insurance_Premium__c = 0;
                    
                    //Set out of sync = true
                    applicationMap.get(ap.Application__c).out_of_sync__c = true;

                } else {

                    //Flush error message if capacity is positive
                    applicationMap.get(ap.Application__c).Insurance_Error_Message__c = '';
                }

                //Afreen - US 485 - Insurance Offers Change 
                flushInsuranceOffersOnNBSMFlagChange(applicationMap.get(ap.Application__c), ap,appToReset, debugLogList);
            }
            //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

            //else{
            //Added the aditonal check for Softquote check for converted applications and BAU Apps
                if(ap.uid__c != null || (applicationMap.get(ap.Application__c).uid__c != null && (applicationMap.get(ap.Application__c).Softquote_Document_Gen_Check__c) == false)) {
                   if(applicationMap.get(ap.Application__c).uid__c == null || (applicationMap.get(ap.Application__c).uid__c != null && (applicationMap.get(ap.Application__c).Softquote_Document_Gen_Check__c) == false)){
                        applicationMap.get(ap.Application__c).uid__c = ap.uid__c;

                        // Added by Adrian Recio 11/6/2015
                        // Store GE Unique Id for populated applications
                        geUniquePopMap.put(ap.Application__c,ap.uid__c);    
                        //set the copy of doc generated for Softquote Application                      
                        if((applicationMap.get(ap.Application__c).uid__c != null && (applicationMap.get(ap.Application__c).Softquote_Document_Gen_Check__c) == false)){
                            (applicationMap.get(ap.Application__c).Softquote_Document_Gen_Check__c) = true;
                        }

                        try {
                            String appId = applicationMap.get(ap.Application__c).Id;
                            
                            //Query for the lates web service log to determine the channel for the requstedName parameter.
                            Web_Service_Log__c wsb = [Select   Channel__c 
                                                      from     Web_Service_Log__c 
                                                      where    Application__c =: appId 
                                                       AND     Service_Called__c =: GEN_OriginationsConstants.SERVICENAME_SUBMIT
                                                      ORDER BY CreatedDate
                                                      LIMIT    1 ];        
                            
                            String requestedName = Web_Service_Settings__c.getValues('Requested Name Customer').Value__c;
                            if(wsb.Channel__c  == 'SalesUI'){
                                requestedName = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c; 
                            }
                            //call appExtract web service
                            IS_GenerateApplicationExtract.generateApplicationExtractRequest(appId,Util.getUser().Mock_Enable__c, requestedName, null);

                        } catch (Exception e) {
                            ErrorHandlerException.recordException(e.getMessage() + e.getStackTraceString(), 'AppResponseTriggerHandler', 'applicationExtract', 'Class', String.valueOf(applicationMap.get(ap.Application__c).Id));
                        }
                   }
                    else{
                        applicationMap.get(ap.Application__c).uid__c = ap.uid__c;
                    }            
                }
                if(ap.Case_Manager_ID__c != null) {
                    applicationMap.get(ap.Application__c).Case_Manager_ID__c = ap.Case_Manager_ID__c;
                }
                if(ap.Response_Code__c != null){
                    
                    //BEGIN MLASALA 06-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                    //Flush promo online message if conditionally approved to unconditionally approved
                    if(GEN_OriginationsConstants.CA_RESPONSE_CODE_NZ.contains(applicationMap.get(ap.Application__c).Response_Code__c) && 
                       ap.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA && 
                       applicationMap.get(ap.Application__c).Promo_Online_Message__c != null){
                        
                        applicationMap.get(ap.Application__c).Promo_Online_Message__c = null;
                    }
                    //END MLASALA 06-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
                    
                    applicationMap.get(ap.Application__c).Response_Code__c = ap.Response_Code__c;
                }
                if(ap.Response_Description__c != null){
                    applicationMap.get(ap.Application__c).Response_Description__c = ap.Response_Description__c;
                }
                if(ap.Insurance_Eligibility_Flag_Applicant_1__c != null){
                    applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_1__c = ap.Insurance_Eligibility_Flag_Applicant_1__c;
                }
                //if(ap.Insurance_Eligibility_Flag_Applicant_2__c != null){ //Afreen - 18-OCT, 16 - Commenting this condition as flag doesnt flush on application when NBS sends null for applicant 2 upon applicant 2 removal
                    applicationMap.get(ap.Application__c).Insurance_Eligibility_Flag_Applicant_2__c= ap.Insurance_Eligibility_Flag_Applicant_2__c;
                //}
                if(ap.Card_Cross_Sell_Eligibility__c != null){
                    applicationMap.get(ap.Application__c).Credit_Card_Eligibility_Flag__c= ap.Card_Cross_Sell_Eligibility__c;
                }
                //Added by Fel Saliba 11/28/2013
                if(ap.Max_Capacity_Secured__c != null){
                    applicationMap.get(ap.Application__c).Max_Capacity_Secured__c = ap.Max_Capacity_Secured__c;    
                }
                if(ap.Max_Capacity_Unsecured__c != null){
                    applicationMap.get(ap.Application__c).Max_Capacity_Unsecured__c = ap.Max_Capacity_Unsecured__c;    
                }
                if(ap.Min_Collateral_Amount__c != null){
                    applicationMap.get(ap.Application__c).Min_Collateral_Amount__c = ap.Min_Collateral_Amount__c;    
                }            
                if(ap.Master_Offer_Flag__c != null){
                    applicationMap.get(ap.Application__c).Master_Offer_Flag__c = ap.Master_Offer_Flag__c;    
                }
                if(ap.Max_Monthly_Capacity__c != null){
                    applicationMap.get(ap.Application__c).Max_Monthly_Capacity__c = ap.Max_Monthly_Capacity__c;    
                }
                
                //Added by Russell Cadapan 06/02/2014
                if(ap.Contract_Account_Number__c != null){
                    applicationMap.get(ap.Application__c).Contract_Account_Number__c = ap.Contract_Account_Number__c;    
                }
                
                //Added by Neha Desor - DBHZL-206 -  on 23/03/2015 for NFL response mapping
                if(ap.Applicant_1_NFL__c != null){
                    applicationMap.get(ap.Application__c).Applicant_1_NFL__c = ap.Applicant_1_NFL__c;    
                }
                if(ap.Applicant_2_NFL__c != null){
                    applicationMap.get(ap.Application__c).Applicant_2_NFL__c = ap.Applicant_2_NFL__c;    
                }                  
                if(ap.Applicant_1_NFL_Expiry_Date__c != null){
                    applicationMap.get(ap.Application__c).Applicant_1_NFL_Expiry_Date__c = ap.Applicant_1_NFL_Expiry_Date__c;    
                }                  
                if(ap.Applicant_2_NFL_Expiry_Date__c != null){
                    applicationMap.get(ap.Application__c).Applicant_2_NFL_Expiry_Date__c = ap.Applicant_2_NFL_Expiry_Date__c;    
                }                  
                
                //Added by Fahad Akhtar 27/06/2016
                if(ap.X60DC_Max_Amount__c != null){
                    applicationMap.get(ap.Application__c).X60DC_Max_Amount__c = ap.X60DC_Max_Amount__c;    
                }


                if(ap.Promo_Offer_Amount__c != null){
                    applicationMap.get(ap.Application__c).Promo_Offer_Amount__c = ap.Promo_Offer_Amount__c;    
                }
                
                if(ap.Score_Eligible__c != null){
                    applicationMap.get(ap.Application__c).Score_Eligible__c = ap.Score_Eligible__c;    
                }

                //Added Risk Grade Change : Soft Quote Changes
                if(ap.Risk_Grade__c != null){
                    applicationMap.get(ap.Application__c).Risk_Grade__c = ap.Risk_Grade__c;    
                }
               
                             
               //Start code changes as part of ODDS-12213 Epoi AU
                if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.EPOI_Completed_Flag__c != null){
                    IncomeCapAppMap.get(ap.Application__c).Is_e_POI__c = ap.EPOI_Completed_Flag__c;
                }
               /*if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.Verified_Date__c != null && ap.EPOI_Completed_Flag__c == true){
                    IncomeCapAppMap.get(ap.Application__c).Income_1_DD__c = ap.Verified_Date__c;
                }*/
                if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.Verified_Income__c != null && ap.EPOI_Completed_Flag__c != null && ap.EPOI_Completed_Flag__c == true){
                    if(IncomeCapAppMap.get(ap.Application__c).Income__r.Applicant__r.Primary_Employment_Status__c.containsIgnoreCase('Part Time'))
                        { 
                            IncomeCapAppMap.get(ap.Application__c).Employment_Type__c = 'Permanent Part Time';
                        }
                      else{
                             IncomeCapAppMap.get(ap.Application__c).Employment_Type__c = 'Permanent Full Time';
                         }
                        IncomeCapAppMap.get(ap.Application__c).Income_1__c = ap.Verified_Income__c;
                        IncomeCapAppMap.get(ap.Application__c).Income_1_DD__c = system.today(); 
                        IncomeCapAppMap.get(ap.Application__c).Is_e_POI__c = true;                   
                        IncomeCapAppMap.get(ap.Application__c).Method_of_Verification__c = 'Proviso';                   
                        IncomeCapAppMap.get(ap.Application__c).Frequency_of_Payment__c = 'Monthly';
                        IncomeCapAppMap.get(ap.Application__c).Method_of_Calculation__c = 'Net Income';
                        IncomeCapAppMap.get(ap.Application__c).Minimum_Income_Used__c= ap.Verified_Income__c;
                        IncomeCapAppMap.get(ap.Application__c).Annualised_Net_Income__c= ap.Verified_Income__c * 12;
                        IncomeCapAppMap.get(ap.Application__c).Annualised_Net_Income_per_Month__c= ap.Verified_Income__c;                    
                        IncomeCapAppMap.get(ap.Application__c).Overtime_Shift_Allowance__c='No';
                    
                        //ap.EPOI_Completed_Flag__c = false;
                    
                    //Added Defaults feilds
                    
                            IncomeCapAppMap.get(ap.Application__c).Rental_Income_per_ppty_owners__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Gross_YTD__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Net_YTD__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Less_Tax__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Annualised_Gross_Income__c = 0;   
                            IncomeCapAppMap.get(ap.Application__c).Gross_Annualised_per_annum__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Gross_Annualised_per_month__c = 0;
                   // Tax Return and Profit & Loss Fields
                            IncomeCapAppMap.get(ap.Application__c).EQUALS_ADJUSTED_INCOME__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).ADJUSTED_INCOME_YEARLY__c = 0;
                            IncomeCapAppMap.get(ap.Application__c).Net_Monthly_Income__c = 0;
                            applicationMap.get(ap.Application__c).out_of_sync__c = false;
                                      
                   system.debug('Checking After Out of Sync'+applicationMap.get(ap.Application__c).out_of_sync__c); 
                    
                   IncomeCapListToUpdate.add(IncomeCapAppMap.get(ap.Application__c));
                }
                               
                //End code changes as part of ODDS-12213 Epoi AU
                
                
                //End


                //BEGIN DSUNEEL 11-April-19 AU PL MMP
                if(applicationMap.get(ap.Application__c).Brand_Country__c != 'NZ' && ap.Total_Net_Debt_Amount__c != null){
                   applicationMap.get(ap.Application__c).Total_Net_Debt_Amount__c = ap.Total_Net_Debt_Amount__c;
                 }
                //END DSUNEEL 11-April-19 AU PL MMP
                
               
                
                //BEGIN DSUNEEL POI Automation 05/02/2021
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                  applicationMap.get(ap.Application__c).EVerifier_Alert_Applicant_1__c = ap.EVerifier_Alert_Applicant_1__c;
                 }
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                  applicationMap.get(ap.Application__c).EVerifier_Alert_Applicant_2__c = ap.EVerifier_Alert_Applicant_2__c;
                 }
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){                 
                  applicationMap.get(ap.Application__c).EVerifier_Income_Applicant_1__c = ap.EVerifier_Income_Applicant_1__c;
                 }
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                  applicationMap.get(ap.Application__c).EVerifier_Income_Applicant_2__c = ap.EVerifier_Income_Applicant_2__c;
                 }
                  if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                  applicationMap.get(ap.Application__c).EVerifier_Request_Date_Applicant_1__c = ap.EVerifier_Request_Date_Applicant_1__c;
                 }
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                  applicationMap.get(ap.Application__c).EVerifier_Request_Date_Applicant_2__c = ap.EVerifier_Request_Date_Applicant_2__c;
                 }
                //END DSUNEEL POI Automation 05/02/2021
                
                
                

                //BEGIN MLASALA 19-SEPT-16 TQLQW-487 Promo engine
                if(!restartIndicator && 
                   !riskGradeMap.get(applicationMap.get(ap.Application__c).Id)){
                    
                    //flush promo messaging
                    applicationMap.get(ap.Application__c).Promo_Message__c = null;
                }
                //END MLASALA 19-SEPT-16 TQLQW-487 Promo engine
                
                //End Fahad Akhtar - 27/06/2016

                //Added by Mike Lasala 05/19/15 for calculation debugging
                Application__c tempApplication = applicationMap.get(ap.Application__c);

                //Added by Fel Saliba 12/02/2014
                //Populate Offer Fields
                applicationMap.put(ap.Application__c,GEN_OfferUtility.populateOfferFields(applicationMap.get(ap.Application__c),riskGradeMap.get(applicationMap.get(ap.Application__c).Id)));
                
                //Added by Mike Lasala 05/19/15 for calculation debugging
                debugLog.Calculation_Log__c += 'Class: GEN_OfferUtility\nMethod: populateOfferFields\n\n';
                debugLog.Calculation_Log__c += 'Offered_Interest_Rate__c: '+tempApplication.Offered_Interest_Rate__c+' --> '+applicationMap.get(ap.Application__c).Offered_Interest_Rate__c+'\n';
                debugLog.Calculation_Log__c += 'Adjusted_Interest_Rate__c: '+tempApplication.Adjusted_Interest_Rate__c+' --> '+applicationMap.get(ap.Application__c).Adjusted_Interest_Rate__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Interest_Rate_Orig__c: '+tempApplication.Offered_Interest_Rate_Orig__c+' --> '+applicationMap.get(ap.Application__c).Offered_Interest_Rate_Orig__c+'\n';
                debugLog.Calculation_Log__c += 'EMI_with_Service_Fee__c: '+tempApplication.EMI_with_Service_Fee__c+' --> '+applicationMap.get(ap.Application__c).EMI_with_Service_Fee__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Repayments__c: '+tempApplication.Offered_Repayments__c+' --> '+applicationMap.get(ap.Application__c).Offered_Repayments__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Frequency_Repayments__c: '+tempApplication.Offered_Frequency_Repayments__c+' --> '+applicationMap.get(ap.Application__c).Offered_Frequency_Repayments__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Repayments_Orig__c: '+tempApplication.Offered_Repayments_Orig__c+' --> '+applicationMap.get(ap.Application__c).Offered_Repayments_Orig__c+'\n';
                debugLog.Calculation_Log__c += 'Total_Loan_Interest_Amount_Payable__c: '+tempApplication.Total_Loan_Interest_Amount_Payable__c+' --> '+applicationMap.get(ap.Application__c).Total_Loan_Interest_Amount_Payable__c+'\n';
                debugLog.Calculation_Log__c += 'Total_Insurance_Interest_Amount_Payable__c: '+tempApplication.Total_Insurance_Interest_Amount_Payable__c+' --> '+applicationMap.get(ap.Application__c).Total_Insurance_Interest_Amount_Payable__c;
                debugLogList.add(debugLog);
                
                //Added as part of POI Automation phase 2
                
                Decimal verifierMMCapacity = ap.Max_Monthly_Capacity__c != null ? ap.Max_Monthly_Capacity__c : 0;
                Decimal verifierEmiServiceFee = applicationMap.get(ap.Application__c).EMI_with_Service_Fee__c != null ? applicationMap.get(ap.Application__c).EMI_with_Service_Fee__c : 0;
                system.debug('verifierEmiServiceFee$$$'+verifierEmiServiceFee);
                Decimal verifierRCapacity = verifierMMCapacity - verifierEmiServiceFee;
                
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.EVerifier_Income_Applicant_1__c != null && verifierRCapacity < 0){
                   applicationMap.get(ap.Application__c).isPOIVerifiedA2__c = true;
                 }else{
                   applicationMap.get(ap.Application__c).isPOIVerifiedA2__c = false;
                 }
                
                if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                            if(verifierRCapacity < 0){
                            applicationMap.get(ap.Application__c).isRemainingCapacityNegative__c = true;
                            }else{
                            applicationMap.get(ap.Application__c).isRemainingCapacityNegative__c = false;
                            }
                }
                if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                 if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && applicationMap.get(ap.Application__c).Application_Type__c == 'Single'){
                if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && verifierRCapacity > 0 && ap.EVerifier_Income_Applicant_1__c != null && string.isBlank(ap.EVerifier_Alert_Applicant_1__c) && (IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My permanent - full time job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c || IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My permanent - part time job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c  || IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My contracting job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c || IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My self-employed business' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c))
                {
                        if(IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My permanent - full time job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c){
                        IncomeCapMap.get(ap.Application__c).Employment_Type__c = 'Permanent Full Time';
                        }
                        if(IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My permanent - Part time job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c){
                        IncomeCapMap.get(ap.Application__c).Employment_Type__c = 'Permanent Part Time';
                        }                         
                        if(IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My contracting job' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c){
                        IncomeCapMap.get(ap.Application__c).Employment_Type__c = 'Fixed Term Contract';
                        }                        
                        if(IncomeCapMap.get(ap.Application__c).Income_Detail__c == 'My self-employed business' + ' ' +IncomeCapMap.get(ap.Application__c).Income__r.Emp_Bus_Name__c){
                        IncomeCapMap.get(ap.Application__c).Employment_Type__c = 'Self Employed';
                        }
                        IncomeCapMap.get(ap.Application__c).Method_of_Verification__c = 'Verifier';  
                        IncomeCapMap.get(ap.Application__c).Income_1__c = ap.EVerifier_Income_Applicant_1__c;
                        IncomeCapMap.get(ap.Application__c).Frequency_of_Payment__c = 'Monthly';
                        IncomeCapMap.get(ap.Application__c).Method_of_Calculation__c = 'Net Income';
                        IncomeCapMap.get(ap.Application__c).Income_1_DD__c = ap.EVerifier_Request_Date_Applicant_1__c;
                        IncomeCapMap.get(ap.Application__c).Minimum_Income_Used__c= ap.EVerifier_Income_Applicant_1__c;
                        IncomeCapMap.get(ap.Application__c).Annualised_Net_Income__c= ap.EVerifier_Income_Applicant_1__c * 12;
                        IncomeCapMap.get(ap.Application__c).Annualised_Net_Income_per_Month__c= ap.EVerifier_Income_Applicant_1__c;                    
                        IncomeCapMap.get(ap.Application__c).Overtime_Shift_Allowance__c='No';                       
                        applicationMap.get(ap.Application__c).out_of_sync__c = false;

                   IncomeCapListUpdate.add(IncomeCapMap.get(ap.Application__c));
                   System.debug('IncomeCapListUpdate$$$'+IncomeCapListUpdate);
                
                }
                }
                //Join Applicant
                if(applicationMap.get(ap.Application__c).Application_Type__c == 'Joint' && applicationMap.get(ap.Application__c).Brand_Country__c == 'AU'){
                Map<Id, List<Income_Capacity__c>> mapAcctIdContactList = new Map<Id, List<Income_Capacity__c>>();
                List<Income_Capacity__c> listContact = [SELECT Id, income__r.Applicant__c FROM Income_Capacity__c where Income__r.Applicant__r.Application__c=:applicationMap.get(ap.Application__c).Id];
                List<Id> keyList ;
                for(Income_Capacity__c con : listContact) {
                    if(String.isNotBlank(con.income__r.Applicant__c)){
                        if(!mapAcctIdContactList.containsKey(con.income__r.Applicant__c)) {
                            mapAcctIdContactList.put(con.income__r.Applicant__c, new List<Income_Capacity__c>());
                        }
                        mapAcctIdContactList.get(con.income__r.Applicant__c).add(con);                      
                        set<Id> keys = mapAcctIdContactList.KeySet();
                        keyList = new List<Id>();
                        keyList.addAll(keys);         
                    }
                    
                }
                // Applicant 1 - Joint Applicant 
                 
                                      ictyList = [SELECT Id, Income__r.Applicant__r.POI_Financial_Situation_Verified__c,Income_Detail__c,Income__r.Emp_Bus_Name__c,Income_1_DD__c,Income_1__c, Is_e_POI__c, 
                                        Income__c,Income__r.Applicant__r.Primary_Employment_Status__c,Income__r.Applicant__r.Application__c,
                                        Method_of_Verification__c,Employment_Type__c,Overtime_Shift_Allowance__c,Frequency_of_Payment__c,
                                        Method_of_Calculation__c,Minimum_Income_Used__c,Annualised_Net_Income__c,Annualised_Net_Income_per_Month__c,
                                        Rental_Income_per_ppty_owners__c,Gross_YTD__c,Net_YTD__c,Less_Tax__c,Annualised_Gross_Income__c,Net_Monthly_Income__c,
                                        Gross_Annualised_per_annum__c,Gross_Annualised_per_month__c,EQUALS_ADJUSTED_INCOME__c,ADJUSTED_INCOME_YEARLY__c,Income__r.Applicant__r.Application__r.out_of_sync__c
                                        FROM 
                                        Income_Capacity__c 
                                        WHERE 
                                        Income__r.Applicant__c =: keyList[0]];                                                                                
                                        
                                        for(Income_Capacity__c icty: ictyList){
                                        
                                       if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.EVerifier_Income_Applicant_1__c != null && string.isBlank(ap.EVerifier_Alert_Applicant_1__c) && (icty.Income_Detail__c == 'My permanent - full time job' + ' ' +icty.Income__r.Emp_Bus_Name__c || icty.Income_Detail__c == 'My permanent - part time job' + ' ' +icty.Income__r.Emp_Bus_Name__c  || icty.Income_Detail__c == 'My contracting job' + ' ' +icty.Income__r.Emp_Bus_Name__c || icty.Income_Detail__c == 'My self-employed business' + ' ' +icty.Income__r.Emp_Bus_Name__c))
                                            {
                                                    System.debug('Size of Income List$$$ '+ictyList.size());
                                                    if(icty.Income_Detail__c == 'My permanent - full time job' + ' ' +icty.Income__r.Emp_Bus_Name__c){
                                                    icty.Employment_Type__c = 'Permanent Full Time';                                                    
                                                    }if(icty.Income_Detail__c == 'My permanent - Part time job' + ' ' +icty.Income__r.Emp_Bus_Name__c){
                                                    icty.Employment_Type__c = 'Permanent Part Time';                                                  
                                                    }
                                                    if(icty.Income_Detail__c == 'My contracting job' + ' ' +icty.Income__r.Emp_Bus_Name__c){
                                                    icty.Employment_Type__c = 'Fixed Term Contract';
                                                    }                                                    
                                                    if(icty.Income_Detail__c == 'My self-employed business' + ' ' +icty.Income__r.Emp_Bus_Name__c){
                                                    icty.Employment_Type__c = 'Self Employed';
                                                    }
                                                    icty.Method_of_Verification__c = 'Verifier';  
                                                    icty.Income_1__c = ap.EVerifier_Income_Applicant_1__c;
                                                    icty.Frequency_of_Payment__c = 'Monthly';
                                                    icty.Method_of_Calculation__c = 'Net Income';
                                                    icty.Income_1_DD__c = ap.EVerifier_Request_Date_Applicant_1__c;
                                                    icty.Minimum_Income_Used__c= ap.EVerifier_Income_Applicant_1__c;
                                                    icty.Annualised_Net_Income__c= ap.EVerifier_Income_Applicant_1__c * 12;
                                                    icty.Annualised_Net_Income_per_Month__c= ap.EVerifier_Income_Applicant_1__c;                    
                                                    icty.Overtime_Shift_Allowance__c='No';
                                                   // icty.Income__r.Applicant__r.Application__r.out_of_sync__c = false;
                                               JointIncomeCapListUpdate1.add(icty);
                                            
                                               system.debug('JointIncomeCapListUpdate1$$$'+JointIncomeCapListUpdate1);
                                            
                                            }
                                            
                                               if(ictyList.size() > 0 && icty.Method_of_Verification__c == 'Verifier' && verifierRCapacity < 0){
                                                    icty.Employment_Type__c = '';
                                                    icty.Method_of_Verification__c='';
                                                    icty.Method_of_Calculation__c ='';
                                                    icty.Frequency_of_Payment__c ='';  
                                                    icty.Annualised_Net_Income_per_Month__c = 0.0;  
                                                    //Added as part of fix 
                                                    update ictyList;                                
                                                 }   
                                                /**  if(ictyList.size() > 0){
                                                     update ictyList;
                                                  }  */                                         
                                        }
                     jointincomeList = [select id,Applicant__c from Income__c where Applicant__c =: keyList[0]];

                           //Applicant 2 - Joint Applicant
                           
                                        ictyList2 = [SELECT Id,Income__r.Applicant__r.POI_Financial_Situation_Verified__c,Income_Detail__c,Income__r.Emp_Bus_Name__c,Income_1_DD__c,Income_1__c, Is_e_POI__c, 
                                        Income__c,Income__r.Applicant__r.Primary_Employment_Status__c,Income__r.Applicant__r.Application__c,
                                        Method_of_Verification__c,Employment_Type__c,Overtime_Shift_Allowance__c,Frequency_of_Payment__c,
                                        Method_of_Calculation__c,Minimum_Income_Used__c,Annualised_Net_Income__c,Annualised_Net_Income_per_Month__c,
                                        Rental_Income_per_ppty_owners__c,Gross_YTD__c,Net_YTD__c,Less_Tax__c,Annualised_Gross_Income__c,Net_Monthly_Income__c,
                                        Gross_Annualised_per_annum__c,Gross_Annualised_per_month__c,EQUALS_ADJUSTED_INCOME__c,ADJUSTED_INCOME_YEARLY__c,
                                        Income__r.Applicant__r.Application__r.out_of_sync__c
                                        FROM 
                                        Income_Capacity__c 
                                        WHERE 
                                        Income__r.Applicant__c =: keyList[1]];
                                        
                                        for(Income_Capacity__c icty2: ictyList2){
                                        
                                       if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && ap.EVerifier_Income_Applicant_2__c != null && String.isBlank(ap.EVerifier_Alert_Applicant_2__c) && (icty2.Income_Detail__c == 'My permanent - full time job' + ' ' +icty2.Income__r.Emp_Bus_Name__c || icty2.Income_Detail__c == 'My permanent - part time job' + ' ' +icty2.Income__r.Emp_Bus_Name__c  || icty2.Income_Detail__c == 'My contracting job' + ' ' +icty2.Income__r.Emp_Bus_Name__c || icty2.Income_Detail__c == 'My self-employed business' + ' ' +icty2.Income__r.Emp_Bus_Name__c ))
                                            {
                                                    if(icty2.Income_Detail__c == 'My permanent - full time job' + ' ' +icty2.Income__r.Emp_Bus_Name__c){
                                                    icty2.Employment_Type__c = 'Permanent Full Time';
                                                    }if(icty2.Income_Detail__c == 'My permanent - Part time job' + ' ' +icty2.Income__r.Emp_Bus_Name__c){
                                                    icty2.Employment_Type__c = 'Permanent Part Time';
                                                    }
                                                    if(icty2.Income_Detail__c == 'My contracting job' + ' ' +icty2.Income__r.Emp_Bus_Name__c){
                                                    icty2.Employment_Type__c = 'Fixed Term Contract';
                                                    }                                                    
                                                    if(icty2.Income_Detail__c == 'My self-employed business' + ' ' +icty2.Income__r.Emp_Bus_Name__c){
                                                    icty2.Employment_Type__c = 'Self Employed';
                                                    }
                                                    icty2.Method_of_Verification__c = 'Verifier';  
                                                    icty2.Income_1__c = ap.EVerifier_Income_Applicant_2__c;
                                                    icty2.Frequency_of_Payment__c = 'Monthly';
                                                    icty2.Method_of_Calculation__c = 'Net Income';
                                                    icty2.Income_1_DD__c = ap.EVerifier_Request_Date_Applicant_2__c;
                                                    icty2.Minimum_Income_Used__c= ap.EVerifier_Income_Applicant_2__c;
                                                    icty2.Annualised_Net_Income__c= ap.EVerifier_Income_Applicant_2__c * 12;
                                                    icty2.Annualised_Net_Income_per_Month__c= ap.EVerifier_Income_Applicant_2__c;                    
                                                    icty2.Overtime_Shift_Allowance__c='No';
                                                   // icty2.Income__r.Applicant__r.Application__r.out_of_sync__c = false;
                                               JointIncomeCapListUpdate2.add(icty2);
                                               
                                               system.debug('JointIncomeCapListUpdate2$$$'+JointIncomeCapListUpdate2);
                                            
                                            }
                                            
                                            if(ictyList2.size() > 0 && icty2.Method_of_Verification__c == 'Verifier' && verifierRCapacity < 0){
                                                    icty2.Employment_Type__c = '';
                                                    icty2.Method_of_Verification__c='';
                                                    icty2.Method_of_Calculation__c ='';
                                                    icty2.Frequency_of_Payment__c =''; 
                                                    icty2.Annualised_Net_Income_per_Month__c = 0.0; 
                                                    //Added as part of fix
                                                    update ictyList2;                                                                                                                            
                                                 }  
                                                /**  if(ictyList2.size() > 0){
                                                     update ictyList2;
                                                  } */ 
                                        }
                                        
          jointincomeList1 = [select id,Applicant__c from Income__c where Applicant__c =: keyList[1]];

 
                          }
                          
                          }
                //End of Joint Applicant

                //add the application in a list for update
                applicationListToUpdate.add(applicationMap.get(ap.Application__c));
            //}
             
             
             
            if(applicationMap.get(ap.Application__c).Brand_Country__c == 'AU' && applicationMap.get(ap.Application__c).Application_Type__c == 'Single'){
    
             List<Income_Capacity__c> icList = [SELECT Id, Income__r.Applicant__r.POI_Financial_Situation_Verified__c,Income_1__c, Income_1_DD__c, Is_e_POI__c, 
                                        Income__c,Income__r.Applicant__r.Primary_Employment_Status__c,Income__r.Applicant__r.Application__c,
                                        Method_of_Verification__c,Employment_Type__c,Overtime_Shift_Allowance__c,Frequency_of_Payment__c,
                                        Method_of_Calculation__c,Minimum_Income_Used__c,Annualised_Net_Income__c,Annualised_Net_Income_per_Month__c,
                                        Rental_Income_per_ppty_owners__c,Gross_YTD__c,Net_YTD__c,Less_Tax__c,Annualised_Gross_Income__c,Net_Monthly_Income__c,
                                        Gross_Annualised_per_annum__c,Gross_Annualised_per_month__c,EQUALS_ADJUSTED_INCOME__c,ADJUSTED_INCOME_YEARLY__c
                                        FROM 
                                        Income_Capacity__c 
                                        WHERE 
                                        Income__r.Applicant__r.Application__c IN: applicationId];
                                        
                                        for(Income_Capacity__c icap : icList){
                                        
                                         if(icList.size() > 0 && icap.Method_of_Verification__c == 'Verifier' && verifierRCapacity < 0){
                                            icap.Employment_Type__c = '';
                                            icap.Method_of_Verification__c='';
                                            icap.Method_of_Calculation__c ='';
                                            icap.Frequency_of_Payment__c ='';
                                            icap.Annualised_Net_Income_per_Month__c = 0.0; 
                                           update icList;
                                         }
                                         
                                        }
                                       /** if(icList.size() > 0){
                                        update icList;
                                        } */
                                        
                                }   
        }

        //BEGIN MLASALA: 08/10/15 - UNLOCKING AUTO LOAN TEMPLATE ISSUE
        //Moved block of code here to avoid referencing of old list
        AUT_BenjiRulesUtility autoRule = new AUT_BenjiRulesUtility();
        //Modified by Fsaliba 1/15/2015 - benjiRulesValidation method is accepting List
        //Run rules only in Update and Doc Gen
        List<Application__c> aList = new List<Application__c>();
        for(Application__c a : applicationList){
            if(a.Type_of_Product__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN &&
              (a.Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_UPDATE
              || a.Last_Webservice_Operation_Invoked__c == GEN_OriginationsConstants.SERVICENAME_GENERATEDOCUMENT)){
              aList.add(a);
            } 
            System.debug('*** Product Name ' + a.Type_of_Product__c + 'Last Web Service Operation ' + a.Last_Webservice_Operation_Invoked__c);             
        }
        System.debug('Size of List ' + aList.size());
        //END MLASALA: 08/10/15 - UNLOCKING AUTO LOAN TEMPLATE ISSUE
        // Added by Adrian Recio 11/6/2015
        // Sync latest GE Unique Id to Opportunity
        // Note: This approach is necessary even if the opportunity has a lookup to application.
        // Formula field is not used in the text field in opportunity since application number can come from
        // different sources aside from the parent application of opportunity.
        if(geUniquePopMap.size()>0){

          List<Opportunity> oppSyncList = [Select Application__c from Opportunity where Application__c In :geUniquePopMap.keySet()];
          for(Opportunity oppVar: oppSyncList){
            string geUniqueIdStr = geUniquePopMap.get(oppVar.Application__c);
            oppVar.Application_Number__c = geUniqueIdStr;
          } 

          Map<Id,Opportunity>oppSyncMap = new Map<Id,Opportunity>();
          oppSyncMap.putAll(oppSyncList);

          List<Task>relatedTask = [Select whatId, Application_Number__c from Task where whatId In :oppSyncMap.keySet()]; 

          for(Task tskVar: relatedTask){
            Opportunity oppParentVar = oppSyncMap.get(tskVar.WhatId);
            tskVar.Application_Number__c = oppParentVar.Application_Number__c;
          }

          try{
            // Update Opportunity
            update oppSyncList;
            // Update Task
            update relatedTask;
          }catch(DMLException e){
              ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Debug_Log__c', 'Class');
          }
        }
        
        //Added by Fel Saliba 20/01/2014
        //check if there are applications to reset
        if(appToReset.size()>0){            
            GEN_OfferUtility.flushOffers(appToReset);
        }
        //Added by Fel Saliba 23/06/2014
        //check if there are applications product items to recalculate
        if(appToRecalculate.size()>0){            
            GEN_OfferUtility.flushApplicant2(appToRecalculate);
        }
        
        //check the list size prior update
        if(applicationListToUpdate.size() > 0){
            System.debug('applicationListToUpdate-->'+applicationListToUpdate);
            update applicationListToUpdate;
        }
        
       //Added as part of ODDS-12213
        if(!IncomeCapListToUpdate.isEmpty()){
            System.debug('IncomeCapListToUpdate-->'+IncomeCapListToUpdate);
            update IncomeCapListToUpdate;
        }
        
        //Added as part of POI Automation phase 2
        if(!IncomeCapListUpdate.isEmpty() && (incomeList.size() > 0 &&  incomeList .size() < 2)){
        //if(!IncomeCapListUpdate.isEmpty()){
            System.debug('IncomeCapListUpdate-->'+IncomeCapListUpdate);
            update IncomeCapListUpdate;
        } 
        
       
        if(!JointIncomeCapListUpdate1.isEmpty() && jointincomeList.size() > 0 && jointincomeList.size() < 2){
            update JointIncomeCapListUpdate1;
        }
        if(!JointIncomeCapListUpdate2.isEmpty() && jointincomeList1.size() > 0 && jointincomeList1.size() < 2){
            update JointIncomeCapListUpdate2;
        }
       /* if(!JointIncomeCapListUpdate.isEmpty()){
        update JointIncomeCapListUpdate;
        } */

        //End

        //Process List of applicaiton for Benji Rule and update application.
        if(aList.size() > 0)
            List<IS_ValidationError> tempList = autoRule.benjiRulesValidation(aList);

        //check the list size prior update
        if(!exLogsToInsert.isEmpty()){
            System.debug('exLogsToInsert-->'+exLogsToInsert);
            try {
                insert exLogsToInsert;
            }
            Catch(Exception e) {
                //exception log failure should not prevent completion of method
                System.debug('Exception Log Insert Failed - ' + e);
            }
        }

        //Added by Mike Lasala 05/19/15 for calculation debugging
        if(!debugLogList.isEmpty()){
            try{
                insert debugLogList;
            } catch(DMLException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Debug_Log__c', 'Class');
            }
        }
    }

    /*  Description: Insert decisions that is compared response code with the custom setting Response_Code_Control__c.Decision__c
     *  Author: Jade Serrano
     *  Date Created: 16-Dec-2013
     *  Input Parameters: List<Application_Response__c>
     *  Return: void
     */
    public void createDecision(List<Application_Response__c> appResList){
        List<Decision__c> dList = new List<Decision__c>();
        String[] resDes;

        for(Application_Response__c a: appResList){
            if(a.Application__c!=null && a.Response_Code__c!=null && a.Response_Description__c!=null){
                String b = a.Response_Description__c;
                resDes = b.split(';');
                for(String c: resDes){
                    String[] d = c.split('\\|');
                    String e = d[0].substring(d[0].length()-1,d[0].length());
                    if(e=='M'){
                        Decision__c dec = new Decision__c();
                        dec.Application__c = a.Application__c;
                        dec.Response_Code__c = a.Response_Code__c;
                        dec.NBSM_Code__c = d[0];
                        dec.Response_Description__c = d[1];
                        dec.Clearance__c = 'Manual';
                        dList.add(dec);
                    }
                }
            }
        }

        if(dList.size()>0){
            insert dList;
        }
    }

    /*  Description: Update Application Response Code
     *  Author: Mac Domingo
     *  Date Created: 10-Feb-2014
     *  Input Parameters: Application Response
     *  Return: Application
     */
    public void updateApplication(Map<Id, String> appResMap){        
        Set<Id> appId = new Set<Id>();
        map<string,IDV_Action_Settings__c> idvAction=IDV_Action_Settings__c.getall();
        List<Application__c> appList = new List<Application__c>();
        appId = appResMap.keySet();
        appList = [Select Id, Response_Code__c,personal_loan_form_IDV__c from Application__c where Id IN :appId];
        System.debug('**** appList ' + appList.size());
        if(appList.size() > 0){
            for(Application__c a : appList){
                a.Response_Code__c = appResMap.get(a.Id);
                a.personal_loan_form_IDV__c= idvAction.containsKey(a.Response_Code__c)?idvAction.get(a.Response_Code__c).personal_loan_form_IDV__c:false;
            }
            try{
                System.debug('#### appList ' + appList);
                update appList;
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Application__c', 'Class');
            }
        }          
    }

    /*  Description: Update Application Response Code
     *  Author: Mike Lasala
     *  Date Created: 28-Apr-2014
     *  Input Parameters: Application Ids
     *  Return: None
     */
    public void flushDecisions(Set<String> applicationIds){
        List<Decision__c> decisionList = new List<Decision__c>();

        decisionList = [SELECT  Id 
                        FROM    Decision__c 
                        WHERE   Action__c = false
                        AND     Application__c IN: applicationIds ];

        if(!decisionList.isEmpty()){
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Decision__c.sObjectType.getDescribe().isDeletable()){
                    delete decisionList;
                }
                */
                delete decisionList;
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Decision__c', 'Class');
            }
        }
    }
    
    //BEGIN MLASALA: 26-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    /*  Description: Update Application Response Code
     *  Author: Mike Lasala
     *  Date Created: 26-NOV-2015
     *  Input Parameters: Application Ids
     *  Return: None
     */
    public void flushCLVs(Set<String> applicationIds){

        //Afreen - May-13-2016 - Updated for CLV issue for Fix Pack 3
        Set<Id> applicationIdsToUpdate = new Set<Id>();
        
        //Retrieve applicants and child applicant clvs
        List<Applicant__c> applicantList = [SELECT Id, Application__c, (SELECT Id FROM Applicants_CLV__r) FROM Applicant__c WHERE Application__c IN: applicationIds];


        
        if(!applicantList.isEmpty()){
            
            List<Applicant_CLV__c> applicantCLVList = new List<Applicant_CLV__c>();
            
            for(Applicant__c a: applicantList){
                applicationIdsToUpdate.add(a.Application__c); // May-13-2016 -Afreen Updated for CLV issue for Fix Pack 3
                
                for(Applicant_CLV__c ac: a.Applicants_CLV__r){
                    
                    //Set applicant lookup to null to preserve clv search history
                    ac.Applicant__c = null;
                    applicantCLVList.add(ac);
                }
            }
            
            if(!applicantCLVList.isEmpty()){
                
                try{
                    update applicantCLVList;
                }
                catch(Exception e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Applicant_CLV__c', 'Class');
                }
            }

            // May-13-2016 -Afreen Setting the application restrted flag to true
            if(!applicationIdsToUpdate.isEmpty()){
                List<Application__c> apptoupdateRestartFlag = [Select Id, Application_Restarted__c From Application__c where Id in : applicationIdsToUpdate];
                for(Application__c app : apptoupdateRestartFlag){
                    app.Application_Restarted__c = true;
                }

                try{
                    update apptoupdateRestartFlag;
                }
                catch(Exception e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'AppResponseTriggerHandler', 'Application__c', 'Class');
                }

            }
        }
        //END MLASALA: 26-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    }

    /*  Description: Flush the Insurance offer with teh chnage in employment status which triggered the NBSM flag change
     *  Author: Afreen Khan
     *  Date Created: Sept-16-2016
     *  Return: None
     */
     @testVisible
    private static void flushInsuranceOffersOnNBSMFlagChange(Application__c app, Application_Response__c appResponse, List<Application__c> appToReset, List<Debug_Log__c> debugLogList){
        //BEGIN MLASALA 11-OCT-16 Added checking of insurance and joint application type
        if(app.Total_Insurance_Premium__c != null && 
           app.Total_Insurance_Premium__c != 0 && 
           ((app.Insurance_Eligibility_Flag_Applicant_1__c != null && 
             app.Insurance_Eligibility_Flag_Applicant_1__c != 0 && 
             app.Insurance_Eligibility_Flag_Applicant_1__c != appResponse.Insurance_Eligibility_Flag_Applicant_1__c) || 
            (app.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT &&
             app.Insurance_Eligibility_Flag_Applicant_2__c != null && 
             app.Insurance_Eligibility_Flag_Applicant_2__c != 0 && 
             appResponse.Insurance_Eligibility_Flag_Applicant_2__c != app.Insurance_Eligibility_Flag_Applicant_2__c))){
            //END MLASALA 11-OCT-16 Added checking of insurance and joint application type    
            
            appToReset.add(app);

            //Populate insurance info message
            app.Insurance_Error_Message__c = util.updateInsuranceInfoMessage(app.Id, app.Insurance_Error_Message__c, GEN_OriginationsConstants.NBSM_FLAG_CHANGE_INSURANCE_INFO_MESSAGE);
            System.debug('@@@@ Insurance Error Message'+ app.Insurance_Error_Message__c);
            debugLogList.add(Util.createInsuranceActivity(app.Id, 'Flush', GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 'System', app.Total_Insurance_Premium__c, 0));

            //Set total insurance premium = 0
            app.Total_Insurance_Premium__c = 0;
            
            //Set out of sync = true
            app.out_of_sync__c = true;

        }       
    }
}