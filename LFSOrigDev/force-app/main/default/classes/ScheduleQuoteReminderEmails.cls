global class ScheduleQuoteReminderEmails implements Schedulable {
    global void execute(SchedulableContext sc) {
      Database.executeBatch(new quoteBatchEmailReminder(),100);
           
    }
}