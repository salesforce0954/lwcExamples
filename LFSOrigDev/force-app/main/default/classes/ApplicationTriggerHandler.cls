/*
Author: Adrian Recio Cloud Sherpas
Created Date: June 30, 2016
Description: Main Appliction Trigger Handler Class

* @History:
   =====================================================================
       05-05-15: Mike: Updated Defect 1375 - updated createAutoRiskReferal method to add feed item 
                                            to application when application status is Referred: Refer to CPU/CMO
       26-08-15: Adrian: Added validateBrandOwnership Method
       03-SEPT-15: WEEKLY CONTRACT PAYMENT ISSUE - MLASALA
   =====================================================================
*/
public with sharing class ApplicationTriggerHandler {

	public static boolean isAfterUpdateExecuted = false;
    public static boolean isAfterInsertExecuted = false;
    public static boolean isBeforeInsertExecuted = false;
    public static boolean isBeforeUpdateExecuted = false;
    public static boolean isAfterDeleteExecuted = false;
    public static Map<Id, string> recordTypeMap = new Map<Id, string>();
    public static Boolean Do_Not_Run_Trigger = false;
    
    //Skip auto risk referal creation
    Public static boolean createRiskFlow = true;
    
    public static void clear_execution_flags(){
        isAfterUpdateExecuted = false;
        isAfterInsertExecuted = false;
        isBeforeInsertExecuted = false;
        isBeforeUpdateExecuted = false;
        isAfterDeleteExecuted = false;
    }

	/*
    * Method name: executeTriggerEvents
    * Purpose: This method checks the trigger events and accordingly execute the methods  along with the trigger context variables and data
    */
    
    public static void executeTriggerEvents(boolean isBefore, boolean isAfter, boolean isInsert, boolean isUpdate,
                                            boolean isDelete, List<Application__c> newAppList, Map<Id, Application__c>newAppMap, 
                                            List<Application__c> oldAppList, Map<Id, Application__c> oldAppMap ){
        
        System.debug('Inside executeTriggerEvents');
        if(!Utils.is_enabled('ApplicationTrigger')){
            return; 
        }
        
        if(isInsert){

            if(isBefore) {
                 System.debug('Inside IsInsert && isBefore');
                 if(!isBeforeInsertExecuted){  
                 	setApplicationFields(newAppList, newAppMap, oldAppMap);    
                    isBeforeInsertExecuted = true;
                 } 
            }  

            if(isAfter){
                System.debug('Inside isInsert && isAfter');
                if(!isAfterInsertExecuted){
                    
                    isAfterInsertExecuted = true;
                }
                createAutoRiskReferal(newAppList);  
            }  
        }

        if(isUpdate){
            if(isBefore){
                 System.debug('Inside isUpdate && isBefore');
                 if(!isBeforeUpdateExecuted){  
                    // Added by: Adrian Recio
                    // Date: 26/08/15
                    // Description: Method that validates application for ownership assignment.
                    //              This validation should fire first before any processes.
                    validateBrandOwnership(newAppList,oldAppMap);    
                    setBrokerFields(newAppList, newAppMap, oldAppMap);
                    compiledIsBeforeUpdate(newAppList, newAppMap, oldAppMap);
                    isBeforeUpdateExecuted = true;
                }
            } 

            if(isAfter){
                System.debug('Inside isUpdate && isAfter');
                if(!isAfterUpdateExecuted){
                    compiledIsAfterUpdate(newAppList, newAppMap, oldAppMap);
                    
                    isAfterUpdateExecuted = true; 
                }
                createAutoRiskReferal(newAppList); 
            }
          
        }

        if(Trigger.isUndelete){
            accessControl(newAppList);
        }                                                                                               
    }
    
    /*
    * Method name: updateApplicationFields Update concatenated fields when the source fields have been updated
      Created By: Luke Sevior
    */  
    public static void setApplicationFields(List<Application__c> applicationList, 
                                            Map<Id, Application__c> newMap, 
                                            Map<Id, Application__c> oldMap ){
        //Start check recursive call
        if(StopRecursionCalls.getStatus('ApplicationTriggerHandler.setApplicationFields')){
            return;
        }

        // Contatenate applicant names into the Applicant__c field
        for(Application__c app : applicationList){
            app.Applicant__c = app.Applicant_1_Name__c;
            if(app.Applicant_2_Name__c != null){
            	app.Applicant__c += ' & ' + app.Applicant_2_Name__c;
            }  
        }
    }

    /*
    * Method name: update Broker Information on Broker Change,Update concatenated fields when the source fields have been updated
      Created By: Luke Sevior
    */  
    public static void setBrokerFields(List<Application__c> applicationList, 
                                       Map<Id, Application__c> newMap, 
                                       Map<Id, Application__c> oldMap ){
        //Start check recursive call
        if(StopRecursionCalls.getStatus('ApplicationTriggerHandler.setBrokerFields')){
            return;
        }
        
        List<Disbursement__c> lst_Disbursement = new List<Disbursement__c>();
        set<id> setOfAppIds = new set<id>();
        set<id> setOfBrokerIds = new set<id>();

        // Contatenate applicant names into the Applicant__c field
        for(Application__c app : applicationList){
            if((oldMap.get(app.id).Broker__c != newMap.get(app.id).Broker__c) && app.Broker__c != null){
                setOfAppIds.add(app.id);
                setOfBrokerIds.add(app.Broker__c);
            }
        }
        
        Map<Id, Application__c> appDisbursementMap = new Map<Id, Application__c>([SELECT id, (SELECT id,Branch__c //, Broker_Aggregator_Account_Name__c
                                                                                    FROM Disbursements__r) 
                                                                                   FROM Application__c WHERE Id In :setOfAppIds]);
        Map<Id, Contact> brokerMap = new Map<Id, Contact>([Select Id //, Broker_Aggregator_Account_Name__c 
                                                            from Contact where Id In :setOfBrokerIds]);

        // Fire application broker alignment on before update event 
        for(Application__c app: applicationList){
                if(setOfAppIds.contains(app.Id)){
                    //Change Broker Aggregator Account Name to formula field- MDAVID 8/11/2016
                    //app.Broker_Aggregator_Account_Name__c = app.Broker__r.Broker_Aggregator_Account_Name__c;
                    Application__c appTempVar = appDisbursementMap.get(app.Id);

                    if(appTempVar!=null){
                        Contact conTempVar = brokerMap.get(app.Broker__c);
                        for(Disbursement__c d : appTempVar.Disbursements__r){
                            //Change Broker Aggregator Account Name to formula field- MDAVID 8/11/2016
                            //d.Broker_Aggregator_Account_Name__c = conTempVar.Broker_Aggregator_Account_Name__c;
                            lst_Disbursement.add(d);
                        }
                    }

                }else if(app.Broker__c == null){
                    //Change Broker Aggregator Account Name to formula field- MDAVID 8/11/2016
                    //app.Broker_Aggregator_Account_Name__c = null; 
                    Application__c appTempVar = appDisbursementMap.get(app.Id);

                    if(appTempVar!=null){
                        for(Disbursement__c d : appTempVar.Disbursements__r){
                            //Change Broker Aggregator Account Name to formula field- MDAVID 8/11/2016
                            //d.Broker_Aggregator_Account_Name__c = null;
                            lst_Disbursement.add(d);
                        }   
                    }
                }
        }
        
   
        if(lst_Disbursement.size() > 0)
            update lst_Disbursement;
    }        

    /*  Description: Brand ownership check for owner of application.
                     Application can only be owned by internal users with brand assignment based 
                     on the application brand, queue, and community user.
                     Any other assignments should be invalid and fire validation error. 
     *  Author: Adrian Recio
     *  Date Created: AUG-26-2015
     *  Input Parameters: List<Application__c>
     */
    public static void validateBrandOwnership(List<Application__c> origAppList, Map<Id,Application__c> oldAppMap){
        

        // Validate that list is not empty or null
        if(origAppList!=null && oldAppMap!=null ){

          // Filter Application with owner change 
          List<Application__c> appList = new List<Application__c>();
          // Validate that ownerId changed
          Boolean ownrChange = false;

          for(Application__c appVar: origAppList){
            Application__c appOldVar = oldAppMap.get(appVar.Id);
            if(appOldVar.ownerId!=appVar.ownerId){
              ownrChange = true;
              appList.add(appVar);
            }
          }

          if(applist.size()>0 && ownrChange==true){

              // Pull application owner Id
              Set<Id> appOwnerIdSet = new Set<Id>();
              for(Application__c appVar:applist){
                appOwnerIdSet.add(appVar.ownerId);
              }

              // Pull list of application qualified for validation.
              // Only application with standard user owners are qualified
              // and ownership is updated.
              Map<Id,User> usrInfoMap = new Map<Id,User>([Select Id,UserType from User where Id In :appOwnerIdSet]);
              List<Application__c> appCheckList = new List<Application__c>();
              Set<Id> userBCheckIdSet = new Set<Id>();

              // Pull application owner Id
              for(Application__c appVar:applist){

                // Retrieve user information type and old app
                User usrVar = usrInfoMap.get(appVar.ownerId);

                // User is null if owner is queue
                if(usrVar!=null){
                  // If user is standard and ownership is updated, pull app and owner in a seprate list
                  if(usrVar.UserType == 'Standard'){
                    appCheckList.add(appVar);
                    userBCheckIdSet.add(appVar.ownerId);
                  }
                }
              }  

              // Pull brand assignments where owner is one of the qualified users for brand check
              List<Brand_Assignment__c> brandAssList = [Select Id,User__c, Brand__c from Brand_Assignment__c where User__c In :userBCheckIdSet];
              Map<Id, Set<Id>> brandGroupOwnerMap = new Map<Id, Set<Id>>();

              // Organize brand assignment where key is the brand and value is set of user Ids under it
              for(Brand_Assignment__c baVar: brandAssList){
                // If brand key exist, pull current value and include user and update map
                if(brandGroupOwnerMap.containsKey(baVar.Brand__c)){
                  Set<Id> usrGroupIdSet = brandGroupOwnerMap.get(baVar.Brand__c);
                  usrGroupIdSet.add(baVar.User__c);
                  brandGroupOwnerMap.put(baVar.Brand__c,usrGroupIdSet);
                // If brand key doesn't exist create a new map value for it and assign it as key
                }else{
                  Set<Id> usrGroupIdSet = new Set<Id>();
                  usrGroupIdSet.add(baVar.User__c);
                  brandGroupOwnerMap.put(baVar.Brand__c,usrGroupIdSet);
                }
              }

              // loop across applications for owner assignment check based on appliation brand
              for(Application__c appVar: appCheckList){
                Boolean vIsFail = false;

                // Check if brand exist in qualified users
                if(brandGroupOwnerMap.containsKey(appVar.Brand_Lookup__c)){
                  // Get brand set users
                  Set<Id> brandUsrSet = brandGroupOwnerMap.get(appVar.Brand_Lookup__c);
                  // Check that owner exist in the brand assignment
                  if(!brandUsrSet.contains(appVar.ownerId)){
                    vIsFail = true;
                  }
                }else{
                  vIsFail = true;
                }

                // Fire validation message if application failed
                if(vIsFail==true){
                  appVar.addError('New owner is not qualified for application brand.');
                }
              }
          }
        }
    }


    public static void compiledIsAfterUpdate(List<Application__c> appNewList,
                                              Map<Id, Application__c> newMap, 
                                              Map<Id, Application__c> oldMap ){

        ApplicationTriggerHandler handler = new ApplicationTriggerHandler();
        TOM_ApplicationQueueEngine queueEngine;
        GEN_PCAUtility genPCAhandler = new GEN_PCAUtility();
        Set<Id> appIds = new Set<Id>();     //MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE

        List<Application__c> applicationFlushList = new List<Application__c>();
        List<Application__c> flushConsentandLoanDocumentsList = new List<Application__c>();
        List<Id> applicationIdList = new List<Id>();
        
        //Added by Fel Saliba 24/06/2014 - Created list to store applications for product Item recalculation.
        List<Application__c> applicationList = new List<Application__c>();
        

        for(Application__c app:appNewList){

          Application__c oldApplication = oldMap.get(app.ID);
              
            if(app.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA && 
              app.Out_Of_Sync__c == true && 
              app.PCA_Flush__c == true && 
              oldApplication.PCA_Flush__c == false){

                applicationFlushList.add(app);

            }
            
            //Added by Fel Saliba 24/06/2014 - check for changes in Total Insurance Premium 
            if(app.Total_Insurance_Premium__c != null && app.Total_Insurance_Premium__c != 0 && 
               oldApplication.Total_Insurance_Premium__c != app.Total_Insurance_Premium__c){
               
               //add in the list
               applicationList.add(app);
            }

            if(oldApplication.Acceptance_Channel__c != null && 
               app.Acceptance_Channel__c != null &&
               oldApplication.Acceptance_Channel__c != app.Acceptance_Channel__c){
                
                flushConsentandLoanDocumentsList.add(app);
            }

            if(oldApplication.Collateral_Count__c != app.Collateral_Count__c){

                applicationIdList.add(app.Id);
                appIds.add(app.Id);     //MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE
            }

        }
        
        if(!applicationIdList.isEmpty()){
            //Run Pricing Rule engine
            RUL_Engine.runPricingEngineAsync(applicationIdList);
        }
        //BEGIN MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE
        if(!appIds.isEmpty()){
            //Recalculate repayments
            handler.recalculateRepayments(appIds);
        }
        //END MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE

        if(!applicationFlushList.isEmpty()){
              GEN_PCAUtility.flushComplianceChecklistandLoanDocuments(applicationFlushList);
        }
        
        //Added by Fel Saliba 24/06/2014 - check list size prior calling the method, must be greater than 0
        if(applicationList.size()>0){
            GEN_OfferUtility.calculateProductItems(applicationList);
        }

        if(!flushConsentandLoanDocumentsList.isEmpty()){
            GEN_PCAUtility.flushConsentandLoanDocuments(flushConsentandLoanDocumentsList);
        }

    }

    public static void compiledIsBeforeUpdate(List<Application__c> applicationList, 
                                              Map<Id, Application__c> newMap, 
                                              Map<Id, Application__c> oldMap ){

        ApplicationTriggerHandler handler = new ApplicationTriggerHandler();
        TOM_ApplicationQueueEngine queueEngine;
        GEN_PCAUtility genPCAhandler = new GEN_PCAUtility();
        Set<Id> appIds = new Set<Id>();     //MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE

        List<Application__c> appListWithoutBlended = new List<Application__c>();
        List<Application__c> appPCAList = new List<Application__c>();
        List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();     //MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        List<Application__c> appAssignmentQueue = new List<Application__c>();    //TOM Change
        
        for(Application__c app:applicationList){
            
            Application__c oldApplication = oldMap.get(app.ID);
            //check for the changes in Adjusted Rate
            if((oldApplication.Credit_Score__c == app.Credit_Score__c && 
                (oldApplication.Adjusted_Interest_Fee_Locked__c != app.Adjusted_Interest_Fee_Locked__c) || 
                (oldApplication.Adjusted_Interest_Rate__c != app.Adjusted_Interest_Rate__c)) || 
               (oldApplication.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER && 
                app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER && 
                oldApplication.Brokerage_Fee__c != app.Brokerage_Fee__c)){
                
                appListWithoutBlended.add(app);
                appIds.add(app.Id);     //MLASALA: 03-SEPT-15 - WEEKLY CONTRACT PAYMENT ISSUE

                //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                //Check if application has insurance
                if(app.Total_Insurance_Premium__c != null && 
                   app.Total_Insurance_Premium__c != 0){
                    
                    //Identify which scenario to get specific error message
                    //Rate change
                    if(oldApplication.Credit_Score__c == app.Credit_Score__c && 
                        oldApplication.Adjusted_Interest_Rate__c != app.Adjusted_Interest_Rate__c){

                        app.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(app.Id, 
                                                                                         app.Insurance_Error_Message__c, 
                                                                                         GEN_OriginationsConstants.RATE_CHANGE_INSURANCE_INFO_MESSAGE);
                    }

                    //Broker fee change
                    if(oldApplication.Channel__c == app.Channel__c && 
                       oldApplication.Brokerage_Fee__c != app.Brokerage_Fee__c){

                        //Populate error message on application
                        app.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(app.Id, 
                                                                                         app.Insurance_Error_Message__c, 
                                                                                         GEN_OriginationsConstants.BROKER_FEE_INSURANCE_INFO_MESSAGE);
                    }

                    //BEGIN MLASALA: 20-AUG-15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES
                    //Establishment fee change
                    if(oldApplication.Adjusted_Interest_Fee_Locked__c != app.Adjusted_Interest_Fee_Locked__c && 
                       oldApplication.Offered_Establishment_Fee__c != app.Offered_Establishment_Fee__c){

                        //Populate error message on application
                        app.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(app.Id, 
                                                                                         app.Insurance_Error_Message__c, 
                                                                                         GEN_OriginationsConstants.ESTABLISHMENT_FEE_INSURANCE_INFO_MESSAGE);
                    }
                    //END MLASALA: 20-AUG-15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES

                    debugLogList.add(Util.createInsuranceActivity(app.Id, 
                                                                  'Flush', 
                                                                  GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                                  'System', 
                                                                  app.Total_Insurance_Premium__c, 
                                                                  0));
                    
                }
                //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

            }
            
            if(app.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA && 
               app.Out_Of_Sync__c == true && 
               oldApplication.Out_Of_Sync__c == false && 
               app.PCA_Flush__c == false && 
               app.Generated_Doc_Confirm_Sent__c){      //MLASALA 19-APR-2016 FLUSH ONLY ON POST DOC GEN
                
                app.PCA_Flush__c = true;
            }
            
            if(oldApplication.Adjusted_Interest_Rate__c != app.Adjusted_Interest_Rate__c || oldApplication.Offered_Interest_Rate__c != app.Offered_Interest_Rate__c || oldApplication.Acceptance_Channel__c != app.Acceptance_Channel__c){
                app.Out_Of_Sync__c = true;
            }
            
            //Check custom settings if TOM Enabled, if not, don't execute the logic, Aussie Money and NZ brands are currently out of scope
            if(Admin_Settings__c.getValues('TOM Enabled').Value__c == 'TRUE'){
                system.debug('!@#$old:'+oldApplication.Response_Code__c + '    new:'+app.Response_Code__c);
                if((oldApplication.Response_Code__c != app.Response_Code__c || oldApplication.Applicant_1_Response_Code__c != app.Applicant_1_Response_Code__c  || oldApplication.Applicant_2_Response_Code__c != app.Applicant_2_Response_Code__c )
                   && app.Brand_Country__c == 'AU' && app.Brand_String__c != 'Aussie Money AU' && !GEN_OriginationsConstants.SERVER_RESPONSE_CODE.contains(app.Response_Code__c)){
                    appAssignmentQueue.add(app);
                } 
            }
        }            
        
        if(!appListWithoutBlended.isEmpty()){ 
            //pass the application list in handler class.           
            handler.calculateOfferedRate(appListWithoutBlended, false, false);
        }
        
        if(!appAssignmentQueue.isEmpty()){
            //Start queueing engine
            queueEngine = new TOM_ApplicationQueueEngine();
            queueEngine.startProcess(appAssignmentQueue);
        }

        if(!debugLogList.isEmpty()){
            //Insert debug logs
            try{
                insert debugLogList;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', null);
            }
        }
    }
    // Block undelete
    public static void accessControl(List<Application__c> applicationList){
        System.debug('!@#isUndelete');
        AccessControlTriggerHandler act = new AccessControlTriggerHandler();
        act.blockUndelete(applicationList);
    }   

    /** Method to update Correlation Id **/
    public void updateCorrelationId(List<Application__c> appList){
        
        List<Application__c> uAppList = new List<Application__c>();
        if(applist.size()>0){
            for(Application__c app: appList){
                app.Correlation_ID__c = generateCID(app.CID__c);
                uAppList.add(app);
            }
        }
        
        if(!uAppList.isEmpty()){
            update uAppList;
        }
    }

    /*  Description: Update Credit File Checkbox on Application object
     *  Author: Mike Lasala
     *  Date Created: JAN-06-2014
     *  Input Parameters: Set<Id>
     */
    public void updateCreditFileCheckbox(Set<Id> appIds){
        if(!appIds.isEmpty()){
            List<Applicant__c> appList = [SELECT    Id 
                                            FROM    Applicant__c
                                            WHERE   Id IN: appIds];
            if(!appList.isEmpty()){
                for(Applicant__c a: appList){
                    a.Has_Credit_File_Check__c = true;
                }
                update appList;
            }
        }
    }

    public void verifyDeletedCFC(Set<Id> appIds){
        if(!appIds.isEmpty()){
            List<Applicant__c> appList = [SELECT    Id,
                                                    (Select Id FROM Credit_File_Checks__r)
                                            FROM    Applicant__c
                                            WHERE   Id IN: appIds];
            if(!appList.isEmpty()){
                for(Applicant__c a: appList){
                    if(a.Credit_File_Checks__r.isEmpty()) {
                        a.Has_Credit_File_Check__c = false; //set the credit file check to false
                    }
                }
                update appList;
            }
        }
    }

    /*  Description: Update Compliance record fields on update
     *  Author: Mike Lasala
     *  Date Created: JAN-08-2014
     *  Input Parameters: List<Compliance_Check__c> and String
     */
    public void updateComplianceDate(List<Compliance_Check__c> ccList, String prof){
        if(!ccList.isEmpty()){
            for(Compliance_Check__c cc: ccList){
                if(prof == 'PFR'){
                    if(cc.PFR_Check__c != null){
                        cc.PFR_Date__c = Date.today();
                        cc.PFR_ID__c = UserInfo.getName();
                        cc.PFR_User_ID__c = UserInfo.getUserId();
                    } else {
                        cc.PFR_Date__c = null;
                        cc.PFR_ID__c = null;
                        cc.PFR_User_ID__c = null;
                    }
                }
                
                if(prof == 'BM'){
                    if(cc.BM_Check__c != null){
                        cc.BM_Date__c = Date.today();
                        cc.BM_ID__c = UserInfo.getName();
                        cc.BM_User_ID__c = UserInfo.getUserId();
                    } else {
                        cc.BM_Date__c = null;
                        cc.BM_ID__c = null;
                        cc.BM_User_ID__c = null;
                    }
                }
            }
        }
    }

    /** Method for constructing Correlation Id **/
    public String generateCID(String auto){ 
        
        String correlation = '004'+auto;
        return correlation;
    }

    /*  Description: Method to determine Application Offered Rate
     *  Author: Fel Saliba
     *  Date Created: JAN-22-2014
     *  Description: This method will be called for the following scenarios.
                   - Fee Reduction
                   - Rate Reduction
                   - Rate Reduction Cancellation
                   - Broker Fee Changes
     */ 
    public void calculateOfferedRate(List<Application__c> appList, boolean isCancelRate, boolean blendedRequired){
        
        If(appList.size() > 0){
            
            //flush all the insurance product first
            GEN_OfferUtility.flushOffers(appList);
            
            Set<String> appIds= new Set<String>();
            for(Application__c app: appList){
                appIds.add(app.Id);
            }

            OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
            offerCalculator.getProdutctItemsBySet(appIds);

            Map<Id,List<Product_Item__c>> appProdItemMap = new Map<Id,List<Product_Item__c>>();
            for(Product_Item__c pi: offerCalculator.prodItems){
                if(appProdItemMap.containsKey(pi.Application__c)){
                    appProdItemMap.get(pi.Application__c).add(pi);
                }else{
                    appProdItemMap.put(pi.Application__c, new List<Product_Item__c> {pi});
                }
            }

            //Added by Mike Lasala 05/19/15 for calculation debugging
            List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();
            for(Application__c app: appList){
                //Added by Mike Lasala 05/19/15 for calculation debugging
                Application__c tempApplication = app;
                Debug_Log__c debugLog = Util.createDebugLog(app.Id, 'After update: '+System.now(), 'ApplicationTriggerHandler', 'calculateOfferedRate');

                offerCalculator = new OFF_OfferFieldsCalculator();
                offerCalculator.prodItems = appProdItemMap.get(app.Id);
                
                if(isCancelRate){
                    //app.Offered_Interest_Rate__c = offerCalculator.getInterestRate(app);
                    
                    //set values to null and false for rate reduction cancellation.
                    app.Adjusted_Interest_Rate_Locked__c = false;
                    app.Adjusted_Interest_Rate_Reason__c = '';
                    app.Adjusted_Interest_Rate__c = null;
                    app.Workflow_In_Progress__c = false;
                    
                    //Added by Mike Lasala 05/19/15 for calculation debugging
                    debugLog.Calculation_Log__c += 'Adjusted_Interest_Rate__c: '+tempApplication.Adjusted_Interest_Rate__c+' --> '+app.Adjusted_Interest_Rate__c+'\n';
                } else{
                    app.Offered_Interest_Rate__c = offerCalculator.getOfferedInterestRateWithoutAppResponse(app);                    
                }
                if(blendedRequired){
                    //app.Offered_Interest_Rate__c = offerCalculator.getBlendedRate(app, app.Offered_Interest_Rate__c);
                    //app.Offered_Interest_Rate_Orig__c = app.Offered_Interest_Rate__c;

                    //Added by Mike Lasala 05/19/15 for calculation debugging
                    //debugLog.Calculation_Log__c += 'Offered_Interest_Rate_Orig__c: '+tempApplication.Offered_Interest_Rate_Orig__c+' --> '+app.Offered_Interest_Rate_Orig__c+'\n';
                }

                //since we have already deleted all the insurance product, set the Total Insurance Premium to zero.
                app.Total_Insurance_Premium__c = 0;

                app.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(app);
                app.Offered_Repayments__c  = offerCalculator.getRepaymentEMI(app);
                app.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(app);
                //Added by Fel Saliba 16/07/2015 put this code and turned ProductItem trigger off to avoid Self Trigger Reference Error.
                app.Out_Of_Sync__c = true;
    
                //Added by Mike Lasala 05/19/15 for calculation debugging
                //debugLog.Calculation_Log__c += 'Offered_Interest_Rate__c: '+tempApplication.Offered_Interest_Rate__c+' --> '+app.Offered_Interest_Rate__c+'\n';
                debugLog.Calculation_Log__c += 'Total_Insurance_Premium__c: '+tempApplication.Total_Insurance_Premium__c+' --> '+app.Total_Insurance_Premium__c+'\n';
                debugLog.Calculation_Log__c += 'EMI_with_Service_Fee__c: '+tempApplication.EMI_with_Service_Fee__c+' --> '+app.EMI_with_Service_Fee__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Repayments__c: '+tempApplication.Offered_Repayments__c+' --> '+app.Offered_Repayments__c+'\n';
                debugLog.Calculation_Log__c += 'Offered_Frequency_Repayments__c: '+tempApplication.Offered_Frequency_Repayments__c+' --> '+app.Offered_Frequency_Repayments__c+'\n\n';
                //call the class to compute for Individual Insurance
                app = GEN_OfferUtility.getIndividualInsuranceAndPayable(app);
                System.debug('app-->'+app);
                //Added by Mike Lasala 05/19/15 for calculation debugging
                debugLog.Calculation_Log__c += 'Class: GEN_OfferUtility\nMethod: populateOfferFields\n\n';
                debugLog.Calculation_Log__c += 'Total_Loan_Interest_Amount_Payable__c: '+tempApplication.Total_Loan_Interest_Amount_Payable__c+' --> '+app.Total_Loan_Interest_Amount_Payable__c+'\n';
                debugLog.Calculation_Log__c += 'Total_Insurance_Interest_Amount_Payable__c: '+tempApplication.Total_Insurance_Interest_Amount_Payable__c+' --> '+app.Total_Insurance_Interest_Amount_Payable__c;
                debugLogList.add(debugLog);
            }

            if(isCancelRate){
                update appList;
            }
            //Added by Mike Lasala 03/19/15 for calculation debugging
            if(!debugLogList.isEmpty()){
                try{
                    insert debugLogList;
                } catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'ApplicationTriggerHandler', 'Debug_Log__c', 'Class');
            }
            }
        }
    }
    
    //BEGIN MLASALA: 03-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
    /*  Description: Recalculate repayments after update of pricing engine
     *  Author: Mike Lasala
     *  Date Created: 03-SEPT-2015
     *  Input Parameters: Set<Id>
     */
    public void recalculateRepayments(Set<Id> appIds){
        //Retrieve applications
        List<Application__c> applicationList = [SELECT  Offered_Monthly_Loan_Service_Fee__c, 
                                                        Total_Loan_Amount__c, 
                                                        Total_Insurance_Premium__c, 
                                                        Offered_Establishment_Fee__c, 
                                                        Offered_PPSR_Search_Fee__c, 
                                                        Offered_PPSR_Registration_Fee__c, 
                                                        Brokerage_Fee__c, 
                                                        Offered_Interest_Rate__c, 
                                                        Loan_Term_Months__c, 
                                                        Payment_Frequency__c, 
                                                        Offered_Repayments__c
                                                FROM    Application__c 
                                                WHERE   Id IN: appIds];
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        if(!applicationList.isEmpty()){
            //Relcalculate
            for(Application__c app: applicationList){
                app.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(app);
                app.Offered_Repayments__c  = offerCalculator.getRepaymentEMI(app);
                app.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(app);
                app.Out_Of_Sync__c = true;
                app = GEN_OfferUtility.getIndividualInsuranceAndPayable(app);
            }
            //Update records
            try{
                update applicationList;
            } catch(DMLException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'ApplicationTriggerHandler', 'Application__c', 'Class');
            }
        }
    }
    //END MLASALA: 03-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
    public Static void createAutoRiskReferal(List<Application__c> lstApplication) {
     /* if(!Profile_Country__c.getInstance().NZ__c) {
        return;
      } 
      */
      if(!createRiskFlow) {
        return;
      }
      createRiskFlow = false;
      map<Id,Brand__c> mpBrand = new map<Id,Brand__c>([select Id,Country__c From Brand__c]);
      List<WorkFlow__c> lstRiskreferral = [Select Id,Risk_CPU_Decision__c,Application__c 
                                           FROM WorkFlow__c 
                                           WHERE Application__c IN :lstApplication AND (Risk_CPU_Decision__c =: NULL OR Bypass_BM_Approval__c = TRUE ) AND RecordType.Name = 'Risk Referral'];
      map<String,WorkFlow__c> mpWorkFlow = new map<String,WorkFlow__c>(); 
     
      for(WorkFlow__c wrkFlw : lstRiskreferral) {
        mpWorkFlow.put(wrkFlw.Application__c,wrkFlw);
      } 
      list<User> lstCMOManager = new List<User>();            
      if(!Test.isRunningTest()) {
        lstCMOManager = [Select Id FROM User Where username =:NZ_Specific_Settings__c.getValues('CMO Manager').value__c];  
   
      if(lstCMOManager.isEmpty() ) {
        return;
        }
      }
      List<WorkFlow__c> lstRiskReferalToInsert = new List<WorkFlow__c>();
      Schema.DescribeSObjectResult d = Schema.SObjectType.WorkFlow__c;
      Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
      Schema.RecordTypeInfo rtByName =  rtMapByName.get('Risk Referral');

      System.debug('$$$ mpWorkFlow: '+mpWorkFlow.keySet()+' mpBrand: '+mpBrand.keySet());
      for(Application__c app : lstApplication) {
        if(mpWorkFlow.containsKey(app.Id)) {
          continue;
        }
        if(!mpBrand.containsKey(app.Brand_Lookup__c) || mpBrand.get(app.Brand_Lookup__c).Country__c != 'NZ') {
          continue;
        }
        if(app.Status__c != 'Referred: Refer to CPU/CMO' || app.Response_code__c != 'SCR') {
          continue;
        }
        System.debug('$$$ app: '+app.Id+', '+app.Brand_Lookup__c+', '+app.Status__c+', '+app.Response_Code__c);
        
        WorkFlow__c wrk = new WorkFlow__c();
        wrk.Risk_Referral_Reason__c = 'Reason code: Refer CPU';
        wrk.Priority__c = 'Standard';
        wrk.Loan_Amount__c = app.Total_Loan_Amount__c;
        wrk.Risk_Collateral_Value__c = 0;
        wrk.Description__c = 'Credit Decision Automatic Referral';
        wrk.Risk_Capacity__c = app.Available_Capacity__c==null ? null:String.valueOf(app.Available_Capacity__c);
        wrk.Risk_Character__c = 'Credit Decision Automatic Referral';
        wrk.Risk_Credit__c = 'Credit Decision Automatic Referral';
        wrk.Risk_Customer_Type__c = 'N/A';
        if(lstCMOManager.size() > 0)
        wrk.Assigned_To_2__c = lstCMOManager[0].Id;
        wrk.RecordTypeId = rtByName.getRecordTypeId();
        wrk.Application__c = app.Id;
        wrk.Bypass_BM_Approval__c = true;
        wrk.Status__c = 'Assigned CMO';  
        lstRiskReferalToInsert.add(wrk);
      }
      if(!lstRiskReferalToInsert.isEmpty()) {
        insert lstRiskReferalToInsert;
        
        //Updated By DYU 05-05-2015 - Add FeedItem to application when a risk referral is added
        Set<Id> workflowIds = new set<Id>();
        for(WorkFlow__c w: lstRiskReferalToInsert){
            workflowIds.add(w.id);
        }
        List<WorkFlow__c> insertedWorkFlows = new List<WorkFlow__c>();
        if(workflowIds.size() > 0){
          insertedWorkFlows = [Select name, Application__c, id FROM Workflow__c WHERE id IN: workflowIds];
        }

        List<FeedItem> feedItemsForInsert = new List<FeedItem>();
        if(insertedWorkFlows.size() > 0){
          for(WorkFlow__c w: insertedWorkFlows){
            //create a feed item
            FeedItem post = new FeedItem();
            post.ParentId = w.Application__c;
            post.type = 'LinkPost';
            post.LinkUrl = '/'+w.Id ; 
            post.Title = w.Name + ' created';
            feedItemsForInsert.add(post);
          }
            system.debug('feedItem: '+feedItemsForInsert.size());
          if(feedItemsForInsert.size() > 0){
            insert feedItemsForInsert;        
          }
        }
      }
    }
}