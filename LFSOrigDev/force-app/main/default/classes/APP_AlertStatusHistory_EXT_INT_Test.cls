@isTest()

public class APP_AlertStatusHistory_EXT_INT_Test{

static testMethod void testAlert(){
       Application__c application = TestDataBuilder.createApplication();//create application
    application.Channel__c = 'Broker';
    application.Response_Code__c = 'PC';
    insert application;
    ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
    APP_AlertStatusHistory_EXT_INT ash = new APP_AlertStatusHistory_EXT_INT(standardController);
    ash.applicationHistoryList();

  
}
}