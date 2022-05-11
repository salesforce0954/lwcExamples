/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: November 22, 2013
Description: Trigger Hander for watching Applicant CLV
*/
public class ApplicantCLVTriggerHandler {
    /**  Description: Method to populate the Status of the Applicant Search
     *  Author: Jan Mark Domingo
     *  Date Created: 11-22-13
     *  Input Parameters: Trigger.new - newly inserted Applicant CLV records
     *  Return: void
     */
    public static void updateApplicantSearch(List<Applicant_CLV__c> appCLVList){
        List<Applicant_Search__c> appSearchList = new List<Applicant_Search__c>();
        List<Applicant_Search__c> updateSearchList = new List<Applicant_Search__c>();
        Set<Id> appSearchID = new Set<Id>();
        System.debug('*** appCLVList ' + appCLVList.size());
        
        //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
		//CLV history list to be inserted
        List<Debug_Log__c> clvHistoryList = new List<Debug_Log__c>();
		
		//CLV history record type (Debug_Log__c)
        Id clvRecordTypeId = Schema.SObjectType.Debug_Log__c.getRecordTypeInfosByName().get('CLV').getRecordTypeId();
		
		//Mapping to identify parent application of each applicant
        Map<Id, Id> applicationApplicantMap = new Map<Id, Id>();
        //END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        
        if(appCLVList.size() > 0){
            for(Applicant_CLV__c a : appCLVList){
                appSearchID.add(a.Applicant_Search__c);
                
                //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
                if(a.From_Integration__c){
                    
                    //Get applicant ids to be used for query
                    applicationApplicantMap.put(a.Applicant__c, null);
                }
                //END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
            }
        }
        
        //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        //Query applicants to get parent application
        List<Applicant__c> applicantList = [SELECT Id, Application__c FROM Applicant__c WHERE Id IN: applicationApplicantMap.keySet()];
        if(!applicantList.isEmpty()){
            for(Applicant__c a: applicantList){
				
                //Assign application as value for mapping
                applicationApplicantMap.put(a.Id, a.Application__c);
            }
        }
        
        if(!appCLVList.isEmpty()){
            for(Applicant_CLV__c a : appCLVList){
				
                if(a.Appliction_CLV_Code__c != null){
				
                    //Identify external id
                    String externalIdPrefix = a.Appliction_CLV_Code__c.substring(0, 3);
                    
                    //If value starts with 300 or 400, it was sent by Activate.
                    //Else, the search was initiated in Salesforce
                    if(externalIdPrefix == '300' || 
                       externalIdPrefix == '400'){
                        
                        //Create CLV search history record
                        Debug_Log__c clvHistory = new Debug_Log__c();
                        
                        clvHistory.RecordTypeId = clvRecordTypeId;
                        clvHistory.Applicant_CLV__c = a.Id;
                        clvHistory.Application__c = applicationApplicantMap.get(a.Applicant__c);
                        clvHistory.New_Value__c = String.valueOf(a.User_Match_Flag__c);
                        clvHistory.Previous_Value__c = 'Activate';
                        clvHistoryList.add(clvHistory);
                    }
				}
            }
        }
        //END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        
        appSearchList = [Select Id, Status__c from Applicant_Search__c where Id IN :appSearchID];
        if(appSearchList.size() > 0){           
            for(Applicant_Search__c appSe : appSearchList){
                appSe.Status__c = 'Response Received';
                updateSearchList.add(appSe);
            }   
        }
            
        try{
            update updateSearchList;
            System.debug('###updateSearchList ' +  updateSearchList);
        }
        catch(DmlException e){
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'updateApplicantSearch', 'ApplicantCLVTriggerHandler', 'Class', null);
        }
        
        //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
        //Insert CLV search history
        if(!clvHistoryList.isEmpty()){
            try{
                insert clvHistoryList;
            }
            catch(DmlException e){
                ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'updateApplicantSearch', 'ApplicantCLVTriggerHandler', 'Class', null);
            }
        }
		//END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    }
    
    //BEGIN MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    /*  Description: Validate record to check whether CLV recordds came from Activate search
     *  Author: Mike Lasala
     *  Date Created: 20-NOV-2015
     *  Input Parameters: List<Applicant_CLV__c>
     *  Return: Void
     */
    public static void validateRecord(List<Applicant_CLV__c> appCLVList){
                
        // Used for applicant flushing
        Set<Id> applicantIds = new Set<Id>();
        
        for(Applicant_CLV__c ac: appCLVList){
            
            //Add applicant Ids to be used for query
            applicantIds.add(ac.Applicant__c);
			
			//Identify external id
			String externalIdPrefix = ac.Appliction_CLV_Code__c.substring(0, 3);
			
			//If value starts with 300 or 400, it was sent by Activate.
			//Else, the search was initiated in Salesforce
			if(externalIdPrefix == '300' || 
			   externalIdPrefix == '400'){
				
				//Set flag
				ac.From_Integration__c = true;
		    }
        }
        
        //Retrieve applicants
        List<Applicant__c> applicantList = [SELECT Id, 
                                                   Is_Primary_Applicant__c,
                                                   Application__r.Response_Code__c,
                                                   Application__c
                                            FROM   Applicant__c
                                            WHERE  Id IN: applicantIds];
        
        if(!applicantList.isEmpty()){
            
            //Used for identifying whether CLV is for applicant 1 or 2
            Map<Id, String> applicantBucket = new Map<Id, String>();
            
            //Clear set to be reused for querying CLV records
            applicantIds.clear();
            
            for(Applicant__c a: applicantList){
                
                //Process records if latest application response is not Possible Match
                if(a.Application__r.Response_Code__c != 'MAR'){
                    
                    //Set applicant mapping based on Is_Primary_Applicant__c flag
                    if(a.Is_Primary_Applicant__c){
                        applicantBucket.put(a.Id, '1');
                    } else {
                        applicantBucket.put(a.Id, '2');
                    }
                    
                } else {    //Else, add applicant ids to be used for flushing
                    
                    applicantIds.add(a.Id);
                }
            }
            
            if(!applicantBucket.keySet().isEmpty()){
                
                //Iterate over CLV list again to assign applicant bucket (1 or 2)
                for(Applicant_CLV__c ac: appCLVList){
                    ac.Applicant_Bucket__c = applicantBucket.get(ac.Applicant__c);
                }
            }
                
            if(!applicantIds.isEmpty()){
                
                //Retrieve CLV records to be flushed
                List<Applicant_CLV__c> flushList = [SELECT Id FROM Applicant_CLV__c WHERE Applicant__c IN: applicantIds];
                
                if(!flushList.isEmpty()){
                    
                    for(Applicant_CLV__c ac: flushList){
                        
                        //Unlink applicant
                        ac.Applicant__c = null;
                    }
                }
        
                //Update CLV records
                try{
                    update flushList;
                }
                catch(DmlException e){
                    ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'validateRecord', 'ApplicantCLVTriggerHandler', 'Class', null);
                }
                
                //Iterate over CLV list once again to identify if 
                //records about to be inserted should be flushed
                for(Applicant_CLV__c ac: appCLVList){
                    
                    if(applicantIds.contains(ac.Applicant__c)){
                        
                        //Unlink record from applicant
                        ac.Applicant__c = null;
                        ac.From_Integration__c = false;
                    }
                }
            }
        }
    }
    //END MLASALA: 20-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
}