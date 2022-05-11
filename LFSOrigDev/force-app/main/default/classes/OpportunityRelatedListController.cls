public with sharing class OpportunityRelatedListController{
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/20/13 
Description: OpportunityRelatedList Class
*/
	//Variable Declaration
    public List<Opportunity> oppList {get; set;}
    public List<Opportunity> updateOppList;
    public Account acc;
    public string urlStr {get; set;}
    public Id currentUserId = UserInfo.getUserId();
    public Id queueUserId;
    
    public OpportunityRelatedListController(ApexPages.StandardController stdController){
        this.acc = (Account)stdController.getRecord();
        User u = [SELECT Id FROM User WHERE Name = 'GE Capital Queue User'];
        queueUserId = u.Id;
    }
    
    //Create wrapper class for related Opportunities
    public List<oppWrapper> getOpps(){
        oppList = [SELECT Id, Name, OwnerId, StageName, Amount, CloseDate, InPlay__c, Campaign.Status, Campaign.IsActive FROM Opportunity WHERE Account.id =:acc.Id];
        List<oppWrapper> oWrapList = new List<oppWrapper>();
        updateOppList = new List<Opportunity>();
        
        for(Opportunity o:oppList){
            oppWrapper oWrap = new oppWrapper();
            
            if((o.Campaign.IsActive == true || o.Campaign.Status == 'In Progress') && currentUserId == o.OwnerId || (o.InPlay__c == false && (o.Campaign.IsActive == true || o.Campaign.Status == 'In Progress') && queueUserId == o.OwnerId)){
            	//Redirect to GEPlayPage2
                oWrap.urlPgStr= '/apex/GEPlayPage2?oppid='+o.Id;
                if(o.InPlay__c == false && (o.Campaign.IsActive == true || o.Campaign.Status == 'In Progress') && queueUserId == o.OwnerId){
                    oWrap.urlPgStr= '/apex/GEPlayPage2?oppid='+o.Id+'&isURL=true';
                }
            } else if(((o.Campaign.IsActive == false || o.Campaign.Status != 'In Progress') && currentUserId == o.OwnerId) || (currentUserId != o.OwnerId) || (queueUserId == o.OwnerId && o.Campaign.IsActive == false)){
            	//Redirect to GEPlayPage2ReadOnly
                oWrap.urlPgStr= '/apex/GEPlayPage2ReadOnly?oppid='+o.Id;
            }//End Else
            
            oWrap.o = o;
            oWrapList.add(oWrap);
            
        }//End for
        
        return oWrapList;
        
    }//End getOpps()
    
     public class oppWrapper{
        public string urlPgStr {get; set;}
        public Opportunity o {get; set;}
     }   
    
}//End OpportunityRelatedListController