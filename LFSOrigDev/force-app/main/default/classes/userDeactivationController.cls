/**
 * @Description: Class that shows all user subject for deactivation
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 13-07-2015
 * @History:
    =====================================================================
       13-07-2015: Created. - Davey Yu
       19-08-2015: PMIHM 1922 - Customer Login Fix for Abandoned Status - DY
    =====================================================================
**/
public with sharing class userDeactivationController {
	public List<Applicant__c> lst_applicantSubmitted {get;set;}
	String auRegion = GEN_OriginationsConstants.AU_REGION;
    String nzRegion = GEN_OriginationsConstants.NZ_REGION;
    String newAppStatus = GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW;

    public List<User> users90DaysNZ {get;set;}
    public List<User> users90DaysAU {get;set;}
    public List<User> users30DaysNZ {get;set;}
    public List<User> users30DaysAU {get;set;}
    public List<User> users7Days {get;set;}

    public String submittedAU {get;set;}
    public String submittedNZ {get;set;}
    public String unsubmittedAU {get;set;}
    public String unsubmittedNZ {get;set;}
    public String customerLogin	{get;set;}


	public userDeactivationController() {
		lst_applicantSubmitted = new List<Applicant__c>();
		users90DaysNZ = new List<User>();
		users90DaysAU = new List<User>();
		users30DaysNZ = new List<User>();
		users30DaysAU = new List<User>();
		
		submittedAU = null;
		submittedNZ = null;
		unsubmittedAU = null;
		unsubmittedNZ = null;
		customerLogin = null;

		submittedAU = ApexPages.currentPage().getParameters().get('submittedAU');
		submittedNZ = ApexPages.currentPage().getParameters().get('submittedNZ');
		unsubmittedAU = ApexPages.currentPage().getParameters().get('unsubmittedAU');
		unsubmittedNZ = ApexPages.currentPage().getParameters().get('unsubmittedNZ');
		customerLogin = ApexPages.currentPage().getParameters().get('customerLogin');
		if(submittedNZ != null)
			users90DaysNZ = getUsers('NZ', 'New', 90);
		if(submittedAU != null)
			users90DaysAU = getUsers('AU', 'New', 90);
		if(unsubmittedNZ != null)
			users30DaysNZ = getUsersUnsubmitted('NZ', 'New', 30);
		if(unsubmittedAU != null)
			users30DaysAU = getUsersUnsubmitted('AU', 'New', 30);
		if(customerLogin != null)
			users7Days = getUsers7days(7);

	}

	/*  Description: return users for deactivation related to submitted application subject for purging 
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: region, status and number of days
     *  Return: List<User> 
     */
	public List<User> getUsers(String region, String status, Integer days){
		List<User> userd = new List<User>();
		List<Application__c> applicationList = new List<Application__c>();
		List<Applicant__c> applicantList = new List<Applicant__c>();
		
		if(!Test.isRunningTest()){
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE LastModifiedDate < LAST_N_DAYS:90 AND Status__c !=: status AND Brand_Lookup__r.Country__c =: region];
		}else{
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE Status__c !=: status];
		}


		system.debug('application list size: '+applicationList.size());
		if(applicationList.size() > 0){
			for(application__c app: applicationList){
				if(app.Status__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
					system.debug('applicant loop: '+app.Applicant__r);
					for(Applicant__c a2: app.Applicant__r){
						
						applicantList.add(a2);
					}
				}
			}
		}
		system.debug('applicant list size: '+applicantList.size());
		if(applicantList.size() > 0){
			userd = deactivateUsers(retrieveUsersByPersonAccount(applicantList), false);
		}
		system.debug('user size: '+userd.size());
		return userd;
	}

	/*  Description: return users for deactivation related to finalized, closed and 
		accepted application subject for purging 
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: days
     *  Return: List<User> 
     */
	public List<User> getUsers7days(Integer days){
		List<User> userd = new List<User>();
		Set<String> appStatus = new Set<String>();
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_CLOSED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_DECLINED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_FINALIZED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_ABANDONED);


		List<Application__c> applicationList = new List<Application__c>();
		List<Applicant__c> applicantList = new List<Applicant__c>();
		if(!Test.isRunningTest()){
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE LastModifiedDate < LAST_N_DAYS:7 AND Status__c IN: appStatus];
		}else{
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE Status__c IN: appStatus];
		}

		if(applicationList.size() > 0){
			for(application__c app: applicationList){
				if(app.Status__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
					for(Applicant__c a2: app.Applicant__r){
						applicantList.add(a2);
					}
				}
			}
		}

		if(applicantList.size() > 0){
			userd = deactivateUsers(retrieveUsersByPersonAccount(applicantList), false);
		}
		return userd;
	}

	/*  Description: return users for deactivation related to unsubmitted application subject for purging 
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: region, status and number of days
     *  Return: List<User> 
     */
	public List<User> getUsersUnsubmitted(String region, String status, Integer days){
		
		List<User> userd = new List<User>();
		List<Application__c> applicationList = new List<Application__c>();
		List<Applicant__c> applicantList = new List<Applicant__c>();
		if(!Test.isRunningTest()){
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE LastModifiedDate < LAST_N_DAYS:30 AND Status__c =: status AND Brand_Lookup__r.Country__c =: region];
		}else{
			applicationList = [SELECT id, Status__c, Brand_Lookup__r.Country__c, LastModifiedDate, 
			(SELECT id, Email_Address__c, CreatedById, Account__r.PersonContactId, Account__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),
			(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),
			(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
			(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),
			(SELECT id,Title__c FROM Related_Documents__r),
			(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r) 
			FROM Application__c WHERE Status__c =: status AND Brand_Lookup__r.Country__c =: region];
		}
		system.debug('application list size: '+applicationList.size());
		if(applicationList.size() > 0){
			system.debug('application list size: '+applicationList.size());
			for(application__c app: applicationList){
				if(app.Status__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
					for(Applicant__c a2: app.Applicant__r){
						applicantList.add(a2);
					}
				}
			}
		}
		
		if(applicantList.size() > 0){
			userd = deactivateUsers(retrieveUsersByCreatedId(applicantList), true);
		}
		
		return userd;
	}

	/*  Description: Validate users by createdid 
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: List<Applicant>
     *  Return: List<User> 
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
				lst_UserNameForDeactivate.add(s);			
			}
		}
		return lst_UserNameForDeactivate;
	}

	/*  Description: Validate users by personaccount 
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: List<Applicant>
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
				lst_UserNameForDeactivateSub.add(s);			
			}
		}
		return lst_UserNameForDeactivateSub;
	}

	/*  Description: Return final list of users for deactivation
     *  Author: Davey Yu
     *  Date Created: 13-07-2015
     *  Input: List<Applicant>, isNewUser
     *  Return: List<user> 
     */
	public List<User> deactivateUsers(List<String> lst_users, Boolean isNewUser){
		List<user> lst_user = new List<User>();
		system.debug('lst_users: '+lst_users.size());
		if(isNewUser){
			lst_user = [SELECT id, name, username, Email, Profile.UserLicense.Name
						FROM user WHERE Id IN: lst_users
						AND isactive = true
						AND Profile.UserLicense.Name = 'Customer Community Login'];
		} else {
			lst_user = [SELECT id, name, username, Email, Profile.UserLicense.Name
						FROM user WHERE ContactId IN: lst_users
						AND isactive = true
						AND Profile.UserLicense.Name = 'Customer Community Login'];
		}
		
		return lst_user;
	}

}