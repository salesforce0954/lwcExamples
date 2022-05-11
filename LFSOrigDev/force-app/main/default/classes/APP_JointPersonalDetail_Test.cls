@isTest
public class APP_JointPersonalDetail_Test {
    
    static testMethod void constructor_Test(){ 
        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;
        
        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_JointPersonalDetail personalDetails = new APP_JointPersonalDetail();
        Test.StopTest();

        System.assert(!adminSettingsList.isEmpty());
    }

    static testMethod void ApplicantOnedtSearchPrepopulateApp_Test(){ 
        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        // Create Applicant Search for CLV
        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;
                    
        // Create Applicant CLV for Applicant 1
        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, testApplicant.Id);
        appCLVList[0].Prepopulate__c = true;

        insert appCLVList;

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_JointPersonalDetail personalDetails = new APP_JointPersonalDetail();
            personalDetails.appCount = 1;
            personalDetails.appId = testApplication.Id;
            personalDetails.getAppCount();
            personalDetails.setAppCount(1);
            personalDetails.dtSearchPrepopulateApp(1);
            personalDetails.stringNullChecker('Test');
        Test.StopTest();
    }

    static testMethod void ApplicantTwodtSearchPrepopulateApp_Test(){ 
        List<Admin_Settings__c> adminSettingsList = TestDataBuilder.adminSet();
        insert adminSettingsList;

        Account acc = TestDataBuilder.createPersonAccount();
        insert acc;

        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;
    
        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        Applicant__c testApplicant2 = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant2;

        Applicant_Search__c appSearch = TestDataBuilder.appSearch();
        insert appSearch;
                    
        // Create Applicant CLV for Applicant 1
        List<Applicant_CLV__c> appCLVList = TestDataBuilder.applicantCLVList(appSearch.Id, testApplicant2.Id);
        appCLVList[0].Prepopulate__c = true;
        appCLVList[0].Street_Address__c = '';
        appCLVList[0].Suburb__c = 'Test';
        insert appCLVList;
        
        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_JointPersonalDetail personalDetails = new APP_JointPersonalDetail();
            personalDetails.appCount = 2;
            personalDetails.appId = testApplication.Id;
            personalDetails.getAppCount();
            personalDetails.setAppCount(2);
            personalDetails.dtSearchPrepopulateApp(2);
            personalDetails.stringNullChecker(null);
        Test.StopTest();
    }
}