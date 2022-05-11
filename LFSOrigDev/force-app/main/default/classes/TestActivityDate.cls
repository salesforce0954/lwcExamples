@istest
Private class TestActivityDate{
    
    public static List<Task> tasksTest;
    public static List<Task> tasksTest2;
    public static List<Task> tasksTest3;
    public static List<Task> tasksTest4;

    public static List<Event> eventsTest;
    public static List<Event> eventsTest2;
    public static List<Event> eventsTest3;
    public static List<Event> eventsTest4;

    static Id taskRectypeid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Accreditations').getRecordTypeId();
    static Id eventRectypeid = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Event Accreditations').getRecordTypeId();

    @testSetup static void setup() {
        list<Account> newAccounts;
        list<Contact> newContacts;
        list<Opportunity> newOpportunity;
        tasksTest=new List<Task>();
        eventsTest=new List<Event>();
        newOpportunity = new List<Opportunity>();
         
        newAccounts = testingutils.CreateAccount(1);
        Integer ctr = 1;
        for(Account a : newAccounts)
        {
          a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
          ctr++;
        }
        insert newAccounts;

        newOpportunity = CreateOpportunity(1, newAccounts[0].id); 

        insert newOpportunity; 

        TestingUtils.clear_execution_flags();
        newContacts = testingutils.createContacts(1,newAccounts[0].id);
        insert newContacts;
        TestingUtils.clear_execution_flags();
        tasksTest=testingutils.CreateTask(1, newContacts[0].id, newAccounts[0].id);
        
        Profile p1 = [select id, name from profile where name LIKE '%Consumer%' limit 1];
        
        User testUser = TestDataBuilder.createUser2(p1.Id);
        testUser.Business_Unit__c = 'Consumer';
        insert testUser;

        for(Task t : tasksTest)
        {
          t.RecordTypeId = taskRectypeid;
          t.Status = 'Completed';
		  t.Subject = 'Call';
          t.Type = 'Meeting';
          t.Actual_Completion_Date__c = Date.today();
          t.OwnerId = testUser.Id;
        }
        insert tasksTest;

        TestingUtils.clear_execution_flags();
        tasksTest2=testingutils.CreateTask(1, newContacts[0].id, newOpportunity[0].id);
        for(Task t : tasksTest2)
        {
          t.RecordTypeId = taskRectypeid;
          t.Status = 'Completed';
          t.Type = 'Meeting';
		  t.Subject = 'Call';
          t.ActivityDate = System.today() + 1;
        }
        insert tasksTest2;

        TestingUtils.clear_execution_flags();
        tasksTest3=testingutils.CreateTask(1, newContacts[0].id, null);
        for(Task t : tasksTest3)
        {
          t.RecordTypeId = taskRectypeid;
          t.Status = 'Completed';
          t.Type = 'Meeting';
          
        }
        insert tasksTest3;

        TestingUtils.clear_execution_flags();
        tasksTest4=testingutils.CreateTask(1, null, newAccounts[0].id);
        for(Task t : tasksTest4)
        {
          t.RecordTypeId = taskRectypeid;
          t.Status = 'Completed';
          t.Type = 'Call';
          t.Actual_Completion_Date__c = Date.today();
        }
        insert tasksTest4;

        TestingUtils.clear_execution_flags();
        eventsTest=testingutils.CreateEvent(1,newAccounts[0].id,newContacts[0].id);
        for(Event e: eventsTest)
        {
          e.RecordTypeId = eventRectypeid;
          e.Status_Event__c = 'Completed';
          e.Actual_Completion_Date__c = Date.today();
          e.OwnerId = testUser.Id;
        }
        insert eventsTest;
        
        //TestingUtils.clear_execution_flags();
        //eventsTest2=testingutils.CreateEvent(1, newOpportunity[0].id, newContacts[0].id);
        //for(Event e: eventsTest2)
        //{
        //  e.RecordTypeId = eventRectypeid;
        //  e.Status_Event__c = 'Completed';
        //  e.Actual_Completion_Date__c = Date.today();
        //}
        //insert eventsTest2;

        TestingUtils.clear_execution_flags();
        eventsTest3=testingutils.CreateEvent(1, null, newContacts[0].id);
        for(Event e: eventsTest3)
        {
          e.RecordTypeId = eventRectypeid;
          e.Status_Event__c = 'Completed';
          e.OwnerId = testUser.Id;
        }
        insert eventsTest3;

        TestingUtils.clear_execution_flags();
        eventsTest4=testingutils.CreateEvent(1, newAccounts[0].id, null );
        for(Event e: eventsTest4)
        {
          e.RecordTypeId = eventRectypeid;
          e.Status_Event__c = 'Completed';
          e.OwnerId = testUser.Id;
        }
        insert eventsTest4;
        update eventsTest4;

        TestingUtils.clear_execution_flags();
    }
   // Created by Harika Date:6-May-2014 Starts   
   public static testMethod void handleExceptionForTaskEventTest(){         
            
        tasksTest = [SELECT Id,OwnerId,RecordTypeId from Task where RecordTypeId = :taskRectypeid];
        eventsTest = [SELECT Id,OwnerId,RecordTypeId from Event where RecordTypeId = :eventRectypeid];
        
        Test.startTest(); 
        
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, '0290099009');
            //Assering error
            List<Apexpages.Message> messageInstance = ApexPages.getMessages();
            boolean isErrorMessage = false;
            for(Apexpages.Message testMessages : messageInstance){
                if (testMessages.getDetail().contains(
                'Please update the Phone numbers on the Accounts page, for Australian Users, phone numbers must be 10 digits ie. 02 9009 9009, please contact the <a style=color:#0000FF href=\'mailto:pradeep.varala@ge.com\'>GE CRM Team</a> if you have any questions.') )
                    isErrorMessage  = true;
            }
           system.assert(!isErrorMessage);
            
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'areacode');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'AccountStatusrequired');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'FleetNumber');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'BusinessTypeis');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'ABNisrequired');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'ABNmustbe');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'Dealernumberis');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'Dealernumberhas');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'PhysicalCityis');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'SIC');
            ActivityDates.handleExceptionForTaskOnAccountUpdate(tasksTest, 'test');  
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, '0290099009');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'areacode');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'AccountStatusrequired');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'FleetNumber');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'BusinessTypeis');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'ABNisrequired');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'ABNmustbe');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'Dealernumberis');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'Dealernumberhas');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'PhysicalCityis');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'SIC');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'FleetCross-SellOpportunity');
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'EFCross-SellOpportunity'); 
            ActivityDates.handleExceptionForEventOnAccountUpdate(eventsTest, 'testt');  
        Test.stopTest(); 
        utils.get_apex_profile();   
   }   
   
   public static testMethod void putBusinessUnittest()
   {
      List<Task> listTasks = [SELECT Id,OwnerId,RecordTypeId,Business_Unit__c, Owner_Locale__c from Task where RecordTypeId = :taskRectypeid];
      UserRole Urole = [select id from UserRole where name='System Administrator'];
      Profile p1 = [select id, name from profile where name LIKE '%Consumer%' limit 1];
      User u = [Select id, Business_Unit__c, LocaleSidKey FROM User WHERE id = : listTasks[0].OwnerId];                

      Test.startTest();  
      System.runAs(u){
        //ActivityDates.putTBusinessUnit(listTasks);
        system.assertEquals(u.Business_Unit__c, listTasks[0].Business_Unit__c);
        system.assertEquals(u.LocaleSidKey, listTasks[0].Owner_Locale__c);      
      }
      Test.stopTest(); 
      utils.get_apex_profile();
   }
   

   public static List<Opportunity> CreateOpportunity(integer Size, id accId){
        List<Opportunity> myOpportunity = new List<Opportunity>();
        for(Integer i = 0;i<=Size;i++){
            myOpportunity.add(New Opportunity(Name = 'TestOppName__'+i, StageName = 'New',
            AccountId = accId, Branch_Name__c = 'TestBranchName__'+i, CloseDate = System.today()));
        }
        return myOpportunity;
    }       

}