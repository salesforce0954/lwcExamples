/**
 * @Description: Test class for user deactivation
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 29-10-2015
 * @History:
    =====================================================================
       29-10-2015: Created. - Davey Yu
       
    =====================================================================
**/
@isTest
public class DeactivateApplicationUsers_Test{
    static testMethod void batch_Test(){    
      
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
          DeactivateUserHelper util = new DeactivateUserHelper('New');
          DeactivateUnsubmittedUsersBatch batchJob = new DeactivateUnsubmittedUsersBatch();
          batchJob.query = util.getQuery(index);
          batchJob.index = index+1;
          Database.executeBatch(batchJob);

          DeactivateUserHelper util2 = new DeactivateUserHelper('Submitted');
          DeactivateSubmittedUsersBatch batchJob2 = new DeactivateSubmittedUsersBatch();
          batchJob2.query = util2.getQuery(index);
          batchJob2.index = index+1;
          Database.executeBatch(batchJob2);

          Test.StopTest();
      }
  
  }
}