@isTest
public class GEN_PCAUtility_Test {
    
    static testMethod void Flush_Test() {
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA;
        testApplication.Out_Of_Sync__c = true;
        testApplication.PCA_Flush__c = false;
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        insert testDocument;
        
        Attachment testAttachment = TestDataBuilder.createAttachment(testDocument.Id);
        Attachment testAttachment2 = TestDataBuilder.createAttachment(testDocument.Id);

        List<Attachment> testAttachmentList = new List<Attachment>();
        testAttachmentList.add(testAttachment);
        testAttachmentList.add(testAttachment2);
        insert testAttachmentList;

        Compliance_Check__c testComplianceCheck = TestDataBuilder.createComplianceCheck(testApplication.Id);
        Compliance_Check__c testComplianceCheck2 = TestDataBuilder.createComplianceCheck(testApplication.Id);
        
        List<Compliance_Check__c> testComplianceCheckList = new List<Compliance_Check__c>();
        testComplianceCheckList.add(testComplianceCheck);
        testComplianceCheckList.add(testComplianceCheck2);
        insert testComplianceCheckList;

        Test.StartTest();
            testApplication.PCA_Flush__c = true;
            update testApplication;
        Test.StopTest();
        
        List<Attachment> deletedAttach = [SELECT Id FROM Attachment WHERE ParentId =: testDocument.Id];
        List<Compliance_Check__c> deletedCompliance = [SELECT Id FROM Compliance_Check__c WHERE Application__c =: testApplication.Id];
        //System.assertEquals(true, deletedAttach.isEmpty());
        //System.assertEquals(true, deletedCompliance.isEmpty());
    }

    static testMethod void Flush_Test2() {
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Acceptance_Channel__c = GEN_OriginationsConstants.OFFLINE_ACCEPTANCE;
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Related_Document__c testDocument = TestDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        insert testDocument;

        Test.StartTest();
            testApplication.Acceptance_Channel__c = GEN_OriginationsConstants.ONLINE_ACCEPTANCE;
            update testApplication;
        Test.StopTest();
        
        Application__c updatedApplication = [SELECT Is_Accepted_Primary__c, 
                                                    Is_Accepted_Secondary__c, 
                                                    Is_Insurance_Acknowledgement_Enabled__c, 
                                                    Is_Insurance_Acknowledgement_Enabled_2nd__c, 
                                                    Insurance_Acknowledgement__c, 
                                                    Insurance_Acknowledgement_Secondary__c
                                             FROM   Application__c 
                                             WHERE  Id =: testApplication.Id];

        List<Related_Document__c> deletedDocuments = [SELECT Id FROM Related_Document__c WHERE Application__c =: testApplication.Id];

        System.assertEquals(false, updatedApplication.Is_Accepted_Primary__c);
        System.assertEquals(false, updatedApplication.Is_Accepted_Secondary__c);
        System.assertEquals(false, updatedApplication.Is_Insurance_Acknowledgement_Enabled__c);
        System.assertEquals(false, updatedApplication.Is_Insurance_Acknowledgement_Enabled_2nd__c);
        System.assertEquals(false, updatedApplication.Insurance_Acknowledgement__c);
        System.assertEquals(false, updatedApplication.Insurance_Acknowledgement_Secondary__c);
        //System.assertEquals(true, deletedDocuments.isEmpty());
    }
}