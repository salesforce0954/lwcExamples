/*
 * @Description: Utility Class for getting Related Document records, fields with specifications.
 * @Author: Russell Cadapan
 * @Date Created: DEC-16-2013
 * @History:
   =====================================================================
       16-12-13: Created - Russell
       05-04-14: Updated method to remove query redundancy in APP_Document tab - Dan
   =====================================================================
 */
Public class GEN_RelatedDocumentUtility{

    Public Static final String ORGANIZATION_URL = URL.getSalesforceBaseUrl().toExternalForm();

    /*
    Author: Russell Cadapan Cloud Sherpas
    Description: A method that returns a list of documents with the corresponding URL
    Parameters: Set<Id> of the related document
    Return: Map<Related_Document__c, String>
    Revision:
        - March 5: Updated method to remove query redundancy in APP_Document tab - Dan
    */
    Public static Map<Id, String> getDocumentURL(List<Related_Document__c> relatedDocs){

        //Custom Settings
        DocumentLinkEndpoints__c dle = DocumentLinkEndpoints__c.getInstance();   
        String ATTACHMENT_URL = dle.AttachmentUrl__c;
        
        //initialize variables to use
        Map<Id, String> relatedDocumentMap = new Map<Id, String>();
        Set<Id> generatedDocIds = new Set<Id>();
        
        //filter all related documents with link types
        for(Related_Document__c rd: relatedDocs){
            if(rd.Ge_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED){
                generatedDocIds.add(rd.Id);
            }
        }
        
        Map<Id, Attachment> attachmentsMap = new Map<Id, Attachment>();
        
        if(!generatedDocIds.isEmpty()) {
            for(Attachment att: [SELECT    Id,
                                           Name,
                                           ParentId
                                 FROM      Attachment
                                 WHERE     ParentId IN: generatedDocIds
                                 ORDER BY  CreatedDate ASC]){
                attachmentsMap.put(att.ParentId,att);
            }
        }

        for(Related_Document__c rd: relatedDocs){
            String GeDocumentURL='';
            Web_Service_Settings__c urlLink = Web_Service_Settings__c.getInstance(rd.Ge_Link_type__c + ' Document Link');

            if(rd.Ge_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_GENERATED){
                if(attachmentsMap.containsKey(rd.Id)){
                    GeDocumentURL = ORGANIZATION_URL + ATTACHMENT_URL + String.valueOf(attachmentsMap.get(rd.Id).Id) + '/Name='+ attachmentsMap.get(rd.Id).Name;
                }
            } else if(rd.Ge_Link_Type__c == DOC_GenerateDocumentsUtil.LINK_TYPE_STATIC) {
                GeDocumentURL = rd.AttachmentUrl__c;
            } else if(urlLink != null && rd.GE_Document_ID__c != null){
                GeDocumentURL = urlLink.Value__c + rd.GE_Document_ID__c + '/Name=' + rd.GE_Document_Id__c;
            }
            relatedDocumentMap.put(rd.Id,GeDocumentURL);
        }
        return relatedDocumentMap;
    }
}