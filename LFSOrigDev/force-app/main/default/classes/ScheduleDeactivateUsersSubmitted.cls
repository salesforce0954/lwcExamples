/**
 * @Description: Class to schedule on user deactivation for submitted application
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 29-10-2015
 * @History:
    =====================================================================
       29-10-2015: Created. - Davey Yu
    =====================================================================
**/
global class ScheduleDeactivateUsersSubmitted implements Schedulable {
    global void execute(SchedulableContext sc) {
        DeactivateUserHelper util = new DeactivateUserHelper('Submitted');
        DeactivateSubmittedUsersBatch b = new DeactivateSubmittedUsersBatch();
        b.index = 1;
        b.query = util.getQuery(0);
        database.executebatch(b);
    }
}