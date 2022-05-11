@isTest
private class PR_RateCardExtTest {
	
	@isTest static void test_method_one() {
		Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        Rate_Card__c rCard = TestDataBuilder.createRateCard(prodVersion.Id);
        insert rCard;
        Rate__c rate = TestDataBuilder.createRate(rCard.Id);
        insert rate;
		ApexPages.StandardController standardController = new ApexPages.StandardController(rCard);
        PR_RateCardExt rcardExt = new PR_RateCardExt(standardController);
        PR_RateCardExt.RateBand rcardBand = new PR_RateCardExt.RateBand();
        Integer i = rcardExt.rowCounter;
        Integer i2 = rcardExt.getNextRowNum();
        List<String> slist = rcardExt.creditScores;
        rcardExt.selectedRateCard = rCard;
        rcardExt.saveAllRow();
        rcardExt.addNewRow();
        System.assertEquals(rCard.Id, rcardExt.selectedRateCard.Id);
	}

    @isTest static void test_method_two() {
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        Rate_Card__c rCard = TestDataBuilder.createRateCard(prodVersion.Id);
        insert rCard;
        Rate__c rate = TestDataBuilder.createRate(rCard.Id);
        insert rate;
        ApexPages.CurrentPage().getParameters().put('rowNum', '0');
        ApexPages.StandardController standardController = new ApexPages.StandardController(rCard);
        PR_RateCardExt rcardExt = new PR_RateCardExt(standardController);
        PR_RateCardExt.RateBand rcardBand = new PR_RateCardExt.RateBand();
        Integer i = rcardExt.rowCounter;
        Integer i2 = rcardExt.getNextRowNum();
        List<String> slist = rcardExt.creditScores;
        rcardExt.selectedRateCard = rCard;
        rcardExt.deleteRow();
        rCardExt.addNewRow();
        System.assertEquals(rCard.Id, rcardExt.selectedRateCard.Id);
    }
}