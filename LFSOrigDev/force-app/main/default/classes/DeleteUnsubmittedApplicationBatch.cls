/*
 * @Description: Batch Class to delete all unsubmitted applications
 * @Author: Davey
 * @Date Created: 29-10-2015
 * @History:  
    =====================================================================
       29-05-2014: Created - Davey
    =====================================================================
**/
global class DeleteUnsubmittedApplicationBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    public String query{get; set;}
    public integer index{get;set;}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        Set<String> appStatus = new Set<String>();
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_CLOSED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_DECLINED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_FINALIZED);
        
        String docStatusDraft = GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_DRAFT;
        String linkTypeEvolve = GEN_OriginationsConstants.RELATED_DOCUMENT_LINKTYPE_EVOLVE;
        String auRegion = GEN_OriginationsConstants.AU_REGION;
        String nzRegion = GEN_OriginationsConstants.NZ_REGION;
        String newAppStatus = GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW;
        
        System.debug('$$$ query: '+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        AppDataPergeHandler.AppDataPergeHandler(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        DeleteRecordsHelper util = new DeleteRecordsHelper('New');

        if(util.queryStringList.size() > index && util.queryStringList.size() != index ){

                DeleteUnsubmittedApplicationBatch b = new DeleteUnsubmittedApplicationBatch();
                b.query = util.getQuery(index);
                b.index = index+1;
                database.executebatch(b);
           
        }
    }
}