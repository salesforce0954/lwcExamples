/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: November 22, 2013
Description: Class for the Search and Match Functionality.
Update: 11-12-2014  Added nwe field in Applicant_Search__c for DBHZL28   Tony Xu
Update: 04-09-2015  Comment-out the validation that reference to PRS - DY
Update 31-03-2016 Updated the search method validation to make the first name and last name also mandatory.
*/
public with sharing class APP_SearchAndMatchCC{
    public static final String TOPIC_NAME = 'ApplicantCLV';    
    private final sObject mysObject;

    public Applicant_Search__c appSearch        {get;set;}
    public List<Applicant_CLV__c> appClv1       {get;set;}
    public List<Applicant_CLV__c> appClv2       {get;set;}    
    public List<Applicant_CLV__c> appCLVList    {get;set;}
    public Applicant_Account__c appAccount      {get;set;}

    public String selectedApplicant             {get;set;}
    public String selectedApplicantCLV          {get;set;}
    public String applicantDirection            {get;set;} 

    public Boolean showWaitDialog               {get;set;}
    public Boolean showResults                  {get;set;}
    public Boolean hasResultError               {get;set;}
    public Boolean showUnsavedNotification      {get;set;}

    public String applicationId                 {get;set;}
    public Applicant__c applicant1              {get;set;}
    public Applicant__c applicant2              {get;set;}
    public Boolean displayPopup                 {get;set;}

    public static String rowId                  {get;set;}
    public static String dest                   {get;set;}
    public String useGrid                       {get;set;} 
    
    public Map<id, boolean> InAppClv1           {get;set;}
    public Map<id, boolean> InAppClv2           {get;set;}
    public Map<id, boolean> InAppCLVList        {get;set;}
    public Map<id, integer> InAppCLVListNo      {get;set;}
    public Map<id, string> InRowStyle           {get;set;}
    public Map<id,string> InBirthDateFormat     {get;set;}

    public boolean SearchInProgress             {get;set;}
    public boolean SearchDisabledValErr         {get;set;}

    public String timeoutSettings               {get;set;}

    public Boolean showTimeOut                  {get;set;}
    public String timeOutMessage                {get;set;}
    public Boolean stopTimer                    {get;set;}

    public String birthYear                     {get;set;}
    public String birthMonth                    {get;set;}
    public String birthDate                     {get;set;}

    public Boolean isExist                      {get;set;}
    public Boolean searchMatchViewControl       {get;set;}
    public Boolean searchMatchEditControl       {get;set;}
    public Boolean searchMatchControl           {get;set;}
    
    /********************************************************
    **  Search and match Enhancement 
    *********************************************************/
    
    public string selectedCriteria              {get;set;}
    public boolean isAcctNumSelected            {get;set;}
    public boolean  isPersonalInfoSelected      {get;set;}
    public String goBack {get;set;}
     
    /*****************END of Search and Match Enhancement **/
    

    public Integer searchCounter = 0;


    //Placeholder of deleted Id's
    
    public List<Id> deletedIds1 = new List<Id>();
    public List<Id> deletedIds2 = new List<Id>();

    public Set<String> appCLV1Id = new Set<String>();
    public Set<String> appCLV2Id = new Set<String>();

    public Set<Id> oldCLVId = new Set<Id>();    
    public Set<Id> newCLVId = new Set<Id>(); 

    Application__c currentApplication = new Application__c();

    //MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    public Map<Id, Debug_Log__c> clvHistoryMap = new Map<Id, Debug_Log__c>();
    // showProceedToCustomerDetails getter-setter
    public boolean showProceedToCustomerDetails{
        get{
            Boolean result = false;
        
            if(searchCounter > 0 ){
	    	//BEGIN MLASALA: 02-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                if(appClv1.size() > 0 || appClv2.size() > 0){
                    
                    //BEGIN MLASALA: 02-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                    for(Applicant_CLV__c ac: appClv1){
                        if(ac.User_Match_Flag__c){
                            result=true;
                            break;
                        }
                    }
                    
                    for(Applicant_CLV__c ac: appClv2){
                        if(ac.User_Match_Flag__c){
                            result=true;
                            break;
                        }
                    }
                    //END MLASALA: 02-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                }
            }
            
            return result;
        }
        set;  
    }
    
    public Boolean isDirty = false;     //MLASALA: 15-FEB-16 DIRTY FLAG ISSUE

    public Boolean isSearchAndMatchFlag {get; set;}  // Afreen: May-12-2016 
    
    /*  Description: Get Topic name
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: String
     */
    public String getName() {        
        return topic_Name; 
    }
    
    /*  Description: Setting Date Options when selecting month
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void setDate(){
        getDateOptions();
    }  
    
    /*  Description: monthOptions getter-setter
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    Public List<SelectOption> monthOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select', 'Month'));
            options.add(new SelectOption('01', 'January'));
            options.add(new SelectOption('02', 'February'));
            options.add(new SelectOption('03', 'March'));
            options.add(new SelectOption('04', 'April'));
            options.add(new SelectOption('05', 'May'));
            options.add(new SelectOption('06', 'June'));
            options.add(new SelectOption('07', 'July'));
            options.add(new SelectOption('08', 'August'));
            options.add(new SelectOption('09', 'September'));
            options.add(new SelectOption('10', 'October'));
            options.add(new SelectOption('11', 'November'));
            options.add(new SelectOption('12', 'December'));
            return options;
        }
        set;
    }
    
    /*  Description: Date Year picklist options
     *  Author: Mac Domingo
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    Public List<SelectOption> getYearOptions(){
        List<SelectOption> options = new List<SelectOption>();
        System.debug('###birthYear : ' + birthYear);
        integer currYear, oldestYear,startYear;
        currYear =  System.Today().year(); 
        oldestYear = currYear - 100;
        startYear = currYear - 18;
        options.add(new SelectOption('Select', 'Year'));
        for(Integer i = startYear ; i >= oldestYear  ; i --){
           options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));

        }   
        return options; 
    }

    /*  Description: BirthDate Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    Public List<SelectOption> getDateOptions(){
        List<SelectOption> options = new List<SelectOption>();
        System.debug('###birthMonth : ' + birthMonth);
        Integer dateNum = 31;
        options.add(new SelectOption('Select', 'Day'));
        if(Util.nullCheck(birthMonth)){     //05.14.15 Mike Lasala: Code Scan fix
            if(birthMonth== '02'){
                dateNum = 29;
            }
            if(birthMonth== '01' || birthMonth== '03' || birthMonth == '05' || birthMonth == '07' || birthMonth == '08' || birthMonth == '10' || birthMonth == '12' ){
                dateNum = 31;
            }
            if(birthMonth == '04' || birthMonth == '06' || birthMonth == '09' || birthMonth == '11'){
                dateNum = 30;
            }
        }
        for(Integer i = 1; i <= dateNum; i ++){
            if(i<=9) {
                options.add(new SelectOption('0' + String.valueOf(i), String.valueOf(i)));
            } else {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
        }
        return options;
    }
         
    /*  Description: Search criteria picklist selection
     *  Author: RDELACRUZ(OAKTON)
     *  Date Created: OCT.13.2014
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    Public List<SelectOption> SearchCriteriaOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', 'SELECT SEARCH CRITERIA'));
            options.add(new SelectOption('AcctNum', 'SEARCH BY ACCOUNT NUMBER'));
            options.add(new SelectOption('PersonalInfo', 'SEARCH BY PERSONAL INFORMATION'));
            return options;
        }
        set;
    }
    
    /*  Description: Show/Hide sections based on selected searched criteria
     *  Author: RDELACRUZ(OAKTON)
     *  Date Created: OCT.13.2014
     *  Input Parameters: None
     *  Return: Void
     */
    public void renderCriteria(){
        isAcctNumSelected = false;
        isPersonalInfoSelected = false;
        if(selectedCriteria!=''){
            if(selectedCriteria=='AcctNum')
                isAcctNumSelected = true;
            if(selectedCriteria== 'PersonalInfo')
                isPersonalInfoSelected = true;
        }
     
        if( ApexPages.CurrentPage().getParameters().get('goBack') != '1'){
            clearSearch();
        }else{
            appSearch = new Applicant_Search__c();
        }
    }
    
    /**  Description: 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public boolean getPrevSelectionExists(){
        if(appClv1.size() > 0 || appClv2.size() > 0) { return true;}
        return false;
    }

    /**  Description: 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public boolean getProceedToNext(){
        
        if (searchCounter > 0 ) {
            if(appCLVList.size() == 1) {
                if(appCLVList.get(0).Message_Code__c=='0000' || appCLVList.get(0).Message_Code__c=='9999') {
                    return  true;
                } else {return false;}
            }else {
                 if(appCLVList.size() > 1) {
                        return true ;
                 } else {return false;}
            }
        } else {return false;}
    }
    
    /** Description: Set boolean visiblity to true and set timeout message
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public void displayTimeoutMessage(){
        /*timeOutMessage = GEN_OriginationsConstants.NO_RESULT_FOUND;*/
        timeOutMessage = 'The search and match request timed-out please try again.';
        showTimeOut = true;
    }
    
     /*  Description: Opens the Pop Up window.
     *  Author: Mac Domingo
     *  Date Created: Nov-4-2013
     *  Input: None
     *  Return: N/A
     */
    /*
    public void showPopup(){
         if(rowId==null)
            rowId = ApexPages.CurrentPage().getParameters().get('rowId');

        if(rowId != null){
            appAccount  = [ Select  Id, Account_Balance__c, Account_Number__c, Account_Open_Date__c, Account_Type__c, Applicant_CLV__c, Applicant_CLV_GE_ID__c,
                                    CLV__c, Credit_Limit_Borrowed_Amount__c, Host_System_Identifier__c
                            from    Applicant_Account__c
                            where   Applicant_CLV__c =: rowId LIMIT 1];
        }    
        displayPopup = true;
    }
    */

    /*  Description: Close the Pop Up window.
     *  Author: Mac Domingo
     *  Date Created: Nov-4-2013
     *  Input: None
     *  Return: N/A
     */
    public void closePopup() {
        displayPopup = false; 
        showWaitDialog = false;
    }    
    
    // End of Page Visibility Methods
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   /*  Description: Class Constructor
     *  Author: Jan Mark Domingo
     *  Date Created: 22-Nov-2013
     *  Input Parameters: StandardController with type of Application__c
     *  Return: NA
     */
   public APP_SearchAndMatchCC(ApexPages.StandardController controller){         
 
        // Get Controller Application Record
        currentApplication = (Application__c)controller.getRecord();
        applicationId = currentApplication.Id;
        
        // Query Application Details if Application Id is not null       
        if(applicationId != null){
            
            currentApplication      = [Select Id, Status__c, Response_Code__c, Application_Restarted__c from Application__c where Id = :currentApplication.Id];
            isSearchAndMatchFlag    = currentApplication.Application_Restarted__c; // May-13-2015 Afreen - to display the banner on the page based on this flag           
        }
        
        // Set page setup and visibility based on response code of related application
        pageControl(currentApplication.Response_Code__c);

        //initialise application clv data buckets
        appClv1 = new List<Applicant_CLV__c>();
        appClv2 = new List<Applicant_CLV__c>();
        showTimeOut = false;

        appCLV1Id = new Set<String>();
        appCLV2Id = new Set<String>();
        InAppClv1   =  new Map<id, boolean>();
        InAppClv2   =  new Map<id, boolean>();
        InAppCLVList =  new Map<id, boolean>();
        InAppCLVListNo = new map<id,integer>();
        InRowStyle =     new map<id,string>(); 
        InBirthDateFormat = new map<id,string>();   
                
        // Initialise timeout settings
        timeoutSettings = initialiseTimeOutSetting(timeoutSettings);
        // Initialise go back value
        goBack = initialiseGoBackValue(goBack);

        if(applicationId!=null) {
            // get application associated applicants
            List<Applicant__c> applicantList = [SELECT id, name, First_Name__c, last_name__c, Is_Primary_Applicant__c
                                                FROM Applicant__c WHERE application__c =: applicationId];
                                                
            if(applicantList.size()>0) {
                //only 1 applicant found
                if(applicantList.size()==1) {
                    applicant1 = applicantList.get(0);
                //joint application -> now work out which one is the primary 
                }else if(applicantList.size()==2){
                    if(applicantList.get(0).Is_Primary_Applicant__c){
                        applicant2 = applicantList.get(1);
                        applicant1 = applicantList.get(0);
                    }else{
                        applicant1 = applicantList.get(1);
                        applicant2 = applicantList.get(0);
                    }
                // Fire error if there are more than 2 applicants related to application
                }else{                    
                    Util.addMessage(ApexPages.Severity.ERROR, 'Data Error. More than 2 applicants were found on this Application. Cannot proceed.');
                    return;
                }

                //get any existing applicant CLVs
                appCLVList = [  SELECT  Id, Message_Code__c, Message_Description__c, Applicant__c, Applicant__r.Application__c, Name, 
                                        CLV__c, Applicant_Search__c, Date_of_Birth__c, Drivers_License__c, First_Name__c, Home__c,
                                        Middle_Name__c, Mobile__c, Post_Code__c, State__c, Street_Address__c, Suburb__c, Surname__c, 
                                        Title__c, Work__c,Appliction_CLV_Code__c, Town__c, User_Match_Flag__c, (select id from Applicant_accounts__r) 
                                FROM    Applicant_CLV__c 
                                WHERE   Applicant__c IN: applicantList
                                AND     CLV__c != null];  
                                
                System.debug('appCLVList===>'+appCLVList);
                System.debug('appCLVListSize===>'+appCLVList.size());
		//MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                Id clvRecordTypeId = Schema.SObjectType.Debug_Log__c.getRecordTypeInfosByName().get('CLV').getRecordTypeId();
                
                // Process Matching CLVS
                for(integer i=0; i<appCLVList.size();i++) {
                    Applicant_CLV__c clv = appCLVList.get(i);
                    System.debug('in constuctor===>'+applicant1.id  +'<===>'+clv.applicant__c);
                    
                        if(applicant1.id == clv.applicant__c) {
                            appClv1.add(clv);
                        oldCLVId.add(clv.Id);
                        //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                        if(clv.User_Match_Flag__c){
                            appCLV1Id.add(clv.CLV__c);
                            InAppClv1.put(clv.id,true); 
                            InAppCLVList.put(clv.id,false);
                        } else {
                            InAppClv1.put(clv.id,false);
                            InAppCLVList.put(clv.id,true);
                        }
                            InAppClv2.put(clv.id,false); 
                            InAppCLVList.put(clv.applicant__c,false);
                    
                            
                        } else if(applicant2.Id == clv.applicant__c) {
                            appClv2.add(clv);
                        oldCLVId.add(clv.Id);
                        if(clv.User_Match_Flag__c){
                            appCLV2Id.add(clv.CLV__c);
                            InAppClv2.put(clv.id,true); 
                            InAppCLVList.put(clv.id,false);
                        } else {
                            InAppClv2.put(clv.id,false); 
                            InAppCLVList.put(clv.id,true);
                        }
                            InAppClv1.put(clv.id,false); 
                            InAppCLVList.put(clv.applicant__c,false);
                        //END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                        }
                            
                        InAppCLVListNo.put(clv.id,i + 1);
                        string sStyle = RowStyle(i + 1);
                        InRowStyle.put(clv.id,sStyle);
                        InBirthDateFormat.put(clv.id, FormatDateString(clv.Date_of_Birth__c));  
		    //BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                    Debug_Log__c clvHistory = new Debug_Log__c();
                    //Assign mapping
                    clvHistory.Application__c =  currentApplication.Id;
                    clvHistory.Applicant_CLV__c = clv.Id;
                    clvHistory.RecordTypeId = clvRecordTypeId;
                    clvHistory.Previous_Value__c = 'Salesforce';
                    clvHistoryMap.put(clv.Id, clvHistory);
		    //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                    }
                }
        }// End If applicationId!=null
       
        if(goBack != '1' ){ 
            appSearch = new Applicant_Search__c();        
            appSearch.country__c = [SELECT Country__c FROM User WHERE ID = : UserInfo.getUserId()].Country__c;  //DBHZL28       
            appCLVList = new List<Applicant_CLV__c>();
            appAccount = new Applicant_Account__c();
            isExist = false;
            showUnsavedNotification = false;
            isAcctNumSelected = false;
            isPersonalInfoSelected = false;
            selectedCriteria='';
            
            showWaitDialog = false;
            showResults = false;
            stopTimer = false;
        }else{
            showProceedToCustomerDetails = true;
            searchCounter += 1;
            
            showWaitDialog = false;
            showResults = true;
            stopTimer = true;
        }      
        
        searchFromSalesAndLeads();
    }
    
    /*  Description: Initialise goBack Value
     *  Author: Adrian Recio
     *  Date Created: 24-MAR-2015
     *  Input Parameters:
     *  Return: Void
     */
    public string initialiseGoBackValue(string goBackVar){
        // Determine goBack url parameter value
        if(ApexPages.CurrentPage().getParameters().get('goBack') == '1'){
            goBackVar = '1';
        }else{
            goBackVar='0';
        }
        return goBackVar;
    }
    
    /*  Description: Initialise timeout settings Value
     *  Author: Adrian Recio
     *  Date Created: 24-MAR-2015
     *  Input Parameters:
     *  Return: Void
     */
    public string initialiseTimeOutSetting(string timeoutSettingsVar){
        Web_Service_Settings__c sto =  Web_Service_Settings__c.getInstance('SearchTimeOut');
        if(sto!=null) {
            timeoutSettingsVar = sto.value__c;
        } else {
            timeoutSettingsVar = '45'; //default 
        }
        return timeoutSettingsVar;
    }

    /*  Description: This will control the search and match rendering depending on pre set 
                     custom settings for Profile Control and Response Code Control.
     *  Author: Jade Serrano
     *  Date Created: 27-MAR-2014
     *  Input Parameters:
     *  Return: Void
     */
    public void pageControl(String responseCode){
        Id profileId = UserInfo.getProfileId();

        searchMatchViewControl = Profile_Control__c.getInstance(profileId).Search_and_Match_View__c;
        searchMatchEditControl = Profile_Control__c.getInstance(profileId).Search_and_Match_Edit__c;

        if(!searchMatchViewControl && !searchMatchEditControl){
            Util.addMessage(ApexPages.Severity.ERROR, 'Your profile does not have access to the Customer Search and Match function');
        }

        List<Response_Code_Control__c> responseCodeControl = [SELECT Name FROM Response_Code_Control__c WHERE Name =: responseCode];

        if(responseCodeControl.size()>0){
                searchMatchControl = Response_Code_Control__c.getInstance(responseCode).Search_and_Match_Edit__c;
                System.debug('!@#searchMatchControl1: '+searchMatchControl);
        }else{
            if(responseCode==null){
                searchMatchControl = true;
                System.debug('!@#searchMatchControl2: '+searchMatchControl);
            }else{
                Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
                System.debug('!@#searchMatchControl3: '+searchMatchControl);
            }   
        }
    }
    
    /*  Description: Method to auto populate search fields based of 
                     URL parameters passed by sales and leads page.
     *  Author: Adrian Recio
     *  Date Created: 24-MAR-2015
     *  Input Parameters:
     *  Return: Void
     */
    public void searchFromSalesAndLeads(){
        // Pull flag parameter to determine that call came from salesandleads
        String searchFromSalesAndLeads = ApexPages.CurrentPage().getParameters().get('searchFromSalesAndLeads');
    
        if(searchFromSalesAndLeads=='TRUE'){
            // Populate public search fields
            selectedCriteria='PersonalInfo';
            isPersonalInfoSelected = true;
            birthDate = ApexPages.CurrentPage().getParameters().get('bDay');
            birthMonth = ApexPages.CurrentPage().getParameters().get('bMonth');
            birthYear = ApexPages.CurrentPage().getParameters().get('bYear');
            appSearch.Date_of_Birth__c = birthYear + '-' + birthMonth + '-' + birthDate;
            appSearch.Post_Code__c = ApexPages.CurrentPage().getParameters().get('postcode');
            appSearch.Mobile_Phone__c = ApexPages.CurrentPage().getParameters().get('mobilephone');
            appSearch.First_Name__c = ApexPages.CurrentPage().getParameters().get('firstname');
            appSearch.Last_Name__c = ApexPages.CurrentPage().getParameters().get('lastname');
        } 
    }

    /** Description: Method to call the web service that will watch for applicant CLV records.
     *  Author: Jan Mark Domingo
     *  Date Created: 11-25-13
     *  Input Parameters: 
     *  Return: 
     */
    public PageReference search(){
        showResults = false;
        
        //Calls an @future method
        //Util.getApplicantRecords();
        //Create/Check PushTopic record
        Boolean validationPass = true;
        checkPushTopic();
        system.debug('clv list: '+appCLVList);
        //delete records on the current page
        if(appCLVList.size() > 0 && goBack != '1'){            
            appCLVList = new List<Applicant_CLV__c>();

            InAppClv1   =  new Map<id, boolean>();
            InAppClv2   =  new Map<id, boolean>();
            InAppCLVList =  new Map<id, boolean>();
            InAppCLVListNo = new map<id,integer>();
            InRowStyle = new map<id,string>();
            InBirthDateFormat = new map<id,string>();      
        }
 
        // Account Number required validation
        if(isAcctNumSelected &&
            appSearch.account_number__c==null || appSearch.account_number__c==''){
            Util.addMessage(ApexPages.Severity.ERROR, 'Account Number required.');
            validationPass = false;
        } 
        
        // Account Number numeric validation
        if (isAcctNumSelected &&
            Util.nullCheck(appSearch.account_number__c) &&    //05.14.15 Mike Lasala: Code Scan fix
            !(appSearch.account_number__c.isnumeric())
            ) {
            Util.addMessage(ApexPages.Severity.ERROR, 'Account Number must be numeric');
            validationPass = false;
        }

        // Birthdate and post code required validation
        //Modified Lavanya Kavuri, 22-04-2015 for defect in AML : 569
        if( isPersonalInfoSelected &&
            (   (appSearch.date_of_birth__c==null || appSearch.date_of_birth__c=='') && 
                (
                    (appSearch.post_code__c==null || appsearch.post_code__c=='') || 
                    (appSearch.Mobile_Phone__c==null || appsearch.Mobile_Phone__c=='') || 
                    (appSearch.Drivers_License__c==null || appsearch.Drivers_License__c=='')
                )
            )
            ) {
                Util.addMessage(ApexPages.Severity.ERROR, 'Must enter Date of Birth and either Post code or Mobile number or Drivers License');
           
            validationPass = false;
        }

        // Postcode validation
        if(isPersonalInfoSelected && 
            (appSearch.date_of_birth__c!=null && (appSearch.post_code__c==null || appSearch.post_code__c==''))){
           Util.addMessage(ApexPages.Severity.ERROR, 'Must enter Post Code.'); 

           validationPass = false;
        }

        // Birthdate validation
        if(isPersonalInfoSelected && 
            (appSearch.post_code__c !=null && (appSearch.date_of_birth__c==null || appSearch.date_of_birth__c==''))){
           Util.addMessage(ApexPages.Severity.ERROR, 'Must enter Date of Birth.'); 

           validationPass = false;
        }
        
        if(isPersonalInfoSelected && 
            (appSearch.first_name__c==null || appSearch.first_name__c=='')){
           Util.addMessage(ApexPages.Severity.ERROR, 'Must enter First Name.'); 

           validationPass = false;
        }
        
        if(isPersonalInfoSelected && 
            (appSearch.last_name__c==null || appSearch.last_name__c=='')){
           Util.addMessage(ApexPages.Severity.ERROR, 'Must enter Last Name.'); 

           validationPass = false;
        }

		if(!validationPass){
			return null;
		}
        //Added by mlasala 2/10/2014 for perspecsys validation
        //Updated by DYU 04-09-15 - Comment-out the PRS validation
        /*if((appSearch.account_number__c!=null || appSearch.account_number__c!='') && appSearch.account_number__c=='ERR1'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Account Number must be less than 16 characters.');
            return null;
        }
        // date of birth ERR8 format validation
        if((appSearch.date_of_birth__c!=null || appSearch.date_of_birth__c!='') && appSearch.date_of_birth__c=='ERR8'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Date of Birth format is incorrect.');
            return null;
        // date of birth ERR6 age validation
        } else if((appSearch.date_of_birth__c!=null || appSearch.date_of_birth__c!='') && appSearch.date_of_birth__c=='ERR6'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Date of Birth must be more than 18 years of age.');
            return null;
        // date of birth ERR7 max 110 age validation
        } else if((appSearch.date_of_birth__c!=null || appSearch.date_of_birth__c!='') && appSearch.date_of_birth__c=='ERR7'){
            Util.addMessage(ApexPages.Severity.ERROR, 'Date of Birth must be less than 110 years of age.');
            return null; 
        }*/      
       
        showWaitDialog = true;
        showTimeOut = false;      
        
        try{
            // Check that applicant search can be created
            if (Applicant_Search__c.SObjectType.getDescribe().isCreateable()) {
                appSearch.Id = null;
                // Populate appSearch country based on current user
                appSearch.Country__c = [SELECT Country__c FROM User WHERE ID = : UserInfo.getUserId()].Country__c;  //DBHZL28
                insert appSearch;  
            }
        }catch(DmlException e){
            ErrorHandlerException.recordException(e.getMessage(), 'search', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
            Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
            return null;
        }
                  
        system.debug(' util.getUser().Mock_Enable__c = ' +  util.getUser().Mock_Enable__c);

        system.debug('appsearchId var:' + appSearch.Id);
        system.debug('utilgetuser:' + util.getUser().Mock_Enable__c);
        system.debug('ws Requested Name Sales:' + Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);
        
        // Removed by: Adrian Recio
        // Description: Call moved inside serverSearchCall method to implement fix for sync call
        // Date Changed: 9/10/2015
        //IS_CustomerSearch.customerSearchService(appSearch.Id, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c);     
        system.debug('appSearch in Search==>'+appSearch);
        searchCounter += 1;        
        return null;
    }
    /** Description: Method to perform sync call to search service
     *  Author: Adrian Recio
     *  Date Created: 10/9/2015
     *  Input Parameters: NA
     *  Return: NA
     */

    public void serverSearchCall(){
        if(appSearch.Id!=null){
            try{
                // Update by: Adrian Recio
                // Description: Added last boolean parameter to allow service to work dynamically based on a boolean.
                //              False: Service is called from Old Search and Match
                //              True: Service is called from Redesigned application form
                // Date Changed: 20/10/2015
                IS_CustomerSearch.customerSearchService(appSearch.Id, util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, false);
            }catch(DmlException e){
                ErrorHandlerException.recordException(e.getMessage(), 'search', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
                Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
            }
        }
    }

    /** Description: pull push topics base on final static topic name
     *  Author: Jan Mark Domingo
     *  Date Created: 11-25-13
     *  Input Parameters: 
     *  Return: 
     */
    public void checkPushTopic(){
        try{    
            //check if the push topic already exists                     
            List<PushTopic> topics = [SELECT id, name, query FROM PushTopic WHERE name =: TOPIC_NAME];
            // If topic doesn't exist create a new one
            if(topics.size()==0) {
                PushTopic pushTopic = new PushTopic();
                pushTopic.Name = TOPIC_NAME;               
                pushTopic.Query = 'SELECT Id, Applicant_Search__c, CLV__c, Message_Code__c, Message_Description__c FROM Applicant_CLV__c';
                pushTopic.ApiVersion = 30.0;
                pushTopic.NotifyForOperationCreate = true;
                pushTopic.NotifyForOperationUpdate = false;
                pushTopic.NotifyForOperationUndelete = false;
                pushTopic.NotifyForOperationDelete = false;             
                pushTopic.NotifyForFields = 'Referenced';                    
                insert pushTopic;
            }
        }catch(Exception e){
            system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'checkPushTopic', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
        }
    }

    /**  Description: Clears the search criteria
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public void clearSearch(){
        appSearch   = new Applicant_Search__c();
        appCLVList  = new List<Applicant_CLV__c>();

        InAppClv1   =  new Map<id, boolean>();
        InAppClv2   =  new Map<id, boolean>();
        InAppCLVList =  new Map<id, boolean>();
        InAppCLVListNo = new map<id,integer>();
        InRowStyle = new map<id,string>();
        InBirthDateFormat = new map<id,string>();      
        
        birthYear = '';
        birthMonth = '';
        birthDate = '';
        showWaitDialog = false;
        showTimeOut = false;
        showResults = false;

        searchCounter = 0;
    }

    /**  Description: 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public string FormatDateString(string dt){
        string dtVal, day, yr, mth;
        dtVal = dt;
        return dtVal; 
    }

    /**  Description: 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public string RowStyle(integer iRow){
        string s;
        if(math.mod(irow,2) == 0){
            s='TblRowBorder';
            return s ;
        }else{ 
            s='TblRowBackGrnd';
            return s ;
        }
    }

    /** Description: Main method that handles applicant clv selection buttons 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public PageReference move() {    

        showUnsavedNotification = true;
        System.debug('&&&& ROW ID ' + rowId);
        
        // This is the Id of Selected CLV passed via URL Parameter named rowId
        if(rowId==null){
            rowId = ApexPages.CurrentPage().getParameters().get('rowId');
        }
        
        // This determines the applicant number via URL Parameter named dest
        if(dest==null){
            dest = ApexPages.CurrentPage().getParameters().get('dest');
        }

        // This two parameter can't be null
        if(rowId==null || dest==null) {
            Util.addMessage(ApexPages.Severity.ERROR, 'Bad Move Parameters. rowId=' + rowId  + 'dest=' + dest);
            return null;
        }

        //look in the search results
        Integer foundIndex = -1;
        Applicant_CLV__C foundAppCLV = null;
        
        //BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        if(useGrid == '0'){
            for(integer i=0; i<appCLVList.size();i++) {
                Applicant_CLV__c appCLV = appCLVList.get(i);
                if(appCLV.id==rowId) {
                    foundIndex = i;
                    foundAppCLV = appCLV;
                    break;
                }
            }// End For
            
            if(foundIndex!=-1) {
                if(dest=='1') {               
                    // if (appCLV2Id.contains(foundAppCLV.CLV__c)){
                    //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                    //     return null;
                    // }else{
                        // if(appClv1.size() < 20){
                            if(applicant2 != null && 
                               foundAppCLV.Applicant__c == applicant2.Id){
                                Util.addMessage(ApexPages.Severity.ERROR, 'This CLV cannot be reassigned to Applicant 1.');
                                return null;
                            }
                            foundAppCLV.User_Match_Flag__c = true;
                          if(appCLv1.size() == 0){
                            appClv1.add(foundAppCLV);
                            appCLV1Id.add(foundAppCLV.CLV__c);  
                            InAppClv1.put(rowId,true);
                            InAppCLVList.put(rowId,false);
                          }else{
                                // Boolean result = appCLV1Id.add(foundAppCLV.CLV__c);   
                                // if(result == false){
                                //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                                //     return null;
                                // }else{
                              appClv1.add(foundAppCLV);
                              InAppClv1.put(rowId,true);
                              InAppCLVList.put(rowId,false);
                                // }                        
                          }
                        // }else{
                        //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add more than 20 Applicants');
                        //     return null;
                        // }// End Else
                    // }// End If               
            }// End If foundIndex!=-1
            
            if(dest=='2') {                
                    // if (appCLV1Id.contains(foundAppCLV.CLV__c)){
                    //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                    //     return null;
                    // }else {
                        // if(appClv2.size() < 20){
                            if(applicant2 != null && 
                               foundAppCLV.Applicant__c == applicant1.Id){
                                Util.addMessage(ApexPages.Severity.ERROR, 'This CLV cannot be reassigned to Applicant 2.');
                                return null;
                            }
                            foundAppCLV.User_Match_Flag__c = true;
                            if(appCLv2.size() == 0){
                                appClv2.add(foundAppCLV);
                                appCLV2Id.add(foundAppCLV.CLV__c);
                                InAppClv2.put(rowId,true);
                                InAppCLVList.put(rowId,false);    
                            }else{
                                // Boolean result = appCLV2Id.add(foundAppCLV.CLV__c);
                                // if(result == false){
                                //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                                //     return null;
                                // }else{
                                    appClv2.add(foundAppCLV);
                                    InAppClv2.put(rowId,true);
                                    InAppCLVList.put(rowId,false);
                                // }                        
                            }
                        // }else{
                        //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add more than 20 Applicants');
                        //     return null;
                        // }// End If Else
                    // }// End If Else
                }// End If dest=='2'
                isDirty = true;     //MLASALA: 15-FEB-16 DIRTY FLAG ISSUE
                return null;
            } // End If dest=='2'
        } // End If userGrid == '0'

        //look in applicant 1 bucket
        System.debug('in move appClv1===>'+appClv1);
        for(integer i=0; i<appClv1.size();i++) {
            Applicant_CLV__c appCLV = appClv1.get(i);
            System.debug('appCLV.id==rowId===>'+appCLV.id+'=='+rowId);
            if(appCLV.id==rowId) {
                foundIndex = i;
                foundAppCLV = appCLV;
                break;
            }
        }// End For

        System.debug('dest===>'+dest+'foundIndex===>'+foundIndex);
        if(foundIndex!=-1) {
            if(dest=='X') {
                foundAppCLV.User_Match_Flag__c = false;
                deletedIds1.add(rowId);
                //appCLVList.add(foundAppCLV);   
                System.debug('remove clv1===>'+foundAppCLV.CLV__c+'<===>'+InAppClv1);  
                appCLV1Id.remove(foundAppCLV.CLV__c);
                InAppClv1.put(rowId,false);
                InAppCLVList.put(rowId,true);
            }
                
            if(dest=='2') {               
                // if(appClv2.size() < 20){
                    if(applicant2 != null && 
                       foundAppCLV.Applicant__c == applicant1.Id){
                        Util.addMessage(ApexPages.Severity.ERROR, 'This CLV cannot be reassigned to Applicant 2.');
                        return null;
                    }
                    foundAppCLV.User_Match_Flag__c = true;
                    if(appCLv2.size() == 0){
                        appClv2.add(foundAppCLV);
                        appCLV2Id.add(foundAppCLV.CLV__c);
                        InAppClv2.put(rowId,true);
                        InAppCLVList.put(rowId,false);    
                    }else{
                        // Boolean result = appCLV2Id.add(foundAppCLV.CLV__c);
                        // if(result == false){
                        //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                        //     return null;
                        // }else{
                            appClv2.add(foundAppCLV);
                            InAppClv2.put(rowId,true);
                            InAppCLVList.put(rowId,false);
                        // }
                    }
                // }else{
                //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add more than 20 Applicants');
                //     return null;
                // }               
            }// End If dest=='2'
                
            // appClv1.remove(foundIndex);
            appCLV1Id.remove(foundAppCLV.CLV__c);
            InAppClv1.put(rowId,false);
            InAppCLVList.put(rowId,true);
            
            isDirty = true;     //MLASALA: 15-FEB-16 DIRTY FLAG ISSUE
            
            return null;
        }//End foundIndex!=-1
         
        //look in applicant 2 bucket
        System.debug('appClv2.size()===>'+appClv2.size()+'<====>'+appClv1.size());
        for(integer i=0; i<appClv2.size();i++) {
            Applicant_CLV__c appCLV = appClv2.get(i);
            if(appCLV.id==rowId) {
                foundIndex = i;
                foundAppCLV = appCLV;
                break;
            }
        }// End For        

        if(foundIndex!=-1) {
            if(dest=='1') {                
                //if(appClv1.size() < 20){
                    if(applicant2 != null && 
                       foundAppCLV.Applicant__c == applicant1.Id){
                        Util.addMessage(ApexPages.Severity.ERROR, 'This CLV cannot be reassigned to Applicant 1.');
                        return null;
                    }
                    foundAppCLV.User_Match_Flag__c = true;
                        if(appCLv1.size() == 0){
                            appClv1.add(foundAppCLV);
                            appCLV1Id.add(foundAppCLV.CLV__c);
                            InAppClv1.put(rowId,true);
                            InAppCLVList.put(rowId,false);
                        }else{
                        // Boolean result = appCLV1Id.add(foundAppCLV.CLV__c);
                        // if(result == false){
                        //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add duplicate CLV Ids.');
                        //     return null;
                        // }else{
                                appClv1.add(foundAppCLV);
                                InAppClv1.put(rowId,true);
                                InAppCLVList.put(rowId,false);
                        // }// End If - Else                        
                        }// End If - Else
                // }else{
                //     Util.addMessage(ApexPages.Severity.ERROR, 'You cannot add more than 20 Applicants');
                //     return null;
                // }// End If - Else                            
           }// End If dest=='1'
                
           if(dest=='X') {
                foundAppCLV.User_Match_Flag__c = false;
              deletedIds2.add(rowId);
              appCLV2Id.remove(foundAppCLV.CLV__c);
              InAppClv2.put(rowId,false);
              InAppCLVList.put(rowId,true);            
           }// End If
           
            // appClv2.remove(foundIndex);
           appCLV2Id.remove(foundAppCLV.CLV__c);
           InAppClv2.put(rowId,false);
           InAppCLVList.put(rowId,true);
           
           isDirty = true;     //MLASALA: 15-FEB-16 DIRTY FLAG ISSUE
           
           return null;
      }// End If foundIndex!=-1     
        //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
      return null;
    }// End move method

    /** Description: Create and process new application 
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public PageReference saveAndNext() {
        System.debug('appSearch in Save&Next==>'+appSearch);
        showUnsavedNotification = false;
        String custId = UserInfo.getUserId();
        Map<Id,Applicant_CLV__c> listDelAppCLV = new Map<Id,Applicant_CLV__c>();
        Boolean isChanged = false;        
        List<Id> idList1 = new List<Id>();
        List<Id> idList2 = new List<Id>();
              
        //Create the Applicaiton if it doesn't exist
        system.debug('^^^searchCounter' + searchCounter);
        Integer lSearch = 1; 
        Datetime d = System.now().addMinutes(-lSearch);

        if(applicationId == null){            
            if(searchCounter == 0){
                Util.addMessage(ApexPages.Severity.ERROR, 'Please ensure you have attempted to search for the applicant.');
                return null;
            }//End If
        }// End If-Else
        
        system.debug('promotionType:' + ApexPages.CurrentPage().getParameters().get('promotionType'));
           
        string promotionType = ApexPages.CurrentPage().getParameters().get('promotionType');
        string oppId = ApexPages.CurrentPage().getParameters().get('oppId');
        Boolean IsConApproved = false;

        try{
           if(applicationId==null) {
                Application__C application = new Application__c();
                system.debug('main oppId value:' + oppId);
                // Auto create application based on promotion campaign if 
                // connected lead is 'Conditionally Approved Offer' 
                if(oppId!=null && oppId!=''){
                   application.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_60_DAY_CERTIFICATE; //ADDED BY DYU 17-AUG-2015 PMIHM 1891 - Assign 60 DAY Certificate when it comes from GE PLAY
                   if(promotionType=='Conditionally Approved Offer'){
                        application.Id=ApprovedCampaignHandler.campaignProcess(promotionType,oppId);
                        IsConApproved = true;
                        system.debug('Conditionally Approved App Id:' + application.Id);
                        system.debug('Is Conditionally Approved!');
                   }
                }    

                // Determine application type based on search and match selected application CLVs
                System.debug('### APPCLV  1 ' + appClv1 + ' APP CLV 2 ' + appClv2);
                if(appClv1.size() > 0 && appClv2.size() > 0){
                    application.Application_Type__c = 'Joint';
                }
                if(appClv1.size() > 0 && appClv2.size() == 0){
                    application.Application_Type__c = 'Single';
                }
                if(appClv1.size() == 0 && appClv2.size() > 0){
                    application.Application_Type__c = 'Single';
                }
                if(appClv1.size() == 0 && appClv2.size() == 0){
                    application.Application_Type__c = '';
                }
                
                system.debug('Opp Id Param:' + ApexPages.CurrentPage().getParameters().get('oppId'));
                system.debug('Application is creatable:' + Application__C.SObjectType.getDescribe().isCreateable());
                
                //System.debug('## application.Application_Type__c ' + application.Application_Type__c);
                if (Application__C.SObjectType.getDescribe().isCreateable()) {
                    system.debug('Is Entered');
                    upsert application;
                    system.debug('New Upsert Application Created:' + application);
                    List<Opportunity> salesAndLeadsOpp = [Select Application__c from Opportunity where Id=:ApexPages.CurrentPage().getParameters().get('oppId')];
                    if(salesAndLeadsOpp.size()==1){
                        system.debug('Is Entered 2');
                        salesAndLeadsOpp[0].Application__c = application.Id;
                        update salesAndLeadsOpp;
                    }
                }
                system.debug('AppId:' + application.id);
                applicationId = application.id;
            }else{
                System.debug('### APPCLV  1 ' + appClv1 + ' APP CLV 2 ' + appClv2);
                if(appClv1.size() > 0 && appClv2.size() > 0){
                    currentApplication.Application_Type__c = 'Joint';
                }
                if(appClv1.size() > 0 && appClv2.size() == 0){
                    if(applicant2!=null) {
                        if(applicant2.id!=null && applicant2.First_Name__c==null && applicant2.last_name__c==null) {
                            currentApplication.Application_Type__c = 'Single';
                        }
                    }
                }
                if(appClv1.size() == 0 && appClv2.size() > 0){
                    if(applicant1!=null) {
                        if(applicant1.id!=null && applicant1.First_Name__c==null && applicant1.last_name__c==null) {
                            currentApplication.Application_Type__c = 'Single';
                        }
                    }
                }
                
                //MLASALA 15-JUL-2016 DEFECT 1152 FIX
                //Commented out. Application type should never be flushed
                //if(appClv1.size() == 0 && appClv2.size() == 0){
                //    currentApplication.Application_Type__c = '';
                //}
                
                if (Application__C.SObjectType.getDescribe().isUpdateable()) {
                    update currentApplication;
                }
                applicationId = currentApplication.id;
            } // End If-Else
        }catch(Exception e){
             ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'saveAndNext', 'APP_SearchAndMatchCC', 'Class');
             Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
             return null;
        }// End Catch
        
        //Create Applicant 1 if it doesn't exist
        System.debug('**** Applicant 1 ' +  applicant1 + ' #### Applicant 2 ' + applicant2);
        if(applicant1==null) {
            if (Applicant__c.SObjectType.getDescribe().isCreateable()) {
                
                // 1381 Change by Adrian Recio: Added force POI Verification 
                // value in POI_Financial_Situation_Verified__c field
                applicant1 = new Applicant__c(application__c = applicationId, Is_Primary_Applicant__c = true,
                                              POI_Financial_Situation_Verified__c = IsConApproved);
                insert applicant1;
            }// End If
        }// End If

        //Create Applicant 2 if it doesn't exist       
        
        if(applicant2 == null && !appClv2.isEmpty()) { 
            if (Applicant__c.SObjectType.getDescribe().isCreateable()) {//if appCLV2 is not empty and no applicant 2 is present
                
                // 1381 Change by Adrian Recio: Added force POI Verification 
                // value in POI_Financial_Situation_Verified__c field
                applicant2 = new Applicant__c(application__c = applicationId,
                                              POI_Financial_Situation_Verified__c = IsConApproved);
                insert applicant2;
            }// End If
        } else if(applicant2 != null) {
            if(applicant2.id!=null && applicant2.First_Name__c==null && applicant2.last_name__c==null && appClv2.isEmpty()) { //if applicant2 is still blank and no appCLV selected
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Applicant__c.sObjectType.getDescribe().isDeletable()){
                    delete applicant2;
                }
                */
                delete applicant2;
            }// End If
        }// End If-Else
        
        Map<Id,Applicant_CLV__c> appCLVListToInsert = new Map<Id,Applicant_CLV__c>();

        for(Applicant_CLV__c appCLV : appClv1) {
            System.debug('appCLV Applicant ' + applicant1.Id);
              if(applicant1.Id != null){
              appCLV.applicant__c = applicant1.Id;        
              appCLV.Applicant_Bucket__c = '1';
              appCLV.Last_Search__c = System.now();    
              appCLVListToInsert.put(appCLV.Id,appCLV);
              Boolean hasChanged = oldCLVId.contains(appCLV.Id);
              if(hasChanged == false){
                 newCLVId.add(appCLV.Id);
              }// End If
              idList1.add(appCLV.Id);
		//MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS                
                clvHistoryMap.get(appCLV.Id).New_Value__c = String.valueOf(appCLV.User_Match_Flag__c);
            }// End If
        }// End For
            
        //Save Audit Logs
        if(idList1.size() > 0){
            if(appSearch!=null){
                createAuditLog('1', 'Add', idList1, applicationId, custId, appSearch.Account_Number__c);    
            }// End If
        }// End If
 
        for(Applicant_CLV__c appCLV : appClv2) {
            System.debug('#### appCLV ' + applicant2.Id);
             if(applicant2.Id != null){
                appCLV.applicant__c = applicant2.Id;       
                appCLV.Applicant_Bucket__c = '2';         
                appCLV.Last_Search__c = System.now();    
                 appCLVListToInsert.put(appCLV.Id,appCLV);
                Boolean hasChanged = oldCLVId.contains(appCLV.Id);
                if(hasChanged == false){
                    newCLVId.add(appCLV.Id);
                }// End If            
                idList2.add(appCLV.Id);
		//MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                clvHistoryMap.get(appCLV.Id).New_Value__c = String.valueOf(appCLV.User_Match_Flag__c);
             }// End If
        }// End For
        
        if(idList2.size() > 0){
            if(appSearch!=null){
                createAuditLog('1', 'Add', idList2, applicationId, custId, appSearch.Account_Number__c);
            }// End If
        }// End If

        //save the applicant clv records
        System.debug('#### Saving Applicant CLV Records' + appCLVListToInsert);
        if(appCLVListToInsert.size() > 0){
            upsert appCLVListToInsert.values();        
        }// End If
        
        //Check if there are no deleted records
        System.debug('*** OLD CLV ID SIZE ' + oldCLVId + 'NEW CLV  ' + newCLVId);
        if(oldCLVId.size() == newCLVId.size()){
            System.debug('*** OLD CLV ID  ' + oldCLVId.containsAll(newCLVId));
            System.debug('*** NEW CLV ID  ' + newCLVId.containsAll(oldCLVId));
            if(!oldCLVId.containsAll(newCLVId) || !newCLVId.containsAll(oldCLVId)){
                isChanged = true;
            }// End If
        }// End If       

        System.debug('#### Deleted IDS 1 ' + deletedIds1 + ' ### Deleted IDS 2 ' + deletedIds2);
        if(deletedIds1.size() > 0){
            if(appSearch != null){
                createAuditLog('2', 'Remove', deletedIds1, applicationId, custId, appSearch.Account_Number__c);
            }// End If
            
            List<Applicant_CLV__c> listAppCLV = new List<Applicant_CLV__c>([Select  Id,Applicant__c from Applicant_CLV__c where Id in : deletedIds1 and Id not in : appCLVListToInsert.keyset()]);
            for(Applicant_CLV__c a : listAppCLV){
                listDelAppCLV.put(a.Id,a);
            }// End For
        }// End If        
        
        if(deletedIds2.size() > 0){
            if(appSearch != null){
                createAuditLog('2', 'Remove', deletedIds2, applicationId, custId, appSearch.Account_Number__c);
            }// End If
            
            List<Applicant_CLV__c> listAppCLV = new List<Applicant_CLV__c>([Select  Id,Applicant__c from Applicant_CLV__c where Id in : deletedIds2 and Id not in : appCLVListToInsert.keyset()]);
            for(Applicant_CLV__c a : listAppCLV){
                listDelAppCLV.put(a.Id,a);
            }// End For
        }// End If
        
        System.debug('#### listDelAppCLV ' + listDelAppCLV);
        if(listDelAppCLV.size() > 0){
            if (Applicant_CLV__c.SObjectType.getDescribe().isUpdateable()) {
                update listDelAppCLV.values();
            }// End If
            isChanged = true;
        }// End If

	//BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        if(!clvHistoryMap.isEmpty()){
            try{
                insert clvHistoryMap.values();
            }catch(Exception e){
                ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'saveAndNext', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
            }
        }
        
        //BEGIN MLASALA: 15-FEB-16 DIRTY FLAG ISSUE
        if(currentApplication.Id != null && isDirty) {
            if(Application__C.SObjectType.getDescribe().isUpdateable()){
                currentApplication.Out_Of_Sync__c = true;
                update currentApplication;
            }
        }
        //END MLASALA: 15-FEB-16 DIRTY FLAG ISSUE
        
        System.debug('### ID: ' + currentApplication.Id + ' Status: ' + currentApplication.Status__c);
        if(currentApplication.Id != null && currentApplication.Status__c != 'New' && showProceedToCustomerDetails){
            PageReference ref = Page.APP_AccountData;
            ref.getParameters().put('id',String.valueOf(applicationId));
            
            //BEGIN MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
            //Added parameter to identify if application is not new
            ref.getParameters().put('oldApp', 'true');
            return ref;
        }else{
            if((appClv1.size() == 0 && appClv2.size() == 0) || !showProceedToCustomerDetails) {
                PageReference ref;
                //BEGIN MLASALA 24-FEB-16 Refresh issue on new applications
                //if(applicationId != null){
                if(currentApplication.Id != null){
                //END MLASALA 24-FEB-16 Refresh issue on new applications
                
                    //If application is not new, refresh page because search and match is inside iframe
                     ref = Page.APP_SearchAndMatch;
                     ref.getParameters().put('goBack', '1');
                } else {
                    // PageReference ref = Page.APP_ProductEligibility_INT;
                    ref = Page.APP_ProductEligibility_INT;
                }
                ref.getParameters().put('Id',String.valueOf(applicationId));
                ref.setRedirect(true);
                return ref;
           }else{                
                PageReference ref = Page.APP_AccountData;
                ref.getParameters().put('id',String.valueOf(applicationId));
                if(!newCLVId.isEmpty()){
                    ref.getParameters().put('hasChanged', '1');
                }else{
                    if(isChanged == true){
                        ref.getParameters().put('hasChanged', '1');
                    }
                }
                
                //Added parameter to identify if application is not new
                if(currentApplication.Id != null){
                    ref.getParameters().put('oldApp', 'true');
                }
                //END MLASALA: 14-JAN-16 CAPINC0768525 Search Tab directing users to create new application
                
                ref.setRedirect(true);
                return ref;
           }// End If-Else 
        }// End If-Else                  
        //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    }

    /** Description: Main method to populate application clv record list
     *  Author: Jan Mark Domingo
     *  Date Created: 03-05-14
     *  Input Parameters: 
     *  Return: 
     */
    public PageReference getApplicantCLVRecords(){
        //List to be inserted for CLV search history
        //BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS

      Map<Id,boolean> validAppClv1 = new Map<Id,boolean>();
      for(ID clvID : InAppClv1.keySet()){
            // if(InAppClv1.get(clvID) == true){
            validAppClv1.put(clvID,true);
            // }
      }
     
      Map<Id,boolean> validAppClv2 = new Map<Id,boolean>();
      for(ID clvID : InAppClv2.keySet()){
            // if(InAppClv2.get(clvID) == true){
            validAppClv2.put(clvID,true);
            // }
      }
     
      System.debug('validAppClv1==>'+validAppClv1+'<===>'+InAppClv1+'<===>'+validAppClv2+'<===>'+InAppClv2);
     
      appCLVList = [  SELECT  Id, Message_Code__c, Message_Description__c, Applicant__c, Applicant__r.Application__c, 
                              Name, CLV__c, Applicant_Search__c, Date_of_Birth__c, Drivers_License__c, First_Name__c, Home__c,
                              Middle_Name__c, Mobile__c, Post_Code__c, State__c, Street_Address__c, Suburb__c, Surname__c, 
                              Title__c, Work__c,Appliction_CLV_Code__c, Town__c, (select id from Applicant_accounts__r) 
                        FROM  Applicant_CLV__c
                      //WHERE Applicant_Search__c = : appSearch.Id or Id  IN: validAppClv1.keyset() or Id IN: validAppClv2.keyset() ];
                      WHERE Applicant_Search__c = : appSearch.Id or Id  IN: validAppClv1.keyset() or Id IN: validAppClv2.keyset() 
                      ORDER BY Applicant_Search__c DESC];
        //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
      System.debug('appCLVList===>'+appCLVList);
      System.debug('clvCountValue:'+appCLVList.size());
      /**
      Set<String> clvList = new Set<String>();
        
      for( Integer k=0; k <appCLVList.size();k++ ){
        if(clvList.contains( appCLVList[k].CLV__c ) ){
            appCLVList.remove(k);
        }else{
             clvList.add(appCLVList[k].CLV__c);
        }
      }
      **/
                
     hasResultError = false;
     if(appCLVList.size() > 0 ){
        if(appCLVList.size() > 1000){
            ErrorHandlerException.recordException('appCLVList: Collection size exceeds 1000. appSearch = '+appSearch.Id+' appCLVList[0]: '+appCLVList.get(0).Id, 'getApplicantCLVRecords', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
        }

        showWaitDialog = false;
        showResults = true;
        stopTimer = true;
            
        if(goBack != '1'){
            InAppClv1   =  new Map<id, boolean>();
            InAppClv2   =  new Map<id, boolean>();
            InAppCLVList =  new Map<id, boolean>();
            InAppCLVListNo = new map<id,integer>();
            InRowStyle = new map<id,string>();
            InBirthDateFormat = new map<id,string>();
        }else{
            for(ID clvID : InAppClv1.keySet()){
                if(InAppClv1.get(clvID) == true){
                    InAppCLVList.put(clvID,false);
                    InAppClv1.put(clvID,true);
                    InAppClv2.put(clvID,false);
                }
            }// End For
            for(ID clvID : InAppClv2.keySet()){
                if(InAppClv2.get(clvID) == true){
                    InAppCLVList.put(clvID,false);
                    InAppClv2.put(clvID,true);
                    InAppClv1.put(clvID,false);
                }
            }// End For
        }// End If-Else
    
            Id clvRecordTypeId = Schema.SObjectType.Debug_Log__c.getRecordTypeInfosByName().get('CLV').getRecordTypeId();
        for(integer i=0; i<appCLVList.size();i++) {
            Applicant_CLV__c oAppCLV = appCLVList.get(i);
            
            if(!InAppClv1.containsKey(oAppCLV.id)){
                InAppClv1.put(oAppCLV.id,false); 
                InAppCLVList.put(oAppCLV.id,true);
            }
            
            if(!InAppClv2.containsKey(oAppCLV.id)){
                InAppClv2.put(oAppCLV.id,false);
                InAppCLVList.put(oAppCLV.id,true);
            }
           
            InAppCLVListNo.put(oAppClv.id,i + 1);
            string sStyle = RowStyle(i + 1);
            InRowStyle.put(oAppClv.id,sStyle);
            InBirthDateFormat.put(oAppClv.id, FormatDateString(oAppCLV.Date_of_Birth__c));      
                
		//BEGIN MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                Debug_Log__c clvHistory = new Debug_Log__c();
                //Assign mapping
                clvHistory.Application__c =  currentApplication.Id;
                clvHistory.Applicant_CLV__c = oAppCLV.Id;
                clvHistory.RecordTypeId = clvRecordTypeId;
                clvHistory.Previous_Value__c = 'Salesforce';
                clvHistoryMap.put(oAppCLV.Id, clvHistory);
                //END MLASALA: 01-DEC-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        }// End For
    } //End appCLVList.size() > 0

    //check for the "No Result" or "Exception" result
    //"0000" is success, "5555" is no results, "9999" is an exception
    if(appCLVList.size() == 1) {
        showResults = true;
        showUnsavedNotification = true;
        if(appCLVList.get(0).Message_Code__c!='0000') {
            hasResultError = true;
        }
    }
        
    //Set the Applicant=null, if user deselects and on search selects same id.
    String custId = UserInfo.getUserId();
    Map<Id,Applicant_CLV__c> listDelAppCLV = new Map<Id,Applicant_CLV__c>();
      if(deletedIds1.size() > 0){
           
        if(appSearch != null){
            createAuditLog('2', 'Remove', deletedIds1, applicationId, custId, appSearch.Account_Number__c);
        }
        //if(appClv1.size() == 0){
            List<Applicant_CLV__c> listAppCLV = new List<Applicant_CLV__c>([Select  Id,Applicant__c from Applicant_CLV__c where Id in : deletedIds1 ]);
            for(Applicant_CLV__c a : listAppCLV){
                //if(!appCLVListToInsert.containsKey(a.Id)){
                a.Applicant__c = null;
                listDelAppCLV.put(a.Id,a);
                //}
            }
        //}
    }      
    
    if(deletedIds2.size() > 0){
        if(appSearch != null){
            createAuditLog('2', 'Remove', deletedIds2, applicationId, custId, appSearch.Account_Number__c);
        }
        List<Applicant_CLV__c> listAppCLV = new List<Applicant_CLV__c>([Select  Id,Applicant__c from Applicant_CLV__c where Id in : deletedIds2 ]);
        for(Applicant_CLV__c a : listAppCLV){
            a.Applicant__c = null;
            listDelAppCLV.put(a.Id,a);
        }
    }// End If
        
    System.debug('#### listDelAppCLV ' + listDelAppCLV);
    if(listDelAppCLV.size() > 0){
        if (Applicant_CLV__c.SObjectType.getDescribe().isUpdateable()) {
            update listDelAppCLV.values();
        }// End If
    }// End If
        
    return null;
  }// End getApplicantCLVRecords

   
    /*  Description: Creates an Audit Log record
     *  Author: Mac Domingo
     *  Date Created: Nov-4-2013
     *  Input: None
     *  Return: N/A
     */
    private void createAuditLog(String auditCode, String auditAction, List<Id> idAddRem, String auditApplicationId, String auditCustId, String auditAccNumber){
        String addString = 'The following CLV IDs were added to the applicant:';
        String remString = 'The following CLV IDs were removed from the applicant:';
        String audAction = 'Customer Match: ';

        User u = [SELECT SSO_Number__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];

        Audit_Log__c aLog = new Audit_Log__c();
        aLog.Audit_Account_Number__c    = auditAccNumber;
        aLog.Audit_Action__c            = audAction + auditAction;
        aLog.Audit_Action_Type__c       = 'User';
        aLog.Audit_Code__c              = auditCode;
        aLog.Audit_Application__c       = auditApplicationId;
        aLog.Audit_Customer_ID__c       = auditCustId;
        aLog.Audit_Date_Time_Stamp__c   = System.now();
        alog.Audit_SSO_ID__c            = u.SSO_Number__c;

        if(auditCode == '1'){
            aLog.Audit_Log_Body__c      = addString + idAddRem;             
        }else{
            aLog.Audit_Log_Body__c      = remString + idAddRem;             
        }
        
        try{
            if (Audit_Log__c.SObjectType.getDescribe().isCreateable()) {
                insert aLog;
            }
        }catch(Exception e){
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'checkPushTopic', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
        }
    }

    /*  Description: update application's serach flag
     *  Author: Afreen Khan
     *  Date Created: May-12-2016
     */
    public void updateSearchFlag(){
        currentApplication.Application_Restarted__c = false;
        isSearchAndMatchFlag                        = false;
        try{
            update currentApplication;
        }catch(DmlException e){
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'updateSearchFlag', 'APP_SearchAndMatchCC', 'Class', String.valueOf(applicationId));
        }
    }
}