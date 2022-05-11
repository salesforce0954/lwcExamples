@isTest
private class APP_WaitPageExt_IntTest {
	
	@isTest static void test_method_one() {
		// Implement test code
		Application__c application = TestDataBuilder.createApplication();
		insert application;
		Test.startTest();
			Test.setCurrentPageReference(new PageReference('Page.App_WaitPageStaff')); 
			System.currentPageReference().getParameters().put('id', application.Id);
			ApexPages.StandardController standardCon = new ApexPages.StandardController(application);
			APP_WaitPageExt_INT appWait = new APP_WaitPageExt_INT(standardCon);	
			appWait.name = 'Test';				
			appWait.hideComponent();
			appwait.proceedToOffer();			
		Test.stopTest();

		System.assert(!appWait.showComponent);
	}

	@isTest static void test_method_two(){
		// Implement test code		
		List<Insurance_Premium_Calculation_Variables__c> insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
		insert insurancePremiumCalculationVariables;
		Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('ResponseTimeOut', '60');
		insert testWebServiceSettings;
		Test.startTest();
			Application__c application = TestDataBuilder.createApplication();
			insert application;

			// Jerome
	        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
	        
	        Brand__c testBrand = TestDataBuilder.createBrand();
        	insert testBrand;

	        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
	        insert testProduct;

	        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
	        insert testProductVersion;

	        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(application.Id,ONRrecordType.Id);
	        insert testONR;

	        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(application.Id, testONR.Id);
	        insert testLoanPurpose;

	        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
	        insert rateCard;

	        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
	        insert rate;
	        // end
			
			Test.setCurrentPageReference(new PageReference('Page.App_WaitPageStaff')); 
			System.currentPageReference().getParameters().put('id', application.Id);
			ApexPages.StandardController standardCon = new ApexPages.StandardController(application);
			APP_WaitPageExt_INT appWait = new APP_WaitPageExt_INT(standardCon);							
			appWait.name = 'Test';	
			

			Application_Response__c appResp = TestDataBuilder.createApplicationResponse(application.Id);
			insert appResp;			
			appWait.hideComponent();
			appwait.proceedToContractAcceptance();
			appWait.checkPushTopic();
		Test.stopTest();

		System.assert(!appWait.showComponent);
	}
}