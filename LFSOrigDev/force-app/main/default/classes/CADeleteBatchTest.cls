@isTest
public class CADeleteBatchTest{

    static testMethod void TestCase1(){
        List<Campaign> cam = TestDataBuilder.createCampaign(5);
        insert cam;
        List<Campaign_Assignment__c> ca = TestDataBuilder.createCampaignAssignment(1, cam,UserInfo.getUserId());
        
        insert ca;

        Test.startTest();
        CADeleteBatch plan = new CADeleteBatch();
        Database.executeBatch(plan);
          
        Test.stopTest();
        
        System.assert(!ca.isEmpty());
    }
}