/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 21 Feb 2013 
* @description Scheduleable class to create batch job for Billing Vision Plus Mass Delete
*/

global class ScheduleBVisionPlusDeleteBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BVisionPlusDeleteBatch b = new BVisionPlusDeleteBatch();
        database.executebatch(b);
    }
}