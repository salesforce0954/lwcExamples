@isTest
public class APP_POIExt_Test {
    static testMethod void POI_Test() {
        //redirect w/ customer parameter and all methods
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Income__c> testIncomeList = new List<Income__c>();

        Income__c testIncomeFULL = TestDataBuilder.createIncome(testApplicant.Id);
        testIncomeFULL.Income_Source__c = 'Permanent full time / Part time';
        testIncomeList.add(testIncomeFULL);

        Income__c testIncomeRENTAL = TestDataBuilder.createIncome(testApplicant.Id);
        testIncomeRENTAL.Income_Source__c = 'Rental Income';
        testIncomeList.add(testIncomeRENTAL);

        Income__c testIncomeSUPER = TestDataBuilder.createIncome(testApplicant.Id);
        testIncomeSUPER.Income_Source__c = 'Superannuation';
        testIncomeList.add(testIncomeSUPER);

        insert testIncomeList;

        List<Income_Document__c> testIncomeDocumentList = new List<Income_Document__c>();

        Income_Document__c testIncomeDocumentFULL = new Income_Document__c();
        testIncomeDocumentFULL.Name = 'Test';
        testIncomeDocumentFULL.Income_Source__c = 'Permanent full time / Part time';
        testIncomeDocumentFULL.Information_to_show__c = 'Test';
        testIncomeDocumentList.add(testIncomeDocumentFULL);

        Income_Document__c testIncomeDocumentRENTAL = new Income_Document__c();
        testIncomeDocumentRENTAL.Name = 'Test';
        testIncomeDocumentRENTAL.Income_Source__c = 'Rental Income';
        testIncomeDocumentRENTAL.Information_to_show__c = 'Test';
        testIncomeDocumentList.add(testIncomeDocumentRENTAL);

        Income_Document__c testIncomeDocumentSUPER = new Income_Document__c();
        testIncomeDocumentSUPER.Name = 'Test';
        testIncomeDocumentSUPER.Income_Source__c = 'Superannuation';
        testIncomeDocumentSUPER.Information_to_show__c = 'Test';
        testIncomeDocumentList.add(testIncomeDocumentSUPER);

        insert testIncomeDocumentList;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('File Upload Endpoint','https://plorigau-Dev.salesforce.capital.ge.com/ge/fileupload-dev.au.money/fileupload/income/salesforceRequest');
        insert testWebServiceSettings;
    
        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('mode', 'Cust');
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_POIExt poi = new APP_POIExt(standardCon);
            PageReference pageRef = Page.APP_POI;
            Test.setCurrentPageReference(pageRef);
            poi.getFullTimeOpt();
            poi.getRentalOpt();
            poi.getSuperOpt();
            poi.createInitialRelatedDocument();
            poi.pageCancel();
            poi.title = 'test';
            poi.insertRelatedDocument();
            poi.status = 'success';
            poi.updateRelatedDocument();
            poi.status = '209';
            poi.updateRelatedDocument();
            poi.status = '220';
            poi.updateRelatedDocument();
            poi.status = '221';
            poi.updateRelatedDocument();
            poi.status = '222';
            poi.updateRelatedDocument();
            poi.status = '210';
            poi.updateRelatedDocument();
        Test.StopTest();

        //System.assertEquals(testIncomeDocumentList.size(), poi.allDocuments.size());
        //System.assertEquals(1, poi.fullTimeDocuments.size());
        //System.assert(poi.hasFullTime);
        //System.assertEquals(1, poi.rentalDocuments.size());
        //System.assert(poi.hasRental);
        //System.assertEquals(1, poi.superDocuments.size());
        //System.assert(poi.hasSuper);
        System.assertEquals('Cust', poi.mode);
        System.assertEquals(testWebServiceSettings.Value__c, poi.uploadEndPoint);
        //System.assertEquals(testApplicant.First_Name__c, poi.applicantFirstName);
        //System.assertEquals(testApplicant.Last_Name__c, poi.applicantLastName);
    }

    static testMethod void POI_Test2() {
        //redirect w/ staff parameter and existing related document
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('File Upload Endpoint','https://plorigau-Dev.salesforce.capital.ge.com/ge/fileupload-dev.au.money/fileupload/income/salesforceRequest');
        insert testWebServiceSettings;

        Related_Document__c testRelatedDocument = TestDataBuilder.createRelatedDocument(testApplicant.Id, testApplication.Id);
        insert testRelatedDocument;

        Test.StartTest();
            ApexPages.CurrentPage().getParameters().put('mode', 'Staff');
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_POIExt poi = new APP_POIExt(standardCon);
            PageReference pageRef = Page.APP_POI;
            Test.setCurrentPageReference(pageRef);
            poi.createInitialRelatedDocument();
            poi.pageCancel();
        Test.StopTest();

        System.assert(poi.allDocuments.isEmpty());
        System.assert(poi.fullTimeDocuments.isEmpty());
        System.assert(!poi.hasFullTime);
        System.assert(poi.rentalDocuments.isEmpty());
        System.assert(!poi.hasRental);
        System.assert(poi.superDocuments.isEmpty());
        System.assert(!poi.hasSuper);
        System.assertEquals('Staff', poi.mode);
        System.assertEquals(testWebServiceSettings.Value__c, poi.uploadEndPoint);
        //System.assertEquals(testRelatedDocument.Id, poi.initialDocument.Id);
        //System.assertEquals(testApplicant.First_Name__c, poi.applicantFirstName);
        //System.assertEquals(testApplicant.Last_Name__c, poi.applicantLastName);
    }

    static testMethod void POI_Test3() {
        //redirect w/o parameter
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('File Upload Endpoint','https://plorigau-Dev.salesforce.capital.ge.com/ge/fileupload-dev.au.money/fileupload/income/salesforceRequest');
        insert testWebServiceSettings;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_POIExt poi = new APP_POIExt(standardCon);
            PageReference pageRef = Page.APP_POI;
            Test.setCurrentPageReference(pageRef);
            poi.pageCancel();
        Test.StopTest();

        System.assert(poi.allDocuments.isEmpty());
        System.assert(poi.fullTimeDocuments.isEmpty());
        System.assert(!poi.hasFullTime);
        System.assert(poi.rentalDocuments.isEmpty());
        System.assert(!poi.hasRental);
        System.assert(poi.superDocuments.isEmpty());
        System.assert(!poi.hasSuper);
        System.assertEquals(null, poi.mode);
        System.assertEquals(testWebServiceSettings.Value__c, poi.uploadEndPoint);
        //System.assertEquals(testApplicant.First_Name__c, poi.applicantFirstName);
        //System.assertEquals(testApplicant.Last_Name__c, poi.applicantLastName);
    }
    static testMethod void POI_Test4(){
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        Web_Service_Settings__c testWebServiceSettings = TestDataBuilder.createWebServiceSettings('File Upload Endpoint','https://plorigau-Dev.salesforce.capital.ge.com/ge/fileupload-dev.au.money/fileupload/income/salesforceRequest');
        insert testWebServiceSettings;

        Test.startTest();
            String rdId = APP_POIExt.testInsertForMultiple(testApplication.Id, testApplicant.Id, '');
        Test.StopTest();

        System.assertNotEquals(null,rdId);
    }
}