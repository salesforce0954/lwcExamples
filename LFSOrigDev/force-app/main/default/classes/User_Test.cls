@isTest
public class User_Test {
    @TestSetup
    static void makeData() {
        Profile profileId = [SELECT ID from Profile where Name = 'Latitude Profile' LIMIT 1];
        User guestUser = TestDataBuilder.createUser(profileId.Id);
        guestUser.Username = 'Dummy@lfs.com';
        guestUser.CommunityNickname = 'Test Nickname Community';
        guestUser.UserRoleId = null;
        insert guestUser;
    }

    static testMethod void UpdateUser_Test() {
        Id customerProfileId =  [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        System.runAs(adminUser){
            Account testPersonAccount = TestDataBuilder.createPersonAccount();
            insert testPersonAccount;

            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: testPersonAccount.Id].Id;

            User testUser = TestDataBuilder.createUser2(customerProfileId);
            testUser.ContactId = contactId;
            insert testUser;

            Test.StartTest();
                testUser.Email = 'test@ge.com';
                update testUser;
                
            Test.StopTest();
            
            Contact testContact = [SELECT Id, Email FROM Contact WHERE AccountId =: testPersonAccount.Id];
            //System.assertEquals('test@ge.com', testContact.Email);
        }
    }

    static testMethod void SendEmail_Test() {
        
        Id customerProfileId = [Select Id From Profile Where Name = 'A1 Customer Community Login'].Id;
        Id sysAdId = [Select Id From Profile Where Name = 'System Administrator'].Id;

        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        System.runAs(adminUser){
            Account testPersonAccount = TestDataBuilder.createPersonAccount();
            testPersonAccount.ownerId = adminUser.id;
            insert testPersonAccount;

            Contact testContact = [SELECT Id, Email FROM Contact WHERE AccountId =: testPersonAccount.Id];
            testContact.Email = 'test@mail.com';
            update testContact;

            User testUser = TestDataBuilder.createUser2(customerProfileId);
            testUser.ContactId = testContact.Id;
            testUser.Brand__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
            insert testUser; 

            Brand__c testBrand = TestDataBuilder.createBrand();
            testBrand.Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY;
            testBrand.Template_Password_Reset__c = 'test'+System.today().month()+'_'+System.today().year()+'_'+System.today().day();
            testBrand.OrgWide_Email_Address__c = 'Latitude Personal Loans';
            insert testBrand;

            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Response_Code__c = 'Test';
            insert testApplication;
    
            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant;
     
            EmailTemplate testEmailTemplate = new EmailTemplate();
            testEmailTemplate.DeveloperName = 'test'+System.today().month()+'_'+System.today().year()+'_'+System.today().day();
            testEmailTemplate.FolderId = UserInfo.getOrganizationId();
            testEmailTemplate.TemplateType = 'Text';
            testEmailTemplate.Name = 'test'+System.today().month()+'_'+System.today().year()+'_'+System.today().day();
            testEmailTemplate.IsActive = true;
            insert testEmailTemplate;

            Test.StartTest();
            UserTriggerHandler UTH = new UserTriggerHandler();
            UTH.sendEmail(testUser);
            UserUtility.checkApplicationStatus(testApplication.id);
            UserUtility.nextPage(testApplication.id);
            UserUtility.pageName();
            UserUtility.setPassword('a@a.com', 'password', 'a@a.com', string.valueof(system.today()));
            UserUtility.updateAppId(testUser.id, testApplication.id, testBrand.id);
            UserUtility.searchEmailAddresses('test@mail.com');
            UserUtility ut = new UserUtility();
            ut.hasExistingUser(testApplicant);
            Test.StopTest();
        }
    }

    static testMethod void CreateCommunityUser_Test() {
        //Authenticated
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Test.StartTest();
            UserUtility userUtil = new UserUtility();
            userUtil.registerPassword = 'test1234';
            userUtil.createCommunityUser(testApplication, testApplicant);
            userUtil.generateRandomPassword();
            userUtil.updateApplicantFromRegister(testApplicant);
            userutil.updateUserFromApplicant(testApplicant);
            userutil.getUserRedirectURL(testApplication.id);
            
        Test.StopTest();
        
        System.assertEquals(testApplication.Id, testApplicant.Application__c);
    }
 
    static testMethod void CreateCommunityUser_Test2() {
        //Unauthenticated
        //No existing user
		
        User guestUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1 ];
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;        

        System.runAs(guestUser){
            UserUtility userUtil = new UserUtility();
            userUtil.createCommunityUser(testApplication, testApplicant);
        }
    }
    
   /* static testMethod void CreateCommunityUser_Test2() {
        //Unauthenticated
        //No existing user
        Account testPersonAccount = TestDataBuilder.createPersonAccount();
        insert testPersonAccount;
        Id contactId = [SELECT Id FROM Contact WHERE AccountId =: testPersonAccount.Id].Id;    
        Id customerProfileId =  [Select Id From Profile Where Name = 'Customer Community Login'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        System.runAs(adminUser){
            User testUser = TestDataBuilder.createUser(customerProfileId);
            testUser.ContactId = contactId;
            insert testUser;
            
            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Response_Code__c = 'Test';
            testApplication.Brand_String__c = 'Test';           
            insert testApplication;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            insert testApplicant;

            System.runAs(testUser){
                Test.StartTest();
                    UserUtility userUtil = new UserUtility();
                    userUtil.createCommunityUser(testApplication, testApplicant);
                Test.StopTest();
            }
            
            System.assertEquals(testApplication.Id, testApplicant.Application__c);
        }
    }

    static testMethod void CreateCommunityUser_Test3() {
        //Unauthenticated
        //No existing user
        Account testPersonAccount = TestDataBuilder.createPersonAccount();
        insert testPersonAccount;
        Id contactId = [SELECT Id FROM Contact WHERE AccountId =: testPersonAccount.Id].Id;
        Id customerProfileId =  [Select Id From Profile Where Name = 'Customer Community Login'].Id;
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

        System.runAs(adminUser){
            User testUser = TestDataBuilder.createUser(customerProfileId);
            testUser.ContactId = contactId;
            insert testUser;
            
            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Response_Code__c = 'Test';
            testApplication.Brand_String__c = 'Test';           
            insert testApplication;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Email_Address__c = null;
            testApplicant.First_Name__c = null;
            testApplicant.Last_Name__c = null;
            testApplicant.Date_of_Birth__c = null;
            insert testApplicant;

            System.runAs(testUser){
                Test.StartTest();
                    UserUtility userUtil = new UserUtility();
                    userUtil.createCommunityUser(testApplication, testApplicant);
                Test.StopTest();
            }
            
            System.assertEquals(testApplication.Id, testApplicant.Application__c);
        }
    }
*/
    static testMethod void UpdateApplicant_Test() {
        Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

//        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];


        System.runAs(adminUser){
            User testUser = TestDataBuilder.createUser(sysAdId);
            testUser.Email = 'test@ge.com';
            insert testUser;

            Application__c testApplication = TestDataBuilder.createApplication();
            testApplication.Response_Code__c = 'Test';
            insert testApplication;

            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
            testApplicant.Email_Address__c = 'test@mail.com';
            insert testApplicant;

            Test.StartTest();
                UserUtility userUtil = new UserUtility();
                userUtil.registerEmail = 'test1234@mail.com';
                userUtil.registerDateOfBirth = testApplicant.Date_of_Birth__c;
                userUtil.updateApplicantFromRegister(testApplicant);
                userUtil.hasExistingUser(testApplicant);
            Test.StopTest();
            
            System.assertEquals(testApplicant.Email_Address__c, userUtil.registerEmail);
        }
    }
    
    static testMethod void UpdateApplicant_Test2() {
		Id sysAdId =  [Select Id From Profile Where Name = 'System Administrator'].Id;   
//       User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: sysAdId AND UserRoleId != null AND IsActive = true LIMIT 1 ];

		Test.StartTest();
        System.runAs(adminUser){
			runHasExistingUser();
            
            //System.assertEquals(testApplicant.Email_Address__c, userUtil.registerEmail);
        }
        Test.StopTest();
    }    

    @future static private void runHasExistingUser() {
        List<RecordType> origCustId = [SELECT ID From RecordType Where SObjectType='Account' AND Name = 'Originations - Customer' LIMIT 1];
    
        List<Account> acc = TestDataBuilder.createPersonAccounts(1);
		acc[0].RecordTypeId = origCustId[0].Id;        
        insert acc;
    
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Response_Code__c = 'Test';
        insert testApplication2;            

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Email_Address__c = 'test@mail.com';
        testApplicant.Account__c = acc[0].Id;
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication2.Id);
        testApplicant2.Email_Address__c = 'test@mail.com';
        testApplicant2.Account__c = acc[0].Id;
        insert testApplicant2;            

        UserUtility userUtil = new UserUtility();
        userUtil.registerEmail = 'test1234@mail.com';
        userUtil.registerDateOfBirth = testApplicant.Date_of_Birth__c;
        userUtil.updateApplicantFromRegister(testApplicant);
        userUtil.hasExistingUser(testApplicant2);
    } 
    
    static testMethod void GetUserRedirectURL_Test() {
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Test.StartTest();
            PageReference pageRef = Page.APP_Register;
            Test.setCurrentPageReference(pageRef);
            UserUtility userUtil = new UserUtility();
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_main?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.App_JointIncome;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_jointexpenses?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.APP_JointPersonalDetails;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_jointincome?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.App_JointExpenses;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_jointassets?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.App_JointAssets;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_jointdebtandliabilities?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.App_JointDebtAndLiabilities;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_main?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));

            pageRef = Page.APP_Eligibility;
            Test.setCurrentPageReference(pageRef);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_jointpersonaldetails?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));
        Test.StopTest();
    }

    static testMethod void CompletePage_Test() {
        //Joint
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
        insert testIncome2;

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
        insert testExpense2;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        Test.StartTest();
            PageReference pageRef = Page.APP_Eligibility;
            Test.setCurrentPageReference(pageRef);
            UserUtility userUtil = new UserUtility();
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_main?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));
        Test.StopTest();
    }

    static testMethod void CompletePage_Test2() {
        //Single
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Asset_Exempt__c = true;
        testApplicant.Debts_Exempt__c = true;
        insert testApplicant;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        insert testDebt;

        Test.StartTest();
            PageReference pageRef = Page.APP_Eligibility;
            Test.setCurrentPageReference(pageRef);
            UserUtility userUtil = new UserUtility();
            userUtil.hasExistingUser(testApplicant);
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_main?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));
        Test.StopTest();
    }

    static testMethod void CompletePage_Test3() {
        //Single debt payout = true
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Asset_Exempt__c = true;
        testApplicant.Total_Debts__c = 0;
        insert testApplicant;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
        insert testIncome;

        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
        insert testExpense;

        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
        testDebt.Acknowledge_Payout__c = true;
        insert testDebt;

        Test.StartTest();
            PageReference pageRef = Page.APP_Eligibility;
            Test.setCurrentPageReference(pageRef);
            UserUtility userUtil = new UserUtility();
            userUtil.getUserRedirectURL(testApplication.Id);
            System.assertEquals('/app_main?Id='+testApplication.Id, userUtil.getUserRedirectURL(testApplication.Id));
        Test.StopTest();
    }
    
    
}