/*****************************************************************
*Class Name: ContactTriggerHandler
*Purpose: Trigger Handler for the Contact SObject to help ensure the trigger code is bulkified and all in one place.
*Created date:11/04/2014  By Sandhyarani Behera
******************************************************************/

public with sharing class ContactTriggerHandler {

    public static Boolean DoNotCall_updateConStatePicklist = false;
    public static Boolean DoNotCall_validateSinglePrimary = false;
    public static Boolean DoNotCall_validateSinglePrimary_before = false;
    public static Boolean DoNotCall_validatePrimaryCampaignMember  = false;
    public static boolean isBeforeInsertExecuted= false;
    public static boolean isBeforeUpdateExecuted= false;
    public static boolean isAfterInsertExecuted = false;
    public static boolean isAfterUpdateExecuted = false;
    
    /*
    *   Populates fields which were previously formula fields which referenced encrypted fields
    */
    public static void setReferenceFieldsBefore(List<Contact> contacts){
        for(Contact con : contacts){
            con.Lastname_Firstname__c = con.LastName + ',' + con.FirstName;
        }
    }
    
    
     /*
        Purpose: To validate single primary contact per account and show error message. 
        @param contacts: list of the contact records and map of old contact records
    */
     public static void validateSinglePrimary_before(List<Contact> contacts,Map<ID,Contact>  oldcontacts){ 

        if(DoNotCall_validateSinglePrimary_before){
            log('validateSinglePrimary_before method has already been called.');
            return;
        }
        if(contacts == null || contacts.isEmpty()){
            log('validateSinglePrimary fuction argument is Null or empty.'+contacts);
            return;
        }

        Set<ID> contact_ids = new Set<ID>();
        Set<ID> account_ids = new Set<ID>();
        Map<id,List<Contact>> primary_contact = new Map<ID,List<Contact>>();
        
        for(Contact con : Contacts){
            if(con.AccountId != null && con.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId()){
                account_ids.add(con.AccountId);
                contact_ids.add(con.Id);
                if(con.Primary_Contact__c){     
                    if(primary_contact.containsKey(con.AccountId)){
                        primary_contact.get(con.AccountId).add(con);
                    }else{
                        primary_contact.put(con.AccountId,new List<Contact>{con});
                    }
                }
            }
        }

        if(account_ids == null || account_ids.isEmpty()){
        log('Contacts have no associated accounts.');return;
        }
        
        //To display error message if more than one primary inserted or updated
        if((primary_contact!=null)||!(primary_contact.isEmpty())){
            for(Id accid : primary_contact.Keyset()){
                List<contact> cons = primary_contact.get(accid);
                if(cons != null || !cons.isEmpty()){
                    if(cons.size() > 1){
                        for(Contact con : cons){
                            con.Primary_Contact__c.addError('There are more than one primary!');
                        }
                    }
                }
            }
        }
                
        //Code to execute only for insert..
        if(oldcontacts == null){
        
            Map<id,List<Contact>> accounts_contact = new Map<ID,List<Contact>>();
            List<Contact> contactList = new List<Contact>();
            
            contactList = [select id,AccountId,Primary_Contact__c from contact 
                            where AccountId in : account_ids 
                            AND id NOT IN: contact_ids 
                            AND Primary_Contact__c = true];
            log('All existing contacts:'+contactList);
            
            if(primary_contact.isEmpty() && contactList.isEmpty()){
                log('There is no primary contact for any of the associated accounts');
                for(Contact con : contacts){
                    con.Primary_Contact__c.addError('A Primary Contact Must Be Created.');
                }
            }else if(!contactList.isEmpty()){
                log('Few associated accounts have primary contacts.');
                for(Contact con : contactList){
                    if(accounts_contact.containsKey(con.AccountId)){
                        accounts_contact.get(con.AccountId).add(con);
                    }else{
                        accounts_contact.put(con.AccountId,new List<Contact>{con});
                    }
                }
                log('Accounts having primary contact[Account --> contacts]:'+accounts_contact);
            }

            if(!accounts_contact.isEmpty()){
                for(Id accid :account_ids){
                List<Contact> conlist = accounts_contact.containsKey(accid) ? accounts_contact.get(accid) :null;
                    if(conlist == null || conlist.isEmpty()){
                        //To display error message if account has no primary.
                        for(Contact con : Contacts){
                            if(con.AccountID == accid){
                                con.Primary_Contact__c.addError('A Primary Contact Must Be Created.');
                            }
                        }
                    }else{
                        log('This Account has primary contact:'+accid);
                    }
                }
            }
        }  //End of Insert code..
            
       DoNotCall_validateSinglePrimary_before =  true;
    }
    
     /*
        Purpose: To update old primary contacts to nonprimary if new primary is created. 
        @param contacts: list of the contact records and map of old contact records
    */
     public static void validateSinglePrimary(List<Contact> contacts,Map<ID,Contact>  oldcontacts){ 

        if(DoNotCall_validateSinglePrimary){
            log('validateSinglePrimary method has already been called.');
            return;
        }
        if(contacts == null || contacts.isEmpty()){
            log('validateSinglePrimary fuction argument is Null or empty'+contacts);
            return;
        }

        Set<ID> contact_ids = new Set<ID>();
        Set<ID> account_ids = new Set<ID>();
        Map<Id,Contact> ContactsToUpdate = new Map<Id,Contact>();
        
        for(Contact con : Contacts){
            if(con.AccountId != null && con.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId()){   
               account_ids.add(con.AccountId);
               if(con.Primary_Contact__c){
                    contact_ids.add(con.Id);
               }
            }
        }

        if(account_ids == null || account_ids.isEmpty()){
            log('Contacts have no associated accounts.');
            return;
        }
        log('primary contact_ids:'+contact_ids);
        if(!contact_ids.isEmpty()){
          List<Contact> contactList = new List<Contact>();
          contactList = [select id,AccountId,Primary_Contact__c from contact 
                          where AccountId in : account_ids 
                          AND id NOT IN : contact_ids 
                          AND Primary_Contact__c = true];
  
          log('Existing contacts:'+contactList);
          
          //To make the existing primary to non-primary if new primary is created..
          if(contactList != Null || !contactList.isEmpty()){
              for(Contact con : contactList){
                  if(ContactsToUpdate.containsKey(con.Id)){
                      ContactsToUpdate.get(con.ID).Primary_Contact__c = false;
                  }else{
                      ContactsToUpdate.put(con.Id,new Contact(Id=con.ID,Primary_Contact__c = false) );
                  }
              }
          }
        }
        log('Existing contacts to update#1:'+ContactsToUpdate);
        
        /*
        Code To Execute for after update..
        Primary contact should not be updated unless there is no other primary created.
        */
        if(oldcontacts != Null){
            for(Contact con : Contacts){
                if(con.AccountId != null 
                    && con.Primary_Contact__c != oldcontacts.get(con.id).Primary_Contact__c 
                    && !con.Primary_Contact__c){   
                   if(ContactsToUpdate.containsKey(con.Id)){
                        ContactsToUpdate.get(con.ID).Primary_Contact__c = true;
                    }else{
                        ContactsToUpdate.put(con.Id,new Contact(Id=con.ID,Primary_Contact__c = true) );
                    }
                }
            }
            log('Existing contacts to update#2:'+ContactsToUpdate);
        }
        
        DoNotCall_validateSinglePrimary = true;
        
        //update existing primary contaccts
        if(!ContactsToUpdate.isEmpty()){
            List<contact> conToUpdate = ContactsToUpdate.values();
            if(conToUpdate != null || !conToUpdate.isEmpty()){
                try{
                    update conToUpdate;
                }catch(DMLException e){
                    handle_exception(e,conToUpdate);    
                }
            }
        }     
    }

    public static void handle_exception(DMLException e,List<Contact> conToUpdate){
        map<String, List<String>> mapAllErrors = new map<String, List<String>>();
        for (Integer i = 0; i < e.getNumDml(); i++){
            if(StatusCode.REQUIRED_FIELD_MISSING == e.getDmlType(i)){    
              if(mapAllErrors.containskey(e.getDmlId(i))){          
                List<String> tLst = mapAllErrors.get(e.getDmlId(i));
                tLst.addAll(e.getDmlFieldNames(i));
                mapAllErrors.put(e.getDmlId(i), tLst);
              }
              else        
                mapAllErrors.put(e.getDmlId(i), e.getDmlFieldNames(i));
            }else if(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION == e.getDmlType(i)){     
              if(mapAllErrors.containskey(e.getDmlId(i))){                  
                List<String> tLst = mapAllErrors.get(e.getDmlId(i));
                tLst.addAll(e.getDmlFieldNames(i));
                mapAllErrors.put(e.getDmlId(i), tLst);             
              }
              else       
                mapAllErrors.put(e.getDmlId(i), e.getDmlFieldNames(i));
            }else if(StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION == e.getDmlType(i)){
              if(mapAllErrors.containskey(e.getDmlId(i))){
                List<String> tLst = mapAllErrors.get(e.getDmlId(i));
                tLst.addAll(e.getDmlFieldNames(i));
                mapAllErrors.put(e.getDmlId(i), tLst);
              }else
                mapAllErrors.put(e.getDmlId(i), e.getDmlFieldNames(i));
            } 
        }   
        
        if(!mapAllErrors.isEmpty()){
            for(Contact con : conToUpdate){
                List<String> conFields = mapAllErrors.get((String)con.Id);
    
                if(conFields != null || !conFields.isEmpty()){
                    String errFields = '';
                    for(String str :  conFields){
                        errFields = (errFields == '' ? str : errFields+','+str);
                    }
                    String errMessage = '';
                    if(errFields != ''){
                        errMessage = ' Current Primary Contact'+
                                     '<a href=\'/' + con.Id + '\'>' +
                                      con.Name + '</a>'+' has invalid data in fields '+errFields+'.';
                        errMessage = errMessage+'<br/> Please update '+
                                     ' <a href=\'/' + con.ID + '\'>' +
                                      con.Name + '</a>' +'before proceeding.';
                        errMessage = errMessage.replace('__c','').replace('_',' ').replace('Error:',' ');
                    }else{
                        continue;
                    }
                    con.addError(errMessage);
                }
            }
        }
    }
    /*
        Purpose:  Static log method for trouble-shooting
        @param contacts: Expected error message.
    */
    static void log(Object obj){
        system.debug(LoggingLevel.INFO,obj);
    }
 
   
    
    
    }