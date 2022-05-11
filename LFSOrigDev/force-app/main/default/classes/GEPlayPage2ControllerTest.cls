@isTest
Public Class GEPlayPage2ControllerTest{

    //dml methods
    public static List<Task> createTasks(integer numberOfTasks,Opportunity opp) {

        List<Task> taskList = new List<Task>();
        for(Integer i=0; i<numberOfTasks; i++){
            Task tsk = new Task(
                whatID = opp.Id,
                OwnerId = opp.OwnerId,
                Subject = opp.Call_Type__c,
                Description = opp.Description,
                Call_Outcome__c = opp.StageName
            );
            taskList.add(tsk);
        }
        return taskList;
    }
    
    static testMethod void saveAndNextWithLeadQueueTest() {
        // Set Pfr Settings
        
        Debug_Settings__c debugSettings = new Debug_Settings__c();
        debugSettings.name = 'Production';
        debugSettings.debug__c = true;
        
        insert debugSettings;
        
        // Create Test Campaign
        List<Campaign>campaignList = TestdataBuilder.createCampaign(1);
        insert campaignList;
        
        // Create Test Campaign Assignment for Pfr
        List<Campaign_Assignment__c> caList = TestDataBuilder.createCampaignAssignment(1, campaignList, userInfo.getUserId());
        insert caList;
        
        // Create Test Branch
        List<Branch__c>branchList = TestDataBuilder.createBranch(1);
        insert branchList;
        
        // Create Test Branch Assignment of type Branch Leads for Pfr
        List<Branch_Assignment__c>blList = TestDataBuilder.createBranchAssignment(1, branchList, userInfo.getUserId(),'Branch Leads');
        insert blList;
        
        // Create Test Branch Assignment of type Working Location for Pfr
        List<Branch_Assignment__c>wlList = TestDataBuilder.createBranchAssignment(1, branchList, userInfo.getUserId(),'Working Location');
        insert wlList;

        // Create Test Lead
        
        // Create Test Account
        List<Account>accList = TestDataBuilder.createAccounts(2);
        accList[0].CLV_Customer_ID__c='0001111';
        insert accList;
        
        // Create Test Opportunity which is currently inplay for the pfr
        List<Opportunity>inplayOpp = TestDataBuilder.createOpportunities(1, accList[0].Id);
        inPlayOpp[0].CampaignId = campaignList[0].Id;
        inPlayOpp[0].Branch_Name__c = branchList[0].Name;
        inPlayOpp[0].InPlay__c = true;
        inPlayOpp[0].Time_Out__c = null;
        inPlayOpp[0].StageName = 'New';
        inPlayOpp[0].PostCode_Exclusion__c = false;
        inPlayOpp[0].Mail_Code__c = '';
        inPlayOpp[0].Excluded_Date__c = null;
 
        insert inplayOpp;
    
        List<Opportunity>queueOpp = TestDataBuilder.createOpportunities(2, accList[0].Id);
        
        // Create Test Opportunity that is valid to queue and is currently not inplay
        queueOpp[0].CampaignId = campaignList[0].Id;
        queueOpp[0].Branch_Name__c = branchList[0].Name;
        queueOpp[0].InPlay__c = false;
        queueOpp[0].Time_Out__c = null;
        queueOpp[0].StageName = 'New';
        queueOpp[0].PostCode_Exclusion__c = false;
        queueOpp[0].Mail_Code__c = '';
        queueOpp[0].Excluded_Date__c = null;
        
        // Create Test Opportunity that is valid to queue and is currently not inplay
        queueOpp[1].CampaignId = campaignList[0].Id;
        queueOpp[1].Branch_Name__c = branchList[0].Name;
        queueOpp[1].InPlay__c = false;
        queueOpp[1].Time_Out__c = null;
        queueOpp[1].StageName = 'New';
        queueOpp[1].PostCode_Exclusion__c = false;
        queueOpp[1].Mail_Code__c = '';
        queueOpp[1].Excluded_Date__c = null;
        
        insert queueOpp;
        
        PageReference pageRef = Page.geplaypage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid',queueOpp[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        
        test.startTest();
            GEPLay.selectedOpp.StageName = 'Customer Not Available';
            GEPLay.saveAndNext();
        test.stopTest();
    }
    
    //validate readonly null opportunity
    static testMethod void validateReadOnlyNull(){
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        test.startTest();
            GEPLay.validateReadOnly();
        test.stopTest();
    }
    
    static testMethod void saveAndNextNull(){
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        PageReference pageRef = Page.geplaypage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid',testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        
        test.startTest();
            GEPLay.selectedOpp.stageName = null;
            GEPLay.saveAndNext();
        test.stopTest();
    }
    
     //validate readonly null opportunity
    static testMethod void readOnlySaveLessDateToday(){
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'In Progress';
		testTask[0].Subject = 'Call';
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        PageReference pageRef = Page.geplaypage2readonly;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        
        test.startTest();           
            GEPLay.readOnlyTask.ReminderDateTime = Date.Today().addDays(-100);
            GEPLay.readOnlySave();
        test.stopTest();
    }
    
    //test methods
    static testMethod void ControllerTest(){//covering the constructor            
       
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        testAccount[0].PersonTitle = 'Mr.';
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getCallTypesTest(){//covering the getCallTypes method

        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        List<SelectOption> calltypes = GEPLay.getCallTypes();

        System.assert(!calltypes.isEmpty());
    }
    static testMethod void getStagesTest1(){ //covering getStages method if Call_Type__c == Inbound Call
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.getStages();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getStagesTest2(){ //covering getStages method if Call_Type__c == Outbound Call
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Outbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.getStages();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getStagesTest3(){ //covering getStages method if Call_Type__c is neither Inbound or Outbound Call
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = null;
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.getStages();    

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }

    static testMethod void getReasonsDNSTest(){//covering getReasonDNS method
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        List<SelectOption> dnsReasons = GEPLay.getReasonDNS();

        System.assert(!dnsReasons.isEmpty());
    
    }
    static testMethod void getReasonNI(){//covering getReasonNI method
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        List<SelectOption> niReasons = GEPLay.getReasonNI();

        System.assert(!niReasons.isEmpty());
        
    }
    static testMethod void getRenderDNSBoxTest1(){//covering getRenderDNSBox method if stageName == 'Do Not Solicit'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Do Not Solicit';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderDNSBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }    
    static testMethod void getRenderDNSBoxTest2(){//covering getRenderDNSBox method if stageName != 'Do not Solicit'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderDNSBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderNIBoxTest1(){//covering getRenderNIBox method if stageName == 'Not Interested'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Not Interested';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderNIBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderNIBoxTest2(){//covering getRenderNIBox method if stageName != 'Not Interested'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderNIBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderAppTakenBoxTest1(){//covering getRenderAppTaken method if stageName == 'Application Taken'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderAppTakenBox();    

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderAppTakenBoxTest2(){//covering getRenderAppTaken method if stageName != 'Application Taken'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'New';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderAppTakenBox();    

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderFollowUpBoxTest1(){//covering getRenderFollowUpBox method if stageName == 'Set Follow-Up Call'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderFollowUpBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void getRenderFollowUpBoxTest2(){//covering getRenderFollowUpBox method if stageName != 'Set Follow-Up Call'
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'New';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];        
        GEPLay.getRenderFollowUpBox();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest1(){//covering updateRecord method if stageName == 'Application Taken' and ApplicationNumber == nul
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest2(){//covering updateRecord method if stageName == 'Application Taken' and ApplicationNumber != nul
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Application Taken';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest3(){//covering updateRecord method if stageName == 'Set Follow-Up Call' and ReminderDateTime == nul
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'In Progress';
        testTask[0].subject = 'Call';		
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest4(){//covering updateRecord method if stageName == 'Set Follow-Up Call' and ReminderDateTime != null and ReminderDateTime >= 90 days
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'In Progress';
        testTask[0].subject = 'Call';		
        testTask[0].ReminderDateTime = Date.today().addDays(90);
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.selectedTask = testTask[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest5(){//covering updateRecord method if stageName == 'Set Follow-Up Call' and ReminderDateTime != null and ReminderDateTime is neither >= 90 days or today
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'In Progress';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = Date.today().addDays(-5);
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.selectedTask = testTask[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateRecordTest6(){//covering updateRecord method if stageName == 'Set Follow-Up Call' and Assigned_to_User__c == null
       //data variables
           List<Campaign> testCampaign = new List<Campaign>();
           Opportunity opportunity = new Opportunity();
       
           String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
            testCampaign.addAll(TestDataBuilder.createCampaign(1));
        //create account data
            Account testAccount = new Account(
              RecordTypeID=RecTypeId,
              FirstName='fname',
              LastName='lname',
              PersonMailingStreet='street',
              PersonMailingPostalCode='postal',
              PersonMailingCity='city',
              PersonEmail='testmail@yahoo.com',
              PersonHomePhone='homephone',
              PersonMobilePhone='mobilephone',
              PersonMailingState = 'state',
              PersonMailingCountry = 'country',
              CLV_Customer_Id__c = '14344');
            
            insert testAccount;

       //insert Opportunity
       
           for(Campaign c: testCampaign){
                    
                    opportunity.Name = 'Test Opportunity';
                    opportunity.AccountId = testAccount.Id;
                    opportunity.StageName = 'Test Stage';
                    opportunity.Branch_Name__c = 'Test Branch Name';
                    opportunity.Branch_ID__c = 'Test Branch ID';
                    opportunity.Branch_Suburb__c = 'Test Suburb';
                    opportunity.Branch_Postcode__c = 'Test Post';
                    opportunity.Propensity_Score__c = 1;
                    opportunity.Call_Type__c = 'Inbound Call';
                    opportunity.CampaignId = c.Id;
                    opportunity.CloseDate = System.today();
                    opportunity.OwnerId = UserInfo.getUserId();
                    opportunity.StageName = 'Set Follow-Up call';
                    insert opportunity;
                         
                    Opportunity currentOpportunity = [SELECT ID,Name FROM Opportunity WHERE Id =: opportunity.Id];
                    system.assertEquals(opportunity.Id,currentOpportunity.Id);
        }
            Task task = new Task();
            
            task.WhatId = opportunity.Id;
            task.OwnerId = opportunity.Owner.Id;
            task.Subject = opportunity.Call_Type__c;
            task.Call_Outcome__c = opportunity.StageName;
            task.Status = 'Open';
            task.ReminderDateTime = Date.today(); 
            task.OwnerId = UserInfo.getUserId();
            task.ActivityDate = Date.today();
            insert task;        
        
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', opportunity.Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedTask = task;
        GEPLay.selectedOpp = opportunity;
        GEPLay.updateRecord();
    }
    static testMethod void updateRecordTest7(){//covering updateRecord method if stageName == 'Set Follow-Up Call' and ReminderDateTime != null and ReminderDateTime is neither >= 90 days or today
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Cancel';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = Date.today();
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    } 
    static testMethod void updateRecordTest8(){//covering updateRecord method if stageName is null
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Cancel';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = Date.today();
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.selectedOpp.stageName = null;
        GEPLay.updateRecord();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    } 
    static testMethod void taskRecordTypeIdTest(){//covering taskRecordTypeId method
        String RecTypeId= [select Name from RecordType where SobjectType='Task' LIMIT 1].Name;
        GEPlayPage2Controller Controller = new GEPlayPage2Controller();
        Id taskRTId = Controller.taskRecordTypeId(RecTypeId);

        System.assert(taskRTId != null);
    }       
    static testMethod void pausePlayTest(){//covering pausePlay method
        
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Cancel';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.pausePlay();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
   static testMethod void saveAndNextTest1(){
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Do Not Solicit';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].Assigned_to_User__c = UserInfo.getUserId();
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.saveAndNext();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void saveAndCloseTest1(){
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Cancel';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.saveAndClose();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void saveAndCloseTest2(){
        //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.saveAndClose();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void readOnlySaveTest1(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
        testTask[0].subject = 'Call';		
        testTask[0].ReminderDateTime = Date.today().addDays(90);
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.readOnlyTask = testTask[0];
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.readOnlySave();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void readOnlySaveTest2(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].Subject = 'Call';
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.readOnlyTask = testTask[0];
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.readOnlySave();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateLeadTimerTest1(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = Date.today();
        
        insert testOpportunity;
     
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();   
        GEPLay.updateLeadTimer(testOpportunity);

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateLeadTimerTest2(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = Date.today();
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        
        insert testOpportunity;
     
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();   
        GEPLay.updateLeadTimer(testOpportunity);

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void updateLeadTimerTest3(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = null;
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        
        insert testOpportunity;
     
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();   
        GEPLay.updateLeadTimer(testOpportunity);

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void initOppTest1(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        testCampaign[0].IsActive = false;
        update testCampaign[0];
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = Date.today();
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        testOpportunity[0].Call_End_Date_Time__c = Date.today();
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('redirected' , '2');
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPlay.validateReadOnly();
        GEPLay.initOpp();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void initOppTest2(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();
        //create user
        Profile profile = [SELECT Id, Name from Profile WHERE Name = 'System Administrator'];

            User users = new User();
            users.FirstName = 'Test';
            users.LastName = 'User';
            users.Alias = 'Testu';
            users.Email = 'TestEmail@yahoo.com';
            users.Username = 'Dummy@cloudsherpas.com';
            users.CommunityNickname = 'Test Nickname';
            users.ProfileId = profile.Id;
            users.LocaleSidKey = 'en_US';
            users.EmailEncodingKey ='UTF-8';
            users.LanguageLocaleKey = 'en_US';
            users.TimeZoneSidKey = 'America/Los_Angeles';
            insert users;
            
        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        testCampaign[0].Status = 'Planned';
        update testCampaign;
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].OwnerId = users.Id;
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = null;
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        testOpportunity[0].Call_End_Date_Time__c = null;
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('redirected' , '2');
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPlay.validateReadOnly();
        GEPLay.initOpp();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void initOppTest3(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();

        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].InPlay__c = false;
        testOpportunity[0].OwnerId = [SELECT Id FROM User WHERE Name = 'GE Capital Queue User'].Id;
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = Date.today();
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        testOpportunity[0].Call_End_Date_Time__c = Date.today();
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = null;
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('redirected' , '2');
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 
        GEPLay.selectedOpp = testOpportunity[0];
        GEPlay.validateReadOnly();
        GEPLay.initOpp();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void createFollowUpTaskTest(){
         //data variables
        List<Campaign> testCampaign = new List<Campaign>();
        List<Opportunity> testOpportunity = new List<Opportunity>();
        List<Account> testAccount = new List<Account>();
        List<Task> testTask = new List<Task>();

        //create campaign
        testCampaign.addAll(TestDataBuilder.createCampaign(1));
        insert testCampaign;      
        
        //create person account
        testAccount.addAll(TestDataBuilder.createPersonAccounts(1));
        insert testAccount;
        //create user
            Profile profile = [SELECT Id, Name from Profile WHERE Name = 'System Administrator'];

            User users = new User();
            users.FirstName = 'Test';
            users.LastName = 'User';
            users.Alias = 'Testu';
            users.Email = 'TestEmail@yahoo.com';
            users.Username = 'Dummy@cloudsherpas.com';
            users.CommunityNickname = 'Test Nickname';
            users.ProfileId = profile.Id;
            users.LocaleSidKey = 'en_US';
            users.EmailEncodingKey ='UTF-8';
            users.LanguageLocaleKey = 'en_US';
            users.TimeZoneSidKey = 'America/Los_Angeles';
            insert users;
            
        //create opportunity
        testOpportunity.addAll(TestDataBuilder.createOpportunities(1,testAccount[0].Id));
        testOpportunity[0].CampaignId = testCampaign[0].Id;
        testOpportunity[0].stageName = 'Set Follow-Up Call';
        testOpportunity[0].Call_Type__c = 'Inbound Call';
        testOpportunity[0].InPlay__c = false;
        testOpportunity[0].OwnerId = UserInfo.getUserId();
        testOpportunity[0].Application_Number__c = '1';
        testOpportunity[0].Pause_Date_Time__c = Date.today();
        testOpportunity[0].Cumulative_Pause_Time__c = 1.0;
        testOpportunity[0].Assigned_To_User__c = users.Id;
        testOpportunity[0].Call_End_Date_Time__c = Date.today();
        
        insert testOpportunity;
        
        //create task
        testTask.addAll(createTasks(1,testOpportunity[0]));
        testTask[0].Status = 'Open';
		testTask[0].subject = 'Call';
        testTask[0].ReminderDateTime = Date.today();
        testTask[0].OwnerId = UserInfo.getuserId();
        testTask[0].ActivityDate = Date.today();
        insert testTask;
        
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid', testOpportunity[0].Id);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();
        GEPLay.selectedTask = testTask[0];
        GEPLay.selectedOpp = testOpportunity[0];
        GEPLay.createFollowUpTask();

        System.assertEquals(testOpportunity.get(0).Id, GEPLay.selectedOpp.Id);
    }
    static testMethod void incrementCounterTest(){
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();
        Decimal ctr = GEPLay.incrementCounter(1);

        System.assertEquals(2, ctr);
    }
    static testMethod void incrementCounterTest2(){
        //calling the controller's constructor
        PageReference pageRef = Page.GEPlayPage2;
        Test.setCurrentPage(pageRef);
        GEPlayPage2Controller GEPLay = new GEPlayPage2Controller();
        Decimal ctr = GEPLay.incrementCounter(null);

        System.assertEquals(1, ctr);
    }
    
    static testMethod void geOriginationIntegrationTest(){
        
        // Grant Profile Access to current user
        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
            
        // Create Admin Settings
        List<Admin_Settings__c> adminSettingsList = testDataBuilder.adminSet();
        insert adminSettingsList;   
        
        // Create 'Clone' Response Code Access
        Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'Clone'); 
        insert rccVar;
        
        // Create Account
        List<Account> accVar = testDataBuilder.createPersonAccounts(1);
        accVar[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accVar;
        
        // Create Billing ICBS 
        List<Billing_ICBS__c> billICBS = testDataBuilder.createBIcbs(2, accVar[0].Id);
        billICBS[0].Account_Number__c = '2000018223344';
        billICBS[0].Contract_Date__c = '25/08/2015';
        billICBS[1].Account_Number__c = '2000018223345';
        billICBS[1].Contract_Date__c = '31/08/2015';
        insert billICBS;
            
        List<Sobject> soVar = billICBS;
    
        // Create Campaign
        List<Campaign> camList = TestDataBuilder.createCampaign(3);
        camList[0].Promotional_Campaign__c = '60 Day Certificate';
        camList[1].Promotional_Campaign__c = 'Conditionally Approved Offer';
        camList[2].Promotional_Campaign__c = null;
        insert camList;      
        
        // Create Lead (Opportunity)
        List<Opportunity> oppVar = testDataBuilder.createOpportunities(1, accVar[0].Id);
        oppVar[0].Name = 'Test Lead Joint';
        oppVar[0].StageName = 'New';
        oppVar[0].CampaignId = camList[0].Id;
        insert oppVar;
                        
        // Create Brand
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        // Create Applicaton
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Max_Monthly_Capacity__c = 10000;
        testApplication.Contract_Account_Number__c = '18223345';
        insert testApplication;

        test.startTest();
            PageReference pageRef = Page.GEPlayPage2;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('oppid', oppVar[0].Id);

            GEPlayPage2Controller GEPLay = new GEPlayPage2Controller(); 

            // Test Error Messages
            ApexPages.currentPage().getParameters().put('appCreateErrMsg','No valid application found for 60 day certificate.');
            GEPLay.appCreateError();
            ApexPages.currentPage().getParameters().put('appSetupSuccMsg','Application is already assigned for this lead.');
            GEPLay.appSetupMsg();

            // Get latest info of opportunity before generating ICBS Account number
            GEPLay.opportunityRefresh();

            // Refresh ICBS Info
            GEPLay.checkOrigICBS();

            // Test ICBS Account Number Generation
            system.assertEquals('18223345',GEPlayPage2Controller.pullICBSAccountNumber(soVar,string.valueOf(oppVar[0].Id),null));

            // Refresh icbs and Contract Date based on new value generated from pullICBSAccountNumber method
            GEPLay.icbsInfoRefresh();

            // Create Application for 60 day cert
            SixtyDaysCertService.sixtyDayCertResponse appResponse = GEPlayPage2Controller.campaignProcess(oppVar[0].Id);
            
            system.assertNotEquals(null,appResponse.appId);
            
            // Link opportunity to created application
            ApexPages.currentPage().getParameters().put('sixtyDayAppId', appResponse.appId);
            GEPLay.refreshAndLinkOpportunityToApp();

        test.stopTest();
    }
}