/*------------------------------------------------------------
Author: Davey Yu
Company: Cloud Sherpas
Description: DeactivateUsersBatch test class
History
14/07/15    Davey Yu      Created
------------------------------------------------------------*/
@isTest
public class DeactivateUsersBatch_Test{
    static testMethod void batch_Test(){    
      
      DeactivateUserUtil util = new DeactivateUserUtil();
      Integer index = 0;

      //Contact c = [SELECT Id FROM Contact WHERE AccountId =: testPersonAccountList.get(0).Id];
      Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'A1 Customer Community Login'];
      Profile testProfileAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
      UserRole adminRole = [Select id from UserRole where name = 'System Administrator'];
      
      User testUserAdmin = TestDataBuilder.createUser2(testProfileAdmin.ID);
      
      testUserAdmin.UserRoleId = adminRole.id;
      User testUser;
  
      System.runAs(testUserAdmin){
       List<Data_Perge_Settings__c> testDataPurgeSettings = TestDataBuilder.createAllDataPurgeSettings();
       insert testDataPurgeSettings;

          Test.StartTest();
          DeactivateUsersBatch batchJob = new DeactivateUsersBatch();
          batchJob.query = util.getQuery(index);
          batchJob.index = index+1;
          Database.executeBatch(batchJob);
          Test.StopTest();
      }
  
  }
}