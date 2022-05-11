global class ScheduleQuoteSMSReminder implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new QuoteBatchSMSReminder(),100);
     }
}