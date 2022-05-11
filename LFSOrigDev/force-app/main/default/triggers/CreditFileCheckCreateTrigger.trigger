/*
Author: Michael Lasala Cloud Sherpas
Created Date: January 6, 2013
Description: Class for Credit File Check Triggers
*/

trigger CreditFileCheckCreateTrigger on Credit_File_Check__c (before insert, before update, after insert, after update, after delete) {

    AppTriggerClass handler = new AppTriggerClass();
    AccessControlTriggerHandler acth = new AccessControlTriggerHandler();

    //before
    if(Trigger.isBefore){
        //before insert
        if(Trigger.isInsert){      
            for(Credit_File_Check__c c: Trigger.new){
                Boolean authorized;
                authorized = acth.publisherProfileControl(UserInfo.getProfileId(), 'Credit_File_Check__c');
                if(!authorized){
                    c.addError('You are not authorized to access this item');
                }

                Boolean appStatus;
                appStatus = acth.publisherResponseCodeControl(c.Response_Code__c, 'Credit_File_Check__c');
                if(!appStatus){
                    c.addError('Item cannot be created at the current Application Status');
                }
            }            
        }
    }

    //after
    if(Trigger.isAfter){
        //after insert
        if(Trigger.isInsert){
            Set<Id> appIds = new Set<Id>();
            for(Credit_File_Check__c cfc: Trigger.new){
                appIds.add(cfc.Applicant__c);
            }
            handler.updateCreditFileCheckbox(appIds);
        }

        //after delete
        if(Trigger.isDelete){
            Set<Id> appIds = new Set<Id>();
            for(Credit_File_Check__c cfc: Trigger.old){
                appIds.add(cfc.Applicant__c);
            }
            handler.verifyDeletedCFC(appIds);
        }
    }

}