/* @Description: Trigger for Debit object
 * @Author: Mike Lasala
 * @Date Created: MAR-07-2014
 * @History:
   =====================================================================
       03-07-14: Created - Mike
   =====================================================================
 */ 
trigger DebitTrigger on Debit__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    DebitTriggerHandler handler = new DebitTriggerHandler();
    AccessControlTriggerHandler accessControl = new AccessControlTriggerHandler();
	list<sobject> debitLst=new list<sobject>();
	
    if((Trigger.isBefore && Trigger.isInsert) || 
       (Trigger.isAfter && Trigger.isUndelete)){
        if(Trigger.isInsert){        
            handler.checkDebitRecordCount(trigger.new, true);
        }
        if(Trigger.isUndelete){
            handler.checkDebitRecordCount(trigger.new, false);
            AccessControlTriggerHandler act = new AccessControlTriggerHandler();
            act.blockUndelete(Trigger.new);
        }
    }

    //before
    if(Trigger.isBefore){
        //before insert
        if(Trigger.isInsert){
            //code logic here
            
            //Defect Fix #689
            handler.createBSBValue(Trigger.New);
            
            
            for(Debit__c d: Trigger.new){

                Boolean flag = true;
                flag = accessControl.insertDebit(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to insert a record.');
                }

            }
            
            //Added by vijay Start
            if(Profile_Country__c.getInstance().NZ__c) {
	            for(Debit__c d: Trigger.new){
	            	if((d.Account_Number__c!=null && d.Account_Number__c!='') && (d.Bank_Number__c!=null && d.Bank_Number__c!='')
	            				&& (d.Branch_Number__c!=null && d.Branch_Number__c!='') && (d.Suffix_Number__c!=null && d.Suffix_Number__c!='')){
	            		debitLst.add((sobject)d);
	            	}	
	            }
	            if(!debitLst.isEmpty()){
	            	bankAcctValidationHelperClass.validateAcct(debitLst,'Debit');
	            }
            } 
            //Added by vijay End  
        }
        //before update
        if(Trigger.isUpdate){
            //code logic here
            
            
            //Defect Fix #689
            handler.createBSBValue(Trigger.New);
            
            
            for(Debit__c d: Trigger.new){
                
                Boolean flag = true;
                flag = accessControl.updateDebit(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to update a record.');
                }

            }
            //Added by vijay Start
            if(Profile_Country__c.getInstance().NZ__c) {
	            for(Debit__c d: Trigger.new){
	            	if((d.Account_Number__c!=null && d.Account_Number__c!='') && (d.Bank_Number__c!=null && d.Bank_Number__c!='')
	            				&& (d.Branch_Number__c!=null && d.Branch_Number__c!='') && (d.Suffix_Number__c!=null && d.Suffix_Number__c!='')){
	            		debitLst.add((sobject)d);
	            	}	
	            }
	            if(!debitLst.isEmpty()){
	            	bankAcctValidationHelperClass.validateAcct(debitLst,'Debit');
	            }
            }
            //Added by vijay End  
        }
        //before delete
        if(Trigger.isDelete){
            //code logic here
            for(Debit__c d: Trigger.old){

                Boolean flag = true;
                flag = accessControl.deleteCollateral(d.Response_Code__c);

                if(!flag){
                    d.addError('Application status already Accepted. You are no longer allowed to delete a record.');
                }

            }
        }
    }

    //after
    if(Trigger.isAfter){
        Set<Id> appIds = new Set<Id>();
        //after insert
        if(Trigger.isInsert){
            for(Debit__c d: Trigger.new){
                appIds.add(d.Application__c);
            }
        }
        //after update
        if(Trigger.isUpdate){
            for(Debit__c d: Trigger.new){
                
                Debit__c oldDebit = Trigger.oldMap.get(d.ID);
                if(oldDebit != d){
                    appIds.add(d.Application__c);
                }                
            }
        }
        //after delete
        if(Trigger.isDelete){
            for(Debit__c d: Trigger.old){
                appIds.add(d.Application__c);
            }
        }
        
        if(appIds.size()>0){
            DebitTriggerHandler.setAppOutOfSync(appIds);
        }
    }
}