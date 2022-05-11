@isTest
public class APP_InsuranceHistoryExt_INT_Test {
	
	static testMethod void noRecord_Test(){
		
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        Test.StartTest();
        	ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_InsuranceHistoryExt_INT insurance = new APP_InsuranceHistoryExt_INT(standardCon);
            insurance.refresh();
        Test.StopTest();

        System.assertEquals(testApplication.Id, insurance.applicationId);
        System.assertEquals(insurance.insuranceHistoryList.isEmpty(), true);
	}

	static testMethod void record_Test(){
		
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Brand_Lookup__c = testBrand.Id;
        testApplication.Response_Code__c = 'Test';
        insert testApplication;

        List<Debug_Log__c> testDebugLogList = new List<Debug_Log__c>();

        for(Integer i=0; i<5; i++){
	        Debug_Log__c testDebugLog = new Debug_Log__c();
	        testDebugLog.Name = 'Test';
	        testDebugLog.Application__c = testApplication.Id;
	        testDebugLog.Insurance_Type__c = 'All';
	        testDebugLog.Previous_Value__c = '1';
	        testDebugLog.New_Value__c = '0';
	        testDebugLog.Changed_By__c = 'Name';
	        testDebugLogList.add(testDebugLog);
	    }

	    insert testDebugLogList;

        Test.StartTest();
        	ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_InsuranceHistoryExt_INT insurance = new APP_InsuranceHistoryExt_INT(standardCon);
            insurance.refresh();
        Test.StopTest();

        System.assertEquals(testApplication.Id, insurance.applicationId);
        System.assertEquals(!insurance.insuranceHistoryList.isEmpty(), true);
	}
}