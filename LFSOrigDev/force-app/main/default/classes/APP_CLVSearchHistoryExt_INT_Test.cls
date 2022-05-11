@isTest
public class APP_CLVSearchHistoryExt_INT_Test {
	
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
            APP_CLVSearchHistoryExt_INT search = new APP_CLVSearchHistoryExt_INT(standardCon);
            search.refresh();
        Test.StopTest();

        System.assertEquals(testApplication.Id, search.applicationId);
        System.assertEquals(search.searchHistoryList.isEmpty(), true);
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
        
        Id clvRecordTypeId = Schema.SObjectType.Debug_Log__c.getRecordTypeInfosByName().get('CLV').getRecordTypeId();
        
        for(Integer i=0; i<5; i++){
	        Debug_Log__c testDebugLog = new Debug_Log__c();
	        testDebugLog.Name = 'Test';
	        testDebugLog.Application__c = testApplication.Id;
	        testDebugLog.RecordTypeId = clvRecordTypeId;
	        testDebugLogList.add(testDebugLog);
	        
	    }

	    insert testDebugLogList;

        Test.StartTest();
        	ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_CLVSearchHistoryExt_INT search = new APP_CLVSearchHistoryExt_INT(standardCon);
            search.refresh();
        Test.StopTest();

        System.assertEquals(testApplication.Id, search.applicationId);
        System.assertEquals(!search.searchHistoryList.isEmpty(), true);
	}
}