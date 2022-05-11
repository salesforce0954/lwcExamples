/*
 *Author: Jan Mark Domingo Cloud Sherpas
 *Created Date: December 13, 2013
 *Description: Class for the Account Data Search.
 * @History:
   =====================================================================
       31-03-14: Updated - Commented out Admin Settings custom settings temporarily - Matt Isidro
       12-08-15: Updated - Add new method getDebtAmount to calculate total debt - DYU
       07-SEPT-15: PMIHM-2119 Genesis accounts correct instalment amount to display in PL debts section -MLASALA

*/
global without sharing class APP_AccountDataExt {
    // String value for Topic
    public static final String TOPIC_NAME = 'ApplicantAccount';
    //List to hold applicant clv records that will be displayed on page.
    public List<Applicant_CLV__c> appCLVList    {get; set;}
    //Boolean to show Next button
    public Boolean showNext                     {get; set;}
    //Boolean to display the Applicant Account related list 
    public Boolean showRelAppAccount            {get; set;}
    //Boolean to display the Applicant Account Detail
    public Boolean showApplicantAccount         {get; set;}
    //Selected CLV Record 
    public String selectedCLV                   {get; set;}
    //Selected CLV Record 
    public String selectedAppACC                {get; set;}
    //Holds all the Applicant Account related 
    //to the selected Applicant CLV records
    public List<Applicant_Account__c> applicantAccList {get; set;}
    //String to display if no records found
    public String noRecs                         {get; set;}
    //String to hold applicant account recordType
    public String appRecordType                  {get; set;}
    
    //List of Applicant Account Involved parties 
    public List<Applicant_Account_Involved_Party__c> appPartylist {get; set;}
    public Boolean showPartyList {get; set;}
    public String selectedAccountParty{get;set;}
    public String selectCust{get;set;}
    //test
    // Profile control visibility
    public Boolean searchMatchViewControl       {get;set;}
    public Boolean searchMatchEditControl       {get;set;}
    public Boolean searchMatchControl           {get;set;}  
    // Next button visibility 
    public Boolean nextButton                   {get;set;}
    
    //Holder of application Id from URL
    String applicationId;    
    String isChange;
    public String oldApp {get;set;}     //MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
    
    Set<Id> appCLVId = new Set<Id>();  
    //Holder of applicantId's
    Set<Id> applId = new Set<Id>();  
    
    // Main Application Variable
    public Application__c application = new Application__c();
    // Main Applicant variables     
    public Applicant__c app1 = new Applicant__c();
    public Applicant__c app2 = new Applicant__c();
    // Applicant list holder
    public List<Applicant__c> applicantList {get; set;}
    // CLV count flag
    public Boolean hasCLV{get; set;}
        
    // Variables for prepopulation 
    /*
    public Boolean hasExistDefaultApp1{get; set;}
    public Boolean hasExistDefaultApp2{get; set;}
    public Boolean hasPrepopulation{get; set;}    
    */
    
    // CLV Variables
    public Boolean appClvError{get; set;}
    public map<Id, Applicant_CLV__c> appCLVMap{get; set;}
    
    // Remote action Json string variables
    public string clvListJSONStr{get; set;}
    public string clvIdJSONStr{get; set;}
    public string applicantListJSONStr{get; set;}
    
        
    /*
     * Author: Adrian Recio Cloud Sherpas
     * Created Date: March 31, 2015
     * Description: Pull Applicant Account RecordtypeId by name
     */
    public static Id appAccRecordTypeId(string typeStr){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Applicant_Account__c;
        Map<String,Schema.RecordTypeInfo> appAccRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        return appAccRecordTypeInfo.get(typeStr).getRecordTypeId();
    }// End appAccRecordTypeId Method
    
     /*
     * Author: Adrian Recio Cloud Sherpas
     * Created Date: March 31, 2015
     * Description: Pull Applicant Account RecordtypeId by name
     */
    public static Id liabilityRecordTypeId(string typeStr){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Liability__c;
        Map<String,Schema.RecordTypeInfo> liaRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        return liaRecordTypeInfo.get(typeStr).getRecordTypeId();
    }// End liabilityRecordTypeId Method
    
    
    /*
     *Author: Mac Domingo
     *Created Date: March 03, 2015
     *Description: Constructor method
                   Initiates applicant clv and account records.
                   Initiates page visibility variables.
     *Param: ApexPages.StandardController - Application as Standard Contoller
     *Return: NA
    */
    public APP_AccountDataExt(ApexPages.StandardController stdController) {
        
        // Pull Application from Controller
        application = (Application__c)stdController.getRecord();
        if(application.Id != null){
            application = [Select Id, Status__c, Response_Code__c from Application__c where Id = :application.Id];
        }

        // Initialize default values for page visibility
        pageControl(application.Response_Code__c);
        showRelAppAccount = false;
        showApplicantAccount = false;
        showNext = false;        
        selectCust = 'Select Customer';
        
        // Initialize variable checkers that will be used to determine if an applicant and clv 
        // is created in loadSearchAndMatchCLV method which will work as page inital action method
        showPartyList = false;
        Integer lSearch = 12; 
        Datetime d = System.now().addHours(-lSearch);
        
        // Pull url parameter variables
        applicationId = ApexPages.currentPage().getParameters().get('id'); 
        isChange = ApexPages.currentPage().getParameters().get('hasChanged');
        
        //MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
        //Parameter from search and match which identifies if application is not new
        oldApp = ApexPages.currentPage().getParameters().get('oldApp');
        
        //Initialize Applicant Records
        applicantList = [Select Id, Application__c, First_Name__c, 
                                    Last_Name__c, Date_of_Birth__c, 
                                    Is_Primary_Applicant__c 
                                    from Applicant__c where Application__c = :applicationId];
                            
        if(applicantList.size() > 0){            
            if(applicantList.size() >1){
                for(Applicant__c a : applicantList){
                    applId.add(a.Id);
                    if(a.Is_Primary_Applicant__c == true){
                        app1 = a;
                    }else{
                        app2 = a;
                    }// End Else
                }// End For
            }else{
                app1 = applicantList[0];
                applId.add(app1.Id);
            }// End Else
        }// End If

        system.debug('isChange:' + isChange);
        
        //Applicant CLV against the Applicant Changed
        if(isChange == '1'){                
            appCLVList = [Select Id, Last_Search__c, Applicant__c, Applicant__r.Name, Title__c, 
                          CLV__c, Surname__c, First_Name__c, Middle_Name__c, Date_of_Birth__c, Message_Code__c,
                          Message_Description__c, Drivers_License__c, Street_Address__c, Suburb__c, Post_Code__c, 
                          Home__c, Mobile__c, Work__c, State__c, Applicant_Bucket__c, prepopulate__c
                          from Applicant_CLV__c where Message_Code__c != '5555' AND Applicant__c in :applId AND User_Match_Flag__c = true]; //MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                          
        //Applicant CLV against the Applicant did not change
        }else{
            appCLVList = [Select Id, Last_Search__c, Applicant__c, Applicant__r.Name, Title__c, CLV__c, Surname__c, 
                          First_Name__c, Middle_Name__c, Date_of_Birth__c, Message_Code__c,Message_Description__c, 
                          Drivers_License__c, Street_Address__c, Suburb__c, Post_Code__c, Home__c, Mobile__c, Work__c, 
                          State__c, Applicant_Bucket__c, prepopulate__c , User_Match_Flag__c
                          from Applicant_CLV__c where Message_Code__c != '5555' AND Applicant__c in :applId AND Last_Search__c > :d AND User_Match_Flag__c = true]; //MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        }
        
        if(appCLVList.size() > 0){
            // Select default Application CLV to prepopulate
            // appCLVList = defaultCLVPrepopulate(appCLVList);
            // Clear previous prepopulation values
            appCLVList = clearPrepopulate(appCLVList);
        } 
        
        system.debug('Constructor CLV Count:' + appCLVList.size());
        /*
        system.debug('applicant 1 constructor prepopulate disable:' + hasExistDefaultApp1);
        system.debug('applicant 2 constructor prepopulate disable:' + hasExistDefaultApp2);
        */
    }

    /*
     *Author: Mac Domingo 
     *Created Date: March 03, 2015
     *Description: Page action method that executes after constructor initalization.
                 Performs applicant CLV and Account delete and updates operation.
     *Param: NA
     *Return: void
    */
    public void loadSearchAndMatchCLV(){        
        system.debug('Action Method Applicant CLV Size:' + appCLVList.size());
        
        // If there is CLV Match
        if(appCLVList.size() > 0){
            system.debug('After Prepopulation Method:' + appCLVList);
            
            // Pull application CLV Ids
            Set<ID> appCLVId = new Set<ID>();
            
            //BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
            Set<String> appCLVNumber = new Set<String>();
            List<Applicant_CLV__c> uniqueCLVList = new List<Applicant_CLV__c>();
            
            Integer i = 0;
            for(Applicant_CLV__c a : appCLVList){
                    
                if(!appCLVNumber.contains(a.CLV__c)){
                    appCLVId.add(a.Id);
                    uniqueCLVList.add(a);
                }
                
                appCLVNumber.add(a.CLV__c);
                i++;
            }
            
            appCLVList.clear();
            appCLVList = uniqueCLVList;
            //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
            
            //Delete Applicant Account Records
            List<Applicant_Account__c> appAccountList = [Select Id from Applicant_Account__c where Applicant_CLV__c IN :appCLVId];
            
            // Updated by: Adrian Recio
            // Description: Webservice call moved before dml operations to allow sync call in a single thread
            // Date: 17/09/2015
            try{
                IS_CustomerSearch.customerAccountSearchService(appCLVId, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);  
            }catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 
                                                           'loadSearchAndMatchCLV', 'APP_AccountDataExt', 'Class');
                Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
            }  
            
            system.debug('Applicant Account Delete Count:' + appAccountList.size());
            system.debug('Applicant Account Delete Match:' + appAccountList);
                                    
            if(appAccountList.size() > 0){
                try{
                    /*CHECKMARX:
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Applicant_Account__c.sObjectType.getDescribe().isDeletable()){
                        delete appAccountList;
                    }
                    */
                    delete appAccountList;
                }catch(Exception e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 
                                                               'loadSearchAndMatchCLV', 'APP_AccountDataExt', 'Class');
                    Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
                }
            }
            
            System.debug('###appCLVID ' + appCLVId);
            try{
                update appCLVList;
                // Updated by: Adrian Recio
                // Description: Webservice call moved before dml operations to allow sync call in a single thread
                // Date: 17/09/2015
                //IS_CustomerSearch.customerAccountSearchService(appCLVId, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);                        
            }catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 
                                                           'loadSearchAndMatchCLV', 'APP_AccountDataExt', 'Class');
                Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
            }                
        }
        
        system.debug('clv_list:' + appCLVList.size());
        system.debug('clv_set_Id:' + appCLVId);
        
        /*
        system.debug('applicant 1 action method prepopulate disable:' + hasExistDefaultApp1);
        system.debug('applicant 2 action method prepopulate disable:' + hasExistDefaultApp2);
        */
    }        
    
    /*  Description: This will control the account data rendering
     *  Author: Jade Serrano
     *  Date Created: 27-MAR-2014
     *  Input Parameters:
     *  Return: Void
     */
    public void pageControl(String responseCode){

        system.debug('Response Code:' + responseCode);
        
        // Get Current user profile Id
        Id profileId = UserInfo.getProfileId();

        // Determine Search and Match View and Edit Access.
        // This access determines account clv page selection access
        searchMatchViewControl = Profile_Control__c.getInstance(profileId).Search_and_Match_View__c;
        searchMatchEditControl = Profile_Control__c.getInstance(profileId).Search_and_Match_Edit__c;

        system.debug('search view control:' + searchMatchViewControl);
        system.debug('search edit control:' + searchMatchEditControl);
        
        // If there is no access, display error message in UI
        if(!searchMatchViewControl && !searchMatchEditControl){
            Util.addMessage(ApexPages.Severity.ERROR, 'Your profile does not have access to the Customer Search and Match function');
        }
        
        if(responseCode!=null){
            List<Response_Code_Control__c> responseCodeControl = [SELECT Name FROM Response_Code_Control__c WHERE Name =: responseCode];
            if(responseCodeControl.size()>0){
                searchMatchControl = Response_Code_Control__c.getInstance(responseCode).Search_and_Match_Edit__c;
                nextButton = Response_Code_Control__c.getInstance(responseCode).Edit_CLV__c;
            }else{
                Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
            }
        }
    }
        
    public String getName() {        
        return topic_Name;
    }
    
    /*
     *Author: Adrian Recio 
     *Created Date: March 03, 2015
     *Description: Clear Default
     */
    public List<Applicant_CLV__c> clearPrepopulate(List<Applicant_CLV__c> appCLVVarList){
        for(Applicant_CLV__c appCLVVar:appCLVVarList){
            appCLVVar.prepopulate__c = false;
        }
        return appCLVVarList;
    }
    
    /*
     *Author: Adrian Recio 
     *Created Date: March 03, 2015
     *Description: Method to default Applicant CLV Prepopulate field
     */
    /* 
    public List<Applicant_CLV__c> defaultCLVPrepopulate(List<Applicant_CLV__c> appCLVVarList){
        // Default flag variable
        Boolean IsDefaultedApp1 = false;
        Boolean IsDefaultedApp2 = false;
        hasExistDefaultApp1 = false;
        hasExistDefaultApp2 = false;
        hasPrepopulation = false;
        
        // If one of the applicant field 
        // required field is populated,
        // disable prepopulation for applicant 1 and 2
        
        // App 1 prepopulation check
        if(app1.Id!=null &&
            (app1.First_Name__c!=null || 
             app1.Last_Name__c!=null || 
             app1.Date_of_Birth__c!=null)){
           hasExistDefaultApp1=true;                  
        }
        
        // App 2 prepopulation check
        if(app2.Id!=null &&
           (app2.First_Name__c!=null || 
            app2.Last_Name__c!=null || 
            app2.Date_of_Birth__c!=null)){
           hasExistDefaultApp2=true;                  
        }
        
        // Set default CLV for prepopulation        
        for(Applicant_CLV__c a : appCLVVarList){
            if(a.Applicant_Bucket__c == '1'){ 
                if(IsDefaultedApp1==false && hasExistDefaultApp1 == false){ 
                    IsDefaultedApp1 = true;
                    a.prepopulate__c = true;
                }else{
                    a.prepopulate__c = false;
                }
            }
            
            if(a.Applicant_Bucket__c == '2' ){
                if(IsDefaultedApp2==false && hasExistDefaultApp2 == false){ 
                    IsDefaultedApp2 = true;
                    a.prepopulate__c = true;
                }else{
                    a.prepopulate__c = false;
                }
            }
        }
        
        // Determine if prepopulation will be visible.
        // There should be one matching default CLV.
        if(IsDefaultedApp1==true || IsDefaultedApp2==true){
            hasPrepopulation = true;    
        }
        
        system.debug('applicant 1 prepopulate disable:' + hasExistDefaultApp1);
        system.debug('applicant 2 prepopulate disable:' + hasExistDefaultApp2);
        return appCLVVarList;
    }
    */
        
    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: December 16, 2013
     *Description: Method to go Product Selection Page
     */
    public void goToNext(){
        
        // Set to false which means the are no initial clv errors
        appClvError = false;
        
        // Init variables
        clvListJSONStr = '';
        clvIdJSONStr='';
        appCLVMap = new Map<Id,Applicant_CLV__c>();
        
        // Prepopulate debug
        for(Applicant_CLV__c appCLV:appCLVList){
            system.debug('appCLVValue:' + appCLV.prepopulate__c);
        }
        
        // Determine clv count flag value
        if(appCLVList.size()>0){
            hasCLV = true;
        }else{
            hasCLV = false;
        }
        
        // Validate prepopulation value
        if(validatePrepopulation(appCLVList)){
            appClvError = true;
            Util.addMessage(ApexPages.Severity.ERROR, 'Multiple Applicant CLV prepopulation for the same applicant is not allowed.');
        }else{
            // Populate App CLV Map for Key External reference in visualforce
            if(appCLVList!=null){
                appCLVMap.putAll(appCLVList);
            }
            List<sObject> sObject1 = appCLVList;
            List<sObject> sObject2 = applicantList;
            
            sObjectRemote.QueryResult qr1 = APP_AccountDataExt.convertToQuerySobject(sObject1);
            sObjectRemote.QueryResult qr2 = APP_AccountDataExt.convertToQuerySobject(sObject2);
    		
            clvListJSONStr = JSON.serializePretty(qr1);        
            applicantListJSONStr = JSON.serializePretty(qr2);
            clvIdJSONStr = JSON.serializePretty(appCLVMap.keyset());
            
            //BEGIN MLASALA: 16-FEB-16 SAVE BUTTON NOT PROGRESSING
	        //Added escape for single quotes for all values
	        clvListJSONStr = String.escapeSingleQuotes(clvListJSONStr);
	        applicantListJSONStr = String.escapeSingleQuotes(applicantListJSONStr);
	        //END MLASALA: 16-FEB-16 SAVE BUTTON NOT PROGRESSING
        }
        
        system.debug('CLV Record List:' + clvListJSONStr);
        system.debug('CLV Id Set:' + clvIdJSONStr);
        system.debug('Applicant List:' + applicantListJSONStr);
        system.debug('CLV Validation Status:' + appClvError);
    }

    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: April 15, 2015
     *Description: Get the ICBS Customer Number
     */
    public static sObjectRemote.QueryResult convertToQuerySobject(List<sObject> sObjectList){
        sObjectRemote.QueryResult qr = new sObjectRemote.QueryResult();
        
        //Perform the query
        for(sObject obj : sObjectList){
            //Add sObject list of sObject returned in the QueryResult
            qr.sObjects.add(obj);
        }

        //Set the object type in the attributes of the QueryResult
        if(qr.sObjects.size() > 0){
            qr.sObjectAttributes.put('sObjectType',String.valueOf(qr.sObjects[0].getsObjectType()));
        }
        return qr;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: April 15, 2015
     *Description: Pull user region
     */
    public static string pullUserRegion(){
       List<User> userInfoVar = [Select Id, Region__c from User where 
                                 Id = :UserInfo.getUserId() limit 1];
       string regionValue = 'AU'; // Default to AU
       
       for(User userVar:userInfoVar){
          if(userVar.Region__c!=null && 
             userVar.Region__c!='AU'){
            regionValue = userVar.Region__c;
          } 
       }
       return regionValue;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: April 15, 2015
     *Description: Method to convert clv format date to readable sf date in applicant
     *Updated by MLASALA 18-FEB-16 Added type to accommodate format for WS and Doc Gen
     */
    public static string formatCLVDateToSF(string clvDateStr, string dateType){
        
        string finalConDate = '';
        system.debug('CLV Source Date:' + clvDateStr);
        if(clvDateStr!=null){
            List<string> splitVal = clvDateStr.split('-',3);
            system.debug('Birthdate List:' + splitVal);
            system.debug('Birthdate List Size:' + splitVal);
            if(splitVal.size()==3){
                if(dateType == 'SF'){
                    finalConDate = splitVal[2] + '-' + splitVal[1] + '-' + splitVal[0];
                } else if(dateType == 'WS'){
                    finalConDate = splitVal[0] + '-' + splitVal[1] + '-' + splitVal[2];
                } else if(dateType == 'DG'){
                    finalConDate = splitVal[2] + '/' + splitVal[1] + '/' + splitVal[0];
                }
            }
            
            system.debug('Converted Date:' + finalConDate);
        }
        return finalConDate;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 13, 2014
     *Description: Method to sort applicant account by it's parent Application CLV  
     */
    public static Map<Id, List<Applicant_Account__c>> sortAppAccByApplicantCLV(List<Applicant_Account__c>appliAccountObjList){
        Map<Id,List<Applicant_Account__c>> appAccMap = new Map<Id, List<Applicant_Account__c>>();
        
        for(Applicant_Account__c aaVar: appliAccountObjList){
            if(appAccMap.containsKey(aaVar.Applicant_CLV__c)){
                List<Applicant_Account__c> aaListValue = appAccMap.get(aaVar.Applicant_CLV__c);
                aaListValue.add(aaVar);
                appAccMap.put(aaVar.Applicant_CLV__c,aaListValue);
            }else{
                List<Applicant_Account__c> aaListValue = new List<Applicant_Account__c>();
                aaListValue.add(aaVar);
                appAccMap.put(aaVar.Applicant_CLV__c,aaListValue);
            }
        }
        
        return appAccMap;
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: June 02, 2015
     *Description: Method to flush liabilities in applicant
     */
     public static void flushLiabilities(Set<Id>aIdSet){
        List<Liability__c>  liaList = [Select Id from Liability__c where Applicant__c In :aIdSet AND Prepopulated__c=true];
        system.debug('Flushed Liability Size:' + liaList.size());
        system.debug('Flushed Liability Details:' + liaList.size());
        delete liaList;
     }

    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 13, 2014
     *Description: Get the ICBS Customer Number
     */
    @RemoteAction
    global static Boolean populateDebtAndPersonalDetails(List<Applicant_CLV__c>appCLVUpdateList,
                                                         List<Applicant_CLV__c>appCLVList, 
                                                         List<Applicant_Account__c>appliAccountObjList, 
                                                         List<Applicant__c>applicantList,
                                                         Map<String,String> dmlOptions){

       system.debug('Remote Update CLV List:' + appCLVUpdateList);
       system.debug('Remote CLV List:' + appCLVList);
       system.debug('Remote Applicant Account List:' + appliAccountObjList);
       system.debug('Remote applicant List:' + applicantList);
          


       // Pull Applicant Account sorted by Application CLV
       Map<Id,List<Applicant_Account__c>> appAccMap = APP_AccountDataExt.sortAppAccByApplicantCLV(appliAccountObjList); 
       
       // Method Variable Declaration      
       IS_ApplicationDTO isDTO = new IS_ApplicationDTO();
       isDTO.applicant = new Applicant__c();
       Set<Id> applicantIdsToQuery = new Set<Id>();
       List<Applicant__c> appListToUpdate = new List<Applicant__c>();
       List<Liability__c>appAccLiabilityList = new List<Liability__c>();
       map<Id, Applicant_CLV__c> appCLVMap = new map<Id,Applicant_CLV__c>();
       
       // Pull current user region 
       // Values will handle region specific value assignment like liability recordtype
       string regionValue = APP_AccountDataExt.pullUserRegion();
                                 
        //Get Applicant Records
        if(applicantList.size() > 0){
            if(applicantList.size() == 1){
                isDTO.applicant = applicantList[0];
                applicantIdsToQuery.add(applicantList[0].Id);
            } else if(applicantList.size() > 1){
                for(Applicant__c app : applicantList){
                    if(app.Is_Primary_Applicant__c == true){
                        isDTO.applicant = app;
                    } else{
                        isDTO.applicant2 = app;
                    }
                    applicantIdsToQuery.add(app.Id);
                }
            }
        }

        // Populate App CLV Map for Key External reference in visualforce
        if(appCLVList!=null){
            appCLVMap.putAll(appCLVList);
        }
                                                                                                                    
        system.debug('appCLVKeySet:' + appCLVMap.KeySet());                                
        system.debug('appCLVMatcSize:' + appCLVUpdateList.size());
        
        for(Applicant_CLV__c aCLVVar:appCLVUpdateList){
            
            // Pull child Applicant Account of CLV
            List<Applicant_Account__c> aaChildList = appAccMap.get(aCLVVar.Id);
            
            if(aaChildList == null){
                aaChildList = new List<Applicant_Account__c>();
            }
            
            system.debug('appBucket:'+aCLVVar.Applicant_Bucket__c);
            system.debug('child applicant account:' + aaChildList.size());
            system.debug('child app acc values:' + aaChildList);
            system.debug('current bucket:' + aCLVVar.Applicant_Bucket__c);
            system.debug('street address val:' + aCLVVar.Street_Address__c);
            
            Applicant_CLV__c currentEditCLVVar = appCLVMap.get(aCLVVar.Id);

            // Commit Prepopulate value
            aCLVVar.prepopulate__c = currentEditCLVVar.prepopulate__c;
            system.debug('prePop:'+currentEditCLVVar.prepopulate__c);
            
                            
                // If first name is already populated, population already occurred ones
                if(aCLVVar.Applicant_Bucket__c == '1'){ 
                    if(currentEditCLVVar.prepopulate__c==true){   
                        isDTO.applicant.First_Name__c = aCLVVar.First_Name__c;
                        isDTO.applicant.Middle_Name__c = aCLVVar.Middle_Name__c;
                        isDTO.applicant.Last_Name__c = aCLVVar.Surname__c;
                        isDTO.applicant.Date_of_Birth__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'SF');
                        isDTO.applicant.State_Res__c = aCLVVar.State__c;
                        isDTO.applicant.Home__c = aCLVVar.Home__c;
                        isDTO.applicant.Work__c = aCLVVar.Work__c;
                        isDTO.applicant.Mobile__c = aCLVVar.Mobile__c;
                        
                        //BEGIN MLASALA 18-FEB-16 PREPOPULATION ISSUE
                        isDTO.applicant.Date_of_Birth_WS__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'WS');
                        isDTO.applicant.Date_of_Birth_Doc_Gen__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'DG');
                        if(aCLVVar.Home__c != null){
                            isDTO.applicant.Home_Area_Code__c = aCLVVar.Home__c.left(2);
                            isDTO.applicant.Home_WS__c = aCLVVar.Home__c.subString(2);
                        }
                        if(aCLVVar.Work__c != null){
                            isDTO.applicant.Work_Area_Code__c = aCLVVar.Work__c.left(2);
                            isDTO.applicant.Work_WS__c = aCLVVar.Work__c.subString(2);
                        }
                        //END MLASALA 18-FEB-16 PREPOPULATION ISSUE
                    }
                    
                    system.debug('App1:' + isDTO.applicant);
                    system.debug('ApplicantAccount1:' + aaChildList.size());

                    for(Applicant_Account__c appAccnt : aaChildList){
                        Liability__c liaVar = APP_AccountDataExt.populateAALiability(appAccnt,isDTO.applicant,regionValue,'Applicant 1');
                        if(liaVar!=null){
                            appAccLiabilityList.add(liaVar);
                        }
                        if(appAccnt.Account_Number__c!=null && appAccnt.Selected_ICBS_Customer_Number__c!=null){
                            isDTO.applicant.ICBS_Account_Number__c = appAccnt.Account_Number__c;
                            isDTO.applicant.ICBS_Customer_Number__c = appAccnt.Selected_ICBS_Customer_Number__c;
                        }
                    }
                // If first name is already populated, population already occurred ones
                }else if(aCLVVar.Applicant_Bucket__c == '2'){  
                     if(currentEditCLVVar.prepopulate__c==true){                            
                            isDTO.applicant2.First_Name__c = aCLVVar.First_Name__c;
                            isDTO.applicant2.Middle_Name__c = aCLVVar.Middle_Name__c;
                            isDTO.applicant2.Last_Name__c = aCLVVar.Surname__c;
                            isDTO.applicant2.Date_of_Birth__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'SF');
                            isDTO.applicant2.State_Res__c = aCLVVar.State__c;
                            isDTO.applicant2.Home__c = aCLVVar.Home__c;
                            isDTO.applicant2.Work__c = aCLVVar.Work__c;
                            isDTO.applicant2.Mobile__c = aCLVVar.Mobile__c;
                            
                            //BEGIN MLASALA 18-FEB-16 PREPOPULATION ISSUE
                            isDTO.applicant.Date_of_Birth_WS__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'WS');
                            isDTO.applicant.Date_of_Birth_Doc_Gen__c = APP_AccountDataExt.formatCLVDateToSF(aCLVVar.Date_of_Birth__c, 'DG');
                            if(aCLVVar.Home__c != null){
                                isDTO.applicant.Home_Area_Code__c = aCLVVar.Home__c.left(2);
                                isDTO.applicant.Home_WS__c = aCLVVar.Home__c.subString(2);
                            }
                            if(aCLVVar.Work__c != null){
                                isDTO.applicant.Work_Area_Code__c = aCLVVar.Work__c.left(2);
                                isDTO.applicant.Work_WS__c =aCLVVar.Work__c.subString(2);
                            }
                            //END MLASALA 18-FEB-16 PREPOPULATION ISSUE
                     }    
                        
                    system.debug('App2:' + isDTO.applicant2);
                    system.debug('ApplicantAccount2:' + aaChildList.size());
                    
                    for(Applicant_Account__c appAccnt : aaChildList){
                        // Updated By: Adrian Recio
                        // Description: All liabilities should connect to applicant 1 regardless if involve party is applicant 2
                        //Liability__c liaVar = APP_AccountDataExt.populateAALiability(appAccnt,isDTO.applicant2,regionValue,'Applicant 2');
                        Liability__c liaVar = APP_AccountDataExt.populateAALiability(appAccnt,isDTO.applicant,regionValue,'Applicant 2');
                        if(liaVar!=null){
                            appAccLiabilityList.add(liaVar);
                        }
                        if(appAccnt.Account_Number__c!=null && appAccnt.Selected_ICBS_Customer_Number__c!=null){
                            isDTO.applicant2.ICBS_Account_Number__c = appAccnt.Account_Number__c;
                            isDTO.applicant2.ICBS_Customer_Number__c = appAccnt.Selected_ICBS_Customer_Number__c;
                        }
                    }
                }
        }
        
        system.debug('After loop CLV Value:' + appCLVUpdateList);
        
        appListToUpdate.add(isDTO.applicant);
        if(isDTO.applicant2!=null) {
            system.debug('Not Null:' + isDTO.applicant2);
            appListToUpdate.add(isDTO.applicant2);
        }
        
        system.debug('Applicant 2:' + isDTO.applicant2);
        
        // Create save point if any dml operation suddenly fails
        System.Savepoint sp = Database.setSavepoint();

        try{
            // Commit prepopulated values to applicant
            update appListToUpdate;
            // Commit prepopulation stats
            system.debug('Prepopulate Update Value:' + appCLVUpdateList);
            update appCLVUpdateList;

            // Flush previously populated liabilities in applicant
            APP_AccountDataExt.flushLiabilities(applicantIdsToQuery);

            // Populate new liabilities related to appplicant
            system.debug('Liability Size:' + appAccLiabilityList.size());
            if(appAccLiabilityList.size()>0){
                insert appAccLiabilityList;
            }
        }catch(Exception e){
            Database.rollback(sp);   
            system.debug('DebtAndLiabilityUpdateError:' + string.valueOf(e));
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'updateICBS', 'APP_AccountDataExt', 'Class');
            return false; 
        }
       
        return true;
    }
    
    /*
     * Author: Adrian Recio Cloud Sherpas
     * Created Date: March 31, 2015
     * Description: Create liability based on applicant account
     */
    public static Liability__c populateAALiability(Applicant_Account__c appAccntVar,Applicant__c appVar,string regionVar,string appliParty){
        Liability__c liabilityVar = new Liability__c();
        liabilityVar.Prepopulated__c = true;
        LiabilityVar.Debt_Auto_Created__c = true; //ADDED BY DYU 13-AUG-2015 - SET AUTO CREATED TO TRUE
        Boolean hasLiabilityMatch = false;
        
        Id liabilityRTId = APP_AccountDataExt.liabilityRecordTypeId(regionVar);
        Id appAccGenesisRTId = APP_AccountDataExt.appAccRecordTypeId('Genesis');
        Id appAccVisionRTId = APP_AccountDataExt.appAccRecordTypeId('Vision');
        Id appAccICBSRTId = APP_AccountDataExt.appAccRecordTypeId('ICBS');
        
        system.debug('AAGenesisRT:' + appAccGenesisRTId);
        system.debug('AAVisionRT:' + appAccVisionRTId);
        system.debug('AAICBSRT:' + appAccVisionRTId);
        system.debug('AACurrentRecordTypeId:' + appAccntVar.RecordTypeId);
        system.debug('Applicant Account - Parent Applicant:' + appVar.Id);
        
        system.debug('AACloseDate:' + appAccntVar.Closed_Date__c );
        system.debug('AAAccountCurrBalance:' + appAccntVar.Current_Balance__c );
        system.debug('AAAccountMaxCredLimit:' + appAccntVar.Maximum_Credit_Limit__c );
        
        // This string decimal represenation 
        // should at least have a zero value for decimal convert                
        if(appAccntVar.Current_Balance__c==null){
            appAccntVar.Current_Balance__c = '0';
        }
        
        try{
        // Genesis Applicant Account
        if(appAccntVar.RecordTypeId==appAccGenesisRTId && Decimal.valueOf(appAccntVar.Current_Balance__c)>0){
            liabilityVar.Applicant__c = appVar.Id;
            liabilityVar.Debt_Category__c = 'Car loan';
            liabilityVar.Financier_Name__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            
            try{
                //liabilityVar.Car_Personal_Bal_Amt__c = Decimal.valueOf(appAccntVar.Account_Balance__c);
                liabilityVar.Car_Personal_Bal_Amt__c = Decimal.valueOf(appAccntVar.Current_Balance__c); // Updated // Text
            }catch(exception e){
                system.debug('Genesis_Car_Personal_Bal_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Car_Personal_Bal_Amt__c = null;
            }
            
            //BEGIN MLASALA: 07-SEPT-15 - PMIHM-2119 Genesis accounts correct instalment amount to display in PL debts section
            //Commented out, changed mapping value to Next_Payment_Amount_Due__c
            //liabilityVar.Car_Personal_Repay_Amt__c = appAccntVar.Installment_Amount__c;
            liabilityVar.Car_Personal_Repay_Amt__c = appAccntVar.Next_Payment_Amount_Due__c;
            System.debug('$$$: Installment_Amount__c: '+appAccntVar.Installment_Amount__c+' Next_Payment_Amount_Due__c: '+appAccntVar.Next_Payment_Amount_Due__c);
            //END MLASALA: 07-SEPT-15 - PMIHM-2119 Genesis accounts correct instalment amount to display in PL debts section

            liabilityVar.Car_Personal_Repay_Int__c = 'Month';
            
            try{
                //liabilityVar.Car_Personal_Borrowed_Amt__c = Decimal.valueOf(appAccntVar.Credit_Limit_Borrowed_Amount__c);
                
                liabilityVar.Car_Personal_Borrowed_Amt__c = appAccntVar.Amount_Financed__c; // Updated // Decimal
            }catch(exception e){
                system.debug('Genesis_Car_Personal_Borrowed_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Car_Personal_Borrowed_Amt__c = null;
            }
           
            hasLiabilityMatch = true;
        // Vision Plus Applicant Account
        }else if(appAccntVar.RecordTypeId==appAccVisionRTId && appAccntVar.Closed_Date__c==null && appAccntVar.Maximum_Credit_Limit__c!=null){
            liabilityVar.Applicant__c = appVar.Id;
            liabilityVar.Debt_Category__c = 'Credit card';
            liabilityVar.Financier_Name__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            liabilityVar.Type_of_Credit_Card__c = 'Others'; //ADDED BY DYU 14-AUG-2015 AUGUST RELEASE- SET OTHERS AS DEFAULT VALUE

            try{
                liabilityVar.Credit_Limit_Amt__c = Decimal.valueOf(appAccntVar.Maximum_Credit_Limit__c);
            }catch(exception e){
                system.debug('VisionPlus_Credit_Limit_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Credit_Limit_Amt__c = null;
            }
            
            try{
                //liabilityVar.Card_Personal_Bal_Amt__c = Decimal.valueOf(appAccntVar.Current_Balance__c);
                // Liability field is number
                liabilityVar.Card_Overdraft_Bal_Amt__c = Decimal.valueOf(appAccntVar.Current_Balance__c);
            
            }catch(exception e){
                system.debug('VisionPlus_Card_Overdraft_Bal_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Card_Personal_Bal_Amt__c = null;
            }
            hasLiabilityMatch = true;
            
        // ICBS Applicant Account
        }else if(appAccntVar.RecordTypeId==appAccICBSRTId && Decimal.valueOf(appAccntVar.Current_Balance__c)>0){
            liabilityVar.Applicant__c = appVar.Id;
            liabilityVar.Debt_Category__c = 'Personal loan';
            liabilityVar.Financier_Name__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            
            try{
                //liabilityVar.Car_Personal_Bal_Amt__c = Decimal.valueOf(appAccntVar.Account_Balance__c);
                liabilityVar.Car_Personal_Bal_Amt__c = Decimal.valueOf(appAccntVar.Current_Balance__c); // Text
            }catch(exception e){
                system.debug('ICBS_Car_Personal_Bal_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Car_Personal_Bal_Amt__c = null;
            }
            
            //liabilityVar.Car_Personal_Repay_Amt__c = appAccntVar.Next_Payment_Amount_Due__c;
            liabilityVar.Car_Personal_Repay_Amt__c = appAccntVar.Installment_Amount__c; // Currency
            liabilityVar.Car_Personal_Repay_Int__c = 'Month';
            
            try{
                //liabilityVar.Car_Personal_Borrowed_Amt__c = Decimal.valueOf(appAccntVar.Credit_Limit_Borrowed_Amount__c);
                liabilityVar.Car_Personal_Borrowed_Amt__c = Decimal.valueOf(appAccntVar.Opening_Balance__c); // Text
            }catch(exception e){
                system.debug('ICBS_Car_Personal_Borrowed_Amt__c-Exception:' + string.valueOf(e));
                liabilityVar.Car_Personal_Borrowed_Amt__c = null;
            }
            hasLiabilityMatch = true;
        }
        
       
        }catch(exception e){
            system.debug('Major Liability Prepopulation Process Error:' + string.valueOf(e));
        }
        system.debug('hasLiabilityMatch:' + hasLiabilityMatch);
        
        if(hasLiabilityMatch==true){
            liabilityVar.Total_Debts__c = getDebtAmount(liabilityVar.Debt_Category__c, liabilityVar, regionVar); //Added by DYU 08/12/2015 - Get Total Debt
            liabilityVar.Applicable_Party__c = appliParty; // Populate Party
            liabilityVar.RecordTypeId = liabilityRTId;
            liabilityVar.Applicant_Account__c = appAccntVar.Id; // Set Source/Match Applicant Account as Parent
            return liabilityVar;
        }
        
        return null;
    }

    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: March 23, 2014
     *Description: Prepopulation validation
     */
    public Boolean validatePrepopulation(List<Applicant_CLV__c>appCLVList){
        Integer selectedApp1 = 0;
        Integer selectedApp2 = 0;
        Boolean IsMultiPrepop = false;
        
        for(Applicant_CLV__c appCLVVar:appCLVList){
            if(appCLVVar.prepopulate__c==true){ 
                if(appCLVVar.Applicant_Bucket__c == '1'){  
                    selectedApp1++;
                }else if(appCLVVar.Applicant_Bucket__c == '2'){ 
                    selectedApp2++;
                }
            }
        }
        
        if(selectedApp1>1||selectedApp2>1){
            IsMultiPrepop = true;
        }
        return IsMultiPrepop;
    }  

    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: December 17, 2013
     *Description: Method to go Product Selection Page
     */
    public PageReference displayApplicantAccount(){     
        showRelAppAccount = true;        
        applicantAccList = new List<Applicant_Account__c>();
        applicantAccList.clear();
         System.debug('###selectedCLV ' + selectedCLV);
        if(selectedCLV != null){
            applicantAccList = [SELECT Account_Balance__c,Selected_ICBS_Customer_Number__c ,Account_Number__c,Account_Open_Date__c,Account_Type__c,Applicant_CLV_GE_ID__c,Applicant_CLV__c,
                        CLV__c,Credit_Limit_Borrowed_Amount__c,Host_System_Identifier__c,Id,Message_Code__c,Message_Description__c,Name, CLV_Match_Indicator__c, Account_Status__c 
                        FROM Applicant_Account__c where Applicant_CLV__c=:selectedCLV];
            System.debug('###applicantAccList ' + applicantAccList.size());
            
            if(applicantAccList.size() == 0){
                noRecs = 'No records found. Click on the record again to retry.';
            }else{
                noRecs = null;
            }
            System.debug('### NO RECORDS: ' + noRecs);
        }
        System.debug('### showRelAppAccount: ' + showRelAppAccount + ' ' + noRecs);
        return null; 
    }

    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: December 17, 2013
     *Description: Displays the Applicant Account Detail
     */
    public PageReference displayApplicantAccountDetail(){       
        System.debug('SHOWING');
        String icbs = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        String vis = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        String gen = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
        List<Applicant_Account__c> appAccList = [Select Id, RecordTypeId from Applicant_Account__c where Id= : selectedAppACC];
        System.debug('&&&& selectedAppACC ' + selectedAppACC);
        if(appAccList.size()>0){
            if(appAccList[0].RecordTypeId == icbs){
                appRecordType = 'ICBS';
            }
            if(appAccList[0].RecordTypeId == vis){
                appRecordType = 'Vision';
            }
            if(appAccList[0].RecordTypeId == gen){
                appRecordType = 'Genesis';
            }
            
        }
        appPartylist = new List<Applicant_Account_Involved_Party__c>();
        appPartylist = retrievePartyList(selectedAppACC);
        if(appPartylist.size() > 0){
            showPartyList = true;
        }else{
            showPartyList = false;
        }
        System.debug('**** showPartyList ' + showPartyList); 
        showApplicantAccount = true;        
        return null; 
    }

    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: February 13, 2014
     *Description:
     */
    private List<Applicant_Account_Involved_Party__c> retrievePartyList(ID selapp) {
        List<Applicant_Account_Involved_Party__c> partyList = new List<Applicant_Account_Involved_Party__c>();
        if(selapp!=null) {
            for(sObject o: 
                queryRelatedRecords(
                SObjectType.Applicant_Account_Involved_Party__c.FieldSets.InvolvedParties.getFields(), 
                'Applicant_Account_Involved_Party__c', 'Applicant_Account__c' , selapp)) {
                partyList.add((Applicant_Account_Involved_Party__c)o);
            }
        } 
        return partyList;
    }
        
    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: February 13, 2014
     *Description: Get the ICBS Customer Number, Inserts record to the Applicant Account Customer
     */
    public PageReference copyICBSCustomerNumber(){                
        Applicant_Account__c appAcc = new Applicant_Account__c();
        Applicant_Account_Customer__c appAccCust = new Applicant_Account_Customer__c();
        List<Applicant_CLV__c> appCLVList = [Select Id, Applicant__c from Applicant_CLV__c where Id = : selectedCLV];        
        if(selectedAccountParty!=null){
            Applicant_Account_Involved_Party__c appParty = [Select Applicant_Account__c, Customer_Identifier__c, 
                                                                   Id, solicitFlag__c from 
                                                                   Applicant_Account_Involved_Party__c where 
                                                                   Id = : selectedAccountParty];
            appAcc = [Select Id, Selected_ICBS_Customer_Number__c, Account_Number__c from 
                      Applicant_Account__c where Id = :appParty.Applicant_Account__c];                    
            //appAcc.Selected_ICBS_Customer_Number__c = appParty.Customer_Identifier__c;
            appAccCust.Account_Number__c = appAcc.Account_Number__c;
            appAccCust.Customer_Number__c = appParty.Customer_Identifier__c;
            appAccCust.Applicant__c = appCLVList[0].Applicant__c;
            appAccCust.solicitFlag__c = appParty.solicitFlag__c;

            try{                
               // On insert, this will fire a trigger in Applicant Account 
               // Customer to update its parent applicant account
               // based on the values assigned to it.
               insert appAccCust;
            }catch(DmlException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 
                                                           'copyICBSCustomerNumber', 'APP_AccountDataExt', 'Class');               
            }
        }        
         
        return null;
    }
    
    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: February 13, 2014
     *Description: Clears the ICBS Customer Number field of the related Applicant Account data.
     */
    public PageReference clearICBSNumbers(){
        System.debug('#### selectedAppACC ' + selectedAppACC + '### applId ' + applId);
        List<Applicant_Account_Customer__c> appAccCustDelList = [Select Id, Applicant__c from 
                                                                 Applicant_Account_Customer__c where 
                                                                 Applicant__c IN :applId];
        Applicant_Account__c appAcc = [Select Id, Selected_ICBS_Customer_Number__c from 
                                       Applicant_Account__c where Id = : selectedAppACC];
        appAcc.Selected_ICBS_Customer_Number__c = '';
        try{
            update appAcc;
            /*CHECKMARX
            // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
            if(Applicant_Account_Customer__c.sObjectType.getDescribe().isDeletable()){
                delete appAccCustDelList;
            }
            */
            delete appAccCustDelList;
        }catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 
                                                       'clearICBSNumbers', 'APP_AccountDataExt', 'Class'); 
        }
        return null;
    }
        
    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: Jan 8, 2014
     *Description: Force Search Functionality
     */
    public PageReference forceSearch(){       
        System.debug('SHOWING');
        try{
            if(applicantAccList!=null) {
                if(!applicantAccList.isEmpty()) {
                    /*CHECKMARX
                    // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                    if(Applicant_Account__c.sObjectType.getDescribe().isDeletable()){
                        delete applicantAccList;
                    }
                    */
                    delete applicantAccList;
                }
            }
        }
        catch(Exception e){
            String appId = null;
            if(application.Id != null){
                appId = application.Id;
            }
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'forceSearch', 'APP_SearchAndMatchCC', 'Class', appId);
        }
        applicantAccList = new List<Applicant_Account__c>();
        showApplicantAccount = false; 
        showRelAppAccount = false;
        for(Applicant_CLV__c apclv : appCLVList){
            appCLVId.add(apclv.Id);
        }
        try{                    
            IS_CustomerSearch.customerAccountSearchService(appCLVId, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);
        }
        catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'loadSearchAndMatchCLV', 'APP_AccountDataExt', 'Class');
            Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
        }       
        return null; 
    }

    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: February 13, 2014
     *Description:
     */
    private List<sObject> queryRelatedRecords (List<Schema.FieldSetMember> fieldSetMembers, String objectName, 
                                               String parentObjectFieldName, String parentRecordId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate ASC';
        System.debug('###query: ' + query);
        return Database.query(query);
    }

    // PAGE REDIRECT METHODS //
    /*
     *Author: Jan Mark Domingo Cloud Sherpas
     *Created Date: December 16, 2013
     *Description: Method to go Back to Search and Match page.
     */
    public PageReference backToSearchandMatch(){
        PageReference ref = Page.APP_SearchAndMatch;
        ref.getParameters().put('id',String.valueOf(applicationId));
        ref.getParameters().put('goBack','1');
        return ref; 
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: April 15, 2015
     *Description: Refresh page to app eligibility page with application Id as parameter
     */
    public pageReference redirectToAppEligibilityPage(){
        //BEGIN MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
        //If application is not new, redirect back to search and match, else redirect as per BAU
        if(oldApp == 'true'){
            return backToSearchandMatch();
        } else {
            PageReference ref = Page.APP_ProductEligibility_INT;
            ref.getParameters().put('Id',String.valueOf(applicationId));
            return ref;
        }
        //END MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
    }

    /*
     *Author: Davey Yu
     *Created Date: August 12, 2015
     *Description: Calculate Total Debt Amount 
     *param: Category - Credit Card Category
     *param: debt - Liability record to be created
     *param: region - User region
     */
    public static Decimal getDebtAmount(String category, Liability__c debt, String region) {
        
        if(region == GEN_OriginationsConstants.AU_REGION){ //AU Credit card Calculation
            if(category == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT) {
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    return debt.Credit_Limit_Amt__c * 0.03;
                }else{  
                    return debt.Card_Overdraft_Bal_Amt__c * 0.03;
                }
            }
        }else{ //NZ Credit Card Calculation
            if(category == GEN_OriginationsConstants.DEBT_CATEGORY_CREDIT) {
                decimal repaymentPercent = GEN_OriginationsConstants.REPAYMENT_CALCULATION_THREE_PERCENT;
                if(debt.Card_Overdraft_Bal_Amt__c < debt.Credit_Limit_Amt__c){
                    if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Credit_Limit_Amt__c * repaymentPercent){
                        return debt.Credit_Limit_Amt__c * repaymentPercent;
                    }else{
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                    } 
                }else{
                    if(GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT < debt.Card_Overdraft_Bal_Amt__c * repaymentPercent){
                        return debt.Card_Overdraft_Bal_Amt__c * repaymentPercent;
                    }else{
                        return GEN_OriginationsConstants.DEBT_MONTHLY_REPAYMENT;
                    }
                }
            }

        }
        //same calculation for AU and NZ
        if(category == GEN_OriginationsConstants.DEBT_CATEGORY_PERSONAL_LOAN || category == GEN_OriginationsConstants.DEBT_CATEGORY_CAR_LOAN) {
            if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK){
                return (debt.Car_Personal_Repay_Amt__c * 52) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_FORTNIGHT){
                return (debt.Car_Personal_Repay_Amt__c * 26) / 12;
            }
            else if(debt.Car_Personal_Repay_Int__c == GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH){
                return debt.Car_Personal_Repay_Amt__c;
            }
        } 
        return 0;
    } 
    
}