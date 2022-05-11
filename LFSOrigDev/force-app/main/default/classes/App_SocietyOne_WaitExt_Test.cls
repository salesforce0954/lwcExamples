/* @Description: Controller for Page APP_SocietyOne_Wait.page
    *  @Author     : Afreen
    *  @Date       : Jun-20-2016
    *  @History    :
    =========================================================================================================
        Jun-20-2016 : Created - Afreen Khan
    =========================================================================================================
    */

@isTest
public class App_SocietyOne_WaitExt_Test {
    private static final String EXTRENAL_APP_ID_VALID = 'XAppId';
    private static final String EXTRENAL_APP_ID_INVALID = 'XAppIdInvalid';
    private static final String EXTRENAL_SECURITY_TOKEN = 'stoken';
    
    public static testmethod void testPolling_Success (){
        X3rd_Party_Application_Status_Log__c statusLog  = new X3rd_Party_Application_Status_Log__c();
        statusLog.X3rd_Party_Application_Number__c      = EXTRENAL_APP_ID_VALID;
        statusLog.Status__c                             = 'Success';
        statusLog.Status_Message__c                     = 'Successfully submitted the app.';
        insert statusLog;
        
        Test.startTest();
        App_SocietyOne_WaitExt.startPolling(EXTRENAL_APP_ID_VALID); 
        App_SocietyOne_WaitExt.startPolling(EXTRENAL_APP_ID_INVALID); 
        Test.stopTest();
    }
    
    public static testmethod void testPolling_Error (){
        X3rd_Party_Application_Status_Log__c statusLog  = new X3rd_Party_Application_Status_Log__c();
        statusLog.X3rd_Party_Application_Number__c      = EXTRENAL_APP_ID_VALID;
        statusLog.Status__c                             = 'Error';
        statusLog.Status_Code__c                        = 'ERR_002';
        statusLog.Status_Message__c                     = 'Successfully submitted the app.';
        insert statusLog;
        
        Test.startTest();
        App_SocietyOne_WaitExt.startPolling(EXTRENAL_APP_ID_VALID); 
        Test.stopTest();
    }
    
    public static testmethod void testPostProcessing1(){
        List<Web_Service_Settings__c> wssList = new List<Web_Service_Settings__c>();
        
        Web_Service_Settings__c wss1                    = TestDataBuilder.createWebServiceSettings('SOLCode-AU-3rd Party Application', 'BC1');
        wssList.add(wss1);
        
        Web_Service_Settings__c wss2                    = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        wssList.add(wss2);
        
        insert wssList;
        
        Brand__c brand                              = TestDataBuilder.createBrand();
        brand.Site__c                               = GEN_OriginationsConstants.GEMONEY_AU_SITENAME;
        insert brand;
        
        GEProduct__c geProduct                      = TestDataBuilder.createGEProduct(brand.Id);
        insert geProduct;
        
        Product_Version__c prodVer                  = TestDataBuilder.createProductVersion(geProduct.Id);
        insert prodver;
        
        Application__c currentApp                   = TestDataBuilder.createApplication();
        currentApp.Loan_Term_Months__c              = 36;
        currentApp.Loan_Term__c                     = '3.5 years';
        currentApp.Payment_Frequency__c             = 'Monthly'; 
        currentApp.Total_Loan_Amount__c             = 12344;
        currentApp.Higher_Approval_Consent__c       = false;
        currentApp.X3rd_Party_Application_Number__c = EXTRENAL_APP_ID_VALID;
        currentApp.X3rd_Party_Security_Token__c     = EXTRENAL_SECURITY_TOKEN;
        currentApp.X3rd_Party_Application_Source__c = 'Society One';
        currentApp.Response_Code__c                 = 'New';
        insert currentApp;
        
        Applicant__c app1                       = TestDataBuilder.createApplicant(null, currentApp.Id);
        app1.Is_Primary_Applicant__c            = true;
        app1.First_Name__c                      = 'abcdkjkj';
        app1.Interested_in_other_services__c    = true ;        // Need to check with Weishen (on App Eligibitliy)
        app1.Meets_Eligibility_Criteria__c      = true;
        app1.Agrees_to_Fees__c                  = true;
        app1.Agrees_to_Privacy_Policy__c        = true;
        app1.KB_HL_or_Graduate__c               = false;
        app1.Accept_Terms_and_Conditions__c     = true;
        app1.EIDV__c                            = 'Yes';
        app1.Email_Address__c                   = 'testuniqueemail@gmail.com';
        insert app1;
        
        Loan_Purpose__c lp                      = TestDataBuilder.createLoanPurpose(currentApp.Id, null);
        insert lp;
        
        Income__c employmnet = TestDataBuilder.createIncome(app1.Id);
        insert employmnet;
        
        app1.Res_Status__c = 'Renting';
        update app1;
        
        Expense__c exp = TestDataBuilder.createExpense(app1.Id);
        insert exp;
        
        Asset__c asset = TestDataBuilder.createAsset(app1.Id);
        insert asset;
        
        Liability__c debt = TestDataBuilder.createOtherLiability(app1.Id); 
        insert debt;
        
        Id onrRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'ONR__c' AND DeveloperName = 'General' LIMIT 1].Id;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(currentApp.Id, onrRecordTypeId);
            testONR.geID__c = GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES;
        insert testONR;

        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        X3rd_Party_Application_Status_Log__c statusLog = new X3rd_Party_Application_Status_Log__c();
        statusLog.X3rd_Party_Application_Number__c          = EXTRENAL_APP_ID_VALID;
        statusLog.Status_Code__c                            = 'SUC_001';
        statusLog.Status__c                                 = 'Success';
        statusLog.Status_Message__c                         = 'Successfully submitted the application.';
        insert statusLog;
        
        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        
        PageReference pageRef = Page.App_SocietyOne_Wait;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ANo ', EXTRENAL_APP_ID_VALID);
        ApexPages.currentPage().getParameters().put('LoanAmount', EXTRENAL_SECURITY_TOKEN);
        
        User siteUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1];
        System.runAs(siteUser) {
            System.debug('!@#testSite: ' + site.getName());
            App_SocietyOne_WaitExt waitPageCtrl = new App_SocietyOne_WaitExt();
            List<X3rd_Party_Application_Status_Log__c> statusLogList = App_SocietyOne_WaitExt.startPolling(EXTRENAL_APP_ID_VALID);
            
            if(!statusLogList.isEmpty()){
                System.debug('!@#statusLogList: ' + statusLogList);
                PageReference returnReference = waitPageCtrl.afterPoll();
                System.assertEquals(null, returnReference);
                
                PageReference pgRef = Page.App_SocietyOne_SysError;
                pgRef.getParameters().put('err', 'ERR_003');
                pgRef.getParameters().put('externalappId', EXTRENAL_APP_ID_VALID);
                pgRef.setRedirect(true);
                waitPageCtrl.ex_application.X3rd_Party_Security_Token__c = null;
                System.assertEquals(pgRef.getUrl(), waitPageCtrl.retrieveRecords().getUrl());
            }

        }

        Test.stopTest();
    }
    
    public static testmethod void testPostProcessing2(){
        List<Web_Service_Settings__c> wssList = new List<Web_Service_Settings__c>();
        
        Web_Service_Settings__c wss1                    = TestDataBuilder.createWebServiceSettings('SOLCode-AU-3rd Party Application', 'BC1');
        wssList.add(wss1);
        
        Web_Service_Settings__c wss2                    = TestDataBuilder.createWebServiceSettings('Requested Name Sales', 'SalesUI');
        wssList.add(wss2);
        
        insert wssList;
        
        Brand__c brand                              = TestDataBuilder.createBrand();
        brand.Site__c                               = GEN_OriginationsConstants.GEMONEY_AU_SITENAME;
        insert brand;
        
        GEProduct__c geProduct                      = TestDataBuilder.createGEProduct(brand.Id);
        insert geProduct;
        
        Product_Version__c prodVer                  = TestDataBuilder.createProductVersion(geProduct.Id);
        insert prodver;
        
        Application__c currentApp                   = TestDataBuilder.createApplication();
        currentApp.Loan_Term_Months__c              = 36;
        currentApp.Loan_Term__c                     = '3.5 years';
        currentApp.Payment_Frequency__c             = 'Monthly'; 
        currentApp.Total_Loan_Amount__c             = 12344;
        currentApp.Higher_Approval_Consent__c       = false;
        currentApp.X3rd_Party_Application_Number__c = EXTRENAL_APP_ID_VALID;
        currentApp.X3rd_Party_Security_Token__c     = EXTRENAL_SECURITY_TOKEN;
        currentApp.X3rd_Party_Application_Source__c = 'Society One';
        currentApp.Response_Code__c                 = 'New';
        insert currentApp;
        
        Applicant__c app1                       = TestDataBuilder.createApplicant(null, currentApp.Id);
        insert app1;
        
        Loan_Purpose__c lp                      = TestDataBuilder.createLoanPurpose(currentApp.Id, null);
        insert lp;
        
        Income__c employmnet = TestDataBuilder.createIncome(app1.Id);
        insert employmnet;
        
        app1.Res_Status__c = 'Boarding with Parents';
        update app1;
        
        Expense__c exp = TestDataBuilder.createExpense(app1.Id);
        insert exp;
        
        Asset__c asset = TestDataBuilder.createAsset(app1.Id);
        insert asset;
        
        Liability__c debt = TestDataBuilder.createOtherLiability(app1.Id); 
        insert debt;
        
        Meta_ONR__c testMetaONR = TestDataBuilder.createMetaONR();
            testMetaONR.type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE;
        insert testMetaONR;
        
        X3rd_Party_Application_Status_Log__c statusLog = new X3rd_Party_Application_Status_Log__c();
        statusLog.X3rd_Party_Application_Number__c          = EXTRENAL_APP_ID_VALID;
        statusLog.Status_Code__c                            = 'SUC_001';
        statusLog.Status__c                                 = 'Success';
        statusLog.Status_Message__c                         = 'Successfully submitted the application.';
        insert statusLog;
        
        Test.startTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
        
        PageReference pageRef = Page.App_SocietyOne_Wait;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ANo ', EXTRENAL_APP_ID_VALID);
        ApexPages.currentPage().getParameters().put('LoanAmount', EXTRENAL_SECURITY_TOKEN);
        
        User siteUser = [SELECT Id FROM User WHERE Profile.Name = 'Latitude Profile' LIMIT 1];
        System.runAs(siteUser) {
            System.debug('!@#testSite: ' + site.getName());
            App_SocietyOne_WaitExt waitPageCtrl = new App_SocietyOne_WaitExt();
            List<X3rd_Party_Application_Status_Log__c> statusLogList = App_SocietyOne_WaitExt.startPolling(EXTRENAL_APP_ID_VALID);
            
            if(!statusLogList.isEmpty()){
                System.debug('!@#statusLogList: ' + statusLogList);
                PageReference returnReference = waitPageCtrl.afterPoll();
                System.assertEquals(null, returnReference);
                
                PageReference pgRef = Page.App_SocietyOne_SysError;
                pgRef.getParameters().put('err', 'ERR_003');
                pgRef.getParameters().put('externalappId', EXTRENAL_APP_ID_VALID);
                pgRef.setRedirect(true);
                waitPageCtrl.ex_application.X3rd_Party_Security_Token__c = null;
                System.assertEquals(pgRef.getUrl(), waitPageCtrl.retrieveRecords().getUrl());
            }
        }
        
        Test.stopTest();
    }
}