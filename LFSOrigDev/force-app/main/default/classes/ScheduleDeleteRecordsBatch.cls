/**
 * @Description: Class to scheduel recods delete batch
 * @Author: Fahad Akhtar (Cloud Sherpas)
 * @Date Created: 29-05-2014
 * @History:
    =====================================================================
       29-05-2014: Created. - Fahad Akhtar
    =====================================================================
**/
global class ScheduleDeleteRecordsBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        DeleteRecordsUtil util = new DeleteRecordsUtil();
        DeleteRecordsBatch b = new DeleteRecordsBatch();
        b.index = 1;
        b.query = util.getQuery(0);
        database.executebatch(b);
    }
}