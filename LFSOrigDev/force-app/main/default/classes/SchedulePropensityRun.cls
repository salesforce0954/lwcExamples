/**
* @author Original: Andre Calimlim Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description 
*/

global class SchedulePropensityRun implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        DailyRefreshLogicBatch b = new DailyRefreshLogicBatch();
        database.executebatch(b);
    }
}