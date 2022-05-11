/*
Author: Russell Cadapan Cloud Sherpas
Created Date: November 4, 2013
Description: Trigger handler for Brand Assignment object
*/


Public class BrandAssignmentTriggerHander{
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: November 4, 2013
    Description: Method to assign the user to the brand's public group
    */

    @future
    public static void assignPublicGroup(Set<Id> bAssignmentIds){
        List<Brand_Assignment__c> brandAssignmentList = new List<Brand_ASsignment__c>();
        brandAssignmentList = [SELECT Id, User__c, Brand__c FROM Brand_Assignment__c WHERE Id IN: bAssignmentIds];

        Set<Id> userId = new Set<Id>();
        Set<Id> groupId = new Set<Id>();
        Set<Id> brandId = new set<Id>();

        List<GroupMember> groupMemberList = new List<GroupMember>();
        Map<Id, Brand__c> brandMap = new Map<Id, Brand__c>();

        for(Brand_Assignment__c b: brandAssignmentList){
            userId.add(b.User__c);
            brandId.add(b.Brand__c);
        }

        List<Brand__c> brList = new List<Brand__c>();
        brList = [SELECT ID, Public_Group_Id__c FROM Brand__c WHERE Id IN: brandId];

        for(Brand__c b: brList){
            brandMap.put(b.Id, b);
        }

        for(Brand_Assignment__c b: brandAssignmentList){
            if(brandMap.get(b.Brand__c).Public_Group_Id__c != null){
                Id pGroupId = brandMap.get(b.Brand__c).Public_Group_Id__c;
                if(Util.isIdTypeOfObject(pGroupId, Group.sObjectType)){
                    GroupMember g = new GroupMember();
                    g.UserOrGroupId = b.User__c;
                    g.GroupId = brandMap.get(b.Brand__c).Public_Group_Id__c;
                    groupMemberList.add(g);
                }
            }
        }

        if(groupMemberList.size() > 0 ){
            insert groupMemberList;
        }   
    }
    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: November 4, 2013
    Description: Method to remove the user to the brand's public group when brand assignment is deleted
    */
    @Future
    public static void removePublicGroup(Set<Id> bAssignmentIds){
        Set<Id> userId = new Set<Id>();
        Set<Id> groupId = new Set<Id>();
        Set<Id> brandId = new set<Id>();
        Set<String> groupMember = new Set<String>();
        Map<Id, Brand__c> brandMap = new Map<Id, Brand__c>();
        List<GroupMember> groupMemberList = new List<GroupMember>();
        List<GroupMember> groupMemberListToDelete = new List<GroupMember>();
        List<Brand_Assignment__c> brandList = new List<Brand_Assignment__c>();
        System.debug('###bAssignmentIds: ' + bAssignmentIds);
        brandList = [SELECT Id, User__c, Brand__c FROM Brand_Assignment__c WHERE ID IN: bAssignmentIds ALL ROWS];
        System.debug('###brandList: ' + brandList);
        for(Brand_Assignment__c b: brandList){
            userId.add(b.User__c);
            brandId.add(b.Brand__c);
        }

        List<Brand__c> brList = new List<Brand__c>();
        brList = [SELECT ID, Public_Group_Id__c FROM Brand__c WHERE Id IN: brandId];

        for(Brand__c b: brList){
            brandMap.put(b.Id, b);
        }

        
        for(Brand_Assignment__c b: brandList){
            groupId.add(brandMap.get(b.Brand__c).Public_Group_Id__c);
            if(b.Brand__c != null && b.User__c != null){
                groupMember.add((String.valueOf(b.User__c).subString(0,15) + String.valueOf(brandMap.get(b.Brand__c).Public_Group_Id__c).subString(0,15)));
            }
        }

        groupMemberList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: groupId AND UserOrGroupId IN: userId];

        if(groupMemberList.size() > 0){
            for(GroupMember g: groupMemberList){
                String user = String.valueOf(g.UserOrGroupId).subString(0,15);
                String groupName = String.valueOf(g.GroupId).subString(0,15);
                System.debug('groupMember: ' + (user+groupName));
                if(groupMember.contains(user+groupName)){
                    groupMemberListToDelete.add(g);
                }
            }
            if(groupMemberListToDelete.size() > 0){
                delete groupMemberListToDelete;
            }
        } 
    }
    @Future
    public static void reAssignPublicGroup(Map<Id, Id> oldMemberMap, Map<Id, Id> newMemberMap){
        List<GroupMember> existingGroupMemberList = new List<GroupMember>();

        Set<Id> oldUserId = new Set<Id>();
        Set<Id> oldGroupId = new Set<Id>();
        Set<Id> oldBrandId = new Set<Id>();
        Set<String> oldMember = new Set<String>();
        Map<Id, Brand__c> brandMap = new Map<Id, Brand__c>();
        List<GroupMember> memberListToRemove = new List<GroupMember>();

        for(Id id: oldMemberMap.keySet()){
            oldUserId.add(id);
            oldBrandId.add(oldMemberMap.get(id));
        }

        List<Brand__c> brList = new List<Brand__c>();
        brList = [SELECT ID, Public_Group_Id__c FROM Brand__c WHERE Id IN: oldbrandId];

        for(Brand__c b: brList){
            brandMap.put(b.Id, b);
        }

        for(Id id: oldMemberMap.keySet()){
            oldGroupId.add(BrandMap.get(oldMemberMap.get(id)).Public_Group_Id__c);
            oldMember.add(String.valueOf(id).subString(0,15) + String.valueOf(BrandMap.get(oldMemberMap.get(id)).Public_Group_Id__c).subString(0,15) );
        }

        existingGroupMemberList = [SELECT Id, UserOrGroupId, GroupId FROM GroupMember where UserOrGroupId IN: oldUserId AND GroupId IN: oldGroupId];
        
        for(GroupMember g: existingGroupMemberList){
            String user = String.valueOf(g.UserOrGroupId).subString(0,15);
            String groupName = String.valueOf(g.groupId).subString(0,15);

            if(oldMember.contains(user+groupName)){
                memberListToRemove.add(g);
            }
        }

        if(memberListToRemove.size() > 0){
            delete memberListToRemove;
        }

        Set<Id> newUSerId = new Set<Id>();
        Set<Id> newGroupId = new Set<Id>();
        Set<Id> newBrandId = new Set<Id>();
        Set<String> newMember = new Set<String>();
        Map<Id, Brand__c> newBrandMap = new Map<Id, Brand__c>();
        List<GroupMember> groupMemberListToInsert = new List<GroupMember>();

        for(Id id: newMemberMap.keySet()){
            newUserId.add(id);
            newBrandId.add(newMemberMap.get(id));
        }

        brList = new List<Brand__c>();
        brList = [SELECT ID, Public_Group_Id__c FROM Brand__c WHERE ID IN: newBrandid];

        for(Brand__c b: brList){
            newBrandMap.put(b.Id, b);
        }

        for(Id id: newMemberMap.keySet()){
            if(newBrandMap.get(newMemberMap.get(id)).Public_Group_Id__c != null){
                GroupMember groupTemp = new GroupMember();
                groupTemp.UserOrGroupId = id;
                groupTemp.GroupId = newBrandMap.get(newMemberMap.get(id)).Public_Group_Id__c;
                groupMemberListToInsert.add(groupTemp);
            }
        }

        if(groupMemberListToInsert.size() > 0){
            insert groupMemberListToInsert;
        }
    }
    public void isBrandAssignmentExists(List<Brand_Assignment__c> bAssignmentList){
        

        Set<String> existingBrandAssignment = new Set<String>();
        Set<Id> brandId = new Set<Id>();
        Set<Id> userId = new Set<Id>();
        Set<String> memberId = new Set<String>();

        List<Brand_Assignment__c> existingBrandAssignmentList = new List<Brand_Assignment__c>();

        Map<String, Group> groupMap = new Map<String, Group>();
        List<Group> groupList = new List<Group>([SELECT Id FROM Group WHERE Type =: 'Regular']);

        for(Group g: groupList){
            String grId = String.valueOf(g.Id).subString(0,15);
            groupMap.put(grId, g);
        }

        Map<String, Brand__c> brandMap = new Map<String, Brand__c>();
        List<Brand__c> brandList = new List<Brand__c>([SELECT Id, Public_Group_Id__c FROM Brand__c]);
        for(Brand__c b: brandList){
            String brId = String.valueOf(b.Id).subString(0,15);
            brandMap.put(brId, b);
        }


        for(Brand_Assignment__c b: bAssignmentList){
            if(b.User__c != null && b.Brand__c != null){
                String brId = String.valueOf(b.Brand__c).subString(0,15);
                if(brandMap.get(brId).Public_Group_Id__c != null){
                    String pGroupId = String.valueOf(brandMap.get(brId).Public_Group_Id__c);
                    if(groupMap.containsKey(pGroupId)){
                        userId.add(b.User__c);
                        brandId.add(b.Brand__c);
                        memberId.add(String.valueOf(b.User__c).subString(0,15) + String.valueOf(b.Brand__c).subString(0,15));
                    }else{
                        b.Brand__c.addError('Invalid public group Id.');
                    }
                }
            }
        }

        existingBrandAssignmentList = [SELECT Id, User__c, Brand__c FROM Brand_Assignment__c WHERE User__c IN: userId AND Brand__c IN: brandId];

        if(existingBrandAssignmentList.size() > 0){
            for(Brand_Assignment__c b: existingBrandAssignmentList){
                existingBrandAssignment.add(String.valueOf(b.User__c).subString(1,15) + String.valueOf(b.Brand__c).subString(1,15));
            }

            for(Brand_Assignment__c b: bAssignmentList){
                String user = String.valueOf(b.User__c).subString(1,15);
                String brand = String.valueOf(b.Brand__c).subString(1,15);
                if(existingBrandAssignment.contains(user+brand)){
                    b.User__c.addError('Brand assignment already exists.');
                }
            }
        }
    }
}