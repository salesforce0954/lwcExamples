/**
* @author Original: Dan Crisologo Cloud Sherpas
* @date Original: April 2013 
* @description Class for task component in GEPlayPage2 and ReadOnly
*/
public class TaskComponentController{

    //task wrapper
    public class TaskWrapper{   
        public String Subject{get;set;}
        public String ReminderDateTime{get;set;} 
    }
    
    //returns all top 5 tasks sorted by reminder date/time
    public List<TaskWrapper> getTaskSubject(){
        DateTime dateToday = DateTime.newInstanceGmt(System.now().date(), System.now().time()).dateGMT();

        Set<ID> validOpportunities = new Set<ID>();

        for(Opportunity opp:  [ SELECT  Id 
                                FROM    Opportunity 
                                WHERE   Owner.Name =: UserInfo.getName() 
                                  AND   (Outcome_Group__c = 'Call Back-Diary' 
                                   OR   Outcome_Group__c = 'Queue') ] ) {
            validOpportunities.add(opp.Id);
        }

        List<TaskWrapper> taskListWrapper = new List<TaskWrapper>();
        List<Task> taskList = [SELECT  Subject, 
                                       ReminderDateTime 
                               FROM    Task 
                               WHERE   Call_Outcome__c = 'Set Follow-Up Call' 
                                and    Recordtype.Name = 'Call Back' 
                                and    ReminderDateTime >=: dateToday-1 
                                and    OwnerId =: UserInfo.getUserId() 
                                and    Status != 'Completed' 
                                and    WhatId IN: validOpportunities
                             ORDER BY  ReminderDateTime ASC LIMIT 5 ];
                             
        for(Task t: taskList){
        
            TaskWrapper tWrap = new TaskWrapper();
            //t.ReminderDateTime = DateTime.newInstanceGmt(t.ReminderDateTime.date(), t.ReminderDateTime.time());
            String convertDate = t.ReminderDateTime.format('hh:mm:a\' \'dd/MM/yyyy\' \'');
            tWrap.Subject = t.Subject;
            tWrap.ReminderDateTime = convertDate;
            taskListWrapper.add(tWrap);
            
        }
        return taskListWrapper;
    }
}