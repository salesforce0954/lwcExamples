/**
 * @Description: Test Class for APP_GSD_FileUpload Class
 * @Author: Adrian Recio
 * @Date Created: 8/2/2016
 * @History:
   =====================================================================
       08-02-16: Created - Adrian Recio
   =====================================================================
 */
@IsTest
public with sharing class APP_GSD_FileUploadTest {
        public static testmethod void testClass(){
            List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
            insert insPremVariables;
    
            // Create Test Person Account
            List<Account> accList = testDataBuilder.createPersonAccounts(1);
            accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
            insert accList;
    
            List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
            insert adminSettingsList;        
            
            //Brand__c testBrand = testDataBuilder.createBrand();
            //insert testBrand;
    
            // Create Test Application
            
            
    
            // Jerome
            RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
    
            Brand__c testBrand = TestDataBuilder.createBrand();
            insert testBrand;
            
            Application__c appVar = testDataBuilder.createApplication();
            appVar.Brand_Lookup__c = testBrand.Id;
            insert appVar;
    
            GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            insert testProduct;
            
            Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
            insert testProductVersion;
            
            ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(appVar.Id,ONRrecordType.Id);
            insert testONR;
    
            Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(appVar.Id, testONR.Id);
            insert testLoanPurpose;
    
            Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
            insert rateCard;
    
            Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
            insert rate;
            // end
            
            // Create Applicant 1
            Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
            appliVar1.Is_Primary_Applicant__c = true;
            insert appliVar1;
            
            //Added as part of AU APOI
             Income__c inVar1 = testDataBuilder.createIncome(appliVar1.Id);
             inVar1.Income_Source__c ='Net Salary/Wages';
             insert inVar1;
                
             Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
             insert inCap;
             //End as part of AU APOI
             
            // Create Application Response
            Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(appVar.Id);
            insert appResponse;
    
            // Create Requested Document
            Requested_Document__c rdVar = new Requested_Document__c(Application__c = appVar.Id);
            insert rdVar;
            
            // Create response code custom setting
            Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'PIA');
            insert rccVar;
                
            test.startTest();
                //  Satisfy not joint condition
                ApexPages.standardController standardCon = new ApexPages.standardController(appVar);
                APP_GSD_FileUpload pIncomeExt = new APP_GSD_FileUpload(standardCon);
                system.assertEquals(false,pIncomeExt.getIsJoint());
                
                // Satisfy joint condition
                // Create Applicant 2
                Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
                insert appliVar2;
                
                standardCon = new ApexPages.standardController(appVar);
                pIncomeExt = new APP_GSD_FileUpload(standardCon);
                system.assertEquals(false,pIncomeExt.getIsJoint());
            
                pIncomeExt.application.Status__c = null;
                pIncomeExt.application.Response_Code__c = 'PIA';
                system.assertEquals(null, pIncomeExt.validatePostSubmit());
                
                pageReference pgRef = Page.APP_Complete;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = 'FIA';
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                pgRef = Page.APP_Main;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = null;
                pIncomeExt.application.Status__c = 'New';
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                pgRef = Page.APP_Main_PostSubmit;
                pgRef.getParameters().put('Id',appVar.Id);
                pgRef.setRedirect(true);
                pIncomeExt.application.Response_Code__c = 'PCO';
                pIncomeExt.application.Status__c = 'Submitted';
                pIncomeExt.application.Acceptance_Channel__c = null;
                system.assertEquals(pgRef.getUrl(),pIncomeExt.validatePostSubmit().getUrl());
                
                // Redirect methods
                pIncomeExt.redirectMain();
                pIncomeExt.redirectToCompletePage();
                pIncomeExt.logout();
    
                // Count method
                // system.assertEquals(5,pIncomeExt.getRDCount());
            test.stopTest();
    }
    
    public static testMethod void testWSFileUpload(){
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        appVar.Brand_Lookup__c = testBrand.Id;
        appVar.Application_Type__c = 'Joint';
        insert appVar;
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
        
        // Create Applicant 1
        Applicant__c appliVar1 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        appliVar1.Is_Primary_Applicant__c = true;
        insert appliVar1;
        
        // Create Applicant 2
        Applicant__c appliVar2 = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar2;
        
        // File upoad success value
        Web_Service_Settings__c fileUpload = new Web_Service_Settings__c();
        fileUpload.name='File Upload Success';
        fileUpload.Value__c='Your document has been sent.';
        insert fileUpload;
        
        // File upload end point
        Web_Service_Settings__c fileUploadEP = new Web_Service_Settings__c();
        fileUploadEP.name='File Upload Endpoint';
        fileUploadEP.Value__c='https://fileupload-dev.au.money.ge.com/fileupload/income/salesforceRequest';
        insert fileUploadEP;
        
        test.startTest();

            PageReference pageRefCurr = Page.app_gsd_aml_response;
            system.test.setCurrentPage(pageRefCurr);

            ApexPages.standardController standardCon = new ApexPages.standardController(appVar);

            APP_GSD_FileUpload cntrl = new APP_GSD_FileUpload(standardCon);

            pageRefCurr = Page.app_gsd_poi_response;
            system.test.setCurrentPage(pageRefCurr);

            standardCon = new ApexPages.standardController(appVar);

            cntrl = new APP_GSD_FileUpload(standardCon); 

            pageRefCurr = Page.app_gsd_poa_response;
            system.test.setCurrentPage(pageRefCurr);

            standardCon = new ApexPages.standardController(appVar);

            cntrl = new APP_GSD_FileUpload(standardCon);


            pageRefCurr = Page.app_gsd_requesteddoc;
            system.test.setCurrentPage(pageRefCurr);

            standardCon = new ApexPages.standardController(appVar);

            cntrl = new APP_GSD_FileUpload(standardCon);

            pageRefCurr = Page.app_gsd_contractacceptance;
            system.test.setCurrentPage(pageRefCurr);
            
            string enpointStr = cntrl.uploadEndPoint;
            Integer rdCnt = cntrl.getRDCount();
            APP_GSD_FileUpload.getApplicantOptions(appVar.Id);
            APP_GSD_FileUpload.insertRelatedDocument('Test Doc.docx','Tax Document','POI1','Complete',string.valueOf(appVar.Id),false);
            
        test.stopTest(); 
    }
}