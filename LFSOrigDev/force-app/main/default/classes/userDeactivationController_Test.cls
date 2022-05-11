/*------------------------------------------------------------
Author: Davey Yu
Company: Cloud Sherpas
Description: userDeactivationController test class
History
07/13/15    Davey Yu      Created
------------------------------------------------------------*/
@istest
public with sharing class userDeactivationController_Test {
  static testMethod void userDeactivationController_Test() {
    List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
      insert testDataPurgeSettings;

      Brand__c testBrand = TestDataBuilder.createBrand();
      insert testBrand;

      List<Application__c> testApplicationList = new List<Application__c>();

      Application__c testApplication = TestDataBuilder.createApplication();
      testApplication.Status__c = GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW;
      testApplication.Brand_Lookup__c = testBrand.Id;
      testApplicationList.add(testApplication);

      Application__c testApplication2 = TestDataBuilder.createApplication();
      testApplication2.Status__c = GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMITTED;
      testApplication2.Brand_Lookup__c = testBrand.Id;
      testApplicationList.add(testApplication2);

      Application__c testApplication3 = TestDataBuilder.createApplication();
      testApplication3.Status__c = GEN_OriginationsConstants.APP_STATUS_CLOSED;
      testApplication3.Brand_Lookup__c = testBrand.Id;
      testApplicationList.add(testApplication3);
  
      insert testApplicationList;

      List<Applicant__c> testApplicantList = new List<Applicant__c>();
      Integer counter = 0;
      for(Application__c a: [Select Id from Application__c]){
          Applicant__c testApplicant = TestDataBuilder.createApplicant(null, a.Id);
          testApplicant.Email_Address__c = 'test'+counter+'@mail.com';
          testApplicantList.add(testApplicant);
          counter++;
      }

      insert testApplicantList;
      system.debug('test applicant list: '+testApplicantList.size());

      //List<Account> testPersonAccountList = TestDataBuilder.createPersonAccounts(1);
      
      //insert testPersonAccountList;

      List<Account> accList = new List<Account>();
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        for(Integer i=0; i<3; i++){
            Account acc = new Account(
                RecordTypeID=RecTypeId,
                FirstName='fname'+i,
                LastName='lname'+i,
                PersonMailingStreet='street',
                PersonMailingPostalCode='postal',
                PersonMailingCity='city',
                PersonEmail='testmail'+i+'@yahoo.com',
                PersonHomePhone='homephone',
                PersonMobilePhone='mobilephone',
                PersonMailingState = 'state',
                PersonMailingCountry = 'country',
                CLV_Customer_Id__c = '14344'+i
            );
            accList.add(acc);
        }    
        insert accList;

      List<Applicant__c> appForUpdate = new List<Applicant__c>();
      for(Integer i=0; i < 3; i++){
        testApplicantList[i].Account__c = accList[i].id;
        appForUpdate.add(testApplicantList[i]);
      }

      //update appForUpdate;

      Test.startTest();
        userDeactivationController ctrl = new userDeactivationController();
        ctrl.submittedAU = '1';
        ctrl.submittedNZ = '1';
        ctrl.unsubmittedAU = '1';
        ctrl.unsubmittedNZ = '1';
        ctrl.customerLogin = '1';
      Test.stopTest();
      
  }
}