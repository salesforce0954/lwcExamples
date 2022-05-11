/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 21 Feb 2013 
* @description Scheduleable class to create batch job for Billing Genesis Mass Delete
*/

global class ScheduleBGenesisDeleteBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BGenesisDeleteBatch b = new BGenesisDeleteBatch();
        database.executebatch(b);
    }
}