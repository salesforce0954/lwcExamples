/**
 * @Description: DeleteUnassignedLeadBatch scheduler class
 * @Author: Russel Cadapan (Accenture)
 * @Date Created: 10-OCT-2016
 * @History:
    =====================================================================
       210-OCT-2016: Created. - Russell Cadapan
    =====================================================================
**/
global class DeleteUnassignedLeadBatchScheduler implements schedulable{
    Boolean isMock;
    global DeleteUnassignedLeadBatchScheduler(Boolean isMock){
        this.isMock = isMock;
    }
    global void execute(SchedulableContext sc){
        DeleteUnassignedLeadBatch b = new DeleteUnassignedLeadBatch(isMock);
        database.executebatch(b);
    }
}