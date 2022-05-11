/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: February 19, 2014
Description: Populates the Selected ICBS Customer Number on the Applicant Account 
*/
public with sharing class ApplicantAccountCustomerTriggerHandler {
	List<Applicant_Account__c> appAccListUpd = new List<Applicant_Account__c>();
	Set<String> appInv = new Set<String>();
	Set<Id> appApplicants = new Set<Id>();
	Set<Id> appAcc = new Set<Id>();
	Map<String, String> accNumIdenMap = new Map<String, String>();	
	Map<String, boolean> mapSolicitFlag = new Map<String, boolean>();

	public void updateSelectedICBS(List<Applicant_Account_Customer__c> appAccCustList){

		//Get All Customer Identifier and Account Number
		for(Applicant_Account_Customer__c a : appAccCustList){
			appInv.add(a.Customer_Number__c);
			appApplicants.add(a.Applicant__c);
			accNumIdenMap.put(a.Account_Number__c + '-' + a.Applicant__c, a.Customer_Number__c);
			mapSolicitFlag.put(a.Account_Number__c + '-' + a.Applicant__c, a.solicitFlag__c);
		}

		//Gets the related records, Applicant Involved party then Appicant Account
		List<Applicant_Account_Involved_Party__c> appInvList = [SELECT Applicant_Account__c, 
																	   Customer_Identifier__c, 
																	   Id ,solicitFlag__c
																FROM   Applicant_Account_Involved_Party__c 
																WHERE  Customer_Identifier__c IN :appInv 
																 AND   Applicant_Account__r.Applicant_CLV__r.Applicant__c IN: appApplicants];
		for(Applicant_Account_Involved_Party__c a : appInvList){
			appAcc.add(a.Applicant_Account__c);
		}

		List<Applicant_Account__c> appAccList = [SELECT Id, 
														Account_Number__c, 
														Selected_ICBS_Customer_Number__c,
														Applicant_CLV__r.Applicant__c ,solicitFlag__c
												 FROM   Applicant_Account__c 
												 WHERE  Id IN :appAcc];
		for(Applicant_Account__c a : appAccList){
			a.Selected_ICBS_Customer_Number__c = accNumIdenMap.get(a.Account_Number__c + '-' + a.Applicant_CLV__r.Applicant__c);
			if (mapSolicitFlag.get(a.Account_Number__c + '-' + a.Applicant_CLV__r.Applicant__c) != null ) 
			{
				a.solicitFlag__c = mapSolicitFlag.get(a.Account_Number__c + '-' + a.Applicant_CLV__r.Applicant__c);
			}
			appAccListUpd.add(a);
		}

		try{
			update appAccListUpd;
		}
		catch(Exception e){
			ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'copyICBSCustomerNumber', 'APP_AccountDataExt', 'Class');
		}
	}
}