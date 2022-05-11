/**
 * @Description: Batch Class to delete all records
 * @Author: Fahad Akhtar (Cloud Sherpas)
 * @Date Created: 29-05-2014
 * @History: Added Sales & leads billing object Queries with Custom Settings for number of days
 *           Added custom settings on all queries.
             Added a filter for Application records      
    =====================================================================
       29-05-2014: Created. - Fahad Akhtar
    =====================================================================
**/
global class DeleteRecordsBatch implements Database.Batchable<sObject>,Database.Stateful{
    
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
        if(scope.size()>0 && scope[0].getSObjectType().getDescribe().getName() != GEN_OriginationsConstants.APPLICATION){
            delete scope;
        }
        if(scope[0].getSObjectType().getDescribe().getName() == GEN_OriginationsConstants.APPLICATION){
           AppDataPergeHandler.AppDataPergeHandler(scope);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        DeleteRecordsUtil util = new DeleteRecordsUtil();

        if(util.queryStringList.size() > index && util.queryStringList.size() != index ){

                DeleteRecordsBatch b = new DeleteRecordsBatch();
                b.query = util.getQuery(index);
                b.index = index+1;
                database.executebatch(b);
           
        }
    }
}