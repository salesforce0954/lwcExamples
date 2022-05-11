/*
Author: August Del Rosario Cloud Sherpas
Created Date: Febuary 25, 2014
Description: Test Coverage for APP_Workflow_EXT_INT
Update: 
        Adrian Recio (26/08/2015) : Updated WorkFlowListMethod test method to 
                                    acommodate new ownership update validation in application trigger.
*/
@isTest
public with sharing class APP_Workflow_EXT_INT_Test {
    
    static testMethod void WorkFlowListMethod(){        
        
        Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
        Id roleId = [SELECT Id FROM UserRole where DeveloperName = 'BM' LIMIT 1].Id;

        User testUser = TestDataBuilder.createUser(profileId);
        testUser.UserRoleId = roleId;
        insert testUser;
        
        System.runAs(testUser){
        
        //MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        NZ_Specific_Settings__c nz = TestDataBuilder.createNZSpecificSettings();
        insert nz;
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Id profileId2 =  [Select Id From Profile Where Name = 'A1 Originations Staff Profile'].Id;
        Id roleId2 = [SELECT Id, developerName FROM UserRole where DeveloperName = 'CPU' LIMIT 1].Id;

        User testUser2 = TestDataBuilder.createUser2(profileId2);
        testUser2.UserRoleId = roleId2;
        insert testUser2;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Adjusted_Interest_Rate_Locked__c = true;
        testApplication.Response_Code__c = 'SCR';
        testApplication.Brand_Lookup__c = testBrand.Id;
        insert testApplication;
        
        // Added as part of AU APOI
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
        
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;

        //Ended as part of AU EPOI
 
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
       
        Insurance_Premium_Calculation_Variables__c insuranceVariable = TestDataBuilder.createInsurancePremium();
        insert insuranceVariable;

        Id recordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Workflow__c' AND DeveloperName =: 'Risk_Referral'].Id;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        //response code
        Response_Code_Control__c testResponseCodeCtrl = new Response_Code_Control__c();
        testResponseCodeCtrl.Name = 'New';
        testResponseCodeCtrl.Risk_Referral__c = true;
        insert testResponseCodeCtrl;

        //profile control
        Profile_Control__c testProfileControl = new Profile_Control__c();
        testProfileControl.Name = 'System Administrator';
        testProfileControl.Risk_Referral__c = true;
        insert testProfileControl;
        
        Response_Code_Control__c testResponseCodeControl = new Response_Code_Control__c();
        testResponseCodeControl.Name = 'SCR';
        testResponseCodeControl.Risk_Referral__c = true;
        insert testResponseCodeControl;

        // Added by: Adrian Recio
        // Change Date: 26/08/2015
        // Description: Updated test class to acommodate new ownership 
        //              assignment validation in application trigger.
        // Create test valid brand assignment
        List<Brand_Assignment__c> baList = new List<Brand_Assignment__c>();
        Brand_Assignment__c baVar = testDataBuilder.createBrandAssignment(testUser2.Id,testBrand.Id);
        baList.add(baVar);
        insert baList;

        List<Workflow__C> worfFlowList  = new List<Workflow__C>();
        Workflow__C testWorkflow = TestDataBuilder.createWorkflow(testApplication.Id, testUser.Id, recordTypeId);
        testWorkflow.Locked_L1__c = true;
        testWorkflow.Risk_CPU_Decision__c = null;
        testWorkflow.Risk_BM_Decision__c = 'Approved';
        worfFlowList.add(testWorkflow);
        insert worfFlowList;
        system.debug('======>'+testWorkFlow);
        testApplication.OwnerId = testUser2.Id;
        update testApplication;

        Test.startTest();
            System.runAs(testUser2){
                testWorkflow.Risk_CPU_Decision__c = 'Approve';
                testWorkflow.Status__c = 'CPU - Approve';
                testWorkflow.Assigned_To_2__c = testUser2.Id;
                testWorkflow.Approval_Description__c = 'test';
                update testWorkflow;

                ApexPages.StandardController workflowPage = new ApexPages.StandardController(testApplication);
                APP_Workflow_EXT_INT appWFExtInt = new APP_Workflow_EXT_INT(workflowPage);
                appWFExtInt.workflowList = worfFlowList;
                appWFExtInt.refreshWorkFlowList();
            }
        Test.StopTest();    
        system.debug('======>'+testApplication);
        system.debug('======>'+testWorkFlow);
        Application_Response__c appResponse = [SELECT Id, Application__c, Max_Capacity_Unsecured__c , Max_Capacity_Secured__c , Max_Term__c , Type__c FROM Application_Response__c WHERE Application__c =: testApplication.Id LIMIT 1];
        Workflow__c updatedWorkflow = [SELECT Id, Application__c, Risk_Max_UnSecured_Amount__c, Risk_Max_Secured_Amount__c, Max_Term__c, RecordType.Name FROM Workflow__c WHERE Application__c =: testApplication.Id LIMIT 1];
        
        System.debug('###appResponse: ' + appResponse);
        System.debug('###updatedWorkflow: ' + updatedWorkflow);

        
        System.assertEquals(appResponse.Max_Capacity_Unsecured__c, updatedWorkflow.Risk_Max_UnSecured_Amount__c);
        System.assertEquals(appResponse.Max_Capacity_Secured__c , updatedWorkflow.Risk_Max_Secured_Amount__c);
        System.assertEquals(appResponse.Max_Term__c , updatedWorkflow.Max_Term__c);
        System.assertEquals(appResponse.Type__c , updatedWorkflow.RecordType.Name);
        System.assertEquals(appResponse.Application__c , updatedWorkflow.Application__c); 
        }
    }

    static testMethod void WorkFlowListMethodWithoutWorkflow(){
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Adjusted_Interest_Rate_Locked__c = true;
        testApplication.Response_Code__c = 'SCR';
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.startTest();
                ApexPages.StandardController workflowPage = new ApexPages.StandardController(testApplication);
                APP_Workflow_EXT_INT appWFExtInt = new APP_Workflow_EXT_INT(workflowPage);
                appWFExtInt.workflowList = null;
                appWFExtInt.refreshWorkFlowList();
        Test.StopTest();

        System.assert(appWFExtInt.workflowList.isEmpty());
    }
}