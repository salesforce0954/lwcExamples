/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description Scheduleable class to create batch job for Billing Icbs Mass Delete
*/

global class ScheduleBIcbsDeleteBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BIcbsDeleteBatch b = new BIcbsDeleteBatch();
        database.executebatch(b);
    }
}