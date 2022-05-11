@isTest
private class HelperClassTest {    
    public static testMethod void testHelperClass(){  
        //Preparing Profile,Role and user data
        Profile p = [select id,name from profile where name='System Administrator']; 
        UserRole Urole = [SELECT  id,Name FROM UserRole WHERE name='System Administrator'];        
        User u = TestingUtils.createUsers(1,p.id, Urole.id);                    
        insert u;  
        List<User> userLIst = TestingUtils.createUsers(1,p.Name, Urole.Name,'USD');                    
        insert userLIst; 
         
        LIST<recordType> rType = [SELECT id FROM RecordType];
        list<General_Properties__c> generalproperties = new list<General_Properties__c>(); 
        
        system.runAs(userLIst[0]){
	        Audit_Tracker__c myAuditRecords = new Audit_Tracker__c(Field_Name__c = 'Name',Object_Name__c = 'Account');        	   
		    insert myAuditRecords;
        }         
        
        System.runAs(u){
        	List<Account> Acc = TestingUtils.CreateAccount(1);
        	//List<Account> AccNew = TestingUtils.CreateAccount(1);
        	//AccNew[0].Name ='testing';
        	//AccNew[0].comments = 'test';
	        Integer ctr = 1;
            for(Account a : Acc)
            {
               a.Consumer_Accreditation_Comments_cons__c = 'test Comment '+ ctr;
               ctr++;
            }
	        insert Acc;
	        //insert AccNew;
	        acc[0].Name = 'Audit Tracker';
	        acc[0].Consumer_Accreditation_cons__c =false;
	        acc[0].Primary_Business_Unit__c = 'Corporate Finance Bank';
	        update acc[0];
	        Map<id,Account> AccMap = new Map<id,Account>();    
            AccMap.put(Acc[0].id,Acc[0]);
            
            profile prf; 
            User u1;
            UserRole r1;
            recordType rType1;
            boolean permissionFlag;
            boolean IsProfileExcluded;
            Test.StartTest();   
            //Getting the profile info from profile id    
            prf = HelperClass.getProfileInfo(String.ValueOf(p.Id));
            //Asserting rerieved profile is same
            System.assertEquals(prf.id,p.Id);
            u1 = HelperClass.getuserInfo(u.id);
            //Asserting rerieved user is same
            System.assertEquals(u1.id,u.Id);
            r1= HelperClass.getRoleName(Urole.id);
            //Asserting rerieved role is same
            System.assertEquals(r1.id,Urole.Id);
            generalproperties = TestingUtils.CreateGeneralProperties();      
            insert generalproperties;            
            IsProfileExcluded = HelperClass.profileExcluded(p.name,generalproperties[0].Name);
            //Asserting profile excluded 
            system.assertEquals(true,IsProfileExcluded );
            Test.StopTest();
            utils.get_apex_profile();   
            
        }
    }
}