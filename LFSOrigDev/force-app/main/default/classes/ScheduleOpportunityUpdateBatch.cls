/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 21 Feb 2013 
* @description 
*/

global class ScheduleOpportunityUpdateBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        OpportunityUpdateBatch b = new OpportunityUpdateBatch();
        database.executebatch(b);
    }
}