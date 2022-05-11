/**
 * @Description: Class to schedule delete on unsubmitted application
 * @Author: Davey
 * @Date Created: 29-10-2015
 * @History:
    =====================================================================
       29-05-2014: Created. - Davey
    =====================================================================
**/
global class ScheduleDeleteUnsubmittedApplication implements Schedulable {
    global void execute(SchedulableContext sc) {
        DeleteRecordsHelper util = new DeleteRecordsHelper('New');
        DeleteUnsubmittedApplicationBatch b = new DeleteUnsubmittedApplicationBatch();
        b.index = 1;
        b.query = util.getQuery(0);
        database.executebatch(b);
    }
}