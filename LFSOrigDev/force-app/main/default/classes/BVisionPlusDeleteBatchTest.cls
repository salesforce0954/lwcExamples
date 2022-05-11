@isTest
public class BVisionPlusDeleteBatchTest{
    static testMethod void TestCase1(){
        List<account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        List<Billing_Vision_Plus__c> ca = TestDataBuilder.createBVision(1,acc[0].id );
        
        insert ca;

        Test.startTest();
        BVisionPlusDeleteBatch plan = new BVisionPlusDeleteBatch();
        Database.executeBatch(plan);
          
        Test.stopTest();
        
        System.assert(!ca.isEmpty());
    }
}