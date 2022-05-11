/*
 * @Description: Test class for APP_SearchAndMatchCC class
 * @Author: August Del Rosario
 * @Date Created: Jan-30-2014
 * @History:
   =====================================================================
       28-01-14: Created - August
       03-25-15: Updated - Adrian Recio - Removed all test code based on (SeeAllData=True).
       									  This required me to remove all code that August created
       									  and create the code coverage from scratch.
       									- Build code coverage for search and match 
       									  auto population based on sales and leads.
   =====================================================================
 */
@isTest(SeeAllData=false)
private class APP_SearchAndMatchCC_Test {
    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 18 March 2013
    * @description Test method for searchFromSalesAndLeads
    */
   
    static testMethod void searchFromSalesAndLeads(){
    	
    	Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
        
        Applicant_Search__c testApplicantSearch = TestDataBuilder.appSearch();
        insert testApplicantSearch;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testApplicantSearch.Id, testApplicant.Id);
        insert testApplicantCLVList;
        
        List<Admin_Settings__c> testAdminSettings = TestDataBuilder.adminSet();
        // insert testAdminSettings;
        
        Test.startTest();
  			ApexPages.CurrentPage().getParameters().put('searchFromSalesAndLeads','TRUE');
            ApexPages.CurrentPage().getParameters().put('bDay','01');
            ApexPages.CurrentPage().getParameters().put('bMonth','02');
            ApexPages.CurrentPage().getParameters().put('bYear','1989');
            ApexPages.CurrentPage().getParameters().put('postcode','1111');
            ApexPages.CurrentPage().getParameters().put('mobilephone','11111111');
            //ApexPages.CurrentPage().getParameters().put('firstname','Nick');
            //ApexPages.CurrentPage().getParameters().put('lastname','Gordon');
            
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            APP_SearchAndMatchCC appSearchAndMatchCC = new APP_SearchAndMatchCC(standardCon);
            
            system.assertEquals(appSearchAndMatchCC.selectedCriteria,'PersonalInfo');
            system.assertEquals(appSearchAndMatchCC.isPersonalInfoSelected,true);
            system.assertEquals(appSearchAndMatchCC.birthDate,'01');
            system.assertEquals(appSearchAndMatchCC.birthMonth,'02');
            system.assertEquals(appSearchAndMatchCC.birthYear,'1989');
            system.assertEquals(appSearchAndMatchCC.appSearch.Date_of_Birth__c,'1989-02-01');
            system.assertEquals(appSearchAndMatchCC.appSearch.Post_Code__c,'1111');
            system.assertEquals(appSearchAndMatchCC.appSearch.Mobile_Phone__c,'11111111');
            //system.assertEquals(appSearchAndMatchCC.appSearch.First_Name__c,'Nick');
            //system.assertEquals(appSearchAndMatchCC.appSearch.Last_Name__c,'Gordon');
            
        Test.stopTest();
    }
  
    
    static testMethod void APP_SearchAndMatchCC_FirstSetTest(){
    	// Create Test Application
    	Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
	
		// Create Test Applicant
		
		// -- Applicant 1 --
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
		// Create Test App Search
        Applicant_Search__c testAppSearchVar = TestDataBuilder.appSearch();
        insert testAppSearchVar;
        
        // Create Test Applicant CLV
        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearchVar.Id, testApplicant.Id);
    	insert testApplicantCLVList;
    	    	
        // Create Applicant Account
        Applicant_Account__c testAppAccVar = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
        insert testAppAccVar;

        // Create Test Profile Control
        Profile_Control__c pcVar = TestDataBuilder.createProfileControl(true);
        pcVar.Search_and_Match_View__c = true;
        pcVar.Search_and_Match_Edit__c = true;
        pcVar.SetupOwnerId = UserInfo.getProfileId();
        insert pcVar;
        
        // Create Test Account
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        // Create Test Opportunity
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        // Create Test Response Code Control
        Response_Code_Control__c rccVar = TestDataBuilder.createResponseCodeControl(true,'001Test');
        insert rccVar;

		// Create test ws for requested name sales
		Web_Service_Settings__c testWSSettingReqNameSales = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
	    insert testWSSettingReqNameSales;
	        
        Test.startTest();
  			
  			// Test Constructor
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            
            // Satisfy condition without webservice setting fo search timeout and app go back is '0' and 1 applicant
            ApexPages.CurrentPage().getParameters().put('goBack','0');
            APP_SearchAndMatchCC appSearchAndMatchCC = new APP_SearchAndMatchCC(standardCon);
            
            // Satisfy condition with webservice setting fo search timeout and app go back is '1' and 2 applicant
            // -- Applicant 2 -- 
        	Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        	insert testApplicant2;
        	
            ApexPages.CurrentPage().getParameters().put('goBack','1');
            
            // -- Create Web Service Settings -- 
	        Web_Service_Settings__c testWSSettingTimeOut = TestDataBuilder.createWebServiceSettings('SearchTimeOut','45');
	        insert testWSSettingTimeOut;
	        
	        appSearchAndMatchCC = new APP_SearchAndMatchCC(standardCon);

			// Test pageControl
            appSearchAndMatchCC.pageControl('001Test');
            appSearchAndMatchCC.pageControl(null);

            // Test search
            appSearchAndMatchCC.goBack = '0';
            appSearchAndMatchCC.appSearch = testAppSearchVar;
            
            // Account Number should not be null
            appSearchAndMatchCC.isPersonalInfoSelected = true;
            appSearchAndMatchCC.isAcctNumSelected = true;
            appSearchAndMatchCC.appSearch.Account_Number__c = null;
            appSearchAndMatchCC.search();
            
            // Account Number should be numeric
            appSearchAndMatchCC.isAcctNumSelected = true;
            appSearchAndMatchCC.appSearch.Account_Number__c = 'ABC';
            appSearchAndMatchCC.search();
            appSearchAndMatchCC.appSearch.Account_Number__c = '00111';
            
            // Post code and birthdate validation
            appSearchAndMatchCC.isPersonalInfoSelected = true;
            appSearchAndMatchCC.appSearch.date_of_birth__c = null;
            appSearchAndMatchCC.appSearch.post_code__c = null;
			appSearchAndMatchCC.search();
			appSearchAndMatchCC.appSearch.Date_of_Birth__c ='14/12/1989';
			appSearchAndMatchCC.appSearch.post_code__c = null;
			appSearchAndMatchCC.search();
			appSearchAndMatchCC.appSearch.Date_of_Birth__c =null;
			appSearchAndMatchCC.appSearch.post_code__c = '3000';
			appSearchAndMatchCC.search();
			
            // ERR8 validation for birth date
            appSearchAndMatchCC.appSearch.Date_of_Birth__c = 'ERR8';
            appSearchAndMatchCC.search();
			
			// ERR6 validation for birth date
			appSearchAndMatchCC.appSearch.Date_of_Birth__c ='ERR6';
			appSearchAndMatchCC.search();
			
			// ERR7 validation for birth date 
			appSearchAndMatchCC.appSearch.Date_of_Birth__c ='ERR7';
			appSearchAndMatchCC.search();
			
			// Satisfy
			appSearchAndMatchCC.appSearch.Date_of_Birth__c ='14/12/1989';
			appSearchAndMatchCC.search();
			
			// Test checkPushTopics
         	appSearchAndMatchCC.checkPushTopic();
         	
         	// Test clearSearch
         	appSearchAndMatchCC.clearSearch();
         	
         	// Test Format Datestring and Rowstyle
         	String formatDateStrVar = appSearchAndMatchCC.FormatDateString('12/14/1989');
			String rowStyleVar = appSearchAndMatchCC.RowStyle(3);
         	
         	// Test Move
         	// Null rowId and dest
         	PageReference pgVar = appSearchAndMatchCC.move();
         	
         	appSearchAndMatchCC.appCLVList = testApplicantCLVList;
			system.debug('app clv size:' + appSearchAndMatchCC.appCLVList.size());
			
			ApexPages.CurrentPage().getParameters().put('rowId',testApplicantCLVList[0].Id);
			ApexPages.CurrentPage().getParameters().put('dest','1');
			appSearchAndMatchCC.useGrid='0';
			pgVar = appSearchAndMatchCC.move();
			
			ApexPages.CurrentPage().getParameters().put('rowId',testApplicantCLVList[0].Id);
			ApexPages.CurrentPage().getParameters().put('dest','2');
			appSearchAndMatchCC.useGrid='0';
			pgVar = appSearchAndMatchCC.move();
			
			ApexPages.CurrentPage().getParameters().put('rowId',testApplicantCLVList[0].Id);
			ApexPages.CurrentPage().getParameters().put('dest','X');
			appSearchAndMatchCC.useGrid='1';
			pgVar = appSearchAndMatchCC.move();
			
			ApexPages.CurrentPage().getParameters().put('rowId',testApplicantCLVList[0].Id);
			ApexPages.CurrentPage().getParameters().put('dest','X');
			appSearchAndMatchCC.useGrid='2';
			pgVar = appSearchAndMatchCC.move();
			
						
			// Test saveAndNext
			
			// Application Id is null
			appSearchAndMatchCC.applicationId = null;
			PageReference saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Application Id is not null but searchCounter is zero
			appSearchAndMatchCC.searchCounter = 0;
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			appSearchAndMatchCC.searchCounter = 1;
			
			// Search performed but application is null and lead(opportunity is 'Conditionally Approved Offer')
			oppList[0].Promotional_Campaign__c = 'Conditionally Approved Offer';
			ApexPages.CurrentPage().getParameters().put('promotionType',oppList[0].Promotional_Campaign__c);
			ApexPages.CurrentPage().getParameters().put('oppId',oppList[0].Id);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Search performed but application is null and lead(opportunity is 'Conditionally Approved Offer')
			oppList[0].Promotional_Campaign__c = '60 Day Certificate';
			ApexPages.CurrentPage().getParameters().put('promotionType',oppList[0].Promotional_Campaign__c);
			ApexPages.CurrentPage().getParameters().put('oppId',oppList[0].Id);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// No Special oppotunity status - ApplicationId is null
			oppList[0].Promotional_Campaign__c = '';
			ApexPages.CurrentPage().getParameters().put('promotionType',oppList[0].Promotional_Campaign__c);
			ApexPages.CurrentPage().getParameters().put('oppId',oppList[0].Id);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// No Special opportunity status - ApplicationId is populated		
			//  -- Has Applicant 1,Applicant 2 --
			// Has App1CLV1 and App1CLV2
			
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has App1CLV2
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// -- No Applicant 1 --
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			

			// -- No Applicant 2 --
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = testApplication.Id;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// No Special opportunity status - ApplicationId is not populated			
			//  -- Has Applicant 1,Applicant 2 --
			// Has App1CLV1 and App1CLV2
			
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has App1CLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();

			// Condition migrated to APP_SearchAndMatchCC_SecondSetTest test method
			// to avoid soql limits. Conditions are massive!
			/*
			// -- No Applicant 1 --
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			

			// -- No Applicant 2 --

			// Has AppCLV1
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			


			// Deleted Ids
			
			appSearchAndMatchCC.deletedIds1 = new List<Id>();
			appSearchAndMatchCC.deletedIds1.add(testApplicantCLVList[0].Id);
			appSearchAndMatchCC.deletedIds2 = new List<Id>();
			appSearchAndMatchCC.deletedIds2.add(testApplicantCLVList[1].Id);
			
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			*/

            // Test getApplicantCLVRecords
            appSearchAndMatchCC.goBack = '0';
            appSearchAndMatchCC.InAppClv1.put(testApplicantCLVList[0].Id,true);
            appSearchAndMatchCC.InAppClv2.put(testApplicantCLVList[1].Id,true);
            appSearchAndMatchCC.getApplicantCLVRecords();
            
            appSearchAndMatchCC.goBack = '1';
            appSearchAndMatchCC.InAppClv1.put(testApplicantCLVList[0].Id,true);
            appSearchAndMatchCC.InAppClv2.put(testApplicantCLVList[1].Id,true);
            appSearchAndMatchCC.getApplicantCLVRecords();

         	/*
            // Test createAuditLog - Cancelled test since method is private
            //List<Id> testId = new List<Id>();
            //String auditCode, String auditAction, List<Id> idAddRem, String auditApplicationId, String auditCustId, String auditAccNumber
            //appSearchAndMatchCC.createAuditLog('AUD001', 'Fix Error', testId, '001N000000OfXBi', '001', '002');       
			*/
			
			
			
			
			
			
			// Test getter setter variables
            string selectedApplicantVar = appSearchAndMatchCC.selectedApplicant;
            string selectedApplicantCLVVar = appSearchAndMatchCC.selectedApplicantCLV;
            string applicantDirectionVar = appSearchAndMatchCC.applicantDirection;
            
            boolean SearchInProgressVar = appSearchAndMatchCC.SearchInProgress;
            boolean SearchDisabledValErrVar = appSearchAndMatchCC.SearchDisabledValErr;
            
            // Test getter setter methods
			Boolean showProceedToCustomerDetailsVar = appSearchAndMatchCC.showProceedToCustomerDetails;
            
            // Test showPopup - Depricated
            /*
            ApexPages.CurrentPage().getParameters().put('rowId',testApplicantCLVList[0].Id);
            appSearchAndMatchCC.displayPopup = false;
            appSearchAndMatchCC.appAccount = null;
            APP_SearchAndMatchCC.rowId = null;
            appSearchAndMatchCC.showPopup();
            
            system.assertEquals(appSearchAndMatchCC.displayPopup,true);
            system.assertEquals(appSearchAndMatchCC.appAccount.Id,testAppAccVar.Id);
            system.assertEquals(APP_SearchAndMatchCC.rowId,testApplicantCLVList[0].Id);
         	*/

			// Test getName
            system.assertEquals(appSearchAndMatchCC.getName(),'ApplicantCLV');
          
            // Test setDate
            appSearchAndMatchCC.setDate();
            
            // Test monthOptions
            List<SelectOption> mOptionList = appSearchAndMatchCC.monthOptions;
			system.assertEquals(mOptionList[0].getValue(),'Select');
			system.assertEquals(mOptionList[1].getValue(),'01');
			system.assertEquals(mOptionList[2].getValue(),'02');
			system.assertEquals(mOptionList[3].getValue(),'03');
			system.assertEquals(mOptionList[4].getValue(),'04');
			system.assertEquals(mOptionList[5].getValue(),'05');
			system.assertEquals(mOptionList[6].getValue(),'06');
			system.assertEquals(mOptionList[7].getValue(),'07');
			system.assertEquals(mOptionList[8].getValue(),'08');
			system.assertEquals(mOptionList[9].getValue(),'09');
			system.assertEquals(mOptionList[10].getValue(),'10');
			system.assertEquals(mOptionList[11].getValue(),'11');
			system.assertEquals(mOptionList[12].getValue(),'12');
			
			system.assertEquals(mOptionList[0].getLabel(),'Month');
			system.assertEquals(mOptionList[1].getLabel(),'January');
			system.assertEquals(mOptionList[2].getLabel(),'February');
			system.assertEquals(mOptionList[3].getLabel(),'March');
			system.assertEquals(mOptionList[4].getLabel(),'April');
			system.assertEquals(mOptionList[5].getLabel(),'May');
			system.assertEquals(mOptionList[6].getLabel(),'June');
			system.assertEquals(mOptionList[7].getLabel(),'July');
			system.assertEquals(mOptionList[8].getLabel(),'August');
			system.assertEquals(mOptionList[9].getLabel(),'September');
			system.assertEquals(mOptionList[10].getLabel(),'October');
			system.assertEquals(mOptionList[11].getLabel(),'November');
			system.assertEquals(mOptionList[12].getLabel(),'December');
			
			// Test getYearOptions
            List<SelectOption> yearOptionList = appSearchAndMatchCC.getYearOptions();
            // assert year result here
            
            // Test getDateOptions
            appSearchAndMatchCC.birthMonth = null;
            List<SelectOption> nullOptionList = appSearchAndMatchCC.getDateOptions();
            appSearchAndMatchCC.birthMonth = '02';
            List<SelectOption> twoOptionList = appSearchAndMatchCC.getDateOptions();
            appSearchAndMatchCC.birthMonth = '01';
            List<SelectOption> oneOptionList = appSearchAndMatchCC.getDateOptions();
            appSearchAndMatchCC.birthMonth = '04';
            List<SelectOption> fourOptionList = appSearchAndMatchCC.getDateOptions();
            // assert date options here
            
            // Test SearchCriteriaOptions
            List<SelectOption>optionList = appSearchAndMatchCC.SearchCriteriaOptions;
			system.assertEquals(optionList[0].getValue(), '');
			system.assertEquals(optionList[1].getValue(), 'AcctNum');
			system.assertEquals(optionList[2].getValue(), 'PersonalInfo');
			system.assertEquals(optionList[0].getLabel(), 'SELECT SEARCH CRITERIA');
			system.assertEquals(optionList[1].getLabel(), 'SEARCH BY ACCOUNT NUMBER');
			system.assertEquals(optionList[2].getLabel(), 'SEARCH BY PERSONAL INFORMATION');
			
			// Test renderCriteria
			appSearchAndMatchCC.selectedCriteria='AcctNum';
			appSearchAndMatchCC.renderCriteria();
			system.assertEquals(appSearchAndMatchCC.isAcctNumSelected,true);
			system.assertEquals(appSearchAndMatchCC.isPersonalInfoSelected,false);
			
			appSearchAndMatchCC.selectedCriteria='PersonalInfo';
			appSearchAndMatchCC.renderCriteria();
			system.assertEquals(appSearchAndMatchCC.isAcctNumSelected,false);
			system.assertEquals(appSearchAndMatchCC.isPersonalInfoSelected,true);
			
			ApexPages.CurrentPage().getParameters().put('goBack','1');
			appSearchAndMatchCC.renderCriteria();
			ApexPages.CurrentPage().getParameters().put('goBack','0');
			appSearchAndMatchCC.renderCriteria();

			// Test getPrevSelectionExists
			Boolean getPrevSelectionExistsVar = appSearchAndMatchCC.getPrevSelectionExists();
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			getPrevSelectionExistsVar = appSearchAndMatchCC.getPrevSelectionExists();
			
			// Test getProceedToNext
			// Search Counter is zero
			appSearchAndMatchCC.searchCounter = 0;
			Boolean getProceedToNextVar = appSearchAndMatchCC.getProceedToNext();
			
			// Search Counter is one and msg code is '0000' and there is one applicant clv
			appSearchAndMatchCC.appCLVList = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.searchCounter = 1;
			testApplicantCLVList[0].Message_Code__c='0000';
			appSearchAndMatchCC.appCLVList.add(testApplicantCLVList[0]);
			getProceedToNextVar = appSearchAndMatchCC.getProceedToNext();
			
			// Search Counter is one and msg code is empty and there is one applicant clv
			testApplicantCLVList[0].Message_Code__c='';
			appSearchAndMatchCC.appCLVList.add(testApplicantCLVList[0]);
			getProceedToNextVar = appSearchAndMatchCC.getProceedToNext();

			// Search Counter is 2 and applicant clv record is greater than 2
			appSearchAndMatchCC.searchCounter = 2;
			appSearchAndMatchCC.appCLVList.add(testApplicantCLVList[1]);
			getProceedToNextVar = appSearchAndMatchCC.getProceedToNext();
			
			// Search Counter is 2 and applicant clv record is greater than 2
			appSearchAndMatchCC.searchCounter = 2;
			appSearchAndMatchCC.appCLVList = new List<Applicant_CLV__c>();
			getProceedToNextVar = appSearchAndMatchCC.getProceedToNext();
			            
            // Test displayTimeoutMessage
			appSearchAndMatchCC.displayTimeoutMessage();
			
			// Test closePop
            appSearchAndMatchCC.closePopup();
			
        Test.stopTest();
    }

     static testMethod void APP_SearchAndMatchCC_SecondSetTest(){
    	// Create Test Application
    	Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
	
		// Create Test Applicant
		
		// -- Applicant 1 --
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;
        
		// Create Test App Search
        Applicant_Search__c testAppSearchVar = TestDataBuilder.appSearch();
        insert testAppSearchVar;
        
        // Create Test Applicant CLV
        List<Applicant_CLV__c> testApplicantCLVList = TestDataBuilder.applicantCLVList(testAppSearchVar.Id, testApplicant.Id);
    	insert testApplicantCLVList;
    	    	
        // Create Applicant Account
        Applicant_Account__c testAppAccVar = TestDataBuilder.createApplicantAcocunt(testApplicantCLVList[0].Id);
        insert testAppAccVar;

        // Create Test Profile Control
        Profile_Control__c pcVar = TestDataBuilder.createProfileControl(true);
        pcVar.Search_and_Match_View__c = true;
        pcVar.Search_and_Match_Edit__c = true;
        pcVar.SetupOwnerId = UserInfo.getProfileId();
        insert pcVar;
        
        // Create Test Account
        List<Account> accList = TestDataBuilder.createAccounts(1);
        insert accList;
        
        // Create Test Opportunity
        List<Opportunity> oppList = TestDataBuilder.createOpportunities(1, accList[0].Id);
        insert oppList;
        
        // Create Test Response Code Control
        Response_Code_Control__c rccVar = TestDataBuilder.createResponseCodeControl(true,'001Test');
        insert rccVar;

		// Create test ws for requested name sales
		Web_Service_Settings__c testWSSettingReqNameSales = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
	    insert testWSSettingReqNameSales;
	        
        Test.startTest();
  			
  			// Test Constructor
            ApexPages.standardController standardCon = new ApexPages.standardController(testApplication);
            
            // Satisfy condition without webservice setting fo search timeout and app go back is '0' and 1 applicant
            ApexPages.CurrentPage().getParameters().put('goBack','0');
            APP_SearchAndMatchCC appSearchAndMatchCC = new APP_SearchAndMatchCC(standardCon);
            
            // Satisfy condition with webservice setting fo search timeout and app go back is '1' and 2 applicant
            // -- Applicant 2 -- 
        	Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        	insert testApplicant2;
        	
            ApexPages.CurrentPage().getParameters().put('goBack','1');
            
            // -- Create Web Service Settings -- 
	        Web_Service_Settings__c testWSSettingTimeOut = TestDataBuilder.createWebServiceSettings('SearchTimeOut','45');
	        insert testWSSettingTimeOut;
	        
	        appSearchAndMatchCC = new APP_SearchAndMatchCC(standardCon);
			
			PageReference saveAndNextPR = appSearchAndMatchCC.saveAndNext();

			// Test saveAndNext remaining conditions

			// -- No Applicant 1 --
			// Has AppCLV1
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = testApplicant2;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			

			// -- No Applicant 2 --

			// Has AppCLV1
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
			// Has AppCLV1 and AppCLV2
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = testApplicant;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv1.add(testApplicantCLVList[0]);
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2.add(testApplicantCLVList[1]);
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
	
			// Deleted Ids
			
			appSearchAndMatchCC.deletedIds1 = new List<Id>();
			appSearchAndMatchCC.deletedIds1.add(testApplicantCLVList[0].Id);
			appSearchAndMatchCC.deletedIds2 = new List<Id>();
			appSearchAndMatchCC.deletedIds2.add(testApplicantCLVList[1].Id);
			
			appSearchAndMatchCC.applicationId = null;
			appSearchAndMatchCC.applicant1 = null;
			appSearchAndMatchCC.applicant2 = null;
			appSearchAndMatchCC.appClv1 = new List<Applicant_CLV__c>();
			appSearchAndMatchCC.appClv2 = new List<Applicant_CLV__c>();
			saveAndNextPR = appSearchAndMatchCC.saveAndNext();
			
        Test.stopTest();
    }
}