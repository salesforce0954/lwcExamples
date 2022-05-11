/*
* @Description: APP_DisbursementCC_INT test class
* @Author: Jade Serrano
* @Date Created: 04-MAR-2014
* @History:
*  =====================================================================
*      Jade - 04-MAR-2014: Created
*  =====================================================================
*/
@isTest
private class APP_DisbursementCC_INT_Test {
	
	@isTest static void test_method_one() {

		TestDataBuilder.createListInsurancePremiumVars();

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Disbursement', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Disbursement',objectDefinition.Name);//assert inserted Object_Definition__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Channel__c = 'Broker';
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
		insert disbursement;
		system.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Disbursement_INT;//ensure that APP_Disbursement_INT page is being tested
        pageRef.getParameters().put('id',disbursement.Id);
        Test.setCurrentPageReference(pageRef);

        APP_DisbursementCC_INT controller = new APP_DisbursementCC_INT(standardController);

        controller.refresh();

	}

	@isTest static void test_method_two() {				

		TestDataBuilder.createListInsurancePremiumVars();

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Disbursement', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Disbursement',objectDefinition.Name);//assert inserted Object_Definition__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Channel__c = 'Broker';
		application.Response_Code__c = 'New';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, String.valueOf(application.Response_Code__c));
		insert responseCodeControl;
		system.assertEquals(String.valueOf(application.Response_Code__c),responseCodeControl.Name);//assert inserted Response_Code_Control__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
		insert disbursement;
		system.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Disbursement_INT;//ensure that APP_Disbursement_INT page is being tested
        pageRef.getParameters().put('id',disbursement.Id);
        Test.setCurrentPageReference(pageRef);

        APP_DisbursementCC_INT controller = new APP_DisbursementCC_INT(standardController);

	}

	@isTest static void test_method_three() {

		TestDataBuilder.createListInsurancePremiumVars();

		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PC');
		insert responseCodeControl;
		system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Disbursement', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Disbursement',objectDefinition.Name);//assert inserted Object_Definition__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application.Channel__c = 'Broker';
		application.Response_Code__c = 'PC';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
		insert disbursement;
		system.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Disbursement_INT;//ensure that APP_Disbursement_INT page is being tested
        pageRef.getParameters().put('id',disbursement.Id);
        Test.setCurrentPageReference(pageRef);

        APP_DisbursementCC_INT controller = new APP_DisbursementCC_INT(standardController);

	}

	@isTest static void test_method_four() {

		TestDataBuilder.createListInsurancePremiumVars();
		
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(false,'PC');//false
		insert responseCodeControl;
		system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

		Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
		profileControl.SetupOwnerId = UserInfo.getProfileId();
		insert profileControl;
		system.assertEquals(UserInfo.getProfileId(),profileControl.SetupOwnerId);//assert inserted Response_Code_Control__c

		Object_Definition__c objectDefinition = new Object_Definition__c(Name = 'Disbursement', Object_id__c = 'abcd1234', Application__c = 'abcd1234');
		insert objectDefinition;
		system.assertEquals('Disbursement',objectDefinition.Name);//assert inserted Object_Definition__c

		Application__c application = TestDataBuilder.createApplication();//create application
		application .Channel__c = 'Broker';
		application.Response_Code__c = 'PC';
		insert application;
		system.assertNotEquals(null,application.Id);//assert inserted Application__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
        System.debug(disbursement);
		insert disbursement;
		system.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c

		ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);

		PageReference pageRef = Page.APP_Disbursement_INT;//ensure that APP_Disbursement_INT page is being tested
        pageRef.getParameters().put('id',disbursement.Id);
        Test.setCurrentPageReference(pageRef);

        APP_DisbursementCC_INT controller = new APP_DisbursementCC_INT(standardController);
        Decimal totalDisbursmentAmount = controller.getTotalDisbursementAmount();

        System.assertEquals(disbursement.Amount__c,totalDisbursmentAmount);
	}


    @isTest static void test_method_five_AU() 
    {
       
		Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

        Brand__c brandAU = TestDataBuilder.createBrand();
        insert brandAU;

		Application__c application = TestDataBuilder.createApplication();
		application.Channel__c = 'Broker';
		application.Response_Code__c = 'New';
        application.Brand_Lookup__c = brandAU.Id;
		insert application;
		System.assertNotEquals(null,application.Id);//assert inserted Application__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
		insert disbursement;
		System.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c
        
        //Create Custom Setting
        Direct_Debit_Field_Ids__c debitFields = new Direct_Debit_Field_Ids__c();
        debitFields.Name = 'Prepopulate_DirectDebit_AU';
        debitFields.Account_Name__c    = '00N9000000AaCi0';
        debitFields.Account_Number__c  = '00N9000000AaCi1';
		debitFields.Application__c     = 'CF00N9000000AaCWe';
        debitFields.Bank_Name__c       = '00N9000000AaCi3';
        debitFields.Branch_Location__c = '00N9000000AaCi4';
        debitFields.BSB_Number__c      = '00N9000000AaCi2'; 
        insert debitFields;
        
        APP_DisbursementCC_INT.createDirectDebit((String)disbursement.Id);
        
    }
    
    @isTest static void test_method_five_NZ() 
    {
       Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'New');
		insert responseCodeControl;
		system.assertEquals('New',responseCodeControl.Name);//assert inserted Response_Code_Control__c		

        Brand__c brandNZ = TestDataBuilder.createBrandNZ();
        insert brandNZ;

		Application__c application = TestDataBuilder.createApplication();
		application.Channel__c = 'Broker';
		application.Response_Code__c = 'New';
        application.Brand_Lookup__c = brandNZ.Id;
		insert application;
		System.assertNotEquals(null,application.Id);//assert inserted Application__c

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

		Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
		insert disbursement;
		System.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c
		
        //Create Custom Setting
        Direct_Debit_Field_Ids__c debitFields = new Direct_Debit_Field_Ids__c();
        debitFields.Name = 'Prepopulate_DirectDebit_NZ';
        debitFields.Account_Name__c    = '00N9000000AaCi0';
        debitFields.Account_Number__c  = '00N9000000AaCi1';
		debitFields.Application__c     = 'CF00N9000000AaCWe';
        debitFields.Bank_Name__c       = '00N9000000AaCi3';
        debitFields.Branch_Location__c = '00N9000000AaCi4';
        debitFields.Suffix_Number__c   = '00N9000000DjqIy';
        debitFields.Branch_Number__c   = '00N9000000DjqIx';
        insert debitFields;
        
        APP_DisbursementCC_INT.createDirectDebit((String)disbursement.Id);
        
    }
}