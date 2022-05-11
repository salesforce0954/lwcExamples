@isTest
public class ScheduleExpiredPromoBatch_Test{
    
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
    
    static testMethod void schedulerTest(){
        
        String startTime = '0 0 12 * * ?';
        ScheduleExpiredPromoBatch testScheduler = new ScheduleExpiredPromoBatch();
        String jobId = System.schedule('Test expired promos job', '0 0 12 * * ?', testScheduler);
        
        CronTrigger c = [SELECT Id,
                                CronExpression,
                                TimesTriggered,
                                NextFireTime
                         FROM   CronTrigger
                         WHERE  Id =: jobId];
        
        System.assertEquals(startTime, c.CronExpression);
        System.assertEquals(0, c.TimesTriggered);
    }
}