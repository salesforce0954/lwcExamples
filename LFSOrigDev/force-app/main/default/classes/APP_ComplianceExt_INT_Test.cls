@isTest
public with sharing class APP_ComplianceExt_INT_Test {

    static testMethod void Compliance_Test(){
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        //No meta records
        List<Account> testBrokerAccounts = TestDataBuilder.createAccounts(1);
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        Id brokerRecordTypeId = AccountRecordTypeInfo.get(GEN_OriginationsConstants.COMPLIANCE_BROKER).getRecordTypeId();
        testBrokerAccounts.get(0).RecordTypeId = brokerRecordTypeId;
        insert testBrokerAccounts;
                
        Contact testContact = new Contact();
        testContact.LastName = testBrokerAccounts.get(0).name;
        testContact.AccountId = testBrokerAccounts.get(0).id;
        
        /**TXU changed contact to satisfy new lookup filter for Application__c.Broker__C**/
        ID contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
        testContact.RecordTypeId = contactRecordTypeId;
        testContact.Contact_Accreditation_Status__c = 'Active';
        testContact.Broker_Product__c = GEN_OriginationsConstants.PL_BROKER_PRODUCT_FILTER;     //MLASALA: 21-MAR-16 TQLQW-127 Re-brand
        testContact.primary_contact__c = true;
        /**END**/    
        
        insert testContact;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;    

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Broker__c = testContact.Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false, testApplication.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(false);
        insert profileControl;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            User testUser = TestDataBuilder.createUser(profileId);
            insert testUser;

            system.runAs(testUser){
                Test.StartTest();
                    ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                    APP_ComplianceExt_INT compliance = new APP_ComplianceExt_INT(standardCon);
                    compliance.getPFRCheck();
                    //compliance.AcceptanceChannels();
                    List<SelectOption> acceptanceChannel = compliance.AcceptanceChannels;
                    compliance.getCollateralRecords();
                    compliance.showForm();
                    compliance.showAcceptance();
                    compliance.cancelAcceptance();
                    compliance.updateAcceptance();
                    compliance.cancel();
                    compliance.save();
                Test.StopTest();

                System.assertEquals(testApplication.Id, compliance.app.Id);
                System.assertEquals(testUser.Id, compliance.currentUser.Id);
                System.assertEquals(acceptanceChannel.size(), compliance.AcceptanceChannels.size());
                System.assert(!compliance.formState);
                System.assert(!compliance.acceptanceState);
                System.assert(compliance.isNew);
                System.assert(compliance.newEditComplianceButton);
                System.assert(compliance.collateralList.isEmpty());
                System.assert(compliance.complianceCheckList.isEmpty());
            }
        }
    }

    static testMethod void Compliance_Test2(){
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        //With new meta records, true , false
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
    
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Product_Id__c = testProduct.Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;


        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        responseCodeControl.Save_Collateral_Standard__c = true;
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            User testUser = TestDataBuilder.createUser(profileId);
            insert testUser;

            Insurance_Premium_Calculation_Variables__c insurance = TestDataBuilder.createInsurancePremiumCalculationVariable('counter', 15);
            insert insurance;

            Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
            insert testCollateralSettings;

            Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
            insert testCollateral;
            
            Meta_Compliance_Check__c testMCC = new Meta_Compliance_Check__c();
            insert testMCC;

            List<Meta_Compliance_Check_Line_Item__c> testMCCLI_List = TestDataBuilder.createMetaComplianceCheckLinteItem(2, true, false, testMCC.Id);
            testMCCLI_List.get(1).Section__c = '0';
            insert testMCCLI_List;

            List<Meta_Compliance_Pre_Settle__c> testMCPreS_List = TestDataBuilder.createMetaCompliancePreSettle(2, true, false, testMCC.Id);
            testMCPreS_List.get(1).Section__c = '0';
            insert testMCPreS_List;
            
            List<Meta_Compliance_Post_Settle__c> testMCPostS_List = TestDataBuilder.createMetaCompliancePostSettle(2, true, false, testMCC.Id);
            testMCPostS_List.get(1).Section__c = '0';
            insert testMCPostS_List;

            try{
            system.runAs(testUser){
                Test.StartTest();
                    ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                    APP_ComplianceExt_INT compliance = new APP_ComplianceExt_INT(standardCon);
                    compliance.refreshComplianceCheckList();
                    //compliance.getAcceptanceChannels();
                    //for(Integer i=0; i<(testMCCLI_List.size()+testMCPreS_List.size()+testMCPostS_List.size()); i++)
                    for(Integer i=0; i<compliance.complianceCheckList.size(); i++){
                        compliance.complianceCheckList.get(i).PFR_Check__c = 'Yes';
                    }
                    compliance.save();
                Test.StopTest();

                System.assertEquals(testApplication.Id, compliance.app.Id);
                System.assertEquals(testUser.Id, compliance.currentUser.Id);
                System.assert(!compliance.newEditComplianceButton);
              }  
            }catch(Exception e){}
        }
    }

    static testMethod void Compliance_Test3(){

        //With new meta records, false, true
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion; 

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Product_Id__c = testProduct.Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        responseCodeControl.Save_Collateral_Standard__c = true;
        insert responseCodeControl;

        Insurance_Premium_Calculation_Variables__c insurance = TestDataBuilder.createInsurancePremiumCalculationVariable('counter', 15);
        insert insurance;

        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
        insert testCollateralSettings;
        
        Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
        insert testCollateral;
        
        Meta_Compliance_Check__c testMCC = new Meta_Compliance_Check__c();
        insert testMCC;

        List<Meta_Compliance_Check_Line_Item__c> testMCCLI_List = TestDataBuilder.createMetaComplianceCheckLinteItem(2, false, true, testMCC.Id);
        insert testMCCLI_List;

        List<Meta_Compliance_Pre_Settle__c> testMCPreS_List = TestDataBuilder.createMetaCompliancePreSettle(2, false, true, testMCC.Id);
        insert testMCPreS_List;
        
        List<Meta_Compliance_Post_Settle__c> testMCPostS_List = TestDataBuilder.createMetaCompliancePostSettle(2, false, true, testMCC.Id);
        insert testMCPostS_List;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            User testUser = TestDataBuilder.createUser(profileId);
            insert testUser;
        try{
            system.runAs(testUser){
                Test.StartTest();
                    ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                    APP_ComplianceExt_INT compliance = new APP_ComplianceExt_INT(standardCon);
                Test.StopTest();

                System.assertEquals(testApplication.Id, compliance.app.Id);
                System.assertEquals(testUser.Id, compliance.currentUser.Id);
                System.assert(compliance.isNew);
                System.assertEquals(testMCC.Id, compliance.latestMCC.Id); 
            }
            }catch(Exception e){}
        }
    }

    static testMethod void Compliance_Test4(){
        //With compliance records (with pre settle)
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion; 

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Product_Id__c = testProduct.Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;


        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        responseCodeControl.Save_Collateral_Standard__c = true;
        insert responseCodeControl;

        Insurance_Premium_Calculation_Variables__c insurance = TestDataBuilder.createInsurancePremiumCalculationVariable('counter', 15);
        insert insurance;

        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
        insert testCollateralSettings;
        
        Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
        insert testCollateral;
        
        Meta_Compliance_Check__c testMCC = TestDataBuilder.createMetaComplianceCheck();
        insert testMCC;

        List<Meta_Compliance_Check_Line_Item__c> testMCCLI_List = TestDataBuilder.createMetaComplianceCheckLinteItem(2, false, true, testMCC.Id);
        insert testMCCLI_List;

        List<Meta_Compliance_Pre_Settle__c> testMCPreS_List = TestDataBuilder.createMetaCompliancePreSettle(2, false, true, testMCC.Id);
        insert testMCPreS_List;
        
        List<Meta_Compliance_Post_Settle__c> testMCPostS_List = TestDataBuilder.createMetaCompliancePostSettle(2, false, true, testMCC.Id);
        insert testMCPostS_List;

        Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
        testCompliance.Meta_Compliance_Check__c = testMCC.Id;
        insert testCompliance;

        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            User testUser = TestDataBuilder.createUser(profileId);
            insert testUser;

            system.runAs(testUser){
                Test.StartTest();
                    ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                    APP_ComplianceExt_INT compliance = new APP_ComplianceExt_INT(standardCon);
                Test.StopTest();

                System.assertEquals(testApplication.Id, compliance.app.Id);
                System.assertEquals(testUser.Id, compliance.currentUser.Id);
                System.assert(!compliance.isNew);
                System.assertEquals(testMCC.Id, compliance.latestMCC.Id);
            }
        }
    }

    static testMethod void Compliance_Test5(){
        //With compliance records (without pre settle)
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion; 
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Product_Id__c = testProduct.Id;
        insert testApplication;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;


        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
        responseCodeControl.Save_Collateral_Standard__c = true;
        insert responseCodeControl;

        Insurance_Premium_Calculation_Variables__c insurance = TestDataBuilder.createInsurancePremiumCalculationVariable('counter', 15);
        insert insurance;

        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
        insert testCollateralSettings;
        
        Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
        insert testCollateral;
        
        Meta_Compliance_Check__c testMCC = TestDataBuilder.createMetaComplianceCheck();
        insert testMCC;

        List<Meta_Compliance_Check_Line_Item__c> testMCCLI_List = TestDataBuilder.createMetaComplianceCheckLinteItem(2, false, true, testMCC.Id);
        insert testMCCLI_List;

        List<Meta_Compliance_Pre_Settle__c> testMCPreS_List = TestDataBuilder.createMetaCompliancePreSettle(2, false, true, testMCC.Id);
        insert testMCPreS_List;
        
        List<Meta_Compliance_Post_Settle__c> testMCPostS_List = TestDataBuilder.createMetaCompliancePostSettle(2, false, true, testMCC.Id);
        insert testMCPostS_List;

        Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
        testCompliance.Meta_Compliance_Check__c = testMCC.Id;
        testCompliance.Meta_Compliance_Pre_Settle__c = testMCPreS_List.get(0).Id;
        testCompliance.Meta_Compliance_Post_Settle__c = testMCPostS_List.get(0).Id;
        testCompliance.Meta_Compliance_Check_Line_Item__c = testMCCLI_List.get(0).Id;
        //testCompliance.Meta_Compliance_Check__c = testMCC.get(0).Id;
        insert testCompliance;
        
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;//query profile
        User adminUser = [SELECT Id FROM User WHERE ProfileId =: adminId AND UserRoleId != null AND IsActive = true LIMIT 1 ];
        System.runAs(adminUser) {
            User testUser = TestDataBuilder.createUser(profileId);
            insert testUser;

            system.runAs(testUser){
                Test.StartTest();
                    ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
                    APP_ComplianceExt_INT compliance = new APP_ComplianceExt_INT(standardCon);
                    compliance.flushPreSettleCompliance();
                    APP_ComplianceExt_INT.country='AU';
                    Meta_Compliance_Post_Settle__c mcp = new Meta_Compliance_Post_Settle__c();
                    Meta_Compliance_Check_Line_Item__c mci = new Meta_Compliance_Check_Line_Item__c();
                    APP_ComplianceExt_INT.checklistWrapper cw = new APP_ComplianceExt_INT.checklistWrapper();
                    cw.mccLineItem = mci;
                    cw.mcpostLineItem = mcp;
                   // compliance.refreshComplianceCheckList();
                Test.StopTest();

                List<Compliance_Check__c> preSettlementList = [SELECT Id FROM Compliance_Check__c WHERE Meta_Compliance_Pre_Settle__c != null AND Application__c =: testApplication.Id];
                List<Meta_Compliance_Check_Line_Item__c> mcc = [SELECT Id FROM Meta_Compliance_Check_Line_Item__c WHERE Id ='a0J000000K23KL9']; 
                System.assertEquals(testApplication.Id, compliance.app.Id);
                System.assertEquals(testUser.Id, compliance.currentUser.Id);
                System.assertEquals(true, preSettlementList.isEmpty());
                System.assertEquals(true, mcc.isEmpty());                
                System.assert(!compliance.isNew);
                
            }
        }
    }
}