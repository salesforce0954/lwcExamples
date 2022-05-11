/**
* @author Original: Dandreb Crisolog Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Test class for BranchSetupController Class
*/
@isTest(seeAllData = false)
    private class BranchSetupControllerTest
    {
        static testMethod void case1(){
        
            //create District
            District__c district = new District__c();
            district.Name = 'Test District';
            insert district;
            
            District__c currentDistrict = [SELECT Id,Name FROM District__c WHERE Id=: district.Id];
            system.assertEquals(district.Id,currentDistrict.Id);
            
            //create branch
            Branch__c branch = new Branch__c();
            branch.Name = 'Test Branch';
            branch.District__c = district.Id;
            branch.Branch_Id__c = '123';
            insert branch;
            
            Branch__c currentBranch = [SELECT Id,Name FROM Branch__c WHERE Id=: branch.Id];
            system.assertEquals(branch.Id,currentBranch.Id);
            
            
            //create branch assignment
            Branch_Assignment__c branchAssignment = new Branch_Assignment__c();
            branchAssignment.Branch__c = branch.Id;
            branchAssignment.User__c = UserInfo.getUserId();
            insert branchAssignment;
            
            Branch_Assignment__c currentBranchAssignment = [SELECT ID,Name FROM Branch_Assignment__c WHERE Id=: branchAssignment.Id];
            system.assertEquals(branchAssignment.Id,currentBranchAssignment.Id);
            
            BranchSetupController Controller = new BranchSetupController();
            List<Branch_Assignment__c> branchList = new List<Branch_Assignment__c>([Select Branch__c from Branch_Assignment__c WHERE User__c =: UserInfo.getUserId() ORDER BY Branch__c]);
            
            
        }
        static testMethod void case2(){
        
            //create District
            District__c district = new District__c();
            district.Name = 'Test District';
            insert district;
            
            District__c currentDistrict = [SELECT Id,Name FROM District__c WHERE Id=: district.Id];
            system.assertEquals(district.Id,currentDistrict.Id);
            
            //create branch
            Branch__c branch = new Branch__c();
            branch.Name = 'Test Branch';
            branch.District__c = district.Id;
            branch.Branch_ID__c = '123';
            insert branch;
            
            Branch__c currentBranch = [SELECT Id,Name FROM Branch__c WHERE Id=: branch.Id];
            system.assertEquals(branch.Id,currentBranch.Id);
            
            
            //create branch assignment
            Branch_Assignment__c branchAssignment = new Branch_Assignment__c();
            branchAssignment.Branch__c = branch.Id;
            branchAssignment.User__c = UserInfo.getUserId();
            insert branchAssignment;
            
            Branch_Assignment__c currentBranchAssignment = [SELECT ID,Name FROM Branch_Assignment__c WHERE Id=: branchAssignment.Id];
            system.assertEquals(branchAssignment.Id,currentBranchAssignment.Id);
            
            BranchSetupController Controller = new BranchSetupController();
    
            Controller.districtId = district.Id;
            Controller.setBranchList();
        
        }
        static testMethod void case3(){
        
            //create District
            District__c district = new District__c();
            district.Name = 'Test District';
            insert district;
            
            District__c currentDistrict = [SELECT Id,Name FROM District__c WHERE Id=: district.Id];
            system.assertEquals(district.Id,currentDistrict.Id);
            
            //create branch
            Branch__c branch = new Branch__c();
            branch.Name = 'Test Branch';
            branch.District__c = district.Id;
            branch.Branch_ID__c = '123';
            insert branch;
            
            Branch__c currentBranch = [SELECT Id,Name FROM Branch__c WHERE Id=: branch.Id];
            system.assertEquals(branch.Id,currentBranch.Id);
            
            
            //create branch assignment
            Branch_Assignment__c branchAssignment = new Branch_Assignment__c();
            branchAssignment.Branch__c = branch.Id;
            branchAssignment.User__c = UserInfo.getUserId();
            insert branchAssignment;
            
            Branch_Assignment__c currentBranchAssignment = [SELECT ID,Name FROM Branch_Assignment__c WHERE Id=: branchAssignment.Id];
            system.assertEquals(branchAssignment.Id,currentBranchAssignment.Id);
            
            BranchSetupController Controller = new BranchSetupController();
    
            Controller.districtId = district.Id;
            Controller.getDistricts();
        
        }
        static testMethod void case4(){
        
            //create District
            District__c district = new District__c();
            district.Name = 'Test District';
            insert district;
        
            District__c currentDistrict = [SELECT Id,Name FROM District__c WHERE Id=: district.Id];
            system.assertEquals(district.Id,currentDistrict.Id);
        
            //create branch
            Branch__c branch = new Branch__c();
            branch.Name = 'Test Branch';
            branch.District__c = district.Id;
            branch.Branch_ID__c = '123';
            insert branch;
        
            Branch__c currentBranch = [SELECT Id,Name FROM Branch__c WHERE Id=: branch.Id];
            system.assertEquals(branch.Id,currentBranch.Id);

            //create branch assignment
            Branch_Assignment__c branchAssignment = new Branch_Assignment__c();
            branchAssignment.Branch__c = branch.Id;
            branchAssignment.User__c = UserInfo.getUserId();
            insert branchAssignment;
        
            Branch_Assignment__c currentBranchAssignment = [SELECT ID,Name FROM Branch_Assignment__c WHERE Id=: branchAssignment.Id];
            system.assertEquals(branchAssignment.Id,currentBranchAssignment.Id);
        
            BranchSetupController Controller = new BranchSetupController();

            Controller.districtId = district.Id;
            Controller.saveBranchAssignment();
        
        }
        static testMethod void case5(){
            BranchSetupController Controller = new BranchSetupController();
            Controller.districtId = null;
            Controller.saveBranchAssignment();

            System.assertEquals(null, controller.districtId);
        }
        static testMethod void case6(){
                Profile profile = [SELECT Id, Name from Profile WHERE Name = 'System Administrator'];
        
                User users = new User();
                users.FirstName = 'Test';
                users.LastName = 'User';
                users.Alias = 'Testu';
                users.Email = 'TestEmail@yahoo.com';
                users.Username = 'Dummy@cloudsherpas.com';
                users.CommunityNickname = 'Test Nickname';
                users.ProfileId = profile.Id;
                users.LocaleSidKey = 'en_US';
                users.EmailEncodingKey ='UTF-8';
                users.LanguageLocaleKey = 'en_US';
                users.TimeZoneSidKey = 'America/Los_Angeles';
                users.SSO_Number__c = '1010';
                insert users;
            //create District
            District__c district = new District__c();
            district.Name = 'Test District';
            insert district;
            
            District__c currentDistrict = [SELECT Id,Name FROM District__c WHERE Id=: district.Id];
            system.assertEquals(district.Id,currentDistrict.Id);
            
            //create branch
            Branch__c branch = new Branch__c();
            branch.Name = 'Test Branch';
            branch.District__c = district.Id;
            branch.Branch_ID__c = '123';
            insert branch;
            
            Branch__c currentBranch = [SELECT Id,Name FROM Branch__c WHERE Id=: branch.Id];
            system.assertEquals(branch.Id,currentBranch.Id);
            
            
            //create branch assignment
            Branch_Assignment__c branchAssignment = new Branch_Assignment__c();
            branchAssignment.Branch__c = branch.Id;
            branchAssignment.User__c = users.Id;
            insert branchAssignment;
            
            Branch_Assignment__c currentBranchAssignment = [SELECT ID,Name FROM Branch_Assignment__c WHERE Id=: branchAssignment.Id];
            system.assertEquals(branchAssignment.Id,currentBranchAssignment.Id);
            String RecTypeId= [select Name from RecordType where (Name = 'Branch Leads') and (SobjectType='Branch_Assignment__c') LIMIT 1].Name;
            BranchSetupController Controller = new BranchSetupController();
            Controller.getBranchType(RecTypeId);
        }
    }