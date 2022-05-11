/*
Author: Andre Calimlim Cloud Sherpas
Created Date: 02/07/13
Description: Class for Opportunity Triggers
*/

public class OpportunityTriggerHandler{
    /*
    Author: Andre Calimlim Cloud Sherpas
    Created Date: 02/07/13
    Description: Class for Opportunity Triggers
    */
    
    public void createTask(List<Opportunity> rec){
        List<Task> taskList = new List<Task>();
        for(Opportunity o : rec){
            Task tasks = new Task(
                    whatID = o.ID,
                    Ownerid = o.OwnerId,
                    Subject = o.Call_Type__c,
                    Description = o.Description,
                    Call_Outcome__c = o.StageName
            );
            taskList.add(tasks);
        }
        insert taskList;
    }
}