public class Util{
    
    public class RecordTypeException extends Exception{}

    /*Variable to check if data is already queried*/
    private static boolean userDataCached = false;
    
    private static User user = new User();
    private static RecordType recMap;
    public static boolean isSearched = false;

   /* 
    *Description: Gets fields of a specific Picklist Field
    *Author: Mac Domingo
    *param: SObject  
    *param: Picklist Field  
    *return: List<SelectOption>   
  */
   public static list<SelectOption> getPicklistValues(SObject obj, String fld)
   {
      list<SelectOption> options = new list<SelectOption>();      
      Schema.sObjectType objType = obj.getSObjectType();       
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();             
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();       
      list<Schema.PicklistEntry> values =
         fieldMap.get(fld).getDescribe().getPickListValues();
      
      for (Schema.PicklistEntry a : values)
      { 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      return options;
   }

   public static list<SelectOption> getRuleSettingValues(){
        List<selectOption> options = new List<selectOption>();

        for (Admin_Settings__c rm : Admin_Settings__c.getAll().values()){
            options.add(new SelectOption(rm.Value__c, rm.Value__c));
        }
        return options;
   }

   /* *Description: Gets fields of a specific Sobject
    *Author: Mac Domingo
    *param: SObject  
    *return: List<SelectOption>   
  */
   public static list<SelectOption> getAllFields(SObject obj){
      List<selectOption> options = new List<selectOption>();      
      Schema.sObjectType objType = obj.getSObjectType();      
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();             
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();   

        for(Schema.SObjectField field : fieldMap.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            if(fieldResult.isAccessible())  
            {  
              options.add(new SelectOption(fieldResult.getLabel(), fieldResult.getName()));                
            }  
        }           
        return options;
   }
   /* *Description: Gets fields of a specific Sobject
    *Author: Mac Domingo
    *param: SObject  
    *return: List<String>   
  */
   public static list<String> getFields(SObject obj){
      List<String> options = new List<String>();      
      Schema.sObjectType objType = obj.getSObjectType();      
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();             
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();   

        for(Schema.SObjectField field : fieldMap.values())  {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            if(fieldResult.isAccessible())  {  
              options.add(fieldResult.getName());
            }  
        }           
        return options;
   }
    /*  *Description: Add error messages to apex pages
        *Author: Fahad Akhtar
        *param: Enum Severity Level
        *param: String Error Message                
        *return: No return value. 
    */
    public static void addMessage(ApexPages.Severity level,String message){
        ApexPages.Message myMsg = new ApexPages.Message(level,message);
        ApexPages.addmessage(myMsg);
    }
    /*  *Description: get user record for user specific settings.
        *Author: Fahad Akhtar                
        *return: User. 
    */
    public static user getUser(){
        if(userDataCached) return user;
        user = [SELECT  id, Mock_Enable__c, country__c FROM User WHERE id =: UserInfo.getUserId() LIMIT 1];
        userDataCached = true;
        return user;
    }   
                                
    /*  *Description: get the exception log webservice record type
        *Author: Dan Crisologo              
        *return: RecordType - Exception Log object
    */
    public static RecordType getWebServiceRecordType() {
        if(recMap == null){
            recMap = [Select Id From RecordType  where SobjectType = 'ExceptionLog__c' and Name ='Web Service'];
        }
        return recMap;
    }
    
    /*
	Lavanya - Jira Item : PMIHM-1197
	Commenting this case, as we are now creating a batch job to delete the records from the below objects.
    @future
    public static void getApplicantRecords(){      
      String currUser = UserInfo.getUserId();
      Set<Id> clvId = new Set<Id>();
      List<Applicant_CLV__c> clvList = [SELECT Id FROM Applicant_CLV__C WHERE Applicant__c = null AND applicant_search__r.CreatedDate < YESTERDAY];
      if(clvList.size() > 0){
        for(Applicant_CLV__c ap : clvList){
          clvId.add(ap.Id);  
        }        
      }
      List<Applicant_Account__c> applAccList = [Select Id from Applicant_Account__c  where Applicant_CLV__c IN :clvId];
      try{
          if(applAccList.size() > 0){
          delete applAccList;
        }
        if(clvList.size() > 0){
          delete clvList;
        }  
      }
      catch (Exception e){
          ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'getApplicantRecords', 'Util', 'Class');
      }
    } 
    */

    /*  *Description: compares an ID to an sobject type
        e.g. Util.isIdTypeOfObject(params, Application__c.sObjectType)
        *Author: Andrew Manetakis   
    */
    public static boolean isIdTypeOfObject(ID myId, sObjectType type) {
      System.debug('#### myId='+myId);
      if(myId != null && type != null) {
        try {
          System.debug('###myId.getSObjectType(): ' + myId.getSObjectType());
          System.debug('###mytype: ' + type);
          return (myId.getSObjectType() == type);
        }
        catch(StringException e) {
          return false;
        }
      }
      return false;
    }
    
    /*  *Description: Convert String to Integer
        *Author: Fahad Akhtar                
        *return: Integer. 
    */
    public static Integer stringToInteger(string str){
        return Integer.valueOf(str);
    } 
    
    /*  *Description: Convert Integer to String 
        *Author: Fahad Akhtar                
        *return: String. 
    */
    public static string integerToString(integer inte){
        return String.valueOf(inte);
    }
    /*  *Description: Return record type id
        *Param: sObject, String 
        *Author: Fahad Akhtar                
        *return: String. 
    */
    public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
        //Generate a map of tokens for all the Record Types for the desired object
        Map <String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();

        if(!recordTypeInfo.containsKey(recordTypeName))
            throw new RecordTypeException('Record type "'+ recordTypeName +'" does not exist.');
        System.debug('** Found record type id ' +  recordTypeInfo.get(recordTypeName).getRecordTypeId()); 
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
    /*  *Description: Return true of string is not empty and false if its is
        *Param: sObject, String 
        *Author: Fahad Akhtar                
        *return: String. 
    */
    public static boolean nullCheck(String s){
      if(s != null){
        if(s.trim() != '')
          return true;
      }else{
        return false;
      }
      return false;
    }

    public static List<sObject> queryAllRelatedRecords (List<Schema.FieldSetMember> fieldSetMembers, String objectName, String parentObjectFieldName, Set<Id> parentRecordIds) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' IN: parentRecordIds ORDER BY CreatedDate ASC';
        return Database.query(query);
    }
    
    public static List<sObject> queryRelatedRecordsWithRecordType(List<Schema.FieldSetMember> fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId, String recordTypeId) {
        System.debug('Parent record id ' + parentRecordId + 'Record type id ' + recordTypeId);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + '=:parentRecordId AND RecordTypeId =: recordTypeId ORDER BY CreatedDate ASC';
        System.debug('Final Query ' + query);
        return Database.query(query);
    }

    /*  Description: Create Debug_Log__c record for computation logging
     *  Author: Mike Lasala
     *  Date Created: MAY-19-2015
     *  Input: Application Id,
               Event when log is created
               Class where invoked
               Method where invoked
     *  Return: Debug_Log__c
     */
    public static Debug_Log__c createDebugLog(Id applicationId, String recordName, String className, String methodName){
        Debug_Log__c debugLog = new Debug_Log__c();

        debugLog.Application__c = applicationId;
        debugLog.Name = recordName;
        debugLog.Calculation_Log__c = '';
        
        if(Util.nullCheck(className)){
            debugLog.Calculation_Log__c += 'Class: '+className+'\n';

            if(Util.nullCheck(methodName)){
                debugLog.Calculation_Log__c += 'Method: '+methodName+'\n\n';
            }
        }

        return debugLog;
    }

    /*  Description: Populate insurance info message on application (PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING)
     *  Author: Mike Lasala
     *  Date Created: AUG-06-2015
     *  Input: Application Id,
               Application__c.Insurance_Info_Messages__c value 
               Info message type
     *  Return: Application
     */

    //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
    public static String updateInsuranceInfoMessage(String appId, String infoMessageValue, String infoMessageType){
        System.debug('$$$ infoMessageType: '+infoMessageType);
        String infoMessage = '';

        try{
            //BEGIN MLASALA: 18-AUG-15 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES
            //construct specfic info message
            String prefix = Insurance_Info_Messages__c.getInstance(GEN_OriginationsConstants.PREFIX_INFO_MESSAGE).Info_Message__c;
            String suffix = Insurance_Info_Messages__c.getInstance(GEN_OriginationsConstants.SUFFIX_INFO_MESSAGE).Info_Message__c;
            
            //Assign specific scenario info message type from custom setting
            if(!Util.nullCheck(infoMessageValue)){
                infoMessage = Insurance_Info_Messages__c.getInstance(infoMessageType).Info_Message__c;
            } else {
                infoMessage = Insurance_Info_Messages__c.getInstance(GEN_OriginationsConstants.MULTIPLE_SCENARIO_INSURANCE_INFO_MESSAGE).Info_Message__c;
            }
            
            infoMessage = prefix+' '+infoMessage+''+suffix;
            //END MLASALA: 18-AUG-15 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING FIXES

        } catch (System.NullPointerException e){
            ErrorHandlerException.recordException(e.getMessage() + e.getStackTraceString(), 'Util', 'Insurance_Info_Messages__c', 'Class', appId);
        }
        System.debug('$$$ infoMessage: '+infoMessage);
        return infoMessage;
    }
    //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

    /*  Description: Create record to track insurance history on application (PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING)
     *  Author: Mike Lasala
     *  Date Created: AUG-10-2015
     *  Input: Application Id
               Operation (Add/Remove/Flush)
               Insurance Type (Life/Disability/Unemployment)
               User (User which triggered the event)
               Previous Insurance Premium value
               New Insurance Premium value
     *  Return: Debug_Log__c
     */

    //BEGIN MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
    public static Debug_Log__c createInsuranceActivity(String appId, 
                                               String operation, 
                                               String insuranceType, 
                                               String userName, 
                                               Decimal previousInsurancePremium, 
                                               Decimal newInsurancePremium){
        
        Debug_Log__c debugLog = new Debug_Log__c();

        //Map fields
        debugLog.Name = operation;
        debugLog.Application__c = appId;
        debugLog.Insurance_Type__c = insuranceType;
        debugLog.Previous_Value__c = String.valueOf(previousInsurancePremium);
        debugLog.New_Value__c = String.valueOf(newInsurancePremium);
        debugLog.Changed_By__c = userName;

        return debugLog;
    }
    //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
}