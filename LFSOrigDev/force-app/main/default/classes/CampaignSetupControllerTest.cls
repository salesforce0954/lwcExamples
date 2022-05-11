/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 Feb 2013 
* @description Test Class for CampaignSetupController Class
*/
@isTest
public with sharing class CampaignSetupControllerTest {
    static testMethod void case1(){
        //insert campaign
        Campaign c = new Campaign();
        c.Name = 'Test Campaign';
        c.Campaign_ID__c = 'TEST0001';
        c.StartDate = Date.today();
        c.EndDate = Date.today();
        c.Status = 'In Progress';
        c.IsActive = true;
        insert c;
        
        //insert Campaign Assignment
        Campaign_Assignment__c CaC = new Campaign_Assignment__c();
        CaC.User__c = Userinfo.getUserId();
        CaC.Campaign__c = c.Id;
        insert CaC;
        
        CampaignSetupController controller = new CampaignSetupController();
        
        //controller.setCampaignList();
        controller.saveCampaignAssignment();

        System.assertEquals(c.Id, controller.CampaignWrapperList.get(0).campaignVar.Id);
    }
}