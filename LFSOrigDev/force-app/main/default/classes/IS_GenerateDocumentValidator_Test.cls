@isTest
private class IS_GenerateDocumentValidator_Test {
    
    @isTest static void validateData() {
    // Implement test code
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        testApplication.Out_Of_Sync__c = true;
        testApplication.Is_Manager_Approved__c = false;
        testApplication.Acceptance_Channel__c = null;
        testApplication.Offered_Interest_Rate__c = 29.96;
        testApplication.EMI_with_Service_Fee__c = 10000;
        testApplication.Product_SubType__c = 'Better Start PL';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Date_Of_Birth__c = String.valueOf(23/10/1978);
        testApplicant.Email_Address__c = null;
        testApplicant.State_Res__c = 'VIC';
        testApplicant.Full_Name__c ='John Smith';
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Related_Document__c related = new Related_Document__c();
        related = TestDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        related.Title__c = null;
        related.Type__c = null;
        related.Document_Category__c = null;
        related.Template_Name__c = null;
        insert related;

        List<Related_Document__c> relDoc = new List<Related_Document__c>();
        relDoc.add(related);
        
        Collateral__c collateral = new Collateral__c();
        collateral = TestDataBuilder.createCollateral(testApplication.Id);
        collateral.Collateral_Type__c = null;
        collateral.Collateral_Make__c = null;
        collateral.Collateral_Model__c = null;
        collateral.Collateral_Year__c = null;
        collateral.Collateral_VIN_No__c = null;
        collateral.Collateral_Eng_No__c = null;
        collateral.Collateral_Val__c = null;
        collateral.Collateral_State_of_Registration__c = null;
        collateral.Collateral_Insurance_expiry_date__c = null;
        collateral.Collateral_Date_Valued__c = null;
        collateral.Collateral_Insurance_Policy_number__c = null;
        collateral.Collateral_Insurance_company_name__c = null;
        collateral.Collateral_NVIC__c = null;
        collateral.Collateral_Body_Type__c = null;
        collateral.Collateral_Reg_No__c  = null;

        List<Collateral__c> collateralList = new List<Collateral__c>();
        collateralList.add(collateral); 

        Id directDebitRecordType = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' AND DeveloperName = 'Direct_Debit' LIMIT 1].Id;
        Debit__c debit = new Debit__c();
        debit = TestDataBuilder.createDebit(directDebitRecordType, testApplication.Id);
        debit.Account_Holders__c = null;
        debit.Bank_Name__c = null;
        debit.Branch_Location__c = null;
        debit.BSB_Number__c = null;
        debit.Account_Number__c = null;
        debit.Commencement_Date__c = null;
        debit.Repayment_level__c = 'Higher';

        List<Debit__c> debitList = new List<Debit__c>();
        debitList.add(debit); 

        List<Debit__c> debitList2 = new List<Debit__c>();

        Disbursement__c disbursementReduce = new Disbursement__c();
        disbursementReduce.Disbursement_Outcome__c = 'Reduce';

        Disbursement__c disbursementClose = new Disbursement__c();
        disbursementClose.Disbursement_Outcome__c = 'Close';
        
        Disbursement__c disbursementPersonal = new Disbursement__c();
        disbursementPersonal.Disbursement_Outcome__c = 'Close';
        disbursementPersonal.Disbursement_Account_Type__c = 'Personal Loan';
        disbursementPersonal.Fin_Institution__c = 'GE';

        Disbursement__c disbursementBroker = new Disbursement__c();
        disbursementBroker.RecordTypeId = Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Broker Insurance').getRecordTypeId();

        List<Disbursement__c> disbursementList = new List<Disbursement__c>();
        disbursementList.add(disbursementReduce);
        disbursementList.add(disbursementClose);
        disbursementList.add(disbursementPersonal);
        disbursementList.add(disbursementBroker);

        for(Integer i=0; i<10; i++){
            Disbursement__c disburse = new Disbursement__c();
            disbursementList.add(disburse);
        }

        Branch__c branch = new Branch__c();

        List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();

        List<Personal_Reference_Check__c> personalRefList = new List<Personal_Reference_Check__c>();
        Personal_Reference_Check__c prc = TestDataBuilder.createPersonalReferenceCheck(testApplication.Id);
        personalRefList.add(prc);

        List<Disbursement_Plan__c> testDisbursementPlanList = new List<Disbursement_Plan__c>();
        Disbursement_Plan__c testDisbusementPlan = new Disbursement_Plan__c();
        testDisbusementPlan.IF_Credit_Plan_Number__c = null;
        testDisbusementPlan.IF_Current_Credit_Plan_Balance__c  = null;
        testDisbusementPlan.Rebate_Amount__c  = null;
        testDisbusementPlan.IF_Credit_Plan_Number__c = null;
        testDisbusementPlan.IF_Credit_Plan_Number__c = null;
        testDisbusementPlan.Disbursement__c = disbursementPersonal.Id;
        testDisbursementPlanList.add(testDisbusementPlan);

        Compliance_Check__c testCompliance = TestDataBuilder.createComplianceCheck(testApplication.Id);
        testCompliance.Pre_Contract_Indicator__c = true;
        testCompliance.PFR_Check__c = null;
        testCompliance.BM_Check__c = null;

        List<Compliance_Check__c> testComplianceList = new List<Compliance_Check__c>();
        testComplianceList.add(testCompliance);
        insert testComplianceList;

        IS_ApplicationDTO appDTO = new IS_ApplicationDTO();
        appDTO.applicant = testApplicant;
        appDTO.applicant2 = testApplicant2;
        appDTO.acceptanceDocuments = relDoc;
        appDTO.collateralList = collateralList;
        appDTO.applicationDebits = debitList;
        appDTO.applicationAllDebits = debitList2;
        appDTO.disbursementList = disbursementList;
        appDTO.branch = branch;
        appDTO.disbursementPlanList = testDisbursementPlanList;
        
        //2015-06-18 New Custom Settings - TXU
        Admin_Settings__c ast = new Admin_Settings__c();
        ast.Name = 'Payoff Valid Days at Doc Gen';
        ast.Value__c = '3';
        insert ast;

        Test.StartTest();
            IS_GenerateDocumentValidator validator = new IS_GenerateDocumentValidator();
            List<IS_ValidationError> errors = validator.validate(appDTO);
            appDTO.app = testApplication;
            appDTO.complianceCheckList = complianceList;
            appDTO.personalReferenceList = personalRefList;
            appDTO.app.Acceptance_Channel__c = 'Online Acceptance';
            update appDTO.app;
            errors = validator.validate(appDTO);
            testApplicant.Email_Address__c = 'test';
            appDTO.complianceCheckList = testComplianceList;
            errors = validator.validate(appDTO);
        Test.StopTest();
        
        System.assert(!errors.isEmpty());
    }
}