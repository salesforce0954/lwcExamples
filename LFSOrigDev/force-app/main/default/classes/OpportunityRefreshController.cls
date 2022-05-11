public with sharing class OpportunityRefreshController {
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/08/13 
Description: OpportunityRefresh class
Last Modified: Michael Lasala		03/07/2013		Added filter conditions on opportunity Query
*/
	//Variable Declaration
    public string Branches {get; set;}
    List<Branch__c> branch = new List<Branch__c>();
    
    public OpportunityRefreshController(ApexPages.StandardController stdController){
    
    }
    
    //Select all Branches available
    public List<selectOption> getBranch(){
        List<selectOption> options = new List<selectOption>();
        
        options.add(new selectOption('', '- None -'));
        
        branch = [Select Id, Name FROM Branch__c];
        
        for (Branch__c b: branch){
            options.add(new selectOption(b.Id, b.Name));
        }//End for
        return options;
    }//End getBranch
    
    //Method to select Opportunities to be refreshed 
    public PageReference refreshPropensity(){
        List<Branch__c> branchName = [SELECT Name FROM Branch__c WHERE Id =: Branches];
            if(branchName.size()>0){
                List<Opportunity> opps = [SELECT id, Live_Propensity_Score__c, Propensity_Score__c FROM Opportunity 
                						  WHERE Branch_Name__c =: branchName[0].Name AND Campaign.IsActive = true AND Campaign.Status = 'In Progress' 
                						  AND (StageName = 'New' OR StageName = 'Customer Not Available' OR StageName = 'Left Message' 
                						  OR StageName = 'No Answer')];
                for (Opportunity o: opps){
                    o.Live_Propensity_Score__c = o.Propensity_Score__c;
                }//End for
                update opps;
                 return new PageReference('javascript:window.close()'); 
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please a select Branch'));
                return null;
            }//End else
    }//End refreshPropensity
}//End OpportunityRefreshController