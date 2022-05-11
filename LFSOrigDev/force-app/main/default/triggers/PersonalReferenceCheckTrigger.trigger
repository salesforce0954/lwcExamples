/*
 * @Description: Personal Reference Check trigger
 * @Author: Jade Serrano
 * @Date Created: 02-FEB-2014
 * @History:
 * =====================================================================
 *     Jade - 10-FEB-2014: Created
 * =====================================================================
 */
trigger PersonalReferenceCheckTrigger on Personal_Reference_Check__c (before insert, before update, after insert, after update) {

	AccessControlTriggerHandler acth = new AccessControlTriggerHandler();

	//before
    if(Trigger.isBefore){
        //before insert
        if(Trigger.isInsert){
            //check profile access         
            for(Personal_Reference_Check__c p: Trigger.new){
                Boolean authorized;
            	authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Personal_Reference_Check__c');
            	if(!authorized){
            		p.addError('You are not authorized to access this item');
            	}
                Boolean appStatus;
            	appStatus = acth.publisherResponseCodeControl(p.Response_Code__c, 'Personal_Reference_Check__c');
                
            	if(!appStatus){
            		p.addError('Item cannot be created at the current Application Status');
            	}
            }

            acth.validatePersonalRefCheckCount(Trigger.new);
        }
    }


}