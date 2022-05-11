trigger PLAccountTrigger on Account (before insert, after insert, before update, after update, after delete )
{
        
    AccountTriggerHandler.executeTriggerEvents(trigger.isBefore, trigger.isAfter, trigger.isInsert, 
                                                trigger.isUpdate,trigger.isDelete, trigger.new, trigger.newMap, trigger.old, trigger.oldMap );
    /*AccountTriggerHandlerContactStratgey.executeTriggerEvents(trigger.isBefore, trigger.isAfter, trigger.isInsert, 
                                               trigger.isUpdate,trigger.isDelete, trigger.new, trigger.newMap, trigger.old, trigger.oldMap ); */
}