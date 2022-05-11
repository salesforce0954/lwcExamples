/*
* @Description: APP_LoginCC test class
* @Author: Jade Serrano
* @Date Created: 02-MAY-2014
* @History:
*  =====================================================================
*      Jade - 02-MAY-2014: Created
	   Tony Xu - 25/11/2014: Update to fix test issues
*  =====================================================================
*/
@isTest
private class APP_LoginCC_Test {    

    @TestSetup
    static void makeData(){
        Brand__c brand = TestDataBuilder.createBrand();
        brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
        insert brand;
    }

    @isTest static void test_method_one() {

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        system.assertNotEquals(null,profileId);//assert queried profile

        User user = TestDataBuilder.createUser(profileId);//create user
        insert user;
        system.assertNotEquals(null,user.Id);//assert inserted user

        system.runAs(user){

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = 'test@mail.com';
            controller.password = '';

            controller.login();

        }

    }

    @isTest static void test_method_two() {

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        system.assertNotEquals(null,profileId);//assert queried profile

        User user = TestDataBuilder.createUser(profileId);//create user
        insert user;
        system.assertNotEquals(null,user.Id);//assert inserted user

        system.runAs(user){

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = '';
            controller.password = 'test1234';

            controller.login();

        }

    }

    @isTest static void test_method_three() {

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        system.assertNotEquals(null,profileId);//assert queried profile

        User user = TestDataBuilder.createUser(profileId);//create user
        insert user;
        system.assertNotEquals(null,user.Id);//assert inserted user

        system.runAs(user){

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = '';
            controller.password = '';

            controller.login();

        }

    }

    @isTest static void test_method_four() {
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
            ProfileId = profile1.Id,
            UserRoleId = [SELECT ID FROM UserRole WHERE name = 'System Administrator'].id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@mail.com'
            );
            Database.insert(contact1);
        
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'A1 Customer Community Login' LIMIT 1].Id;//query profile
            system.assertNotEquals(null,profileId);//assert queried profile
    
            User user = TestDataBuilder.createUser(profileId);//create user
            user.ContactId = contact1.Id;
            user.UserRoleId = null;
            insert user;
            system.assertNotEquals(null,user.Id);//assert inserted user
    
            system.runAs(user){
    
                PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
                Test.setCurrentPageReference(pageRef);
    
                APP_LoginCC controller = new APP_LoginCC();
    
                controller.username = 'test@mail.com';
                controller.password = 'test123';
    
                controller.login();
    
            }        
        }

    }    

    @isTest static void OtherProfile_Test() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'A1 Originations Staff Profile' LIMIT 1].Id;//query profile
        system.assertNotEquals(null,profileId);//assert queried profile

        User user = TestDataBuilder.createUser(profileId);//create user
        insert user;
        system.assertNotEquals(null,user.Id);//assert inserted user

        system.runAs(user){

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();
            controller.passwordReset();

        }

    }

    @isTest static void InvalidUsernamePassword_Test() {
        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;        //Updated by Txu 25/11/2014
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        system.assertNotEquals(null,runAsUser.Id);//assert inserted user
        system.runAs(runAsUser){
            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = 'test';
            controller.password = 'test123';

            controller.login();

        }
    }

    @isTest static void NullBrand_Test() {
        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;        //Updated by Txu 25/11/2014
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){
            Account account = new Account();
            account.LastName = 'account';
            account.RecordTypeId = personAccountRecordTypeId;
            insert account;
            System.assertEquals(account.LastName,'account');//assert inserted Account

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: account.Id].Id;

            User user = new User();
            user.Username = 'username@username.com';
            user.Email = 'email@email.com';
            user.FirstName = 'firstname';    
            user.LastName = 'lastname';
            user.CommunityNickname = 'nickname';
            user.Date_Of_Birth__c = '01-01-1991';
            user.ProfileId = customerProfileId;
            user.Alias = 'emai';
            user.TimeZoneSidKey = 'GMT';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Password_Reset_Token__c = '12345qwert';
            user.Password_Reset_Attempts__c = 0;
            user.Valid_Password_Reset_Timestamp__c =  datetime.now();
            user.Password_Reset_Timestamp__c =  datetime.now();
            user.Title = 'Mr';
            user.ContactId = contactId;
            insert user;

            PageReference pageRef = Page.APP_Login;//ensure that APP_Login page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_LoginCC controller = new APP_LoginCC();

            controller.username = 'email@email.com';
            controller.password = 'test123';

            controller.login();

        }

    }
}