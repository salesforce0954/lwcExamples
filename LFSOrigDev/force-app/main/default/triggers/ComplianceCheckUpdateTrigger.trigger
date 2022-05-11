/*
Author: Michael Lasala Cloud Sherpas
Created Date: January 8, 2013
Description: Class for Compliance Check Triggers
*/

trigger ComplianceCheckUpdateTrigger on Compliance_Check__c (before update) {

    AppTriggerClass handler = new AppTriggerClass();
    
    if(Trigger.isBefore && Trigger.isUpdate){
        List<Compliance_Check__c> compCheckPFRList = new List<Compliance_Check__c>();
        List<Compliance_Check__c> compCheckBMList = new List<Compliance_Check__c>();
        
        for(Compliance_Check__c cc: Trigger.new){
            Compliance_Check__c beforeUpdate = System.Trigger.oldMap.get(cc.Id);
            if (Trigger.oldMap.get(cc.Id).PFR_Check__c != Trigger.newMap.get(cc.Id).PFR_Check__c ){
                compCheckPFRList.add(cc);
            }
            if (Trigger.oldMap.get(cc.Id).BM_Check__c != Trigger.newMap.get(cc.Id).BM_Check__c){
                compCheckBMList.add(cc);
            }
        }
        
        if(!compCheckPFRList.isEmpty()){
            handler.updateComplianceDate(compCheckPFRList, 'PFR');
        }
        
        if(!compCheckBMList.isEmpty()){
            handler.updateComplianceDate(compCheckBMList, 'BM');
        }
    }
}