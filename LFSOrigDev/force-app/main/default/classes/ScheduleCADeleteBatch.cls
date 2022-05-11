/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 05 Feb 2013 
* @description Schedulable class to perform mass delete of campaign assignments using the CADeleteBatch Batch Class
*/

global class ScheduleCADeleteBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        CADeleteBatch b = new CADeleteBatch();
        database.executebatch(b);
    }
}