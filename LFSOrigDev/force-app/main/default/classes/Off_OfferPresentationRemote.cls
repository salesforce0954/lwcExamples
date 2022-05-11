/*
Author: Jan Mark Domingo Cloud Sherpas
Created Date: April 10, 2014
Description: Javascript remoting function for the Offers page. Intended as a work around 
             until PerspecSys can support the Streaming API
*/
global class Off_OfferPresentationRemote {

    public Off_OfferPresentationRemote(ApexPages.StandardController controller) {
        
    }

    @RemoteAction
    //global static Integer checkForApplicationResponseNonStreaming(String applicationIdToLook){
    global static Application_Response__c checkForApplicationResponseNonStreaming(String applicationIdToLook){ // - May 13-2016 Afreen changed the rurn type
        DateTime timePageWasLoaded = System.now().addSeconds(-10);       
        List<Application_Response__c> appResponseList = [Select Id, Restart_Indicator__c from Application_Response__c where Application__c = :applicationIdToLook AND CreatedDate > : timePageWasLoaded Order By CreatedDate];
        System.debug('### appResponseList ' + appResponseList);    
        //return appResponseList.size();
        if(appResponseList.size()>0){
            return appResponseList[0];
        }else{
            return null;
        }
    }
    
    
    /**TXU DBHZL386**/
    @RemoteAction
    global static Application_Response__c checkForRetrievePayoffApplicationResponse(String applicationIdToLook){
    	DateTime timePageWasLoaded = System.now().addSeconds(-10);
    	List<Application_Response__c> appResponseList = [SELECT Id, Retrieved_Payoff_Amount__c, 
    															RPQ_Charge_Off_Amount__c,
    															RPQ_Early_Termination_Fee__c,
    															RPQ_Fees_or_Charges_Due__c,
    															RPQ_Insurance_Rebate__c,
    															RPQ_Interest_Due__c,
    															RPQ_Interest_Rate__c,
    															RPQ_Late_Fees_Due__c,
    															RPQ_Penalty_Interest_Due__c,
    															RPQ_Principal_Amount__c
    													 FROM Application_Response__c WHERE Application__c = : applicationIdToLook
    													 AND Retrieve_Payoff_Response__c = true AND CreatedDate > : timePageWasLoaded];
    														
    	if(appResponseList.size()>0){
    		return appResponseList[0];
    	}else{
    		return null;
    	}													
    														
    }
    
     /*  Description: Method to perform document receive confirmation. This replaces the need to 
                     perform an asyn callout inside GeneratedDocumentTrigger. After all documents are
                     successfully generated for an application.
     *  Author: Adrian Recio
     *  Date Created: 21-09-2015
     *  Input: None     
     */
    @RemoteAction
    global static Boolean callConfirmContractRecieved(String appId){
     
        //Query apps with their appropriate related doc recrods 
        List<Related_Document__c> relDocList = [SELECT  Application__c,
                                                              Application__r.Generated_Doc_Confirm_Sent__c,
                                                              Status__c
                                                      FROM    Related_Document__c 
                                                      WHERE   GE_Link_Type__c = :DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED 
                                                      AND     Application__r.Generated_Doc_Confirm_Sent__c = FALSE 
                                                      AND     Document_Category__c = :GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN 
                                                      AND     application__C = :appId];

        System.debug('relDocList='+relDocList);

        Application__c appVar = new Application__c();

        //no related documents found so exit method
        if(relDocList.isEmpty()) {
            return false;
        }else{
            appVar.Id = relDocList[0].Application__c;
        }    

        boolean allDocsReceived = true;
        

        for(Related_Document__c relDoc : relDocList) {
            if(relDoc.Application__r.Generated_Doc_Confirm_Sent__c==false){
                System.debug('relDoc-->'+relDoc);
                if(relDoc.Status__c != GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_RECEIVED) {
                    allDocsReceived = false;
                    break;
                }
            }
        }

        //call web service if all docs are received 
        System.debug('allDocsReceived--->'+allDocsReceived);
        if(allDocsReceived) {
            try{
                List<IS_ValidationError> result = IS_ConfirmContractReceived.confirmContractReceivedRequest(appVar.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);          
                try {
                    appVar.Generated_Doc_Confirm_Sent__c = true;
                    appVar.Doc_Gen_Check__c = false;
                    appVar.Update_Doc_Gen_Check__c = false;
                    update appVar;
                }catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'GeneratedDocumentTriggerHandler', 'Application__c', 'Class', null);
                }
            }catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'callConfirmContractRecieved', 'RelatedDocumentTriggerClass', 'Class');
            }
        }    

        return allDocsReceived;   
    }    
}