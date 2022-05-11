/*
Author: Michael Lasala Cloud Sherpas
Created Date: 2/18/2013
Description: GEPlayPage2 Controller
History: -- Updated code logic to display and control opportunity record in the page. DCRISOLOGO 2/19
*/

global with sharing class GEPlayPage2Controller{
    
    // Class Variable Declaration
    
    public Opportunity selectedOpp {get; set;}
    public Task selectedTask {get; set;}
    public Task readOnlyTask{get; set;}
    public boolean noTask {get; set;}
    public String namePanelCustomer {get; set;}
    public String namePanelOpp {get; set;}
    public String oppId {get; set;}
    public String accId;
    public String previousStage;
    public string isReadOnly = ApexPages.currentPage().getParameters().get('readOnly');
    public Boolean isDNS {get; set;}
    public string confirmMessage {get; set;}
    public double totalPauseTime;
    public datetime startTime;
    public string branchNameStr;
    public string usrSSONumberStr;
    public String perspecSysURL {get; set;} 
    public string processName{get; set;}
    public Id recordId{get; set;}
    public string sixtyDayAppId{get; set;}
    public string appCreateErrMsg{get; set;}
    public string appSetupSuccMsg{get; set;}
    public string appSixtyDayCertMsg{get; set;}
    public string geUniqueId{get; set;}
    public string genesysOutcome {get;set;}
    public string assignedUserSSO {get;set;}
    public Boolean isValid {get;set;}
    public Boolean hideButtons {get;set;}
    private List<opportunity> initialList;
    
    //Added by MLASALA 11-AUG-2016
    //Boolean to identify whether the user is associated with a call center
    public Boolean isCallCenter {get; set;}
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 27 Feb 2013
    * @description pull recordtypeid from task object
    * @param typeStr recordtype name under task object
    */
    public Id taskRecordTypeId(string typeStr){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task;
        Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        return TaskRecordTypeInfo.get(typeStr).getRecordTypeId();
    }// End taskRecordTypeId Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 27 Feb 2013
    * @description pull recordtypeid from branch assignment object
    * @param typeStr recordtype name under branch assignment object
    */
    public Id branchAssRecordTypeId(string typeStr){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Branch_Assignment__c;
        Map<String,Schema.RecordTypeInfo> baRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        return baRecordTypeInfo.get(typeStr).getRecordTypeId();
    }// End taskRecordTypeId Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Contractor Method
    * @param 
    */ 
    public GEPlayPage2Controller() {
        
        //set the url to blank if no value in custom settings
        this.perspecsysURL = timeout__c.getOrgDefaults().Perspecsys_URL__c;
        if(this.perspecsysURL == null) {
            this.perspecsysURL = '';
        }
        
        // Vaariable Declaration for Editable GEPlay Page
        selectedTask = new Task();  
        noTask = false;
        
        // Variable Declaration for Read only GEPlay Page
        readOnlyTask = new Task();
    
    // Varaible Declaration for Editable and Read only Page
        oppId = ApexPages.currentPage().getParameters().get('oppid');
        isDNS = false;
        
        for(Opportunity opp: [SELECT Name, Call_Type__c,Description,
                                     StageName, PlayPageSave__c, PRS_Record_Id__c, Processed__c,
                                     Application_Number__c,Assigned_to_User__c,
                                     Call_Start_Date_Time__c, Call_End_Date_Time__c,
                                     Cumulative_Pause_Time__c, Paused__c,
                                     OwnerId,ID, Outcome_Code__c,Pause_Date_Time__c, UnPause_Date_Time__c,
                                     Marketing_Segment_Code__c,Excluded_Date__c,
                                     Campaign.StartDate, Campaign.EndDate,
                                     Account.CLV_Customer_ID__c, Account.Name, Account.PersonTitle, Branch_Name__c,
                                     Account.FirstName, Account.LastName, Account.Date_of_Birth__pc,
                      Account.PersonMailingPostalCode,Account.PersonMobilePhone,
                                     Time_Out__c, PostCode_Exclusion__c,Campaign.Promotional_Campaign__c, 
                                     Application__c, Region__c,AccountId, Contract_Date__c, Account_Number__c, Application_GE_Unique_Id__c                               
                                     FROM   Opportunity
                                     WHERE  Id =: oppId limit 1]) {  
                                             
            String strSalutation = '';
            if(opp.Account.PersonTitle != null){
                strSalutation = opp.Account.PersonTitle;
            }
            // Set Default Values for Display                                                               
            this.namePanelCustomer = strSalutation + ' ' + opp.Account.Name;
            this.namePanelOpp = opp.Name;
            previousStage = opp.StageName;
     
            // Set Default Values for Opportunity
            this.selectedOpp = opp;

            System.debug('opp region : ' + opp.Region__c);
            
            // Check current page name
            String pageName = ApexPages.currentPage().getUrl();
            pageName = pageName.split('apex/')[1];

            // Set values if page is editable GePlay Page
            if(pageName.toLowerCase().contains('geplaypage2readonly') == false){

               this.selectedOpp.StageName = '';
               this.selectedOpp.Call_Type__c = 'Outbound Call';
               
               // Empty Description if opportunity is not paused
               if(this.selectedOpp.Pause_Date_Time__c == null){
                 this.selectedOpp.Description = '';
               }// End If
               
            // Set values if page is read only GePlay Page
            }
            
            // Default values for both pages
            selectedOpp.Assigned_to_User__c = UserInfo.getUserId();
            
            // Assign GE Unique Id
            geUniqueId = this.selectedOpp.Application_GE_Unique_Id__c;
            
            //BEGIN MLASALA 11-AUG-2016
            isCallCenter = false;
            hideButtons = false;
            
            //Retrieve user call center
            User loggedUser = [SELECT CallCenterId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            
            //Parameter which identifies whether lead was accessed through Play, To-Do List or Recent Leads
            String isDialer = ApexPages.currentPage().getParameters().get('isDialer');
            
            //If call center exists, set boolean to true
            if(loggedUser != null && 
               loggedUser.CallCenterId != null){
                   
                hideButtons = true;
               
               if(isDialer != 'false'){
                
                    isCallCenter = true;
               }
            }
            //END MLASALA 11-AUG-2016
            
        }// End For 
    }// End Constractor Method

      
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: Main method to pull icbs account number from lead Billing ICBS Records
    * @description Split checker
    * @param 
    */
    @RemoteAction 
    global static string pullICBSAccountNumber(List<sObject> objects, string OppId, Map<String,String> dmlOptions){
       
       // Check if opportunity is overriden
       Opportunity updateOpp = [Select Id, override_ICBS_Billing__c, Account_Number__c from Opportunity where Id=:OppId];
       String AccNumberResult = null;
       
       if(updateOpp.override_ICBS_Billing__c==false){
         
         List<Billing_ICBS__c> billICBSList = new List<Billing_ICBS__c>();

         // Cast billing icbs
         for(sObject sObjectVar:objects){
           Billing_ICBS__c billICBSVar = (Billing_ICBS__c)sObjectVar;
           billICBSList.add(billICBSVar);
           system.debug('ICBS Record Value:' + billICBSVar);
         }
  
         if(billICBSList.size()>0){
          Date maxDate = null;
          Integer currCount = 0;
          Billing_ICBS__c billICBSMain = null;
          
          try{
            for(Billing_ICBS__c billICBSVar:billICBSList){
              if(currCount == 0){
                List<String> dateValArr = billICBSVar.Contract_Date__c.split('/', 3);
                system.debug('Date Array:' + dateValArr);
                Date dateVal = Date.valueOf(dateValArr[2] + '-' + dateValArr[1] + '-' + dateValArr[0]);
                maxDate = dateVal;
                billICBSMain = billICBSVar;
                currCount++;
              }else{
                List<String> dateValArr = billICBSVar.Contract_Date__c.split('/', 3);
                system.debug('Date Array 2:' + dateValArr);
                Date dateVal = Date.valueOf(dateValArr[2] + '-' + dateValArr[1] + '-' + dateValArr[0]);
                if(dateVal>maxDate){
                  maxDate = dateVal;
                  billICBSMain = billICBSVar;
                }
              }
            }
            
            system.debug('MaxDate:' + maxDate);
            system.debug('Final Billing Match:' + billICBSMain);
            
            if(billICBSMain!=null){
              if(billICBSMain.Account_Number__c!=null){
                updateOpp.Account_Number__c = GEPlayPage2Controller.specialAccountNumberTrim(billICBSMain.Account_Number__c);
              updateOpp.Contract_Date__c = maxDate;
                update updateOpp;
                AccNumberResult = updateOpp.Account_Number__c ;
              }
            }
          }catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Billing ICBS Contract date found for 60 day certificate.');
                ApexPages.addMessage(myMsg);   
          }
        }
       }else{
           AccNumberResult = updateOpp.Account_Number__c;
       }
     
     return AccNumberResult;
      
    }

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 07 April 2013
    * @description Method to trim Application Number from Billing ICBS.
             This method will perform trim logic based on the business rule example below.
             
             If passed value is '200000123056',
              trim to only have '123056'. All characters
                that is non zero including the very first character regardless if it is non zero
                will be removed in the start of the string. The first time a non zero character is 
                found use the it and the rest of the characters as the final trimmed value.
            
    * @param accNoVar - String to hold account number found from Billing ICBS
    * @return string - trimmed account number value
    */ 
    public static string specialAccountNumberTrim(string accNoVar){
    string trimmedStr = '';
    if(accNoVar!=null){
      for(integer i=1;i<accNoVar.length();i++){
        system.debug('Trim Value:'+accNoVar.substring(i, i+1));
          
          if(accNoVar.substring(i, i+1)!='0'){
              trimmedStr = accNoVar.substring(i, accNoVar.length());
              break;
          }
      }
    }
    system.debug('Trimmed Value:' + trimmedStr);
      return trimmedStr;
    }
        
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns call type picklist values
    * @param 
    */ 
    public List<SelectOption> getCallTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Inbound Call','Inbound Call')); 
        options.add(new SelectOption('Outbound Call','Outbound Call')); 
        return options; 
    }// End getCallTypes Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns stage picklist values depending on the opportunity call type
    * @param 
    */ 
    public List<SelectOption> getStages(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','- Choose Outcome -'));
        // Stages if Call type is 'Inbound Call'
        if(this.selectedOpp.Call_Type__c=='Inbound Call') {
            options.add(new SelectOption('Application Taken','Application Taken'));
            if(this.selectedOpp.Region__c == 'AU'){
                options.add(new SelectOption('Application Taken - Auto Loan','Application Taken - Auto Loan'));
                options.add(new SelectOption('Application Taken - Exception Process','Application Taken - Exception Process'));
            }
            options.add(new SelectOption('Do Not Solicit','Do Not Solicit'));
            options.add(new SelectOption('Not Interested','Not Interested'));
            options.add(new SelectOption('Set Follow-Up Call','Set Follow-Up Call'));
        
        // Stages if Call Type is Outbound Call
        } else if(this.selectedOpp.Call_Type__c=='Outbound Call') {
            options.add(new SelectOption('Application Taken','Application Taken'));
            if(this.selectedOpp.Region__c == 'AU'){
                options.add(new SelectOption('Application Taken - Auto Loan','Application Taken - Auto Loan'));
                options.add(new SelectOption('Application Taken - Exception Process','Application Taken - Exception Process'));
            }
            options.add(new SelectOption('Customer Not Available','Customer Not Available'));
            options.add(new SelectOption('Disconnected','Disconnected'));
            options.add(new SelectOption('Do Not Solicit','Do Not Solicit'));
            options.add(new SelectOption('Left Message','Left Message'));
            options.add(new SelectOption('Not Interested','Not Interested'));
            options.add(new SelectOption('No Answer','No Answer'));
            options.add(new SelectOption('Set Follow-Up Call','Set Follow-Up Call'));
            options.add(new SelectOption('Unsuitable Lead','Unsuitable Lead'));
            options.add(new SelectOption('Wrong Number','Wrong Number'));
            options.add(new SelectOption('Please Contact me letter sent','Please Contact me letter sent'));
            options.add(new SelectOption('Number Busy','Number Busy')); //Added by MLASALA 15-AUG-2016 New outcome
            
        // If Call Type is null set to None
        } else {
            options.add(new SelectOption('None','No call type selected',true)); 
        }// End Else
        return options; 
    }// End getStages Method 

    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a options for reason picklist
    * @param 
    */ 
    public List<SelectOption> getReasonDNS() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('',''));
        options.add(new SelectOption('Adverse to telemarketing','Adverse to telemarketing'));
        options.add(new SelectOption('DNQ - permanent','DNQ - permanent'));
        options.add(new SelectOption('Other bank loyalty','Other bank loyalty'));
        options.add(new SelectOption('Other – elaborate in comments','Other – elaborate in comments'));
        options.add(new SelectOption('Poor GE relationship','Poor GE relationship'));
        return options; 
    }// End getReasonDNS Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a options for reason picklist
    * @param 
    */  
    public List<SelectOption> getReasonNI() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('',''));
        options.add(new SelectOption('DNQ - permanent','DNQ - permanent'));
        options.add(new SelectOption('DNQ - temporary','DNQ - temporary'));
        options.add(new SelectOption('Doesn’t see benefit','Doesn’t see benefit'));
        options.add(new SelectOption('Other bank loyalty','Other bank loyalty'));
        options.add(new SelectOption('Other – elaborate in comments','Other – elaborate in comments'));
        options.add(new SelectOption('Partner is Decision Maker','Partner is Decision Maker'));
        return options; 
    }// End getReasonNI Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a boolean value, true if Stage is equal to 'Do Not Solicit'
    * @param 
    */            
    public Boolean getRenderDNSBox() {
        if(this.selectedOpp.StageName == 'Do Not Solicit') {
            isDNS = true;
            confirmMessage = 'Are you sure you would like to choose this?';
            return true;
           
        }// End if
        return false;
    }// End getRenderDNSBox Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a boolean value, true if Stage is equal to 'Not Interested'
    * @param 
    */
    public Boolean getRenderNIBox() {
        if(this.selectedOpp.StageName == 'Not Interested') {
            return true;
        }// End If
        return false;
    }// End getRenderNIBox Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a boolean value, true if Stage is equal to 'Application Taken'
    * @param 
    */
    public Boolean getRenderAppTakenBox() {
        if(this.selectedOpp.StageName == 'Application Taken') {
            return true;
        }// End If
        return false;
    }// End getRenderAppTakenBox Method

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 10 June 2015
    * @description Getter method that returns a boolean value, true if Stage is equal to 'Application Taken - Auto' or 'Application Taken - Exception'
    * @param 
    */
    public Boolean getRenderAppTakenSpecialBox(){
        if(this.selectedOpp.StageName == 'Application Taken - Auto Loan' || 
           this.selectedOpp.StageName == 'Application Taken - Exception Process') {
            return true;
        }// End If
        return false;
    }
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Getter method that returns a boolean value, true if Stage is equal to 'Set Follow-Up Call'
    * @param 
    */
    public Boolean getRenderFollowUpBox() {
        if(this.selectedOpp.StageName == 'Set Follow-Up Call') {
            return true;
        }// End If
        return false;
    }// End getRenderFollowUpBox Method    
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Method to perform validation and dml operation for opportunity and it's task
    * @param 
    */
    
    public boolean updateRecord() {
        // Variable Declaration
        Boolean validationSuccessful = false;
        Boolean isFollowUpCallError = false;
        
        // Validation if outcome selected is null or empty string
        if(this.selectedOpp.StageName == null || this.selectedOpp.StageName ==''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an outcome.');
            ApexPages.addMessage(myMsg);
            return validationSuccessful;
        }// End if  
        
        system.debug('Opportunity Stage:' + this.selectedOpp.StageName);

        //If stage is application taken require Application Number
        if(this.selectedOpp.StageName.equalsIgnoreCase('Application Taken')) {
            // Refresh Application Value since GE Unique Id can be auto populated in a different page in the back ground
            List<Opportunity> refreshApplicationVal = [Select Id,Application__c from Opportunity where Id = :this.selectedOpp.Id];
            
            system.debug('refreshApplicationVal size:' + refreshApplicationVal.size());
            for(Opportunity oppVar: refreshApplicationVal){
              // Refresh selected opportunity var
              this.selectedOpp.Application__c = oppVar.Application__c;

        system.debug('Lead Application:' + oppVar.Application__c);
              if(oppVar.Application__c==null){
                  //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Application number should not be null if Stage = Application Taken');
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Application not yet taken.');
                  ApexPages.addMessage(myMsg);
              } else {
                  validationSuccessful = true;
              }// End Else
            }
        // If stage is Application Taken , Auto Loan or Exception Process
        }else if(this.selectedOpp.StageName.equalsIgnoreCase('Application Taken - Auto Loan') || 
             this.selectedOpp.StageName.equalsIgnoreCase('Application Taken - Exception Process')){
            if(this.selectedOpp.Application_Number__c==null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Application number not specified.');
                ApexPages.addMessage(myMsg);
            } else {
                validationSuccessful = true;
            }// end Else
        }else if (this.selectedOpp.StageName.equalsIgnoreCase('Set Follow-Up Call')) {
            //Check if Reminder Date is null
            if(this.selectedTask.ReminderDateTime==null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Date & Time');
                ApexPages.addMessage(myMsg);
                isFollowUpCallError = true;
            } else {
                if(this.selectedTask.ReminderDateTime>=Date.Today().addDays(90)){
                // Check if Reminder Date Time is greater than 90 days from today's date, if true, throw an error
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Reminder date should not be set more than the 3 months from the current date');
                    ApexPages.addMessage(myMsg);
                    isFollowUpCallError = true;
                } else if(DateTime.newInstanceGmt(this.selectedTask.ReminderDateTime.date(), this.selectedTask.ReminderDateTime.time())>=DateTime.newInstanceGmt(System.now().date(), System.now().time())) {
                // Check if Reminder Date Time is greater than todays date, if true, throw an error
                    this.selectedTask.IsReminderSet = true;
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Reminder date should not be less than the current date and time');
                    ApexPages.addMessage(myMsg);
                    isFollowUpCallError = true;
                }// End Else
            }// End If
            
            // Check if assigned to user is null, if true, throw an error
            if(this.selectedOpp.Assigned_to_User__c == null && isFollowUpCallError == false){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Assigned to User:Field is Required');
                    ApexPages.addMessage(myMsg);    
                    isFollowUpCallError = true;
            }// End If
            
            // If there are no errors and current stage is Set Follow-Up Call create second task 
            if(isFollowUpCallError == false){
                validationSuccessful = true;
            }// End If
        } else {
            validationSuccessful = true;
        }// End Else
        
        // If there are no validation errors, perform update to opportunity and main task
        if(validationSuccessful) {
            // Query Branch Assignment name for assigned user         
            setupOpportunity();
            insert defaultTaskValue(this.selectedTask,this.selectedOpp,true);
            
            //Flush all the call stats values
            this.selectedOpp.Call_End_Date_Time__c = null;
            this.selectedOpp.Call_Start_Date_Time__c = null;
            this.selectedOpp.Cumulative_Pause_Time__c = null;
            this.selectedOpp.Pause_Date_Time__c = null; 
            this.selectedOpp.UnPause_Date_Time__c = null;
            this.selectedOpp.Paused__c = false;
            this.selectedOpp.PlayPageSave__c = true;
            
            update this.selectedOpp;     
            
        }// End If
        
        if(validationSuccessful && this.selectedOpp.StageName.equalsIgnoreCase('Set Follow-Up Call')){
            createFollowUpTask();
        }// End If
        
        //MLASALA 16-AUG-16 Added public variable to use for validation before calling softphone method
        isValid = validationSuccessful;
        return validationSuccessful;
    }// End updateRecord Method
    
    
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 14 March 2013
    * @description Method to close all open task
    * @param 
    */
    public void closeTask(){
        // Select all task where whatId is equal to current opportunity and status is open
        List<Task>closeTaskList = new List<Task>();
        for(Task tVar: [Select Id,Status, PlayPageSave__c from Task where whatID = :selectedOpp.ID and Status = 'Open']){
            tVar.PlayPageSave__c = true;
            tVar.Status = 'Completed';
            tVar.Subject = 'Call';
            closeTaskList.add(tVar);
        }// End For
        
        if(closeTaskList.size()>0){
            Update closeTaskList;
        }
    }// End closeTask Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 27 Feb 2013
    * @description Create follow up task and sent email notification
    * @param 
    */
    public void createFollowUpTask(){
            // Close all open task before creating a new open task 
            closeTask();
            
            // Create an open task
            insert defaultTaskValue(this.selectedTask,this.selectedOpp,false);
            
            // Send email to user specified in the assigned to user field if it's not the current user
            // Recipient User type must be a Standard SF licence (not community user) 
            if(this.selectedOpp.Assigned_to_User__c != userinfo.getUserId()){
               SalesAndLeadsUtility slUtil = new SalesAndLeadsUtility();
               slUtil.pushEmail(this.selectedOpp.Assigned_to_User__c, this.selectedOpp.Id);
            }// End If
    }// End createFollowUpTask Method
    
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 14 March 2013
    * @description Populate default task values
    * @param 
    */
    public Task defaultTaskValue(Task taskValue, Opportunity parentOpp, Boolean IsCompleted){
        
        // Clear task value
        taskValue.Id = null;
        
        // Query branch assignment work location for current pfr
        List<Branch_Assignment__c> branchAssWorkLocation = [Select Id, Branch__r.Name from Branch_Assignment__c 
                                                            where RecordTypeId = :branchAssRecordTypeId('Working Location') and 
                                                            User__c = :this.selectedOpp.Assigned_to_User__c limit 1]; 
        
        // Query sso number for assigned user
        List<User> usrVar = [Select Id, SSO_Number__c from User where Id = :this.selectedOpp.Assigned_to_User__c limit 1];
        
        branchNameStr = '';
        usrSSONumberStr = '';
        
        // Assign to string variable if there's a work location and sso number for the assigned pfr     
        if(branchAssWorkLocation.size() == 1){                                                  
            branchNameStr = branchAssWorkLocation[0].Branch__r.Name;
        }// End If
        
        if(usrVar.size() == 1){                                                 
            usrSSONumberStr = usrVar[0].SSO_Number__c;
        }// End If
        
        // Populate sso number based on sso number of current user
        taskValue.SSO_Number__c = usrSSONumberStr;
        
        // Populate branch assignment based on assignment of current user
        taskValue.Branch_Assignment__c = branchNameStr;
        
        // Populate date values
        taskValue.Cumulative_Pause_Time__c = parentOpp.Cumulative_Pause_Time__c;
        taskValue.Call_Start_Date_Time__c = parentOpp.Call_Start_Date_Time__c;
        taskValue.Call_End_Date_Time__c = parentOpp.Call_End_Date_Time__c;
        
        // Sync task values based from parent opportunity
        taskValue.Subject = 'Call';
     //   taskValue.Description = parentOpp.Description;
        taskValue.Description = parentOpp.Description__c;
        taskValue.Call_Outcome__c = parentOpp.StageName;
        taskValue.whatID = parentOpp.Id;
        taskValue.CLV_Customer_ID__c = parentOpp.Account.CLV_Customer_ID__c;
        taskValue.X3rd_Party_Task_Source__c = parentOpp.X3rd_Party_Lead_Source__c;  // Added by RCADAPAN for TQLQW-489 and TQLQW-481.
                                                                                    // This will used to bypass a validation rule so task records without CLV Ids can be inserted
                                                                                    // when the lead is from a 3rd party source.
        
        taskValue.Application_Number__c = parentOpp.Application_Number__c;
        taskValue.Outcome_Code__c = parentOpp.Outcome_Code__c;
        taskValue.Marketing_Segment_Code__c = parentOpp.Marketing_Segment_Code__c;
        taskValue.Excluded_Date__c = parentOpp.Excluded_Date__c;
        taskValue.Campaign_Start_Date__c = parentOpp.Campaign.StartDate;
        taskValue.Campaign_End_Date__c = parentOpp.Campaign.EndDate;
        taskValue.Recorded_Branch__c = parentOpp.Branch_Name__c;
        taskValue.Region__c = parentOpp.Region__c;
        
        // set playpagesave sot that workflow will know that update is from code
        taskValue.PlayPageSave__c = true;
        
        if(IsCompleted){
            taskValue.Status = 'Completed';
            taskValue.Ownerid = UserInfo.getUserId();
            taskValue.recordTypeId = taskRecordTypeId('Lead Process');
        }else{
            taskValue.Status = 'Open';
            taskValue.Ownerid = parentOpp.Assigned_to_User__c;
            taskValue.recordTypeId = taskRecordTypeId('Call Back');
        }// End Else
        
        if(taskValue.ReminderDateTime!=null){
            //Extract Due Date's value from Reminder Date
            Datetime dateTimetemp = taskValue.ReminderDateTime;

            Date dateTemp = DateTime.newInstanceGmt(dateTimetemp.date(), dateTimetemp.time()).dateGMT();
            //taskValue.ReminderDateTime = DateTime.newInstanceGmt(taskValue.ReminderDateTime.date(), taskValue.ReminderDateTime.time());
            taskValue.activityDate = dateTemp;
        }// End If
        taskValue.PlayPageSave__c = true;
        taskValue.Call_Type__c = parentOpp.Call_type__c;
                  
        return taskValue;
    }// End Setup Task
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Perform updates to opportunity
    * @param 
    */
    public void setupOpportunity(){
         // Query generic user
         User usrVar = [Select Id from User where Name = 'GE Capital Queue User'];
         this.selectedOpp.InPlay__c = false;

         // Set propensity score to 0 and owner to GE Capital Queue User if the 
         // Stage = (Cancel,Left Message, No Answer, Customer Not Available, Please Contact me letter sent)
         if(this.selectedOpp.StageName == 'Cancel' || 
                this.selectedOpp.StageName  == 'Left Message' || 
                this.selectedOpp.StageName == 'No Answer' || 
                this.selectedOpp.StageName == 'Customer Not Available' || 
                this.selectedOpp.StageName == 'Please Contact me letter sent'){
                        
            // Reset prepensity and reassign to GE Capital Queue User
            this.selectedOpp.Live_Propensity_Score__c = 0;
            this.selectedOpp.OwnerId = usrVar.Id;
            this.selectedOpp.Processed__c = false;
         
         // Reset ownership equal to assigned to user field if stage = 'Set Follow-Up Call'
         }else if(this.selectedOpp.StageName == 'Set Follow-Up Call' && this.selectedOpp.Assigned_to_User__c != null){
            this.selectedOpp.OwnerId = this.selectedOpp.Assigned_to_User__c;
         }// End If
         
         // Reset ownership to generic queue owner if outcome is not Set Follow-Up Call
         if(this.selectedOpp.StageName != 'Set Follow-Up Call'){
            this.selectedOpp.OwnerId = usrVar.Id;
         }// End If

         //Update Opportunity time fields for Lead Timer
         this.selectedOpp.Cumulative_Pause_Time__c = totalPauseTime;
         this.selectedOpp.Call_End_Date_Time__c = system.now();
         this.selectedOpp.PlayPageSave__c = true;
         this.selectedTask.Call_End_Date_Time__c = system.now();
         
         //Set Task Reminder Date time on Opportunity
         if(this.selectedTask.ReminderDateTime!=null) {
             this.selectedOpp.Task_Reminder_Date__c = DateTime.newInstanceGmt(this.selectedTask.ReminderDateTime.date(), this.selectedTask.ReminderDateTime.time());
             
         }
         
         update this.selectedOpp;
         
         // Update Opportunity Values to reflect formula field values
         this.selectedOpp = [SELECT Description__C,Name, Call_Type__c,Description,
                                     StageName, PlayPageSave__c, PRS_Record_Id__c, Processed__c,
                                     Application_Number__c,Assigned_to_User__c,
                                     Call_Start_Date_Time__c, Call_End_Date_Time__c,
                                     Cumulative_Pause_Time__c, Paused__c,
                                     OwnerId,ID, Outcome_Code__c,Pause_Date_Time__c, UnPause_Date_Time__c,
                                     Marketing_Segment_Code__c,Excluded_Date__c,
                                     Campaign.StartDate, Campaign.EndDate,
                                     Account.CLV_Customer_ID__c, Account.Name, Account.PersonTitle, Branch_Name__c,
                                     Account.FirstName, Account.LastName, Account.Date_of_Birth__pc,
                                     Account.PersonMailingPostalCode,Account.PersonMobilePhone,
                                     Time_Out__c, PostCode_Exclusion__c,Campaign.Promotional_Campaign__c, 
                                     Application__c, Region__c,AccountId, Contract_Date__c, 
                                     Account_Number__c, Application_GE_Unique_Id__c, X3rd_Party_Lead_Source__c        // Afreen- Added the lead source for PicStarter - 481                      
                                     FROM   Opportunity
                                     WHERE  Id =: oppId limit 1];

         system.debug('Opportunity Value on Save:' + selectedOpp);
    }// End setupOpportunity
    
    public Decimal incrementCounter(Decimal count) {
        if(count != null) {
             count = count + 1;
         } else {
             count = 1;
         }
        return count;
    }
            
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Method to clear values upon click of pause button and 
                   set pause date time value equal to now then redirect to home.
    * @param 
    */
    
    public PageReference pausePlay(){
 
     try{
        this.selectedOpp.PlayPageSave__c = true;
        // Restore stage to it's previous value, undo reason, description
        this.selectedOpp.StageName = previousStage;
        this.selectedOpp.Pause_Date_Time__c = system.now();
        this.selectedOpp.inPlay__c = false;
        this.selectedOpp.Time_Out__c = null;
        this.selectedOpp.PostCode_Exclusion__c = false;
        this.selectedOpp.Excluded_Date__c = null;
        this.selectedOpp.Paused__c = true;
        
        List<Opportunity> toUpdateOpp = new List<Opportunity>();
        toUpdateOpp.add(this.selectedOpp);
        update toUpdateOpp;
        //update selectedOpp;
        } catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);   
        }
        
        
        //PageReference leadMgmtPage = Page.LeadManagementHome;
        PageReference leadMgmtPage = new PageReference(perspecSysURL + '/apex/LeadManagementHome');
        leadMgmtPage.setRedirect(true);
        return leadMgmtPage;
    }// End pausePlay Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Method to fire on click of save and next button
    * @param 
    */
    public PageReference saveAndNext() {
        // Redirect to next lead if there are no validation errors
        if(updateRecord()) {
            LeadManagementController lmController = new LeadManagementController();
            String idVar = lmController.createLeadQueue();
              
            system.debug('IdVar Value:' + idVar); 
              
            if(idVar==null) {
                //PageReference leadMgmtPage = Page.LeadManagementHome;
                PageReference leadMgmtPage = new PageReference(perspecSysURL + '/apex/LeadManagementHome');
                leadMgmtPage.setRedirect(true);
                return leadMgmtPage;
            } else {
                //PageReference ref = Page.GEPlayPage2;   
                PageReference ref = new PageReference(perspecSysURL + '/apex/GEPlayPage2');
                ref.getParameters().put('oppid', idVar);  
                ref.setRedirect(true);
                return ref;
            }// End Else
            
        } else {
            return null;
        }// End If
    }// End saveAndNext Method
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Method to fire on click of save and close button 
    * @param 
    */
    public PageReference saveAndClose() {
        // Redirect to home page if there are no validation errors
        if(updateRecord()) {
            PageReference leadMgmtPage = new PageReference(perspecSysURL + '/apex/LeadManagementHome');
            leadMgmtPage.setRedirect(true);
            
            //BEGIN MLASALA 11-AUG-2016 Added condition to not redirect when agent is using softphone
            if(isCallCenter){
                return null;
            } else {
                return leadMgmtPage;
            }
            //END MLASALA 11-AUG-2016
            
        } else {
            return null;
        }// End If
    }// End saveAndClose Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Method for save event in GE Play Page - Read Only
    * @param
    * @last modified by Michael Lasala Cloud Sherpas    28 Feb 2013     Added validation for Reminder Date > 90 days 
    */    
    public PageReference readOnlySave(){
        
        system.debug('Read Only Save Stage:' + this.selectedOpp.StageName);
               
        system.debug('Task Value before insert:' + readOnlyTask);
            
        // Create Task
        if(readOnlyTask.ReminderDateTime>=Date.Today().addDays(90)){
           // Check if Reminder Date Time is greater than 90 days from today's date, if true, throw an error
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Reminder date should not be set more than the 3 months from the current date');
           ApexPages.addMessage(myMsg);
           return null;
        } else if(readOnlyTask.ReminderDateTime!=null){
           // Use describe to get Call Back recordtype for task object
           Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Task;
           Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
           
           // Close all open task before creating a new open task 
           closeTask();
             
           // Set task values  
           insert defaultTaskValue(readOnlyTask,this.selectedOpp,false);
        }// End If
            
        // Save opportunity
        this.selectedOpp.PlayPageSave__c = true;
        List<Opportunity> toUpdateOpp = new List<Opportunity>();
        toUpdateOpp.add(this.selectedOpp);
        update toUpdateOpp;
        
        //update selectedOpp;
        system.debug('Read Only Opportunity:' + selectedOpp);
        
        // Redirect to Lead Management Home Page
        //PageReference leadMgmtPage = Page.LeadManagementHome;
        PageReference leadMgmtPage = new PageReference(perspecSysURL + '/apex/LeadManagementHome');
        leadMgmtPage.setRedirect(true);
        return leadMgmtPage;
    }// End saveReadOnly Method
    
    //vadalidates if the page should be redirected to readOnly
    public PageReference validateReadOnly() {
    
        //Variable Declaration
        string oppId = ApexPages.currentPage().getParameters().get('oppid');
        
        if(oppId == null || oppId == ''){
            PageReference pr = new PageReference(perspecSysURL + '/apex/GEPlayPage2Error');
            pr.setRedirect(true);
            return pr;
        }

        string isRedirected = ApexPages.currentPage().getParameters().get('redirected');
        
        Id currentUserId = UserInfo.getUserId();
        User u = [SELECT Id FROM User WHERE Name = 'GE Capital Queue User'];
        Id queueUserId = u.Id;
        
        //initialize the opportunity being viewed
        initialList = [Select OwnerId, 
                              Id, 
                              InPlay__c, 
                              Assigned_to_User__c, 
                              Call_Start_Date_Time__c,
                              UnPause_Date_Time__c, 
                              Pause_Date_Time__c, 
                              Cumulative_Pause_Time__c, 
                              Campaign.IsActive,
                              stageName,
                              Campaign.Status,
                              Call_End_Date_Time__c,
                              PlayPageSave__c,
                              Paused__c
                       from   Opportunity 
                       where  Id = :oppId limit 1];    
        
        //ensure the user has access to the record, do nothing if page is previously redirected. no need to check.
        if(initialList.size() == 1 && isRedirected != '1') {
            
            //set to read-only depending on conditions
            if((initialList[0].Campaign.IsActive == false) || (currentUserId != initialList[0].OwnerID && initialList[0].InPlay__c == TRUE) ) {
                PageReference pr = new PageReference(perspecSysURL + '/apex/GEPlayPage2ReadOnly');
                pr.getParameters().put('oppid', oppId);  
                pr.getParameters().put('redirected', '1'); 
                pr.setRedirect(true);
                return pr;
            } 

        }//End if
        return null;
    }
    
    //new initOpp modified by Dan 2/26
    public void initOpp(){

        string isUrl;

        Id currentUserId = UserInfo.getUserId();
        User u = [SELECT Id FROM User WHERE Name = 'GE Capital Queue User'];
        Id queueUserId = u.Id;

        if(initialList.size() > 0){
            //set to isUrl depending on conditions
            if(initialList[0].InPlay__c == false && queueUserId == initialList[0].OwnerId && (initialList[0].StageName =='Set Follow-Up Call' || initialList[0].Campaign.Status == 'In Progress')) {
                isUrl = 'true';
            }        
            
            //Call updateLeadTimer method
            updateLeadTimer(initialList);
            if(isUrl == 'true'){
                if(initialList.size()>0){
                //Set Opportunity owner to current user and In Play to true
                    initialList[0].Inplay__c = true;
                    initialList[0].OwnerId = UserInfo.getUserId();
                    initialList[0].PlayPageSave__c = true;
                    if(initialList[0].Assigned_to_User__c == null)
                        initialList[0].Assigned_to_User__c = UserInfo.getUserId();
                }// End If
            } else {
                initialList[0].PlayPageSave__c = true;
                //Set Assigned to User field
                if(initialList[0].Assigned_to_User__c == null)
                    initialList[0].Assigned_to_User__c = UserInfo.getUserId();
            }//End else
            initialList[0].paused__c = false;
    
            update initialList;
        }
    }//End initOpp()
    
    //update leadTimer 
    public void updateLeadTimer(List<Opportunity> opp){

        if(opp[0].OwnerId == UserInfo.getUserId() && opp[0].Pause_Date_Time__c != null){
        //Unpause lead timer
            opp[0].UnPause_Date_Time__c = system.now();
            opp[0].InPlay__c = true;
            opp[0].Paused__c = false;
            long unPause = system.now().getTime() / 1000;
            long Pause = opp[0].Pause_Date_Time__c.getTime() / 1000;
            double totalPause = unPause - Pause;
            if(opp[0].Cumulative_Pause_Time__c == null){
            //Set pause time
                opp[0].Cumulative_Pause_Time__c = totalPause;
                totalPauseTime = totalPause;
            } else {
            //Set pause time + previous total pause time
                double cumulativePause = opp[0].Cumulative_Pause_Time__c;
                totalPauseTime = cumulativePause + totalPause;
            }//End else
            
            //Clear Pause & Unpause time
            opp[0].UnPause_Date_Time__c = null;
            opp[0].Pause_Date_Time__c = null;
            
        } else {
        //Start lead timer
            opp[0].Call_Start_Date_Time__c = system.now();
            startTime = system.now();
        }//End else
        
    }//End updateLeadTimer()

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 March 2015
    * @description Error message creator method
    */
    public void appCreateError(){
      appSixtyDayCertMsg = ApexPages.currentPage().getParameters().get('appSixtyDayCertMsg');
      appCreateErrMsg = ApexPages.currentPage().getParameters().get('appCreateErrMsg');
      if(appSixtyDayCertMsg!=null&&appSixtyDayCertMsg!=''){
        ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, appSixtyDayCertMsg);
          ApexPages.addMessage(myMsg);  
      }else if(appCreateErrMsg!=null&&appCreateErrMsg!=''){
        ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, appCreateErrMsg);
          ApexPages.addMessage(myMsg);   
      }
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 March 2015
    * @description Info message creator method
    */
    public void appSetupMsg(){
      appSetupSuccMsg = ApexPages.currentPage().getParameters().get('appSetupSuccMsg');
      if(appSetupSuccMsg!=null&&appSetupSuccMsg!=''){
        ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.INFO, appSetupSuccMsg);
          ApexPages.addMessage(myMsg);   
      }
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 March 2015
    * @description Remote action method to create application based on sixtydayscert process
    */
    @RemoteAction
    global static SixtyDaysCertService.sixtyDayCertResponse campaignProcess(Id recordId){
      SixtyDaysCertService sdcClass = new SixtyDaysCertService();
      SixtyDaysCertService.sixtyDayCertResponse appResponse = sdcClass.createApplication(recordId);
      system.debug('60DayCertAppId:' + appResponse.appId);
      system.debug('60DayCertAppCreationMsg:' + appResponse.response);
      return appResponse;
    }
    
    public Date origContractDate{get; set;}
    public String origAppNumber{get; set;}
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 March 2015
    * @description Method to refresh application
    */
    public pageReference icbsInfoRefresh(){
      List<Opportunity> oppVar = [Select Id,Contract_Date__c,Account_Number__c
                       from Opportunity where Id=:selectedOpp.Id];
      
      if(oppVar.size()==1){
        selectedOpp.Contract_Date__c = oppVar[0].Contract_Date__c;
        selectedOpp.Account_Number__c = oppVar[0].Account_Number__c;
        origContractDate = selectedOpp.Contract_Date__c;
        origAppNumber = selectedOpp.Account_Number__c;
      }
      return null;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 26 March 2015
    * @description Method to revert ICBS Info Fields to its original value
    */
    public void checkOrigICBS(){
      //if(selectedOpp.override_ICBS_Billing__c==false){
        selectedOpp.Account_Number__c = origAppNumber;
        selectedOpp.Contract_Date__c = origContractDate;
      //}
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 2 May 2015
    * @description Method to refresh opportunity before application create 
    */
    public pageReference opportunityRefresh(){
      List<Opportunity> oppVar = new List<Opportunity>(); 
      oppVar=[Select Id,Contract_Date__c,Account_Number__c,
               Campaign.Promotional_Campaign__c,Application__c 
               from Opportunity where Id=:selectedOpp.Id];
      
      if(oppVar.size()==1){
        // Sync connected application and campaign to the current opportunity instance
        selectedOpp.Application__c = oppVar[0].Application__c;
        selectedOpp.Campaign.Promotional_Campaign__c = oppVar[0].Campaign.Promotional_Campaign__c;
        
        // Commit Application Number, Contract Date, and override billing icbs value
        // so that remote action to calculate ICBS Account number will see it
        Opportunity oppUpdateVar = new Opportunity();
        oppUpdateVar.Id = selectedOpp.Id;
        oppUpdateVar.Account_Number__c = selectedOpp.Account_Number__c;
        oppUpdateVar.Contract_Date__c = selectedOpp.Contract_Date__c;
        oppUpdateVar.override_ICBS_Billing__c = selectedOpp.override_ICBS_Billing__c;
        update oppUpdateVar;
      }

      return null;
    }
    
  
     /*
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 27 Feb 2013
    * @description Method to update application and link 
                   opportunity to creaated sixty day cert application.
    */
    public void refreshAndLinkOpportunityToApp(){
      system.debug('sixtyDayAppId:' + sixtyDayAppId);
      sixtyDayAppId = ApexPages.currentPage().getParameters().get('sixtyDayAppId');
      system.debug('after URL GET:' + sixtyDayAppId);
      if(sixtyDayAppId!=null){
        selectedOpp.Application__c = sixtyDayAppId;
        Opportunity oppUpdateVar = new Opportunity();
        oppUpdateVar.Id = selectedOpp.Id;
        oppUpdateVar.Application__c = sixtyDayAppId;
        update oppUpdateVar;
        selectedOpp.Application__c = sixtyDayAppId;
      }
    }

   /*
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 06 June 2015
    * @description Method to update application and link 
                   opportunity to creaated sixty day cert application.
    */
    public void refreshGEUniqueId(){
        List<Opportunity> oppVar = new List<Opportunity>(); 
        oppVar=[Select Application_GE_Unique_Id__c from Opportunity where Id=:selectedOpp.Id limit 1];
        if(oppVar.size()>0){
            geUniqueId = oppVar[0].Application_GE_Unique_Id__c;
        }
    }
    
    /*  Description: Retrieve genesys data required for softphone
     *  Author: Mike Lasala
     *  Date Created: 18-AUG-2016
     *  Input: None
		Return: Void
     */
    public void getGenesysData(){
        
        //Retrieve opp
        Opportunity opp = [SELECT Id, Genesys_Outcome_Code__c FROM Opportunity WHERE Id =: selectedOpp.Id LIMIT 1];
        
        if(opp != null){
            
            //Assign selected stage to opp
            opp.StageName = selectedOpp.StageName;
            
            //Recalcualte formula fields for the record
            opp.recalculateFormulas();
            
            //Assign value to be used for dialer method
            genesysOutcome = opp.Genesys_Outcome_Code__c;
        }
        
        if(selectedOpp.Assigned_to_User__c != null){
            //Retrieve assigned user SSO
            User assignedUser = [SELECT SSO_Number__c FROM User WHERE Id =: selectedOpp.Assigned_to_User__c LIMIT 1];
            
            if(assignedUser != null){
                assignedUserSSO = assignedUser.SSO_Number__c;
            }
        }
    }
}