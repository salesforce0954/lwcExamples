/* 
 * @Author: Fel Saliba
 * @Company: Cloud Sherpas
 * @Description: Service for creating a shell Origination Application 
                 with Applicant and other related Objects for Leads
                 with 60 Day Certificate Eligibility
 * @History:
   =====================================================================
       20-11-14: Created - Fel
       20-11-14: Updated - Adrian : Added catch condition to no populate applicant search if empty
   =====================================================================
 */
 
//public without sharing class SixtyDaysCertService implements ApprovedCampaignInterface{
global without sharing class SixtyDaysCertService {
    
    /* 
    *  Description: Sixty Day Cert Creation Respons Wrapper
    *  Author: Adrian Recio
    *  Input Parameters: 
    *  Return: 
    */
    global class sixtyDayCertResponse{
        public string appId{get; set;}
        public string response{get; set;}
        public sixtyDayCertResponse(string appIdPar, string responsePar){
            appId = appIdPar;
            response = responsePar;
        }
    }
    
    /* 
    *  Description: Create Originations Application with Applicant and other related Objects
    *  Author: Fel Saliba
    *  Input Parameters: Opporutunity
    *  Return: String - applicationId
    */
    public SixtyDaysCertService.sixtyDayCertResponse createApplication(string oppRecordId){
     
       Savepoint sp = Database.setSavepoint();
       SixtyDaysCertService.sixtyDayCertResponse responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'');
       Opportunity eligibleOpp = new Opportunity();
       
       try{ 
           // Pull opportunity information
           if(oppRecordId != null && oppRecordId != ''){
                //Build query string
                String query = 'SELECT ';
                
                //Add fields from field set
                for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.Opportunity_Commons.getFields()) {
                    query += f.getFieldPath() + ',';
                }
                query += 'Campaign.Promotional_Campaign__c,';
            
                //Trim last comma
                query = query.subString(0, query.length() - 1);
    
                //Build object source and filter recordId parameter
                query += ' FROM Opportunity WHERE Id =: oppRecordId';
                
                //Retrieve record
                eligibleOpp = Database.query(query);
           }else{
                responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'Invalid opportunity value.');
                return responseVar;
           }
  
           //Build query String to retrieve old Application
           String queryApp = generateQueryString('Application__c', 'Contract_Account_Number__c = \''+eligibleOpp.Account_Number__c+'\'');   
           system.debug('Sixty Day Cert App Query:' + queryApp);                        
           List<Application__c> appList = Database.query(queryApp);

           // Added by Adrian Recio
           // CVP3 Fix pack
           // Special query to pull formula fields and non creatable fields in the old 60 dc app.
           List<Application__c> oldAppNonCreateFields = [Select Id, Brand_Country__c 
                                                         From Application__c 
                                                         where Contract_Account_Number__c=:eligibleOpp.Account_Number__c];

           Application__c oldApp;
           if(appList != null && appList.size()==1){
               oldApp = appList.get(0);
               Decimal remainingCapacity;
               
               if(oldApp.Max_Monthly_Capacity__c==null){
                    oldApp.Max_Monthly_Capacity__c = 0;
               }
               
               if(oldApp.Max_Monthly_Capacity__c!=null && (oldApp.EMI_with_Service_Fee__c == 0 || oldApp.EMI_with_Service_Fee__c == null)){
                    remainingCapacity = oldApp.Max_Monthly_Capacity__c;
               }else{
                    try{
                        remainingCapacity = oldApp.Max_Monthly_Capacity__c - oldApp.EMI_with_Service_Fee__c;
                    }catch(exception e){
                        system.debug('Remaining Capacity Calc Error:' + string.valueOf(e));
                        remainingCapacity = 0;
                    }
               }
               
               system.debug('Remaining Capacity:' + remainingCapacity);
               if(remainingCapacity<40 && oldAppNonCreateFields.get(0).Brand_Country__c == 'NZ'){
                    responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'Application match is invalid with remaining capacity of less than 40.');
                    return responseVar;
               }

               if(remainingCapacity<1 && oldAppNonCreateFields.get(0).Brand_Country__c == 'AU'){
                    responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'Application match is invalid with remaining capacity of less than 1.');
                    return responseVar;
               }
           }
           
           system.debug('OldApp60Days:' + oldApp);
           if(oldApp != null){
           
               //****************************Application Record***************************
               //Clone the old Application                              
               Application__c newApp = oldApp.Clone(false, true); 
               
               system.debug('Clone Original Owner:' + newApp.OwnerId);
               
               // Flush Adjusted interest rate flag // CVP 3 fix pack item // Updated by: Adrian Recio
               newApp.Adjusted_Interest_Rate_Locked__c = false;

               // New Application Owner
               newApp.OwnerId = UserInfo.getUserId();
               system.debug('Clone New Owner:' + newApp.OwnerId);
               
               // Populate Status
               newApp.Status__c = 'New';

               // Set Response code to cloning to avoid response code validation.
               newApp.Response_Code__c = 'Clone';

               // Set zero values
               newApp.Offered_Establishment_Fee__c = 0;
               
               // Populate values from opportunity
               newApp.Opportunity__c = eligibleOpp.Id; 
               newApp.Promotional_Campaign__c = eligibleOpp.Campaign.Promotional_Campaign__c;
               newApp.Promo_Loan_Offer_Amount__c = eligibleOpp.Promo_Loan_Offer_Amount__c;
               newApp.ICBS_Account_Number__c = eligibleOpp.Account_Number__c;
               try{
               if(eligibleOpp.Contract_Date__c!=null){
                    string year = string.valueOf(eligibleOpp.Contract_Date__c.year());
                    string month = string.valueOf(eligibleOpp.Contract_Date__c.month());
                    string day = string.valueOf(eligibleOpp.Contract_Date__c.day());
                    string hour = '0';
                    string minute = '0';
                    string second = '0';
                    string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' 
                                        + minute +  ':' + second;
                    Datetime dt = Datetime.valueOf(stringDate);
                   newApp.Initial_Submit_Date__c = dt;
               }
               }catch(exception e){
                system.debug('Initial Submit Date Assignment Error:' + string.valueOf(e));
               }

               // Flush Contract Account Numberp
               newApp.Contract_Account_Number__c = null;
              
              // Channel - default channel to sales
              newApp.Channel__c = GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES;

              // Set previous App No. with the GE Unique Id
              newApp.Previous_App_No__c = newApp.UID__c;

               // Empty Main and default product eligibility fields
               // This fields are the fields visible in the product eligibilit page
               
               newApp.UID__c = null;
               /*
               newApp.Brand_Lookup__c = null;                       // Product
               newApp.Type_of_Product__c = null;                    // Type
               newApp.Mirror__c = null;                             // Business Source
               */
               //Get all record types of Application__c object
               Map<ID,Schema.RecordTypeInfo> rt_Map = Application__c.sObjectType.getDescribe().getRecordTypeInfosById();

               if(rt_map.get(newApp.recordTypeID).getName().containsIgnoreCase('AU')){
                  newApp.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_60_DAY_CERTIFICATE_AU;    // Application Type 
                  // Added by: Adrian Recio
                  // Description: This rate values should be flush and will be recalculated on submit for 60 day cert AU
                  // Date: 9/15/2016
                  newApp.Offered_Interest_Rate__c = null;
                  newApp.Adjusted_Interest_Rate__c = null;
                  newApp.Offered_Interest_Rate_Orig__c = null;
                }else{
                  newApp.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_60_DAY_CERTIFICATE;    // Application Type                  
                }
               
               //newApp.Branch__c = null;                           // Sales Team
               newApp.Settlement_Date__c = null;                    // Settlement Date
               
               // Empty Integration Information
               newApp.Submission_Status__c = 'Not Submitted';
               newApp.Last_Submit_Date__c = null;
               newApp.Last_Webservice_Operation_Invoked__c = null;
               newApp.Last_Webservice_Operation_Status__c = null;
               newApp.Final_Approved_Date__c = null;
               newApp.Response_Description__c = null;
               newApp.Out_Of_Sync__c = false;
               newApp.Generated_Doc_Confirm_Sent__c = false;
               newApp.Error_Response_Code__c = null;
               
               // Empty iOvation 
               newApp.iOvation_Type__c = null;
               newApp.Fingerprint_Step__c = null;
               newApp.FP_IP_Address__c = null;
               
               // Flush Application Submit Decision Values - This are the values in the left sidebar in app main page
               
               newApp.Total_Loan_Amount__c = 0;             //Amount
               newApp.Loan_Term__c  = '';                   //Term
               newApp.EMI_with_Service_Fee__c = 0;          //Monthly Repayment
               //newApp.Offered_Interest_Rate__c = 0;       //Rate
               //newApp.Credit_Score__c = '';               //Score 
               //newApp.Max_Capacity_Unsecured__c = 0;      //Unsecured Limit
               //newApp.Max_Capacity_Secured__c = 0;        //Secured Limit
               newApp.Max_Monthly_Capacity__c = 0;          //Remaining Capacity
               newApp.EMI_with_Service_Fee__c = 0;          //Remaining Capacity
               newApp.Workflow_Status__c = null;            //Work flow status
               newApp.Is_Manager_Approved__c = false;       //Manager Approved
               
               //Flush to avoid validation for Total_Insurance_Premium_Rule in Application Object
               newApp.Total_Insurance_Premium__c = 0;
               
               // Flush connected Applicant 
               newApp.Applicant1__c = null;
               newApp.Applicant2__c = null;
        
               insert newApp;
               
               //****************************Applicant Record/s***************************
               //Query for the applicants
               String queryApplicants = generateQueryString('Applicant__c', 'Application__c = \''+ oldApp.Id+'\'');                             
               List<Applicant__c> oldApplicants = Database.query(queryApplicants);
               
               //Create Map to store the old and New Applicants
               Map<String, Applicant__c> oldNewApplicantMap = new Map<String, Applicant__c>();
               if(oldApplicants != null && oldApplicants.size()>1){
                   for(Applicant__c applicant: oldApplicants){
                       Applicant__c newApplicant = applicant.Clone(false,true);
                       newApplicant.Application__c = newApp.Id;
 
                       oldNewApplicantMap.put(applicant.Id, newApplicant);
                   }
               }
               else if(oldApplicants != null && oldApplicants.size()==1){                  
                   Applicant__c newApplicant = oldApplicants[0].Clone(false,true);
                   newApplicant.Application__c = newApp.Id;
                   oldNewApplicantMap.put(oldApplicants[0].Id, newApplicant);
               }
               
               if(oldNewApplicantMap != null){
                   insert oldNewApplicantMap.values();                  
               }
               
               // Populate Applicant Account to Application 

               
               //Believe it or not bind variables actually work in dynamic SOQL
               //Note that you can't embed method calls (e.g. Applicant__c IN: \''+ oldNewApplicantMap.keySet() 
               //would fail) when binding in this way. So I used set instead.
               Set<String> applicantIds = oldNewApplicantMap.keySet();
               
               //****************************AML Record/s***************************
               List<AML__c> insertAml = new List<AML__c>();
               //Query for the applicants AML
               //String queryAML = generateQueryString('Aml__c', 'Applicant__c IN: \''+ oldNewApplicantMap.keySet() +'\''); 
               String queryAML = generateQueryString('Aml__c', 'Applicant__c IN: applicantIds'); 
               system.debug('Sixty Day Cert AML Query String:' + queryAML);                                                    
               List<AML__c> oldAML = Database.query(queryAML); 
        
               if(oldAML != null && oldAML.size()>0){
                   for(AML__c aml:oldAML){
                       Aml__c newAML = aml.Clone(false,true);
                       newAML.Applicant__c = oldNewApplicantMap.get(aml.Applicant__c).Id;
                       insertAml.add(newAML);
                   }
               }
               
               //check for list size prior insert
               if(insertAml != null && insertAml.size()>0){
                   insert insertAML;
               }
               
               //****************************Asset Record/s***************************
               List<Asset__c> insertAssets = new List<Asset__c>();
               //Query for the applicants Asset
               String queryAsset = generateQueryString('Asset__c', 'Applicant__c IN: applicantIds');                               
               List<Asset__c> oldAssets = Database.query(queryAsset);
        
               if(oldAssets != null && oldAssets.size()>0){
                   for(Asset__c asset:oldAssets){
                       Asset__c newAsset = asset.Clone(false,true);
                       newAsset.Applicant__c = oldNewApplicantMap.get(asset.Applicant__c).Id;
                       insertAssets.add(newAsset);
                   }
               }
               //check for list size prior insert
               if(insertAssets != null && insertAssets.size()>0){
                   insert insertAssets;
               }
               
               //****************************Expense Record/s***************************
               List<Expense__c> insertExpenses = new List<Expense__c>();
               //Query for the applicants Expense
               String queryExpense = generateQueryString('Expense__c', 'Applicant__c IN: applicantIds');                                                         
               List<Expense__c> oldExpenses = Database.query(queryExpense);
        
               if(oldExpenses != null && oldExpenses.size()>0){
                   for(Expense__c exp:oldExpenses){
                       Expense__c newExpense = exp.Clone(false,true);
                       newExpense.Applicant__c = oldNewApplicantMap.get(exp.Applicant__c).Id;
                       insertExpenses.add(newExpense);
                   }
               }
               //check for list size prior insert
               if(insertExpenses != null && insertExpenses.size()>0){
                   insert insertExpenses;
               }
                            
               //****************************Income Record/s***************************
               //Query for the applicants Income
               String queryIncome = generateQueryString('Income__c', 'Applicant__c IN: applicantIds');                                                         
               List<Income__c> oldIncome = Database.query(queryIncome);
        
               //make Map for Income and Income Capacity Records 
               Map<String,Income__c> incomeAndIncomeCapacityMap = new Map<String,Income__c>();
               if(oldIncome != null && oldIncome.size()>0){
                   for(Income__c inc:oldIncome){
                       Income__c newIncome = inc.Clone(false,true);
                       newIncome.Applicant__c = oldNewApplicantMap.get(inc.Applicant__c).Id;
                      System.debug('** Income record ** '+ newIncome);
                       incomeAndIncomeCapacityMap.put(inc.Id,newIncome);
                       
                   }
               }
               //check for Map prior insert
               if(incomeAndIncomeCapacityMap != null){
                   //Make sure that Income clone will not auto create shell income capacity records
                   IncomeTriggerHandler.SixtyDayCertClone = true;
                   insert incomeAndIncomeCapacityMap.values();
               }
               Set<String> incomeIds = incomeAndIncomeCapacityMap.keySet();
               
               //****************************Income Capacity Record/s***************************
               List<Income_Capacity__c> insertIncCap = new List<Income_Capacity__c>();
               //Query for the Income Capacity
               String queryIncomeCapacity = generateQueryString('Income_Capacity__c', 'Income__c IN: incomeIds') ;                                                         
               List<Income_Capacity__c> oldIncomeCapacity = Database.query(queryIncomeCapacity);
        
               if(oldIncomeCapacity != null && oldIncomeCapacity.size()>0){
                   for(Income_Capacity__c incCapacity:oldIncomeCapacity){
                       Income_Capacity__c newIncomeCapacity = incCapacity.Clone(false,true);
                       newIncomeCapacity .Income__c = incomeAndIncomeCapacityMap.get(incCapacity.Income__c).Id;
                       insertIncCap.add(newIncomeCapacity);
                   }
               }
               //check for list size prior insert
               if(insertIncCap != null && insertIncCap.size()>0){
                   insert insertIncCap;
               }
               
               //****************************Liability Record/s***************************
               List<Liability__c> insertLiability = new List<Liability__c>();               
               //Query for the applicants Liability
               String queryLiability = generateQueryString('Liability__c', 'Applicant__c IN: applicantIds');                                                         
               List<Liability__c> oldLiability = Database.query(queryLiability);
        
               if(oldLiability != null && oldLiability.size()>0){
                   for(Liability__c l:oldLiability){
                       Liability__c newLiability = l.Clone(false,true);
                       newLiability.Applicant__c = oldNewApplicantMap.get(l.Applicant__c).Id;
                       insertLiability.add(newLiability);
                   }
               }
               //check for list size prior insert
               if(insertLiability != null && insertLiability.size()>0){
                   insert insertLiability;
               }
               
               //****************************Credit Ref Check Record/s***************************
               List<Credit_Ref_Check__c> insertCreditRefCheck = new List<Credit_Ref_Check__c>();   
               //Query for the Credit Ref Check 
               String queryCreditRef = generateQueryString('Credit_Ref_Check__c', 'Application__c = \''+ oldApp.Id +'\'');                                                         
               List<Credit_Ref_Check__c> oldCreditRef = Database.query(queryCreditRef);
        
               if(oldCreditRef != null && oldCreditRef.size()>0){
                   for(Credit_Ref_Check__c cr:oldCreditRef){
                       Credit_Ref_Check__c newCreditRef = cr.Clone(false,true);
                       newCreditRef.Application__c = newApp.Id;
                       insertCreditRefCheck.add(newCreditRef);
                   }
               }
               //check for list size prior insert
               if(insertCreditRefCheck != null && insertCreditRefCheck.size()>0){
                   insert insertCreditRefCheck;
               }
               
               //****************************Credit File Check Record/s***************************
               try{
                   List<Credit_File_Check__c> insertCreditFileCheck = new List<Credit_File_Check__c>();   
                   //Query for the Credit File Check 
                   String queryCreditFile = generateQueryString('Credit_File_Check__c', 'Application__c = \''+ oldApp.Id +'\'');                                                         
                   List<Credit_File_Check__c> oldCreditFile = Database.query(queryCreditFile);
            
                   if(oldCreditFile != null && oldCreditFile.size()>0){
                       for(Credit_File_Check__c cr:oldCreditFile){
                           
                           Credit_File_Check__c newCreditFile = cr.Clone(false,true);
                           newCreditFile.Application__c = newApp.Id;
                           
                           // Assign Parent Applicant
                           Applicant__c appMatch = oldNewApplicantMap.get(cr.Applicant__c);
                           newCreditFile.Applicant__c = appMatch.Id;
                           insertCreditFileCheck.add(newCreditFile);
                       }
                   }
                   //check for list size prior insert
                   if(insertCreditFileCheck != null && insertCreditFileCheck.size()>0){
                       insert insertCreditFileCheck;
                   }
               }catch(exception e){
                    system.debug('Credit File Check Creation Failed:' + string.valueOf(e));
               }
               
               //****************************Debit Record/s***************************
               // For removal
               /*
               List<Debit__c> insertDebit = new List<Debit__c>();
               //Query for the Debit 
               String queryDebit = generateQueryString('Debit__c', 'Application__c = \''+ oldApp.Id +'\'');                                                         
               List<Debit__c> oldDebit = Database.query(queryDebit);
               
               system.debug('Debit Match Count:' + oldDebit.size());
               
               if(oldDebit != null && oldDebit.size()>0){
                   for(Debit__c debit: oldDebit){
                       //Debit__c newDebit= debit.Clone(false,true);
                       Debit__c newDebit= new Debit__c();
                       newDebit.Application__c = newApp.Id;
                       newDebit.Account_Holders__c = debit.Account_Holders__c;
                       newDebit.Account_Number__c = debit.Account_Number__c;
                       newDebit.Bank_Name__c = debit.Bank_Name__c;
                       newDebit.Bank_Number__c = debit.Bank_Number__c;
                       newDebit.Branch_Location__c = debit.Branch_Location__c;
                       newDebit.Branch_Number__c = debit.Branch_Number__c;
                       newDebit.BSB_Number__c = debit.BSB_Number__c;
                       newDebit.Commencement_Date__c = debit.Commencement_Date__c;
                       newDebit.Frequency__c = debit.Frequency__c;
                       newDebit.Specify_Higher_Amount__c = debit.Specify_Higher_Amount__c;
                       newDebit.Repayment_Level__c  = debit.Repayment_Level__c;
                       newDebit.Suffix_Number__c = debit.Suffix_Number__c;
                       newDebit.Type__c = debit.Type__c;
                       insertDebit.add(newDebit);
                   }
               }
               //check for list size prior insert
               if(insertDebit!= null && insertDebit.size()>0){
                   insert insertDebit;
                   system.debug('Created Debit:' + insertDebit);
               }
               */
               
               //****************************Personal Reference Record/s***************************
               List<Personal_Reference_Check__c> insertPersonalRefCheck = new List<Personal_Reference_Check__c>();
               //Query for Personal Reference Check 
               String queryPRC = generateQueryString('Personal_Reference_Check__c', 'Application__c = \''+ oldApp.Id +'\'');                                                         
               List<Personal_Reference_Check__c> oldPRC = Database.query(queryPRC);
        
               if(oldPRC != null && oldPRC.size()>0){
                   for(Personal_Reference_Check__c prc: oldPRC ){
                       //Personal_Reference_Check__c newPRC= prc.Clone(false,true);
                       Personal_Reference_Check__c newPRC= new Personal_Reference_Check__c();
                       newPRC.Application__c = newApp.Id;
                       newPRC.Personal_Ref_Address__c = prc.Personal_Ref_Address__c;
                       newPRC.Country__c = prc.Country__c;
                       newPRC.Name__c = prc.Name__c;
                       newPRC.Phone_Number__c = prc.Phone_Number__c;
                       newPRC.Postcode__c = prc.Postcode__c;
                       newPRC.Property_Name__c = prc.Property_Name__c;
                       newPRC.Relationship__c = prc.Relationship__c;
                       newPRC.State__c = prc.State__c;
                       newPRC.Street_Name__c = prc.Street_Name__c;
                       newPRC.Street_Number__c = prc.Street_Number__c;
                       newPRC.Street_Type__c = prc.Street_Type__c;
                       newPRC.Suburb__c = prc.Suburb__c;
                       newPRC.Town_City__c = prc.Town_City__c;
                       newPRC.Unit_number__c = prc.Unit_number__c;
                       insertPersonalRefCheck.add(newPRC);
                   }
               }
               //check for list size prior insert
               if(insertPersonalRefCheck != null && insertPersonalRefCheck.size()>0){
                   insert insertPersonalRefCheck;
               }
               
               //****************************Security Record/s***************************
               /*
               List<Collateral__c> insertCollateral = new List<Collateral__c>();
               //Query for Security 
               String querySecurity = generateQueryString('Collateral__c', 'Application__c = \''+ oldApp.Id +'\'');                                                         
               List<Collateral__c> oldSecurity = Database.query(querySecurity);
        
               if(oldSecurity != null && oldSecurity.size()>0){
                   for(Collateral__c security: oldSecurity){
                       Collateral__c newSecurity= security.Clone(false,true);
                       newSecurity.Application__c = newApp.Id;
                       insertCollateral.add(newSecurity);
                   }
               }
               //check for list size prior insert
               if(insertCollateral != null && insertCollateral.size()>0){
                   insert insertCollateral;
               }
               */
               
               //****************************Related Document Record/s***************************

                try{
               List<Related_Document__c> insertRelatedDoc = new List<Related_Document__c>();
               //Query for Related Document 
               String queryRD = generateQueryString('Related_Document__c', 'Application__c = \''+ oldApp.Id +'\''); 
               
               queryRD += ' AND (GE_Link_Type__c !=\'' + DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED + '\' AND GE_Link_Type__c !=\'' + DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC + '\')' + 
                          ' AND (GE_Link_Type__c =\'' + DOC_GenerateDocumentsUtil.LINK_TYPE_EVOLVE + '\' AND status__c=\'' + DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_RECEIVED + '\')';
                                                                      
               List<Related_Document__c> oldRD = Database.query(queryRD);
        
               if(oldRD != null && oldRD.size()>0){
                   for(Related_Document__c rd: oldRD){
                       Related_Document__c newRD= rd.Clone(false,true);
                       newRD.Application__c = newApp.Id;
                       insertRelatedDoc.add(newRD);
                   }
               }
               //check for list size prior insert
               if(insertRelatedDoc != null && insertRelatedDoc.size()>0){
                   insert insertRelatedDoc;
               }
                }catch(exception e){
                    system.debug('Error on Related Document Creation:' + string.valueOf(e));
                }
        
               //****************************Requested Document Record/s***************************
               List<Requested_Document__c> insertRequestedDoc = new List<Requested_Document__c>();
               //Query for Requested Document 
               String queryRequestedDoc = generateQueryString('Requested_Document__c', 'Application__c = \''+ oldApp.Id +'\'');
               String Collateral = GEN_OriginationsConstants.COLLATERAL_CATEGORY_COLLATERAL;
               String POI = GEN_OriginationsConstants.COLLATERAL_CATEGORY_POI;
               //queryRequestedDoc += ' AND (Category__c = \''+ Collateral +'\'' +' OR Category__c = \''+ POI +'\')';                                                     
               List<Requested_Document__c> oldRequestedDoc = Database.query(queryRequestedDoc);
        
               if(oldRequestedDoc != null && oldRequestedDoc.size()>0){
                   for(Requested_Document__c requestedDoc: oldRequestedDoc){               
                       Requested_Document__c newRequestedDoc= requestedDoc.Clone(false,true);
                       newRequestedDoc.Application__c = newApp.Id;
                       if(requestedDoc.Applicant__c != null){
                           newRequestedDoc.Applicant__c = oldNewApplicantMap.get(requestedDoc.Applicant__c).Id;
                       }
                       insertRequestedDoc.add(newRequestedDoc);
                   }
               }
               //check for list size prior insert
               if(insertRequestedDoc != null && insertRequestedDoc.size()>0){
                   insert insertRequestedDoc;
               }
                   
               //****************Cloning of Accounts Related Records *************************//
               
               //****************************Applicant Account Customer Record/s***************************
               List<Applicant_Account_Customer__c> insertAppAC = new List<Applicant_Account_Customer__c>();
               //Query for the applicant Account Customer
               String queryAppAC = generateQueryString('Applicant_Account_Customer__c', 'Applicant__c IN: applicantIds');                                                         
               List<Applicant_Account_Customer__c> oldAppAC = Database.query(queryAppAC);
        
               if(oldAppAC != null && oldAppAC.size()>0){
                   for(Applicant_Account_Customer__c appAC:oldAppAC){
                       Applicant_Account_Customer__c newAppAC = appAC.Clone(false,true);
                       newAppAC.Applicant__c = oldNewApplicantMap.get(appAC.Applicant__c).Id;
                       insertAppAC.add(newAppAC);
                   }
               }
               //check for list size prior insert
               if(insertAppAC != null && insertAppAC.size()>0){
                   insert insertAppAC;
               }
               
               //****************************Applicant CLV Record/s And Applicant Search***************************
               //Query for the applicant CLV
               String queryCLV = generateQueryString('Applicant_CLV__c', 'Applicant__c IN: applicantIds');                                                         
               List<Applicant_CLV__c> oldCLV = Database.query(queryCLV);
        
                //get the applicant search record Id first
                Set<String> asIds = new Set<String>();
                if(oldCLV != null && oldCLV.size()>0){
                  for(Applicant_CLV__c clv:oldCLV){
                         asIds.add(clv.Applicant_Search__c);
                  }
                }

                //create map to put old Applicant Search Id and the new Applicant Search record.
                Map<String,Applicant_Search__c> oldAppSearchMap = new Map<String,Applicant_Search__c>();
                if(asIds != null && asIds.size()>0){
                  String queryAS = generateQueryString('Applicant_Search__c', 'Id IN: asIds');                                                         
                  List<Applicant_Search__c> oldAS = Database.query(queryAS);

                  if(oldAS != null && oldAS.size()>0){
                    for(Applicant_Search__c apps: oldAS){
                        Applicant_Search__c newAS = apps.Clone(false,true);
                        newAS.ownerId = UserInfo.getUserId(); // Assign current user as owner // CVP 3 fix pack item // Updated by: Adrian Recio
                        oldAppSearchMap.put(apps.Id,newAS);
                    }
                  }
                }
                //check for map content prior insert
                if(oldAppSearchMap != null){
                    insert oldAppSearchMap.Values();
                }

               //create Map to store old and new CLV values
               Map<String, Applicant_CLV__c> oldAndNewCLV = new Map<String, Applicant_CLV__c>();
               if(oldCLV != null && oldCLV.size()>0){
                   for(Applicant_CLV__c clv:oldCLV){
                       Applicant_CLV__c newCLV = clv.Clone(false,true);
                       newCLV.ownerId = UserInfo.getUserId(); // Assign current user as owner // CVP 3 fix pack item // Updated by: Adrian Recio
                       newCLV.Applicant__c = oldNewApplicantMap.get(clv.Applicant__c).Id;
                       // Updated by: Adrian Recio
                       // Description: Populate Applicant Search if not null
                       // Date: 99/2015
                       Applicant_Search__c asVar = oldAppSearchMap.get(clv.Applicant_Search__c);
                       if(asVar!=null){
                          newClv.Applicant_Search__c = asVar.Id;
                       }
                       oldAndNewCLV.put(clv.Id, newCLV);
                   }
               }
               //check for map content prior insert
               if(oldAndNewCLV != null){
                   insert oldAndNewCLV.values();
               }
               Set<String> clvIds = oldAndNewCLV.keySet();

               //****************************Applicant Account Record/s***************************
               //Query for the applicant Account
               String queryAppAcc = generateQueryString('Applicant_Account__c', 'Applicant_CLV__c IN: clvIds');                                                         
               List<Applicant_Account__c> oldAppAcc = Database.query(queryAppAcc);
        
               //create Map to store old and new Applicant Account values
               Map<String, Applicant_Account__c> oldAndNewAppAcc = new Map<String, Applicant_Account__c>();
               if(oldAppAcc != null && oldAppAcc.size()>0){
                try{
                   for(Applicant_Account__c appAcc:oldAppAcc ){
                       Applicant_Account__c  newAppAcc = appAcc.Clone(false,true);
                       newAppAcc.ownerId = UserInfo.getUserId(); // Assign current user as owner // CVP 3 fix pack item // Updated by: Adrian Recio
                       newAppAcc.Applicant_CLV__c = oldAndNewCLV.get(appAcc.Applicant_CLV__c).Id;
                       oldAndNewAppAcc.put(appAcc.Id, newAppAcc);
                   }
                }catch(exception e){
                    system.debug('Applicant Account Prepopulation Failed:' + string.valueOf(e));
                }
               }        
               //check for map content prior insert
               if(oldAndNewAppAcc!= null){
                   insert oldAndNewAppAcc.values();
               }
               Set<String> appAccountIds = oldAndNewAppAcc.keySet();
               
               //****************************Applicant Account Bus Contract Goods Record/s***************************
               List<App_Account_Bus_Contract_Goods__c> insertAppABCG = new List<App_Account_Bus_Contract_Goods__c>();
               //Query for the applicant Account Bus Contract Goods
               String queryAppABCG = generateQueryString('App_Account_Bus_Contract_Goods__c', 'Applicant_Account__c IN: appAccountIds');                                                         
               List<App_Account_Bus_Contract_Goods__c> oldAppABCG = Database.query(queryAppABCG);
        
               if(oldAppABCG != null && oldAppABCG.size()>0){
                   for(App_Account_Bus_Contract_Goods__c appABCG:oldAppABCG){
                       App_Account_Bus_Contract_Goods__c newAppABCG = appABCG.Clone(false,true);
                       newAppABCG.Applicant_Account__c = oldAndNewAppAcc.get(appABCG.Applicant_Account__c).Id;
                       insertAppABCG.add(newAppABCG);
                   }
               }
               //check for list size prior insert
               if(insertAppABCG!= null && insertAppABCG.size()>0){
                   insert insertAppABCG;
               }
               
               //****************************Applicant Account History Record/s***************************
               List<Applicant_Account_History__c> insertAppAH= new List<Applicant_Account_History__c>();
               //Query for the applicant Account History
               String queryAppAH = generateQueryString('Applicant_Account_History__c', 'Applicant_Account__c IN: appAccountIds');                                                         
               List<Applicant_Account_History__c> oldAppAH = Database.query(queryAppAH);
        
               if(oldAppAH != null && oldAppAH.size()>0){
                   for(Applicant_Account_History__c appAH:oldAppAH){
                       Applicant_Account_History__c newAppAH = appAH.Clone(false,true);
                       newAppAH.Applicant_Account__c = oldAndNewAppAcc.get(appAH.Applicant_Account__c).Id;
                       insertAppAH.add(newAppAH);
                   }
               }
               //check for list size prior insert
               if(insertAppAH != null && insertAppAH.size()>0){
                   insert insertAppAH;
               }
               
               //****************************Applicant Account Involved Party Record/s***************************
               List<Applicant_Account_Involved_Party__c> insertAppAIP = new List<Applicant_Account_Involved_Party__c>();
               //Query for the applicant Account Involved Party
               String queryAppAIP = generateQueryString('Applicant_Account_Involved_Party__c', 'Applicant_Account__c IN: appAccountIds');                                                         
               List<Applicant_Account_Involved_Party__c> oldAppAIP = Database.query(queryAppAIP);
        
               if(oldAppAIP != null && oldAppAIP.size()>0){
                   for(Applicant_Account_Involved_Party__c appAIP:oldAppAIP){
                       Applicant_Account_Involved_Party__c newAppAIP = appAIP.Clone(false,true);
                       newAppAIP.Applicant_Account__c = oldAndNewAppAcc.get(appAIP.Applicant_Account__c).Id;
                       insertAppAIP.add(newAppAIP);
                   }
               }
               //check for list size prior insert
               if(insertAppAIP != null && insertAppAIP.size()>0){
                   insert insertAppAIP;
               }
               
               //****************************Applicant Account Loss History Record/s***************************
               List<Applicant_Account_Loss_History__c> insertAppALH = new List<Applicant_Account_Loss_History__c>();
               //Query for the applicant Account Loss History
               String queryAppALH = generateQueryString('Applicant_Account_Loss_History__c', 'Applicant_Account__c IN: appAccountIds');                                                         
               List<Applicant_Account_Loss_History__c> oldAppALH = Database.query(queryAppALH);
        
               if(oldAppALH != null && oldAppALH.size()>0){
                   for(Applicant_Account_Loss_History__c appALH:oldAppALH){
                       Applicant_Account_Loss_History__c newAppALH = appALH.Clone(false,true);
                       newAppALH.Applicant_Account__c = oldAndNewAppAcc.get(appALH.Applicant_Account__c).Id;
                       insertAppALH.add(newAppALH);
                   }
               }
               //check for list size prior insert
               if(insertAppALH != null && insertAppALH.size()>0){
                   insert insertAppALH;
               }
               
               //****************************Applicant Account Plan Record/s***************************
               List<Applicant_Account_Plan__c> insertAppAP = new List<Applicant_Account_Plan__c>();
               //Query for the applicant Account Plan
               String queryAppAP = generateQueryString('Applicant_Account_Plan__c', 'Applicant_Account__c IN: appAccountIds');                                                         
               List<Applicant_Account_Plan__c> oldAppAP = Database.query(queryAppAP);
        
               if(oldAppAP != null && oldAppAP.size()>0){
                   for(Applicant_Account_Plan__c appAP:oldAppAP){
                       Applicant_Account_Plan__c newAppAP = appAP.Clone(false,true);
                       newAppAP.Applicant_Account__c = oldAndNewAppAcc.get(appAP.Applicant_Account__c).Id;
                       insertAppAP.add(newAppAP);
                   }
               }
               //check for list size prior insert
               if(insertAppAP != null && insertAppAP.size()>0){
                   insert insertAppAP;
               }
               
               // Commit extra update to Application that can't be applied when cloning child records
               newApp.Response_Code__c = 'New';
               update newApp;
               
               // Force POI Verification to applicants
               List<Applicant__c>poiVerifiedAppList = oldNewApplicantMap.values();
               for(Applicant__c appVar: poiVerifiedAppList){
                    appVar.POI_Financial_Situation_Verified__c = true;
               }
               
               if(poiVerifiedAppList.size()>0){
                    update poiVerifiedAppList;
               }
               
               responseVar = new SixtyDaysCertService.sixtyDayCertResponse(newApp.Id,'Application auto created for 60 day certificate. Please complete application setup in the separated tab.');
                       
           }else{
               responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'Application with Contract Number ' + eligibleOpp.Account_Number__c + ' doesn\'t exist.');  
           }
      }
        catch(Exception e){
            //TODO: handle Exception
            System.debug('Exception-->'+e); 
            database.rollback(sp);
            responseVar = new SixtyDaysCertService.sixtyDayCertResponse(null,'Application creation failed from an internal error: ' + string.valueOf(e));               
      }
        
        return responseVar; 
       
    }
    
    
 
   /* 
    *  Description: Method that fetches all writable fields and creates it into SQL format
    *  Author: Fel Saliba
    *  Input Parameters: Object Name
    *  Return: String - field
    */    
    
    private String generateSelectFields(String objectName) {
        String selects = '';
        System.debug('objectName-->'+objectName);
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        system.debug('FMapVal:' + fMap);
        if (fMap != null){
            
            for (Schema.SObjectField ft : fMap.values()){
                Schema.DescribeFieldResult fd = ft.getDescribe();
                
                system.debug(objectName + 'FD Name:' + fd.getName());
                system.debug('Is Accessible:' + fd.isAccessible());
                system.debug('Is Creatable:' + fd.isCreateable());
                system.debug('Is Autonumber:' + !fd.isAutoNumber());
                system.debug('Is Calculated:' + !fd.isCalculated());
                system.debug('Is DefaultOnCreate:' + !fd.isDefaultedOnCreate());
                
                if (fd.isAccessible() && fd.isCreateable() && !fd.isUnique() && !fd.isAutoNumber() && !fd.isCalculated()){
                    system.debug('Is Passed');
                    selectFields.add(fd.getName());
                }
            }
        }
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
        }
       
        return selects;
 
    }
    
    
    /* 
    *  Description: Method to construct the query String
    *  Author: Fel Saliba
    *  Input Parameters: String - Object Name
    *                    String - filterCondition
    *  Return: String -  queryString
    */
    private String generateQueryString(String objectName, String filterCondition) {
        
        String queryString = 'SELECT ' + generateSelectFields(objectName) +  
                             ' FROM '+ objectName + ' WHERE ' + filterCondition;
        system.debug('Query String Gen Value:' + queryString);                     
        return queryString;
    }
}