/*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 02/04/2014
    Description: Test Class for AppResponseTrigger
*/
@isTest()
public class AppResponseTrigger_test{
    
    //Author: Russell Cadapan Cloud Sherpas
    //Created Date: 02/04/2014
    //Description: Test Method to capture application fields related to application response
    
    static testMethod void populateResponseCodeTest(){

        Application__c application = TestDataBuilder.createApplication();
        insert application;
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        List<Application_Response__c> listApplicationResponseTest = new List<Application_Response__c>();

          for(Integer i = 0; i < 0; i++){
            listApplicationResponseTest.add(TestDataBuilder.createApplicationResponse(application.Id));
        }

        Test.StartTest();
            insert listApplicationResponseTest;
        Test.StopTest();

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControlPA();
        insert responseCodeControl;

        Application__c updatedApplication = [SELECT Id, Response_Code__c, Response_Description__c, Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Master_Offer_Flag__c, Max_Monthly_Capacity__c, Credit_Score__c FROM Application__c where ID =: application.Id];

        for(Integer i = 0; i < listApplicationResponseTest.size(); i ++){
            System.assertEquals(updatedApplication.Response_Code__c, listApplicationResponseTest[i].Response_Code__c);
            System.assertEquals(updatedApplication.Response_Description__c, listApplicationResponseTest[i].Response_Description__c);
            System.assertEquals(updatedApplication.Max_Capacity_Secured__c, listApplicationResponseTest[i].Max_Capacity_Secured__c);
            System.assertEquals(updatedApplication.Max_Capacity_Unsecured__c, listApplicationResponseTest[i].Max_Capacity_Unsecured__c);
            System.assertEquals(updatedApplication.Master_Offer_Flag__c, listApplicationResponseTest[i].Master_Offer_Flag__c);
            System.assertEquals(updatedApplication.Max_Monthly_Capacity__c, listApplicationResponseTest[i].Max_Monthly_Capacity__c);
            System.assertEquals(updatedApplication.Credit_Score__c, listApplicationResponseTest[i].Credit_Score__c);
        }
    }
    
    static testMethod void updateApplicationTest(){
    
    
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        Application__c application = TestDataBuilder.createApplication();
        application.Channel__c = 'Broker';
        //added by suneel
        //application.Promotional_Campaign__c='60 Day Certificate';
        application.X60DC_Max_Amount__c = 1000;
        application.Promo_Offer_Amount__c = 1000;
        application.Score_Eligible__c = 'N';
        application.Total_Net_Debt_Amount__c = 1000.00;
        application.Contract_Account_Number__c ='12345';
        application.Applicant_1_NFL__c = 'Yes';
        application.Applicant_2_NFL__c = 'Yes';
        application.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);     
        application.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9);
        application.Insurance_Error_Message__c = null;
        application.Total_Insurance_Premium__c = 1234;
        application.out_of_sync__c = true;
//Added by Arshad at 11:28 IST
        application.Max_Monthly_Capacity__c = null;
        application.Insurance_Eligibility_Flag_Applicant_1__c = null;
//End        
        //application.Brand_Lookup__r.Country__c= 'NZ';       
        application.Insurance_Eligibility_Flag_Applicant_2__c = 1;
        application.Total_Net_Debt_Amount__c = 500;
        insert application;
        
        system.assertEquals(application.Insurance_Eligibility_Flag_Applicant_2__c,1);
        
        //Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(application.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(application.Id, testONR.Id);
        insert testLoanPurpose;


        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        //end
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.prodItems = new List<Product_Item__c>();
            Boolean isLifeSingle = false;
            Boolean isDisabilitySingle = false;
            Boolean isIUISingle = false;
        if(offerCalculator.prodItems.size()>1){
        }

        Application_Response__c applicationResponse = TestDataBuilder.createApplicationResponse(application.Id);
        
        List<ExceptionLog__c> exLogs = new List<ExceptionLog__c>();
        ExceptionLog__c exceptionLogs = TestDataBuilder.createExceptionLog('XYZ', 'ABC', 'Exception', 'ExceptionVar', 'SUR', 'PCA', application.ID);
        exceptionLogs.Exception__c = 'Response Code: SUR';
        exceptionLogs.Origin__c = 'Class';
        exceptionLogs.Parameters__c = applicationResponse.Application__c;
        exceptionLogs.Retry_Attempts__c = 0;
        exceptionLogs.Retry_Status__c = 'FAILED';
        exceptionLogs.Application__c = applicationResponse.Application__c;
        insert exLogs;
        
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        applicationResponse.Application__c = application.Id;
        applicationResponse.Restart_Indicator__c = 1;
        //Added by Suneel
        applicationResponse.X60DC_Max_Amount__c = 1000;
        applicationResponse.Promo_Offer_Amount__c = 1000;
        applicationResponse.Score_Eligible__c = 'N';
        applicationResponse.Total_Net_Debt_Amount__c = 1000.00;
        applicationResponse.Contract_Account_Number__c ='12345';
        applicationResponse.Applicant_1_NFL__c = 'Yes';
        applicationResponse.Applicant_2_NFL__c = 'Yes';
        applicationResponse.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);
        applicationResponse.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9); 
        applicationResponse.Total_Net_Debt_Amount__c=500;
        
        insert applicationResponse;
        
        //Added by suneel  
        Application_Response__c applicationResponse1 = TestDataBuilder.createApplicationResponse(application.Id);
        applicationResponse1.Application__c = application.Id;
        applicationResponse1.Restart_Indicator__c = 5;        
        insert applicationResponse1;
        //End   
        applicationResponse.Response_Code__c = 'PA';

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControlPA();
        insert responseCodeControl;
        
        Test.StartTest();
        update applicationResponse;
        Test.StopTest();
        
        Application_Response__c insertedApplicationResponse = [SELECT Application__c FROM Application_Response__c where ID =: applicationResponse.Id ];
        Application__c updatedApplication = [SELECT Id, Response_Code__c, Promotional_Campaign__c, Offered_Interest_Rate__c, Adjusted_Interest_Rate_Locked__c, Response_Description__c, Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Master_Offer_Flag__c, Max_Monthly_Capacity__c, Credit_Score__c FROM Application__c where ID =: insertedApplicationResponse.Application__c];

        System.assertEquals(application.Id, applicationResponse.Application__c);
        System.assertEquals('PA', applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Code__c, applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Description__c, applicationResponse.Response_Description__c);
        System.assertEquals(updatedApplication.Max_Capacity_Secured__c, applicationResponse.Max_Capacity_Secured__c);
        System.assertEquals(updatedApplication.Max_Capacity_Unsecured__c, applicationResponse.Max_Capacity_Unsecured__c);
        System.assertEquals(updatedApplication.Master_Offer_Flag__c, applicationResponse.Master_Offer_Flag__c);
        System.assertEquals(updatedApplication.Max_Monthly_Capacity__c, applicationResponse.Max_Monthly_Capacity__c);
        System.assertEquals(updatedApplication.Credit_Score__c, applicationResponse.Credit_Score__c);
        
        //Added by suneel
        System.assertEquals(applicationResponse.Restart_Indicator__c,1);
        System.assertEquals(applicationResponse1.Restart_Indicator__c,5);
        //System.assertEquals(application.Promotional_Campaign__c,'60 Day Certificate');
        System.assertEquals(applicationResponse.X60DC_Max_Amount__c ,application.X60DC_Max_Amount__c);
        System.assertEquals(applicationResponse.Promo_Offer_Amount__c,application.Promo_Offer_Amount__c);
        System.assertEquals(applicationResponse.Score_Eligible__c,application.Score_Eligible__c);
        System.assertEquals(applicationResponse.Total_Net_Debt_Amount__c,application.Total_Net_Debt_Amount__c);
        System.assertEquals(applicationResponse.Contract_Account_Number__c,application.Contract_Account_Number__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL__c,application.Applicant_1_NFL__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL__c,application.Applicant_2_NFL__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL_Expiry_Date__c,application.Applicant_1_NFL_Expiry_Date__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL_Expiry_Date__c,application.Applicant_2_NFL_Expiry_Date__c);
        System.assertEquals(application.Insurance_Error_Message__c, null);
        System.assertEquals(application.Total_Net_Debt_Amount__c,applicationResponse.Total_Net_Debt_Amount__c);
        //System.assertEquals(application.Brand_Lookup__r.Country__c,'');
//        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        List<Application__c> applist = new List<Application__c>();
        List<Debug_Log__c> debuglist = new List<Debug_Log__c>();
        AppResponseTriggerHandler.flushInsuranceOffersOnNBSMFlagChange(application,applicationResponse,applist,debuglist);

        
    }
       static testMethod void updateApplicationTestTwo(){
      
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
       
       List<Application_Response__c> apresponse = new List<Application_Response__c>();
       insert apresponse;
       
       Application__c application = TestDataBuilder.createApplication();
//Added by Arshad at 11:43 IST
        application.Max_Monthly_Capacity__c = 1245;
        application.Insurance_Eligibility_Flag_Applicant_1__c = null;   
        insert application;

               
       /* Applicant__c app1 = TestDataBuilder.createApplicant(acc.Id, application.Id);
       insert app1;
       
       Income__c inc = TestDataBuilder.createIncome(app1.Id);
       insert inc; 
                
        Income_Capacity__c incomecap = new Income_Capacity__c();
        incomecap.Is_e_POI__c = True;
        incomecap.Income__c = inc.Id;
        insert incomecap;      

        System.assertEquals(applicationResponse3.EPOI_Completed_Flag__c ,incomecap.Is_e_POI__c);

           
         Application_Response__c applicationResponse3 = TestDataBuilder.createApplicationResponse(application.Id);
        applicationResponse3.Application__c = application.Id;
        applicationResponse3.EPOI_Completed_Flag__c = True;   
        applicationResponse3.Response_Description__c = 'Manual';        
     
        insert applicationResponse3;*/
        
       
        
        //Application_Response__c appResponse=TestDataBuilder.createApplicationResponse(application.Id);
        //insert appResponse;
        
        AppResponseTriggerHandler appresponsetrigger = new AppResponseTriggerHandler();
        appresponsetrigger.createDecision(apresponse);
//Added by Arshad at 11:11 IST 
    List<Decision__c> decisionList = new List<Decision__c>();
        Decision__c testDecision = new Decision__c();
        testDecision.Application__c = application.Id;
        decisionList.Add(testDecision);
        insert decisionList;
        
        Test.startTest();

            ApexPages.standardController standardCon = new ApexPages.standardController(application);
            APP_Decisioning_EXT_INT decisioningExInt = new APP_Decisioning_EXT_INT(standardCon);
            decisioningExInt.decList = decisionList;
            
        Test.stopTest();

        System.assert(!decisioningExInt.decList.isEmpty());
        System.assert(!decisioningExInt.manualAction); 

//End

        /*Decision__c decision = TestDataBuilder.createDecision(application.Id,true);
        decision.Response_Code__c = 'POC';
        decision.NBSM_Code__c = 'abc';
        decision.Response_Description__c = 'Manual';
        decision.Clearance__c = 'Manual';
        insert decision;
        List<Decision__c> decList = new List<Decision__c>();
        decList.add(decision);*/

        String s = 'R01VM|Referred - ID verification;C80AS|A1 Verify ID (AML);C91AS|Conditionally Approved Proof of Income A1;P01AS|Pending Customer Acceptance';
        String[] result = s.split('\\|');
        System.debug('Result'+result);
        System.debug('Result    :'+result[0]);
        String e = result[0].substring(result[0].length()-1,result[0].length());
        System.debug('E value    :  ' + e);
        
        Decision__c decision = new Decision__c();
        decision.Application__c = application.Id;
        decision.clearance__c = 'M';
        insert decision;

        List<Decision__c> decList = new List<Decision__c>();
        decList.add(decision);
        
        System.assertEquals(e ,decision.clearance__c);      
        System.assertEquals(decList.size() ,1);

        appresponsetrigger.flushDecisions(null);
        }

    static testMethod void auEPOIPermanent() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        System.assertEquals(testBrand.Id!=NULL ,true);
        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        insert testApplication;    
          
         System.assertEquals(testApplication.Id!=NULL ,true);  
          
          
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Insurance_Acknowledgement__c = true;
        testApplication2.Contract_Account_Number__c = '123123123123';
        testApplication2.Brand_Lookup__c = testBrand.id;
        insert testApplication2;        
        
         System.assertEquals(testApplication2.Id!=NULL ,true); 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
 
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
       
        System.assertEquals(testApplicant.Id!=NULL ,true); 
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        insert testApplicant2;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
       
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;
        try{
        insert appResponse;
        }catch(DMLException e){}

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);

            System.assertEquals(2,construct.applicantList.size());
            System.assertEquals(0,construct.applicant2.Time_at_previous_employer_years__c);
            System.assertEquals(1,construct.applicant.Time_at_previous_employer_years__c);
            System.assertEquals(false, construct.getTypeofProducts('testBrand').isEmpty()); 
            System.assertEquals(false, construct.isSystemReasonCode('testService')); 
            System.assertEquals(false, construct.serviceDeliveryTypes.isEmpty()); 
            System.assertEquals(true, APP_CommonExt.isPostcodeValid('0123')); 
            System.assertEquals(false, APP_CommonExt.isPostcodeValid('22222'));
            System.assertEquals(testONR.id, construct.parentONRId(testApplication.id)); 

        Test.StopTest();

    }
    static testMethod void auEPOIPartTime() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        System.assertEquals(testBrand.Id!=NULL ,true);
        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        insert testApplication;    
          
         System.assertEquals(testApplication.Id!=NULL ,true);  
          
          
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Insurance_Acknowledgement__c = true;
        testApplication2.Contract_Account_Number__c = '123123123123';
        testApplication2.Brand_Lookup__c = testBrand.id;
        insert testApplication2;        
        
         System.assertEquals(testApplication2.Id!=NULL ,true); 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
 
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        testApplicant.Primary_Employment_Status__c= 'Permanent Part Time (work over 20 hours per week)';
        
        insert testApplicant;
       
        System.assertEquals(testApplicant.Id!=NULL ,true); 
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        testApplicant2.Primary_Employment_Status__c= 'Permanent Part Time (work over 20 hours per week)';
        insert testApplicant2;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
       
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        inVar1.Income_Source__c ='Net Salary/Wages';
        insert inVar1;
        
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        insert inCap;
        
        Webservice_Message_Codes__c wemc = new Webservice_Message_Codes__c();
         wemc.name = 'asdfksdf';

        System.assertEquals(wemc.name.contains('asdfksdf'),true);

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;
        try{
        insert appResponse;
        }catch(DMLException e){}

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);

            System.assertEquals(2,construct.applicantList.size());
            System.assertEquals(0,construct.applicant2.Time_at_previous_employer_years__c);
            System.assertEquals(1,construct.applicant.Time_at_previous_employer_years__c);
            System.assertEquals(false, construct.getTypeofProducts('testBrand').isEmpty()); 
            System.assertEquals(false, construct.isSystemReasonCode('testService')); 
            System.assertEquals(false, construct.serviceDeliveryTypes.isEmpty()); 
            System.assertEquals(true, APP_CommonExt.isPostcodeValid('0123')); 
            System.assertEquals(false, APP_CommonExt.isPostcodeValid('22222'));
            System.assertEquals(testONR.id, construct.parentONRId(testApplication.id)); 

        Test.StopTest();

    }
//Added by Arshad
static testMethod void updateApplicationTestt(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c application = TestDataBuilder.createApplication();
        application.Channel__c = 'Broker';
        //added by suneel
        application.Promotional_Campaign__c='60 Day Certificate';
        application.X60DC_Max_Amount__c = 1000;
        application.Promo_Offer_Amount__c = 1000;
        application.Score_Eligible__c = 'N';
        application.Offered_Interest_Rate__c = null;
        application.Total_Net_Debt_Amount__c = 1000.00;
        application.Contract_Account_Number__c ='12345';
        application.Applicant_1_NFL__c = 'Yes';
        application.Applicant_2_NFL__c = 'Yes';
        application.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);     
        application.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9);
        application.Insurance_Error_Message__c = '';
        application.Total_Insurance_Premium__c = 1234;
        application.out_of_sync__c = true;
        application.Insurance_Eligibility_Flag_Applicant_1__c = 1;
        application.Insurance_Eligibility_Flag_Applicant_2__c = 5;
        application.Total_Net_Debt_Amount__c=500;
        application.Promo_Online_Message__c ='Test';
        application.Application_Type__c = 'Joint';
        application.Application_Restarted__c = true;
        application.Adjusted_Interest_Rate_Locked__c = false;
        application.EMI_with_Service_Fee__c = 15000;
        insert application;

//        Decimal oir = application.offered_Interest_Rate__c;
        
        System.assertEquals(application.Application_Restarted__c, true);
        System.assertEquals(application.Promotional_Campaign__c, '60 Day Certificate');
        System.assertEquals(application.Credit_Score__c, null);
        System.assertEquals(application.Adjusted_Interest_Fee_Locked__c, false);
                
        String rescode = 'PA';
        Application_Response__c applicationResponse = TestDataBuilder.createApplicationResponse(application.Id);       
        applicationResponse.Insurance_Eligibility_Flag_Applicant_1__c = 1;        

       List<ExceptionLog__c> exLogs = new List<ExceptionLog__c>();
        ExceptionLog__c exceptionLogs = TestDataBuilder.createExceptionLog('XYZ', 'ABC', 'Exception', 'ExceptionVar', 'SUR', 'PCA', application.ID);
        exceptionLogs.Exception__c = 'Response Code: SUR';
        exceptionLogs.Origin__c = 'Class';
        exceptionLogs.Parameters__c = applicationResponse.Application__c;
        exceptionLogs.Retry_Attempts__c = 0;
        exceptionLogs.Retry_Status__c = 'FAILED';
        exceptionLogs.Application__c = applicationResponse.Application__c;
        insert exLogs;

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        
        Applicant_Search__c appSearch = new Applicant_Search__c();
        insert appSearch;
        
        Applicant__c app1 = new Applicant__c();
        app1.Application__c = application.Id;
        insert app1;
        
        Applicant_CLV__c apCLV = new Applicant_CLV__c();
        apCLV.Applicant__c = app1.Id;
        insert apCLV;
        
        //Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(application.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(application.Id, testONR.Id);
        insert testLoanPurpose;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        testProductItem.Rate__c = 10.99;
        testProductItem.Fixed_Premium_Amount__c = 50;
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        //end
               
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.prodItems = new List<Product_Item__c>();
            Boolean isLifeSingle = false;
            Boolean isDisabilitySingle = false;
            Boolean isIUISingle = false;        
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
       
        applicationResponse.Application__c = application.Id;
        applicationResponse.Restart_Indicator__c = 1;
        //Added by Suneel
        applicationResponse.X60DC_Max_Amount__c = 1000;
        applicationResponse.Promo_Offer_Amount__c = 1000;
        applicationResponse.Credit_Score__c = 'A';
        applicationResponse.Score_Eligible__c = 'N';
        applicationResponse.Total_Net_Debt_Amount__c = 1000.00;
        applicationResponse.Contract_Account_Number__c ='12345';
        applicationResponse.Applicant_1_NFL__c = 'Yes';
        applicationResponse.Applicant_2_NFL__c = 'Yes';
        applicationResponse.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);
        applicationResponse.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9); 
        applicationResponse.Total_Net_Debt_Amount__c=500;
        //applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c = 2;
//Added by Arshad at 11:56
        //applicationResponse.Response_Code__c = 'PCA';
        applicationResponse.Response_Code__c = null;
//End        
        insert applicationResponse;
               
        //Added by suneel  
        Application_Response__c applicationResponse1 = TestDataBuilder.createApplicationResponse(application.Id);
        applicationResponse1.Application__c = application.Id;
        applicationResponse1.Restart_Indicator__c = 5;        
        insert applicationResponse1;
        //End   
//        applicationResponse.Response_Code__c = 'PA';

        Set<String> myString = new Set<String>{'PCO','PCA'};
        String resCode1 = 'PCO';
        String resCode2 = 'PCA';
        myString.add(resCode1);
        myString.add(resCode2);

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControlPA();
        insert responseCodeControl;
        
        Test.StartTest();
        update applicationResponse;
        Test.StopTest();
        
        Application_Response__c insertedApplicationResponse = [SELECT Application__c FROM Application_Response__c where ID =: applicationResponse.Id ];
        Application__c updatedApplication = [SELECT Id, Response_Code__c, Promotional_Campaign__c, Promo_Online_Message__c, Offered_Interest_Rate__c, Adjusted_Interest_Rate_Locked__c, Response_Description__c, Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Master_Offer_Flag__c, Max_Monthly_Capacity__c, Credit_Score__c FROM Application__c where ID =: insertedApplicationResponse.Application__c];

        System.assertEquals(true,myString.contains('PCA'));
       // System.assertNotEquals(application.Insurance_Eligibility_Flag_Applicant_2__c, applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c);
        System.assertEquals(application.Id, applicationResponse.Application__c);
        System.assertEquals(null, applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Code__c, applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Description__c, applicationResponse.Response_Description__c);
        System.assertEquals(updatedApplication.Max_Capacity_Secured__c, applicationResponse.Max_Capacity_Secured__c);
        System.assertEquals(updatedApplication.Max_Capacity_Unsecured__c, applicationResponse.Max_Capacity_Unsecured__c);
        System.assertEquals(updatedApplication.Master_Offer_Flag__c, applicationResponse.Master_Offer_Flag__c);
        System.assertEquals(updatedApplication.Max_Monthly_Capacity__c, applicationResponse.Max_Monthly_Capacity__c);
        System.assertEquals(updatedApplication.Credit_Score__c, applicationResponse.Credit_Score__c);
        System.assertEquals(updatedApplication.Offered_Interest_Rate__c,application.Offered_Interest_Rate__c);
        System.assertEquals(updatedApplication.Promo_Online_Message__c, application.Promo_Online_Message__c);
        
        System.assertEquals(application.Insurance_Eligibility_Flag_Applicant_1__c,applicationResponse.Insurance_Eligibility_Flag_Applicant_1__c);

        
        //Added by suneel
        System.assertEquals(applicationResponse.Restart_Indicator__c,1);
        System.assertEquals(applicationResponse1.Restart_Indicator__c,5);
        //System.assertEquals(application.Promotional_Campaign__c,'60 Day Certificate');
        System.assertEquals(applicationResponse.X60DC_Max_Amount__c ,application.X60DC_Max_Amount__c);
        System.assertEquals(applicationResponse.Promo_Offer_Amount__c,application.Promo_Offer_Amount__c);
        System.assertEquals(applicationResponse.Score_Eligible__c,application.Score_Eligible__c);
        System.assertEquals(applicationResponse.Total_Net_Debt_Amount__c,application.Total_Net_Debt_Amount__c);
        System.assertEquals(applicationResponse.Contract_Account_Number__c,application.Contract_Account_Number__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL__c,application.Applicant_1_NFL__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL__c,application.Applicant_2_NFL__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL_Expiry_Date__c,application.Applicant_1_NFL_Expiry_Date__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL_Expiry_Date__c,application.Applicant_2_NFL_Expiry_Date__c);
        System.assertEquals(application.Insurance_Error_Message__c, '');
        System.assertEquals(application.Total_Net_Debt_Amount__c,applicationResponse.Total_Net_Debt_Amount__c);
        System.assertEquals(application.Insurance_Eligibility_Flag_Applicant_2__c,5);
        System.assertEquals(applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c,3);
        
//        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        List<Application__c> applist = new List<Application__c>();
        List<Debug_Log__c> debuglist = new List<Debug_Log__c>();
        AppResponseTriggerHandler.flushInsuranceOffersOnNBSMFlagChange(application,applicationResponse,applist,debuglist);
        
    }

//End by Arshad    
     
    static testMethod void updateApplicationTestt_Check(){
     Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Name = 'Disability Insurance';
        insert testProduct;
        
           Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;
        
          
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Fees_Charges__c testFees = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        insert testFees;
        
        Webservice_Message_Codes__c testWMC = new Webservice_Message_Codes__c ();
        testWMC.Name = 'err';
        testWMC.Synchronous__c = false;
        testWMC.Error_Message__c = 'err';
        testWMC.Message_Description__c = 'test';
        testWMC.Retry__c = false;
        insert testWMC;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);

        applicationBuilder.application.Out_Of_Sync__c = true;
        applicationBuilder.application.Doc_Gen_Check__c = true;
        update applicationBuilder.application;

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applicationBuilder.application.Id);
        insert testAppResponse;

        Decision__c testDecision = TestDataBuilder.createDecision(applicationBuilder.application.Id, true);
        insert testDecision;
        
       
        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(applicationBuilder.application);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.updateApplication();
        Test.StopTest();
        
        System.assertEquals(testBrand.Id, testProduct.Brands__c);
        System.assertEquals(testProduct.Id, testProductVersion.GEProduct__c);
        System.assert(!adminSettingsList.isEmpty());
        System.assertEquals(testProductVersion.Id, testFees.Product_Version__c);
        System.assertEquals('Requested Name Sales', testWebServiceSettings.Name);
        System.assertEquals('SalesUI', testWebServiceSettings.Value__c);
        
    }
    static testMethod void updateApplicationTesting(){
        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
            testProduct.Name = 'Disability Insurance';
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Fees_Charges__c testFees = TestDataBuilder.createFeesAndcharges(testProductVersion.Id);
        insert testFees;
        
        Webservice_Message_Codes__c testWMC = new Webservice_Message_Codes__c ();
        testWMC.Name = 'err';
        testWMC.Synchronous__c = false;
        testWMC.Error_Message__c = 'err';
        testWMC.Message_Description__c = 'test';
        testWMC.Retry__c = true;
        insert testWMC;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;

        WS_TestApplicationBuilder applicationBuilder = new WS_TestApplicationBuilder(GEN_OriginationsConstants.APPLICATION_TYPE_JOINT, 
                                                                                     GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES,
                                                                                     GEN_OriginationsConstants.ONLINE_ACCEPTANCE);


        applicationBuilder.application.Out_Of_Sync__c = true;
        applicationBuilder.application.Doc_Gen_Check__c = true;
        update applicationBuilder.application;

        Application_Response__c testAppResponse = TestDataBuilder.createApplicationResponse(applicationBuilder.application.Id);
        insert testAppResponse;

        Decision__c testDecision = TestDataBuilder.createDecision(applicationBuilder.application.Id, true);
        insert testDecision;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(applicationBuilder.application);
            APP_ApplicationMain_INTCC AppMain = new APP_ApplicationMain_INTCC(standardCon);
            AppMain.updateApplication();
        Test.StopTest();
        
        System.assertEquals(testBrand.Id, testProduct.Brands__c);
        System.assertEquals(testProduct.Id, testProductVersion.GEProduct__c);
        System.assert(!adminSettingsList.isEmpty());
        System.assertEquals(testProductVersion.Id, testFees.Product_Version__c);
        System.assertEquals('Requested Name Sales', testWebServiceSettings.Name);
        System.assertEquals('SalesUI', testWebServiceSettings.Value__c);
    }
     static testMethod void updateApplicationWs(){
       Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        Application__c application = TestDataBuilder.createApplication();
        application.Channel__c = 'Broker';
        //added by suneel
        application.Promotional_Campaign__c='60 Day Certificate';
        application.X60DC_Max_Amount__c = 1000;
        application.Promo_Offer_Amount__c = 1000;
        application.Score_Eligible__c = 'N';
        application.Offered_Interest_Rate__c = 15.99;
        application.Total_Net_Debt_Amount__c = 1000.00;
        application.Contract_Account_Number__c ='12345';
        application.Applicant_1_NFL__c = 'Yes';
        application.Applicant_2_NFL__c = 'Yes';
        application.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);     
        application.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9);
        application.Insurance_Error_Message__c = '';
        application.Total_Insurance_Premium__c = 1234;
        application.out_of_sync__c = true;
        application.Insurance_Eligibility_Flag_Applicant_1__c = 1;
        application.Insurance_Eligibility_Flag_Applicant_2__c = 3;
        application.Total_Net_Debt_Amount__c=500;
        application.Promo_Online_Message__c ='Test';
        application.Application_Type__c = 'Joint';
        application.Application_Restarted__c = true;
        application.Adjusted_Interest_Rate_Locked__c = false;
        application.Response_Code__c = 'PAO';
        insert application;

//        Decimal oir = application.offered_Interest_Rate__c;
        
        System.assertEquals(application.Application_Restarted__c, true);
        System.assertEquals(application.Promotional_Campaign__c, '60 Day Certificate');
        System.assertEquals(application.Credit_Score__c, null);
        System.assertEquals(application.Adjusted_Interest_Fee_Locked__c, false);
                
        String rescode = 'PA';
        Application_Response__c applicationResponse = TestDataBuilder.createApplicationResponse(application.Id);       
        applicationResponse.Insurance_Eligibility_Flag_Applicant_1__c = 1;        

       List<ExceptionLog__c> exLogs = new List<ExceptionLog__c>();
        ExceptionLog__c exceptionLogs = TestDataBuilder.createExceptionLog('XYZ', 'ABC', 'Exception', 'ExceptionVar', 'SUR', 'PCA', application.ID);
        exceptionLogs.Exception__c = 'Response Code: SUR';
        exceptionLogs.Origin__c = 'Class';
        exceptionLogs.Parameters__c = applicationResponse.Application__c;
        exceptionLogs.Retry_Attempts__c = 0;
        exceptionLogs.Retry_Status__c = 'FAILED';
        exceptionLogs.Application__c = applicationResponse.Application__c;
        insert exLogs;

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;
        
        Applicant_Search__c appSearch = new Applicant_Search__c();
        insert appSearch;
        
        Applicant__c app1 = new Applicant__c();
        app1.Application__c = application.Id;
        insert app1;
        
        Applicant_CLV__c apCLV = new Applicant_CLV__c();
        apCLV.Applicant__c = app1.Id;
        insert apCLV;
        
        //Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(application.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(application.Id, testONR.Id);
        insert testLoanPurpose;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(application.Id, testProductVersion.Id);
        testProductItem.Rate__c = 10.99;
        testProductItem.Fixed_Premium_Amount__c = 50;
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        //end
               
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.prodItems = new List<Product_Item__c>();
            Boolean isLifeSingle = false;
            Boolean isDisabilitySingle = false;
            Boolean isIUISingle = false;        
        
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Webservice_Message_Codes__c testWMC = new Webservice_Message_Codes__c ();
        testWMC.Name = 'PCA';
        testWMC.Synchronous__c = false;
        testWMC.Error_Message__c = 'err';
        testWMC.Message_Description__c = 'test';
        testWMC.Retry__c = true;
        insert testWMC;
        
        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        insert testWebServiceSettings;
        
        Web_Service_Log__c  wslog = TestDataBuilder.createWebServiceLog(application.Id);
        insert wslog;
        
        applicationResponse.Application__c = application.Id;
        applicationResponse.Restart_Indicator__c = 1;
        //Added by Suneel
        applicationResponse.X60DC_Max_Amount__c = 1000;
        applicationResponse.Promo_Offer_Amount__c = 1000;
        applicationResponse.Credit_Score__c = 'A';
        applicationResponse.Score_Eligible__c = 'N';
        applicationResponse.Total_Net_Debt_Amount__c = 1000.00;
        applicationResponse.Contract_Account_Number__c ='12345';
        applicationResponse.Applicant_1_NFL__c = 'Yes';
        applicationResponse.Applicant_2_NFL__c = 'Yes';
        applicationResponse.Applicant_1_NFL_Expiry_Date__c =Date.newInstance(2022, 12, 9);
        applicationResponse.Applicant_2_NFL_Expiry_Date__c=  Date.newInstance(2022, 12, 9); 
        applicationResponse.Total_Net_Debt_Amount__c=500;
        applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c = 2;
//Added by Arshad at 11:56
        //applicationResponse.Response_Code__c = 'PCA';
        applicationResponse.Response_Code__c = 'PCA';
//End        
        insert applicationResponse;
               
        //Added by suneel  
        Application_Response__c applicationResponse1 = TestDataBuilder.createApplicationResponse(application.Id);
        applicationResponse1.Application__c = application.Id;
        applicationResponse1.Restart_Indicator__c = 5;        
        insert applicationResponse1;
        //End   
//        applicationResponse.Response_Code__c = 'PA';

        Set<String> myString = new Set<String>{'PCO','PCA'};
        String resCode1 = 'PCO';
        String resCode2 = 'PCA';
        myString.add(resCode1);
        myString.add(resCode2);

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControlPA();
        insert responseCodeControl;
        
        Test.StartTest();
        update applicationResponse;
        Test.StopTest();
        
        Application_Response__c insertedApplicationResponse = [SELECT Application__c FROM Application_Response__c where ID =: applicationResponse.Id ];
        Application__c updatedApplication = [SELECT Id, Response_Code__c, Promotional_Campaign__c, Promo_Online_Message__c, Offered_Interest_Rate__c, Adjusted_Interest_Rate_Locked__c, Response_Description__c, Max_Capacity_Secured__c, Max_Capacity_Unsecured__c, Master_Offer_Flag__c, Max_Monthly_Capacity__c, Credit_Score__c FROM Application__c where ID =: insertedApplicationResponse.Application__c];

        System.assertEquals(true,myString.contains('PCA'));
        System.assertNotEquals(application.Insurance_Eligibility_Flag_Applicant_2__c, applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c);
        System.assertEquals(application.Id, applicationResponse.Application__c);
        System.assertEquals('PCA', applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Code__c, applicationResponse.Response_Code__c);
        System.assertEquals(updatedApplication.Response_Description__c, applicationResponse.Response_Description__c);
        System.assertEquals(updatedApplication.Max_Capacity_Secured__c, applicationResponse.Max_Capacity_Secured__c);
        System.assertEquals(updatedApplication.Max_Capacity_Unsecured__c, applicationResponse.Max_Capacity_Unsecured__c);
        System.assertEquals(updatedApplication.Master_Offer_Flag__c, applicationResponse.Master_Offer_Flag__c);
        System.assertEquals(updatedApplication.Max_Monthly_Capacity__c, applicationResponse.Max_Monthly_Capacity__c);
        System.assertEquals(updatedApplication.Credit_Score__c, applicationResponse.Credit_Score__c);
        System.assertEquals(updatedApplication.Offered_Interest_Rate__c,application.Offered_Interest_Rate__c);
        System.assertEquals(updatedApplication.Promo_Online_Message__c, application.Promo_Online_Message__c);
        
        System.assertEquals(application.Insurance_Eligibility_Flag_Applicant_1__c,applicationResponse.Insurance_Eligibility_Flag_Applicant_1__c);

        
        //Added by suneel
        System.assertEquals(applicationResponse.Restart_Indicator__c,1);
        System.assertEquals(applicationResponse1.Restart_Indicator__c,5);
        //System.assertEquals(application.Promotional_Campaign__c,'60 Day Certificate');
        System.assertEquals(applicationResponse.X60DC_Max_Amount__c ,application.X60DC_Max_Amount__c);
        System.assertEquals(applicationResponse.Promo_Offer_Amount__c,application.Promo_Offer_Amount__c);
        System.assertEquals(applicationResponse.Score_Eligible__c,application.Score_Eligible__c);
        System.assertEquals(applicationResponse.Total_Net_Debt_Amount__c,application.Total_Net_Debt_Amount__c);
        System.assertEquals(applicationResponse.Contract_Account_Number__c,application.Contract_Account_Number__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL__c,application.Applicant_1_NFL__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL__c,application.Applicant_2_NFL__c);
        System.assertEquals(applicationResponse.Applicant_1_NFL_Expiry_Date__c,application.Applicant_1_NFL_Expiry_Date__c);
        System.assertEquals(applicationResponse.Applicant_2_NFL_Expiry_Date__c,application.Applicant_2_NFL_Expiry_Date__c);
        System.assertEquals(application.Insurance_Error_Message__c, '');
        System.assertEquals(application.Total_Net_Debt_Amount__c,applicationResponse.Total_Net_Debt_Amount__c);
        System.assertEquals(application.Insurance_Eligibility_Flag_Applicant_2__c,3);
        System.assertEquals(applicationResponse.Insurance_Eligibility_Flag_Applicant_2__c,2);
        
//        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        List<Application__c> applist = new List<Application__c>();
        List<Debug_Log__c> debuglist = new List<Debug_Log__c>();
        AppResponseTriggerHandler.flushInsuranceOffersOnNBSMFlagChange(application,applicationResponse,applist,debuglist);
        
    }
    static testMethod void RateReduction_Test6() {
        //With application response
        //With adjusted interest rate == offered interest rate
        //With adjusted interest rate > newOfferedRate
        //With adjusted interest rate reason (set 1)
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'Test';
        testApplication.Adjusted_Interest_Rate__c = 5;
        testApplication.Offered_Interest_Rate__c = null;
        testApplication.Offered_Interest_Rate_Orig__c = 5;
        testApplication.Adjusted_Interest_Rate_Reason__c = 'VIP';
        testApplication.Channel__c = 'Broker';
        testApplication.Promo_Online_Message__c = null;
        insert testApplication;

        // Jerome
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Brand__c testBrand = TestDataBuilder.createBrand();
        insert testBrand;

        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Product_Item__c testProductItem = TestDatabuilder.createProductItem(testApplication.Id, testProductVersion.Id);
        insert testProductItem;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
        // end

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        try{
        insert appResponse;
        }catch(DMLException e){}

        IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
        applicationDTO.app = testApplication;

        RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();

        Test.StartTest();
            rateReduction.rateReductionWithAppResponse(applicationDTO);
        Test.StopTest();

        //System.assertEquals(rateReduction.rateReductionWithAppResponse(applicationDTO), testApplication.Adjusted_Interest_Rate__c);
        System.assertEquals(5, testApplication.Adjusted_Interest_Rate__c);
    }
    
    static testMethod void testPOICode(){
    
    Application__c application = TestDataBuilder.createApplication();
    application.Insurance_Error_Message__c = '';
    application.Total_Insurance_Premium__c = 15000;
    application.Out_Of_Sync__c = true;
    application.Risk_Grade__c = 'B';
    application.Promo_Online_Message__c = 'xyz';
    application.Last_Webservice_Operation_Status__c = 'Failed';
    application.Credit_Score__c ='A';
    try{
        insert application;
        }catch(DMLException e ){}
        
       // application.Response_Code__c = 'ADO';
        application.Promo_Online_Message__c = null;
        try{
          update application;
        }catch(DMLException e){}
        
        Brand__c testBrand = TestDataBuilder.createBrandNZ();
        insert testBrand;
        
        Application__c applicationNZ = TestDataBuilder.createApplicationNZ(testBrand);
        applicationNZ.Adjusted_Interest_Rate_Locked__c = false;
        applicationNZ.Promotional_Campaign__c = '60 Day Certificate';
        insert applicationNZ;
        
        Applicant__c appId = TestDataBuilder.createApplicant(null, application.Id);
       insert appId;
        
        Web_Service_log__c wsl = new Web_Service_Log__c();
        wsl.application__c = application.id;
        wsl.Channel__c = 'SalesUI';
        wsl.Service_Called__c = 'Submit Application';
        insert wsl;
        System.assertEquals(wsl.Channel__c,'SalesUI');
        
        Application_Response__c appResponse = new Application_Response__c();
        //appResponse.Response_Code__c = 'FIA';
       // appResponse.Contract_Account_Number__c = '123123123123';
       // appResponse.EPOI_Completed_Flag__c= True;
       // appResponse.Verified_Income__c =8000.00;
      //  insert appResponse;
        
        appResponse.Application__c = application.id;
        appResponse.Response_Code__c = 'PCO';
        appResponse.Response_Description__c = 'Partially Approved';
        appResponse.Insurance_Eligibility_Flag_Applicant_1__c = 3;
        appResponse.Insurance_Eligibility_Flag_Applicant_2__c = 3;
        appResponse.Max_Capacity_Secured__c = 15000; 
        appResponse.Max_Capacity_Unsecured__c = 15000;
        appResponse.Max_Monthly_Capacity__c = null;
        appResponse.Credit_Score__c = 'A';
        appResponse.UID__c='Test Id';
        appResponse.Case_Manager_ID__c='Test Id';
        appResponse.Min_Collateral_Amount__c = 10;
        appResponse.Risk_Grade__c = 'B';
        appResponse.EVerifier_Income_Applicant_1__c = 10000.00;
        appResponse.EVerifier_Alert_Applicant_1__c = null;
        appResponse.EVerifier_Request_Date_Applicant_1__c = Date.newInstance(2016, 12, 9);
        appResponse.Restart_Indicator__c = 3;
        try{
        insert appResponse;
        }catch(DMLException e){}
        
        System.assertEquals(appResponse.EVerifier_Alert_Applicant_1__c,null);
        System.assertEquals(appResponse.EVerifier_Income_Applicant_1__c,10000.00);
        
        List<Income__c> incList = new List<Income__c>();
        
        Income__c income = new Income__c();
        income.Applicant__c = appId.id;
        income.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income.Occupation__c = 'Developer';
        income.Emp_Bus_Name__c = 'GlobalOnea';
        income.Emp_Bus_Contact_No__c = '0434567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        
        incList.add(income);
        
        insert incList;
        
        if(!incList.isEmpty() && incList.size() > 0 && incList.size() < 2){
        update incList;
        }
        
        System.assertEquals(incList.size(),1);        
        
        Income__c income1 = new Income__c();
        income1.Applicant__c = appId.id;
        income1.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME;
        income1.Occupation__c = 'Developer';
        income1.Emp_Bus_Name__c = 'GlobalOnea';
        income1.Emp_Bus_Contact_No__c = '0434567890';
        income1.Years_With_Employer__c = 5;
        income1.Months_With_Employer__c = 6;
        income1.Income_Amount__c = 1234567;
        income1.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income1.Total_Income__c = 1234567;
        income1.POI_Amount_Verified__c = 10000.00;
        insert income1;
    
    Income__c income2 = new Income__c();
        income2.Applicant__c = appId.id;
        income2.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_PARTTIME;
        income2.Occupation__c = 'Developer';
        income2.Emp_Bus_Name__c = 'GlobalOneb';
        income2.Emp_Bus_Contact_No__c = '0434567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;
        
        
        
        Income__c income3 = new Income__c();
        income3.Applicant__c = appId.id;
        income3.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_CONTRACT;
        income3.Occupation__c = 'Developer';
        income3.Emp_Bus_Name__c = 'GlobalOnec';
        income3.Emp_Bus_Contact_No__c = '0434567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;
        
        Income__c income4 = new Income__c();
        income4.Applicant__c = appId.id;
        income4.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_TEMPORARY;
        income4.Occupation__c = 'Developer';
        income4.Emp_Bus_Name__c = 'GlobalOned';
        income4.Emp_Bus_Contact_No__c = '0434567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;
        
        Income__c income5 = new Income__c();
        income5.Applicant__c = appId.id;
        income5.Income_Source__c  = GEN_OriginationsConstants.INCOME_SOURCE_SELF_EMPLOYED;
        income5.Occupation__c = 'Developer';
        income5.Emp_Bus_Name__c = 'GlobalOnee';
        income5.Emp_Bus_Contact_No__c = '0434567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;
        
        List<Income_Capacity__c> incapList = new List<Income_Capacity__c>();
        Income_Capacity__c incCap = new Income_Capacity__c();
        incCap.Income__c = income1.id;
        incCap.Income_Detail__c = 'My permanent - full time job';
        incCap.Income_1__c = appResponse.EVerifier_Income_Applicant_1__c ;
        incCap.Employment_Type__c = 'Permanent Full Time';
        incCap.Frequency_of_Payment__c ='Monthly';
        incCap.Method_of_Calculation__c ='Net Income';
        incCap.Method_of_Verification__c ='Verifier';
        incCap.Income_1_DD__c = appResponse.EVerifier_Request_Date_Applicant_1__c ;
        incCap.Minimum_Income_Used__c = 10000.00;
        incCap.Annualised_Net_Income__c = 100000.00;
        incCap.Annualised_Net_Income_per_Month__c = 10000;
        incCap.Overtime_Shift_Allowance__c = 'No';
        insert incCap;     
        
           System.assertEquals(incCap.Income_Detail__c,'My permanent - full time job');
           System.assertEquals(income1.Emp_Bus_Name__c,'GlobalOnea');
           System.assertEquals(incCap.Income_Detail__c + ' ' + income1.Emp_Bus_Name__c ,'My permanent - full time job GlobalOnea');
           System.assertEquals(incCap.Employment_Type__c ,'Permanent Full Time');
           System.assertEquals(incCap.Method_of_Verification__c,'Verifier');
           System.assertEquals(incCap.Frequency_of_Payment__c,'Monthly');
           System.assertEquals(incCap.Method_of_Calculation__c ,'Net Income');
           System.assertEquals(incCap.Minimum_Income_Used__c ,10000.00);
           System.assertEquals(incCap.Annualised_Net_Income__c ,100000.00);
           System.assertEquals(incCap.Annualised_Net_Income_per_Month__c ,10000.00);
           System.assertEquals(incCap.Overtime_Shift_Allowance__c ,'No');
            
                    
   
        
        Income_Capacity__c incCap1 = new Income_Capacity__c();
        incCap1.Income__c = income2.id;
        incCap1.Income_Detail__c = 'My permanent - part time job' + ' ' + income2.Emp_Bus_Name__c;
        incCap1.Income_1__c = appResponse.EVerifier_Income_Applicant_1__c ;
        incCap1.Employment_Type__c = 'Permanent Part Time';
        incCap1.Frequency_of_Payment__c ='Monthly';
        incCap1.Method_of_Calculation__c ='Net Income';
        incCap1.Method_of_Verification__c ='Verifier';
        incCap1.Income_1_DD__c = appResponse.EVerifier_Request_Date_Applicant_1__c ;
        incCap1.Minimum_Income_Used__c = 10000.00;
        incCap1.Annualised_Net_Income__c = 100000.00;
        incCap1.Annualised_Net_Income_per_Month__c = 10000;
        incCap1.Overtime_Shift_Allowance__c = 'No';
     //   insert incCap1;
        
        Income_Capacity__c incCap2 = new Income_Capacity__c();
        incCap2.Income__c = income3.id;
        incCap2.Income_Detail__c = 'My contracting job' + ' ' + income3.Emp_Bus_Name__c;
        incCap2.Employment_Type__c = 'Fixed Term Contract';
        incCap2.Frequency_of_Payment__c ='Monthly';
        incCap2.Method_of_Calculation__c ='Net Income';
        incCap2.Method_of_Verification__c ='Verifier';
        incCap2.Income_1_DD__c = appResponse.EVerifier_Request_Date_Applicant_1__c ;
        incCap2.Minimum_Income_Used__c = 10000.00;
        incCap2.Annualised_Net_Income__c = 100000.00;
        incCap2.Annualised_Net_Income_per_Month__c = 10000;
        incCap2.Overtime_Shift_Allowance__c = 'No';
      //  insert incCap2;
        
        Income_Capacity__c incCap3 = new Income_Capacity__c();
        incCap3.Income__c = income4.id;
        incCap3.Income_Detail__c = 'My casual/temporary job' + ' ' + income4.Emp_Bus_Name__c;
        incCap3.Employment_Type__c = 'Casual';
        incCap3.Frequency_of_Payment__c ='Monthly';
        incCap3.Method_of_Calculation__c ='Net Income';
        incCap3.Method_of_Verification__c ='Verifier';
        incCap3.Income_1_DD__c = appResponse.EVerifier_Request_Date_Applicant_1__c ;
        incCap3.Minimum_Income_Used__c = 10000.00;
        incCap3.Annualised_Net_Income__c = 100000.00;
        incCap3.Annualised_Net_Income_per_Month__c = 10000;
        incCap3.Overtime_Shift_Allowance__c = 'No';
      //  insert incCap3;
        
        Income_Capacity__c incCap4 = new Income_Capacity__c();
        incCap4.Income__c = income5.id;
        incCap4.Income_Detail__c = 'My self-employed business' + ' ' + income5.Emp_Bus_Name__c;
        incCap4.Employment_Type__c = 'Self Employed';
        incCap4.Frequency_of_Payment__c ='Monthly';
        incCap4.Method_of_Calculation__c ='Net Income';
        incCap4.Method_of_Verification__c ='Verifier';
        incCap4.Income_1_DD__c = appResponse.EVerifier_Request_Date_Applicant_1__c ;
        incCap4.Minimum_Income_Used__c = 10000.00;
        incCap4.Annualised_Net_Income__c = 100000.00;
        incCap4.Annualised_Net_Income_per_Month__c = 10000;
        incCap4.Overtime_Shift_Allowance__c = 'No';       
        
       //  insert incCap4;
         
         List<Income_Capacity__c> icListt = new List<Income_Capacity__c>();
            icListt.add(incCap1);
            icListt.add(incCap2);
            icListt.add(incCap3);
            icListt.add(incCap4);
            insert icListt;
    }
    
    static testMethod void auPOIAutomationPermanent() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        System.assertEquals(testBrand.Id!=NULL ,true);
        
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        insert testApplication;    
          
         System.assertEquals(testApplication.Id!=NULL ,true);  
          
          
        Application__c testApplication2 = TestDataBuilder.createApplication();
        testApplication2.Insurance_Acknowledgement__c = true;
        testApplication2.Contract_Account_Number__c = '123123123123';
        testApplication2.Brand_Lookup__c = testBrand.id;
        testApplication2.Application_Type__c = 'Joint';
        insert testApplication2;        
        
         System.assertEquals(testApplication2.Id!=NULL ,true); 
        
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        
 
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
       
        System.assertEquals(testApplicant.Id!=NULL ,true); 
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication2.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        insert testApplicant2;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
       
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        insert inVar1;
                
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        inCap.Method_of_Verification__c ='Verifier';
        inCap.Income_Detail__c = 'My permanent - full time job' + ' ' + inVar1.Emp_Bus_Name__c;
        insert inCap;
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.EVerifier_Alert_Applicant_1__c = '';
        appResponse.EVerifier_Income_Applicant_1__c = 10000.00;
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;
        try{
        insert appResponse;
        }catch(DMLException e){}

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);
        Test.StopTest();

    } 
 static testMethod void auPOIAutomationPart() {
        Brand__c testBrand = TestDataBuilder.createBrand();
        testBrand.country__c = 'AU';
        insert testBrand;
        
        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Insurance_Acknowledgement__c = true;
        testApplication.Contract_Account_Number__c = '123123123123';
        testApplication.Brand_Lookup__c = testBrand.id;
        testApplication.Application_Type__c = 'Joint';
        insert testApplication;    
           
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Time_at_previous_employer_years__c = 1;
        testApplicant.Time_at_previous_employer_months__c = 13;
        insert testApplicant;
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Time_at_previous_employer_years__c = 0;
        testApplicant2.Time_at_previous_employer_months__c = 12;
        insert testApplicant2;
         
         System.assertEquals(testApplicant2.Id!=NULL ,true); 

        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        RecordType ONRrecordType = [SELECT ID FROM RecordType WHERE sObjectType='ONR__c' and DeveloperName = 'General'];
        
        GEProduct__c testProduct = TestDataBuilder.createGEProduct(testBrand.Id);
        insert testProduct;
        
        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        ONR__c testONR = TestDataBuilder.createObjectivesAndRequirements(testApplication.Id,ONRrecordType.Id);
        insert testONR;

        Loan_Purpose__c testLoanPurpose = TestDataBuilder.createLoanPurpose(testApplication.Id, testONR.Id);
        insert testLoanPurpose;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(testProductVersion.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;
       
        Income__c inVar1 = testDataBuilder.createIncome(testApplicant.Id);
        insert inVar1;
                
        Income_Capacity__c inCap= testDataBuilder.createIncomeCapacity(inVar1.Id);
        inCap.Method_of_Verification__c ='Verifier';
        inCap.Income_Detail__c = 'My permanent - full time job' + ' ' + inVar1.Emp_Bus_Name__c;
        insert inCap;
        
        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(testApplication.Id);
        appResponse.Response_Code__c = 'FIA';
        appResponse.EVerifier_Alert_Applicant_1__c = '';
        appResponse.EVerifier_Income_Applicant_1__c = 10000.00;
        appResponse.Contract_Account_Number__c = '123123123123';
        appResponse.EPOI_Completed_Flag__c= True;
        appResponse.Verified_Income__c =8000.00;
        try{
        insert appResponse;
        }catch(DMLException e){}

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);            
            APP_CommonExt construct=new APP_CommonExt(standardCon);
        Test.StopTest();

    }    
}