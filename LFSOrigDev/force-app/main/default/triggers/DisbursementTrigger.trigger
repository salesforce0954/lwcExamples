/*
Author: August Del Rosario Cloud Sherpas
Created Date: Febuary 07, 2014
Description: Trigger for Disbursement
*/
trigger DisbursementTrigger on Disbursement__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    DisbursementTriggerHandler handler = new DisbursementTriggerHandler();
    AccessControlTriggerHandler accessControl = new AccessControlTriggerHandler();
    list<sobject> disObjLst=new list<sobject>();
    //before
    if(Trigger.isBefore){
        //before insert
        if(Trigger.isInsert){
            //code logic here
            
            //Commented out the code - Fel Saliba 1/7/2014
            //handler.saveDisbursement(trigger.new);
            for(Disbursement__c d: Trigger.new){
                
                Boolean flag = true;
                flag = accessControl.insertDisbursement(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to insert a record.');
                }

            }
            handler.populateDisbursementFields(Trigger.new,NULL);
            //Added by vijay Start
            if(Profile_Country__c.getInstance().NZ__c) {
                for(Disbursement__c d: Trigger.new){
                    if((d.Bank_Acc_No__c!=null && d.Bank_Acc_No__c!='') && (d.Bank_Number__c!=null && d.Bank_Number__c!='')
                                && (d.Branch_Number__c!=null && d.Branch_Number__c!='') && (d.Suffix_Number__c!=null && d.Suffix_Number__c!='') ){
                        disObjLst.add((sobject)d);
                    }
                }
                if(!disObjLst.isEmpty()){
                    bankAcctValidationHelperClass.validateAcct(disObjLst,'Disbursement');
                     
                }
            } 
            //Added by vijay End          
        }
        //before update
        if(Trigger.isUpdate){
            //code logic here
            
            //Commented out the code - Fel Saliba 1/7/2014
            //handler.saveDisbursement(trigger.new)
            for(Disbursement__c d: Trigger.new){
                
                Boolean flag = true;
                flag = accessControl.insertDisbursement(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to insert a record.');
                }

            }   
            handler.populateDisbursementFields(Trigger.new,Trigger.oldMap);
            //Added by vijay Start
            if(Profile_Country__c.getInstance().NZ__c) {
                for(Disbursement__c d: Trigger.new){
                    if((d.Bank_Acc_No__c!=null && d.Bank_Acc_No__c!='') && (d.Bank_Number__c!=null && d.Bank_Number__c!='')
                                && (d.Branch_Number__c!=null && d.Branch_Number__c!='') && (d.Suffix_Number__c!=null && d.Suffix_Number__c!='') ){
                        disObjLst.add((sobject)d);
                    }
                }
                if(!disObjLst.isEmpty()){
                    bankAcctValidationHelperClass.validateAcct(disObjLst,'Disbursement');
                }
            }
            //Added by vijay End            
        }
        //before delete
        if(Trigger.isDelete){
            //code logic here
            for(Disbursement__c d: Trigger.old){

                Boolean flag = true;
                flag = accessControl.deleteDisbursement(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to delete a record.');
                }

            }  
        }
    }

    //after
    if(Trigger.isAfter){
        Set<Id> appIds = new Set<Id>();
        Set<Id> appIdsToFlush = new Set<Id>();

        //after insert
        if(Trigger.isInsert){
            for(Disbursement__c d: Trigger.new){
                appIds.add(d.Application__c);
            }
        }
        //after update
        if(Trigger.isUpdate){
            for(Disbursement__c d: Trigger.new){
                
                Disbursement__c oldDisbursement = Trigger.oldMap.get(d.ID);
                //put logic in here
                if(oldDisbursement != d){
                    appIds.add(d.Application__c);
                }

                if(oldDisbursement.Record_Type_Name__c == 'Broker Fee' && d.Record_Type_Name__c == 'Broker Fee' && 
                   oldDisbursement.Amount__c != d.Amount__c){

                    appIdsToFlush.add(d.Application__c);
                }
            }
        }
        //after delete
        if(Trigger.isDelete){
            for(Disbursement__c d: Trigger.old){
                appIds.add(d.Application__c);
            }
        }
        
        if(appIds.size()>0){
            DebitTriggerHandler.setAppOutOfSync(appIds);
        }

        if(!appIdsToFlush.isEmpty()){
            handler.flushInsurance(appIdsToFlush);
        }

        if(Trigger.isUndelete){
            AccessControlTriggerHandler act = new AccessControlTriggerHandler();
            act.blockUndelete(Trigger.new);
        }
    }
}