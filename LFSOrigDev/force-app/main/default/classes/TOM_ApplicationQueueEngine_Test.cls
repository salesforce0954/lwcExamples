/*
 * @Description: Test class for TOM_ApplicationQueueEngine class
 * @Author: Tony Xu
 * @Date Created: 2016-03-10
 * @History:
   =====================================================================
       28-01-14: Created - TXU
   =====================================================================
 */

@isTest
private class TOM_ApplicationQueueEngine_Test {
	 
    static testMethod void VAR_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'VAR';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'VAR';
        insert testApplication2;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void POR_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'POR';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'POR';
        insert testApplication2;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void FBR_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'FBR';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'FBR';
        insert testApplication2;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void SAR_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'SAR';
        
        insert testApplication;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PCO';
		insert testApplicant;        
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'SAR';
        insert testApplication2;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication2.id);
        testApplicant2.Is_Primary_Applicant__c = true;
        testApplicant2.Response_Code__c = 'PCO';
		insert testApplicant2; 
        
        Applicant__c testApplicant3 = TestDataBuilder.createApplicant(null, testApplication2.id);
        
        testApplicant3.Response_Code__c = 'PCO';
		insert testApplicant3; 
        
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void FID_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'FID';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'FId';
        insert testApplication2;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void SCR_PCO_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'SCR';
        insert testApplication;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            ID ProfileID = [SELECT ID FROM Profile WHERE Name = 'A1 Customer Community Login'].ID;
            
            Account a = TestDataBuilder.createPersonAccount();
            insert a;
            
            Contact c = [SELECT ID FROM Contact WHERE AccountId = : a.id];
            
            User u = TestDataBuilder.createUser2(ProfileID);
            u.ContactId = c.id;
            insert u;        
            
            Application__c testApplication2 = TestDataBuilder.createApplication();
            testApplication2.Application_Type__c = 'Joint';
            testApplication2.Brand_Lookup__c = testBrand.Id;
            testApplication2.Response_Code__c = 'PCO';
            testApplication2.ownerId = u.id;
            insert testApplication2;
            
            Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication2.id);
            testApplicant2.Is_Primary_Applicant__c = true;
            testApplicant2.Response_Code__c = 'PCO';
            insert testApplicant2; 
            
            Applicant__c testApplicant3 = TestDataBuilder.createApplicant(null, testApplication2.id);
            
            testApplicant3.Response_Code__c = 'PCO';
            insert testApplicant3; 

            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
            Test.stopTest();
        }
    }
    
    static testMethod void New_Test(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Admin_Settings__c adm = new Admin_Settings__c();
        adm.name = 'Tom Enabled';
        adm.value__c = 'TRUE';
        insert adm;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Application_Type__c = 'Single';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'ERROR';
        insert testApplication;
        
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_Lookup__c = testBrand.Id;
        testApplication2.Response_Code__c = 'ERROR';
        insert testApplication2;
        
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            
            List<Application__c> appList = [SELECT ID, OwnerId, Response_Code__c, Application_Type__c FROM Application__c WHERE ID = :testApplication.id OR ID = :testApplication2.id];
            Test.startTest();
            	TOM_ApplicationQueueEngine taq = new TOM_ApplicationQueueEngine();
                taq.startProcess(appList);
               //Added the below lines to imporve the code coverage -- Suneel - 28/07/2017
                taq.getApplicants(appList[0]);
            	taq.assignToLPEQueue(appList[0]);
                taq.assignToDeclineQueue(appList[0]);
            Test.stopTest();
        }
    }
}