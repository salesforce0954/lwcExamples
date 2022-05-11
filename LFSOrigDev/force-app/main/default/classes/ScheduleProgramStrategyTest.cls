@isTest(SeeAllData=false)
public class ScheduleProgramStrategyTest {

 	public static testMethod void testScheduleProgramStrategy(){
      
			//Inserting Accounts
			List<Account>  accs= new List<Account>();
			accs = TestingUtils.CreateAccount(1); 
			 Integer ctr = 1;
             for(Account a : accs)
             {
                a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Cards Aus').RecordTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
			insert accs;
			TestingUtils.clear_execution_flags();
			     
		    List<Promotions__c> promotionslst = new List<Promotions__c>();
		    promotionslst=TestingUtils.createPromotions(5,accs[0].Id);
		    insert promotionslst;
		    TestingUtils.clear_execution_flags();
      
      Test.StartTest();      
      
	       	ScheduleProgramStrategy sps = new ScheduleProgramStrategy();     
	        String sch = '0  00 2 3 * ?';
	        string jobId = system.schedule('Test', sch, sps);
	      
      Test.StopTest();
      
       		CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
 								   	   FROM CronTrigger WHERE Id = :jobId];
			System.assertEquals(sch, cronTrigger.CronExpression,'Assert that the expressions are the same');
			System.assertEquals(cronTrigger.TimesTriggered, 0,'Assert that the Cron job has not started');
     
      utils.get_apex_profile();  
        
    } 
}