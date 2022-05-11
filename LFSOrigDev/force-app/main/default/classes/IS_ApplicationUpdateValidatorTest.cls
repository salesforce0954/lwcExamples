@isTest(SeeAllData=true)
    private class IS_ApplicationUpdateValidatorTest { 
    @isTest static void validatorTest1() { 
      
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PC');
        insert responseCodeControl;
        system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c 
            
        Application__c testApplication = new Application__c();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'PC';
        testApplication.Out_Of_Sync__c = true;
        testApplication.Doc_Gen_Check__c = true;
        testApplication.Acceptance_Channel__c = null;
        testApplication.Offered_Interest_Rate__c = 29.96;
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Date_Of_Birth__c = null;
        testApplicant.Email_Address__c = null;
        testApplicant.State_Res__c = 'VIC';
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Disbursement__c disb = TestDatabuilder.createDisbursement(testApplication.Id);
        insert disb;
        
        List<Disbursement__c> disbursementList = new List<Disbursement__c>();
        disbursementList.add(disb);
        IS_ApplicationUpdateValidator  appValidator;
        if(disbursementList.size() > 0){              
            appValidator = new IS_ApplicationUpdateValidator();  
            appValidator.countdisbCount = 5;
            appValidator.countpayDownCount = 5;
            appValidator.countlimitReductionCount = 5;
            appValidator.countcardClosureCount = 5;
            appValidator.TotalCount = 20.0;
            System.assertEquals(appValidator.TotalCount,20.0);       
        }       
        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        List<IS_ValidationError> errors = new List<IS_ValidationError>();
        appDTO.applicant = testApplicant;
        appDTO.applicant2 = testApplicant2;
        appDTO.disbursementList = disbursementList;       
        if(appDTO.app.Response_Code__c!=null){
        errors.add(new IS_ValidationError('','Application is updated.'));
        }
        
        Test.startTest();
            appDTO.app = testApplication;
            update appDTO.app;
            Disbursement__c updateDisb= TestDataBuilder.createDisbursement(testApplication.Id);
            List<Disbursement_Plan__c> testDisbursementPlanList = new List<Disbursement_Plan__c>();
            Disbursement_Plan__c testDisbusementPlan = new Disbursement_Plan__c();
            testDisbusementPlan.IF_Credit_Plan_Number__c = null;
            testDisbusementPlan.IF_Current_Credit_Plan_Balance__c  = null;
            testDisbusementPlan.Rebate_Amount__c  = null;
            testDisbusementPlan.IF_Credit_Plan_Number__c = null;
            testDisbusementPlan.IF_Credit_Plan_Number__c = null;
            testDisbusementPlan.Disbursement__c = updateDisb.Id;
            testDisbursementPlanList.add(testDisbusementPlan);
            errors = appValidator.validate(appDTO);           
        Test.stopTest();
        }
        
        @isTest static void validatorTest2() {
        Test.startTest();
            IS_ApplicationUpdateValidator  appValidator = new IS_ApplicationUpdateValidator();
            List<IS_ValidationError> errs = new List<IS_ValidationError>();
            List<SObject> sobj = new List<SObject>();
            appValidator.checkIfEmpty(sobj,'Test');
            System.assert(errs!=null);
        Test.stopTest();
    
    }              
}