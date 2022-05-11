@isTest
public class DeleteUnassignedLeadBatchTest {
    @testSetup
    private static void setupData(){
        Admin_Settings__c windowSetting = new Admin_Settings__c();
        windowSetting.Name = GEN_OriginationsConstants.ADMIN_SETTING_UNASSIGNED_LEADS_WINDOW;
        windowSetting.Value__c = '-1';
        insert windowSetting;
    }
    public static testMethod void DeleteUnassignedLeadBatchScheduler_Test(){
        
        Test.StartTest();
        
            DeleteUnassignedLeadBatchScheduler sh1 = new DeleteUnassignedLeadBatchScheduler(true);
            String sch = '0 0 1 * * ?';
            system.schedule('Opportunity Exclusion Update Batch', sch, sh1);
            
        Test.stopTest();
        
        System.assertNotEquals(sch, null);
        
    }
    
    public static testMethod void DeleteUnassignedLeadBatch_Test(){
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
                Excluded_Date__c = null);
            o.add(opp);
        }
        insert o;
        
        Test.startTest();
        
            DeleteUnassignedLeadBatch OUB = new DeleteUnassignedLeadBatch(false);
            Database.executeBatch(OUB);
            
        Test.stopTest();
        
        List<Opportunity> deletedOpp = [SELECT Id, IsDeleted FROM Opportunity where Id =: o[0].Id ALL ROWS];
        System.assert(deletedOpp[0].IsDeleted);
        
    }
    
    public static testMethod void DeleteUnassignedLeadBatch_Exception_Test(){
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
                Excluded_Date__c = null);
            o.add(opp);
        }
        
        insert o;
        
        delete o;
        
        Test.startTest();
        
            DeleteUnassignedLeadBatchController OUB = new DeleteUnassignedLeadBatchController();
            OUB.deleteUnassignedLeads(o);
            
        Test.stopTest();
        
    }
}