/**
 * @Description: Search and match test class
 * @Author: Adrian Recio
 * @Date Created: 1/12/2015
 * @History: 
 */
 @IsTest
public with sharing class APP_Wizard_SearchAndMatchTest {
	static testMethod void APP_Wizard_SearchAndMatchMainTest() {
        Applicant_Search__c asVar = TestDataBuilder.appSearch();
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        Applicant_Account__c aaVar = new Applicant_Account__c();
        insert aaVar;

        Applicant_Account_Involved_Party__c aaIP = TestDataBuilder.createApplicantAccountInvolvedParty(aaVar.Id);
        insert aaIP;

        List<String> appAccIdList = new List<String>();
        appAccIdList.add(aaVar.Id);

        test.startTest();
        	APP_Wizard_SearchAndMatch.topicNameAC = 'appCLVCreateTest';
        	APP_Wizard_SearchAndMatch.topicNameAA = 'appAccCreateTest';
            APP_Wizard_SearchAndMatch.addAccountTopic();
            APP_Wizard_SearchAndMatch.mockSearch(1,true, false,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(1,false, true,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(1,false, false,true, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(1,false, false,false, true,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(1,false, false,false, false,true, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            
            APP_Wizard_SearchAndMatch.mockSearch(2,true, false,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(2,false, true,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(2,false, false,true, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(2,false, false,false, true,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(2,false, false,false, false,true, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));

            APP_Wizard_SearchAndMatch.mockSearch(1,false, false,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            APP_Wizard_SearchAndMatch.mockSearch(2,false, false,false, false,false, string.valueOf(APP_Wizard_SearchAndMatch.appSearch1Id), string.valueOf(APP_Wizard_SearchAndMatch.appSearch2Id));
            
            Id appSearchId = APP_Wizard_SearchAndMatch.searchApp(asVar);
        	APP_Wizard_SearchAndMatch.fireSearch(appSearchId);

        	APP_Wizard_SearchAndMatch.queryFolder(appAccIdList);
        test.stopTest();
	}
}