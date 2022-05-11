@isTest
private class APP_GSD_AML_Response_Ext_Test {

	private static testMethod void branchLocatorURL_Test() {
        List<Admin_Settings__c> adminSettings = TestDataBuilder.adminSet();
        insert adminSettings;
        
        String branchLocator;
        String brandLatitude;
        String brandGEM;
        String brandAussie;
        String brandKiwibank;

        Test.StartTest();
            APP_GSD_AML_Response_Ext amlResponseExt = new APP_GSD_AML_Response_Ext();
            brandLatitude = amlResponseExt.brandLatitude;
            brandGEM = amlResponseExt.brandGEM;
            brandAussie = amlResponseExt.brandAussie;
            brandKiwibank = amlResponseExt.brandKiwi;
        Test.StopTest();
        
        System.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY, brandLatitude);
        System.assertEquals(GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ, brandGEM);
        System.assertEquals(GEN_OriginationsConstants.BRAND_NAME_AUSSIE, brandAussie);
        System.assertEquals(GEN_OriginationsConstants.BRAND_NAME_KIWI, brandKiwibank);
	}

	private static testMethod void queryAMLFiles_Test() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

	    List<Document> testDocuments = new List<Document>();
	    
        Document testDocument1 = TestDataBuilder.createDocument(GEN_OriginationsConstants.GE_MONEY_IDV);
        Document testDocument2 = TestDataBuilder.createDocument(GEN_OriginationsConstants.KIWIBANK_IDV);
        Document testDocument3 = TestDataBuilder.createDocument(GEN_OriginationsConstants.AUSSIE_IDV);
        testDocuments.add(testDocument1);
        testDocuments.add(testDocument2);
        testDocuments.add(testDocument3);
        
        insert testDocuments;
        
        List<APP_GSD_AML_Response_Ext.AMLDocumentWrapper> amldDocs = new List<APP_GSD_AML_Response_Ext.AMLDocumentWrapper>();
        List<Brand_Content__c> brandContent = new List<Brand_Content__c>();
        Test.StartTest();
            amldDocs.addAll(APP_GSD_AML_Response_Ext.queryAMLFiles(GEN_OriginationsConstants.GEMONEY_AU_SITENAME));
            amldDocs.addAll(APP_GSD_AML_Response_Ext.queryAMLFiles(GEN_OriginationsConstants.GEMONEY_NZ_SITENAME));
            amldDocs.addAll(APP_GSD_AML_Response_Ext.queryAMLFiles(GEN_OriginationsConstants.AUSSIE_MONEY_SITENAME));
            amldDocs.addAll(APP_GSD_AML_Response_Ext.queryAMLFiles(GEN_OriginationsConstants.KIWI_BANK_SITENAME));
            brandContent = APP_GSD_AML_Response_Ext.queryAMLDocuments(testBrand.Id);
        Test.StopTest();
        
        System.assertEquals(4, amldDocs.size());
        System.assert(brandContent.isEmpty());
	}
}