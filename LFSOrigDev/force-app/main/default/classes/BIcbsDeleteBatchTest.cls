@isTest
public class BIcbsDeleteBatchTest{

    static testMethod void TestCase1(){
        List<Account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        List<Billing_ICBS__c> bvp = TestDataBuilder.createBIcbs(1, String.valueof(acc[0].id));
        
        insert bvp;

        Test.startTest();
        BIcbsDeleteBatch plan = new BIcbsDeleteBatch();
        Database.executeBatch(plan);
          
        Test.stopTest();
        
        System.assert(!bvp.isEmpty());
    }
}