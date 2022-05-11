@isTest
public class APP_CancelApplication_INTCC_Test {
    
    static testMethod void CancelApplication_Test() {
        //Catch constructor
        List<SelectOption> testOptions = new List<SelectOption>();

        ApexPages.currentPage().getParameters().put('Id', '');
        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            testOptions = cancel.cancelReason;
            cancel.cancel();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
        
        System.assert(isError);
        System.assertEquals(null, cancel.cancelReasonStr);
        System.assertEquals(null, cancel.comment);
        
    }

    static testMethod void CancelApplication_Test2() {
        //No application
        List<SelectOption> testOptions = new List<SelectOption>();

        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            ApexPages.currentPage().getParameters().put('Id', '');
            cancel.save();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();        
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('The application you are trying to cancel no longer exists')){
                isError = true;
            }
        }
        
        System.assert(isError);
        System.assertEquals(null, cancel.cancelReasonStr);
        System.assertEquals(null, cancel.comment);
    }

    static testMethod void CancelApplication_Test3() {
        //Application does not meet criteria
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            cancel.save();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('You can only cancel submitted applications.')){
                isError = true;
            }
        }
        
        System.assert(isError);
        System.assertEquals(null, cancel.cancelReasonStr);
        System.assertEquals(null, cancel.comment);
    }

    static testMethod void CancelApplication_Test4() {
        //Application meets criteria and empty Webservice_Decline_Reasons__c
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
        testApplication.Initial_Submit_Date__c = Date.today();
        insert testApplication;

        Web_Service_Settings__c testWSSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        insert testWSSettings;

        ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            cancel.cancelReasonStr = 'null';
            cancel.save();
            cancel.cancelReasonStr = 'test';
            cancel.comment = 'test';
            cancel.save();
        Test.StopTest();
        
        System.assertEquals('test', cancel.cancelReasonStr);
        System.assertEquals('test', cancel.comment);
        //System.assert(cancel.wf.Id != null);
    }

    static testMethod void CancelApplication_Test5() {
        //Application meets criteria and with Webservice_Decline_Reasons__c
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
        testApplication.Initial_Submit_Date__c = Date.today();
        insert testApplication;

        Web_Service_Settings__c testWSSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        insert testWSSettings;

        Webservice_Decline_Reasons__c testWSDeclineReasons = new Webservice_Decline_Reasons__c();
        testWSDeclineReasons.Name = 'test';
        testWSDeclineReasons.Reason_Name__c = 'test';
        insert testWSDeclineReasons;

        ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            cancel.cancelReasonStr = 'test';
            cancel.comment = 'test';
            cancel.save();
        Test.StopTest();
        
        System.assertEquals('test', cancel.cancelReasonStr);
        System.assertEquals('test', cancel.comment);
        //System.assert(cancel.wf.Id != null);
    }

    static testMethod void CancelApplication_Test6() {
        //No web service settings
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Submission_Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
        testApplication.Initial_Submit_Date__c = Date.today();
        insert testApplication;

        ApexPages.currentPage().getParameters().put('Id', testApplication.Id);
        Test.StartTest();
            APP_CancelApplication_INTCC cancel = new APP_CancelApplication_INTCC();
            cancel.cancelReasonStr = 'test';
            cancel.comment = 'test';
            cancel.save();
        Test.StopTest();
        
        Boolean isError;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            if(msg.getDetail().contains('There has been an error, please notify your administrator')){
                isError = true;
            }
        }
        
        System.assert(isError);
        System.assertEquals('test', cancel.cancelReasonStr);
        //System.assertEquals('test', cancel.comment);
    }
}