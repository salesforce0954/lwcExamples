/*
 * @Description: Credit Ref Check trigger
 * @Author: Jade Serrano
 * @Date Created: 02-FEB-2014
 * @History:
 * =====================================================================
 *     Jade - 10-FEB-2014: Created
 * =====================================================================
 */
trigger CreditRefCheckTrigger on Credit_Ref_Check__c (before insert, before update, after insert, after update, after undelete) {

	AccessControlTriggerHandler acth = new AccessControlTriggerHandler();

	//before
    if(Trigger.isBefore){
        //before insert
        if(Trigger.isInsert){
            //check profile access
            for(Credit_Ref_Check__c c: Trigger.new){
                Boolean authorized;
            	authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Credit_Ref_Check__c');
            	if(!authorized){
            		c.addError('You are not authorized to access this item');
            	}
            	Boolean appStatus;
                appStatus = acth.publisherResponseCodeControl(c.Response_Code__c, 'Credit_Ref_Check__c');
            	if(!appStatus){
            		c.addError('Item cannot be created at the current Application Status');
            	}
            }   
        }
    }

    //after
    if(Trigger.isAfter){

        if(Trigger.isUndelete){
            AccessControlTriggerHandler act = new AccessControlTriggerHandler();
            act.blockUndelete(Trigger.new);
        }
    }

}