/**
 * @Description: Batch Class to deactivate users
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 13-07-2015
 * @History:     
    =====================================================================
       13-07-2015: Created. - Davey Yu
    =====================================================================
**/
global class DeactivateUsersBatch implements Database.Batchable<sObject> {
	
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
       
        if(scope[0].getSObjectType().getDescribe().getName() == GEN_OriginationsConstants.APPLICATION){
           DeactivateUserHandler.DeactivateUserHandler(scope);
        }
    }
    
	
	global void finish(Database.BatchableContext BC) {
        DeactivateUserUtil util = new DeactivateUserUtil();

        if(util.queryStringList.size() > index && util.queryStringList.size() != index ){

                DeactivateUsersBatch b = new DeactivateUsersBatch();
                b.query = util.getQuery(index);
                b.index = index+1;
                database.executebatch(b);
           
        }
    }
	
}