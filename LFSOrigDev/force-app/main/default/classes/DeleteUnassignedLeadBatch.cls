/**
 * @Description: Batch class to delete all leads without an outcome or have been marked with "No Answer" 6 months after have been created
 * @Author: Russel Cadapan (Accenture)
 * @Date Created: 10-OCT-2016
 * @History:
    =====================================================================
       210-OCT-2016: Created. - Russell Cadapan
    =====================================================================
**/
global class DeleteUnassignedLeadBatch implements Database.batchable<sObject>{
    Date stamp;
    String queryString;
    
    global DeleteUnassignedLeadBatch(Boolean isMock){
        if(isMock){
            stamp = Date.Today().addMonths(getLeadMonthWindow());
            queryString = 'SELECT Id, StageName, CreatedDate FROM Opportunity WHERE (StageName = \'New\' OR StageName = \'No Answer\') AND CreatedDate <: stamp LIMIT 10 ';
        }
        else{
            stamp = Date.Today().addMonths(getLeadMonthWindow());
            queryString = 'SELECT Id, StageName, CreatedDate FROM Opportunity WHERE (StageName = \'New\' OR StageName = \'No Answer\') AND CreatedDate <: stamp';
        }
    }
    
    global Database.querylocator start(Database.batchableContext info){
        // return the leads
        return Database.getQueryLocator(queryString);
   }   
   global void execute(Database.batchableContext info, List<Opportunity> scope){ 
        DeleteUnassignedLeadBatchController deleteLeadController = new DeleteUnassignedLeadBatchController();
        deleteLeadController.deleteUnassignedLeads(scope);
   }     
   global void finish(Database.batchableContext info){ 
       
   } 
   
   /**
    * @author: Russell Cadapan
    * @date : 10-OCT-2016
    * @description Method to retrieve date window for unassigned leads to be deleted
    * @param 
    */
    private Integer getLeadMonthWindow(){
        return Integer.valueOf(Admin_Settings__c.getValues(GEN_OriginationsConstants.ADMIN_SETTING_UNASSIGNED_LEADS_WINDOW).Value__c) * -1;
    }
}