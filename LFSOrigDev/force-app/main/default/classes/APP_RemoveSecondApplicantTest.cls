@isTest
private class APP_RemoveSecondApplicantTest {
	
	@isTest static void test_method_one() {

		TestDataBuilder.createListInsurancePremiumVars();
		
		IS_ApplicationDTO appDTO = new IS_ApplicationDTO();		
		Application__c applctn = TestDataBuilder.createApplication();
			applctn.Application_Type__c = 'Joint';
			applctn.Channel__c = 'Broker';
		insert applctn;

		// Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;


        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(applctn.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(applctn.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

		Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,applctn.Response_code__c);
        insert testResponseCodeCtrl;
		Account accnt = TestDataBuilder.createPersonAccount();
		insert accnt;		
		Applicant__c appli1 = TestDataBuilder.createApplicant(accnt.Id, applctn.Id);
		insert appli1;
		Applicant__c appli2 = TestDataBuilder.createApplicant(accnt.Id, applctn.Id);
		insert appli2;

		Asset__c asset2 = TestDataBuilder.createAsset(appli2.Id);
		insert asset2;

		Asset__c testAsset = TestDataBuilder.createAsset(appli1.Id);
		insert testAsset;

		Asset__c testAsset2 = TestDataBuilder.createAsset(appli2.Id);
		insert testAsset2;

		Liability__c liab2 = TestDataBuilder.createLiabilityMortgage(appli2.Id);		
		insert liab2;

		Liability__c testLiability = TestDataBuilder.createLoanLiability(appli1.Id);
		insert testLiability;

		Liability__c testLiability2 = TestDataBuilder.createLoanLiability(appli2.Id);
		insert testLiability2;

		Income__c income = TestDataBuilder.createIncome(appli2.Id);
		insert income; 
		Expense__c expense = TestDataBuilder.createExpense(appli2.Id);
		insert expense;

		Schema.DescribeSObjectResult debitSchema = Schema.SObjectType.Disbursement__c; 
		Map<String,Schema.RecordTypeInfo> debitRecordTypeInfo = debitSchema.getRecordTypeInfosByName();
		Id directDebitRecordTypeId = debitRecordTypeInfo.get(GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE).getRecordTypeId();

		Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applctn.Id);
			testDisbursement.RecordTypeId = directDebitRecordTypeId;
			testDisbursement.Applicable_Party__c = GEN_OriginationsConstants.APPLICANT_2;
		insert testDisbursement;

		Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
		insert testProfileControl;

		AML__c testAml = TestDataBuilder.createAML(appli2.Id);
		insert testAml;

		Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFileCheck(appli2.Id, applctn.Id);
		insert testCreditFileCheck;

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(applctn.Id);
		insert disbursement;
		Applicant_Search__c appSearch = TestDataBuilder.appSearch();
		insert appSearch;
		Applicant_CLV__c appCLV = TestDataBuilder.createApplicantCLV(appSearch.Id, appli2.Id);
		insert appCLV;
		List<Applicant_CLV__c> appClvList = new List<Applicant_CLV__c>();
		appClvList.add(appCLV);

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applctn.Id);
        insert testAppResponse;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

		Test.startTest();
		appDTO.applicant = appli1;
		appDTO.applicant2 = appli2;
		appDTO.app = applctn;
		APP_RemoveSecondApplicant appRem = new APP_RemoveSecondApplicant(); 
		appRem.deleteApplicantRecord(appDTO);
		Test.stopTest();

		List<Applicant__c> aplList = [SELECT Id FROM Applicant__c WHERE Application__c =: applctn.Id];

		System.assertEquals(1, aplList.size());
	}	
	@isTest static void negative_test_one() {

		TestDataBuilder.createListInsurancePremiumVars();
		
		IS_ApplicationDTO appDTO = new IS_ApplicationDTO();		
		Application__c applctn = TestDataBuilder.createApplication();
			applctn.Application_Type__c = 'Joint';
			applctn.Channel__c = 'Broker';
		insert applctn;

		// Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(applctn.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(applctn.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end
		
		Response_Code_Control__c testResponseCodeCtrl = TestDataBuilder.createResponseCodeControl(true,applctn.Response_code__c);
        insert testResponseCodeCtrl;
		Account accnt = TestDataBuilder.createPersonAccount();
		insert accnt;		
		Applicant__c appli1 = TestDataBuilder.createApplicant(accnt.Id, applctn.Id);
		insert appli1;
		Applicant__c appli2 = TestDataBuilder.createApplicant(accnt.Id, applctn.Id);
		insert appli2;

		Asset__c asset2 = TestDataBuilder.createAsset(appli2.Id);
		insert asset2;

		Asset__c testAsset = TestDataBuilder.createAsset(appli1.Id);
		insert testAsset;

		Asset__c testAsset2 = TestDataBuilder.createAsset(appli2.Id);
		insert testAsset2;

		Liability__c liab2 = TestDataBuilder.createLiabilityMortgage(appli2.Id);		
		insert liab2;

		Liability__c testLiability = TestDataBuilder.createLoanLiability(appli1.Id);
		insert testLiability;

		Liability__c testLiability2 = TestDataBuilder.createLoanLiability(appli2.Id);
		insert testLiability2;

		Income__c income = TestDataBuilder.createIncome(appli2.Id);
		insert income; 
		Expense__c expense = TestDataBuilder.createExpense(appli2.Id);
		insert expense;

		Schema.DescribeSObjectResult debitSchema = Schema.SObjectType.Disbursement__c; 
		Map<String,Schema.RecordTypeInfo> debitRecordTypeInfo = debitSchema.getRecordTypeInfosByName();
		Id directDebitRecordTypeId = debitRecordTypeInfo.get(GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE).getRecordTypeId();

		Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(applctn.Id);
			testDisbursement.RecordTypeId = directDebitRecordTypeId;
			testDisbursement.Applicable_Party__c = GEN_OriginationsConstants.APPLICANT_2;
		insert testDisbursement;

		Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
		insert testProfileControl;

		AML__c testAml = TestDataBuilder.createAML(appli2.Id);
		insert testAml;

		Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFileCheck(appli2.Id, applctn.Id);
		insert testCreditFileCheck;

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(applctn.Id);
		insert disbursement;
		Applicant_Search__c appSearch = TestDataBuilder.appSearch();
		insert appSearch;
		Applicant_CLV__c appCLV = TestDataBuilder.createApplicantCLV(appSearch.Id, appli2.Id);
		insert appCLV;
		List<Applicant_CLV__c> appClvList = new List<Applicant_CLV__c>();
		appClvList.add(appCLV);

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applctn.Id);
        insert testAppResponse;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

		Test.startTest();
		appDTO.applicant = appli1;
		appDTO.applicant2 = appli2;
		appDTO.app = applctn;
		APP_RemoveSecondApplicant appRem = new APP_RemoveSecondApplicant(); 
		appRem.deleteApplicantRecord(appDTO);
		appRem.deleteApplicantRecord(appDTO);
		Test.stopTest();

		List<Applicant__c> aplList = [SELECT Id FROM Applicant__c WHERE Application__c =: applctn.Id];

		System.assertEquals(1, aplList.size());
	}	
}