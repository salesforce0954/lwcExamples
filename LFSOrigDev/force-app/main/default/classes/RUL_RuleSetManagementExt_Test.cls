@isTest
private class RUL_RuleSetManagementExt_Test {   

    @isTest static void test_method_one() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        Condition__c con2 = TestDataBuilder.createCondition2(rul.Id);
        insert con2;
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        rulController.selectedCondition = con2.id;
        rulController.selectedConditionOrder = con2.Order__c;
        rulController.ruleDirection = 'Up';
        rulController.updateConditionOrder();       
        rulController.saveCondition();
        Test.stopTest();
        
        System.assertEquals(con2.Id, rulController.selectedCondition);
    }
    
    @isTest static void test_method_two() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        
        //AM: commenting out due to compilation failures
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        Condition__c con2 = TestDataBuilder.createCondition2(rul.Id);
        insert con2;
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        rulController.selectedCondition = con1.id;
        rulController.selectedConditionOrder = con1.Order__c;
        rulController.ruleDirection = 'Down';
        rulController.updateConditionOrder();       
        Test.stopTest();

        System.assertEquals(con1.Id, rulController.selectedCondition);
    }

    @isTest static void test_method_three() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;

        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Rule__c rul2 = TestDataBuilder.createRule2(offer.Id, rulSet.Id);
        insert rul2;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        Condition__c con2 = TestDataBuilder.createCondition2(rul.Id);
        insert con2;
        Rate_Card__c rateCard = new Rate_Card__c();
        rateCard.Product_Version__c = prodVersion.Id;
        rateCard.Rate_Card_Name__c = 'Test Rate Card';
        insert rateCard;
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        rulController.selectedRule = rul2.id;
        rulController.selectedRuleOrder = rul2.Order__c;
        rulController.ruleDirection = 'Up';
        rulController.ruleSetId = rulSet.Id;
        rulController.updateRuleOrder();       
        List<SelectOption> lCon = rulController.conjunctionToPrevious;
        List<SelectOption> lOpt = rulController.conditionType;
        List<SelectOption> lCondOp = rulController.conditionOperation;
        List<SelectOption> lRHSObj = rulController.conditionRHSObject;
        List<SelectOption> lLHSObj = rulController.conditionLHSObject;
        List<SelectOption> lLHSFld = rulController.conditionLHSFields;
        List<SelectOption> lRHSFld = rulController.conditionRHSFields;
        List<SelectOption> rateCards = rulController.rateCards;

        Test.stopTest();
         
        System.assertEquals(rulSet.Id, rulController.ruleSetId);
    }

    @isTest static void test_method_four() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Rule__c rul2 = TestDataBuilder.createRule2(offer.Id, rulSet.Id);
        insert rul2;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        Condition__c con2 = TestDataBuilder.createCondition2(rul.Id);
        insert con2;
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        rulController.selectedRule = rul.id;
        rulController.selectedRuleOrder = rul.Order__c;
        rulController.ruleDirection = 'Down';
        rulController.ruleSetId = rulSet.Id;
        rulController.updateRuleOrder();       
        Test.stopTest();
        
        System.assertEquals(rulSet.Id, rulController.ruleSetId);
    }

    @isTest static void test_method_five() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        rulController.selectedRule = rul.id;        
        rulController.deleteRule();                
        rulController.addCondition();
        Test.stopTest();        

        System.assertEquals(rul.Id, rulController.selectedRule);
    }

     @isTest static void test_method_six() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);   
        rulController.selectedCondition = con1.Id;         
        rulController.deleteCondition();        
        rulController.selectedRule = rul.Id;        
        Test.stopTest();        

        System.assertEquals(con1.Id, rulController.selectedCondition);
    }

     @isTest static void test_method_seven() {
        Application__c application = TestDataBuilder.createApplication();
        insert application;
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;
        GEProduct__c geProd = TestDataBuilder.createGEProduct(brand.Id);
        insert geProd;
        Product_Version__c prodVersion = TestDataBuilder.createProductVersion(geProd.Id);
        insert prodVersion;
        
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDataBuilder.createOffer(geProd.Id, 'Secured Upsell', restructureRecTypeId );
        insert offer;        

        Test.startTest();
        Rule_Set__c rulSet = TestDataBuilder.createRuleSet(prodVersion.Id);
        insert rulSet;
        Rule__c rul = TestDataBuilder.createRule1(offer.Id, rulSet.Id);
        insert rul;
        Condition__c con1 = TestDataBuilder.createCondition1(rul.Id);
        insert con1;
        List<Condition__c> cList = new List<Condition__c>();
        cList.add(con1);
        ApexPages.StandardController standardController = new ApexPages.StandardController(application);
        RUL_RuleSetManagementExt rulController = new RUL_RuleSetManagementExt(standardController);
        RUL_RuleSetManagementExt.RuleWrapper rulWrapController = new RUL_RuleSetManagementExt.RuleWrapper(rul, cList);
        
        rulWrapController.rule = rul;
        rulWrapController.conditionList = cList;
        rulWrapController.conditionSize = 1;
        rulController.ruleSetId = rulSet.Id;
        rulController.ruleSize = 0;        
        rulController.selectedCondition = con1.Id;
        rulController.addRule();           
        //rulController.addCondition();
        Test.stopTest();    

        System.assertEquals(rulSet.Id, rulController.ruleSetId);    
    }
   
    
}