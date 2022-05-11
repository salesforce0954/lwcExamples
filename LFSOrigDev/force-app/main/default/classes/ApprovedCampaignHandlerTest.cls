/*------------------------------------------------------------
Author: Michael Lasala
Company: Cloud Sherpas
Description: ApprovedCampaignHandler test class
History
11/20/14        Michael Lasala      Created
------------------------------------------------------------*/
@isTest
public class ApprovedCampaignHandlerTest{

    static testMethod void createApplication_Test() {
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'Test';
        testOpportunity.StageName = 'New';
        testOpportunity.CloseDate = Date.today()+30;
        insert testOpportunity;

        Approved_Campaign_Classes__c testSetting = new Approved_Campaign_Classes__c();
        testSetting.Name = 'test';
        testSetting.Class_Name__c = 'ApprovedCampaignService';
        insert testSetting;

        Test.StartTest();
            String applicationId = ApprovedCampaignHandler.campaignProcess('test', testOpportunity.Id);
        Test.StopTest();
        
        Opportunity createdOpportunity = [SELECT Id FROM Opportunity WHERE Id =: testOpportunity.Id LIMIT 1];
        Approved_Campaign_Classes__c createdSetting = Approved_Campaign_Classes__c.getInstance(testSetting.Name);
        //Application__c createdApplication = [SELECT Id FROM Application__c WHERE Id =: applicationId LIMIT 1];
        //Applicant__c createdApplicant = [SELECT Application__c FROM Applicant__c WHERE Application__c =: applicationId LIMIT 1];

        System.assertEquals(testOpportunity.Id, createdOpportunity.Id);
        System.assertEquals(testSetting.Id, createdSetting.Id);
        //System.assertEquals(applicationId, createdApplication.Id);
        //System.assertEquals(applicationId, createdApplicant.Application__c);
    }
}