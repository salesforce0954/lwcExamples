/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: November 22, 2013
Description: Trigger for watching Applicant CLV
*/
trigger ApplicantCLVTrigger on Applicant_CLV__c (before insert, before update, after insert) {
    
    //BEGIN MLASALA: 27-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    if(trigger.isInsert || 
       trigger.isUpdate){
        
        if(trigger.isBefore){
            
            List<Applicant_CLV__c> applicantCLVList = new List<Applicant_CLV__c>();
            
            for(Applicant_CLV__c ac: trigger.new){
                
                // Only process records which has an external id value
                if(ac.Appliction_CLV_Code__c != null){
					applicantCLVList.add(ac);
				}
            }
            
            if(!applicantCLVList.isEmpty()){
                
                // Process records
                ApplicantCLVTriggerHandler.validateRecord(applicantCLVList);
            }
        }
        
        if(trigger.isAfter && 
           trigger.isInsert){
               
            ApplicantCLVTriggerHandler.updateApplicantSearch(trigger.new);
        }
        //END MLASALA: 27-NOV-15 PMIHM-2214 SF AND ACTIVATE TO PERSIST MATCHES AND SUSPECTS
    }
}