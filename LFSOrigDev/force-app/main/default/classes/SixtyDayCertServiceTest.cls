/* 
 * @Author: Fel Saliba
 * @Company: Cloud Sherpas
 * @Description: Test Class for SixtyDayCertService Class
 * @History:
   =====================================================================
       28-11-14: Created - Fel
   =====================================================================
 */
 
 @isTest
private class SixtyDayCertServiceTest{

	// Account Recordtype
    public static Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Account;
    public static Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
    
    /* 
     *  Description: Test cloning process for Joint Application
     *  Author: Adrian Recio
     *  Input Parameters: NA
     *  Return: Void
     */
	static testMethod void sdcJointApplcationMatch_Test(){
		
		// Grant Profile Access to current user
		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
	        
		// Create Admin Settings
		List<Admin_Settings__c> adminSettingsList = testDataBuilder.adminSet();
        insert adminSettingsList;   
        
        // Create 'Clone' Response Code Access
		Response_Code_Control__c rccVar = testDataBuilder.createResponseCodeControl(true, 'Clone'); 
		insert rccVar;
		
		// Create Account
		List<Account> accVar = testDataBuilder.createPersonAccounts(1);
		accVar[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		insert accVar;
		
		// Create Billing ICBS 
		List<Billing_ICBS__c> billICBS = testDataBuilder.createBIcbs(2, accVar[0].Id);
		billICBS[0].Account_Number__c = '2000018223345';
		billICBS[0].Contract_Date__c = '31/08/2015';
		billICBS[1].Account_Number__c = '2000018223344';
		billICBS[1].Contract_Date__c = '25/08/2015';
		insert billICBS;
		
		// Create Campaign
        List<Campaign> camList = TestDataBuilder.createCampaign(1);
        camList[0].Promotional_Campaign__c = '60 Day Certificate';
        insert camList; 
        
		// Create Lead (Opportunity)
		List<Opportunity> oppVar = testDataBuilder.createOpportunities(1, accVar[0].Id);
		oppVar[0].Name = 'Test Lead Joint';
		oppVar[0].StageName = 'New';
		oppVar[0].Account_Number__c = '18223345'; 
		oppVar[0].Contract_Date__c = Date.valueOf('2015-08-31');
		oppVar[0].CampaignId = camList[0].Id;
		insert oppVar;
						
		// Create Brand
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        // Create Applicaton
		Application__c testApplication = TestDataBuilder.createApplication();
		testApplication.Status__c = 'New';
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Clone';
        testApplication.Contract_Account_Number__c = '18223345';
        testApplication.Max_Monthly_Capacity__c = 10000;
        insert testApplication;
        
        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicants
	        // Applicant 1
	        Applicant__c testApplicant = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
	        testApplicant.Has_AML__c = true; 
	        testApplicant.Is_Primary_Applicant__c = true;
			appliList.add(testApplicant);
			// Applicant 2        
	        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication.Id);
			appliList.add(testApplicant2);
			insert appliList;
		// End Create Applicants
		
		// Create Applicant child values
	        // Create Applicant Account Customer
	        Applicant_Account_Customer__c testAppAccCust = TestDataBuilder.createApplicantAccountCustomer(testApplicant.Id);
	        insert testAppAccCust;
	        
	        // Create Income for Applicant 1 and 2
	        List<Income__c>appliIncomeList = new List<Income__c>();
	        Income__c testIncome = TestDataBuilder.createIncome(testApplicant.Id);
	        appliIncomeList.add(testIncome);
	        Income__c testIncome2 = TestDataBuilder.createIncome(testApplicant2.Id);
	        appliIncomeList.add(testIncome2);
	        insert appliIncomeList;
			
			// Create Asset for Applicant 1
	        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
	        insert testAsset;
	
			// Create Expense for Applicant 1 and 2
			List<Expense__c>appliExpList = new List<Expense__c>();
	        Expense__c testExpense = TestDatabuilder.createExpense(testApplicant.Id);
	        appliExpList.add(testExpense);
	        Expense__c testExpense2 = TestDatabuilder.createExpense(testApplicant2.Id);
	        appliExpList.add(testExpense2);
	        insert appliExpList;
			
			// Create Liability for Applicant 1
	        Liability__c testDebt = TestDataBuilder.createCardLiability(testApplicant.Id);
	        insert testDebt;
	
			// Create AML for Applicant 1
	        List<AML__c> amlList = new List<AML__c>();
	        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 1, 'Learning Permit'));
	        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 2, 'Driving Licence'));
	        amlList.add(TestDataBuilder.createAMLRecords(testApplicant.Id, 3, 'Utility Bill'));
	        insert amlList;

			// Create Related Document for Applicant 1 and 2
			List<Related_Document__c>relDocList = new List<Related_Document__c>();
			Related_Document__c relDVar1 = testDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
			relDocList.add(relDVar1);
			Related_Document__c relDVar2 = testDataBuilder.createRelatedDocument(testApplicant2.Id, testApplication.Id);
			relDocList.add(relDVar2);
			insert relDocList;
			
	        // Create Collateral for Applicant 1
	        /*
	       	List<Insurance_Premium_Calculation_Variables__c> insurance = TestDataBuilder.createInsurancePremiumCalculationVariables();
	        insert insurance;
	        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
	        insert testCollateralSettings;
	        Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplication.Id);
	        insert testCollateral;
	        */
	                	
       		// Create Credit File Check for Applicant 1 and 2
       		List<Credit_File_Check__c> cfcList = new List<Credit_File_Check__c>();
       		Credit_File_Check__c cfCheckVar1 = TestDataBuilder.createCreditFileCheck(testApplicant.Id, testApplication.Id);
       		cfcList.add(cfCheckVar1);
       		Credit_File_Check__c cfCheckVar2 = TestDataBuilder.createCreditFileCheck(testApplicant2.Id, testApplication.Id);
       		cfcList.add(cfCheckVar2);
       		insert cfcList;
	    // End Create Applicant child values

		// Documents
		// Create Requested Document
     	Requested_Document__c reqDVar = testDataBuilder.createRequestDoc(testApplication.Id);
     	insert reqDVar;
	     	
        // Create GE Product, Version and Item
	        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
	        insert testProduct;
	        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
	        insert testProductVersion;
	        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
	        insert testProductItem;
        
        // Search and Match Values
        	//InsertApplicantSearch
	        Applicant_Search__c testAppSearch = TestDataBuilder.appSearch();
	        insert testAppSearch;
	        //Insert Applicant CLV
	        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearch.Id,testApplicant.Id);
	        insert testApplicantCLVList;
	        //Insert Applicant Account
	        Applicant_Account__c testAppAcc = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
	        insert testAppAcc;
        	// Applicant Account Child
		        //Insert Applicant Account Involved Party
		        Applicant_Account_Involved_Party__c testAppAccInvolvedParty = TestDataBuilder.createApplicantAccountInvolvedParty(testAppAcc.Id);
		        insert testAppAccInvolvedParty;		
		        //Insert Applicant Account Bus Contract Goods
		        App_Account_Bus_Contract_Goods__c testAppAccBusContractGoods = TestDataBuilder.createApplicantAccountBusContract(testAppAcc.Id);
		        insert testAppAccBusContractGoods;
		        //Insert Applicant Account History
		        Applicant_Account_History__c testAppAccHistory = TestDataBuilder.createApplicantAccountHistory(testAppAcc.Id);
		        insert testAppAccHistory;
		        //Insert Applicant Account Loss History
		        Applicant_Account_Loss_History__c testAppAccLossHistory = TestDataBuilder.createApplicantAccountLossHistory(testAppAcc.Id);
		        insert testAppAccLossHistory;
		        //Insert Applicant Account Plan
		        Applicant_Account_Plan__c testAppAccPlan = TestDataBuilder.createApplicantAccountPlan(testAppAcc.Id);
		        insert testAppAccPlan;
	    
	    // Personal Reference Check
	    Personal_Reference_Check__c prefCheckVar = testDataBuilder.createPersonalReferenceCheck(testApplication.Id);
	    insert prefCheckVar;
	     
	    // Credit Ref Check
        Credit_Ref_Check__c testCreditRefCheck = TestDataBuilder.createCreditRefCheck(testApplication.Id);
    	insert testCreditRefCheck;
    	
    	// Create ONR
    	// Pull ONR recordtype with type of General
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;
        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;
        	
        test.startTest();
        	SixtyDaysCertService sdCertService = new SixtyDaysCertService();
        	SixtyDaysCertService.sixtyDayCertResponse sdCertResponse = sdCertService.createApplication(string.valueof(oppVar[0].Id));
        	system.assertNotEquals(sdCertResponse.appId, null);
        test.stopTest();
        
        List<Application__c> appCloneList = [Select Id from Application__c where Id = :sdCertResponse.appId];
        
        for(Application__c appliVar:appCloneList){
        	//Integer piListC = [Select Count() from Product_Item__c where Application__c = :appliVar.Id];
        	//system.assertEquals(1,piListC);
        	Integer rdListC = [Select Count() from Requested_Document__c where Application__c = :appliVar.Id];
        	system.assertEquals(1, rdListC);
        	Integer prcListC = [Select Count() from Personal_Reference_Check__c where Application__c = :appliVar.Id];
        	system.assertEquals(1, prcListC);
        	Integer crcListC = [Select Count() from Credit_Ref_Check__c where Application__c = :appliVar.Id];
        	system.assertEquals(1, crcListC);
        	//Integer lpListC = [Select Count() from Loan_Purpose__c where Application__c = :appliVar.Id];
        	//system.assertEquals(1, lpListC);
        }
        
        List<Applicant__c> appliCloneList = [Select Id, Is_Primary_Applicant__c from Applicant__c where Application__c = :sdCertResponse.appId];
    	system.assertEquals(2, appliCloneList.size());
    	
    	for(Applicant__c appliVar:appliCloneList){
    		// Assert Primary
    		if(appliVar.Is_Primary_Applicant__c==true){
    			Integer aacListC = [Select Count() from Applicant_Account_Customer__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, aacListC);
    			Integer inListC = [Select Count() from Income__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, inListC);
    			Integer assListC = [Select Count() from Asset__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, assListC);
    			Integer exListC = [Select Count() from Expense__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, exListC);
				Integer liaListC = [Select Count() from Liability__c where Applicant__c = :appliVar.Id];
				system.assertEquals(1, liaListC);
				Integer amlListC = [Select Count() from AML__c where Applicant__c = :appliVar.Id];
				system.assertEquals(3, amlListC);
				//Integer relDocListC = [Select Count() from Related_Document__c where Applicant__c = :appliVar.Id];
				//system.assertEquals(1, relDocListC);
				Integer cfcListC = [Select Count() from Credit_File_Check__c where Applicant__c = :appliVar.Id];
				system.assertEquals(1, cfcListC);
    		// Assert Secondary
    		}else{
    			Integer inListC = [Select Count() from Income__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, inListC);
    			Integer exListC = [Select Count() from Expense__c where Applicant__c = :appliVar.Id];
    			system.assertEquals(1, exListC);
    			//Integer relDocListC = [Select Count() from Related_Document__c where Applicant__c = :appliVar.Id];
				//system.assertEquals(0, relDocListC);
				Integer cfcListC = [Select Count() from Credit_File_Check__c where Applicant__c = :appliVar.Id];
				system.assertEquals(1, cfcListC);
    		}
    	}
	}
}