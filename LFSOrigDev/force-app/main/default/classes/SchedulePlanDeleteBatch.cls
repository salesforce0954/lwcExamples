/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 13 March 2013 
* @description: initial class
* @author: B.Naveenkumar
* @Date :17-Sep-2013
* @Modification: Adding 'Limit 50000' in existing query
*/

global class SchedulePlanDeleteBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        PlanDeleteBatch b = new PlanDeleteBatch();
        database.executebatch(b, 2000);
    }
}