/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 05, 2014
Description: Update the status in the related document Object and call the webservice confirmation contract Recieved.
*/
public with sharing class GeneratedDocumentTriggerHandler {
    /**  Description: Method to update the status in the Related Document Object
     *  Author: Louis Augusto Del Rosario
     *  Date Created: Febuary 05, 2014
     *  Input Parameters: Trigger.new - newly inserted Attachment records
     *  Return: void
     */
    public void UpdateRelatedDocument(List<Attachment> aList) {
        
        //create set to store Parent Ids.
        Set<Id> AttachmentParentIdSet = new Set<Id>();
        //make list of Releated Documents for update.
        List<Related_Document__c> relatedDocumentListToUpdate = new List<Related_Document__c>();       

        for(Attachment a: aList){
            //add parentIds in a set.
            AttachmentParentIdSet.add(a.parentId);
        }
        
        //Query for Related Documents
        String appId = '';
        for(Related_Document__c rd:[SELECT Id, Error_Code__c, Error_Description__c, Status__c
                                    FROM Related_Document__c 
                                    WHERE Id IN:AttachmentParentIdSet]){
                                    
            rd.status__c = GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_RECEIVED;
            //clear error fields.
            rd.Error_Code__c = null;
            rd.Error_Description__c = null;
            //put related Document in a list.
            appId = rd.Id;
            relatedDocumentListToUpdate.add(rd);
        }
        //check list size before doing an update, should be greater than 0.
        if(relatedDocumentListToUpdate.size()>0){
            try{
                update relatedDocumentListToUpdate;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'GeneratedDocumentTriggerHandler', 'Related_Document__c', 'Class', appId);    
            }
        }
    }
    
    public void callConfirmContractRecieved(List<Attachment> attachments){
        
        System.debug('callConfirmContractRecieved - started');

         //1. get a set of all the related doc ids to check if W/S has been / needs to be called
        Set<Id> relIds = new Set<Id>();
        for(Attachment attach:attachments){
            if(attach.ParentId != null){
                relIds.add(attach.ParentId);
            }
        }

        System.debug('relIds='+relIds);
        
        //2. Query the applications associated with the given related documents
        List<Related_Document__c> relList = [SELECT application__C FROM Related_Document__c WHERE id IN: relIds];
        Set<Id> appIds = new Set<Id>();
        for(Related_Document__c rl : relList) {
            appIds.add(rl.application__C);
        }

        System.debug('appIds='+appIds);

        //3. Query apps with their appropriate related doc recrods 
        List<Related_Document__c> relDocAndAppList = [SELECT  Application__c,
                                                              Application__r.Generated_Doc_Confirm_Sent__c,
                                                              Status__c
                                                      FROM    Related_Document__c 
                                                      WHERE   GE_Link_Type__c =: DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED 
                                                      AND     Application__r.Generated_Doc_Confirm_Sent__c = FALSE 
                                                      AND     Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN 
                                                      AND     application__C IN: appIds];

        System.debug('relDocAndAppList='+relDocAndAppList);
        //no related documents found so exit method
        if(relDocAndAppList.isEmpty()) {
            return;
        }    

        Map<Application__c, List<Related_Document__c>> relDocListByAppMap = new Map<Application__c, List<Related_Document__c>>();
        for(Related_Document__c relDoc : relDocAndAppList) {
            List<Related_Document__c> relDocList = relDocListByAppMap.get(relDoc.Application__r);
            if(relDocList==null) {
                relDocList = new List<Related_Document__c>();
                relDocListByAppMap.put(relDoc.Application__r, relDocList);
            }
            relDocList.add(relDoc);
        }

        //4. Iterate through apps and check if it's ready to call the w/s
        System.debug('relDocListByAppMap--->'+relDocListByAppMap);
        List<Application__c> appListToUpdate = new List<Application__c>();
        for(Application__c app : relDocListByAppMap.keySet()) {
            if(app.Generated_Doc_Confirm_Sent__c==false) {
                List<Related_Document__c> relDocList = relDocListByAppMap.get(app);
                
                if(relDocList.isEmpty()) {
                    continue;
                }

                boolean allDocsReceived = true;
                for(Related_Document__c relDoc : relDocList) {
                    System.debug('relDoc-->'+relDoc);
                    if(relDoc.Status__c != GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_RECEIVED) {
                        allDocsReceived = false;
                        break;
                    }
                }

                //call web service if all docs are received 
                System.debug('allDocsReceived--->'+allDocsReceived);
                if(allDocsReceived) {
                    try{
                        List<IS_ValidationError> result = IS_ConfirmContractReceived.confirmContractReceivedRequest(app.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);          
                        app.Generated_Doc_Confirm_Sent__c = true;

                        //BEGIN MLASALA: 10-SEPT-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN
                        //Set doc gen flags to false
                        app.Doc_Gen_Check__c = false;
                        app.Update_Doc_Gen_Check__c = false;
                        //END MLASALA: 10-SEPT-2015 - FORCE APPLICATION UPDATE PRIOR TO DOC GEN
                        appListToUpdate.add(app);
                    }
                    catch(Exception e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'callConfirmContractRecieved', 'RelatedDocumentTriggerClass', 'Class');
                    }
                }
            }
        }

        //5. Update any changed apps
        if(!appListToUpdate.isEmpty()) {
            try {
                update appListToUpdate;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'GeneratedDocumentTriggerHandler', 'Application__c', 'Class', null);
            }
        }

    }
}