@isTest
public class APP_PromoEligibility_Ext_Test{
    
    @testSetup static void staticRecords(){
        List<Meta_ONR__c> loanPurposeValues = TestDataBuilder.createMetaONRLoanPurpose();
        insert loanPurposeValues;
    }
    
    static testMethod void validateDuplicatePromoTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        Promo__c testDuplicatePromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testDuplicatePromo.Promo_ID__c = 'test';
        
        Test.StartTest();
        try{
            insert testDuplicatePromo;
        }catch(DmlException e){
            System.assert(e.getMessage().contains('Campaign has an existing promo'), e.getMessage());
        }
        Test.StopTest();
    }
    
    static testMethod void updatePromoTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        testPromo.Home_Owner__c = true;
        testPromo.Employment__c = true;
        testPromo.Minimum_Employment_Years__c = 1;
        testPromo.Minimum_Employment_Months__c = 1;
        testPromo.DM__c = true;
        
        Test.StartTest();
        update testPromo;
        Test.StopTest();
        
        for(Rule__c r: [SELECT  Order__c, 
                                IsActive__c
                        FROM    Rule__c 
                        WHERE   Rule_Set__r.Promo__c =: testPromo.Id]){
            
            if(r.Order__c == 4){
                System.assertEquals(testPromo.Employment__c, r.IsActive__c);
            } else if(r.Order__c == 5){
                System.assertEquals(testPromo.Employment__c, r.IsActive__c);
            } else {
                System.assertNotEquals(testPromo.DM__c, r.IsActive__c);
            }
        }
    }
    
    static testMethod void updatePromoTest2(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.Employment__c = true;
        testPromo.Minimum_Employment_Years__c = 1;
        testPromo.Minimum_Employment_Months__c = 1;
        testPromo.DM__c = true;
        insert testPromo;
        
        testPromo.Employment__c = false;
        testPromo.DM__c = false;
        
        Test.StartTest();
        update testPromo;
        Test.StopTest();
        
        for(Rule__c r: [SELECT  Order__c, 
                                IsActive__c
                        FROM    Rule__c 
                        WHERE   Rule_Set__r.Promo__c =: testPromo.Id]){
            
            if(r.Order__c == 4){
                System.assertEquals(testPromo.Employment__c, r.IsActive__c);
            } else if(r.Order__c == 5){
                System.assertEquals(testPromo.Employment__c, r.IsActive__c);
            } else {
                // System.assertNotEquals(testPromo.DM__c, r.IsActive__c);
            }
        }
    }
    
    static testMethod void deletePromoTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        Test.StartTest();
        delete testPromo;
        Test.StopTest();
        
        List<Rule__c> ruleList = [SELECT Id FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        System.assert(ruleList.isEmpty());
    }
    
    static testMethod void constructorTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.DM__c = true;
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                c.Free_Text__c = 'test';
                testConditions.add(c);
            }
        }
        
        update testConditions;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        Test.StopTest();
        
        System.assertEquals(testPromo.Id, promo.promo.Id);
        System.assertEquals(false, promo.ruleConditionMap.keySet().isEmpty());
        System.assertEquals(false, promo.ruleList.isEmpty());
        System.assertEquals(true, promo.displayEligibility);
        System.assertEquals(false, promo.loanValues.isEmpty());
        System.assertEquals(false, promo.riskGrades.isEmpty());
    }
    
    static testMethod void constructorErrorTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        List<Rule__c> ruleList = [SELECT Id FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        delete ruleList;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        Test.StopTest();
        
        List<Apexpages.Message> apexMessages = ApexPages.getMessages();
        boolean isError = false;
        for(Apexpages.Message m: apexMessages){
            if(m.getDetail().contains('No Eligiblity found')){
                isError = true;
            }
        }
        system.assert(isError);
        System.assertEquals(testPromo.Id, promo.promo.Id);
        System.assertEquals(true, promo.ruleConditionMap.keySet().isEmpty());
        System.assertEquals(true, promo.ruleList.isEmpty());
        System.assertEquals(true, promo.displayEligibility);
    }
    
    static testMethod void selectOptionsTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        System.assertEquals(false, promo.getEligibility1Options().isEmpty());
        System.assertEquals(false, promo.getConditionOperations().isEmpty());
        System.assertEquals(false, promo.getLoanPurposeValues().isEmpty());
        System.assertEquals(false, promo.getCreditScores().isEmpty());
        Test.StopTest();
    }
    
    static testMethod void toggleEligibilityTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        insert testPromo;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        promo.toggleEligibility();
        System.assertEquals(false, promo.displayEligibility);
        promo.toggleEligibility();
        System.assertEquals(true, promo.displayEligibility);
        Test.StopTest();
    }
    
    // static testMethod void negativeValidateEligibilityTest(){
    //     Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
    //     Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
    //     List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
    //     testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
    //     testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
    //     insert testCampaign;
        
    //     Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
    //     insert testPromo;
        
    //     Test.StartTest();
    //     ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
    //     APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
    //     System.assertEquals(false, promo.validateEligibility());
    //     Test.StopTest();
    // }
    
    static testMethod void positiveValidateEligibilityDMTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.DM__c = true;
        insert testPromo;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        System.assertEquals(true, promo.validateEligibility());
        Test.StopTest();
    }
    
    static testMethod void positiveValidateAndSaveEligibilityTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.DM__c = true;
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 1){
                    c.Free_Text__c = '3000';
                } else {
                    c.Free_Text__c = 'test';
                }
                testConditions.add(c);
            }
        }
        
        update testConditions;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        promo.saveEligiblity();
        Test.StopTest();
        
        for(Rule__c r: [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id]){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 1){
                    System.assertEquals('3000.00', c.Free_Text__c);
                } else {
                    System.assertEquals('test', c.Free_Text__c);
                }
            }
        }
    }
    
    static testMethod void clearValuesTest(){
        Schema.DescribeSObjectResult cfrSchemaAcc = Schema.SObjectType.Campaign;
        Map<String,Schema.RecordTypeInfo> campaignRecordTypeInfo = cfrSchemaAcc.getRecordTypeInfosByName();
        
        List<Campaign> testCampaign = TestDataBuilder.createCampaign(1);
        testCampaign.get(0).Promotional_Campaign__c = 'Special Promotion';
        testCampaign.get(0).RecordTypeId = campaignRecordTypeInfo.get('NZ Lead Process').getRecordTypeId();
        insert testCampaign;
        
        Promo__c testPromo = TestDataBuilder.createPromo(testCampaign.get(0).Id);
        testPromo.DM__c = true;
        insert testPromo;
        
        List<Condition__c> testConditions = new List<Condition__c>();
        List<Rule__c> ruleList = [SELECT Order__c, (SELECT Free_Text__c FROM Conditions__r) FROM Rule__c WHERE Rule_Set__r.Promo__c =: testPromo.Id];
        for(Rule__c r: ruleList){
            for(Condition__c c: r.Conditions__r){
                if(r.Order__c == 2){
                    c.Free_Text__c = 'test';
                }
                testConditions.add(c);
            }
        }
        
        update testConditions;
        
        Test.StartTest();
        ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testPromo);
        APP_PromoEligibility_Ext promo = new APP_PromoEligibility_Ext(standardCon);
        promo.clearloanValues();
        promo.clearRiskGrades();
        Test.StopTest();
        
        System.assertEquals(true, promo.loanValues.isEmpty());
        System.assertEquals(true, promo.riskGrades.isEmpty());
    }
}