/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Class to handle CampaignSetup Page
* @last modified by: Michael Lasala     3 Mar 2013      Added variable declaration of Campaign RecordType Id
* @last modified by: Campbell McKay    14 Oct 2014      Revised Campaign Record Type selection to capture 2 RT's.
*                                                       Changed class to 'with sharing'
*/

public with sharing class CampaignSetupController {

    // Variable Declaration
    public List<CampaignWrapper>CampaignWrapperList {get; set;}
    
    //Removed as query will now retrieve two campaign record type id's.
    //public static Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Campaign;
    //public static Map<String,Schema.RecordTypeInfo> CampaignRecordType = cfrSchema.getRecordTypeInfosByName();
    //public static Id CampaignRecordTypeId = CampaignRecordType.get('Lead Process').getRecordTypeId();
    public Boolean isSelectAll{get; set;}
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description 
    * @param 
    */
    public class CampaignWrapper{
        Public Boolean IsSelected{get; set;}
        Public Campaign campaignVar{get; set;}
    }
        
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description
    * @last modified by: Michael Lasala     3 Mar 2013      Added filter on campainList to query only Campaigns with Record Type = Leads Process 
    * @param 
    */
    public CampaignSetupController(){      
        // Query Campaign
        //List<Campaign> campaignList = [Select Id, Name from Campaign where IsActive = true and RecordTypeId =: CampaignRecordTypeId];
        List<Campaign> campaignList = [SELECT Id, Name FROM Campaign WHERE IsActive = true 
                                        AND RecordTypeId IN (SELECT Id FROM RecordType WHERE SobjectType='Campaign' 
                                                AND DeveloperName IN('Lead_Process', 'NZ_Lead_Process') AND IsActive = TRUE) ORDER BY Name ASC];
        
        
        // Put Campaign Assignment record ids in a map
        Set<Id>campaignIdSet = new Set<Id>();
        Map<Id,Campaign_Assignment__c> caMap = new Map<Id,Campaign_Assignment__c>();
        
        for(Campaign campaignVar: campaignList){
            campaignIdSet.add(campaignVar.Id);
        }
        
        List<Campaign_Assignment__c> caList = [Select Id, Campaign__r.Status,Campaign__c from Campaign_Assignment__c where Campaign__c In :campaignIdSet and User__c = :Userinfo.getUserId() AND Campaign__r.IsActive = true];
        
        for(Campaign_Assignment__c caVar: caList){
            caMap.put(caVar.Campaign__c,caVar);
        }
        
        campaignWrapperList = new List<CampaignWrapper>();
        isSelectAll = true;
        for(Campaign campaignVar:campaignList){
            CampaignWrapper cwVar = new CampaignWrapper();
            cwVar.IsSelected = false;
            if(caMap.get(campaignVar.Id)!=null){
                cwVar.IsSelected = true;
            }
            if(cwVar.IsSelected == false || cwVar.IsSelected == null) {
                isSelectAll = false;
            }
            cwVar.campaignVar = campaignVar;
            campaignWrapperList.add(cwVar);
        }
        
        // Populate select all value
        //setupCheckAll();
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 05 Feb 2013
    * @description 
    * @param 
    */
    public void saveCampaignAssignment(){
        
        // Variable Declaration
        List<Campaign> campaignList = new List<Campaign> ();
        Set<Id>campaignIdSet = new Set<Id>();
        
        for(CampaignWrapper cwVar: campaignWrapperList){
            // Get Campaign that are selected
            if(cwVar.IsSelected == true){
                // Get selected campaign record then put in a list
                campaignList.add(cwVar.campaignVar);
                // Get campaign record Id then put in a set
                campaignIdSet.add(cwVar.campaignVar.Id);
            }// End If
        }// End For
        
        // Remove all Campaign Assignment records that are not selected by the current PFR
        List<Campaign_Assignment__c>caDeleteList = [Select Id from Campaign_Assignment__c where Campaign__c Not IN :campaignIdSet and User__c = :Userinfo.getUserId()];
        Delete caDeleteList;
        
        //hard delete all recently deleted branches
        if(caDeleteList.size()>0) {
            Database.emptyRecycleBin(caDeleteList);
        }
        
        // Determine Campaign Assignment records that is already created for the selected campaign
        List<Campaign_Assignment__c>selectedCampaignList = [Select Id, Campaign__c from Campaign_Assignment__c where Campaign__c IN :campaignIdSet and User__c = :Userinfo.getUserId()];
        
        // Remove campaign ids if a corresponding campaign assignment record is already created for it
        for(Campaign_Assignment__c caVar:selectedCampaignList){
            campaignIdSet.remove(caVar.Campaign__c);
        }
        
        // Instantiate empty Campaign Assignment List to hold new Campaign Assignment records
        List<Campaign_Assignment__c> caCreateList = new List<Campaign_Assignment__c>();
        
        for(Id idVar:campaignIdSet){
            Campaign_Assignment__c caVar = new Campaign_Assignment__c(User__c = UserInfo.getUserId(), Campaign__c = idVar);
            caCreateList.add(caVar);
        }
        
        // Create new campaign assignments
        insert caCreateList;
    }
    
    /**
    * @author Original: Adrian Recio Cloud Sherpas/GEHC
    * @date Original: 12 March 2013
    * @description method to perform select all check/uncheck logic
    * @param 
    */
    public void setupCheckAll(){
        isSelectAll = true;
        if(CampaignWrapperList.size()>0){
            for(CampaignWrapper campWrapVar: CampaignWrapperList){
                if(campWrapVar.IsSelected == false || campWrapVar.IsSelected == null){                  
                    isSelectAll = false;
                }// End If
            }// End For
        }else{
            isSelectAll = false;    
        }// End Else
    }// End setupCheckAll Method
}// End BranchSetupController Class