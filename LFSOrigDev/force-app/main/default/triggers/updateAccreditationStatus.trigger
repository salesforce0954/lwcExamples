trigger updateAccreditationStatus on Accreditation__c (after insert, after update) {
 
 Disable_Trigger__c profileCustomSetting = Disable_Trigger__c.getInstance(UserInfo.getUserId());
 if(!profileCustomSetting.Donot_Run_Trigger__c){
    
    Set<Id> accountId = new Set<Id>();
    Set<Id> contactId = new Set<Id>();
    Map<Id, Account> accToUpdate  = new Map<Id, Account>();
    Map<Id, Contact> conToUpdate  = new Map<Id, Contact>();
    for (Accreditation__c a : trigger.new){
        if(a.Account__c!=null || a.Aggregator__c!=null){
            accountId.add(a.Account__c);
            accountId.add(a.Aggregator__c);
        }
        if(a.Contact__c!=null){
            contactId.add(a.Contact__c);
        }
 
        System.debug('********** Account Ids' + accountId);
        System.debug('********** Contact Ids' + contactId);

    }
    
    Try{
        if(!accountId.isEmpty()){
        for(account a:[SELECT id,Name, Account_Accreditation_Status_cons__c, Aggregator_Account_Name__c,  
                             Broker_Product__c, Accredited_Date__c           
                             FROM Account WHERE Id IN:accountId])
            accToUpdate.put(a.Id, a);                                            
        }
        
        if(!contactId.isEmpty()){
        for(Contact c:[SELECT id, Aggregator_Name__c, Accreditation_Process_Stage__c,
                              Contact_Accreditation_Status__c,Broker_Product__c 
                              FROM Contact WHERE Id IN:contactId])
            conToUpdate.put(c.Id, c);                                            
        }   
    
        
        if(!accToUpdate.isEmpty() || !conToUpdate.isEmpty()){
             
            
            for (Accreditation__c adt: trigger.new){
                 if(contactId.isEmpty()){       
                     if(accToUpdate.get(adt.Account__c)!=null){
                         account ac = accToUpdate.get(adt.Account__c);
                         if(adt.Accreditation_Status__c!=null){
                            ac.Account_Accreditation_Status_cons__c  = adt.Accreditation_Status__c;
                            ac.Accreditation_Process_Stage_cons__c  = adt.Accreditation_Process_Stage__c;
                            ac.Broker_Product__c = adt.Broker_Product__c;
                            ac.Accredited_Date__c = adt.Accreditation_Active_Date__c;
                            ac.Accreditation_Ceased_Date__c = adt.Accreditation_Ceased_Date__c;
                      
                            if(Trigger.isUpdate && Trigger.oldMap.get(adt.Id).Accreditation_Status__c != Trigger.newMap.get(adt.Id).Accreditation_Status__c){
                                ac.Accreditation_Status_Update__c = Date.Today();
                            } else {
                                ac.Accreditation_Status_Update__c = Date.Today();
                            }
                            
                            if(adt.Aggregator__c!=null){
                                if(ac.Aggregator_Account_Name__c!=null){
                                 if(!((ac.Aggregator_Account_Name__c).contains(accToUpdate.get(adt.Aggregator__c).Name))){
                                    ac.Aggregator_Account_Name__c += ',' + accToUpdate.get(adt.Aggregator__c).Name;
                                 }
                                }
                                else{ac.Aggregator_Account_Name__c = accToUpdate.get(adt.Aggregator__c).Name;} 
                            }
                            accToUpdate.put(ac.Id, ac);
                            }
                        }
                    }   
                 
                 
                 if(conToUpdate.get(adt.Contact__c)!=null){
                     contact co = conToUpdate.get(adt.Contact__c);
                     co.Contact_Accreditation_Status__c = adt.Accreditation_Status__c;
                     co.Broker_Product__c = adt.Broker_Product__c;
                     co.Accredited_Date_Cons__c = adt.Accreditation_Active_Date__c;
                     co.Accreditation_Process_Stage__c = adt.Accreditation_Process_Stage__c;
                     co.Accreditation_Ceased_Date__c = adt.Accreditation_Ceased_Date__c;                   
                     co.Contact_Accreditation_Status_Update__c = Date.Today();
          
                     if(adt.Aggregator__c!=null){
                         if(co.Aggregator_Name__c!=null){
                             if(!((co.Aggregator_Name__c).contains(accToUpdate.get(adt.Aggregator__c).Name))){
                                co.Aggregator_Name__c += ',' + accToUpdate.get(adt.Aggregator__c).Name;
                             }
                        }
                         else{co.Aggregator_Name__c = accToUpdate.get(adt.Aggregator__c).Name;}
                     }
                     conToUpdate.put(co.Id, co);
                 }
             }
        }
       
        if(!accToUpdate.isEmpty()){
            Database.update(accToUpdate.values());
        }
        if(!conToUpdate.isEmpty()){
            Database.update(conToUpdate.values());
        }
    
    }Catch(Exception e){
        System.debug(e.getMessage());
    }
 }//do not run if statement    
}