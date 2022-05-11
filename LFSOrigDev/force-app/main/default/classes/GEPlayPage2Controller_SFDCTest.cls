public without sharing class GEPlayPage2Controller_SFDCTest{
    public Opportunity selectedOpp {get; set;}
    public GEPlayPage2Controller_SFDCTest() {

        // Varaible Declaration for Editable and Read only Page
        String oppId = ApexPages.currentPage().getParameters().get('oppid');

        for(Opportunity opp: [SELECT Name, Call_Type__c,Description,
                                     StageName, PlayPageSave__c,
                                     Application_Number__c,Assigned_to_User__c,
                                     Call_Start_Date_Time__c, Call_End_Date_Time__c,
                                     Cumulative_Pause_Time__c,
                                     OwnerId,ID, Outcome_Code__c,Pause_Date_Time__c,
                                     Marketing_Segment_Code__c,Excluded_Date__c,
                                     Campaign.StartDate, Campaign.EndDate,
                                     Account.CLV_Customer_ID__c, Account.Name, Branch_Name__c,
                                     Time_Out__c, PostCode_Exclusion__c
                                     FROM   Opportunity
                                     WHERE  Id =: oppId limit 1]) {    
            
            // Set Default Values for Opportunity
            this.selectedOpp = opp;
 
           this.selectedOpp.StageName = '';
           this.selectedOpp.Call_Type__c = 'Outbound Call';
           
           // Empty Description if opportunity is not paused
           if(this.selectedOpp.Pause_Date_Time__c == null){
             this.selectedOpp.Description = '';
           }// End If
            
            // Default values for both pages
            selectedOpp.Assigned_to_User__c = UserInfo.getUserId();
        }// End For   
    }// End Constractor Method
    
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
            options.add(new SelectOption('Do Not Solicit','Do Not Solicit'));
            options.add(new SelectOption('Not Interested','Not Interested'));
            options.add(new SelectOption('Set Follow-Up Call','Set Follow-Up Call'));
        
        // Stages if Call Type is Outbound Call
        } else if(this.selectedOpp.Call_Type__c=='Outbound Call') {
            options.add(new SelectOption('Application Taken','Application Taken'));
            options.add(new SelectOption('Customer Not Available','Customer Not Available'));
            options.add(new SelectOption('Disconnected','Disconnected'));
            options.add(new SelectOption('Do Not Solicit','Do Not Solicit'));
            options.add(new SelectOption('Left Message','Left Message'));
            options.add(new SelectOption('Not Interested','Not Interested'));
            options.add(new SelectOption('No Answer','No Answer'));
            options.add(new SelectOption('Set Follow-Up Call','Set Follow-Up Call'));
            options.add(new SelectOption('Unsuitable Lead','Unsuitable Lead'));
            options.add(new SelectOption('Wrong Number','Wrong Number'));
        
        // If Call Type is null set to None
        } else {
            options.add(new SelectOption('None','No call type selected',true)); 
        }// End Else
        return options; 
    }// End getStages Method 
    
}