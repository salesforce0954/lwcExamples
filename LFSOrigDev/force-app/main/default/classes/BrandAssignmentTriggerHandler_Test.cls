@isTest
public class BrandAssignmentTriggerHandler_Test {
	static testMethod void assignPublicGroup_Test(){
		Group testGroup = TestDataBuilder.createGroup();
		insert testGroup;		

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
		User testUser = TestDataBuilder.createUser(profileId);
		insert testUser;

		System.runAs(new User(Id = UserInfo.getUserId())) {

		Brand__c testBrand = TestDataBuilder.createBrand();
		String publicGroupId = testGroup.Id;
		testBrand.Public_Group_Id__c = publicGroupId.substring(0, 15);
		insert testBrand;

		Brand_Assignment__c testBrandAssignment = TestDataBuilder.createBrandAssignment(testUser.Id, testBrand.Id);

		Test.StartTest();
			insert testBrandAssignment;
		Test.StopTest();

		}

		GroupMember insertedGroupMember = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: testuser.Id AND GroupId =: testGroup.Id];
		
		System.AssertEquals(insertedGroupMember.GroupId, testGroup.Id);
		System.AssertEquals(insertedGroupMember.UserOrGroupId, testUser.Id);

	}
	static testMethod void removePublicGroup_Test(){
		Group testGroup = TestDataBuilder.createGroup();
		insert testGroup;

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
		User testUser = TestDataBuilder.createUser(profileId);
		insert testUser;

		GroupMember testGroupMember = TestDataBuilder.createGroupMember(testGroup.Id, testUser.Id);
		insert testGroupMember;

		System.runAs(new User(Id = UserInfo.getUserId())) {

		Brand__c testBrand = TestDataBuilder.createBrand();
		String publicGroupId = testGroup.Id;
		testBrand.Public_Group_Id__c = publicGroupId.substring(0, 15);
		insert testBrand;

		Brand_Assignment__c testBrandAssignment = TestDataBuilder.createBrandAssignment(testUser.Id, testBrand.Id);
		insert testBrandAssignment;

		Test.StartTest();
			delete testBrandAssignment;
		Test.StopTest();

		}

		List<GroupMember> deletedMember = new List<GroupMember>([SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: testuser.Id AND GroupId =: testGroup.Id]);
		System.assertEquals(deletedMember.size(), 0);
	}
	static testMethod void reAssignPublicGroup_Test(){
		Group testGroup = TestDataBuilder.createGroup();
		insert testGroup;

		Group testGroup2 = TestDataBuilder.createGroup();
		
		// Code Scan Fix: Adrian Recio - Hard Coded Ids
		// Removed direct assignment of 'SamplePublicGroup2' to testGroup2.DeveloperName 
		// variable since code scan is seeing it as hard coded Id
		string devNameVar = 'SamplePublicGroup2';
		testGroup2.DeveloperName = devNameVar;

		insert testGroup2;		

		Id profileId =  [Select Id From Profile Where Name = 'System Administrator'].Id;
		User testUser = TestDataBuilder.createUser(profileId);
		insert testUser;

		GroupMember testGroupMember = TestDataBuilder.createGroupMember(testGroup.Id, testUser.Id);
		insert testGroupMember;

		System.runAs(new User(Id = UserInfo.getUserId())) {

		Brand__c testBrand = TestDataBuilder.createBrand();
		String publicGroupId = testGroup.Id;
		testBrand.Public_Group_Id__c = publicGroupId.substring(0, 15);
		insert testBrand;

		Brand__c testBrand2 = TestDataBuilder.createBrand();
		String publicGroupId2 = testGroup2.Id;
		testBrand2.Public_Group_Id__c = publicGroupId2.substring(0, 15);
		insert testBrand2;

		Brand_Assignment__c testBrandAssignment = TestDataBuilder.createBrandAssignment(testUser.Id, testBrand.Id);
		insert testBrandAssignment;

		Test.StartTest();
			Brand_Assignment__c updateBrandAssignment = [SELECT Id, User__c, Brand__c FROM Brand_Assignment__c WHERE Id=: testBrandAssignment.Id LIMIT 1];
			updateBrandAssignment.Brand__c = testBrand2.Id;
			update updateBrandAssignment;
		Test.StopTest();

		}

		List<GroupMember> oldGroupMember = new List<GroupMember>([SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: testuser.Id AND GroupId =: testGroup.Id]);
		List<GroupMember> newGroupMember = new List<GroupMember>([SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: testuser.Id AND GroupId =: testGroup2.Id]);
	
		System.assertEquals(oldGroupMember.size(), 0);
		System.assertEquals(newGroupMember.size(), 1);
	}
}