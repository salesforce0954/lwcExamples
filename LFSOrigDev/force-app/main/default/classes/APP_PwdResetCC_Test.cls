@isTest
private class APP_PwdResetCC_Test {    
    
    @isTest static void test_method_one() {

        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;        
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;			//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
            account.LastName = 'account';
			account.FirstName = 'test';
            account.RecordTypeId = personAccountRecordTypeId;
            insert account;
            System.assertEquals(account.LastName,'account');//assert inserted Account

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: account.Id].Id;

            User user = new User();
            user.Username = 'username@username.com';
            user.Email = 'email@email.com';
            user.FirstName = 'firstname';    
            user.LastName = 'lastname';
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            user.Brand__c = String.valueOf(application.Brand_String__c);
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

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@email.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1991';
            controller.siteName = 'GE_Money_AU';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();
            controller.timeOut();

        }


    }
    
    @isTest static void test_method_two() {

        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;			//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
            account.LastName = 'account';
			account.FirstName = 'test';
            account.RecordTypeId = personAccountRecordTypeId;
            insert account;
            System.assertEquals(account.LastName,'account');//assert inserted Account

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: account.Id].Id;

            User user = new User();
            user.Username = 'username@username.com';
            user.Email = 'email@email.com';
            user.FirstName = 'firstname';    
            user.LastName = 'lastname';
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            user.Brand__c = String.valueOf(application.Brand_String__c);
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

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@email.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1992';
            controller.siteName = 'GE_Money_AU';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();

        }


    }

    @isTest static void test_method_three() {

        APP_PwdResetCC controller = new APP_PwdResetCC();
        //controller.emailAddress = 'email@email.com';
        controller.birthDate = '01';
        controller.birthMonth = '01';
        controller.birthYear = '1992';
        controller.siteName = 'GE_Money_AU';
        controller.generateToken(10);
        controller.setDate();
        controller.getmonthOptions();
        controller.resetPassword();

        APP_PwdResetCC controller2 = new APP_PwdResetCC();
        controller2.emailAddress = 'email@email.com';
        /*controller2.birthDate = '01';
        controller2.birthMonth = '01';
        controller2.birthYear = '1992';*/
        controller2.siteName = 'GE_Money_AU';
        controller2.generateToken(10);
        controller2.setDate();
        controller2.getmonthOptions();
        controller2.resetPassword();

        APP_PwdResetCC controller3 = new APP_PwdResetCC();
        //controller3.emailAddress = 'email@email.com';
        controller3.birthDate = '29';
        controller3.birthMonth = '2';
        controller3.birthYear = '1992';
        controller3.siteName = 'GE_Money_AU';
        controller3.generateToken(10);
        controller3.setDate();
        controller3.getmonthOptions();
        controller3.resetPassword();

        APP_PwdResetCC controller4 = new APP_PwdResetCC();
        //controller4.emailAddress = 'email@email.com';
        controller4.birthDate = '29';
        controller4.birthMonth = '2';
        controller4.birthYear = '1991';
        controller4.siteName = 'GE_Money_AU';
        controller4.generateToken(10);
        controller4.setDate();
        controller4.getmonthOptions();
        controller4.resetPassword();

        APP_PwdResetCC controller5 = new APP_PwdResetCC();
        //controller5.emailAddress = 'email@email.com';
        controller5.birthDate = '01';
        controller5.birthMonth = '04';
        controller5.birthYear = '1992';
        controller5.siteName = 'GE_Money_AU';
        controller5.generateToken(10);
        controller5.setDate();
        controller5.getmonthOptions();
        controller5.resetPassword();

    }

    @isTest static void test_method_four() {

        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;			//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
            account.LastName = 'account';
			account.FirstName = 'test';
            account.RecordTypeId = personAccountRecordTypeId;
            insert account;
            System.assertEquals(account.LastName,'account');//assert inserted Account

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: account.Id].Id;

            User user = new User();
            user.Username = 'username@username.com';
            user.Email = 'email@email.com';
            user.FirstName = 'firstname';    
            user.LastName = 'lastname';
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            user.Brand__c = String.valueOf(application.Brand_String__c);
            user.Date_Of_Birth__c = '01-01-1991';
            user.ProfileId = customerProfileId;
            user.Alias = 'emai';
            user.TimeZoneSidKey = 'GMT';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Password_Reset_Token__c = '12345qwert';
            user.Password_Reset_Attempts__c = 5;
            user.Valid_Password_Reset_Timestamp__c =  datetime.now();
            user.Password_Reset_Timestamp__c =  datetime.now();
            user.Title = 'Mr';
            user.ContactId = contactId;
            insert user;

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@email.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1991';
            controller.siteName = 'GE_Money_AU';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();

        }

    }

    @isTest static void test_method_five() {

        Id customerProfileId =  [Select Id From Profile Where Name =: GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1].Id;
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            application.Brand_String__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.GEMONEY_AU_SITENAME ;
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
			account.FirstName = 'test';
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
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            user.Brand__c = String.valueOf(application.Brand_String__c);
            user.Date_Of_Birth__c = '01-01-1991';
            user.ProfileId = customerProfileId;
            user.Alias = 'emai';
            user.TimeZoneSidKey = 'GMT';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Password_Reset_Token__c = '12345qwert';
            user.Password_Reset_Attempts__c = 5;
            user.Valid_Password_Reset_Timestamp__c =  datetime.now();
            user.Password_Reset_Timestamp__c =  datetime.now();
            user.Title = 'Mr';
            user.ContactId = contactId;
            insert user;

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@ge.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1992';
            controller.siteName = 'GE_Money_AU';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();
            user.Password_Reset_Attempts__c = 4;
            update user;
            controller.updateUser(user, false);
            controller.updateUser(user, true);
            
            controller.emailAddress = user.Email;
            controller.dob =user.Date_of_Birth__c;
            controller.sitename= GEN_OriginationsConstants.GEMONEY_AU_SITENAME;
            
            controller.resetPassword();
            
            
         
            
        }

    }

    @isTest static void test_method_six() {

        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;			//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
			account.FirstName = 'test';
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
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            user.Brand__c = String.valueOf(application.Brand_String__c);
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

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@email.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1991';
            controller.siteName = 'Aussie';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();

        }

    }

    @isTest static void test_method_seven() {

        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Originations'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User runAsUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        system.runAs(runAsUser){

            Application__c application = TestDataBuilder.createApplication();//create application
            application.Response_Code__c = 'New';
            insert application;
            System.assertNotEquals(null,application.Id);//assert inserted Application__c

            Brand__c brand = new Brand__c();
            brand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;			//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            brand.Site__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
            insert brand;
            System.assertNotEquals(null,brand.Id);//assert inserted Brand__c

            Account account = new Account();
			account.FirstName = 'test';
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
			user.First_Name__c = 'frstname';
			user.Last_Name__c = 'lastname';
            user.CommunityNickname = 'nickname';
            user.AppId__c = String.valueOf(application.Id);
            //user.Brand__c = String.valueOf(application.Brand_String__c);
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

            PageReference pageRef = Page.APP_PwdReset;//ensure that APP_PwdReset page is being tested
            Test.setCurrentPageReference(pageRef);

            APP_PwdResetCC controller = new APP_PwdResetCC();
            controller.emailAddress = 'email@email.com';
            controller.birthDate = '01';
            controller.birthMonth = '01';
            controller.birthYear = '1991';
            controller.siteName = 'GE_Money_AU';
            controller.generateToken(10);
            controller.setDate();
            controller.getmonthOptions();
            controller.resetPassword();

        }

    }

}