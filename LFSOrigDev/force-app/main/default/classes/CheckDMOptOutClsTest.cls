@istest
Private class   CheckDMOptOutClsTest {
    
    public static testMethod void  testDMLopt(){
        
    UserRole Urole1 = [select id,name from UserRole where name='System Administrator'];
    Profile p2 = [select id, name from profile where name LIKE '~ Consumer (Accreditation AUS)' limit 1];
    User u1 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id);  
    insert u1;
    TestingUtils.clear_execution_flags();
    
    List<Account> newAccounts = new List<Account>();
    List<Contact> contacts = new List<Contact>();
    
    test.starttest();
    system.runas(u1){
        
            // Invoke test Page for makePrimary
            PageReference pageRef = new PageReference('CheckDMOptOutCls');
            Test.setCurrentPage(pageRef);
            
            // Account Creation
            RecordType rt = [SELECT r.Id FROM RecordType r WHERE Name = 'Broker AU (Motor/PL)' AND SobjectType = 'Account'];
            newAccounts = testingutils.CreateAccount(1);
            newAccounts[0].ownerid = rt.Id;
            newAccounts[0].ownerid = u1.id;
            Integer ctr = 1;
            for(Account a : newAccounts)
            {
               a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
               ctr++;
            }
            insert newAccounts;
            TestingUtils.clear_execution_flags();

            contacts = TestingUtils.createContacts(1,newAccounts[0].Id);
            insert contacts;
            TestingUtils.clear_execution_flags();
            contacts[0].Direct_Marketing__c = 'DM - Opt Out';
            contacts[0].DM_Opt_Out_Reason__c = 'Not interested';
            
            update contacts;
            TestingUtils.clear_execution_flags();
            
            ApexPages.currentPage().getParameters().put('Id', contacts[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(contacts[0]);
            CheckDMOptOutCls cls = new CheckDMOptOutCls(sc);
            cls.CheckOnload();
            system.assertequals(cls.propAlert,'PRESENT','To Check propAlert has been updated for Direct Marketing contacts');
    }
            
    test.stoptest();
    utils.get_apex_profile(); 
   }
}