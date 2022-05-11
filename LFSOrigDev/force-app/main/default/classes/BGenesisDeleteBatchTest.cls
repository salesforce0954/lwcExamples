@isTest
public class BGenesisDeleteBatchTest{

    static testMethod void TestCase1(){
        List<Account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        List<Billing_Genesis__c> bvp = TestDataBuilder.createBGenesis(1, String.valueof(acc[0].id));
        
        insert bvp;
        List<Billing_Genesis__c> bgc = new List<Billing_Genesis__c>();
        bgc.add(new Billing_Genesis__c(Credit_Score__c = '100',
                                       Account__c = acc[0].id));
                                      
        insert bgc;
        Test.startTest();
        BGenesisDeleteBatch plan = new BGenesisDeleteBatch();
        Database.executeBatch(plan);
          
        Test.stopTest();
        
        System.assert(!bgc.isEmpty());
    }
}