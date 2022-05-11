/**
 * @Description: Test class for delete application (submitted/unsubmitted) and billing records
 * @Author: Davey
 * @Date Created: 29-10-2015
 * @History:
    =====================================================================
       29-05-2014: Created. - Davey
    =====================================================================
**/
@isTest
public class DeleteApplicationRecordsBatch_Test{
  
    static testMethod void batch_Test(){
      
      List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
      insert testDataPurgeSettings;

      Response_Code_Control__c responseCodeControl = new Response_Code_Control__c();
      responseCodeControl.Name = 'Purged';
      responseCodeControl.Decision__c = 'System';
      responseCodeControl.Close_CLV__c = true;
      responseCodeControl.CPU_Case_CLV__c = true;
      responseCodeControl.Edit_CLV__c = true;
      responseCodeControl.Type__c = 'Conditionally Approved';
      responseCodeControl.Personal_Reference_Check__c = true;
      responseCodeControl.Credit_Ref_Check__c = true;
      responseCodeControl.Credit_File_Check__c = true;
      responseCodeControl.Risk_Referral__c = true;
      responseCodeControl.Lending_Limit_Override__c = false;
      responseCodeControl.Rate_Reduction__c = false;
      responseCodeControl.Fee_Reduction__c = false;
      responseCodeControl.Manager_Approval__c = true;
      responseCodeControl.Save_Collateral_Standard__c = true;
      responseCodeControl.Save_Debit_Standard__c = true;
      responseCodeControl.Save_Disbursement_Standard__c = true;
      responseCodeControl.Edit_Collateral_Standard__c = true;
      responseCodeControl.Edit_Debit_Standard__c = true;
      responseCodeControl.Delete_Collateral_Standard__c = true;
      responseCodeControl.Delete_Debit_Standard__c = true;
      responseCodeControl.Delete_Disbursement_Standard__c = true;
      insert responseCodeControl;
      
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
        
        insert testApplicationList;

        Response_Code_Control__c testResponseCodeControl = TestDataBuilder.createResponseCodeControl(true, testApplication2.Response_Code__c);
        insert testResponseCodeControl;

        Profile_Control__c testProfileControl = TestDataBuilder.createProfileControl(true);
        insert testProfileControl;

        List<Applicant__c> testApplicantList = new List<Applicant__c>();
        
        Integer counter = 0;
        for(Application__c a: testApplicationList){
            Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplicationList.get(counter).Id);
            testApplicant.Email_Address__c = 'test'+counter+'@mail.com';
            testApplicantList.add(testApplicant);
            counter++;
        }

        insert testApplicantList;

        List<Account> testPersonAccountList = TestDataBuilder.createPersonAccounts(1);
        insert testPersonAccountList;

        Credit_File_Check__c testCreditFileCheck = TestDataBuilder.createCreditFileCheck(testApplicantList.get(1).Id, testApplicationList.get(1).Id);
        insert testCreditFileCheck;

        Credit_Ref_Check__c testCreditRefCheck = TestDataBuilder.createCreditRefCheck(testApplicationList.get(1).Id);
        insert testCreditRefCheck;

        Id debitRecordTypeId = Schema.SObjectType.Debit__c.getRecordTypeInfosByName().get('Direct Debit').getRecordTypeId();
        Debit__c testDebit = TestDataBuilder.createDebit(debitRecordTypeId, testApplicationList.get(1).Id);
        insert testDebit;

        Id directCreditRecordTypeId = Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Direct Credit').getRecordTypeId();
        Disbursement__c testDisbursement = TestDataBuilder.createDisbursement(testApplicationList.get(1).Id);
        testDisbursement.RecordTypeId = directCreditRecordTypeId;
        insert testDisbursement;

        Personal_Reference_Check__c testPersonalReferenceCheck = TestDataBuilder.createPersonalReferenceCheck(testApplicationList.get(1).Id);
        insert testPersonalReferenceCheck;

        Related_Document__c testRelatedDocument = TestDataBuilder.createRelatedDocument(testApplicantList.get(1).Id, testApplicationList.get(1).Id);
        insert testRelatedDocument;

        Collateral_Settings__c testCollateralSettings = TestDataBuilder.createCollateralSetting();
        insert testCollateralSettings;

        //Collateral__c testCollateral = TestDataBuilder.createCollateral(testApplicationList.get(1).Id);
        //insert testCollateral;

        AML__c testAML = TestDataBuilder.createAML(testApplicantList.get(1).Id);
        insert testAML;

        Expense__c testExpense = TestDataBuilder.createExpense(testApplicantList.get(1).Id);
        insert testExpense;

        Income__c testIncome = TestDataBuilder.createIncome(testApplicantList.get(1).Id);
        insert testIncome;

        Id generalRecordTypeId = Schema.SObjectType.ExceptionLog__c.getRecordTypeInfosByName().get('General').getRecordTypeId();
        ExceptionLog__c testExceptionLog = TestDataBuilder.createExceptionLog('', '', '', '', '', '', generalRecordTypeId);
        insert testExceptionLog;

   
      Integer index = 0;

        Contact c = [SELECT Id FROM Contact WHERE AccountId =: testPersonAccountList.get(0).Id];
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'A1 Customer Community Login'];
        Profile testProfileAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUserAdmin = TestDataBuilder.createUser2(testProfileAdmin.ID);
        User testUser;
        
        System.runAs(testUserAdmin){
            //testUser = TestDataBuilder.createUser(testProfile.Id);
            //testUser.Email = testApplicantList.get(1).Email_Address__c;
            //testUser.ContactId = c.Id;
            //testUser.UserRoleId = null;
            //insert testUser;
            
          Test.StartTest();
            DeleteRecordsHelper util = new DeleteRecordsHelper('New');
            DeleteUnsubmittedApplicationBatch batchJob = new DeleteUnsubmittedApplicationBatch();
            batchJob.query = util.getQuery(index);
            batchJob.index = index+1;
            Database.executeBatch(batchJob);

            DeleteRecordsHelper util2 = new DeleteRecordsHelper('Submitted');
            UpdateSubmittedApplicationBatch batchJob2 = new UpdateSubmittedApplicationBatch();
            batchJob2.query = util2.getQuery(index);
            batchJob2.index = index+1;
            Database.executeBatch(batchJob2);

            DeleteRecordsHelper util3 = new DeleteRecordsHelper('Billing');
            DeleteBillingRecordsBatch batchJob3 = new DeleteBillingRecordsBatch();
            batchJob3.query = util3.getQuery(index);
            batchJob3.index = index+1;
            Database.executeBatch(batchJob3);
            Test.StopTest();
        }

      Integer applicationCountAfterBatch = [SELECT COUNT() FROM Application__c];
        System.assertNotEquals(testApplicationList.size(), applicationCountAfterBatch);
        
        //User deactivatedUser = [SELECT isActive FROM User WHERE Id =: testUser.Id];
        //System.assertEquals(false, deactivatedUser.isActive);

        List<Application__c> flushedApplcations = [SELECT Id, 
                                                          Applicant_1_Name__c, 
                                                          Applicant_2_Name__c, 
                                                          FP_IP_Address__c, 
                                                          (SELECT Comments__c FROM Credit_File_Checks__r), 
                                                          (SELECT Account_Conduct__c, 
                                                                  Collateral__c, 
                                                                  Company__c, 
                                                                  Contract_Account_No__c, 
                                                                  Name_on_Contract__c, 
                                                                  Spoke_with__c 
                                                           FROM   Credit_Ref_Check__r), 
                                                           (SELECT Account_Holders__c FROM Debits__r), 
                                                           (SELECT Bank_Acc_No__c, Payee__c FROM Disbursements__r), 
                                                           (SELECT Name__c, Phone_Number__c, Relationship__c FROM Personal_Reference_Checks__r), 
                                                           (SELECT Title__c FROM Related_Documents__r) 
                                                   FROM   Application__c];

        Set<Id> applicationIdSet = new Set<Id>();

        for(Application__c a: flushedApplcations){

            System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Applicant_1_Name__c);
            //System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Applicant_2_Name__c);
            System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.FP_IP_Address__c);

            for(Credit_File_Check__c cfc: a.Credit_File_Checks__r){
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, cfc.Comments__c);
            }

            for(Credit_Ref_Check__c crc: a.Credit_Ref_Check__r){
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Account_Conduct__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Collateral__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Company__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Contract_Account_No__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Name_on_Contract__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, crc.Spoke_with__c);
            }

            for(Debit__c d: a.Debits__r){
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, d.Account_Holders__c);
            }

            for(Disbursement__c d: a.Disbursements__r){
                //System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, d.Bank_Acc_No__c);
                //System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, d.Payee__c);
            }

            for(Personal_Reference_Check__c p: a.Personal_Reference_Checks__r){
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, p.Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, p.Phone_Number__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, p.Relationship__c);
            }

            for(Related_Document__c r: a.Related_Documents__r){
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, r.Title__c);
            }

            applicationIdSet.add(a.Id);
        }
        
        if(!applicationIdSet.isEmpty()){

            List<Applicant__c> flushedApplicants = [SELECT Date_of_Birth_WS__c, 
                                                           Date_of_Birth__c, 
                                                           Drivers_Lic_No__c, 
                                                           Email_Address__c, 
                                                           First_Name__c, 
                                                           Home_Area_Code__c, 
                                                           Home_WS__c, 
                                                           Home__c, 
                                                           Last_Name__c, 
                                                           Middle_Name__c, 
                                                           Mobile__c, 
                                                           Previous_Property_Name__c, 
                                                           Residential_Property_Name__c, 
                                                           Street_No_Pos__c, 
                                                           Street_No_Pre__c, 
                                                           Street_Res__c, 
                                                           Unit_No_Pos__c, 
                                                           Unit_No_Pre__c, 
                                                           Unit_No_Res__c, 
                                                           Work_Area_Code__c, 
                                                           Work_WS__c, 
                                                           Work__c, 
                                                           (SELECT ID_No__c, Staff_ID_Sighted_By__c FROM AMLs__r), 
                                                           (SELECT Agent_Landlord_Name__c, Agent_Landlord_Phone_Number__c FROM Expenses__r), 
                                                           (SELECT Emp_Bus_Contact_No__c, Emp_Bus_Name__c FROM Incomes__r) 
                                                    FROM   Applicant__c 
                                                    WHERE  Application__c IN: applicationIdSet];

            /*for(Applicant__c a: flushedApplicants){
                
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Date_of_Birth_WS__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Date_of_Birth__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Drivers_Lic_No__c);
                System.assertEquals(String.valueOf(a.Id + GEN_OriginationsConstants.EMAIL_TOKEN_VALUE).ToLowerCase(), a.Email_Address__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.First_Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Home_Area_Code__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Home_WS__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Home__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Last_Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Middle_Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Mobile__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Previous_Property_Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Residential_Property_Name__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Street_No_Pos__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Street_No_Pre__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Unit_No_Res__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Work_Area_Code__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Work_WS__c);
                System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, a.Work__c);

                for(AML__c am: a.AMLs__r){
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, am.ID_No__c);
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, am.Staff_ID_Sighted_By__c);
                }

                for(Expense__c e: a.Expenses__r){
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, e.Agent_Landlord_Name__c);
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, e.Agent_Landlord_Phone_Number__c);
                }

                for(Income__c i: a.Incomes__r){
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, i.Emp_Bus_Contact_No__c);
                    System.assertEquals(GEN_OriginationsConstants.TOKEN_VALUE, i.Emp_Bus_Name__c);
                }
            }*/
        }
    }
}