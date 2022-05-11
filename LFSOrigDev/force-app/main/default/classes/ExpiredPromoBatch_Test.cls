@isTest
public class ExpiredPromoBatch_Test{
    
    @testSetup static void staticRecords(){
        
        List<Promo__c> testPromoList = new List<Promo__c>();
        for(Integer i=0; i<5; i++){
            Promo__c testPromo = TestDataBuilder.createPromo(null);
            testPromo.Promo_ID__c = 'test'+i;
            testPromoList.add(testPromo);
        }
        
        insert testPromoList;
        testPromoList.clear();
        
        for(Promo__c p: [SELECT Id FROM Promo__c]){
            p.Promo_Start__c = Date.today()-10;
            p.Promo_End__c = Date.today()-1;
            testPromoList.add(p);
        }
        update testPromoList;
    }
    
    static testMethod void batchableTest(){
        
        List<Promo__c> activePromos = [SELECT Id FROM Promo__c WHERE Active__c = true];
        
        Test.StartTest();
        ExpiredPromoBatch batchJob = new ExpiredPromoBatch();
        Database.executeBatch(batchJob);
        Test.StopTest();
        
        List<Promo__c> inActivePromos = [SELECT Id FROM Promo__c WHERE Active__c = false];
        
        System.assertEquals(activePromos.size(), inActivePromos.size());
    }
}