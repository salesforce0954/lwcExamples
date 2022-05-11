/*
 * @Description: APP_Register_INTCC test class
 * @Author: Jade Serrano
 * @Date Created: 12-MAR-2014
 * @History:
 *  =====================================================================
 *      Jade - 12-MAR-2014: Created
 *  =====================================================================
 */
 @isTest
private class APP_Register_INTCC_Test {	

	 /* 
     *  Description: Test Registration Method
     *  Author: Adrian Recio
     *  Input Parameters: NA
     *  Return: Void
     */
	static testMethod void testRegistrationJoint(){

		// Grant Profile Access to current user
		/*
		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        profileControl.SetupOwnerId = UserInfo.getProfileId();
        insert profileControl;
	    */

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
		oppVar[0].Application_Number__c = '18223345'; 
		oppVar[0].Contract_Date__c = Date.valueOf('2015-08-31');
		oppVar[0].CampaignId = camList[0].Id;
		insert oppVar;
						
		// Create Brand
		List<Brand__c> brandList = new List<Brand__c>();
		Brand__c testBrandAU = TestDataBuilder.createBrand();
		testBrandAU.Name = 'GE Money AU';
		testBrandAU.Country__c = 'AU';
		testBrandAU.Template_Save_Retrieve_Sales__c = 'AUTemp';
		brandList.add(testBrandAU);

		Brand__c testBrandNZ = TestDataBuilder.createBrand();
		testBrandNZ.Name = 'GE Money NZ';
		testBrandNZ.Country__c = 'NZ';
		testBrandNZ.Template_Save_Retrieve_Sales__c = 'NZTemp';
		brandList.add(testBrandNZ);
        insert brandList;

        // Create Applicaton 
        List<Application__c>appMainList = new List<Application__c>();
		Application__c testApplication1 = TestDataBuilder.createApplication();
		testApplication1.Status__c = 'New';
        testApplication1.Brand_Lookup__c = testBrandAU.Id;
        testApplication1.Response_Code__c = 'New';
        testApplication1.Contract_Account_Number__c = '18223344';
        testApplication1.Max_Monthly_Capacity__c = 10000;
        testApplication1.Application_Type__c = 'Joint';
        testApplication1.Brand_String__c = 'GE Money AU';
        appMainList.add(testApplication1);

        Application__c testApplication2 = TestDataBuilder.createApplication();
		testApplication2.Status__c = 'New';
        testApplication2.Brand_Lookup__c = testBrandNZ.Id;
        testApplication2.Response_Code__c = 'New';
        testApplication2.Contract_Account_Number__c = '18223345';
        testApplication2.Max_Monthly_Capacity__c = 10000;
        testApplication2.Application_Type__c = 'Joint';
        testApplication2.Brand_String__c = 'GE Money NZ';
        appMainList.add(testApplication2);

        Application__c testApplication3 = TestDataBuilder.createApplication();
		testApplication3.Status__c = 'New';
        testApplication3.Brand_Lookup__c = testBrandNZ.Id;
        testApplication3.Response_Code__c = 'New';
        testApplication3.Contract_Account_Number__c = '18223346';
        testApplication3.Max_Monthly_Capacity__c = 10000;
        testApplication3.Application_Type__c = 'Joint';
        testApplication3.Brand_String__c = 'GE Money NZ';
        appMainList.add(testApplication3);

        insert appMainList;
        
        // Create Joint Applicant
        List<Applicant__c>appliList = new List<Applicant__c>();
        
        // Create Applicants
        	//AU - Joint with existing user and applicant information is no populated
	        // Applicant 1
	        Applicant__c testApplicantAU = TestDataBuilder.createApplicant(accVar[0].Id, testApplication1.Id);
	        testApplicantAU.Has_AML__c = true; 
	        testApplicantAU.Is_Primary_Applicant__c = true;
	        testApplicantAU.First_Name__c = null;
	        testApplicantAU.Last_Name__c = null;
	        testApplicantAU.Email_Address__c = null;
	        testApplicantAU.Date_Of_Birth__c = null;
			appliList.add(testApplicantAU);
			// Applicant 2        
	        Applicant__c testApplicantAU2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication1.Id);
	        testApplicantAU2.First_Name__c = null;
	        testApplicantAU2.Last_Name__c = null;
	        testApplicantAU2.Email_Address__c = null;
	        testApplicantAU2.Date_Of_Birth__c = null;
			appliList.add(testApplicantAU2);

			//NZ - Joint with existing user and applicant information is populated
			// Applicant 1
	        Applicant__c testApplicantNZ = TestDataBuilder.createApplicant(accVar[0].Id, testApplication2.Id);
	        testApplicantNZ.Has_AML__c = true; 
	        testApplicantNZ.Is_Primary_Applicant__c = true;
	        testApplicantNZ.First_Name__c = 'Adrian';
	        testApplicantNZ.Last_Name__c = 'Recio';
	        testApplicantNZ.Email_Address__c = 'ar14@cloudsherpas.com';
	        testApplicantNZ.Date_Of_Birth__c = '14-12-1989';
			appliList.add(testApplicantNZ);
			// Applicant 2        
	        Applicant__c testApplicantNZ2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication2.Id);
	        testApplicantNZ2.First_Name__c = 'May';
	        testApplicantNZ2.Last_Name__c = 'Roque';
	        testApplicantNZ2.Email_Address__c = 'mr22@cloudsherpas.com';
	        testApplicantNZ2.Date_Of_Birth__c = '22-05-1983';
			appliList.add(testApplicantNZ2);

			//NZ - Joint with without existing user and applicant information is populated
			// Applicant 1
	        Applicant__c testApplicantNZX = TestDataBuilder.createApplicant(accVar[0].Id, testApplication3.Id);
	        testApplicantNZX.Has_AML__c = true; 
	        testApplicantNZX.Is_Primary_Applicant__c = true;
	        testApplicantNZX.First_Name__c = 'Adrian';
	        testApplicantNZX.Last_Name__c = 'Recio';
	        testApplicantNZX.Email_Address__c = 'ar14@cloudsherpas.com';
	        testApplicantNZX.Date_Of_Birth__c = '14-12-1989';
			appliList.add(testApplicantNZX);
			// Applicant 2        
	        Applicant__c testApplicantNZX2 = TestDataBuilder.createApplicant(accVar[0].Id, testApplication3.Id);
	        testApplicantNZX2.First_Name__c = 'May';
	        testApplicantNZX2.Last_Name__c = 'Roque';
	        testApplicantNZX2.Email_Address__c = 'mr22@cloudsherpas.com';
	        testApplicantNZX2.Date_Of_Birth__c = '22-05-1983';
			appliList.add(testApplicantNZX2);
			insert appliList;
		// End Create Applicants

		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];

        // Build Profile Map
        set<String>profNameSet = new set<String>();
        profNameSet.add('System Administrator');
        profNameSet.add(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1);	// Default Profile of AU Applicant 1
        profNameSet.add(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1);	// Default Profile of NZ Applicant 2
        profNameSet.add(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2);	// Default Profile of AU Applicant 1
        profNameSet.add(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2);	// Default Profile of NZ Applicant 2

        List<Profile>profList = [SELECT Id, Name FROM Profile WHERE Name In :profNameSet];
        Map<String,Id> profMap = new Map<String,Id>();

        for(Profile profVar: profList){
        	profMap.put(profVar.Name,profVar.Id);
        }

        // Pull Default Admin Role
        Id roleId = [SELECT Id FROM UserRole WHERE Name = 'System Administrator' LIMIT 1].Id;//query role

        List<User>testUserList = new List<User>();

        // Create Test Admin User
        User userVar = TestDataBuilder.createUser(profMap.get('System Administrator'));
        userVar.userRoleId = roleId;

	    system.runAs(thisUser){
	        insert userVar;
    	}

    	 // Create Person Account
        List<Account> accPersonList = testDataBuilder.createPersonAccounts(4);
		accPersonList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		accPersonList[1].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		accPersonList[2].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		accPersonList[3].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
		accPersonList[0].CLV_Customer_Id__c = '14301';
		accPersonList[1].CLV_Customer_Id__c = '14302';
		accPersonList[2].CLV_Customer_Id__c = '14303';
		accPersonList[3].CLV_Customer_Id__c = '14304';
		accPersonList[0].OwnerId = userVar.Id;
		accPersonList[1].OwnerId = userVar.Id;
		accPersonList[2].OwnerId = userVar.Id;
		accPersonList[3].OwnerId = userVar.Id;
		insert accPersonList;

		// Pull Person Account child Contacts
       	Set<Id> parentAccIdSet = new Set<Id>();
        parentAccIdSet.add(accPersonList[0].Id);
        parentAccIdSet.add(accPersonList[1].Id);
        parentAccIdSet.add(accPersonList[2].Id);
        parentAccIdSet.add(accPersonList[3].Id);

        List<Contact> conCommList = [Select Id from Contact where AccountId In :parentAccIdSet] ;

        
     	// Create AU Applicant 1 User
        User userAppAU1 = TestDataBuilder.createUser(profMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT1));
        userAppAU1.IsRegistered__c = true;
        userAppAU1.userRoleId = null; 
        userAppAU1.AppId__c = string.valueOf(testApplication1.Id);
        userAppAU1.ContactId = conCommList[0].Id;
        userAppAU1.Username = 'auApp1@ge.com';
        userAppAU1.CommunityNickName = 'au1';
        userAppAU1.Alias = 'au1';
        userAppAU1.Brand__c = 'GE Money AU';
        testUserList.add(userAppAU1);

        // Create AU Applicant 2 User
        User userAppAU2 = TestDataBuilder.createUser(profMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_AU_APPLICANT2));
        userAppAU2.IsRegistered__c = true;
        userAppAU2.userRoleId = null; 
        userAppAU2.AppId__c = string.valueOf(testApplication1.Id);
        userAppAU2.ContactId = conCommList[1].Id;
        userAppAU2.Username = 'auApp2@ge.com';
        userAppAU2.CommunityNickname = 'au2';
        userAppAU2.Alias = 'au2';
        userAppAU2.Brand__c = 'GE Money AU';
        testUserList.add(userAppAU2);

        // Create NZ Applicant 1 User
        User userAppNZ1 = TestDataBuilder.createUser(profMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT1));
        userAppNZ1.IsRegistered__c = true;
        userAppNZ1.userRoleId = null; 
        userAppNZ1.AppId__c = string.valueOf(testApplication2.Id);
        userAppNZ1.ContactId = conCommList[2].Id;
        userAppNZ1.Username = 'nzApp1@ge.com';
        userAppNZ1.CommunityNickname = 'nz1';
        userAppNZ1.Alias = 'nz1';
        userAppNZ1.Brand__c = 'GE Money NZ';
        testUserList.add(userAppNZ1);

        // Create NZ Applicant 2 User
        User userAppNZ2 = TestDataBuilder.createUser(profMap.get(GEN_OriginationsConstants.COMMUNITY_USER_PROFILE_NZ_APPLICANT2));
        userAppNZ2.IsRegistered__c = true;
        userAppNZ2.userRoleId = null; 
        userAppNZ2.AppId__c = string.valueOf(testApplication2.Id);
        userAppNZ2.ContactId = conCommList[3].Id;
        userAppNZ2.Username = 'nzApp2@ge.com';
        userAppNZ2.CommunityNickname = 'nz2';
        userAppNZ2.Alias = 'nz2';
        userAppNZ2.Brand__c = 'GE Money NZ';
        testUserList.add(userAppNZ2);

        // Create Email Template
        List<EmailTemplate> etList = new List<EmailTemplate>();
        EmailTemplate ETAU = TestDataBuilder.createEmailTemplate(testBrandAU.Template_Save_Retrieve_Sales__c);
        etList.add(ETAU);
        EmailTemplate ETNZ = TestDataBuilder.createEmailTemplate(testBrandNZ.Template_Save_Retrieve_Sales__c);
        etList.add(ETNZ);

	    system.runAs(thisUser){
	        insert testUserList;
	        insert etList;
	    }

		test.startTest();
			system.runAs(userVar){
				// Fire all constructor validation error for applicant
				ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication1);
				APP_Register_INTCC ariCntrl = new APP_Register_INTCC(standardController);	

				// Assert to be continued here
			}


			system.runAs(userVar){
				// Reset this static list or else you will get the 
				// same applicant information from the first constructor call.
				APP_CommonVariables.applicantList = null; 
				// Satisfy all constructor validation error for applicant
				ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication2);
				APP_Register_INTCC ariCntrl = new APP_Register_INTCC(standardController);

				// Satisfy Create Condition for Applicant with existing user
				ariCntrl.createUser();
				ariCntrl.createUser2();

				// Assert to be continued here
			}
			
			userVar.userRoleId = null;

			system.runAs(userVar){
				// Reset this static list or else you will get the 
				// same applicant information from the first constructor call.
				APP_CommonVariables.applicantList = null; 

				// No Role and Applicant User
				ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication3);
				APP_Register_INTCC ariCntrl = new APP_Register_INTCC(standardController);

				// Assert to be continued here
			}

			userVar.userRoleId = roleId;

			system.runAs(userVar){
				// Reset this static list or else you will get the 
				// same applicant information from the first constructor call.
				APP_CommonVariables.applicantList = null; 

				// No Role and Applicant User
				ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(testApplication3);
				APP_Register_INTCC ariCntrl = new APP_Register_INTCC(standardController);

				// Satisfy Create Condition for Applicant without existing user
				ariCntrl.createUser();
				ariCntrl.createUser2();
				ariCntrl.cancel();

				// Assert to be continued here
			}
		test.stopTest();
	}	

}