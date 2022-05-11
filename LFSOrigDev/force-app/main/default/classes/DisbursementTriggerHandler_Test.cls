/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 10, 2014
Description: Test Class for DisbursementTriggerHandler
*/
@isTest
private class DisbursementTriggerHandler_Test {

	@isTest static void validAccountNumber(){

		//First Applicant

		//Applicant Account recordtype
		RecordType appAccRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'ICBS'];

		//Disbursment recordtype
		RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Re-Finance'];

		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;

		Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;
        
		Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
		insert testApplicantSearch;
		//Added by vijay start
		list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
		//Added by vijay End
		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		testApplicant.Application__c = testApplication.Id;
		insert testApplicant;

		List<Applicant_CLV__c> testapplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id,testApplicant.Id);
		testapplicantCLVList[0].Applicant__c = testApplicant.Id;
		insert testapplicantCLVList;

		Applicant_Account__c testApplicantAccount = new Applicant_Account__c();
		testApplicantAccount.Account_Number__c = '3444323242';
		testApplicantAccount.Applicant_CLV__c = testapplicantCLVList[0].Id;
		testApplicantAccount.RecordTypeId = appAccRecordType.Id;
		testApplicantAccount.Account_Balance__c = '300.0';
		insert testApplicantAccount;

		Applicant_Account__c testApplicantAccount2 = new Applicant_Account__c();
		testApplicantAccount2.Account_Number__c = '1234567891';
		testApplicantAccount2.Applicant_CLV__c = testapplicantCLVList[0].Id;
		testApplicantAccount2.RecordTypeId = appAccRecordType.Id;
		testApplicantAccount2.Account_Balance__c = '300.0';
		insert testApplicantAccount2;

		Applicant_Account__c testApplicantAccount3 = new Applicant_Account__c();
		testApplicantAccount3.Account_Number__c = '1234567891';
		testApplicantAccount3.Applicant_CLV__c = testapplicantCLVList[0].Id;
		testApplicantAccount3.RecordTypeId = appAccRecordType.Id;
		testApplicantAccount3.Account_Balance__c = '0.0';
		insert testApplicantAccount3;

		List<Disbursement__c> disList = new List<Disbursement__c>();
		Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(testApplication.Id);
		testDisbursement.Application__c = testApplication.Id;
		testDisbursement.RecordTypeId = disRecordType.Id;
		//Added by vijay start
		testDisbursement.Bank_Acc_No__c = '0068389';
		testDisbursement.Bank_Number__c='1';
		testDisbursement.Branch_Number__c='902';
		testDisbursement.Suffix_Number__c='000';
		//Added by vijay End
		disList.add(testDisbursement);

		//Second Applicant

		Application__c testApplication2 = TestDataBuilder.createApplication();
		insert testApplication2;

		Applicant_Search__c testApplicantSearch2 = TestDataBuilder.appSearch();
		insert testApplicantSearch2;

		Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication2.Id);
		testApplicant2.Application__c = testApplication2.Id;
		insert testApplicant2;

		List<Applicant_CLV__c> testapplicantCLVList2 = TestDataBuilder.applicantCLVList(testApplicantSearch2.Id,testApplicant2.Id);
		testapplicantCLVList2[0].Applicant__c = testApplicant2.Id;
		insert testapplicantCLVList2;

		Applicant_Account__c testApplicantAccount4 = new Applicant_Account__c();
		testApplicantAccount4.Account_Number__c = '3444323220';
		testApplicantAccount4.Applicant_CLV__c = testapplicantCLVList2[0].Id;
		testApplicantAccount4.RecordTypeId = appAccRecordType.Id;
		testApplicantAccount4.Account_Balance__c = '300.0';
		insert testApplicantAccount4;

		List<Disbursement__c> disList2 = new List<Disbursement__c>();
		Disbursement__c testDisbursement2 = TestDataBuilder.createDisbursement(testApplication2.Id);
		testDisbursement2.Application__c = testApplication2.Id;
		testDisbursement2.RecordTypeId = disRecordType.Id;
		//Added by vijay start
		testDisbursement2.Bank_Acc_No__c = '0068389';
		testDisbursement2.Bank_Number__c='01';
		testDisbursement2.Branch_Number__c='902';
		testDisbursement2.Suffix_Number__c='0000';
		//Added by vijay End
		disList2.add(testDisbursement2);
		
		Test.startTest();
			insert testDisbursement;
			insert testDisbursement2;
		Test.stopTest();

		System.assertEquals(testApplication.Id, testDisbursement.Application__c);
		System.assertEquals(testApplication2.Id, testDisbursement2.Application__c);
	}

	@isTest static void Refinance_Test(){
		Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
		responseCodeControl.Save_Disbursement_Standard__c = true;
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        //Added by vijay start
        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
		//Added by vijay End
        String refinanceId = Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
		Disbursement__c  testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
		testDisbursement.RecordTypeId = refinanceId;
		//Added by vijay start
		testDisbursement.Bank_Acc_No__c = '0068389';
		testDisbursement.Bank_Number__c='01';
		testDisbursement.Branch_Number__c='902';
		testDisbursement.Suffix_Number__c='0000';
		//Added by vijay End
		insert testDisbursement;

        Applicant_Search__c testApplicationSearch = TestDataBuilder.appSearch();
        insert testApplicationSearch;

        Applicant_CLV__c testApplicantCLV = TestDataBuilder.createApplicantCLV(testApplicationSearch.Id, testApplicant.Id);
        insert testApplicantCLV;

        String ICBSId = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c testApplicantAccount = TestDataBuilder.createApplicantAcocunt(testApplicantCLV.Id);
        testApplicantAccount.RecordTypeId = ICBSId;
        testApplicantAccount.Account_Number__c = '12345';
        testApplicantAccount.Account_Balance__c = '12345';
        insert testApplicantAccount;

        List<Disbursement__c> dList = new List<Disbursement__c>();
        dList.add(testDisbursement);

		Test.startTest();
			DisbursementTriggerHandler d = new DisbursementTriggerHandler();
			d.saveDisbursement(dList);
		Test.stopTest();

		System.assertEquals(testApplication.Id, testDisbursement.Application__c);
	}

	@isTest static void RefinanceError_Test(){
		Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication.Response_Code__c);
		responseCodeControl.Save_Disbursement_Standard__c = true;
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;
        //Added by vijay start
        list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
		//Added by vijay End
        String refinanceId = Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId();
		Disbursement__c  testDisbursement = TestDataBuilder.createDisbursementRefinance(testApplication.Id, testLoanPurpose.Id);
		testDisbursement.RecordTypeId = refinanceId;
		//Added by vijay start
		testDisbursement.Bank_Acc_No__c = '0068389';
		testDisbursement.Bank_Number__c='01';
		testDisbursement.Branch_Number__c='902';
		testDisbursement.Suffix_Number__c='0000';
		//Added by vijay End
		insert testDisbursement;

        Applicant_Search__c testApplicationSearch = TestDataBuilder.appSearch();
        insert testApplicationSearch;

        Applicant_CLV__c testApplicantCLV = TestDataBuilder.createApplicantCLV(testApplicationSearch.Id, testApplicant.Id);
        insert testApplicantCLV;
        
        List<Disbursement__c> dList = new List<Disbursement__c>();
        dList.add(testDisbursement);

		Test.startTest();
			DisbursementTriggerHandler d = new DisbursementTriggerHandler();
			try{
                d.saveDisbursement(dList);
            }catch(Exception e){
                System.assert(e.getMessage().contains('Corresponding Account Number cannot be refinanced'), e.getMessage());
            }
		Test.stopTest();
	}
	
	@isTest static void populateDisbursementdata(){

		//First Applicant

		//Applicant Account recordtype
		RecordType appAccRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'ICBS'];

		//Disbursment recordtype
		RecordType disRecordType = [SELECT Id,Name FROM RecordType WHERE Name = 'Direct Credit NZ'];

		Application__c testApplication = TestDataBuilder.createApplication();
		insert testApplication;

		Response_Code_Control__c testResponseCode = TestDataBuilder.createResponseCodeControl(true, String.valueOf(testApplication.Response_Code__c));
        insert testResponseCode;
        
		Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
		insert testApplicantSearch;

		Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
		testApplicant.Application__c = testApplication.Id;
		insert testApplicant;

		List<Applicant_CLV__c> testapplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id,testApplicant.Id);
		testapplicantCLVList[0].Applicant__c = testApplicant.Id;
		insert testapplicantCLVList;
		//Added by vijay start
		list<Bank__c> b=TestDataBuilder.createBank();
        insert b;
        
        list<Bank_Branch__c> bb=TestDataBuilder.createBranch(b);
        insert bb;
        
        Algorithm__c alg=TestDataBuilder.createAlgorithm();
        insert alg;
		//Added by vijay End
		Applicant_Account__c testApplicantAccount = new Applicant_Account__c();
		testApplicantAccount.Account_Number__c = '3444323242';
		testApplicantAccount.Applicant_CLV__c = testapplicantCLVList[0].Id;
		testApplicantAccount.RecordTypeId = appAccRecordType.Id;
		testApplicantAccount.Account_Balance__c = '300.0';
		insert testApplicantAccount;

		Profile_Country__c prCountry = new Profile_Country__c(SetupOwnerId = Userinfo.getProfileId(),NZ__c = true);
		insert prCountry;
		//Added by vijay start
		Payee__c payee = TestDataBuilder.createPayee();
		insert payee;
		//Added by vijay End
		List<Disbursement__c> disList = new List<Disbursement__c>();
		Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(testApplication.Id);
		testDisbursement.Application__c = testApplication.Id;
		//testDisbursement.Bank_Acc_No__c = '34443232';
		testDisbursement.lookup_a_payee__c = payee.Id;
		testDisbursement.RecordTypeId = disRecordType.Id;
		testDisbursement.Bank_Acc_No__c = '0068389';
		testDisbursement.Bank_Number__c='01';
		testDisbursement.Branch_Number__c='902';
		testDisbursement.Suffix_Number__c='000';
		disList.add(testDisbursement);
        
        Test.startTest();
			insert testDisbursement;
		Test.stopTest();
		
		System.assertEquals(testApplication.Id, testDisbursement.Application__c);
	}
}