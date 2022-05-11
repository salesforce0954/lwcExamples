trigger updateMerchantNumber on Merchant_ID__c (before insert, after insert) {

    Disable_Trigger__c profileCustomSetting = Disable_Trigger__c.getInstance(UserInfo.getUserId());
    if(!profileCustomSetting.Donot_Run_Trigger__c){
   
    Set<Id> mIds = new Set<Id>();
    Set<Id> accIds = new Set<Id>();
    String groupName='';
    String cardAu = 'NotPresent';
    List<Merchant_ID__c> tempMerchantList = new List<Merchant_ID__c>();
    List<Account> tempAccList = new List<Account>();
    
    for(Merchant_ID__c m : Trigger.new){
       groupName = '%'+m.Merchant_Group__c+'%';
       cardAu = m.Merchant_Group__c;
       System.debug('groupName'+groupName);
    }
    try{
    Merchant_ID__c merchantNumber;
    if(cardAu.equals('Cards AU')){
        merchantNumber = [Select id, Merchant_Number__c, Merchant_Group__c
                       from Merchant_ID__c 
                       where ((Merchant_Number__c >=  408000 and Merchant_Number__c <= 498000)AND
                       (Id != null AND Merchant_Number__c!= null AND Group_Merchant_Number__c LIKE:groupName))
                       Order by Merchant_Number__c DESC Limit 1];       
    
    }else if(cardAu.equals('Healthcare AU')){
        merchantNumber = [Select id, Merchant_Number__c, Merchant_Group__c
                       from Merchant_ID__c 
                       where ((Merchant_Number__c >= 304000 and Merchant_Number__c <= 394000)AND
                       (Id != null AND Merchant_Number__c!= null AND Group_Merchant_Number__c LIKE:groupName))
                       Order by Merchant_Number__c DESC Limit 1];       
    
    }else if(cardAu.equals('Apple AU')){
        merchantNumber = [Select id, Merchant_Number__c, Merchant_Group__c
                       from Merchant_ID__c 
                       where ((Merchant_Number__c >= 701000 and Merchant_Number__c <= 791000)AND
                       (Id != null AND Merchant_Number__c!= null AND Group_Merchant_Number__c LIKE:groupName))
                       Order by Merchant_Number__c DESC Limit 1];       
    }else{
         merchantNumber = [Select id, Merchant_Number__c, Merchant_Group__c
                       from Merchant_ID__c 
                       where (Id != null AND Merchant_Number__c!= null AND Group_Merchant_Number__c LIKE:groupName)
                       Order by Merchant_Number__c DESC Limit 1];
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        for(Merchant_ID__c m : Trigger.new){
            if(merchantNumber!=null){
                System.debug('Existing Merchant Details'+merchantNumber);
                m.Merchant_Number__c = merchantNumber.Merchant_Number__c + 1;
                m.Group_Merchant_Number__c = merchantNumber.Merchant_Group__c + ' ' +  m.Merchant_Number__c;
                m.Primary_Merchant__c = true;
                m.Merchant_ID_Type__c = m.Merchant_Group__c;
                }
            }
        }
    }catch(Exception e){
        if(Trigger.isInsert && Trigger.isBefore){
            try{
                for(Merchant_ID__c m : Trigger.new){    
                    if(m.Merchant_Group__c.equals('Cards AU')){
                        System.debug('IN here==>');
                        m.Merchant_Number__c = 408000;
                        m.Group_Merchant_Number__c = m.Merchant_Group__c + ' ' + m.Merchant_Number__c;
                        m.Primary_Merchant__c = true;
                        m.Merchant_ID_Type__c = m.Merchant_Group__c;                    
                                           
                    } else if (m.Merchant_Group__c.equals('Cards NZ')){
                        m.Merchant_Number__c = 90000000;
                        m.Group_Merchant_Number__c = m.Merchant_Group__c + ' ' + m.Merchant_Number__c;
                        m.Primary_Merchant__c = true;                    
                        m.Merchant_ID_Type__c = m.Merchant_Group__c;
                    
                    }else if (m.Merchant_Group__c.equals('Healthcare AU')){
                        m.Merchant_Number__c = 304000;
                        m.Group_Merchant_Number__c = m.Merchant_Group__c + ' ' + m.Merchant_Number__c;
                        m.Primary_Merchant__c = true;
                        m.Merchant_ID_Type__c = m.Merchant_Group__c;    
                    
                    } else if (m.Merchant_Group__c.equals('Apple AU')){
                        m.Merchant_Number__c = 701000;
                        m.Group_Merchant_Number__c = m.Merchant_Group__c + ' ' + m.Merchant_Number__c;
                        m.Primary_Merchant__c = true;
                        m.Merchant_ID_Type__c = m.Merchant_Group__c;    
                    } 
                  }     
                }catch(Exception e1){System.debug('Error Logs'+e1.getmessage());}
            }   
        }
    
    if(Trigger.isInsert && Trigger.isAfter){
        double merchantNo;
        for(Merchant_ID__c m : Trigger.new){
            if(m.Primary_Merchant__c){mIds.add(m.id);}
            accIds.add(m.Account__c);
            merchantNo = m.Merchant_Number__c;
        }
        
        for(Account a: [Select id, Merchant_Number_cons__c from Account where id in :accIds]){
            a.Merchant_Number_cons__c = merchantNo;
            tempAccList.add(a);
        }
        
        for(Merchant_ID__c mr: [Select id, Primary_Merchant__c from Merchant_ID__c where Account__c in :accIds AND Id NOT in :mIds]){
            mr.Primary_Merchant__c = false;
            tempMerchantList.add(mr);
        }       
        
        if(!tempAccList.isEmpty()){
            Database.update(tempAccList);
        }
        
        if(!tempMerchantList.isEmpty()){
            Database.update(tempMerchantList);
        }       
        
    }
  }
}