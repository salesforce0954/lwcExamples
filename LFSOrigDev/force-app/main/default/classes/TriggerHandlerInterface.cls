/*********************************************************************************************
* @author         Cludo
* @date           14/08/2017
* @description:   Trigger interface
* @Version: 
**********************************************************************************************/
public interface TriggerHandlerInterface {
    Boolean isDisabled();
    String getName();
    Integer getMaxRecursion();

    void beforeInsert(List<SObject> newItems);
    void beforeUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map<Id, SObject> oldItemsMap);
    void beforeDelete(Map<Id, SObject> oldItemsMap);
    
    void afterInsert(List<SObject> newItems, Map<Id, SObject> newItemsMap);
    void afterUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap, Map<Id, SObject> oldItemsMap);
    void afterDelete(Map<Id, SObject> oldItemsMap);
    void afterUndelete(List<SObject> newObjects, Map<Id, SObject> newObjectsMap);
}