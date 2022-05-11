@isTest
private class APP_PwdChangeCC_Test {
    
    static testMethod void PasswordChange_Test() {
        //No user
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.Password_Reset_Token__c = '1234';
        testUser.Valid_Password_Reset_Timestamp__c = DateTime.now();
        insert testUser;
        System.runAs(testUser){
            Password_Reset__c pwReset = new Password_Reset__c(Validity_Period__c = 15);
            insert pwReset;
        
            Test.StartTest();
                APP_PwdChangeCC pwd = new APP_PwdChangeCC();
                ApexPages.currentPage( ).getParameters( ).put( 'token' , '9876');
                pwd.tokenCheck();
            Test.StopTest();
            
            Boolean isError;
            
            List<Apexpages.Message> msgs = ApexPages.getMessages(); 
            for(Apexpages.Message msg:msgs){
                if(msg.getDetail().contains('Password Reset Unavailable')){
                    isError = true;
                }
            }
            
            system.assert(isError);
        }
    }
    
    // static testMethod void PasswordChange_Test2() {
    //     //Passed time validity
    //     Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

    //     User testUser = TestDataBuilder.createUser(profileId);
    //     testUser.Password_Reset_Token__c = '1234';
    //     testUser.Password_Reset_Timestamp__c = datetime.now().addDays(-1);
    //     insert testUser;
    //     System.runAs(testUser){
    //         Password_Reset__c pwReset = new Password_Reset__c(Validity_Period__c = 15);
    //         insert pwReset;
        
    //         Test.StartTest();
    //             APP_PwdChangeCC pwd = new APP_PwdChangeCC();
    //             ApexPages.currentPage( ).getParameters( ).put( 'token' , '12345');
    //             pwd.tokenCheck();
    //         Test.StopTest();
            
    //         Boolean isError;
            
    //         List<Apexpages.Message> msgs = ApexPages.getMessages(); 
    //         for(Apexpages.Message msg:msgs){
    //             if(msg.getDetail().contains('Password Reset Unavailable')){
    //                 isError = true;
    //             }
    //         }
            
    //         system.assert(isError);
    //     }
    // }
    
    static testMethod void PasswordChange_Test3() {
        //Exception
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.Password_Reset_Token__c = '1234';
        testUser.Password_Reset_Timestamp__c = datetime.now();
        testUser.Valid_Password_Reset_Timestamp__c = DateTime.now();
        insert testUser;
        System.runAs(testUser){
            Password_Reset__c pwReset = new Password_Reset__c(Validity_Period__c = 15);
            insert pwReset;
        
            Test.StartTest();
                APP_PwdChangeCC pwd = new APP_PwdChangeCC();
                ApexPages.currentPage( ).getParameters( ).put( 'token' , '1234');
                ApexPages.currentPage( ).getParameters( ).put( 'mode' , 'Sales');
                pwd.tokenCheck();
                pwd.newPassword = '';
                pwd.confirmNewPassword = '';
                pwd.confirmPassword();
                pwd.newPassword = 'test';
                pwd.confirmNewPassword = 'test1';
                pwd.confirmPassword();
                pwd.confirmNewPassword = 'test';
                pwd.confirmPassword();
            Test.StopTest();
            
            system.assertEquals(pwd.newPassword, pwd.confirmNewPassword);
        }
    }
    
    static testMethod void PasswordChange_Test4() {
        //No errors Customer
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.Password_Reset_Token__c = '1234';
        testUser.Password_Reset_Timestamp__c = datetime.now();
        testUser.Valid_Password_Reset_Timestamp__c = DateTime.now();
        insert testUser;
        System.runAs(testUser){
            Password_Reset__c pwReset = new Password_Reset__c(Validity_Period__c = 15);
            insert pwReset;
        
            Test.StartTest();
                APP_PwdChangeCC pwd = new APP_PwdChangeCC();
                ApexPages.currentPage( ).getParameters( ).put( 'token' , '1234');
                ApexPages.currentPage( ).getParameters( ).put( 'mode' , 'Customer');
                pwd.tokenCheck();
                pwd.newPassword = 'test1234!';
                pwd.confirmNewPassword = 'test1234!';
                pwd.confirmPassword();
            Test.StopTest();
            
            system.assertEquals(pwd.newPassword, pwd.confirmNewPassword);
        }
    }
    
    static testMethod void PasswordChange_Test5() {
        //No errors Sales
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.Password_Reset_Token__c = '1234';
        testUser.Password_Reset_Timestamp__c = datetime.now();
        testUser.Valid_Password_Reset_Timestamp__c = DateTime.now();
        insert testUser;
        System.runAs(testUser){
            Password_Reset__c pwReset = new Password_Reset__c(Validity_Period__c = 15);
            insert pwReset;
        
            Test.StartTest();
                APP_PwdChangeCC pwd = new APP_PwdChangeCC();
                ApexPages.currentPage( ).getParameters( ).put( 'token' , '1234');
                ApexPages.currentPage( ).getParameters( ).put( 'mode' , 'Sales');
                pwd.tokenCheck();
                pwd.newPassword = 'test1234!';
                pwd.confirmNewPassword = 'test1234!';
                pwd.confirmPassword();
                pwd.birthDate='12';
                pwd.birthMonth='12';
                pwd.birthYear='12';
                pwd.confirmPassword();
                pwd.setDate();
                pwd.getmonthOptions();
                pwd.getDateOptions();
                pwd.birthDate='29';
                pwd.birthMonth='2';
                pwd.confirmPassword();
            Test.StopTest();
            
            system.assertEquals(pwd.newPassword, pwd.confirmNewPassword);
        }
    }
}