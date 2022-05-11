trigger ContactTrigger on Contact (after insert, after update, before insert, before update) {

    
    if((trigger.isInsert && trigger.isBefore)||(trigger.isUpdate && trigger.isBefore)){
        ContactTriggerHandler.validateSinglePrimary_before(trigger.new,trigger.oldMap);
    }
    if((trigger.isInsert && trigger.isAfter)||(trigger.isUpdate && trigger.isAfter)){
        ContactTriggerHandler.validateSinglePrimary(trigger.new,trigger.oldMap);
    }

}