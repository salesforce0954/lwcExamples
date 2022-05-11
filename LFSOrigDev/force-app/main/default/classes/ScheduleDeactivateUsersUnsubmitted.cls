/**
 * @Description: Class to schedule on user deactivation for unsubmitted application
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 14-07-2015
 * @History:
    =====================================================================
       14-07-2015: Created. - Davey Yu
    =====================================================================
**/
global class ScheduleDeactivateUsersUnsubmitted implements Schedulable {
    global void execute(SchedulableContext sc) {
        DeactivateUserHelper util = new DeactivateUserHelper('New');
        DeactivateUnsubmittedUsersBatch b = new DeactivateUnsubmittedUsersBatch();
        b.index = 1;
        b.query = util.getQuery(0);
        database.executebatch(b);
    }
}