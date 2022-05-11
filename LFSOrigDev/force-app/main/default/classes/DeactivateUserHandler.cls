/**
 * @Description: Class to deactivate users
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 13-07-2015
 * @History:       
    =====================================================================
       13-07-2015: Created. - Davey Yu
    =====================================================================
**/
public with sharing class DeactivateUserHandler{
    /*  Description: Generic method to create queries as query strings.
     *  Author: Fahad Akhtar
     *  Date Created: 06-03-2015
     *  Input: list<Application>
     *  Return:  
     */	
	public static void DeactivateUserHandler(List<Application__c> lst_App){
		List<Application__c> lst_NotSubmittedApplicaitonsToDelete =  new List<Application__c>();
		List<Application__c> lst_ApplicationToProcess = new List<Application__c>();
		List<String> lst_Username = new List<String>();
		List<Applicant__c> lst_applicantUnsubmitted = new List<Applicant__c>();
		List<Applicant__c> lst_applicantSubmitted = new List<Applicant__c>();
		Set<Id> newApplicationIds = new Set<Id>();
		Set<Id> processApplicationIds = new Set<Id>();

		Data_Perge_Settings__c deactivateUser = Data_Perge_Settings__c.getValues('Deactivate User');

		Application__c app;
		//Seprate not submitted record and delete
		for(Sobject a : lst_App){
			app = (Application__c)a;
			
			//Check if the application is not submitted and delete application and its data.
			if(app.Status__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
				for(Applicant__c a1: app.Applicant__r){
					lst_applicantUnsubmitted.add(a1);	
				}		
			}
			
			//Check if the applicattion is submmited and has been inactive for a long time.
			if(app.Status__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
				for(Applicant__c a2: app.Applicant__r){
					lst_applicantSubmitted.add(a2);
				}
			}
		}
		
		//Deactivate users for unsubmitted applications
		if(lst_applicantUnsubmitted.size() > 0){
			deactivateUsers(retrieveUsersByCreatedId(lst_applicantUnsubmitted), true);
		}

		//Deactivate users related to submitted apps
		if(lst_applicantSubmitted.size() > 0){
			deactivateUsers(retrieveUsersByPersonAccount(lst_applicantSubmitted), false);
		}


	}
	
    /*  Description: validate if user has pending applications
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: list<Application>
     *  Return: List<Id>
     */	
	public static List<String> retrieveUsersByCreatedId(List<Applicant__c> applicantList){
		List<String> lst_UserName = new List<String>();
		List<String> lst_UserNameForDeactivate = new List<String>();
		
		for(Applicant__c applicant : applicantList){
			lst_UserName.add(applicant.createdById);
		}
		
		//validate if user has pending application
		Map<String, String> lst_UsernameExisting = new Map<String, String>();
		for(Applicant__c apl: [SELECT Email_Address__c, CreatedById FROM Applicant__c WHERE Application__r.Status__c != 'New' AND createdById IN: lst_Username]){
			lst_UsernameExisting.put(apl.CreatedById, apl.CreatedById);
		}

		//Deactivate users related to submitted and non submitted apps.
		if(lst_UserName.size() > 0 ){
			for(String s: lst_UserName){
				//check if there is an existing 
				//if(!lst_UsernameExisting.containsKey(s)){
					lst_UserNameForDeactivate.add(s);			
				//}
			}
		}
		return lst_UserNameForDeactivate;
	}

	/*  Description: validate if user has pending applications
     *  Author: Michael Lasala
     *  Date Created: 13-07-2015
     *  Input: list<Application>
     *  Return: List<String>
     */	
	public static List<String> retrieveUsersByPersonAccount(List<Applicant__c> applicantList){
		List<String> lst_UserName = new List<String>();
		List<String> lst_UserNameForDeactivateSub = new List<String>();
		
		for(Applicant__c applicant : applicantList){
			lst_UserName.add(applicant.Account__r.PersonContactId);
		}
		
		//validate if user has pending application
		Map<String, String> lst_UsernameExisting = new Map<String, String>();
		for(Applicant__c apl: [SELECT Account__r.PersonContactId, Email_Address__c FROM Applicant__c WHERE Application__r.Status__c != 'New' AND Account__r.PersonContactId IN: lst_Username]){
			lst_UsernameExisting.put(apl.Account__r.PersonContactId, apl.Account__r.PersonContactId);
		}
		system.debug('lst_Username: '+lst_UsernameExisting.size());
		
		//Deactivate users related to submitted and non submitted apps.
		if(lst_UserName.size() > 0 ){
			for(String s: lst_UserName){
				//check if there is an existing 
				//if(!lst_UsernameExisting.containsKey(s)){
					lst_UserNameForDeactivateSub.add(s);			
				//}
			}
		}
		return lst_UserNameForDeactivateSub;
	}

    /*  Description: Deactivate all the users with the email supplied for community users only
     *  Author: Fahad Akhtar
     *  Date Created: 10-03-2015
     *  Input: list<String>
     *  Return:  
     */	
	public static void deactivateUsers(List<String> lst_users, Boolean isNewUser){
		List<user> lst_user = new List<User>();

		if(isNewUser){
			lst_user = [SELECT id, name, Profile.UserLicense.Name
						FROM user WHERE Id IN: lst_users
						AND isactive = true
						AND Profile.UserLicense.Name = 'Customer Community Login'];
		} else {
			lst_user = [SELECT id, name, Profile.UserLicense.Name
						FROM user WHERE ContactId IN: lst_users
						AND isactive = true
						AND Profile.UserLicense.Name = 'Customer Community Login'];
		}
		system.debug('user list deactivated: '+lst_user.size());
		for(user u : lst_user){
			u.isactive = false;
		}

		update lst_user;
	}


	
}