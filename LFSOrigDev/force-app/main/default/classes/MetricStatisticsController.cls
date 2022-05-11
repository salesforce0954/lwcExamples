/*
Author: Dan Crisologo
Created Date: 2/21/2013
Description: 
History: 
*/
public class MetricStatisticsController {

    private DateTime dateToday = DateTime.newInstanceGmt(System.now().date(), System.now().time()).dateGMT();
    
    public Integer getNumberOfCalls() {

        List<Task> activityList = new List<Task>();
        List<Task> taskTemporary = new List<Task>();
        Set<String> oppIds = new Set<String>();
        Set<String> oppIdsToCompare = new Set<String>();
        //FORMULA as per JIRA:  (COUNT Activities WHERE CreatedDate = TODAY() AND Activity.Assignedto = User.ID AND ActivityRecordType = "Leads Process' AND r.OpportunityRecordType = "Leads Process")
        
        //query all task with matching filter
        for(Task t: [SELECT   Id,
                              WhatId,
                              CreatedDate
                     FROM     Task
                     WHERE    CreatedDate >=: Date.Today()-2    // temporarily get all tasks with created date from 2 days ago to minimize result
                      AND     OwnerId =: UserInfo.getUserId()
                      AND     RecordType.Name='Lead Process']) {
            
            if(t.WhatId!=null&&DateTime.newInstanceGmt(t.CreatedDate.date(), t.CreatedDate.time())>=this.dateToday) {
                taskTemporary.add(t);
                oppIds.add(t.WhatId);
            }
        }
        System.debug('oppIds: ' + oppIds.size());
        System.debug('taskTemporary: ' + taskTemporary.size());
        
        //query all opportunities from selected Tasks, filter by Lead Process record type.
        for(Opportunity o: [SELECT Id
                            FROM   Opportunity
                            WHERE  Id IN: oppIds
                             AND   RecordType.Name='Lead Process']) {
            oppIdsToCompare.add(o.Id);
        }
        System.debug('oppIdsToCompare: ' + oppIdsToCompare.size());
        
        //check if task's whatId belongs to the opportunities with lead process record type
        for(Task t2: taskTemporary) {
            if(oppIdsToCompare.contains(t2.whatId)) {
                activityList.add(t2);
            }
        }
        System.debug('activityList: ' + activityList.size());
        
        return activityList.size();
    
    }
    
    public Integer getRPCS() {

        List<Task> activityList = new List<Task>();
        List<Task> taskTemporary = new List<Task>();
        Set<String> oppIds = new Set<String>();
        Set<String> oppIdsToCompare = new Set<String>();
        Set<String> acceptedOutcomes = new Set<String>();
        //FORMULA as per JIRA:   (COUNT Activities WHERE Outcome = ("Not Interested" OR "Application Taken" OR "Do Not Solicit" OR "Unsuitable Lead") and CREATEDDATE = TODAYAND Activity.Assignedto = User.ID AND ActivityRecordType = "Leads Process' AND r.OpportunityRecordType = "Leads Process)
        
        acceptedOutcomes.add('Not Interested');
        acceptedOutcomes.add('Application Taken');
        acceptedOutcomes.add('Do Not Solicit');
        acceptedOutcomes.add('Unsuitable Lead');
        
        //query all task with matching filter
        for(Task t: [SELECT   Id,
                              WhatId,
                              CreatedDate
                     FROM     Task
                     WHERE    CreatedDate >=: Date.Today()-2    // temporarily get all tasks with created date from 2 days ago to minimize result
                      AND     Call_Outcome__c IN: acceptedOutcomes
                      AND     OwnerId =: UserInfo.getUserId()
                      AND     RecordType.Name='Lead Process'
                      AND     Call_Type__c != 'Inbound Call']) {
            
            if(t.WhatId!=null&&DateTime.newInstanceGmt(t.CreatedDate.date(), t.CreatedDate.time())>=this.dateToday) {
                taskTemporary.add(t);
                oppIds.add(t.WhatId);
            }
        }
        System.debug('oppIds: ' + oppIds.size());
        System.debug('taskTemporary: ' + taskTemporary.size());
        
        //query all opportunities from selected Tasks, filter by Lead Process record type.
        for(Opportunity o: [SELECT Id
                            FROM   Opportunity
                            WHERE  Id IN: oppIds
                             AND   RecordType.Name='Lead Process']) {
            oppIdsToCompare.add(o.Id);
        }
        System.debug('oppIdsToCompare: ' + oppIdsToCompare.size());
        
        //check if task's whatId belongs to the opportunities with lead process record type
        for(Task t2: taskTemporary) {
            if(oppIdsToCompare.contains(t2.whatId)) {
                activityList.add(t2);
            }
        }
        System.debug('activityList: ' + activityList.size());
        
        return activityList.size();
    
    }
    
    public Integer getApplications() {

        List<Task> activityList = new List<Task>();
        List<Task> taskTemporary = new List<Task>();
        Set<String> oppIds = new Set<String>();
        Set<String> oppIdsToCompare = new Set<String>();
        Set<String> acceptedOutcomes = new Set<String>();
        //FORMULA as per JIRA: (COUNT Activities WHERE Outcome = Application Taken and CREATEDDATE = TODAYAND Activity.Assignedto = User.ID AND ActivityRecordType = "Leads Process' AND r.OpportunityRecordType = "Leads Process)

        acceptedOutcomes.add('Application Taken');
        
        //query all task with matching filter
        for(Task t: [SELECT   Id,
                              WhatId,
                              CreatedDate
                     FROM     Task
                     WHERE    CreatedDate >=: Date.Today()-2    // temporarily get all tasks with created date from 2 days ago to minimize result
                      AND     Call_Outcome__c IN: acceptedOutcomes
                      AND     OwnerId =: UserInfo.getUserId()
                      AND     RecordType.Name='Lead Process']) {
            
            if(t.WhatId!=null&&DateTime.newInstanceGmt(t.CreatedDate.date(), t.CreatedDate.time())>=this.dateToday) {
                taskTemporary.add(t);
                oppIds.add(t.WhatId);
            }
        }
        System.debug('oppIds: ' + oppIds.size());
        System.debug('taskTemporary: ' + taskTemporary.size());
        
        //query all opportunities from selected Tasks, filter by Lead Process record type.
        for(Opportunity o: [SELECT Id
                            FROM   Opportunity
                            WHERE  Id IN: oppIds
                             AND   RecordType.Name='Lead Process']) {
            oppIdsToCompare.add(o.Id);
        }
        System.debug('oppIdsToCompare: ' + oppIdsToCompare.size());
        
        //check if task's whatId belongs to the opportunities with lead process record type
        for(Task t2: taskTemporary) {
            if(oppIdsToCompare.contains(t2.whatId)) {
                activityList.add(t2);
            }
        }
        System.debug('activityList: ' + activityList.size());
        
        return activityList.size();
    
    }
    //--------------------------------------------------------------------
    public static Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Branch_Assignment__c;
    public static Map<String,Schema.RecordTypeInfo> BranchAssignmentRecordType = cfrSchema.getRecordTypeInfosByName();
    public static Id branchRecordTypeId = BranchAssignmentRecordType.get('Branch Leads').getRecordTypeId();

    public Integer getOpptyQueue() {

        Set<Id> campaignIdSet = new Set<Id>();
        set<String> branchNameSet = new set<String>();
        
        for(Campaign_Assignment__c ca: [Select Id, 
                                        Campaign__c from 
                                        Campaign_Assignment__c where 
                                        User__c = :Userinfo.getUserId() and 
                                        Campaign__r.Status = 'In Progress' and 
                                        Campaign__r.IsActive = true]) {
            if(ca.Campaign__c!=null) {
                campaignIdSet.add(ca.Campaign__c);
            }
        }
        
                                        
        for(Branch_Assignment__c ba: [Select Id, Branch__r.Name from Branch_Assignment__c where User__c = :Userinfo.getUserId() and Recordtype.Name = 'Branch Leads']) {
            if(ba.Branch__r.Name!=null) {
                branchNameSet.add(ba.Branch__r.Name);
            }
        }
        
        //query all task with matching filter
        List<Opportunity> opp = [Select Id
                             from Opportunity 
                             where Branch_Name__c In :branchNameSet 
                                 and CampaignId In :campaignIdSet 
                                 and InPlay__c = false
                                 and (Time_Out__c < :Date.today() or Time_Out__c = null)
                                 and StageName In ('New', 'Customer Not Available', 'No Answer','Cancel', 'Left Message', 'Please Contact me letter sent')
                                 and PostCode_Exclusion__c = false
                                 and Mail_Code__c != 'MO'
                                 and Mail_Code__c != 'CO'
                                 and Overcalled_under_7_Days__c = 'FALSE'
                                 and Overcalled_under_30_Days__c = 'FALSE'
                                 and Excluded_Date__c = null
                                 and Processed__c = false];
            
        return opp.size();

    }
    
    //--------------------------------------------------------------------------
    
    /* -- DO NOT REMOVE. This is for testing purpose regarding GMTs
    public String getTest() {
        Opportunity opp = [Select Id, LastModifiedDate from Opportunity where id = '006f00000024DnU'];
         //   GMTDate.format('MM/dd/yyyy HH:mm:ss', 'America/New_York');
        //userTimeZone
        DateTime d = DateTime.newInstanceGmt(opp.LastModifiedDate.date(), opp.LastModifiedDate.time());
        DateTime d2 = DateTime.newInstanceGmt(System.now().date(), System.now().time());
        DateTime d3 = d2.dateGMT();
        
        return 'test:' + opp.LastModifiedDate + 'xxx' + System.now() + 'xxx' + UserInfo.getTimeZone() + 'xxx' + d + 'xxx' + d2 + 'xxx' + d3;
    }
    */

}