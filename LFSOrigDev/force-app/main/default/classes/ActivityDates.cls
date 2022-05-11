public class ActivityDates{
    // User map
    public static Map<Id, User> mapUser;
    public static String userProfileName = HelperClass.getProfileInfo(userInfo.getProfileId()).name;
    static Id taskRectypeid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Accreditations').getRecordTypeId();
    static Id eventRectypeid = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Event Accreditations').getRecordTypeId();
    // Business Unit On Tasks BEFORE LOAD
    public static void putTBusinessUnit(Task[] tasks){
        if(mapUser == null){
            mapUser = QueryUtil.mapUsers(null, tasks, null);
        }        
        for(Task t:tasks){
            if(isTaskAccreditationRecordType(t)){
                log('Associated task owner detail:'+mapUser);
                log('Associated task ownerId:'+t.OwnerId);
                if(mapUser.get(t.OwnerId)!=null){
                    if(String.isBlank(mapUser.get(t.OwnerId).Business_Unit__c)){
                        t.addError(Label.Invalid_Owner_Business_Unit);              
                    }else{
                        t.Business_Unit__c = mapUser.get(t.OwnerId).Business_Unit__c;
                        t.Owner_Locale__c  = mapUser.get(t.OwnerId).LocaleSidKey;
                    }
                }
            }
        }
        
    }
    
    // Business Unit On Events BEFORE LOAD
    public static void putEBusinessUnit(Event[] events){
        if(mapUser == null){
            mapUser = QueryUtil.mapUsers(Events, null, null);
        }
        for(Event e:events){
            if(isEventAccreditationRecordType(e)){
                if(String.isBlank(mapUser.get(e.OwnerId).Business_Unit__c )){
                    e.addError(Label.Invalid_Owner_Business_Unit);                  
                }else{           
                    e.Business_Unit__c = mapUser.get(e.OwnerId).Business_Unit__c;
                    e.Owner_Locale__c  = mapUser.get(e.OwnerId).LocaleSidKey;
                }
            }
        }   
    }
    
    // Work out whether a task is against a Contact or an Account
    public static void SortTask(Task[] tasks){
    
        if(mapUser == null){mapUser = QueryUtil.mapUsers(null, tasks, null);}
        List<Task> aTasks = new List<Task>();
        List<Task> cTasks = new List<Task>();
        
        for(Task t:tasks){
            if(isTaskAccreditationRecordType(t)){
                if((t.WhoId != null && String.ValueOf(t.WhoId).StartsWith('003')) && (t.WhatId != null && (String.ValueOf(t.WhatId).StartsWith('006')))){
                    cTasks.add(t);
                    aTasks.add(t);
                }else if((t.WhoId != null && String.ValueOf(t.WhoId).StartsWith('003')) && (t.WhatId != null && (String.ValueOf(t.WhatId).StartsWith('001')))){
                    cTasks.add(t);
                    aTasks.add(t);
                }else if(t.WhoId != null && String.ValueOf(t.WhoId).StartsWith('003')){
                    cTasks.add(t);
                }else if(t.WhatId != null && (String.ValueOf(t.WhatId).StartsWith('001') || String.ValueOf(t.WhatId).StartsWith('006'))){
                    aTasks.add(t);
                }
            }
        }
        if(!aTasks.isEmpty()){AccountTask(aTasks, null);}
    }
    // Work out whether an Event is against a Contact or an Account
    public static void SortEvent(Event[] Events){
    
        if(mapUser == null){mapUser = QueryUtil.mapUsers(Events, null, null);}
        List<Event> aEvents = new List<Event>();
        List<Event> cEvents = new List<Event>();
        
        for(Event e:Events){
            if(isEventAccreditationRecordType(e)){
                if((e.WhoId != null && String.ValueOf(e.WhoId).StartsWith('003')) && (e.WhatId != null && (String.ValueOf(e.WhatId).StartsWith('006')))){
                    cEvents.add(e);
                    aEvents.add(e);
                }else if((e.WhoId != null && String.ValueOf(e.WhoId).StartsWith('003')) && (e.WhatId != null && (String.ValueOf(e.WhatId).StartsWith('001')))){
                    cEvents.add(e);
                    aEvents.add(e);
                }else if(e.WhoId != null && String.ValueOf(e.WhoId).StartsWith('003')){
                    cEvents.add(e);
                }else if(e.WhatId != null && (String.ValueOf(e.WhatId).StartsWith('001') || String.ValueOf(e.WhatId).StartsWith('006'))){
                    aEvents.add(e);
                }
            }
        }
        if(!aEvents.isEmpty()){AccountEvent(aEvents, null);}
    }
    
    // For Events once they are completed update the last contact dates on the parent account
    public static void AccountEvent(Event[] events, Map<Id, Contact> mapContacts){  
        map<Id, Account> mapAccount = new Map<Id, Account>();
        Map<Id,Opportunity> mapOpp = new Map<Id, Opportunity>();
        Map<Id, String> userNames = new Map<Id, String>(); //Ashutosh: 5-Jan-2012
        Set<Id> userIds = new Set<Id>();//Ashutosh: 5-Jan-2012
        
        // First loop through our events and pull AccountIds
        Set<ID> oppIds = new Set<ID>();
        for(Event e:events){
            if(isEventAccreditationRecordType(e)){
                if(e.Status_Event__c == 'Completed' && String.ValueOf(e.WhatId).StartsWith('001')){
                    mapAccount.put(e.WhatId, null);
                }else if(e.Status_Event__c == 'Completed' && String.ValueOf(e.WhatId).StartsWith('006')){
                    oppIds.add(e.WhatId);
                }
                userIds.add(e.OwnerId);
            }
        } 
        
        if(!oppIds.isEmpty()){
            for(Opportunity o:[Select AccountId from Opportunity where Id IN: oppIds]){
                mapAccount.put(o.AccountId, null);
                mapOpp.put(o.AccountId,o);
            }
        }
        
        
        
        //We were hitting lookup limit on account, hence we created text fields. Below code fetches Username.
        if(userIds != null){
          for(User usr:[Select Id, Name from User Where Id IN: userIds]){
            userNames.put(usr.Id, usr.Name);
          }     
        }
        
        log('MAP ACCOUNT SIZE===>' +mapAccount.size());
        
        // Fill map with Account records
        for(Account[] arrAccount : [Select Id,                                     
                                    Overall_Last_Meeting_Made_By__c,Last_Meeting_Date_cons__c
                                    From Account 
                                    Where Id IN :mapAccount.keySet()]){
            for(Account sAccount : arrAccount){
                mapAccount.put(sAccount.Id, sAccount);
            }
        }
    
        // fill wth opps ids for keyset
        for(ID myID:mapOpp.keySet()){
            mapAccount.put(mapOpp.get(myID).Id,mapAccount.get(myID));
        }
        
        // A list of Accounts to hold for update
        List<Account> Accounts = new List<Account>();
        Set<ID> uIDs = new Set<ID>();
        
        // Fill in the Last Contact dates for each business unit
        for(Event e:events){
            if(isEventAccreditationRecordType(e)){
                if(e.Status_Event__c == 'Completed'){
                    //date lastContact = Date.newInstance(e.Actual_Completion_Date__c.year(), e.Actual_Completion_Date__c.month(), e.Actual_Completion_Date__c.day());
                    date lastContact;
                    
                    if(e.Actual_Completion_Date__c != null){
                        lastContact = date.newInstance(e.Actual_Completion_Date__c.year(), e.Actual_Completion_Date__c.month(), e.Actual_Completion_Date__c.day());
                    }else if(e.LastModifiedDate!=null){
                        lastContact = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                    }else{
                        lastContact = date.valueOf(e.EndDateTime);
                    }                
                    
                    // For individual business units
                    if( mapUser.get(e.OwnerId).Business_Unit__c.Contains('Consumer')){
                        if(mapAccount.get(e.WhatId).Last_Meeting_Date_cons__c == null || lastContact > mapAccount.get(e.WhatId).Last_Meeting_Date_cons__c){
                            mapAccount.get(e.WhatId).Last_Meeting_Date_cons__c = lastContact;
                            mapAccount.get(e.WhatId).Overall_Last_Meeting_Made_By__c = e.OwnerId;
                        }
                    }
                                                             
                    
                    if(!uIDs.contains(e.WhatId)){
                        Accounts.add(mapAccount.get(e.WhatId));
                        uIDs.add(e.WhatId);
                    }
                
                }
            }
            
        }
        if(!accounts.isEmpty()){                    
            try{
                update accounts;
            }catch (DMLException err){       
                String mystring = err.getmessage().replace(' ',''); //Replacing space ' ' for string comparison like "FirstNameis" with standard error message.             
                system.debug(mystring); 
                handleExceptionForEventOnAccountUpdate(trigger.new,mystring);
            } 
        }
      
    } 
    // For Tasks once they are completed update the last contact dates on the parent account
    public static void AccountTask(Task[] tasks, Map<ID, Contact> mapContacts){     
        map<Id, Account> mapAccount = new Map<Id, Account>();
        Map<Id,Opportunity> mapOpp = new Map<Id, Opportunity>();
        
        Map<Id, String> userNames = new Map<Id, String>(); //Ashutosh: 5-Jan-2012
        Set<Id> userIds = new Set<Id>();//Ashutosh: 5-Jan-2012  
        
        // First loop through our Tasks and pull AccountIds
        Set<ID> oppIds = new Set<ID>();
        for(Task t:Tasks){            
            if(t.WhatId!=null){ 
                if(t.Status == 'Completed' && String.ValueOf(t.WhatId).StartsWith('001')){
                    mapAccount.put(t.WhatId, null);
                }
                else if(t.Status == 'Completed' && String.ValueOf(t.WhatId).StartsWith('006')){
                    oppIds.add(t.whatId);
                }
                userIds.add(t.OwnerId);
            }
        }
        
        if(!oppIds.isEmpty()){
            for(Opportunity o:[Select Id, AccountId from Opportunity where Id IN: oppIds]){
                mapAccount.put(o.AccountId, null);
                mapOpp.put(o.AccountId,o);
            }
        }
        
        //We were hitting lookup limit on account, hence we created text fields. Below code fetches Username.
        if(userIds != null){
            for(User usr:[Select Id, Name from User Where Id IN: userIds]){
                userNames.put(usr.Id, usr.Name);
            }     
        }       
        
        if(mapContacts != null){
            for(ID c:mapContacts.keySet()){
                mapAccount.put(mapContacts.get(c).AccountId, null);
            }
        }
        // Fill map with Account records
        for(Account[] arrAccount : [Select Id, 
                                     
                                    Overall_Last_Call_Date__c, Overall_Last_Call_Made_By__c,
                                    Overall_Last_Meeting_Made_By__c
                                    From Account 
                                    Where Id IN :mapAccount.keySet()]){
            for(Account sAccount : arrAccount){
                mapAccount.put(sAccount.Id, sAccount);
            }
       }
        // fill wth opps ids for keyset
        for(ID myID:mapOpp.keySet()){
            mapAccount.put(mapOpp.get(myID).Id,mapAccount.get(myID));
        }
        
        log('SIZE OF ACCOUNT==>' + mapAccount.size());

        // A list of Accounts to hold for update
        List<Account> Accounts = new List<Account>();
        Set<ID> uIDs = new Set<ID>();
        
        // Fill in the Last Contact dates for each business unit
        for(Task t:Tasks){
            if((t.Status == 'Completed' && 
                    (t.Type == 'Call' 
                    || t.Type == 'Call Received' 
                    || t.Type == 'Email - Inbound' 
                    || t.Type == 'Email - Outbound' 
                    || t.Type == 'Letter' 
                    || t.Type == 'Fax' 
                    || t.Type == 'Meeting'
                    )
                )){
                // For emails use last modified by
                date lastContact;
                
                if(t.Actual_Completion_Date__c != null){
                    lastContact = date.newInstance(t.Actual_Completion_Date__c.year(), t.Actual_Completion_Date__c.month(), t.Actual_Completion_Date__c.day());
                }
                else if(t.ActivityDate > Date.Today() && t.Actual_Completion_Date__c == null){ // Modified by Pradeep 14th July 2014
                    lastContact = null;
                }else {
                    lastContact = date.Today(); // Modified by Pradeep 14th July 2014
                }

                if((mapAccount.get(t.WhatId)) != null){
                     
                    if((t.Type == 'Call' || t.Type == 'Call Received') && (mapAccount.get(t.WhatId).Overall_Last_Call_Date__c == null 
                        || lastContact > mapAccount.get(t.WhatId).Overall_Last_Call_Date__c)){
                        mapAccount.get(t.WhatId).Overall_Last_Call_Date__c = lastContact;
                        mapAccount.get(t.WhatId).Overall_Last_Call_Made_By__c = t.OwnerId;
                    }               
                    if(!uIDs.contains(t.WhatId)){
                        Accounts.add(mapAccount.get(t.WhatId));
                        uIDs.add(t.WhatId);
                    }
                }
            }
        }
        if(!accounts.isEmpty()){  
            try{
                update accounts;            
            }catch (DMLException e){ 
                String mystringTask = e.getmessage().replace(' ',''); //Replacing space ' ' for string comparison like "FirstNameis" with standard error message.   
                log('+stringetaskerrors++++++++'+mystringTask);
                handleExceptionForTaskOnAccountUpdate(tasks,mystringTask);
            }
        }
    }       
            
    
    
        
    public static void handleExceptionForTaskOnAccountUpdate(task[] tasks,string mystringTask)
    {
        for (Task tk : tasks) {                
            if (myStringTask.contains('0290099009')==true){
            tk.addError('Please update the Phone numbers on the Accounts page, for Australian Users, phone numbers must be 10 digits ie. 02 9009 9009, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('areacode')==true){
            tk.addError('Please update the Phone numbers on the Accounts page, numbers must be 9 or 10 digits including area code, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}           
            
            else if (myStringTask.contains('AccountStatusrequired')==true){
            tk.addError('Please update the "Account Status" field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('FleetNumber')==true){
            tk.adderror('Fleet Number is required for Customers, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('BusinessTypeis')==true){
            tk.adderror('Please update "Business Type" on the Accounts page as this is mandatory once an Account or Partner is classified as a Customer, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
        
            else if (myStringTask.contains('ABNisrequired')==true){
            tk.adderror('ABN field on the Accounts page is required if country is Australia, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('ABNmustbe')==true){
            tk.adderror('ABN must be 11 digits, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
        
            else if (myStringTask.contains('Dealernumberis')==true){
            tk.adderror('Dealer number is a mandatory, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('Dealernumberhas')==true){
            tk.adderror('Dealer number has to be atleast 4 digits long, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystringTask.contains('PhysicalCityis')==true){
            tk.adderror('Physical City is mandatory, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myStringTask.contains('SIC')==true){
            tk.adderror('Please update SIC field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else{tk.addError('Mandatory information needs to be entered against the Account before changing the activity to completed. Please go to the Account, edit, save and it will tell you exactly what is missing. Complete and save. For further support please email ASPACSFDCSupport@ge.com');}              
            } 
    }
    
    public static void handleExceptionForEventOnAccountUpdate(event[] events,string myString){
         for (Event ev : events) {                          
            if (myString.contains('0290099009')==true){
            ev.addError('Please update the Phone numbers on the Accounts page, for Australian Users, phone numbers must be 10 digits ie. 02 9009 9009, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myString.contains('areacode')==true){
            ev.addError('Please update the Phone numbers on the Accounts page, numbers must be 9 or 10 digits including area code, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (myString.contains('AccountStatusrequired')==true){
            ev.addError('Please update the "Account Status" field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('FleetNumber')==true){
            ev.adderror('Fleet Number is required for Customers, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('BusinessTypeis')==true){
            ev.adderror('Please update "Business Type" on the Accounts page as this is mandatory once an Account or Partner is classified as a Customer, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
        
            else if (mystring.contains('ABNisrequired')==true){
            ev.adderror('ABN field on the Accounts page is required if country is Australia, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('ABNmustbe')==true){
            ev.adderror('ABN must be 11 digits, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('Dealernumberis')==true){
            ev.adderror('Dealer number is a mandatory, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('Dealernumberhas')==true){
            ev.adderror('Dealer number has to be atleast 4 digits long, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('PhysicalCityis')==true){
            ev.adderror('Physical City is mandatory, please update field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}
            
            else if (mystring.contains('SIC')==true){
            ev.adderror('Please update SIC field on the Accounts page, please contact the ASPAC Team <ASPACSFDCSUPPORT@GE.COM> if you have any questions.');}

            else if (mystring.contains('FleetCross-SellOpportunity')==true){
            ev.adderror('Please update the "Fleet Cross-Sell Opportunity" field in the Account screen before completing the meeting.');}
            
            else if (mystring.contains('EFCross-SellOpportunity')==true){
            ev.adderror('Please update the "EF Cross-Sell Opportunity" field in the Account screen before completing the meeting.');}
            
            else{ev.addError('Mandatory information needs to be entered against the Account before changing the activity to completed. Please go to the Account, edit, save and it will tell you exactly what is missing. Complete and save. For further support please email ASPACSFDCSupport@ge.com');}
        } 
    }

    static void log(object obj){
        System.debug(LoggingLevel.INFO, obj);
    }  

    static Boolean isEventAccreditationRecordType(Event e)
    {        
        return e.RecordTypeId == eventRectypeid;
    }

    static Boolean isTaskAccreditationRecordType(Task t)
    {
        return t.RecordTypeId == taskRectypeid;
    }
}