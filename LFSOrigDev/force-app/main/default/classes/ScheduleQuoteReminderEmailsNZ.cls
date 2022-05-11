global class ScheduleQuoteReminderEmailsNZ implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new QuoteBatchEmailReminderNZ(),100);    
     }
}