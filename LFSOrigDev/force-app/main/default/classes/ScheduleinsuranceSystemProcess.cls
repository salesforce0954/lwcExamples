global class ScheduleinsuranceSystemProcess implements Schedulable {
    global void execute(SchedulableContext sc) {
       Database.executeBatch(new newInsuranceSystem(),1);
    }
}