@isTest
public class APP_Disbursement_List_Test {

    static testMethod void methodOne(){

    Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true,'PC');
    insert responseCodeControl;
    system.assertEquals('PC',responseCodeControl.Name);//assert inserted Response_Code_Control__c    

    Application__c application = TestDataBuilder.createApplication();//create application
    application.Channel__c = 'Broker';
    application.Response_Code__c = 'PC';
    insert application;
    system.assertNotEquals(null,application.Id);//assert inserted Application__c

    Disbursement__c disbursement = TestDataBuilder.createDisbursement(application.Id);//create disbursement
    insert disbursement;
    system.assertEquals(disbursement.Application__c,application.Id);//assert inserted Disbursement__c

    PageReference pageRef = Page.APP_Disbursement_List;//ensure that APP_Disbursement_List page is being tested
    pageRef.getParameters().put('id',disbursement.Id);
    Test.setCurrentPageReference(pageRef);
    
    Test.StartTest();  
    ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(application);
    APP_Disbursement_List controller = new APP_Disbursement_List(standardController);
    Test.StopTest();
  }
}