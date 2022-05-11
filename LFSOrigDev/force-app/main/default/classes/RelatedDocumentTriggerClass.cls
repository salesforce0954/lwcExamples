/*
Author: Fel Saliba Cloud Sherpas
Created Date: March 07, 2014
Description: Class to handle RelatedDocumentTrigger Logic
* @History:
   =====================================================================
       03-07-14: Created - Fel
   =====================================================================
*/

public with sharing class RelatedDocumentTriggerClass {


    public void populateApplicantHasUploaded(Set<String> applicantIds,Set<String> applicationIds){
        List<Related_Document__c> poiDocuments = new List<Related_Document__c>();
        //query on related document which Document_Category__c = POI
        poiDocuments = [SELECT Id, Applicant__c, Status__c, Document_Category__c
                        FROM Related_Document__c 
                        WHERE Applicant__c IN: applicantIds
                        AND Application__c IN: applicationIds
                        AND Document_Category__c =: 'POI'
                        AND Status__c =: GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_RECEIVED];
         
        //make set of applicants               
        Set<String> applicantsWithPOI = new Set<String>();        
        if(!poiDocuments.isEmpty()){
            for(Related_Document__c rd: poiDocuments){
                //add applicant Id to the set
                applicantsWithPOI.add(rd.Applicant__c);
            }
        }
        
        //query all applicants in the trigger.new
        List<Applicant__c> allApplicants = new List<Applicant__c>();
        allApplicants = [Select Id, Has_Uploaded__c 
                        FROM Applicant__c 
                        WHERE ID IN: applicantIds];
                        
        if(!allApplicants.isEmpty()){
            for(Applicant__c applicant: allApplicants){
                //check if the applicant Id is in the set of Applicant Ids
                if(applicantsWithPOI.contains(applicant.Id)){
                    //if yes check has uploaded checkbox
                    applicant.Has_Uploaded__c = true;
                }
                else{
                    //else set it to false
                    applicant.Has_Uploaded__c = false;
                }
            }
            try{
                //update the applicants
                update allApplicants;
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RelatedDocumentTriggerHandler', 'Applicant__c', 'Class');
            }
            
        }
    }
    /*
    Author: Russell Cadapan (Accenture)
    Created Date: 13-OCT-2016
    Description: method to scan through the application's related document, if one of those has a type of ePOI Statement, set the application flag (Is_e_POI_Completed__c) to true
    * @History:
       =====================================================================
           13-OCT-2016: Created - Russell Cadapan
       =====================================================================
    */
    public void updateApplicationPOICompletion(Set<Id> applicationIds){
        // get all applications and its related documents and store it in a list
        List<Application__c> applicationsForUpdate = [SELECT Id, Is_e_POI_Completed__c, (SELECT Id, Type__c FROM Related_Documents__r) FROM Application__c WHERE Id IN: applicationIds];
        
        // iterate through the applications
        for(Application__c app: applicationsForUpdate){
            // default the flag to false
            app.Is_e_POI_Completed__c = false;
            // then each application, scan through the related document
            for(Related_Document__c apprd: app.Related_Documents__r){
                // if the system finds atleast one ePOI Statement document, switch the flag to true then exit the loop
                if(apprd.Type__c == 'ePOI Statement'){
                    app.Is_e_POI_Completed__c = true;
                    break;
                }
            }
        }
        
        // update the application
        try{
            update applicationsForUpdate;
        }
        catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RelatedDocumentTriggerHandler', 'Applicant__c', 'Class');
        }
    }
    /*
    Author: William Putra (VISEO)
    Created Date: 17-SEP-2021
    Description: method to update application status to 'Documents in review' if it hasn't setted upon URL gets updated by downstream system
    * @History:
       =====================================================================
           17-SEP-2021: Created - William Putra
       =====================================================================
    */
    public void updateApplicationStatusToDocumentsInReview(List<Related_Document__c> updatedRelatedDocuments, Map<Id, Related_Document__c> oldRelatedDocumentsMap) {
        Set<Id> setApplicationId = new Set<Id>();
        for(Related_Document__c rd: updatedRelatedDocuments) {
            setApplicationId.add(rd.Application__c);
        }

        //Query application
        Map<Id, Application__c> mapApplication = new Map<Id, Application__c>();
        List<Application__c> listApplication = [SELECT Id, Status__c, Documents_in_Review__c from Application__c WHERE Id IN :setApplicationId];
        for(Application__c app: listApplication) {
            mapApplication.put(app.Id, app);
        }

        List<Application__c> listUpdateApplicationStatus = new List<Application__c>();

        //Loop updated related document again
        for(Related_Document__c rd: updatedRelatedDocuments) {
            if(rd.GE_Document_ID__c != oldRelatedDocumentsMap.get(rd.Id).GE_Document_ID__c && 
            mapApplication.get(rd.Application__c).Documents_in_Review__c == false &&
            (mapApplication.get(rd.Application__c).Status__c == 'Conditionally Approved: AML' || 
            mapApplication.get(rd.Application__c).Status__c == 'Conditionally Approved: POI' ||
            mapApplication.get(rd.Application__c).Status__c == 'Conditionally Approved: AML and POI' ||
            mapApplication.get(rd.Application__c).Status__c == 'Referred: Sales')
            ) {
                Application__c app = mapApplication.get(rd.Application__c);
                app.Documents_in_Review__c = true;
                listUpdateApplicationStatus.add(app);
            }
        }

        if(listUpdateApplicationStatus.size() > 0) {
            // update the application
            try{
                update listUpdateApplicationStatus;
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'RelatedDocumentTriggerHandler', 'Applicant__c', 'Class');
            }            
        }
    }
}