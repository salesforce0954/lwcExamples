/*
Author: Michael Lasala
Created Date: March 05, 2014
Description: General class for flushing records when application = PCA status
*/
public with sharing class GEN_PCAUtility{

    /*  Description: Method that will delete all related documents, attachments and compliance check records
     *  Author: Michael Lasala
     *  Date Created: Mar-05-2014
     *  Input: List<Application__c> application
     *  Return: NONE
     */
    public static void flushComplianceChecklistandLoanDocuments(List<Application__c> applicationList){
        Set<Id> appIds = new Set<Id>();

        if(!applicationList.isEmpty()){

            for(Application__c app: applicationList){
                appIds.add(app.Id);
            }
            
            if(!appIds.isEmpty()){
                
                Set<Id> relatedDocumentIds = new Set<Id>();
                List<Related_Document__c> relatedDocumentList = new List<Related_Document__c>();

                //Get all related documents
                relatedDocumentList = [SELECT   Id 
                                       FROM     Related_Document__c 
                                       WHERE    (Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN
                                       OR        (Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL 
                                       AND       Type__c =: DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT))
                                       AND      Application__c
                                       IN:      appIds];
                
                if(!relatedDocumentList.isEmpty()){
                    try{
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Related_Document__c.sObjectType.getDescribe().isDeletable()){
                            delete relatedDocumentList;
                        }
                        */
                        delete relatedDocumentList;
                    }
                    catch(Exception e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_PCAUtility', 'Related_Document__c', 'Class');
                    }
                }

                List<Compliance_Check__c> complianceCheckList = new List<Compliance_Check__c>();

                //Get all related compliance checklist
                complianceCheckList = [SELECT   Id 
                                       FROM     Compliance_Check__c
                                       WHERE    Application__c 
                                       IN:      appIds];
                
                if(!complianceCheckList.isEmpty()){
                    try{
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Compliance_Check__c.sObjectType.getDescribe().isDeletable()){
                            delete complianceCheckList;
                        }*/
                        delete complianceCheckList;
                    }
                    catch(Exception e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_PCAUtility', 'Compliance_Check__c', 'Class');
                    }
                }
            }
        }
    }

    /*  Description: Method that will flush all consents and related documents, attachments
     *  Author: Michael Lasala
     *  Date Created: May-04-2015
     *  Input: List<Application__c> application
     *  Return: NONE
     */
    public static void flushConsentandLoanDocuments(List<Application__c> applicationList){
        Set<Id> appIds = new Set<Id>();

        if(!applicationList.isEmpty()){

            for(Application__c app: applicationList){
                appIds.add(app.Id);
            }
            
            if(!appIds.isEmpty()){
                
                List<Application__c> appList = new List<Application__c>();

                applicationList = [SELECT Id 
                                   FROM   Application__c 
                                   WHERE  Id IN: appIds];
                
                if(!applicationList.isEmpty()){
                    for(Application__c a: applicationList){
                        a.Is_Accepted_Primary__c = false;
                        a.Is_Accepted_Secondary__c = false;
                        a.Is_Insurance_Acknowledgement_Enabled__c = false;
                        a.Is_Insurance_Acknowledgement_Enabled_2nd__c = false;
                        a.Insurance_Acknowledgement__c = false;
                        a.Insurance_Acknowledgement_Secondary__c = false;
                    }

                    try{
                        update applicationList;
                    } catch(Exception e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_PCAUtility', 'Application__c', 'Class');
                    }
                }

                Set<Id> relatedDocumentIds = new Set<Id>();
                List<Related_Document__c> relatedDocumentList = new List<Related_Document__c>();

                //Get all related documents
                relatedDocumentList = [SELECT   Id 
                                       FROM     Related_Document__c 
                                       WHERE    (Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_LOAN
                                       OR        (Document_Category__c =: GEN_OriginationsConstants.DOCUMENT_CATEGORY_INTERNAL 
                                       AND       Type__c =: DOC_GenerateDocumentsUtil.DOCUMENT_TYPE_DISCLOSURE_STATEMENT))
                                       AND      Application__c
                                       IN:      appIds];
                
                if(!relatedDocumentList.isEmpty()){

                    try{
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Related_Document__c.sObjectType.getDescribe().isDeletable()){
                            delete relatedDocumentList;
                        }*/
                        delete relatedDocumentList;
                    } catch(Exception e){
                        ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_PCAUtility', 'Related_Document__c', 'Class');
                    }
                }
            }
        }
    }
}