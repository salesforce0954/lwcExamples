/*****************************************************************
*Class Name: AccountTriggerHandler
*Purpose: Trigger Handler for the Account SObject to help ensure the trigger code is bulkified and all in one place.
*Created date:03/04/2014  By Rohini Aher
*Modified for Broker Accreditation - JUNE 03 2015
******************************************************************/

public class AccountTriggerHandler{
    
    public static boolean isAfterUpdateExecuted = false;
    public static boolean isAfterInsertExecuted = false;
    public static boolean isBeforeInsertExecuted = false;
    public static boolean isBeforeUpdateExecuted = false;
    public static boolean isAfterDeleteExecuted = false;
    public static Map<Id, string> recordTypeMap = new Map<Id, string>();
    public static Boolean Do_Not_Run_Trigger = false;
    
    
    
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
    
    public static void executeTriggerEvents(boolean isBefore, boolean isAfter, boolean isInsert, boolean isUpdate,boolean isDelete, List<Account>newAccList, Map<Id, Account>newAccMap, 
                                                List<Account>oldAccList, Map<Id, Account> oldAccMap ){
        System.debug('Inside executeTriggerEvents');
        if(!Utils.is_enabled('AccountTrigger')){
            return; 
        }
        
        //fetch record types
        getRecordTypes();
        
        if(isInsert && isAfter){
            System.debug('Inside isInsert && isAfter');
            if(!isAfterInsertExecuted){
                System.debug('******* Line 47 *******');updateChildRecords_AfterInsertUpdate(newAccList);
                isAfterInsertExecuted = true;
            }
        } 
        if(isUpdate && isBefore){
             System.debug('Inside isUpdate && isBefore');
             if(!isBeforeUpdateExecuted){     
                updateRecordFieldsOnSave(isInsert, isUpdate,newAccList, newAccMap, oldAccMap); 
                System.debug('Line 61 isUpdate && isBefore');updateAccountABNBalances_BeforeInsertUpdate(isInsert, isUpdate, newAccList, newAccMap, oldAccMap );
                isBeforeUpdateExecuted = true;
            }
        } 
        
        if(IsInsert && isBefore) {
             System.debug('Inside IsInsert && isBefore');
             System.debug(newAccList);
             if(!isBeforeInsertExecuted){ 
                updateRecordFieldsOnSave(isInsert, isUpdate,newAccList, newAccMap, oldAccMap);     
                updateAccountABNBalances_BeforeInsertUpdate(isInsert, isUpdate,newAccList, newAccMap, oldAccMap );
                isBeforeInsertExecuted = true;
             } 
            
        }   
        if(isUpdate && isAfter){
            System.debug('Inside isUpdate && isAfter');
            if(!isAfterUpdateExecuted){
                System.debug('******* Line 102 *******');updateChildRecords_AfterInsertUpdate(newAccList);
                //Calling this method to create audit Records after update 
                System.debug('******* Line 105 *******');
                HelperClass.createAuditRecords(newAccList,oldAccMap);
                updateChildRecordsOnBrokerDataChange(isInsert, isUpdate, newAccList, newAccMap, oldAccMap);
                isAfterUpdateExecuted = true; 
            }
        }                                                                                                    
    }
    
   public static void getRecordTypes(){
      
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = sObjectMap.get('Account') ; 
        // getting Sobject Type
        Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
        //getting all Recordtype for the Sobject
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); 
        
        for( Schema.RecordTypeInfo info:  recordTypeInfo.values() ){
            recordTypeMap.put(info.getRecordTypeId(), info.getName());
        }
    }

    /*
    *   Method name: updateRecordFieldsOnSave update fields on the account record. 
    *   Used to replace formula fields which reference encrypted fields
        Created By: Luke Sevior
    */  
    public static void updateRecordFieldsOnSave(Boolean isInsert, Boolean isUpdate, 
                                                                    List<Account> accountList, 
                                                                    Map<Id, Account> newMap, 
                                                                    Map<Id, Account> oldMap ){
        for(Account acc : accountList){
            if(acc.Name != null && acc.Name.contains('snooze')){
                acc.Account_Logo_Snooze__c = true;
            }
            else{
                acc.Account_Logo_Snooze__c = false;
            }
            
        }
    }
    
    /*
    * Method name: updateChildRecordsOnBrokerDataChange Update Contact, Application and Disbursement.
      Created By: Fahad Akhtar
    */  
    public static void updateChildRecordsOnBrokerDataChange(Boolean isInsert, Boolean isUpdate, 
                                                                    List<Account> accountList, 
                                                                    Map<Id, Account> newMap, 
                                                                    Map<Id, Account> oldMap ){
        //Start check recursive call
        if(StopRecursionCalls.getStatus('AccountTriggerHandler.updateChildRecordsOnBrokerDataChange')){
            return;
        }

        // Check for updated fields
        List<Id> updatedAccountIds = new List<Id>();
        for(Account acc : accountList){
            if(oldMap.containsKey(acc.Id)){
                if((acc.Aggregator_Account_Name__c != oldMap.get(acc.Id).Aggregator_Account_Name__c)
                    || (acc.Trust_Entity_Name__c != oldMap.get(acc.Id).Trust_Entity_Name__c)){
                    updatedAccountIds.add(acc.Id);
                }
            }  
        }

        // Query related records for updated accounts
        List<Account> updatedAccounts = [
                                            SELECT 
                                                    Id,
                                                    Aggregator_Account_Name__c,
                                                    Trust_Entity_Name__c,
                                                    (SELECT 
                                                            Id, 
                                                            Name
                                                            //Change Broker Aggregator Account Name and Broker Trust Entity Name to formula fields- MDAVID 8/11/2016
                                                            //Broker_Aggregator_Account_Name__c, 
                                                            //Broker_Trust_Entity_Name__c
                                                    FROM 
                                                            Contacts)
                                            FROM 
                                                    Account 
                                            WHERE 
                                                    Id in :updatedAccountIds
                                        ];
        
        // Set fields
        List<contact> contactsToUpdate = new List<contact>();

        for(Account acc : updatedAccounts){
            for(Contact con : acc.Contacts){
                //Change Broker Aggregator Account Name and Broker Trust Entity Name to formula fields- MDAVID 8/11/2016
                //con.Broker_Aggregator_Account_Name__c = newMap.get(acc.Id).Aggregator_Account_Name__c; 
                //con.Broker_Trust_Entity_Name__c = newMap.get(acc.Id).Trust_Entity_Name__c;
                contactsToUpdate.add(con);
            }
        }

        //Update all list at once. 
        update contactsToUpdate;
    }    
       
    /*
    * Method name: updateAccountABNBalances_BeforeInsertUpdate for before Insert and Update event
    * Purpose: This method searches the ABN Balances static table for the ABN or NZ Co num value entered
    * for this account. If a match is found we populate the Lookup reference to the ABN Balances table.
    */
    public static void updateAccountABNBalances_BeforeInsertUpdate(Boolean isInsert, Boolean isUpdate, 
                                                                    List<Account>accountList, 
                                                                    Map<Id, Account>newMap, 
                                                                    Map<Id, Account>oldMap ){
        
        //Start check recursive call*/
        if(StopRecursionCalls.getStatus('AccountTriggerHandler.updateAccountABNBalances_BeforeInsertUpdate')){
        return;
        }  
        //Stop check recursive call*/   
        
        Set<String> eRefs = new Set<String>();
        // Fill set for Accounts in trigger batch
        for(Account a:accountList){
            if(isInsert && a.ABN__c != null){eRefs.add(a.ABN__c);}
            if(isUpdate && a.ABN__c != null && a.ABN__c != oldMap.get(a.Id).ABN__c){eRefs.add(a.ABN__c);}
            if(isUpdate && a.ABN__c != null){eRefs.add(a.ABN__c);}
        }
        
        // Map to hold ABN Balances records
        MAP<String, ID> eRef_Map = new MAP<String, ID>();
        if(!eRefs.IsEmpty()){  
            // Fill MAP with relevant IDs
            for(ABN_Balances__c abn:[Select Id, ABN_NZ_COMPANY_NO__c From ABN_Balances__c Where ABN_NZ_COMPANY_NO__c IN: eRefs]){
                eRef_Map.put(abn.ABN_NZ_COMPANY_NO__c, abn.Id);
            }
        }
        
        // Link Accounts to their relevant ABNBalances Records.
        for(Account a:accountList){
             if(a.ABN__c != null){
                if(eRef_Map.containsKey(a.ABN__c)){
                    a.ABN_NZ_Co_No_LookUP__c = eRef_Map.get(a.ABN__c); 
                }else{
                    a.ABN_NZ_Co_No_LookUP__c = null;
                }
             }
             else{
                continue;
            }
            Utils.log('##ABN__c '+a.ABN__c );  
            //Utils.log('##NZ_Company_Incorporation_Number__c'+a.NZ_Company_Incorporation_Number__c);  
            Utils.log('##ABN_NZ_Co_No_LookUP__c'+a.ABN_NZ_Co_No_LookUP__c);  
        }
        
    }

    /*
    * Method name: updateChildRecords_AfterInsertUpdate for after insert and update event
    * Purpose:update child records
    */
    public static void updateChildRecords_AfterInsertUpdate(List<Account> accountList){
        //Start check recursive call
        if(StopRecursionCalls.getStatus('AccountTriggerHandler.updateChildRecords_AfterInsertUpdate')){
            return;
        }
        //Stop check recursive call
        if(Utils.is_enabled('updateChildRecords_AfterInsertUpdate')){        
            Set<Id> accountIds = new Set<Id>();
            List<Account> childAccounts = new List<Account>();
            Map<Id, Account> newAccMap = new Map<Id, Account>();
            for(Account ccf : accountList){
                if(ccf.Primary_Business_Unit__c == 'Consumer'){
                    AccountIDs.add(ccf.Id);
                    newAccMap.put(ccf.Id, ccf);
                }
            }
            System.debug('Accounts-Ids--'+accountIds);  
            Map<id,account> aMap = new Map<id,account>([SELECT Name, ParentId, Description, Id,Parent.Program_Strategy_cons__c, 
                                                                Program_Strategy_cons__c, Parent.Description, Ownerid 
                                                            FROM Account 
                                                            where ParentId IN :accountIds]);
            System.debug('-----'+aMap );
            List<account> accounts = aMap.values() ;
         
            System.debug('Accounts---'+accounts);          
            for(Account child : accounts){
                 if(child.ParentId!= null){
                    child.Program_Strategy_cons__c= child.Parent.Program_Strategy_cons__c;   
                    childAccounts.add(child); 
                 }
            }   
            
            if(!childAccounts.IsEmpty()){
                 List<Database.SaveResult> updateResult = Database.update(childAccounts);
                 for (Database.SaveResult sr : updateResult) {
                    if (!sr.isSuccess()) {
                       if( aMap.containsKey(sr.getId()) ){
                           for(Database.Error err : sr.getErrors()) {
                               if( newAccMap.containsKey( aMap.get(sr.getId()).parentId ) && 
                                   newAccMap.containsKey( aMap.get(sr.getId()).parentId ) != NULL ){
                                   newAccMap.get( aMap.get(sr.getId()).parentId ).addError(Label.UpdateChildRecordError);                  
                               }
                           }
                        }   
                    }
                    
                }
            }       
        }      
    }
    
    
    
    
    public static void log(Object obj){ 
        System.debug(LoggingLevel.INFO, obj);
    }          
                   
}