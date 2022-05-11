@istest
private  class updateMerchantNumberTest {
    
     public static testMethod void testMerchantId(){
        
        
        UserRole Urole = [select id from UserRole where name='System Administrator'];
        Profile p1 = [select id, name from profile where name LIKE 'System Administrator' limit 1];
        User u = TestingUtils.createUsers(1,p1.id, Urole.id);                    
        insert u;
        TestingUtils.clear_execution_flags();
        
        string  rt1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cards Aus').getRecordTypeId();
        List<Account> newAccountCardsAU = new List<Account>();
        List<Account> newAccountCardsNZ = new List<Account>();
        List<Merchant_ID__c> newmerchs  = new List<Merchant_ID__c>();
        List<Merchant_ID__c> newmerchs1 = new List<Merchant_ID__c>();
        
        Test.startTest();
        system.runas(u){
     
            newAccountCardsAU = testingutils.CreateAccountMerchant(1,rt1,'Merchant','Cards AU');
            insert newAccountCardsAU;
            TestingUtils.clear_execution_flags(); 
         
            newAccountCardsNZ = testingutils.CreateAccountMerchant(1,rt1,'Merchant','Cards NZ');
            insert newAccountCardsNZ;
            TestingUtils.clear_execution_flags();
         
            List<Account> newAccountHealthcareAU = testingutils.CreateAccountMerchant(1,rt1,'Merchant','Healthcare AU');
            insert newAccountHealthcareAU;
            TestingUtils.clear_execution_flags();
         
            List<Account> newAccountAppleAU = testingutils.CreateAccountMerchant(1,rt1,'Merchant','Apple AU');
            insert newAccountAppleAU;
            TestingUtils.clear_execution_flags();

            newmerchs = testingutils.CreateMerchantid(1,'AUD',newAccountCardsAU[0].Id,408100,'Cards AU');
            insert newmerchs;
            TestingUtils.clear_execution_flags();
         
            newmerchs1 = testingutils.CreateMerchantid(1,'AUD',newAccountCardsNZ[0].Id,90000001,'Cards NZ');
            insert newmerchs1;
            TestingUtils.clear_execution_flags();
         
            List<Merchant_ID__c> newmerchs2 = testingutils.CreateMerchantid(1,'AUD',
                                                           newAccountHealthcareAU[0].Id,304001,'Healthcare AU');
            insert newmerchs2;
            TestingUtils.clear_execution_flags();
            List<Merchant_ID__c> newmerchs3 = testingutils.CreateMerchantid(1,'AUD',
                                                           newAccountAppleAU[0].Id,701001,'Apple AU');
            insert newmerchs3;
            TestingUtils.clear_execution_flags();
        }
        Test.stoptest();
        
        system.assertequals([Select id, Merchant_Number_cons__c from Account where id =: 
                             newAccountCardsAU[0].id limit 1].Merchant_Number_cons__c,408000,
                             'To Check  Merchant Cards AU number 408000 assigned to merchant number cons in account');
        
        system.assertequals([Select id, Merchant_Number_cons__c from Account where id =: 
                             newAccountCardsNZ[0].id limit 1].Merchant_Number_cons__c,90000000,
                             'To Check  Merchant Cards NZ number 90000000 assigned to merchant number cons in account');
        
        utils.get_apex_profile(); 
     }
}