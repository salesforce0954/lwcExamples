@isTest

private class DailyRefreshLogicBatchTest{
    static testMethod void case1(){
        Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Lead Process').getRecordTypeId();
        
        //insert acc
        List<Account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        
        Opportunity[] o = new List<Opportunity>();
        for (Integer i=0;i<10;i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity' + i,
                AccountId = acc[0].Id,
                StageName = 'New',
                Branch_Name__c = 'Test Branch Name' + i,
                Branch_ID__c = 'Test Branch ID',
                Branch_Suburb__c = 'Test Suburb',
                Branch_Postcode__c = 'Test Post',
                Propensity_Score__c = 1,
                CloseDate = System.today(),
                Assigned_to_User__c = UserInfo.getUserId(),
                RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Lead Process').getRecordTypeId(),
                Excluded_Date__c = null);
            o.add(opp);
        }
        insert o;
        
        Test.startTest();
        DailyRefreshLogicBatch DRB = new DailyRefreshLogicBatch();
        Database.executeBatch(DRB);
        Test.stopTest();

        System.assert(!o.isEmpty());
    }

}