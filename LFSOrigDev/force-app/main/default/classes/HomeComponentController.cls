/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 26 Feb 2013 
* @description Class to home page component logic (Components: To do List, Recent Leads)
*/

public with sharing class HomeComponentController {

    // Variable Declaration
    public List<OpportunityWrapper> tempList{get;set;}
    public List<Opportunity> RecentOppToDisplay{get;set;}
    public Boolean displayErrorMsg{get;set;}
    public Boolean displayTable{get;set;}
    public String perspecSysURL {get; set;} 

    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Wrapper class for todolist component
    * @param 
    */
    
    public class OpportunityWrapper{
        public Id OppId{get;set;}
        public String OppName{get;set;}
        public DateTime ActDueDate{get;set;}
        public String CampName{get;set;}
        public String AccName{get;set;}
        public Id AccId{get;set;}
    }
    
    /**
    * @author Original: Dan Crisologo Cloud Sherpas
    * @date Original: 26 Feb 2013
    * @description Class constractor
    * @last modified by: Michael Lasala Cloud Sherpas       27 Feb 2013     Removed filter for Campaign to display all tasks
    * @last modified by: Michael Lasala Cloud Sherpas       28 Feb 2013     Added filter for Task to display Status != Completed
    * @param 
    */
    public HomeComponentController(){
        //set the url to blank if no value in custom settings
        this.perspecsysURL = timeout__c.getOrgDefaults().Perspecsys_URL__c;
        if(this.perspecsysURL == null) {
            this.perspecsysURL = '';
        }// End If
        
        // Variable declaration
        Map<DateTime,List<OpportunityWrapper>> dueDate = new Map<DateTime,List<OpportunityWrapper>>(); //dueDate-wrapperMap
        List<DateTime> dateToSort = new List<DateTime>();
        tempList = new List<OpportunityWrapper>();
        
        List<Opportunity> oListToDisplay = [SELECT Id, Name, Account.Id, Account.Name, Campaign.Name,
                                            (Select id, ReminderDateTime from Tasks where Status != 'Completed' order by LastModifiedDate DESC LIMIT 1) 
                                            FROM Opportunity WHERE Owner.Name =: UserInfo.getName() AND 
                                            (Outcome_Group__c = 'Call Back-Diary' OR Outcome_Group__c = 'Queue')/* AND 
                                            Campaign.IsActive = true AND Campaign.Status = 'In Progress'*/ ];
        
        for(Opportunity opp: oListToDisplay){
            if(opp.Tasks.size()>0) {
                if(opp.Tasks[0].ReminderDateTime != null){
                    DateTime dateToday = DateTime.newInstanceGmt(opp.Tasks[0].ReminderDateTime.date(), opp.Tasks[0].ReminderDateTime.time());
                    OpportunityWrapper OppWrapper = new OpportunityWrapper();
                    oppWrapper.OppId = opp.Id;
                    oppWrapper.OppName = opp.Name;
                    oppWrapper.ActDueDate = dateToday;
                    oppWrapper.CampName = opp.Campaign.Name;
                    oppWrapper.AccName = opp.Account.Name;
                    //put the opportunities in a map, use the due date as a key
                    if (dueDate.containsKey(opp.Tasks[0].ReminderDateTime)) {
                        dueDate.get(opp.Tasks[0].ReminderDateTime).add(oppWrapper);
                    } else {
                        List<OpportunityWrapper> newOpps = new List<OpportunityWrapper>();
                        newOpps.add(oppWrapper);
                        dueDate.put(opp.Tasks[0].ReminderDateTime, newOpps);
                        //date to sort is a list the will sort the date
                        dateToSort.add(opp.Tasks[0].ReminderDateTime);
                    }// End Else
                }// End If
            }// End Else
        }// End For
        
        //sort the date
        dateToSort.sort();
        
        //add the opportunities in the wrapper
        for(DateTime d: dateToSort) {
            for(OpportunityWrapper opw: dueDate.get(d)) {
                tempList.add(opw);
            }// End For
        }// End For
        
        if(tempList.size() == 0){
            displayTable = false;
            displayErrorMsg = true;
        }
        else{
            displayTable = true;
            displayErrorMsg = false;
        }// End 
      
        RecentOppToDisplay = [SELECT Id, Name, Account.Id, Account.Name, Campaign.Name, StageName FROM Opportunity where LastModifiedById = :UserInfo.getUserId() ORDER BY LastModifiedDate DESC LIMIT 10];
    }// End Constractor Method
}// End HomeComponentController Class