trigger setOutOfSyncApp on Product_Item__c (after delete) {

    Set<Id> appIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isDelete){
       for(Product_Item__c  pi: Trigger.old){
           appIds.add(pi.Application__c);
       }
    }
    
    if(appIds.size()>0){
        DebitTriggerHandler.setAppOutOfSync(appIds);
    }

}