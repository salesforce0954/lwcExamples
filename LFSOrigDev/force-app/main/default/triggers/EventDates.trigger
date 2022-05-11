trigger EventDates on Event bulk (before insert, before update, after insert,after update) {
    if(Trigger.isBefore){
        ActivityDates.putEBusinessUnit(Trigger.new);
    }
    if(Trigger.isAfter){
        ActivityDates.SortEvent(Trigger.new);
    }
}