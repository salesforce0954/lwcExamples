@isTest
private class GEN_OfferUtilityTest {
    
    @isTest static void test_method_one() {
        
            Brand__c brand = TestDataBuilder.createBrandNZ(); 
            insert brand;
        
            system.debug('***'+brand.Country__c);
			Application__c app = TestDataBuilder.createApplicationNZ(brand);//create application
			app.Response_Code__c = 'New';
			app.Brand_String__c = 'NZ';
            //app.Application_Type__c = 'Joint';
			insert app;

          System.debug('***app.Brand_Country__c:'+app.Brand_Country__c);
          List<Application__c> appList = new List<Application__c>();
          appList.add(app);

      

        GEProduct__c gep = TestDataBuilder.createGEProduct(brand.Id, 'Insurance');
        insert gep;
        
        Product_Version__c pv = TestDataBuilder.createProductVersion(gep.Id);
        insert pv;

        Product_Item__c pi = TestDataBuilder.createProductItem(app.Id, pv.Id);
        insert pi;

        Id rectypeIdONR = [select id from RecordType where name='Loan Purpose' and SObjectType='ONR__c'].Id;
        ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, rectypeIdONR);
        insert onr;

        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(app.Id, onr.id, 'Debt consolidation');
        insert lp;

        test.startTest();
        GEN_OfferUtility.flushOffers(appList);
        GEN_OfferUtility.flushApplicant2(appList);
        

        appList = [select id, name, (Select Id, Product_Name__c From Product_Items__r), (Select Id, Name From Loan_Purpose__r) from Application__c where id = : app.Id];
        for (Application__c application : appList) {
            system.assertEquals(0, application.Product_Items__r.size());
            system.assertEquals(1, application.Loan_Purpose__r.size());
        }
        test.stopTest();

    }
    
    @isTest static void test_method_two() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;

        Application__c app = TestDataBuilder.createApplication();
        insert app;

        List<Application__c> appList = new List<Application__c>();
        appList.add(app);

        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;

        GEProduct__c gep = TestDataBuilder.createGEProduct(brand.Id, 'Insurance');
        insert gep;
        
        Product_Version__c pv = TestDataBuilder.createProductVersion(gep.Id);
        insert pv;

        Product_Item__c pi = TestDataBuilder.createProductItem(app.Id, pv.Id);
        insert pi;

        Id rectypeIdONR = [select id from RecordType where name='Loan Purpose' and SObjectType='ONR__c'].Id;
        ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, rectypeIdONR);
        insert onr;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, app.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, app.Id);
        insert testApplicant2;

        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(app.Id, onr.id, 'Debt consolidation');
        insert lp;

        Insurance_Premium_Calculation_Variables__c  ipcv = new Insurance_Premium_Calculation_Variables__c();
        ipcv.Name = 'counter';
        ipcv.Value__c = 15.000;
        ipcv.Description__c = 'Max number of iteration before getting out';
        insert ipcv;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, app.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(pv.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(app.Id);
        insert appResponse;
        
        String applicationId = app.Id;
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Application__c.FieldSets.Application_Commons.getFields()) {
          query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        //query += ' FROM Application__c where Id IN: applicationId';
        query += ' FROM Application__c where Id =: applicationId';
        AppLication__c application =  Database.query(query);

        test.startTest();
        Application__c newApp = GEN_OfferUtility.populateOfferFields(application,false);

        test.stopTest();

        System.assertEquals(app.Id, lp.Application__c);
    }
    
    @isTest static void test_method_three() {
        List<Insurance_Premium_Calculation_Variables__c> insPremVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
        insert insPremVariables;
        
        Application__c app = TestDataBuilder.createApplication();

        List<Application__c> appList = new List<Application__c>();
        appList.add(app);
        insert appList;

        List<Account> acctList = TestDataBuilder.createAccounts(2);
        insert acctList;
        
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, app.Id);
        insert testApplicant;
        
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, app.Id);
        insert testApplicant2;
        
        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;

        GEProduct__c gep = TestDataBuilder.createGEProduct(brand.Id, 'Insurance', 'Life Insurance');
        insert gep;
        
        Product_Version__c pv = TestDataBuilder.createProductVersion(gep.Id);
        insert pv;

        Product_Item__c pi = TestDataBuilder.createProductItem(app.Id, pv.Id);
        //pi.Applicant1__c = applicant1.Id;
        //pi.Applicant2__c = applicant2.Id;
        insert pi;

        Id rectypeIdONR = [select id from RecordType where name='Loan Purpose' and SObjectType='ONR__c'].Id;
        ONR__c onr = TestDataBuilder.createObjectivesAndRequirements(app.Id, rectypeIdONR);
        insert onr;

        Loan_Purpose__c lp = TestDataBuilder.createLoanPurpose(app.Id, onr.id, 'Debt consolidation');
        insert lp;

        Insurance_Premium_Calculation_Variables__c  ipcv = new Insurance_Premium_Calculation_Variables__c();
        ipcv.Name = 'counter';
        ipcv.Value__c = 15.000;
        ipcv.Description__c = 'Max number of iteration before getting out';
        insert ipcv;

        Response_Code_Control__c responseCodeControl = TestDataBuilder.createResponseCodeControl(true, app.Response_Code__c);
        insert responseCodeControl;

        Profile_Control__c profileControl = TestDataBuilder.createProfileControl(true);
        insert profileControl;

        Insurance_Premium_Calculation_Variables__c insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremium();
        insert insurancePremiumCalculationVariables;

        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        List<Web_Service_Settings__c> testWebServiceSettings = new List<Web_Service_Settings__c>();
        Web_Service_Settings__c setting1= TestDataBuilder.createWebServiceSettings('Requested Name Sales','SalesUI');
        testWebServiceSettings.add(setting1);

        Web_Service_Settings__c setting2 = TestDataBuilder.createWebServiceSettings('SearchTimeOut','100000');
        testWebServiceSettings.add(setting2);

        insert testWebServiceSettings;

        List<HeaderColors__c> createHeaderColorsList = TestDataBuilder.createHeaderColors();
        insert createHeaderColorsList;

        Rate_Card__c rateCard = TestDatabuilder.createRateCard(pv.Id);
        insert rateCard;

        Rate__c rate = TestDatabuilder.createRate(rateCard.Id);
        insert rate;

        Application_Response__c appResponse = TestDataBuilder.createApplicationResponse(app.Id);
        insert appResponse;
        
        String applicationId = app.Id;
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Application__c.FieldSets.Application_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        //query += ' FROM Application__c where Id IN: applicationId';
        query += ' FROM Application__c where Id =: applicationId';
        AppLication__c application =  Database.query(query);
        
        Id restructureRecTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Offer__c' AND DeveloperName =: 'Restructure' LIMIT 1].Id;
        Offer__c offer = TestDatabuilder.createOffer(gep.Id,'Unsecured Upsell', restructureRecTypeId);
        insert offer;

        Offer_Presented__c offerPresented = TestDataBuilder.createOfferPresented(offer.Id,  appResponse.Id);
        insert offerPresented;

        List<GEProduct__c> geProductInsurance = new List<GEProduct__c>();
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(brand.Id, 'Life Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(brand.Id, 'Disability Insurance'));
        geProductInsurance.add(TestDataBuilder.createGEProductInsurance(brand.Id, 'Involuntary Unemployment Insurance'));

        insert geProductInsurance;

        List<Product_Version__c> testProductVersionInsurance = new List<Product_Version__c>();
        for(GEProduct__c prod:geProductInsurance){
            testProductVersionInsurance.add(TestDataBuilder.createProductVersion(prod.Id));
        }
        insert testProductVersionInsurance;

        System.debug('testProductVersionInsurance-->'+testProductVersionInsurance);

        List<Product_Item__c> testProductItemInsurance = new List<Product_Item__c>();
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(application.Id, pv.Id,'Life Insurance', testApplicant.Id, testApplicant2.Id));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(application.Id, pv.Id,'Disability Insurance', testApplicant.Id, testApplicant2.Id));
        testProductItemInsurance.add(TestDatabuilder.createInsuranceProductItem(application.Id, pv.Id,'Involuntary Unemployment Insurance', testApplicant.Id, testApplicant2.Id));
        insert testProductItemInsurance;

        List<Application__c> appList2 = new List<Application__c>();
        appList2.add(application);
        
        test.startTest();
        GEN_OfferUtility.calculateProductItems(appList2);

        test.stopTest();

        System.assertEquals(app.Id, lp.Application__c);
    }   
}