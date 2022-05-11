@isTest

public class TestAccountTriggerHandler{
    
      

    public static testmethod void testUpdateAccountABNBalances_BeforeInsertUpdate(){
            
        UserRole Urole = [select id from UserRole where name='System Administrator'];
        Profile p1 = [select id, name from profile where name LIKE '%Consumer%' limit 1];
        User u = TestingUtils.createUsers(1,p1.id, Urole.id);                    
        insert u;
        TestingUtils.clear_execution_flags(); 

        Test.startTest();
        system.runas(u){     
            List<ABN_Balances__c> newABNBalances = testingutils.CreateABNBalance('ABN',0);
            insert newABNBalances;
            TestingUtils.clear_execution_flags();        
            List<Account> newAccounts = testingutils.CreateAccount(2);
            Integer ctr = 1;
            for(Account a : newAccounts){
                a.Consumer_Accreditation_Comments_cons__c = 'test comment ' + ctr;
                a.Primary_Business_Unit__c = 'Consumer';
                ctr++;
            }
            newAccounts[0].ABN__c = null;
            newAccounts[1].ABN__c = '432432324';
            insert  newAccounts;

            List<Account> newAccount = testingutils.CreateAccount(0);
            for(Account a : newAccount){
                a.Consumer_Accreditation_Comments_cons__c = 'test comment ' + ctr;
                a.Primary_Business_Unit__c = 'Consumer';
                a.ParentId = newAccounts[2].Id;
                ctr++;
            }
            insert newAccount;
            TestingUtils.clear_execution_flags(); 
        }   
        Test.stopTest();  
        utils.get_apex_profile();  
    }


    


    

    
    
}