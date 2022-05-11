/*
Author: August Del Rosario Cloud Sherpas
Created Date: January 21, 2014
Description: Test Coverage for AMLVerifiedTypeHandler
*/
@isTest
private class AMLVerifiedTypeHandlerTest {
    /*
    Author: August Del Rosario Cloud Sherpas
    Created Date: 12/05/2013
    Description: Test Method to test update Verified Type field of AML
    */
    static testMethod void testUpdateAMLPosVerifiedTypeB() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'B';

        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'B');
    }
    
    static testMethod void testUpdateAMLPosVerifiedTypecT() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'T';

        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'T');
        
    }
    static testMethod void testUpdateAMLPosVerifiedTypeA() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'A';
        
        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'A');
        
    }
    static testMethod void testUpdateAMLPosVerifiedTypeE() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'E';

        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'E');
        
    }
    static testMethod void testUpdateAMLPosVerifiedTypeX() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'X';

        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'X');
        
    }
    static testMethod void testUpdateAMLPosVerifiedTypeUnkownCode() {
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;
        
        AML__c testAML = TestDataBuilder.createAML(testApplicant.Id);
        testAML.AML_Pos_Verified_Type__c = 'Test';

        Test.startTest();
           insert testAML;
        Test.stopTest();

        AML__c amlRec = [Select Id,AML_Pos_Verified_Type__c FROM AML__c where Id =: testAML.Id];
        System.assertEquals(amlRec.AML_Pos_Verified_Type__c, 'Test');
        
    }
    
}