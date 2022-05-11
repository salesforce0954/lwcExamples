/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Class to handle LeadManagementHome Page logic
* @last modified by: Michael Lasala     02/20/13    Added error message for Working Location
* @last modified by: Adrian Recio    02/26/13    Added logic for Exclusion Reason
*/

public without sharing class LeadManagementController {

    // Variable Declaration
    public string userNameStr {get; set;}
    public Boolean leadMissing{get; set;}
    public List<Opportunity> leadQueueList{get; set;}
    public string errorMessage{get; set;}
    public static Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Branch_Assignment__c;
    public static Map<String,Schema.RecordTypeInfo> BranchAssignmentRecordType = cfrSchema.getRecordTypeInfosByName();
    public static Id branchRecordTypeId = BranchAssignmentRecordType.get('Branch Leads').getRecordTypeId();
    public static Id locationRecordTypeId = BranchAssignmentRecordType.get('Working Location').getRecordTypeId();
    public String perspecSysURL {get; set;}
    
    //Added by MLASALA 11-AUG-2016
    //Boolean to identify whether the user is associated with a call center
    public Boolean isCallCenter {get; set;}

    //Added By Afreen - 481 PicStarter
    private List<CallBack_Option_Setting__c> callbackSettings;
    private String currentCallBackPeriod;
    private Integer currentWindowStartTime;
    private Integer currentWindowEndTime;
    
    //Added by RCADAPAN - 489 VedaQuote
    private Integer vedaQuoteTimeWindow;
    
    //DEBUG setting retrieval, Steven Herod
    Debug_Settings__c debug = Debug_Settings__c.getInstance('Production');
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Constractor Class
    * @param 
    */
    public LeadManagementController(){
        // Initialize Variables
        this.perspecSysURL = timeout__c.getOrgDefaults().Perspecsys_URL__c;
        if(this.perspecSysURL == null) {
            this.perspecSysURL = '';
        }
        leadMissing = false;
        userNameStr = userInfo.getName(); 
        String err = ApexPages.currentPage().getParameters().get('errorCode');
        if(err=='3'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Valid Working Location.'));
        }
        if(err=='4'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The lead you were trying to access is no longer valid for Play Page editing. You may click on play button again to search for a new lead.'));
        }
        
        //BEGIN MLASALA 11-AUG-2016
        isCallCenter = false;
        
        //Retrieve user call center
        User loggedUser = [SELECT CallCenterId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        
        //If call center exists, set boolean to true
        if(loggedUser != null && 
           loggedUser.CallCenterId != null){
            
            isCallCenter = true;   
        }
        System.debug('$$$ isCallCenter: '+isCallCenter);
        //END MLASALA 11-AUG-2016
        //Added by Afreen - 481 PicStarter
        callbackSettings = [Select Id, Name, Start_Time__c, End_Time__c From CallBack_Option_Setting__c];
        currentCallBackPeriod ='';
        
        //Added by RCADAPAN - TQLQW-489 Veda Quote
        vedaQuoteTimeWindow = 0;
        
    }// End Constractor Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to retrieve Campaign Setting records for the current pfr.
    * @param 
    */   
    public Set<Id> campaignSettings(){
        Set<Id> campaignIdSet = new Set<Id>();
        // Campaign should be In-Progress and Active
        List<Campaign_Assignment__c> caList = [Select Id, 
                                               Campaign__c from 
                                               Campaign_Assignment__c where 
                                               User__c = :Userinfo.getUserId() and 
                                               Campaign__r.Status = 'In Progress' and 
                                               Campaign__r.IsActive = true];
                                               
        for(Campaign_Assignment__c caVar:caList){
            campaignIdSet.add(caVar.Campaign__c);
        }// End For
        return campaignIdSet;
    }// End campaignSettings Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to retrieve Branch Setting records for the current pfr.
    * @param 
    */   
    public Set<String> branchSettings(){
        Set<String> branchNameSet = new Set<String>();
        List<Branch_Assignment__c> baList = [Select Id, Branch__r.Name from Branch_Assignment__c where User__c = :Userinfo.getUserId() and Recordtype.Name = 'Branch Leads']; 
        for(Branch_Assignment__c baVar:baList){
            branchNameSet.add(baVar.Branch__r.Name);
        }// End For
        return branchNameSet;
    }// End branchSettings Method
    
    /*
    Author: Michael Lasala Cloud Sherpas
    Created Date: 2/26/13
    Description: Retreive Branch records with Working Location Record Type for current PFR
    */
       
    public Set<String> locationSettings(){
        Set<String> locationNameSet = new Set<String>();
        List<Branch_Assignment__c> baList = [SELECT Id, Branch__r.Name FROM Branch_Assignment__c WHERE User__c = :Userinfo.getUserId() AND RecordTypeId =: locationRecordTypeId]; 
        for(Branch_Assignment__c baVar:baList){
            locationNameSet.add(baVar.Branch__r.Name);
        }// End For
        return locationNameSet;
    }// End locationSettings Method
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Main method to perform lead allocations. Redirects to the allocation lead record.
    * @param 
    */
    public pageReference allocateLeads(){
            String idVar = createLeadQueue();
            leadMissing = false;
            if(idVar!=null){
                //return new PageReference('/apex/GEPlayPage2?oppid=' + idVar);
                //MLASALA 16-AUG-2016 Added isDialer parameter to identify whether BAU process should flow
                return new PageReference(perspecSysURL + '/apex/GEPlayPage2?oppid='+idVar+'&isDialer=false');
            }// End If
            
            leadMissing = true;
            return null;
    }// End allocateLeads Method
           
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 05 Feb 2013
    * @description Method to create lead queue.
    * @param 
    */
    public Id createLeadQueue(){
     
        // Variable Declaration
        set<Id> campaignIdSet = campaignSettings();
        set<String> branchNameSet = branchSettings();
        set<String> locationNameSet = locationSettings();
        Boolean IsCurrent = false;
        errorMessage = '';
        
        // If there are no campaign selected for the current pfr, populate error message.
        if(campaignIdSet.size() == 0){
            errorMessage = 'No Valid Campaign.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
            return null;
        }// End If
        
        // If there are no branch selected for the current pfr, populate error message.
        if(branchNameSet.size() == 0){
            errorMessage = 'No Valid Branch.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
            return null;
        }// End If
        
         // If there is no Branch with Record Type = Working Location selected for the current PFR, populate error message.
        if(locationNameSet.size() == 0){
            errorMessage = 'No Valid Working Location.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
            return null;
        }// End If
        
        // Check if pfr has a lead in play
        leadQueueList = [Select Id, AccountId, Name, StageName , Live_Propensity_Score__c, Propensity_Score__c, 
                         InPlay__c, LastModifiedDate, Time_Out__c, PostCode_Exclusion__c, Mail_Code__c, PlayPageSave__c from Opportunity where 
                         Branch_Name__c In :branchNameSet 
                         and CampaignId In :campaignIdSet 
                         and ((InPlay__c = true and paused__c = false) or (InPlay__c = false and paused__c = true))
                         and LastModifiedById = :UserInfo.getUserId()
                         and (Time_Out__c < :Date.today() or Time_Out__c = null)
                         and StageName In ('New', 'Customer Not Available', 'No Answer','Cancel','Left Message')
                         and PostCode_Exclusion__c = false
                         and Mail_Code__c != 'MO'
                         and Mail_Code__c != 'CO'
                         and Overcalled_under_7_Days__c = 'FALSE'
                         and Overcalled_under_30_Days__c = 'FALSE'
                         and Excluded_Date__c = null
                         limit 1 FOR UPDATE];
        
         if (debug.debug__c) {             
         
             List<Opportunity> debugQueue = [Select Id, AccountId, Name, StageName , Live_Propensity_Score__c, Propensity_Score__c, 
                         InPlay__c, LastModifiedDate, Time_Out__c, PostCode_Exclusion__c, Mail_Code__c, PlayPageSave__c from Opportunity where 
                         Branch_Name__c In :branchNameSet 
                         and CampaignId In :campaignIdSet 
                         and ((InPlay__c = true and paused__c = false) or (InPlay__c = false and paused__c = true))
                         and LastModifiedById = :UserInfo.getUserId()
                         and (Time_Out__c < :Date.today() or Time_Out__c = null)
                         and StageName In ('New', 'Customer Not Available', 'No Answer','Cancel','Left Message')
                         and PostCode_Exclusion__c = false
                         and Mail_Code__c != 'MO'
                         and Mail_Code__c != 'CO'
                         and Overcalled_under_7_Days__c = 'FALSE'
                         and Overcalled_under_30_Days__c = 'FALSE'
                         and Excluded_Date__c = null limit 100];
         
              writeDebug('Searched for In Play already', leadQueueList, debugQueue, branchNameSet, campaignIdSet);
         }
        
        // Pre Conditions for Lead Queue:
        // Filter by PFR Settings for Branch
        // Filter by PFR Settings for Campaign
        // Inplay is False
        // Outcome(Stage) is equal to New, Customer Not Available,No Answer, Cancel, Left Message
        // Time Out Date < TODAY or Time Out Date = null
        // Sort by Propensity Score (Highest as Priority)
        // Sort by LastModifiedDate (Least current as Priority)
        // PostCode Exclusion is false
        // Mail Code not equal to 'MO'
        // Mail Code not equal to 'CO'
        // Overcalled_under_7_Days__c is false
        // Overcalled_under_30_Days__c is false
        // Owner is Generic Queue Owner - Not yet present
        // Excluded Date is null
        
        system.debug('In Play Lead Size:' + leadQueueList.size());
        if(leadQueueList.size() == 0){
            // Added By Afreen - 481 PicStarter

            currentCallBackPeriod = getCurrentCallBackPeriod();
            
            // Added by Russell Cadapan  - TQLQW-489 - Veda Quote
            vedaQuoteTimeWindow = getVedaTimeWindow();
            
            leadQueueList = [Select Id, AccountId, Name, StageName , Live_Propensity_Score__c, Propensity_Score__c, 
                             InPlay__c, LastModifiedDate, Time_Out__c, PostCode_Exclusion__c, Mail_Code__c, PlayPageSave__c from Opportunity where 
                             Branch_Name__c In :branchNameSet 
                             and CampaignId In :campaignIdSet 
                             and InPlay__c = false
                             and (Time_Out__c < :Date.today() or Time_Out__c = null)
                             and StageName In ('New', 'Customer Not Available', 'No Answer','Cancel', 'Left Message')
                             and PostCode_Exclusion__c = false
                             and Mail_Code__c != 'MO'
                             and Mail_Code__c != 'CO'
                             and Overcalled_under_7_Days__c = 'FALSE'
                             and Overcalled_under_30_Days__c = 'FALSE'
                             and Excluded_Date__c = null
                             and Processed__c = false
                             and ((X3rd_Party_Lead_Source__c !=: GEN_OriginationsConstants.MIRROR_PICSTARTER and  CallBack_Time__c = null ) 
                                  OR (X3rd_Party_Lead_Source__c =: GEN_OriginationsConstants.MIRROR_PICSTARTER and X3rd_Party_Lead_Status__c = 'Incomplete' and CallBack_Time__c = null)
                                  OR (X3rd_Party_Lead_Source__c =: GEN_OriginationsConstants.MIRROR_PICSTARTER and X3rd_Party_Lead_Status__c = 'Complete' 
                                      and CallBack_Time__c = :currentCallBackPeriod 
                                      and ((HOUR_IN_DAY(convertTimezone(CreatedDate)) >= :currentWindowStartTime 
                                            and HOUR_IN_DAY(convertTimezone(CreatedDate)) < :currentWindowEndTime and CreatedDate != TODAY) 
                                           OR (HOUR_IN_DAY(convertTimezone(CreatedDate)) < :currentWindowStartTime 
                                               OR HOUR_IN_DAY(convertTimezone(CreatedDate)) >= :currentWindowEndTime))))
                             and (X3rd_Party_Lead_Source__c !=: GEN_OriginationsConstants.MIRROR_VEDA_QUOTE OR (X3rd_Party_Lead_Source__c =: GEN_OriginationsConstants.MIRROR_VEDA_QUOTE AND CreatedDate <: System.now().addHours(vedaQuoteTimeWindow)))    // Added by Russell Cadapan to fetch Veda Quote leads x hours after they are created.
                             order by Live_Propensity_Score__c DESC, CallBack_Time_Code__c Asc, LastModifiedDate ASC, CreatedDate Asc limit 1];                                             // Afreen - 485, Added Condition for sorting for Picstarter and 
                                                                                                                                                                                            //added  and CallBack_Time__c = :currentCallBackPeriod  in where clause and CallBack_Time__c = :currentCallBackPeriod  in where clause
            
              if (debug.debug__c) {                 
              
                   List<Opportunity> debugList = [Select Id, AccountId, Name, StageName , Live_Propensity_Score__c, Propensity_Score__c, 
                                             InPlay__c, LastModifiedDate, Time_Out__c, PostCode_Exclusion__c, Mail_Code__c, PlayPageSave__c from Opportunity where 
                                             Branch_Name__c In :branchNameSet 
                                             and CampaignId In :campaignIdSet 
                                             and InPlay__c = false
                                             and (Time_Out__c < :Date.today() or Time_Out__c = null)
                                             and StageName In ('New', 'Customer Not Available', 'No Answer','Cancel', 'Left Message')
                                             and PostCode_Exclusion__c = false
                                             and Mail_Code__c != 'MO'
                                             and Mail_Code__c != 'CO'
                                             and Overcalled_under_7_Days__c = 'FALSE'
                                             and Overcalled_under_30_Days__c = 'FALSE'
                                             and Excluded_Date__c = null
                                             and Processed__c = false
                                             and (CallBack_Time__c = :currentCallBackPeriod OR CallBack_Time__c = null)
                                             and (X3rd_Party_Lead_Source__c !=: GEN_OriginationsConstants.MIRROR_VEDA_QUOTE OR (X3rd_Party_Lead_Source__c =: GEN_OriginationsConstants.MIRROR_VEDA_QUOTE AND CreatedDate <: System.now().addHours(vedaQuoteTimeWindow))) // Added by Russell Cadapan to fetch Veda Quote leads x hours after they are created.
                                         order by Live_Propensity_Score__c DESC, CallBack_Time_Code__c Asc, LastModifiedDate ASC, CreatedDate ASC limit 100];                                           // Afreen - 485, Added Condition for sorting for Picstarter and 
                                                                                                                                                                                                         //added  and CallBack_Time__c = :currentCallBackPeriod  in where clause and CallBack_Time__c = :currentCallBackPeriod  in where clause
                     writeDebug('Searched queue',leadQueueList,debugList, branchNameSet, campaignIdSet);
              }                 
        }else{
            IsCurrent = true;
        }
                        
        system.debug('Count:' + leadQueueList.size());
        
        // If there are no leads, populate error message.
        if(leadQueueList.size() == 0){
            errorMessage = 'No Valid Leads.';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
            return null;
        }// End If
        
        if(leadQueueList.size()!=0 && IsCurrent == false){    
            Opportunity allocatedLead = [Select Id, InPlay__c, LastModifiedDate, PlayPageSave__c, Processed__c from Opportunity where Id = :leadQueueList[0].Id  LIMIT 1 FOR UPDATE];
            system.debug('Locked Lead LastModifiedDate:' + allocatedLead.LastModifiedDate);
            system.debug('Queue Lead LastModifiedDate:' + leadQueueList[0].LastModifiedDate);
         
            if(allocatedLead.InPlay__c == true || (allocatedLead.LastModifiedDate != leadQueueList[0].LastModifiedDate)){
                system.debug('Allocation Failed:' + allocatedLead.Id);
                errorMessage = 'Someone has already claimed your new lead. Please retry.';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
                ApexPages.addMessage(myMsg);
                return null;
            }else{
                allocatedLead.Call_Type__c = 'Outbound Call';
                allocatedLead.InPlay__c = true;
                allocatedLead.OwnerId = UserInfo.getUserId();
                allocatedLead.Processed__c = true;
                allocatedLead.PlayPageSave__c = true;
                update allocatedLead;
                return allocatedLead.Id;
            }// End Else
        }else if(leadQueueList.size()!=0 && IsCurrent == true){
                Opportunity allocatedLead = leadQueueList[0];
                allocatedLead.Call_Type__c = 'Outbound Call';
                allocatedLead.InPlay__c = true;
                allocatedLead.OwnerId = UserInfo.getUserId();
                allocatedLead.PlayPageSave__c = true;
                update allocatedLead;
                return allocatedLead.Id;
        }// End Else
        
        return null;
    }// End createLeadQueue Method
    
    private void writeDebug(String comment, List<Opportunity> foundOpp, List<Opportunity> debugQueue,Set<String> branchNameSet, Set<Id> campaignIdSet) {
         
         String foundObject = 'Found object was null';
         String debugList = 'Found list was null';   
         String branchSet = 'None';
         String campaignSet = 'None';
                
                if (foundOpp != null) {
                    foundObject = JSON.serialize(foundOpp); 
                     if (foundObject.length() > 32000) {
                         foundObject = foundObject.subString(0,32000);
                     }               
                }
                
                if (debugQueue != null) {
                     debugList = JSON.serialize(debugQueue); 
                     if (debugList.length() > 32000) {
                         debugList = debugList.subString(0,32000);
                     }
                } 
                   
                if (branchNameSet != null) {
                     branchSet = JSON.serialize(branchNameSet); 
                     if (branchSet.length() > 32000) {
                         branchSet = debugList.subString(0,32000);
                     }
                } 
                
                
                if (campaignIdSet != null) {
                     campaignSet = JSON.serialize(campaignIdSet); 
                     if (campaignSet.length() > 32000) {
                         campaignSet = campaignSet.subString(0,32000);
                     }
                }    
                   
                   
                Debug_Log__c debug = new Debug_Log__c(comment__c = comment, user__c = UserInfo.getUserId(), Found_Object__c = foundObject, Found_Size__c  = debugQueue.size(), Found_List__c = debugList, Branch_List__c = branchSet, Campaign_List__c = campaignSet);
                //insert debug;
    }
    
    /**
    * @author: Afreen Khan
    * @date : Sept 2, 2016
    * @description Method to identify the current callback period
    * @param 
    */

    private String getCurrentCallBackPeriod(){
        Integer currenthour  = getCurrentHour();
        for(CallBack_Option_Setting__c cbo : callbackSettings){
            if(currenthour >= cbo.Start_Time__c  && currenthour < cbo.End_Time__c ){
                currentWindowStartTime = Integer.valueOf(cbo.Start_Time__c);
                currentWindowEndTime   = Integer.valueOf(cbo.End_Time__c);
                return cbo.Name;
            }
        }
        return null;    
    }
    
    /**
    * @author: Russell Cadapan
    * @date : 05-SEP-2016
    * @description Method to retrieve time window for Veda Quote leads to be picked up - TQLQW-489
    * @param 
    */
    private Integer getVedaTimeWindow(){
        return Integer.valueOf(Admin_Settings__c.getValues(GEN_OriginationsConstants.ADMIN_SETTING_VEDA_WINDOW).Value__c) * -1;
    }
    /**
    * @author: Afreen Khan
    * @date : Sept 2, 2016
    * @description Method to identify the current hour
    * @param 
    */
    
    private Integer getCurrentHour(){
        Datetime currentDateTime = DateTime.now();
        return currentDateTime.hour(); // returns current hour based on user's timezone and on 24 hours format
    }

    
}// End LeadManagementControll Class