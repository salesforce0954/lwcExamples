/**
 * @Description: Class to schedule on user deactivation
 * @Author: Davey Yu (Cloud Sherpas)
 * @Date Created: 14-07-2015
 * @History:
    =====================================================================
       14-07-2015: Created. - Davey Yu
    =====================================================================
**/
global class ScheduleDeactivateUsersBatch implements Schedulable {
	global void execute(SchedulableContext sc) {
		DeactivateUserUtil util = new DeactivateUserUtil();
		DeactivateUsersBatch b = new DeactivateUsersBatch();
		b.index = 1;
		b.query = util.getQuery(0);
		database.executebatch(b);
	}
}