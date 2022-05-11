@isTest
public class PlanDeleteBatchTest{
    //@isTest(SeeAllData=false)
    static testMethod void TestCase1(){

        integer BATCH_SIZE = 100;

        List<Account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        List<Billing_Vision_Plus__c> bvp = TestDataBuilder.createBVision(1, String.valueof(acc[0].id));
        
        insert bvp;
        List<Plans__c> Plans_List = new List<Plans__c>();

        for(integer i=0; i<BATCH_SIZE; i++) {
            Plans_List.add(new Plans__c(Balance__c = 100,Billing_Vision_Plus__c = String.ValueOf(bvp[0].id)));
        }
                                      
        insert Plans_List;


      
        
        Test.startTest();
            User currentUser = [SELECT name, email FROM User WHERE id=: UserInfo.getUserId()];
            PlanDeleteBatch planDeleteBatch = new PlanDeleteBatch();
            ID batchprocessid = database.executebatch(planDeleteBatch, BATCH_SIZE);

        Test.stopTest();

        System.assertEquals(BATCH_SIZE, Plans_List.size());
    }

}