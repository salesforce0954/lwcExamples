/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: February 24, 2014
Description: Test class for the APP_AccountData
*/
@isTest
private class App_AccountDataExt_Test { 

    /*  Description: Test Single CLV Account Data Ext
     *  Author: Adrian Recio
     *  Date Created: 12-MAR-2015
     *  Parameter NA
     *  Return: Void
     */
	@isTest static void App_AccountDataExt_JointCLV() {

		// Create profile control
		Profile_Control__c pcVar = TestDataBuilder.createProfileControl(true);
		pcVar.SetupOwnerId = UserInfo.getProfileId();
		pcVar.Search_and_Match_View__c = true;
		pcVar.Search_and_Match_Edit__c = true;
		insert pcVar;
		
		// Create Admin Setting
        List<Admin_Settings__c> admSet = TestDataBuilder.adminSet();
        insert admSet;
        
		// Create Test Account
		Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
		// Create Test Application
		Application__c app = TestDataBuilder.createApplication();
        insert app;
        
        // Response Code Control
        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, app.Response_Code__c);
        responseCodeControl.Search_and_Match_Edit__c = true;
        responseCodeControl.Edit_CLV__c = true;
        insert responseCodeControl;
        
        // Create Test Applicant
        // Applicant 1
        List<Applicant__c>appList = new List<Applicant__c>();
        Applicant__c appl = TestDataBuilder.createApplicant(acc.Id, app.Id);
        appl.Is_Primary_Applicant__c = true;
        appl.First_Name__c = null;
        appl.Last_Name__c = null;
        appl.Date_of_Birth__c = null;
        appList.add(appl);
        // Applicant 2
        Applicant__c appl2 = TestDataBuilder.createApplicant(acc.Id, app.Id);
        appl2.Is_Primary_Applicant__c = false;
        appl2.First_Name__c = null;
        appl2.Last_Name__c = null;
        appl2.Date_of_Birth__c = null;
        appList.add(appl2);
        insert appList;

        // Create Applicant Search for CLV
        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;
            		
        // Create Applicant CLV for Applicant 1
        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, appl.Id);
        
        appCLVList[0].First_Name__c = 'Adrian';
        appCLVList[0].Middle_Name__c = 'Ablola';
        appCLVList[0].Surname__c = 'Recio';
        appCLVList[0].Date_of_Birth__c = '2015-4-27';
        appCLVList[0].State__c = 'VIC';
        appCLVList[0].Home__c = '02111111111';
        appCLVList[0].Work__c = '03111111111';
        appCLVList[0].Mobile__c = '04111111111';
        
        appCLVList[0].Applicant_Bucket__c = '1';
        appCLVList[1].Applicant_Bucket__c = '1';
        appCLVList[2].Applicant_Bucket__c = '1';

        appCLVList[0].User_Match_Flag__c = true;
        appCLVList[1].User_Match_Flag__c = true;
        appCLVList[2].User_Match_Flag__c = true;

        // Create Applicant CLV for Applicant 2
        List<Applicant_CLV__c> appCLVList2 = TestDataBuilder.applicantCLVList(appSearch.Id, appl2.Id);
        
        appCLVList2[0].First_Name__c = 'Lawrence';
        appCLVList2[0].Middle_Name__c = 'Ablola';
        appCLVList2[0].Surname__c = 'Recio';
        appCLVList2[0].Date_of_Birth__c = '2015-4-27';
        appCLVList2[0].State__c = 'VIC';
        appCLVList2[0].Home__c = '02111111111';
        appCLVList2[0].Work__c = '03111111111';
        appCLVList2[0].Mobile__c = '04111111111';
        
        appCLVList2[0].Applicant_Bucket__c = '2';
        appCLVList2[1].Applicant_Bucket__c = '2';
        appCLVList2[2].Applicant_Bucket__c = '2';

        appCLVList2[0].User_Match_Flag__c = true;
        appCLVList2[1].User_Match_Flag__c = true;
        appCLVList2[2].User_Match_Flag__c = true;

        appCLVList2[0].CLV__c = '1233';
        appCLVList2[1].CLV__c = '1234';
        appCLVList2[2].CLV__c = '1235';
        appCLVList.addAll(appCLVList2);
        insert appCLVList;
        
        // Create Applicant Account
        List<Applicant_Account__c>appAccList = new List<Applicant_Account__c>();

        // Create Applicant Account for Applicant 1 CLV
        String icbs = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c appAccICBS = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccICBS.RecordTypeId = icbs;
        appAccICBS.Current_Balance__c = '1000';
        appAccICBS.Installment_Amount__c = 2000;
        appAccICBS.Opening_Balance__c = '3000';
        appAccList.add(appAccICBS);
        
        String vis = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Applicant_Account__c appAccVis = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccVis.RecordTypeId = vis;
        appAccVis.Maximum_Credit_Limit__c = '1000';
        appAccVis.Current_Balance__c = '2000';
        appAccVis.Closed_Date__c = null;
        appAccList.add(appAccVis);
        
        String gen = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
        Applicant_Account__c appAccGen = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccGen.RecordTypeId = gen;
		appAccGen.Current_Balance__c = '1000';
        appAccGen.Installment_Amount__c = 2000;
        appAccGen.Next_Payment_Amount_Due__c = 2000;
        appAccGen.Amount_Financed__c = 2500;
        appAccList.add(appAccGen);

        // Create Applicant Account for Applicant 2 CLV
        Applicant_Account__c appAccICBS2 = TestDataBuilder.createApplicantAcocunt(appCLVList[1].Id);
        appAccICBS2.RecordTypeId = icbs;
        appAccICBS2.Current_Balance__c = '1000';
        appAccICBS2.Installment_Amount__c = 2000;
        appAccICBS2.Opening_Balance__c = '3000';
        appAccList.add(appAccICBS2);
        
        Applicant_Account__c appAccVis2 = TestDataBuilder.createApplicantAcocunt(appCLVList[1].Id);
        appAccVis2.RecordTypeId = vis;
        appAccVis2.Maximum_Credit_Limit__c = '1000';
        appAccVis2.Current_Balance__c = '2000';
        appAccVis2.Closed_Date__c = null;
        appAccList.add(appAccVis2);
        
        Applicant_Account__c appAccGen2 = TestDataBuilder.createApplicantAcocunt(appCLVList[1].Id);
        appAccGen2.RecordTypeId = gen;
        appAccGen2.Current_Balance__c = '1000';
        appAccGen2.Installment_Amount__c = 2000;
        appAccGen2.Next_Payment_Amount_Due__c = 2000;
        appAccGen2.Amount_Financed__c = 2500;
        appAccList.add(appAccGen2);

        insert appAccList;
        
        // Create Applicant Account Involved Party for Genesis
        Applicant_Account_Involved_Party__c  testAAIP = TestDataBuilder.createApplicantAccountInvolvedParty(appAccGen.Id);
        testAAIP.Customer_Identifier__c = '000999';
        insert testAAIP;
        
        Test.startTest();
        	ApexPages.CurrentPage().getParameters().put('id',app.id);
        	ApexPages.CurrentPage().getParameters().put('hasChanged','1');
        	ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(app);
        	APP_AccountDataExt appAccExt = new APP_AccountDataExt(standardCon);
        	
        	// Assert Profile and Respons Code Control Access
        	system.assertEquals(appAccExt.searchMatchViewControl, true);
        	system.assertEquals(appAccExt.searchMatchEditControl, true);
        	system.assertEquals(appAccExt.searchMatchControl, true);
        	system.assertEquals(appAccExt.nextButton, true);
        	
        	// Check expected variable initalization values
        	system.assertEquals(appAccExt.showRelAppAccount, false);
        	system.assertEquals(appAccExt.showApplicantAccount, false);
        	system.assertEquals(appAccExt.showNext,false);
        	system.assertEquals(appAccExt.selectCust,'Select Customer');
        	
        	// Assert Aplication Information
        	system.assertNotEquals(appAccExt.application, null);
        	system.assertNotEquals(appAccExt.app1, null);
        	system.assertNotEquals(appAccExt.app2, null);
        	system.assertEquals(appAccExt.applicantList.size(), 2);
			system.assertEquals(appAccExt.appCLVList.size(), 6);
			
			// Assert Prepopulation Variables
			/*
			system.assertEquals(appAccExt.hasExistDefaultApp1,false);
			system.assertEquals(appAccExt.hasExistDefaultApp2,false);
			system.assertEquals(appAccExt.hasPrepopulation,true);
			*/
			
        	//appAccExt.loadSearchAndMatchCLV();
        	
        	// Assert displayApplicantAccount Method
        	appAccExt.selectedCLV = appCLVList[0].Id;
        	appAccExt.displayApplicantAccount();
        	system.assertEquals(appAccExt.applicantAccList.size(),3);
        	
        	appAccExt.selectedCLV = appCLVList[1].Id;
        	appAccExt.displayApplicantAccount();
        	system.assertEquals(appAccExt.applicantAccList.size(),3);
        	
        	// Assert displayApplicantAccountDetail Method
        	appAccExt.selectedAppACC = appAccICBS.Id;
        	appAccExt.displayApplicantAccountDetail();
        	system.assertEquals(appAccExt.appRecordType, 'ICBS');
        	system.assertEquals(appAccExt.appPartylist.size(),0);
        	system.assertEquals(appAccExt.showPartyList,false);
        	
        	appAccExt.selectedAppACC = appAccVis.Id;
        	appAccExt.displayApplicantAccountDetail();
        	system.assertEquals(appAccExt.appRecordType, 'Vision');
        	system.assertEquals(appAccExt.appPartylist.size(),0);
        	system.assertEquals(appAccExt.showPartyList,false);
        	
        	appAccExt.selectedAppACC = appAccGen.Id;
        	appAccExt.displayApplicantAccountDetail();
        	system.assertEquals(appAccExt.appRecordType, 'Genesis');
        	system.assertEquals(appAccExt.appPartylist.size(),1);
        	system.assertEquals(appAccExt.showPartyList,true);
        	
        	// Assert copyICBSCustomerNumber Method
        	appAccExt.selectedCLV = appCLVList[0].Id;
        	appAccExt.selectedAccountParty = testAAIP.Id;
        	appAccExt.copyICBSCustomerNumber();
        	Applicant_Account__c aaVar = [Select Id,Selected_ICBS_Customer_Number__c from 
        								  Applicant_Account__c where Id = :appAccGen.Id]; 
        	system.assertEquals(aaVar.Selected_ICBS_Customer_Number__c,'000999');
        	
        	// Assert clearICBSNumbers Method
        	appAccExt.selectedAppACC = appAccGen.Id;
        	appAccExt.clearICBSNumbers();
        	aaVar = [Select Id,Selected_ICBS_Customer_Number__c from 
        		     Applicant_Account__c where Id = :appAccGen.Id]; 
        	system.assertEquals(aaVar.Selected_ICBS_Customer_Number__c,null);
        	
        	// Select CLV To prepopulate
        	        	
        	// Assert goToNext Method
        	appAccExt.appCLVList[0].prepopulate__c = true;
        	appAccExt.appCLVList[3].prepopulate__c = true;
        	
        	// Fire Multiple prepopulation error message
        	appAccExt.appCLVList[1].prepopulate__c = true;
        	appAccExt.goToNext();
        	system.assertEquals(appAccExt.appClvError,true);
        	// Satisfy Multiple prepopulation error message
        	appAccExt.appCLVList[1].prepopulate__c = false;
        	appAccExt.goToNext();
        	system.assertEquals(appAccExt.appClvError,false);
        	
        	set<Id>appCLVIdSet = appAccExt.appCLVMap.keyset();
        	List<Applicant_CLV__c> mainAppCLVList = Database.query( 'Select Id,First_Name__c,Middle_Name__c,Surname__c,Date_of_Birth__c,' + 
																	 'Street_Address__c,Suburb__c,State__c,Home__c,Work__c,Mobile__c,' +
																	 'Applicant_Bucket__c,prepopulate__c, ' +
																   	 '(Select Id, Selected_ICBS_Customer_Number__c,' + 
									                        		 'Account_Number__c, Applicant_CLV__c,' + 
												                     'Applicant_CLV__r.Applicant_Bucket__c,' +
												                     'Account_Balance__c, Closed_Date__c,' + 
												                     'Next_Payment_Amount_Due__c,' + 
												                     'Credit_Limit_Borrowed_Amount__c,' +
												                     'Installment_Amount__c,' + 
												                     'Current_Balance__c,Amount_Financed__c,' +
												                     'RecordTypeId,Maximum_Credit_Limit__c,' +
												                     'Opening_Balance__c ' +
														             'from Applicant_Accounts__r ' +
																	 'order by Account_Open_Date__c ASC) ' +
																	 'from Applicant_CLV__c where Id In :appCLVIdSet');
        	
        	List<Applicant_Account__c>appAccChildList = new List<Applicant_Account__c>();
        	for(Applicant_CLV__c appCLVVar:mainAppCLVList){
        		appAccChildList.addAll(appCLVVar.Applicant_Accounts__r);
        	}
        	        	
        	// Assert Remote Action Method populateDebtAndPersonalDetails
        	APP_AccountDataExt.populateDebtAndPersonalDetails(mainAppCLVList,
                                                         	  appAccExt.appCLVList, 
                                                         	  appAccChildList, 
                                                         	  appAccExt.applicantList,
                                                         	  null);
            // Assert Personal Details
            List<Applicant__c>newAppliList = [Select Id,First_Name__c,Middle_Name__c,
            							 			Last_Name__c,Date_of_Birth__c,
            							 			State_Res__c,Home__c,
            							 			Work__c,Mobile__c,Is_Primary_Applicant__c from 
            							 			Applicant__c where 
            							 			Application__c = :app.Id];
            for(Applicant__c appVar:newAppliList){
            	if(appVar.Is_Primary_Applicant__c == true){
            		system.assertEquals(appVar.First_Name__c, appCLVList[0].First_Name__c);
            		system.assertEquals(appVar.Middle_Name__c, appCLVList[0].Middle_Name__c);
            		system.assertEquals(appVar.Last_Name__c, appCLVList[0].Surname__c);
            		system.assertEquals(appVar.Date_of_Birth__c, '27-4-2015');
            		system.assertEquals(appVar.State_Res__c, appCLVList[0].State__c);
            		system.assertEquals(appVar.Home__c, appCLVList[0].Home__c);
            		system.assertEquals(appVar.Work__c, appCLVList[0].Work__c);
            		system.assertEquals(appVar.Mobile__c, appCLVList[0].Mobile__c);
            	}else{
            		system.assertEquals(appVar.First_Name__c, appCLVList2[0].First_Name__c);
            		system.assertEquals(appVar.Middle_Name__c, appCLVList2[0].Middle_Name__c);
            		system.assertEquals(appVar.Last_Name__c, appCLVList2[0].Surname__c);
            		system.assertEquals(appVar.Date_of_Birth__c, '27-4-2015');
            		system.assertEquals(appVar.State_Res__c, appCLVList2[0].State__c);
            		system.assertEquals(appVar.Home__c, appCLVList2[0].Home__c);
            		system.assertEquals(appVar.Work__c, appCLVList2[0].Work__c);
            		system.assertEquals(appVar.Mobile__c, appCLVList2[0].Mobile__c);
            	}
            }
            
            List<Liability__c>newLiaList = [Select Id,Debt_Category__c,Financier_Name__c,
            									   Car_Personal_Bal_Amt__c,Car_Personal_Repay_Amt__c,
            									   Car_Personal_Repay_Int__c,Car_Personal_Borrowed_Amt__c,
            									   Credit_Limit_Amt__c, Card_Overdraft_Bal_Amt__c from 
            									   Liability__c where Applicant__c = :appl.Id];
            system.assertEquals(newLiaList.size(),6);
            
            Integer genesisCount = 0;
            Integer visionCount = 0;
            Integer icbsCount = 0;

            for(Liability__c lVar:newLiaList){
            	// ICBS
				if(lVar.Debt_Category__c == 'Personal Loan'){
					system.assertEquals(lVar.Financier_Name__c , GEN_OriginationsConstants.BRAND_NAME_GEMONEY);	//MLASALA: 24-MAR-16 TQLQW-127 Re-brand 
					system.assertEquals(lVar.Car_Personal_Bal_Amt__c ,1000); // Text Current_Balance__c
					system.assertEquals(lVar.Car_Personal_Repay_Amt__c ,2000);  // Currency Installment_Amount__c
					system.assertEquals(lVar.Car_Personal_Borrowed_Amt__c, 3000); // Text Opening_Balance__c
					icbsCount++;
				}
	            // Genesis
	            if(lVar.Debt_Category__c == 'Car Loan'){
					system.assertEquals(lVar.Financier_Name__c, GEN_OriginationsConstants.BRAND_NAME_GEMONEY);	//MLASALA: 24-MAR-16 TQLQW-127 Re-brand 
					system.assertEquals(lVar.Car_Personal_Bal_Amt__c,1000); // Text Current_Balance__c
					system.assertEquals(lVar.Car_Personal_Repay_Amt__c,2000); // Currency Installment_Amount__c
					system.assertEquals(lVar.Car_Personal_Repay_Int__c,'Month');
					system.assertEquals(lVar.Car_Personal_Borrowed_Amt__c,2500); // Decimal Amount_Financed__c 
	            	genesisCount++;
	            }
				
				// Vision Plus
				if(lVar.Debt_Category__c == 'Credit Card'){
					system.assertEquals(lVar.Financier_Name__c, GEN_OriginationsConstants.BRAND_NAME_GEMONEY);	//MLASALA: 24-MAR-16 TQLQW-127 Re-brand 
					system.assertEquals(lVar.Credit_Limit_Amt__c,1000); // Text Maximum_Credit_Limit__c
					system.assertEquals(lVar.Card_Overdraft_Bal_Amt__c,2000); // Text Current_Balance__c
					visionCount++;
				}
            }
            system.assertEquals(genesisCount, 2);
            system.assertEquals(visionCount, 2);
            system.assertEquals(icbsCount, 2);
            
            // Asssert loadSearchAndMatchCLV Method
            appAccExt.loadSearchAndMatchCLV();
            
            // Assert backToSearchandMatch Method
            appAccExt.backToSearchandMatch();
            
            // Assert redirectToAppEligibilityPage Method
            appAccExt.redirectToAppEligibilityPage();

            // Force Search
            appAccExt.forceSearch();
            appAccExt.getName();
        Test.stopTest();
	}
	
	/*
    @isTest static void test_method_one() {
        
        Application__c app = TestDataBuilder.createApplication();
        insert app;
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        Applicant__c appl = TestDataBuilder.createApplicant(acc.Id, app.Id);
        appl.Is_Primary_Applicant__c = true;
        insert appl;
        Applicant__c appl2 = TestDataBuilder.createApplicant(acc.Id, app.Id);
        insert appl2;
        
        List<Admin_Settings__c> admSet = TestDataBuilder.adminSet();
        insert admSet;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;

        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, appl.Id);
        insert appCLVList;

        String icbs = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c appAccICBS = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccICBS;

        String vis = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Applicant_Account__c appAccVis = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccVis;

        String gen = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
        Applicant_Account__c appAccGen = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccGen;

        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',app.id);
        ApexPages.CurrentPage().getParameters().put('hasChanged','1');
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(app);
        APP_AccountDataExt appAccExt = new APP_AccountDataExt(standardCon);
        appAccExt.selectedAppACC = appAccGen.Id;
        appAccExt.clearICBSNumbers();
        appAccExt.loadSearchAndMatchCLV();
        appAccExt.getName();
        appAccExt.backToSearchandMatch();
        appAccExt.goToNext();
        appAccExt.displayApplicantAccount();
        appAccExt.displayApplicantAccountDetail();
        appAccExt.copyICBSCustomerNumber();
        appAccExt.forceSearch();
        //appAccExt.updateICBS();
        Test.stopTest();

        System.assertEquals(app.Id, appl.Application__c);
        System.assertEquals(app.Id, appl2.Application__c);
        System.assert(!admSet.isEmpty());
        System.assert(!appCLVList.isEmpty());
        System.assertEquals(appSearch.Id, appCLVList.get(0).Applicant_Search__c);
        System.assertEquals(appl.Id, appCLVList.get(0).Applicant__c);
        System.assertEquals(appCLVList.get(0).Id, appAccGen.Applicant_CLV__c);
    }   
    
    @isTest static void test_method_two() {
        
        Application__c app = TestDataBuilder.createApplication();
        insert app;
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        Applicant__c appl = TestDataBuilder.createApplicant(acc.Id, app.Id);
        appl.Is_Primary_Applicant__c = true;
        insert appl;
        Applicant__c appl2 = TestDataBuilder.createApplicant(acc.Id, app.Id);
        insert appl2;
        
        List<Admin_Settings__c> admSet = TestDataBuilder.adminSet();
        insert admSet;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;

        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, appl.Id);
        appCLVList[0].Last_Search__c = System.now().addHours(12);
        appCLVList[1].Last_Search__c = System.now().addHours(12);
        appCLVList[1].Applicant_Bucket__c = '2';
        appCLVList[1].Applicant__c = appl2.Id;
        insert appCLVList;

        String icbs = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c appAccICBS = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccICBS;

        String vis = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Applicant_Account__c appAccVis = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccVis;

        String gen = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
        Applicant_Account__c appAccGen = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        insert appAccGen;

        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',app.id);
        ApexPages.CurrentPage().getParameters().put('hasChanged','2');
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(app);
        APP_AccountDataExt appAccExt = new APP_AccountDataExt(standardCon);
        appAccExt.selectedAppACC = appAccGen.Id;
        appAccext.selectedCLV = appCLVList[0].Id;
        appAccExt.clearICBSNumbers();
        appAccExt.loadSearchAndMatchCLV();
        appAccExt.getName();
        appAccExt.backToSearchandMatch();
        appAccExt.goToNext();
        appAccExt.displayApplicantAccount();
        appAccExt.displayApplicantAccountDetail();
        appAccExt.copyICBSCustomerNumber();
        appAccExt.forceSearch();
        //appAccExt.updateICBS();
        Test.stopTest();

        System.assertEquals(app.Id, appl.Application__c);
        System.assertEquals(app.Id, appl2.Application__c);
        System.assert(!admSet.isEmpty());
        System.assert(!appCLVList.isEmpty());
        System.assertEquals(appSearch.Id, appCLVList.get(0).Applicant_Search__c);
        System.assertEquals(appl.Id, appCLVList.get(0).Applicant__c);
        System.assertEquals(appCLVList.get(0).Id, appAccGen.Applicant_CLV__c);
    }

    @isTest static void test_method_three() {
        
        Application__c app = TestDataBuilder.createApplication();
        insert app;

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Applicant__c appl = TestDataBuilder.createApplicant(acc.Id, app.Id);
        appl.Is_Primary_Applicant__c = true;
        insert appl;
        
        List<Admin_Settings__c> admSet = TestDataBuilder.adminSet();
        insert admSet;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;

        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, appl.Id);
        appCLVList[0].Last_Search__c = System.now().addHours(12);
        insert appCLVList;

        String icbs = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c appAccICBS = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccICBS.RecordTypeId = icbs;
        appAccICBS.Closed_Date__c = Date.today();
        insert appAccICBS;

        String vis = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Applicant_Account__c appAccVis = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccVis.RecordTypeId = vis;
        appAccVis.Closed_Date__c = Date.today();
        insert appAccVis;

        String gen = Schema.Sobjecttype.Applicant_Account__c.getRecordTypeInfosByName().get('Genesis').getRecordTypeId();
        Applicant_Account__c appAccGen = TestDataBuilder.createApplicantAcocunt(appCLVList[0].Id);
        appAccGen.RecordTypeId = gen;
        appAccGen.Account_Balance__c = '10000';
        insert appAccGen;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, app.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Applicant_Account_Involved_Party__c  testAAIP = TestDataBuilder.createApplicantAccountInvolvedParty(appAccGen.Id);
        insert testAAIP;

        Test.startTest();
            ApexPages.CurrentPage().getParameters().put('id',app.id);
            ApexPages.CurrentPage().getParameters().put('hasChanged','1');
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(app);
            APP_AccountDataExt appAccExt = new APP_AccountDataExt(standardCon);
            appAccExt.selectedAppACC = appAccGen.Id;
            appAccExt.selectedCLV = appCLVList.get(0).Id;
            appAccext.selectedAccountParty = testAAIP.Id;
            appAccExt.copyICBSCustomerNumber();
            appAccExt.displayApplicantAccountDetail();
            appAccGen.RecordTypeId = icbs;
            update appAccGen;
            appAccExt.displayApplicantAccountDetail();
            appAccGen.RecordTypeId = vis;
            update appAccGen;
            appAccExt.displayApplicantAccountDetail();
            appAccExt.loadSearchAndMatchCLV();
            //appAccExt.updateICBS();
            appAccExt.forceSearch();
        Test.stopTest();

        System.assertEquals(app.Id, appl.Application__c);
        System.assert(!admSet.isEmpty());
        System.assert(!appCLVList.isEmpty());
        System.assertEquals(appSearch.Id, appCLVList.get(0).Applicant_Search__c);
        System.assertEquals(appl.Id, appCLVList.get(0).Applicant__c);
        System.assertEquals(appCLVList.get(0).Id, appAccGen.Applicant_CLV__c);
    }   
    */
}