/**
 * @Description: Controller class to delete all leads without an outcome or have been marked with "No Answer" 6 months after have been created
 * @Author: Russel Cadapan (Accenture)
 * @Date Created: 10-OCT-2016
 * @History:
    =====================================================================
       210-OCT-2016: Created. - Russell Cadapan
    =====================================================================
**/
public class DeleteUnassignedLeadBatchController {
    private static final Id RECORDTYPEID_EXLOG_GENERAL = Schema.SObjectType.ExceptionLog__c.getRecordTypeInfosByName().get('General').getRecordTypeId();
    public void deleteUnassignedLeads(List<Opportunity> unassignedLeads){
        try{
            delete unassignedLeads;
        }
        catch(Exception e){
            ErrorHandlerException.recordException(e.getMessage(), e.getStackTraceString(), 'DeleteUnassignedLeadBatchController.deleteUnassignedLeads', 'Opportunity', 'Batch Class', 'Failed', null, null, RECORDTYPEID_EXLOG_GENERAL);
        }
    }
}