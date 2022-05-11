@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 02/22/13
Description: Test Coverage for PostcodeExclusionController
*/
private class PostcodeExclusionControllerTest{
    
    static testMethod void testPostcodeExclusionSave(){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
        List<Postcode_Exclusion__c> peVar = testDataBuilder.createPostcodes(1);
        insert peVar;
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar[0]);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        controller.postCodes = '1234';
        controller.saveRecords();
        Test.stopTest();
        List<Postcode_Exclusion__c> peList = [SELECT Id FROM Postcode_Exclusion__c WHERE Postcode__c = '1234'];
        PostCodeListInserted(peList[0].Id, 1);
    }
    
    static testMethod void testPostcodeExclusionSaveBulk(){
        Id userId =  UserInfo.getUserId();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
		Postcode_Exclusion__c peVar = new Postcode_Exclusion__c();
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        
        controller.postCodes = '123450, 123451, 123452, 123453, 123454, 123455, 123456, 123457, 123458, 123459';
        controller.saveRecords();
        Test.stopTest();
        List<Postcode_Exclusion__c> peList = [SELECT Id FROM Postcode_Exclusion__c WHERE OwnerId =: userId];
        PostCodeListInserted(peList, 10);
    }
    
    static testMethod void testPostcodeExclusionSaveError(){
        Id userId =  UserInfo.getUserId();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
		Postcode_Exclusion__c peVar = new Postcode_Exclusion__c();
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        
        controller.postCodes = '123450, 12345123451, 123451, 12345123452, 123452';
        controller.saveRecords();
        Test.stopTest();
        List<Postcode_Exclusion__c> peList = [SELECT Id FROM Postcode_Exclusion__c WHERE OwnerId =: userId];
        PostCodeListInserted(peList, 3);
    }
    
    static testMethod void testPostcodeExclusionError(){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
		List<Postcode_Exclusion__c> peVar = testDataBuilder.createPostcodes(1);
        insert peVar;
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar[0]);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        
        controller.postCodes = '12345678901, 09876543219';
        controller.saveRecords();
        Test.stopTest();

        Boolean isError;            
        List<Apexpages.Message> msgs = ApexPages.getMessages(); 
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('must be less than 10 characters')){
                isError = true;
            }
        }
        
        System.assert(isError);
    }
    
    static testMethod void testPostcodeExclusionCancel(){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
		List<Postcode_Exclusion__c> peVar = testDataBuilder.createPostcodes(1);
        insert peVar;
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar[0]);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        
        controller.Cancel();
        Test.stopTest();

        System.assertEquals('/home/home.jsp', controller.retURL);
    }
    
    static testMethod void testPostcodeExclusionNull(){
        Test.startTest();
        ApexPages.currentPage().getParameters().put('retURL', '/home/home.jsp');
        
		List<Postcode_Exclusion__c> peVar = testDataBuilder.createPostcodes(1);
        insert peVar;
        
        ApexPages.StandardController stc = new ApexPages.StandardController(peVar[0]);
        PostcodeExclusionController controller = new PostcodeExclusionController(stc);
        
        controller.postCodes = '';
        controller.saveRecords();
        Test.stopTest();

        System.assertEquals('/home/home.jsp', controller.retURL);
    }
    
    private static void PostCodeListInserted(Id pcId, Integer result){
        List<Postcode_Exclusion__c> pcList = [Select Postcode__c from Postcode_Exclusion__c where Id =: pcId];
        Integer i = 0;
        System.AssertEquals(result, pcList.size());
        System.AssertEquals('1234', pcList[0].Postcode__c);
    }
    
    private static void PostCodeListInserted(List<Postcode_Exclusion__c> pcList, Integer result){
        Set<Id> pcSet = new Set<Id>();
        Integer i = 0;
        for(Postcode_Exclusion__c pc: pcList){
            pcSet.add(pc.Id);
        }
        List<Postcode_Exclusion__c> pList = [Select Postcode__c from Postcode_Exclusion__c where Id in: pcSet];
        System.AssertEquals(result, pList.size());
    }
}