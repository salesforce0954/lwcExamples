trigger UserTrigger on User (after update) {

    UserTriggerHandler userTriggerHandler = new UserTriggerHandler();

    //after
    if(Trigger.isAfter){

        //after update
        if(Trigger.isUpdate){
            //code logic here

            Map<Id,User> personAccountUserMap = new Map<Id,User>();

            for (User u: Trigger.new){

                User oldUser = Trigger.oldMap.get(u.Id);
                if (u.Email!=oldUser.Email || u.FirstName!=oldUser.FirstName || u.LastName!=oldUser.LastName || u.Password_Reset_Token__c != oldUser.Password_Reset_Token__c || u.Title!=oldUser.Title || u.Email!=oldUser.Email || u.First_Name__c != oldUser.First_Name__c || u.Last_Name__c != oldUser.Last_Name__c ||  u.Email__c != oldUser.Email__c){

                    if(u.ContactId != null){
                        personAccountUserMap.put(u.ContactId, u);
                    }
                    
                }

            }

            if(!personAccountUserMap.isEmpty()){
                userTriggerHandler.updateUserContact(personAccountUserMap);
            }

        }

    }

}