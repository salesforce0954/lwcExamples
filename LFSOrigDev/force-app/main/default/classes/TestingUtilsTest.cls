@istest
Private class TestingUtilsTest{ 

        public static testMethod void TestingUtilsTestMethods(){   
            
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u1 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u1;
        TestingUtils.clear_execution_flags();
        
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>();      
        string AccntRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
                  

        system.runas(u1){
           
            Test.startTest(); 
            TestingUtils.disableTriggerCustSetting(true, p2.id, 'AccountTrigger');
            TestingUtils.createCustomSettingData();       
            profileCustomSetting = testingutils.CreategeneralProperties();                         
            insert profileCustomSetting;       
            
            list<Account> newCreateAccounts = TestingUtils.createAccounts(1,'industry',AccntRecTypeId );
            insert newCreateAccounts ;
            TestingUtils.clear_execution_flags();
            list<Account> newcreateHierarchyAccounts = TestingUtils.createHierarchyAccounts(1,newCreateAccounts,AccntRecTypeId);
            insert newcreateHierarchyAccounts ;
            TestingUtils.clear_execution_flags();
            
            list<Account> newCreateAccount = TestingUtils.createAccounts(1,'industry',AccntRecTypeId);
            Integer ctr = 1;
             for(Account a : newCreateAccount)
             {
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
            insert newCreateAccount ;
            TestingUtils.clear_execution_flags();
            //AccountShare accountShare = TestingUtils.createAccountShare(u1.id,newCreateAccount[0].id,'Edit','Read');
            //insert accountShare ;
            list<user> users = TestingUtils.createUsers(2,'System Administrator','System Administrator','USD');
            insert users ;
            TestingUtils.clear_execution_flags();

            TestingUtils.clear_execution_flags();
            list<Account> CreateAccountMrchant = TestingUtils.CreateAccountMerchant(1,AccntRecTypeId ,'Prospect','Cards AU');
            insert CreateAccountMrchant ;
            TestingUtils.clear_execution_flags();
            list<Account> CreateAccountDormant = TestingUtils.CreateAccountDormant(1, AccntRecTypeId);
            insert CreateAccountDormant ;
            TestingUtils.clear_execution_flags();
            list<Contact> createContacts = TestingUtils.createContacts(1,CreateAccountDormant[0].id);
            insert createContacts ;
            TestingUtils.clear_execution_flags();
            List<ABN_Balances__c> CreateABNBalance = TestingUtils.CreateABNBalance('ABC',0);
            insert CreateABNBalance ;
            TestingUtils.clear_execution_flags();
            List<Merchant_ID__c> CreateMerchantid = TestingUtils.CreateMerchantid (1,'USD', CreateAccountDormant[0].id,123,'456');
            insert CreateMerchantid ;
            TestingUtils.clear_execution_flags();
            
            test.stoptest(); 
            list<String> Roles = new list<String>();
            Roles.add('Admin');      
            list<UserRole> UserRoles = TestingUtils.createRoles( Roles);
            insert UserRoles ;
            TestingUtils.clear_execution_flags();
            User newUser = TestingUtils.createUsers(1,p2.id,UserRoles[0].id);
            insert newUser ;
            TestingUtils.clear_execution_flags();
            //String Randomword = TestingUtils.createRandomWord();
            }
            utils.get_apex_profile();
        }
    
        public static testMethod void TestingUtilsTests(){   
 
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u2 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u2;
        TestingUtils.clear_execution_flags();
        User u3 = TestingUtils.CreateUSer('genreral123@test.com',p2.id, Urole1.id); 
        insert u3;
        TestingUtils.clear_execution_flags();
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>(); 
        
        string AccountRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
    
        system.runas(u3){
            profileCustomSetting = testingutils.CreategeneralProperties();                         
            insert profileCustomSetting;  
                 
            list<Account> CreateAccnt = TestingUtils.CreateAccount(1); 
             Integer ctr = 1;
             for(Account a : CreateAccnt)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert CreateAccnt;
             TestingUtils.clear_execution_flags();                
            list<Contact> createContact = TestingUtils.createContacts(1,CreateAccnt[0].id);
            insert createContact ;
            TestingUtils.clear_execution_flags();
            List<Task> TaskNew = TestingUtils.CreateTask(1,createContact[0].id ,CreateAccnt[0].id);
            insert TaskNew ;
            TestingUtils.clear_execution_flags();
         }              
        
          system.runas(u2){
                    
            profileCustomSetting = testingutils.CreategeneralProperties();                         
            insert profileCustomSetting;   
                 
            list<Account> CreateAccnt = TestingUtils.CreateAccount(1); 
             Integer ctr = 1;
             for(Account a : CreateAccnt)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert CreateAccnt;
             TestingUtils.clear_execution_flags();  
           
            General_Properties__c Customsetting = TestingUtils.CreateCustomSetting('Test','TestOne');
            insert Customsetting ;
            TestingUtils.clear_execution_flags();
            
            
            User UserUserRole = TestingUtils.createUserUserRole('India','Aircraft (AIR)', p2.id,'genreral1@test.com' ,Urole1.id);
            insert UserUserRole ;
            TestingUtils.clear_execution_flags();
            
           
            List<Contact> createContacts = TestingUtils.createContacts(1);
            insert createContacts ;
            TestingUtils.clear_execution_flags();
            
            }
           
        }
        
   public static testMethod void TestingUtilMethodsTest(){   
 
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u3 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u3;
        TestingUtils.clear_execution_flags();
        User u4 = TestingUtils.CreateUSer('genreral111@test.com',p2.id, Urole1.id); 
        insert u4;
        TestingUtils.clear_execution_flags();
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>(); 
        
        string AccountRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
        Date oppDate= system.today();
                      
       
        system.runas(u3){
             
             profileCustomSetting = testingutils.CreategeneralProperties();                         
             insert profileCustomSetting;   
                  
             List<Account> Acct = TestingUtils.accountCreation();
              Integer ctr = 1;
             for(Account a : Acct)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert Acct;
             TestingUtils.clear_execution_flags();         

             list<Contact> createContact = TestingUtils.createContacts(1,Acct[0].id);
             insert createContact ;
             TestingUtils.clear_execution_flags();         
             
             List<Event> EventNew = TestingUtils.CreateEvent(1,Acct[0].id,createContact[0].id );
             insert EventNew ;
             TestingUtils.clear_execution_flags();
             
             List<Merchant_ID__c> CreateMerchantid = TestingUtils.CreateMerchantid (1,'USD', Acct[0].id,123,'456');
             insert CreateMerchantid ;
             TestingUtils.clear_execution_flags();            
             
            
         
            }
            utils.get_apex_profile();
        }
        
      
   public static testMethod void TestingUtilTestMethod(){   
 
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u3 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u3;
        TestingUtils.clear_execution_flags();
        User u4 = TestingUtils.CreateUSer('genreral111@test.com',p2.id, Urole1.id); 
        insert u4;
        TestingUtils.clear_execution_flags();
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>(); 
        
        string AccountRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
        
                                    
     
        system.runas(u3){
             Test.startTest();
             profileCustomSetting = testingutils.CreategeneralProperties();                         
             insert profileCustomSetting; 
             
             List<Account> Acct = TestingUtils.accountCreation();
              Integer ctr = 1;
             for(Account a : Acct)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert Acct;
             TestingUtils.clear_execution_flags();             
             list<Contact> createContact = TestingUtils.createContacts(1,Acct[0].id);
             insert createContact ;
             TestingUtils.clear_execution_flags();
            
            
             List<Promotions__c> Promotions = TestingUtils.createPromotions(1,Acct[0].id);
             insert Promotions; 
             TestingUtils.clear_execution_flags();
             test.stoptest();
            }
          
        }
      
   public static testMethod void TestingUtilMethod(){   
 
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u3 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u3;
        TestingUtils.clear_execution_flags();
        User u4 = TestingUtils.CreateUSer('genreral111@test.com',p2.id, Urole1.id); 
        insert u4;
        TestingUtils.clear_execution_flags();
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>(); 
        List<General_Properties__c> ContactStrategy = new list <General_Properties__c>(); 
        
        string AccountRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
        
                  
       
        system.runas(u4){
                
             profileCustomSetting = testingutils.CreategeneralProperties();                         
             insert profileCustomSetting; 
             ContactStrategy = testingutils.CreateContactStrategyManagement();                         
             insert ContactStrategy; 
             
             List<Account> Acct = TestingUtils.accountCreation();
             Integer ctr = 1;
             for(Account a : Acct)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert Acct;
             TestingUtils.clear_execution_flags();              
             list<String> Roles = new list<String>();
             Roles.add('Admin');      
             list<UserRole> UserRoles = TestingUtils.createRoles( Roles);
             insert UserRoles ;
             TestingUtils.clear_execution_flags();
             User newUser = TestingUtils.createUsers(1,p2.id,UserRoles[0].id);
             insert newUser ;
             TestingUtils.clear_execution_flags(); 
             
             }
            
        }
       public static testMethod void TestingUtilTestMethod2(){   
 
        UserRole Urole1 = [select id,name from UserRole where name='System Administrator']; 
        Profile p2 = [select id, name from profile where name Like '%System Admin%' limit 1];
        User u6 = TestingUtils.CreateUSer('genreral@test.com',p2.id, Urole1.id); 
        insert u6;
        TestingUtils.clear_execution_flags();
      
        List<General_Properties__c> profileCustomSetting = new list <General_Properties__c>(); 
         Date oppDate= system.today();
        string AccountRecTypeId = [SELECT id from RecordType where Name ='Broker AU (Motor/PL)'].Id;
        
                                    
     
        system.runas(u6){
                      
             profileCustomSetting = testingutils.CreategeneralProperties();                         
             insert profileCustomSetting; 
             
             List<Account> Acct = TestingUtils.accountCreation();         
              Integer ctr = 1;
             for(Account a : Acct)
             {
                a.RecordTypeId = AccountRecTypeId;
                a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
                ctr++;
             }
             insert Acct;
             TestingUtils.clear_execution_flags();              
             List<ABN_Balances__c> CreateABNBalance = TestingUtils.CreateABNBalance('ABC',0);
             insert CreateABNBalance ;
             TestingUtils.clear_execution_flags();

            }
            utils.get_apex_profile();
        }
       
    }