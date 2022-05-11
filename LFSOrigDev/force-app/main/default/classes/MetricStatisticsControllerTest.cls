@isTest

private class MetricStatisticsControllerTest{
    static testMethod void case1(){
        
        RecordType accRT = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];        

        //insert account
        Account acc = new Account();
        acc.LastName = 'Test Name';
        acc.CLV_Customer_ID__c = '1234';
        acc.RecordTypeId = accRT.id;
        insert acc;

        RecordType opptyRT = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Lead Process' Limit 1];        
        
        //insert opportunity
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.AccountId = acc.Id;
        opportunity.StageName = 'Test Stage';
        opportunity.Branch_Name__c = 'Test Branch Name';
        opportunity.Branch_ID__c = 'Test Branch ID';
        opportunity.Branch_Suburb__c = 'Test Suburb';
        opportunity.Branch_Postcode__c = 'Test Post';
        opportunity.Propensity_Score__c = 1;
        opportunity.CloseDate = System.today();
        opportunity.Assigned_to_User__c = UserInfo.getUserId();
        opportunity.RecordTypeId = opptyRT.Id;
        insert opportunity;

        RecordType taskRT = [select id,Name from RecordType where SobjectType='Task' and Name='Lead Process' Limit 1];        
       
        //insert task
        Task tsk = new Task();
        tsk.WhatId = opportunity.Id;
		tsk.Subject = 'Call';
        tsk.Call_Outcome__c = 'Do Not Solicit';
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Recordtype = taskRT;
        insert tsk;
        
        List<Task> taskList = new List<Task>();
        taskList = [select Id, WhatId, OwnerId, CreatedDate, RecordType.Name from Task where Id =: tsk.Id];
        system.debug('@@@taskList: ' + taskList);
        
        MetricStatisticsController controller = new MetricStatisticsController();
        controller.getNumberOfCalls();

        System.assert(!taskList.isEmpty());
    }
    
    static testMethod void case2(){
     
        RecordType accRT = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];        

        //insert account
        Account acc = new Account();
        acc.LastName = 'Test Name';
        acc.CLV_Customer_ID__c = '12345';
        acc.RecordTypeId = accRT.id;
        insert acc; 
        
        
        //insert opportunity
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.AccountId = acc.Id;
        opportunity.StageName = 'Test Stage';
        opportunity.Branch_Name__c = 'Test Branch Name';
        opportunity.Branch_ID__c = 'Test Branch ID';
        opportunity.Branch_Suburb__c = 'Test Suburb';
        opportunity.Branch_Postcode__c = 'Test Post';
        opportunity.Propensity_Score__c = 1;
        opportunity.CloseDate = System.today();
        opportunity.Assigned_to_User__c = UserInfo.getUserId();
        insert opportunity;
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Lead Process' Limit 1];
        
        //insert task
        Task tsk = new Task();
        tsk.WhatId = opportunity.Id;
        tsk.Call_Outcome__c = 'Do Not Solicit';
        tsk.OwnerId = UserInfo.getUserId();
		tsk.subject = 'Call';
        tsk.Recordtype = rt;
        insert tsk;

        MetricStatisticsController controller = new MetricStatisticsController();
        controller.getRPCS();

        List<Task> taskList = [select Id, WhatId, OwnerId, CreatedDate, RecordType.Name from Task where Id =: tsk.Id];
        System.assert(!taskList.isEmpty());
    }
    
    static testMethod void case3(){
        //insert account
        Account acc = new Account();
        acc.Name = 'Test Name';
        
        //insert opportunity
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.AccountId = acc.Id;
        opportunity.StageName = 'Test Stage';
        opportunity.Branch_Name__c = 'Test Branch Name';
        opportunity.Branch_ID__c = 'Test Branch ID';
        opportunity.Branch_Suburb__c = 'Test Suburb';
        opportunity.Branch_Postcode__c = 'Test Post';
        opportunity.Propensity_Score__c = 1;
        opportunity.CloseDate = System.today();
        opportunity.Assigned_to_User__c = UserInfo.getUserId();
        
        insert opportunity;
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Opportunity' and Name='Lead Process' Limit 1];
        
        //insert task
        Task tsk = new Task();
        tsk.WhatId = opportunity.Id;
        tsk.Call_Outcome__c = 'Application Taken';
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Recordtype = rt;
		tsk.subject = 'Call';
        insert tsk;
        
        MetricStatisticsController controller = new MetricStatisticsController();
        controller.getApplications();

        List<Task> taskList = [select Id, WhatId, OwnerId, CreatedDate, RecordType.Name from Task where Id =: tsk.Id];
        System.assert(!taskList.isEmpty());
    }
}