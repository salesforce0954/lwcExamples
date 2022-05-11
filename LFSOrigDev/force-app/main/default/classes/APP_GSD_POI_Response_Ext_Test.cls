/* @Description: Test Class for APP_GSD_POI_Response_Ext_Test
 * @Author : Davey Yu
 * @Date : 18-FEB-2016
 * @History:
   =========================================================================================================
        18-FEB-2016 : Created - Davey
   =========================================================================================================
 */
@isTest
private class APP_GSD_POI_Response_Ext_Test {
    
    /*  Description: Test AU Application for Conditionally Approved POI
     *  Author: Davey Yu
     *  Date Created: 18-FEB-2016
    */
    static testMethod void testApplicationAU() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'D';
        insert testApplication;

    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        insert testApplicant;

        String appId = testApplicant.id;

        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'My permanent - full time job';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        Income__c income2 = new Income__c();
        income2.Applicant__c = appId;
        income2.Income_Source__c  = 'My contracting job';
        income2.Occupation__c = 'Test';
        income2.Emp_Bus_Name__c = 'Test';
        income2.Emp_Bus_Contact_No__c = '0334567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;

        Income__c income3 = new Income__c();
        income3.Applicant__c = appId;
        income3.Income_Source__c  = 'My self-employed business';
        income3.Occupation__c = 'Test';
        income3.Emp_Bus_Name__c = 'Test';
        income3.Emp_Bus_Contact_No__c = '0334567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;

        Income__c income4 = new Income__c();
        income4.Applicant__c = appId;
        income4.Income_Source__c  = 'My workers compensation';
        income4.Occupation__c = 'Test';
        income4.Emp_Bus_Name__c = 'Test';
        income4.Emp_Bus_Contact_No__c = '0334567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;

        Income__c income5 = new Income__c();
        income5.Applicant__c = appId;
        income5.Income_Source__c  = 'My rental property';
        income5.Occupation__c = 'Test';
        income5.Emp_Bus_Name__c = 'Test';
        income5.Emp_Bus_Contact_No__c = '0334567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;

        Income__c income6 = new Income__c();
        income6.Applicant__c = appId;
        income6.Income_Source__c  = 'My other source of income';
        income6.Occupation__c = 'Test';
        income6.Emp_Bus_Name__c = 'Test';
        income6.Emp_Bus_Contact_No__c = '0334567890';
        income6.Years_With_Employer__c = 5;
        income6.Months_With_Employer__c = 6;
        income6.Income_Amount__c = 1234567;
        income6.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income6.Total_Income__c = 1234567;
        income6.POI_Amount_Verified__c = 10000.00;
        insert income6;

        Income__c income7 = new Income__c();
        income7.Applicant__c = appId;
        income7.Income_Source__c  = 'My child support';
        income7.Occupation__c = 'Test';
        income7.Emp_Bus_Name__c = 'Test';
        income7.Emp_Bus_Contact_No__c = '0334567890';
        income7.Years_With_Employer__c = 5;
        income7.Months_With_Employer__c = 6;
        income7.Income_Amount__c = 1234567;
        income7.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income7.Total_Income__c = 1234567;
        income7.POI_Amount_Verified__c = 10000.00;
        insert income7;

        Income__c income8 = new Income__c();
        income8.Applicant__c = appId;
        income8.Income_Source__c  = 'My pension';
        income8.Occupation__c = 'Test';
        income8.Emp_Bus_Name__c = 'Test';
        income8.Emp_Bus_Contact_No__c = '0334567890';
        income8.Years_With_Employer__c = 5;
        income8.Months_With_Employer__c = 6;
        income8.Income_Amount__c = 1234567;
        income8.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income8.Total_Income__c = 1234567;
        income8.POI_Amount_Verified__c = 10000.00;
        insert income8;

        //Insert Meta Document
        //String typeID = [Select id from RecordType where sobjecttype = 'Meta_Document__c' and Name = 'AU'].id;
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
        insert md1;

        Test.startTest();
        //APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
        List<Income__c> incomeList = APP_GSD_POI_Response_Ext.queryIncomeSource(testApplicant.id);
        String brandCountry = [Select Brand_Country__c FROM Application__c WHERE id=: testApplication.id].Brand_Country__c;
        system.debug('test brand country: '+brandCountry);

        APP_GSD_POI_Response_Ext.queryPOIDocuments(brandCountry, incomeList, testApplication.Credit_Score__c);
        Test.stopTest();
    }

    /*  Description: Test NZ Application for Conditionally Approved POI
     *  Author: Davey Yu
     *  Date Created: 18-FEB-2016
    */
    static testMethod void testApplicationNZ() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'D';
        insert testApplication;

    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        insert testApplicant;

        String appId = testApplicant.id;

        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'Net Salary/Wages';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        Income__c income2 = new Income__c();
        income2.Applicant__c = appId;
        income2.Income_Source__c  = 'Other';
        income2.Occupation__c = 'Test';
        income2.Emp_Bus_Name__c = 'Test';
        income2.Emp_Bus_Contact_No__c = '0334567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;

        Income__c income3 = new Income__c();
        income3.Applicant__c = appId;
        income3.Income_Source__c  = 'Self Employed';
        income3.Occupation__c = 'Test';
        income3.Emp_Bus_Name__c = 'Test';
        income3.Emp_Bus_Contact_No__c = '0334567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;

        Income__c income4 = new Income__c();
        income4.Applicant__c = appId;
        income4.Income_Source__c  = 'Rental Income';
        income4.Occupation__c = 'Test';
        income4.Emp_Bus_Name__c = 'Test';
        income4.Emp_Bus_Contact_No__c = '0334567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;

        Income__c income5 = new Income__c();
        income5.Applicant__c = appId;
        income5.Income_Source__c  = 'Government Benefit';
        income5.Occupation__c = 'Test';
        income5.Emp_Bus_Name__c = 'Test';
        income5.Emp_Bus_Contact_No__c = '0334567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;

        
        //Insert Meta Document
        //String typeID = [Select id from RecordType where sobjecttype = 'Meta_Document__c' and Name = 'AU'].id;
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        insert md1;

        Test.startTest();
        //APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
        List<Income__c> incomeList = APP_GSD_POI_Response_Ext.queryIncomeSource(testApplicant.id);
        String brandCountry = [Select Brand_Country__c FROM Application__c WHERE id=: testApplication.id].Brand_Country__c;
        system.debug('test brand country: '+brandCountry);

        APP_GSD_POI_Response_Ext.queryPOIDocuments(brandCountry, incomeList, testApplication.Credit_Score__c);
        Test.stopTest();
    }
    
    /*  Description: Test NZ Application for Conditionally Approved POI with F credit score
     *  Author: Davey Yu
     *  Date Created: 18-FEB-2016
    */
    static testMethod void testApplicationCreditScoreNZ() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'F';
        insert testApplication;

    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        insert testApplicant;

        String appId = testApplicant.id;

        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'Net Salary/Wages';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        
        
        //Insert Meta Document
        //String typeID = [Select id from RecordType where sobjecttype = 'Meta_Document__c' and Name = 'AU'].id;
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        insert md1;

        Test.startTest();
        APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
        List<Income__c> incomeList = APP_GSD_POI_Response_Ext.queryIncomeSource(testApplicant.id);
        String brandCountry = [Select Brand_Country__c FROM Application__c WHERE id=: testApplication.id].Brand_Country__c;
        system.debug('test brand country: '+brandCountry);

        //APP_GSD_POI_Response_Ext.queryPOIDocuments(brandCountry, incomeList, testApplication.Credit_Score__c);
        Test.stopTest();
    }
    //
    /*  Description: Test AU Application for Conditionally Approved POI
     *  Author: Davey Yu
     *  Date Created: 18-FEB-2016
    */
    static testMethod void testAppProviso() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrand();
        insert brand;

        Application__c testApplication = TestDataBuilder.createApplication();
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'D';
        insert testApplication;

    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        insert testApplicant;

        String appId = testApplicant.id;

        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'My permanent - full time job';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        Income__c income2 = new Income__c();
        income2.Applicant__c = appId;
        income2.Income_Source__c  = 'My contracting job';
        income2.Occupation__c = 'Test';
        income2.Emp_Bus_Name__c = 'Test';
        income2.Emp_Bus_Contact_No__c = '0334567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;

        Income__c income3 = new Income__c();
        income3.Applicant__c = appId;
        income3.Income_Source__c  = 'My self-employed business';
        income3.Occupation__c = 'Test';
        income3.Emp_Bus_Name__c = 'Test';
        income3.Emp_Bus_Contact_No__c = '0334567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;

        Income__c income4 = new Income__c();
        income4.Applicant__c = appId;
        income4.Income_Source__c  = 'My workers compensation';
        income4.Occupation__c = 'Test';
        income4.Emp_Bus_Name__c = 'Test';
        income4.Emp_Bus_Contact_No__c = '0334567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;

        Income__c income5 = new Income__c();
        income5.Applicant__c = appId;
        income5.Income_Source__c  = 'My rental property';
        income5.Occupation__c = 'Test';
        income5.Emp_Bus_Name__c = 'Test';
        income5.Emp_Bus_Contact_No__c = '0334567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;

        Income__c income6 = new Income__c();
        income6.Applicant__c = appId;
        income6.Income_Source__c  = 'My other source of income';
        income6.Occupation__c = 'Test';
        income6.Emp_Bus_Name__c = 'Test';
        income6.Emp_Bus_Contact_No__c = '0334567890';
        income6.Years_With_Employer__c = 5;
        income6.Months_With_Employer__c = 6;
        income6.Income_Amount__c = 1234567;
        income6.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income6.Total_Income__c = 1234567;
        income6.POI_Amount_Verified__c = 10000.00;
        insert income6;

        Income__c income7 = new Income__c();
        income7.Applicant__c = appId;
        income7.Income_Source__c  = 'My child support';
        income7.Occupation__c = 'Test';
        income7.Emp_Bus_Name__c = 'Test';
        income7.Emp_Bus_Contact_No__c = '0334567890';
        income7.Years_With_Employer__c = 5;
        income7.Months_With_Employer__c = 6;
        income7.Income_Amount__c = 1234567;
        income7.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income7.Total_Income__c = 1234567;
        income7.POI_Amount_Verified__c = 10000.00;
        insert income7;

        Income__c income8 = new Income__c();
        income8.Applicant__c = appId;
        income8.Income_Source__c  = 'My pension';
        income8.Occupation__c = 'Test';
        income8.Emp_Bus_Name__c = 'Test';
        income8.Emp_Bus_Contact_No__c = '0334567890';
        income8.Years_With_Employer__c = 5;
        income8.Months_With_Employer__c = 6;
        income8.Income_Amount__c = 1234567;
        income8.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income8.Total_Income__c = 1234567;
        income8.POI_Amount_Verified__c = 10000.00;
        insert income8;
        
        //Income Capacity
        Income_Capacity__c testIncCap = TestDataBuilder.createIncomeCapacity(income.Id);
        Income_Capacity__c testIncCap1 = TestDataBuilder.createIncomeCapacity(income2.Id);
        
        
        //Insert Meta Document
        //String typeID = [Select id from RecordType where sobjecttype = 'Meta_Document__c' and Name = 'AU'].id;
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
        insert md1;

        Test.startTest();
        PageReference pageRef = Page.APP_GSD_POI_Response;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',testApplication.Id);
        
        APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
        Test.stopTest();
    }
       static testMethod void testProvisoNZ() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;

        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'AA';
        insert testApplication;

        Id appNz= Schema.SObjectType.Applicant__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.recordTypeId = appNz;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        testApplicant.Primary_Employment_Status__c ='Full Time';
        insert testApplicant;
        
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.recordTypeId = appNz;
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Response_Code__c = 'PAO';
        testApplicant2.Primary_Employment_Status__c ='Part Time';
        insert testApplicant2;

        String appId = testApplicant.id;
        string appId2 = testApplicant2.id;
        List<Income__c> incomeList = new List<Income__c>();
        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'Net Salary/Wages';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        Income__c income2 = new Income__c();
        income2.Applicant__c = appId;
        income2.Income_Source__c  = 'Other';
        income2.Occupation__c = 'Test';
        income2.Emp_Bus_Name__c = 'Test';
        income2.Emp_Bus_Contact_No__c = '0334567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;

        Income__c income3 = new Income__c();
        income3.Applicant__c = appId;
        income3.Income_Source__c  = 'Self Employed';
        income3.Occupation__c = 'Test';
        income3.Emp_Bus_Name__c = 'Test';
        income3.Emp_Bus_Contact_No__c = '0334567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;

        Income__c income4 = new Income__c();
        income4.Applicant__c = appId2;
        income4.Income_Source__c  = 'Rental Income';
        income4.Occupation__c = 'Test';
        income4.Emp_Bus_Name__c = 'Test';
        income4.Emp_Bus_Contact_No__c = '0334567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;

        Income__c income5 = new Income__c();
        income5.Applicant__c = appId2;
        income5.Income_Source__c  = 'Government Benefit';
        income5.Occupation__c = 'Test';
        income5.Emp_Bus_Name__c = 'Test';
        income5.Emp_Bus_Contact_No__c = '0334567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;
        incomeList.add(income);
         incomeList.add(income2);
         incomeList.add(income3);
         incomeList.add(income4);
        
         //Income Capacity
        Income_Capacity__c testIncCap = TestDataBuilder.createIncomeCapacity(income.Id);
        Income_Capacity__c testIncCap1 = TestDataBuilder.createIncomeCapacity(income2.Id);

        
        //Insert Meta Document
        //String typeID = [Select id from RecordType where sobjecttype = 'Meta_Document__c' and Name = 'AU'].id;
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        insert md1;

        Test.startTest();
        PageReference pageRef = Page.APP_GSD_POI_Response;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',testApplication.Id);
        
        APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
         String brandCountry = [Select Brand_Country__c FROM Application__c WHERE id=: testApplication.id].Brand_Country__c;
        system.debug('test brand country: '+brandCountry);
        APP_GSD_POI_Response_Ext.queryPOIDocuments(brandCountry, incomeList, testApplication.Credit_Score__c);
        Test.stopTest();
    }
    static testMethod void testProvisoEPOINZ() {
        //Create Test Data
        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Brand__c brand = TestDataBuilder.createBrandNZ();
        insert brand;
        
         GEProduct__c testProduct = TestDataBuilder.createGEProduct(brand.Id);
        insert testProduct;

        Product_Version__c testProductVersion = TestDataBuilder.createProductVersion(testProduct.Id);
        insert testProductVersion;

        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        testApplication.Response_Code__c = 'PAO';
        testApplication.Brand_Lookup__c = brand.id;
        testApplication.Credit_Score__c = 'AA';
        testApplication.UID__c='4656879767890';
        insert testApplication;

        Id appNz= Schema.SObjectType.Applicant__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.recordTypeId = appNz;
        testApplicant.Is_Primary_Applicant__c = true;
        testApplicant.Response_Code__c = 'PAO';
        testApplicant.Primary_Employment_Status__c ='Full Time';
        insert testApplicant;
        
       
        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant2.recordTypeId = appNz;
        testApplicant2.Is_Primary_Applicant__c = false;
        testApplicant2.Response_Code__c = 'PAO';
        testApplicant2.Primary_Employment_Status__c ='Part Time';
        insert testApplicant2;

        String appId = testApplicant.id;
        string appId2 = testApplicant2.id;
        List<Income__c> incomeList = new List<Income__c>();
        //Create Income records
        Income__c income = new Income__c();
        income.Applicant__c = appId;
        income.Income_Source__c  = 'My other source of income';
        income.Occupation__c = 'Test';
        income.Emp_Bus_Name__c = 'Test';
        income.Emp_Bus_Contact_No__c = '0334567890';
        income.Years_With_Employer__c = 5;
        income.Months_With_Employer__c = 6;
        income.Income_Amount__c = 1234567;
        income.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income.Total_Income__c = 1234567;
        income.POI_Amount_Verified__c = 10000.00;
        insert income;

        Income__c income2 = new Income__c();
        income2.Applicant__c = appId;
        income2.Income_Source__c  = 'Other';
        income2.Occupation__c = 'Test';
        income2.Emp_Bus_Name__c = 'Test';
        income2.Emp_Bus_Contact_No__c = '0334567890';
        income2.Years_With_Employer__c = 5;
        income2.Months_With_Employer__c = 6;
        income2.Income_Amount__c = 1234567;
        income2.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income2.Total_Income__c = 1234567;
        income2.POI_Amount_Verified__c = 10000.00;
        insert income2;

        Income__c income3 = new Income__c();
        income3.Applicant__c = appId;
        income3.Income_Source__c  = 'Self Employed';
        income3.Occupation__c = 'Test';
        income3.Emp_Bus_Name__c = 'Test';
        income3.Emp_Bus_Contact_No__c = '0334567890';
        income3.Years_With_Employer__c = 5;
        income3.Months_With_Employer__c = 6;
        income3.Income_Amount__c = 1234567;
        income3.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income3.Total_Income__c = 1234567;
        income3.POI_Amount_Verified__c = 10000.00;
        insert income3;

        Income__c income4 = new Income__c();
        income4.Applicant__c = appId2;
        income4.Income_Source__c  = 'Rental Income';
        income4.Occupation__c = 'Test';
        income4.Emp_Bus_Name__c = 'Test';
        income4.Emp_Bus_Contact_No__c = '0334567890';
        income4.Years_With_Employer__c = 5;
        income4.Months_With_Employer__c = 6;
        income4.Income_Amount__c = 1234567;
        income4.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income4.Total_Income__c = 1234567;
        income4.POI_Amount_Verified__c = 10000.00;
        insert income4;

        Income__c income5 = new Income__c();
        income5.Applicant__c = appId2;
        income5.Income_Source__c  = 'Government Benefit';
        income5.Occupation__c = 'Test';
        income5.Emp_Bus_Name__c = 'Test';
        income5.Emp_Bus_Contact_No__c = '0334567890';
        income5.Years_With_Employer__c = 5;
        income5.Months_With_Employer__c = 6;
        income5.Income_Amount__c = 1234567;
        income5.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
        income5.Total_Income__c = 1234567;
        income5.POI_Amount_Verified__c = 10000.00;
        insert income5;
        incomeList.add(income);
         incomeList.add(income2);
         incomeList.add(income3);
         incomeList.add(income4);
        
         //Income Capacity
        Income_Capacity__c testIncCap = TestDataBuilder.createIncomeCapacity(income.Id);
        Income_Capacity__c testIncCap1 = TestDataBuilder.createIncomeCapacity(income2.Id);

        //Admin settings
         insert new Admin_settings__c(name = 'ePOI link', value__c ='trestinng');
        insert new Admin_Settings__c(name='ePOI Link NZ', value__c='testing');
        //Insert Meta Document
       
        Meta_Document__c md1 = new Meta_Document__c();
        md1.Category__c = 'POI PL';
        md1.Document_Type__c =  'Payslip';
        md1.Description__c = 'Can include any of the followin';
        md1.RecordTypeId = Schema.Sobjecttype.Meta_Document__c.getRecordTypeInfosByName().get('NZ').getRecordTypeId();
        insert md1;

        Test.startTest();
        PageReference pageRef = Page.APP_GSD_POI_Response;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',testApplication.Id);
        
        APP_GSD_POI_Response_Ext ctrl = new APP_GSD_POI_Response_Ext();
         String brandCountry = [Select Brand_Country__c FROM Application__c WHERE id=: testApplication.id].Brand_Country__c;
        system.debug('test brand country: '+brandCountry);
        APP_GSD_POI_Response_Ext.queryPOIDocuments(brandCountry, incomeList, testApplication.Credit_Score__c);
        APP_GSD_POI_Response_Ext.generateRelatedDocuments(testApplication.UID__c,'testing','nz',testApplicant.Id,testProduct.Id,testApplication.Id,'GEM');
        
        Test.stopTest();
    }
    
}