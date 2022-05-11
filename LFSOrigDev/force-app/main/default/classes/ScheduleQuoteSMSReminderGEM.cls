global class ScheduleQuoteSMSReminderGEM implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new QuoteBatchSMSReminderGEM(),100);
     }
}