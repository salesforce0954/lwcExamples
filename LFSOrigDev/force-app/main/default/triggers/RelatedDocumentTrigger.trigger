/**
    Author: Fel Saliba Cloud Sherpas
    Created Date: March 07, 2014
    Description: Trigger for Related Document Object
**/

trigger RelatedDocumentTrigger on Related_Document__c (after insert, after update, after delete, after undelete) {

    RelatedDocumentTriggerClass handler = new RelatedDocumentTriggerClass();
    
    //create set to store the applicantIds to be passed on the handler class.
    Set<String> applicantIds = new Set<String>();
    
    //create a set of applications
    Set<String> applicationIds = new Set<String>();
    
    Set<Id> ePOIApplicationIds = new Set<Id>(); //Added by RCADAPAN for TQLQW-534 - ePOI
    
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            for(Related_Document__c rd:Trigger.new){
                //check if applicant are not empty before putting in Set, for all events.
                if(rd.Applicant__c != null){
                    applicantIds.add(rd.Applicant__c);
                    applicationIds.add(rd.Application__c);                        
                }                                 
                if(rd.Type__c == 'ePOI Statement' && (rd.GE_Document_ID__c != null && rd.GE_Document_ID__c != '')){
                    ePOIApplicationIds.add(rd.Application__c); //Added by RCADAPAN for TQLQW-534 - ePOI
                }
            }             
        }
        if(Trigger.isUpdate){
            for(Related_Document__c rd:Trigger.new){                
                
                //check if there's any changes on the below fields
                if(Trigger.oldMap.get(rd.ID).Application__c != rd.Application__c ||
                   Trigger.oldMap.get(rd.ID).Applicant__c != rd.Applicant__c ||
                   Trigger.oldMap.get(rd.ID).Status__c != rd.Status__c ||
                   Trigger.oldMap.get(rd.ID).Document_Category__c != rd.Document_Category__c){
                        applicantIds.add(rd.Applicant__c);
                        applicationIds.add(rd.Application__c);                       
                }
                
                // Added by RCADAPAN for TQLQW-534 - ePOI
                if(((Trigger.oldMap.get(rd.ID).Type__c != 'ePOI Statement' && rd.Type__c == 'ePOI Statement') ||
                    (Trigger.oldMap.get(rd.ID).Type__c == 'ePOI Statement' && rd.Type__c != 'ePOI Statement') ||
                    (Trigger.oldMap.get(rd.ID).GE_Document_ID__c != rd.GE_Document_ID__c)) &&
                    (rd.GE_Document_ID__c != null && rd.GE_Document_ID__c != '')){
                    ePOIApplicationIds.add(rd.Application__c);
                }
            }

            handler.updateApplicationStatusToDocumentsInReview(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isDelete){
            for(Related_Document__c rd:Trigger.old){
                //check if applicant are not empty before putting in Set, for all events.
                if(rd.Applicant__c != null){
                    applicantIds.add(rd.Applicant__c);
                    applicationIds.add(rd.Application__c);                      
                }
            }
        }
        //check if set has values before calling the handler method.
        if(applicantIds.size()>0){
            //call handler if applicantIds is greater than 0.
            handler.populateApplicantHasUploaded(applicantIds,applicationIds);
        }
        
        //Added by RCADAPAN for TQLQW-534 - ePOI
        if(!ePOIApplicationIds.isEmpty()){
            handler.updateApplicationPOICompletion(ePOIApplicationIds);
        }
        
        if(Trigger.isUndelete){
            AccessControlTriggerHandler act = new AccessControlTriggerHandler();
            act.blockUndelete(Trigger.new);
        }
        
    }
}