/*
* @author Original: Mayank Jain (502315820)   
* @date Original: 20 July 2014 Last Modified: 19 July 2014 
* @description This class works as helper class to get the data information
*/


public class HelperClass{

    public static boolean queryProfile = false;
    public static boolean queryUser = false;
    public static boolean queryUserRole = false;
    public static Map<id, Profile> profileMap;
    public static Map<id, User> userMap;
    public static Map<id, UserRole> userRoleMap;
    
    public static Profile getProfileInfo(ID profileStr){
    
        if(!queryProfile)
        {
        profileMap = new Map<id, Profile>([Select Id , Name from Profile]);
        queryProfile = true;
        }
        
        Profile prf = profileMap.get(profileStr);
        
        return prf ;
    }
    
    public static user getuserInfo(ID userId){
        
        if(!queryUser)
        {
        userMap= new Map<id, User>([Select Id , Name,Profile.name from User WHERE id =: userId]);
        queryUser = true;
        }
        
        User usr= userMap.get(userId);
        
        return usr ;
    }
    
    public static UserRole getRoleName(Id roleId){
        //system.assertEquals(true, false, roleId);
        
        if(!queryUserRole)
        {
        userRoleMap= new Map<id, UserRole>([Select Id , Name from UserRole]);
        queryUserRole = true;
        }
        
        UserRole role = userRoleMap.get(roleId);
        
        return role;
        
    
    }
          
    public static boolean profileExcluded(String profileName, String generalPropertiesName)
    {
        Boolean flag = false ;
        if (generalPropertiesName!='' && profileName!='')
        {
            General_Properties__c aGP = General_Properties__c.getValues(generalPropertiesName);
            if(aGP!=null && aGP.Value__c!=null){
            String aProfileNames = aGP.Value__c.trim();

            list<String> pofileList = aProfileNames.split(';');
            set<String> pofileNames = new set<String>();
            pofileNames.addAll(pofileList);
            if(pofileNames.contains(profileName))
            flag = false;
            else
            flag = true;
        }
        }
        return flag ;
    }


    /***
    *This method will create audit records for Account & Opportunity
    **/      
    public static void createAuditRecords(List<sObject> objectRecords,Map<Id,sObject> OldObjectRecordMap){
        /*
        if(!objectRecords.isEmpty() && !OldObjectRecordMap.isEmpty()){
            sobject eachObject = objectRecords[0];
            set<string> allObjectFields= new set<string>();
            //Getting the object Type
            String ObjectName=eachObject.getsObjectType().getDescribe().getName();
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<string,Schema.SObjectField> mpConField=schemaMap.get(ObjectName).getDescribe().fields.getMap();              
            allObjectFields=mpConField.keySet();
            Map<String,String> labelFieldMap = new Map<String,String>();
            for(String eachField : allObjectFields){
                labelFieldMap.put(eachField,mpConField.get(eachField).getDescribe().getLabel());
            }
            System.debug('Field Label Map ###'+labelFieldMap); 
            System.debug('Creating Audit Record for ###'+ObjectName);
            //Getting the Audit Tracker Records based on object Type
            List<Audit_Tracker__c> auditTrackerList = [SELECT Object_Name__c,Field_Name__c FROM Audit_Tracker__c WHERE Object_Name__c=:ObjectName];
            System.debug('Retrieving Audit Tracker Record for ###'+auditTrackerList);
            //allFields will store the all the audit fields
            List<String> allFields= new List<String>();
            //listAccountAudit stores the account history records  

            List<AccountFieldHistory_Clone__c> listAccountAudit = new List<AccountFieldHistory_Clone__c>();
            //listAccountAudit stores the opportunity history records
            List<OpportunityFieldHistory_Clone__c> listOpportunityAudit = new List<OpportunityFieldHistory_Clone__c>();
            
            for(Audit_Tracker__c eachAudit : auditTrackerList){
                allFields.add(eachAudit.Field_Name__c);
            }
           if(!allFields.isEmpty()){
                for(sObject eachSobj: objectRecords){
                    for(string eachFieldName:allFields){
                        if(eachSobj.get(eachFieldName)!=OldObjectRecordMap.get((String)eachSobj.get('Id')).get(eachFieldName)){
                            if('Account'.equals(ObjectName) || 'Account_Extension__c'.equals(ObjectName)){
                                AccountFieldHistory_Clone__c newAccountHistory = new AccountFieldHistory_Clone__c();
                                newAccountHistory.Field_Name__c=labelFieldMap.get(eachFieldName.toLowerCase());
                                newAccountHistory.New_Value__c=String.ValueOf(eachSobj.get(eachFieldName));
                                newAccountHistory.Old_Value__c=String.ValueOf(OldObjectRecordMap.get((String)eachSobj.get('Id')).get(eachFieldName));
                                if('Account'.equals(ObjectName)){
                                    newAccountHistory.Account__c=(String)eachSobj.get('Id'); 
                                }
                                else if('Account_Extension__c'.equals(ObjectName)){
                                    newAccountHistory.Account__c=(String)eachSobj.get('Account__c');    
                                }
                                
                                listAccountAudit.add(newAccountHistory);
                                System.debug('Account Audit Record####'+newAccountHistory);
                            }
                            else if('Opportunity'.equals(ObjectName)|| 'Opportunity_Extension__c'.equals(ObjectName)){
                                OpportunityFieldHistory_Clone__c newOpportunityHistory = new OpportunityFieldHistory_Clone__c();
                                newOpportunityHistory.Field_Name__c=labelFieldMap.get(eachFieldName.toLowerCase());
                                newOpportunityHistory.New_Value__c=String.ValueOf(eachSobj.get(eachFieldName));
                                newOpportunityHistory.Old_Value__c=String.ValueOf(OldObjectRecordMap.get((String)eachSobj.get('Id')).get(eachFieldName));
                                
                                if('Opportunity_Extension__c'.equals(ObjectName)){
                                    newOpportunityHistory.Opportunity__c=(String)eachSobj.get('Related_Opportunity__c');    
                                }
                                else if('Opportunity'.equals(ObjectName)){
                                    newOpportunityHistory.Opportunity__c=(String)eachSobj.get('Id');
                                }                           
                                listOpportunityAudit.add(newOpportunityHistory);
                                System.debug('Opportunity Audit Record####'+newOpportunityHistory);
                            }

                        }
                    }
                }
            }
            try{
                if(!listAccountAudit.isEmpty()){
                    insert listAccountAudit;
                }
                if(!listOpportunityAudit.isEmpty()){
                    insert listOpportunityAudit;
                }
            }
            catch(DMLException dmlex){
            } 
        }    
    */
    }   
          
}