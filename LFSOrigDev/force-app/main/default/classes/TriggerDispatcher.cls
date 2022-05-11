/*********************************************************************************************
* @author         Cludo
* @date           14/08/2017
* @description:   Trigger dispatcher 
* @Version: 
**********************************************************************************************/
public with sharing class TriggerDispatcher {
    private static Map<String, List<RecursionCounter>> recordsAlreadyProcessedByContext; 

    static {
        recordsAlreadyProcessedByContext = new Map<String, List<RecursionCounter>>();
    }

    public static void run(TriggerHandlerInterface handler){
        if (handler.isDisabled()){
            System.debug('TRIGGER_LOG: Trigger disabled: ' + handler.getName());
            return;
        }

        if(wereObjectsAlreadyExecutedInContext(Trigger.new, handler)){
            System.debug('TRIGGER_LOG: Objects already processed for context: ' + getTriggerContext() + ' by hander: ' + handler.getName() + ' with max recursion count: ' + handler.getMaxRecursion());
            
            // Still need to run the rollup logic
            //dlrs.RollupService.rollup(Trigger.oldMap, Trigger.newMap, getContextObjectType());

            return;
        }
             
        Long triggerStartMillis = Datetime.now().getTime();
        Integer usedSOQLOnEntry = Limits.getQueries();

        System.debug('TRIGGER_LOG: Entering ' + handler.getName() + ' ' + getTriggerContext());
        
        if (Trigger.isBefore){
            if (Trigger.isInsert){
                handler.beforeInsert(Trigger.new);
            }
            else if (Trigger.isUpdate){
                handler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
            }
            else if (Trigger.isDelete){
                handler.beforeDelete(Trigger.oldMap);
            }
        }    
        else if (Trigger.isAfter){
            if (Trigger.isInsert){
                handler.afterInsert(Trigger.new, Trigger.newMap);
            }
            else if (Trigger.isUpdate){
                handler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
            }
            else if (Trigger.isDelete){
                handler.afterDelete(Trigger.oldMap);
            }
            else if (Trigger.isUndelete){
                handler.afterUndelete(Trigger.new, Trigger.newMap);
            }
        }

        //dlrs.RollupService.rollup(Trigger.oldMap, Trigger.newMap, getContextObjectType());

        System.debug('TRIGGER_LOG: Exiting ' + handler.getName() + ' ' + getTriggerContext() + ' - Elapsed time: ' + (Datetime.now().getTime() - triggerStartMillis) + ' milliseconds, Queries: ' + (Limits.getQueries() - usedSOQLOnEntry));
    }

    private static Schema.SObjectType getContextObjectType(){
        if(Trigger.new != null){
            return Trigger.new.get(0).getSObjectType();
        }
        else{
            return Trigger.old.get(0).getSObjectType();
        }
    }

    private static TriggerContext getTriggerContext(){
        TriggerContext context;

        if (Trigger.isBefore){
            if (Trigger.isInsert){
                context = TriggerContext.BEFORE_INSERT;
            }
            else if (Trigger.isUpdate){
                context = TriggerContext.BEFORE_UPDATE;
            }
            else if (Trigger.isDelete){
                context = TriggerContext.BEFORE_DELETE;
            }
        }    
        else if (Trigger.isAfter){
            if (Trigger.isInsert){
                context = TriggerContext.AFTER_INSERT;
            }
            else if (Trigger.isUpdate){
                context = TriggerContext.AFTER_UPDATE;
            }
            else if (Trigger.isDelete){
                context = TriggerContext.AFTER_DELETE;
            }
            else if (Trigger.isUndelete){
                context = TriggerContext.AFTER_UNDELETE;
            }
        }

        return context;
    }

    /*
    *   Validates whether the same list of records were already executed by this trigger in this context
    */
    private static Boolean wereObjectsAlreadyExecutedInContext(List<SObject> objects, TriggerHandlerInterface handler){
        String recordIdString = '';
        
        if(objects != null && (getTriggerContext() != TriggerContext.BEFORE_INSERT || getTriggerContext() != TriggerContext.AFTER_INSERT)){
            for(SObject obj : objects){
                recordIdString += obj.get('Id');
            }

            // Build a composite key from the trigger context and the object type
            String contextKey = getTriggerContext().name() + '-' + objects.get(0).getSObjectType().getDescribe().getName();

            if(recordsAlreadyProcessedByContext.containsKey(contextKey)){
                for(RecursionCounter recursionCount : recordsAlreadyProcessedByContext.get(contextKey)){
                    if(recursionCount.recordIdString.equals(recordIdString)){
                        if(recursionCount.executionCount < handler.getMaxRecursion()){
                            recursionCount.executionCount++;
                            return true;
                        }
                        else{
                            return false;
                        }
                    }
                }

                recordsAlreadyProcessedByContext.get(contextKey).add(new RecursionCounter(recordIdString));
            }
            else{
                recordsAlreadyProcessedByContext.put(contextKey, new List<RecursionCounter>{new RecursionCounter(recordIdString)});
            }
        }
        
        return false;
    }

    public class RecursionCounter{
        public String recordIdString;
        public Integer executionCount = 0;

        public RecursionCounter(String recordIdString){
            this.recordIdString = recordIdString;
        }
    }

    private enum TriggerContext {
        BEFORE_INSERT, 
        BEFORE_UPDATE, 
        BEFORE_DELETE,
        AFTER_INSERT, 
        AFTER_UPDATE, 
        AFTER_DELETE,
        AFTER_UNDELETE
    }
}