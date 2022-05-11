public without sharing class OpportunitySetupController{

    //public List<Opportunity> tempList{get;set;}
    public List<OpportunityWrapper> tempList{get;set;}
    public Boolean displayErrorMsg{get;set;}
    public Boolean displayTable{get;set;}
    public class OpportunityWrapper{
        public Id OppId{get;set;}
        public String OppName{get;set;}
        public String ActDueDate{get;set;}
        public String CampName{get;set;}
    }
    
    public OpportunitySetupController(){
    
        Map<Date,List<OpportunityWrapper>> dueDate = new Map<Date,List<OpportunityWrapper>>(); //dueDate-wrapperMap
        List<Date> dateToSort = new List<Date>();
        tempList = new List<OpportunityWrapper>();
        
        List<Opportunity> oListToDisplay = [SELECT Id, Name, Campaign.Name,(Select id, ActivityDate from Tasks order by LastModifiedDate DESC LIMIT 1) FROM Opportunity WHERE Owner.Name =: UserInfo.getName() AND (Outcome_Group__c = 'Call Back-Diary' OR Outcome_Group__c = 'Queue') AND Campaign.IsActive = true AND Campaign.Status = 'In Progress' ];
        
        for(Opportunity opp: oListToDisplay){
            if(opp.Tasks.size()>0) {
                if(opp.Tasks[0].ActivityDate != null){
                    OpportunityWrapper OppWrapper = new OpportunityWrapper();
                    oppWrapper.OppId = opp.Id;
                    oppWrapper.OppName = opp.Name;
                    oppWrapper.ActDueDate = String.valueOf(opp.Tasks[0].ActivityDate);
                    oppWrapper.CampName = opp.Campaign.Name;
                    //put the opportunities in a map, use the due date as a key
                    if (dueDate.containsKey(opp.Tasks[0].ActivityDate)) {
                        dueDate.get(opp.Tasks[0].ActivityDate).add(oppWrapper);
                    } else {
                        List<OpportunityWrapper> newOpps = new List<OpportunityWrapper>();
                        newOpps.add(oppWrapper);
                        dueDate.put(opp.Tasks[0].ActivityDate, newOpps);
                        //date to sort is a list the will sort the date
                        dateToSort.add(opp.Tasks[0].ActivityDate);
                    }
                }
            }
        }
        
        //sort the date
        dateToSort.sort();
        
        //add the opportunities in the wrapper
        for(Date d: dateToSort) {
            for(OpportunityWrapper opw: dueDate.get(d)) {
                tempList.add(opw);
            }
        }
        if(tempList.size() == 0){
            displayTable = false;
            displayErrorMsg = true;
        }
        else{
            displayTable = true;
            displayErrorMsg = false;
        }
        
        
    }
}