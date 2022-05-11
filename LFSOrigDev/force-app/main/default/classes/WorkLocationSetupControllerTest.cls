@isTest
/*
Author: Michael Lasala Cloud Sherpas
Created Date: 03/04/13
Description: Test Coverage for WorkLocationSetupController Class
*/
private class WorkLocationSetupControllerTest{
    
    static testMethod void testWorkLocationDistrict(){
		List<District__c> districtList = TestDataBuilder.createDistirct(1);
		insert districtList;
		
		District__c currentDistrict = [SELECT Id FROM District__c WHERE Id=: districtList[0].Id];
        system.assertEquals(districtList[0].Id, currentDistrict.Id);
        
		Test.startTest();
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.getDistricts();
        Test.stopTest();
	}
	
	static testMethod void testWorkLocationDistrictBulk(){
		List<District__c> districtList = TestDataBuilder.createDistirct(10);
		insert districtList;
		
        system.assertEquals(10, districtList.size());
        
		Test.startTest();
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.getDistricts();
        Test.stopTest();
	}
	
	static testMethod void testWorkLocationBranch(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(1);
		insert branchList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
        system.assertEquals(branchList[0].District__c, currentBranch.District__c);
		
		Test.startTest();
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.districtId = currentBranch.District__c;
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Test.stopTest();
	}
	
	static testMethod void testWorkLocationBranchBulk(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(10);
		insert branchList;

		system.assertEquals(10, branchList.size());
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[5].Id];
        system.assertEquals(branchList[5].Id, currentBranch.Id);
        system.assertEquals(branchList[5].District__c, currentBranch.District__c);
		
		Test.startTest();
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.districtId = currentBranch.District__c;
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Test.stopTest();
	}
	
	static testMethod void testWorkLocationSave(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(1);
		insert branchList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
		
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.districtId = currentBranch.District__c;
		Controller.locationId = currentBranch.Id;
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Controller.saveLocationAssignment();
	}
	
	static testMethod void testWorkLocationSaveBulk(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(10);
		insert branchList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[9].Id];
        system.assertEquals(branchList[9].Id, currentBranch.Id);
		
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.districtId = currentBranch.District__c;
		Controller.locationId = currentBranch.Id;
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Controller.saveLocationAssignment();
	}
	
	static testMethod void testWorkLocationNoDistrict(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(1);
		insert branchList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
		
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Controller.saveLocationAssignment();
	}
	
	static testMethod void testWorkLocationNoLocation(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(1);
		insert branchList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
		
		WorkLocationSetupController Controller = new WorkLocationSetupController();
		Controller.districtId = currentBranch.District__c;
		Controller.getDistricts();
		Controller.setLocationList();
		Controller.getLocations();
		Controller.saveLocationAssignment();
	}
	
	static testMethod void testWorkLocationCurrentAssignment(){
		List<Branch__c> branchList = new List<Branch__c>();
		branchList = TestDataBuilder.createBranch(1);
		insert branchList;

		List<Branch_Assignment__c> branchAssList = TestDataBuilder.createBranchAssignment(1, branchList, UserInfo.getUserId(), 'Working Location');
		insert branchAssList;
		
		Branch__c currentBranch = [SELECT Id, Name, District__c FROM Branch__c WHERE Id=: branchList[0].Id];
        system.assertEquals(branchList[0].Id, currentBranch.Id);
		
		WorkLocationSetupController Controller = new WorkLocationSetupController();
	}
}