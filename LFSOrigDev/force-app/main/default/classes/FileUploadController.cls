/**
 * @Description: Controller class for fileUploadCmp Lightning Web Component
 * @Author: William Putra - VISEO Asia PTE Ltd
 * @Date Created: 22/07/2021
 * @History:
   =====================================================================
       22-07-21: Created - William Putra
   =====================================================================
 */

public without sharing class FileUploadController {
    @AuraEnabled(cacheable=true)
    public static String getUploadEndPoint() {
        return Web_Service_Settings__c.getValues('File Upload Endpoint').value__c;
    }

    @AuraEnabled
    public static UploadInfo insertRelatedDocument(string title, string applicationId, string applicantId, Boolean mockEnabled){
        try {
            //Map<String, Applicant__c> applicantMap = APP_GSD_FileUpload.getApplicantOptions(applicationId);
            UploadInfo uploadInfoVar = new UploadInfo();

            String applicantFirstName = '';
            String applicantLastName = '';
            String applicationUniqueID = '';
            String getDateStamp = '';
            String productId = '';
            String recordIdSaved = '';
            Application__c application = new Application__c();
            Applicant__c applicant = new Applicant__c();

            System.debug('DEBUG APEX '+applicantId);

            if(applicantId != null) {
                applicant = [SELECT First_Name__c, Last_Name__c, Application__r.UID__c,
                                                Application__r.Brand_Lookup__r.File_Upload_Product__c, 
                                                ID, Email_Address__c, Is_Primary_Applicant__c from
                                                Applicant__c WHERE 
                                                ID = :applicantId LIMIT 1
                                            ];
                applicantFirstName = applicant.First_Name__c;
                applicantLastName = applicant.Last_Name__c;  
                applicationUniqueID = applicant.Application__r.UID__c;                                             
            } else {
                application = [
                    SELECT ID, UID__c, Brand_Lookup__r.File_Upload_Product__c
                    FROM
                    Application__c WHERE 
                    ID = :applicationId LIMIT 1
                ];
            }

            /*Applicant__c primaryApplicant = new Applicant__c();
            Map<String, Id> appEmailMap = new Map<String, Id>();

            // Pull Primary Applicant from list
            // Pull email map from list
            for(Applicant__c applicant: applicantList){
                if(applicant.Is_Primary_Applicant__c==true){
                    primaryApplicant = applicant;
                }
                appEmailMap.put(applicant.Email_Address__c,applicant.Id);
            }*/
            
            //query application record
   
            
            //process create related document record
            Related_Document__c relatedDocument = new Related_Document__c();
            relatedDocument.Application__c = applicationId;
            relatedDocument.Title__c = title;
            if(applicantId != null) {
                relatedDocument.Product__c = applicant.Application__r.Brand_Lookup__r.File_Upload_Product__c;
                relatedDocument.Applicant__c = applicantId;
            } else {
                relatedDocument.Product__c = application.Brand_Lookup__r.File_Upload_Product__c;
            }
            if(mockEnabled==false){
                relatedDocument.Status__c = DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_DRAFT;
            }else{
                relatedDocument.Status__c = DOC_GenerateDocumentsUtil.DOCUMENT_STATUS_RECEIVED;
            }
            /*if(site.getName()!=null&&site.getName()!=''){
                if(category=='POI1' || category=='POI2'){
                    relatedDocument.Document_Category__c = 'POI';
                }else{
                    relatedDocument.Document_Category__c = category;
                }
            }    
            relatedDocument.Type__c = type;*/
            insert relatedDocument;

            //generate requested document
            /*Requested_Document__c rd = new Requested_Document__c();
            rd.Status__c = 'Complete';
            rd.Category__c = category;
            rd.Document_Type__c = 'Not Applicable';
            rd.Applicant__c = applicantId;
            rd.Application__c = applicationId;
            rd.Number_Required__c = '1';
            insert rd;*/
            
            //put the result into variable for response
            recordIdSaved = relatedDocument.Id;
            productId = relatedDocument.Product__c;

            uploadInfoVar.applicantFirstName = applicantFirstName;
            uploadInfoVar.applicantLastName = applicantLastName;
            uploadInfoVar.applicationUniqueID = applicationUniqueID;
            uploadInfoVar.getDateStamp = getDateStamp;
            uploadInfoVar.productId = productId;
            uploadInfoVar.recordIdSaved = recordIdSaved;

            return uploadInfoVar;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteRelatedDocument(string delRelId){
        try {
            if(delRelId!=null && delRelId!=''){
                List<Related_Document__c> delRelList = [Select Id from Related_Document__c where Id = :delRelId];
                if(delRelList.size()==1){
                    delete delRelList;
                }
            }            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*  Description: Upload infor wrapper class
     *  Author: William Putra
     *  Date Created: 23/07/2021
     *  Parameter 
     *  Return: NA
     */
    public class UploadInfo{
        @AuraEnabled public string applicantFirstName{get; set;}
        @AuraEnabled public string applicantLastName{get; set;}
        @AuraEnabled public string applicationUniqueID{get; set;}
        @AuraEnabled public string getDateStamp{get; set;}
        @AuraEnabled public string productId{get; set;}
        @AuraEnabled public string recordIdSaved{get; set;}
    }    
}