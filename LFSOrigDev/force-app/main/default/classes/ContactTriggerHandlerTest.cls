@isTest
public with sharing class ContactTriggerHandlerTest {

    public static testmethod void contact_testmethod1(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Accreditation AUS)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>(); 
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();
         
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        users.add(user1);
        insert users;
        Test.startTest();
        System.runAs(user1){ 
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;
            
            TestingUtils_disableTrigger(false,user1.ProfileID);
            
            RecordType rt = [SELECT r.SobjectType, r.Name, r.Id FROM RecordType r WHERE Name = 'Broker AU (Motor/PL)' AND SobjectType = 'Account'];
            // Account Creation
            List<Account> account = TestingUtils.createAccounts(5,'Agriculture',null);
            account[0].Type = 'Parent';
            account[0].RecordTypeId = rt.Id;
            insert account;
            AccountTriggerHandler.clear_execution_flags();
             
            List<Contact> primarycontact1 = TestingUtils.createContacts(1, account[0].Id);
            for(Contact con : primarycontact1){
                con.MobilePhone='09916684206';
                con.Salutation='Mr.';
                con.Copy_Account_Mailing_Address__c = true;  
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
            system.debug('insert1');
            try{
                insert primarycontact1;
            }catch(Exception e1){
                system.debug('A primary contact must be created');
                Boolean expectedExceptionThrown =  e1.getMessage().contains('A Primary Contact Must Be Created.') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }

            DoNotCall_Flag(false);
            
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact con : primarycontact){
                con.MobilePhone='09916684206';
                con.Salutation='Mr.';
                con.Primary_Contact__c = true;
                con.Copy_Account_Mailing_Address__c = true;  
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
            insert primarycontact;
            
            DoNotCall_Flag(false);
            system.assertequals(true,primarycontact[0].Primary_Contact__c);
            
            List<Contact> primarycontactupdate = [select Primary_Contact__c from contact where Id = :primarycontact[0].ID];
            primarycontactupdate[0].Primary_Contact__c = false;
            update primarycontactupdate;
            
            List<Contact> primarycontactupdate1 = [select Primary_Contact__c from contact where Id = :primarycontactupdate[0].ID];
            system.assertequals(true,primarycontactupdate1[0].Primary_Contact__c);
            
            DoNotCall_Flag(false);
            List<Contact> contacts = TestingUtils.createContacts(4, account[0].Id);
           
            for(Contact con : contacts){
                con.MobilePhone='09916684206';
                con.Salutation='Mr.';
                con.Copy_Account_Mailing_Address__c = true;
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
            try{
            insert contacts;
            }catch(Exception e111){}
            //system.assert for insert
            testassertion(contacts);
            DoNotCall_Flag(false);
            set<ID> contact_ids = new set<ID>();
            for(Contact con : contacts){
                contact_ids.add(con.ID);
            }
            
            List<Contact> contactupdate = [select Id,Primary_Contact__c,MailingState from contact where ID IN : contact_ids];           
            for(Contact con : contactupdate){
                con.Primary_Contact__c = true;
            }

            try{
                update contactupdate;
            }catch(Exception exx11){
                Boolean expectedExceptionThrown =  exx11.getMessage().contains('There are more than one primary!') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
  
            //system.assert for update
            testassertion(contactupdate);
                    
        }
         Test.stopTest();
         utils.get_apex_profile();  
    }

     public static testmethod void contact_testmethod2(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Sales Leader AU)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>(); 
        
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();  
               
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        //User user1 = new User(alias = 'stanU', email='standarduser@testorg.com', Country='China', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', localesidkey='en_IN', 
        //              profileid = profile1.Id, timezonesidkey='America/Los_Angeles', username='standardchnuser@testorg.com',Business_Unit__c = 'Marketing (MKT)',userRoleId=role1.Id);
        users.add(user1);
        RecordType rt = [SELECT r.SobjectType, r.Name, r.Id FROM RecordType r WHERE Name = 'Broker AU (Motor/PL)' AND SobjectType = 'Account'];
        insert users;
        System.runAs(user1){ 
            Test.startTest();
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;
            
            TestingUtils_disableTrigger(false,user1.ProfileID);
            
            // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(5,'Agriculture',null);
            account[0].RecordTypeId = rt.Id;
            account[0].Site = 'Tonnistha Test Account'; 
            account[0].Phone = '07829222988';
            account[0].BillingCity = 'Sanhai';
            account[0].BillingCountry = 'China';
            insert account;
            AccountTriggerHandler.clear_execution_flags();
            
           system.debug('@@account'+account);
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact cont : primarycontact){
                cont.OtherCountry  = 'China';
                cont.MailingCountry ='China';
                cont.OwnerId=user1.Id;
                cont.OtherStreet = 'M G Road';
                cont.OtherState = 'Sanhai';
                cont.OtherPostalCode = '4251786';
                cont.OtherCity = 'Sanhai';
                cont.Copy_Account_Mailing_Address__c = true;
                cont.Primary_Contact__c = true;
                cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
           // try{
            insert primarycontact;
            
            DoNotCall_Flag(false);
            
            List<Contact> primarycontact2 = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact cont : primarycontact2){
                cont.OtherCountry  = 'China';
                cont.MailingCountry ='China';
                cont.OwnerId=user1.Id;
                cont.OtherStreet = 'M G Road';
                cont.OtherState = 'Sanhai';
                cont.OtherPostalCode = '4251786';
                cont.OtherCity = 'Sanhai';
                cont.Copy_Account_Mailing_Address__c = true;
                cont.Primary_Contact__c = true;
                cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
           // try{
            insert primarycontact2;
            
            system.assertequals(false,[select Primary_Contact__c from contact where id =:primarycontact[0].id].Primary_Contact__c);
            
           // }catch(exception ex1){system.debug('Error##'+ex1);}
            List<Contact> contactupdate = [select Id,Primary_Contact__c ,MailingStreet,MailingState,MailingPostalCode,MailingCity,OtherStreet,OtherState,OtherPostalCode,OtherCity from Contact where 
                                            Id = :primarycontact[0].Id];
            for(Contact Cc : contactupdate){
                Cc.MailingStreet = 'M G Road';
                Cc.MailingState = 'Sanhai';
                Cc.MailingPostalCode = '4251786';
                Cc.MailingCity = 'Sanhai';
            }
            update contactupdate;
            
            Test.stopTest();
        }
        utils.get_apex_profile();  
    }
    
     public static testmethod void contact_negativetestmethod(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Accreditation AUS Broker)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>(); 
        
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();  
               
        //BEGIN MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        users.add(user1);
        Profile profile2 = [Select id,Name from profile where Name = '~ Consumer (Sales Leader AU)'];
        User user2 = TestingUtils.CreateUSer('testing2'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile2.Id,role1.Id);
        //END MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        users.add(user2);
        
        insert users;
        Test.startTest();
        System.runAs(user1){ 
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;
            
            TestingUtils_disableTrigger(false,user1.ProfileID);  
                    
            ContactTriggerHandler.validateSinglePrimary(null, null);
            ContactTriggerHandler.validateSinglePrimary_before(null, null);
            
            DoNotCall_Flag(false);
            // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(5, 'Agriculture',null);
            insert account;
            AccountTriggerHandler.clear_execution_flags();
             
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact con : primarycontact){
                con.MobilePhone='09916684206';
                con.Salutation='Mr.';
                con.Primary_Contact__c = true;
                con.Copy_Account_Mailing_Address__c = true;   
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
            insert primarycontact;
            update primarycontact;          
        }
        System.runAs(user2){ 

             // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(3, 'Agriculture',null);
            insert account;
            
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact con : primarycontact){
                con.MobilePhone='09916684206';
                con.Salutation='Mr.';
                con.Primary_Contact__c = true;
                con.Copy_Account_Mailing_Address__c = true;   
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
            }
            insert primarycontact;
            //update primarycontact;
        }
      Test.stopTest();  
      utils.get_apex_profile();  
    }
    
    public static testmethod void contact_negativetestmethod2(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Sales Leader AU)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>();
        
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();  
               
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        users.add(user1);
        insert users;
        
        Test.startTest();
        System.runAs(user1){ 
            
            TestingUtils_disableTrigger(true,user1.ProfileID);
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;  

            // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(5, 'Agriculture',null);
            insert account;
            AccountTriggerHandler.clear_execution_flags();
            
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact con : primarycontact){
                    con.MobilePhone='09916684206';
                    con.Salutation='Mr.';
                    con.Primary_Contact__c = true;
                con.Copy_Account_Mailing_Address__c = true;   
            }
            insert primarycontact;
            update primarycontact;          
        }
       
      Test.stopTest(); 
      utils.get_apex_profile();   
    }
    
    private static void testassertion(List<Contact> contacts){
         set<ID> contact_ids = new set<ID>();
            for(Contact con : contacts){
                contact_ids.add(con.ID);
            }

            for(Contact con : [select MailingState,OtherState,Copy_Account_Mailing_Address__c,MailingStreet,
                                OtherStreet,MailingPostalCode,OtherPostalCode,MailingCity,OtherCity FROM Contact where id IN :contact_ids]){
                
                if(con.Copy_Account_Mailing_Address__c){
                    system.assertequals(con.MailingStreet,con.OtherStreet);
                    system.assertequals(con.MailingState,con.OtherState);
                    system.assertequals(con.MailingPostalCode,con.OtherPostalCode);
                    system.assertequals(con.MailingCity,con.OtherCity);
                }
            }
    }
    

    public static testmethod void contact_negativetestmethod3(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Sales Leader AU)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>();
        
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();  
               
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        users.add(user1);
        insert users;
        System.runAs(user1){
            test.startTest();
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;
            
            // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(5, 'Agriculture',null);
            insert account;
            AccountTriggerHandler.clear_execution_flags();
            
            List<Contact> cont = new List<Contact>();
            cont.add(new Contact(firstname = 'test'));          
            try{
                insert cont;
            }catch(DMLException e){
                ContactTriggerHandler.handle_exception(e,cont);
            }
            List<Contact> cont1 = new List<Contact>();
            cont1.add(new Contact(lastname = 'test'));

            try{
                insert cont1;
            }catch(DMLException e){
                ContactTriggerHandler.handle_exception(e,cont1);
            }
            List<Contact> cont2 = new List<Contact>();
            cont2.add(new Contact(lastname = 'test',
                                MobilePhone='09916684206',
                                Salutation='Mr.',
                                Primary_Contact__c = true,
                                Copy_Account_Mailing_Address__c = true, 
                                Account = account[0]));
            try{
                insert cont2;
            }catch(DMLException e){
                ContactTriggerHandler.handle_exception(e,cont2);
            }
            system.assertEquals(cont[0].Primary_Contact__c,false);
            system.assertEquals(cont1[0].Primary_Contact__c,false);
            system.assertEquals(cont2[0].Primary_Contact__c,true);
            test.stopTest();
        }
    }


    public static testmethod void contact_negativetestmethod4(){
        Profile profile1 = [Select id from profile where name='~ Consumer (Sales Leader AU)'];
        UserRole role1 = [select id from UserRole where name='System Administrator']; 
        List<User> users = new List<User>();
        
        General_Properties__c customSettingData = new General_Properties__c ();
        list<Allowed_Record_Type__c>customSettingDatarecordtype = new list <Allowed_Record_Type__c>();  
               
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        User user1 = TestingUtils.CreateUSer('testing1'+GEN_OriginationsConstants.COMMUNITY_USER_EMAIL_PREFIX,profile1.Id,role1.Id);
        users.add(user1);
        insert users;
        
        Test.startTest();
        System.runAs(user1){ 
            
            TestingUtils_disableTrigger(true,user1.ProfileID);
            
            customSettingData = testingutils.CreateCustomSetting ('ProfilesExcludedInCodeExecution','~System Administrator');
            insert customSettingData;
            
            customSettingDatarecordtype = TestingUtils.createCustomSettingData();
            insert customSettingDatarecordtype;  

            // Account Creation
            List<Account> account = TestingUtils.CreateAccounts(5, 'Agriculture',null);
            insert account;
            AccountTriggerHandler.clear_execution_flags();
            
            List<Contact> primarycontact = TestingUtils.createContacts(1, account[0].Id);   
            for(Contact con : primarycontact){
                con.Primary_Contact__c = false;   
            }
            try{
                insert primarycontact;
                update primarycontact; 
            }catch(DMLException e){
                ContactTriggerHandler.handle_exception(e,primarycontact);
                Boolean expectedExceptionThrown =  e.getMessage().contains('A Primary Contact Must Be Created.') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
                     
        }

       
      Test.stopTest(); 
      utils.get_apex_profile();   
    }
    
    static void TestingUtils_disableTrigger(Boolean isDisable,Id profileId){
        TestingUtils.disableTriggerCustSetting(isDisable, profileId,'ContactTrigger');
    }
    static void DoNotCall_Flag(Boolean val){
        ContactTriggerHandler.DoNotCall_validateSinglePrimary = val;
        ContactTriggerHandler.DoNotCall_validateSinglePrimary_before = val;
        
    }
}