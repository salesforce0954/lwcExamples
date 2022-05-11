trigger BrandAssignmentTrigger on Brand_Assignment__c (after insert, after update, after delete, before insert) {
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            Set<Id> brandAssignmentIds = new set<Id>();
            for(Brand_Assignment__c b: Trigger.new){
                brandAssignmentIds.add(b.Id);
            }
            BrandAssignmentTriggerHander.assignPublicGroup(brandAssignmentIds);
        }
        if(Trigger.isDelete){
            Set<Id> brandAssignmentIds = new Set<Id>();
            for(Brand_Assignment__c b: trigger.old){
                brandAssignmentIds.add(b.Id);
            }
            BrandAssignmentTriggerHander.removePublicGroup(brandAssignmentIds);
        }
        if(Trigger.isUpdate){
            Map<Id, Id> groupMemberOldMap = new Map<Id, Id>();
            Map<Id, Id> groupMemberNewMap = new Map<Id, Id>();

            for(Brand_Assignment__c b: Trigger.old){
                groupMemberOldMap.put(b.User__c, b.Brand__c);
            }
            for(Brand_Assignment__c b: Trigger.new){
                groupMemberNewMap.put(b.User__c, b.Brand__c);
            }
            BrandAssignmentTriggerHander.reAssignPublicGroup(groupMemberOldMap, groupMemberNewMap);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            BrandAssignmentTriggerHander handler = new BrandAssignmentTriggerHander();
            handler.isBrandAssignmentExists(Trigger.new);
        }
    }
}