@isTest
public class RUL_AdminRuleSetManagementExt_Test {
    static testMethod void Rule_Test() {
		Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
  		Id newProductOfferRecordTypeId = Schema.SObjectType.Offer__c.RecordTypeInfosByName.get('New Product Offer').RecordTypeId;

  		Offer__c testOffer = TestDataBuilder.createOffer(testProduct.Id, 'Unsecured Upsell', newProductOfferRecordTypeId);
  		insert testOffer;

  		Rule_Set__c testRuleSet = TestDataBuilder.createRuleSet(testProductVersion.Id);
  		insert testRuleSet;

  		Rule__c testRule = TestDataBuilder.createRule1(testOffer.Id, testRuleSet.Id);
  		insert testRule;

  		Condition__c testCondition = TestDataBuilder.createCondition1(testRule.Id);
  		insert testCondition;

		Test.StartTest();
			ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testRuleSet);
			RUL_AdminRuleSetManagementExt adminRuleSet = new RUL_AdminRuleSetManagementExt(standardCon);
			adminRuleSet.constructRuleSetCondition();
            adminRuleSet.test();
            adminRuleSet.selectedRule = testRule.Id;
            adminRuleSet.selectedCondition = testCondition.Id;
            adminRuleSet.deleteCondition();
            //adminRuleSet.addCondition();
		Test.StopTest();
        
        List<Condition__c> conditionList = [SELECT Id FROM Condition__c];
        System.assertEquals(true, conditionList.isEmpty());
	}
}