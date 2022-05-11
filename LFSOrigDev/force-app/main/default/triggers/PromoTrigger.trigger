/* @Description: Promo trigger
 * @Author: Mike Lasala
 * @Date Created: 17-AUG-2016
 */
trigger PromoTrigger on Promo__c (before insert, before update, before delete, after insert, after update, after delete, after undelete){
    
    PromoTriggerHandler.executeTriggerEvents(trigger.isBefore, trigger.isAfter, 
                                             trigger.isInsert, trigger.isUpdate,trigger.isDelete, trigger.isUndelete, 
                                             trigger.oldMap, trigger.new, trigger.newMap);
}