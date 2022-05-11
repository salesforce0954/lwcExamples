/**Name: MasterQuoteTrigger
 * Description: Master Trigger to handle the operations on Quote Object
 * Date: 17-MAR-2020 */
trigger MasterQuoteTrigger on Quote__c (
    before insert, after insert,
    before update, after update,
    before delete, after delete) {
    
        TriggerDispatcher.run(new QuoteTriggerHandler()); 

}