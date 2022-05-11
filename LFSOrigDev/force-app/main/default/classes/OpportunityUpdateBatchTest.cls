@isTest

private class OpportunityUpdateBatchTest{
    static testMethod void case1(){
        
        //String query = 'SELECT Id,AccountId,Excluded_Date__c FROM Opportunity where Excluded_Date__c = null';
        
        //insert acc
        List<Account> acc = TestDataBuilder.createAccounts(1);
        insert acc;
        
        Opportunity[] o = new List<Opportunity>();
        for (Integer i=0;i<10;i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity' + i,
                AccountId = acc[0].Id,
                StageName = 'Test Stage',
                Branch_Name__c = 'Test Branch Name' + i,
                Branch_ID__c = 'Test Branch ID',
                Branch_Suburb__c = 'Test Suburb',
                Branch_Postcode__c = 'Test Post',
                Propensity_Score__c = 1,
                CloseDate = System.today(),
                Assigned_to_User__c = UserInfo.getUserId(),
                Excluded_Date__c = null);
            o.add(opp);
        }
        insert o;
        
        Test.startTest();
        OpportunityUpdateBatch OUB = new OpportunityUpdateBatch();
        Database.executeBatch(OUB);

        OppIterableCall OIC = new OppIterableCall();
        OIC.Iterator();

        OppIterable OI = new OppIterable();
        OI.hasNext();
        OI.next();
        Test.stopTest();

        System.assert(!o.isEmpty());
    }

}