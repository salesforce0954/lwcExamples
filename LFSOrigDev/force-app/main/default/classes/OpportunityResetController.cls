/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description Class to handle OpportunityResetPage
*/
public without sharing class OpportunityResetController {

// Public Variable Declaration
public String perspecSysURL {get; set;} 

/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013
* @description Constractor Method
* @param 
*/
public OpportunityResetController(){
    //set the url to blank if no value in custom settings
    this.perspecsysURL = timeout__c.getOrgDefaults().Perspecsys_URL__c;
    if(this.perspecsysURL == null) {
       this.perspecsysURL = '';
    }// End If    
}// End Constractor Method

/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013
* @description Method to create lead queue.
* @param 
*/
public pageReference resetOpportunity(){
    // Variable Declaration
    User usrVar = [Select Id from User where Name = 'GE Capital Queue User']; // Query generic user
    string oppIdStr = ApexPages.currentPage().getParameters().get('oppId'); // get oppId url parameter value
    List<Opportunity>oppVar = [Select Id, InPlay__c, Campaign.IsActive , OwnerId from Opportunity where Id = :oppIdStr limit 1]; // Query opportunity details using the oppId url parameter
    List<Opportunity>notInplayOppList = new List<Opportunity>(); 
    
    // Check if opportunity exist
    if(oppVar.size()==1){
    
      // Redirect to read only if selected lead(opportunity) is inplay  
      if((oppVar[0].InPlay__c == true && oppVar[0].OwnerId != UserInfo.getUserId()) || oppVar[0].Campaign.IsActive == false){
        // Perform redirect to GEPlayPage2ReadOnly Page
        PageReference pageVar = Page.GePlayPage2ReadOnly;
        pageVar.getParameters().put('oppId', oppIdStr);
        return pageVar;
      // Redirect to edit if sleected lead(opportunity) is no inplay
      }else{
      
        //JIRA-424: put in working location validation in the opportunity reset controller
  
        Set<String> locationNameSet = new Set<String>();
        List<Branch_Assignment__c> baList = [SELECT Id, Branch__r.Name FROM Branch_Assignment__c WHERE User__c = :Userinfo.getUserId() AND RecordType.Name = 'Working Location']; 
        if(baList.size()<1){
            PageReference pageVar = new PageReference(perspecsysURL + '/apex/LeadManagementHome');
            pageVar.getParameters().put('errorcode', '3');
            return pageVar;
        } else {
      
            // Reset all existing leads(opportunities) in play for current pfr
            List<Opportunity>inplayOppList = [Select Id, InPlay__c, OwnerId from Opportunity where                          
                                     InPlay__c = true
                                     and LastModifiedById = :UserInfo.getUserId()
                                     FOR UPDATE];
                                     
            for(Opportunity oVar: inplayOppList){
                // Reset inplay value to false
                oVar.InPlay__c = false;
                // Reset ownership to generic lead queue owner
                oVar.OwnerId = usrVar.Id;
                oVar.PlayPageSave__c = true;
                notInplayOppList.add(oVar);
            }// End For
            update notInplayOppList;
            
            // Set selected opportunity, 
            oppVar[0].InPlay__c = true; // inplay to true
            oppVar[0].OwnerId = UserInfo.getUserId(); // Ownership equal to current user
            oppVar[0].PlayPageSave__c = true;
            update oppVar;
            
            // Perform redirect to GEPlayPage2 Page
            PageReference pageVar = new PageReference(perspecsysURL + '/apex/GePlayPage2');
            pageVar.getParameters().put('oppId', oppIdStr);
            
            //BEGIN MLASALA 17-AUG-2016 Added isDialer parameter to identify whether BAU process should flow
            String isDialer = ApexPages.currentPage().getParameters().get('isDialer');
            if(isDialer == 'false'){
                pageVar.getParameters().put('isDialer', 'false');
            }
            //END MLASALA 17-AUG-2016
            return pageVar;
            
        }
        // 
      }// End Else
    }// End If
    
    return null;
}// End resetOpportunity Method

}// End OpportunityResetController Class