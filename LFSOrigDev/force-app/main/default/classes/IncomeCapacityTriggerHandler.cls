/*
 *Author: Adrian Recio Cloud Sherpas
 *Created Date: March 28, 2014
 *Description: Trigger Handler Class for Income Capacity
 *@History:
    =====================================================================
    21-10-15: Updated Defect 952 - Update parent applicant poi verification type based on income capacity
    verification method
    =====================================================================
 */
public with sharing class IncomeCapacityTriggerHandler {

    public static Boolean fromIncomeCapacityTrigger = false; 
    //Added to fix Sync issue for Proviso
    Map<Id, String> incomeProvisoMap = new Map<Id, String>();
    //**************************************************// 
    // Uncomment this snippet if before insert          //
    // and update conditions is needed in this trigger  //
    //**************************************************//
    /*public void onBeforeInsert(List<Income__c> newRecords) {

    }
    
    public void onBeforeUpdate(List<Income_Capacity__c> oldRecords, List<Income_Capacity__c> newRecords,  
                               Map<ID, Income_Capacity__c> oldMap, Map<ID, Income_Capacity__c> newMap){
                    
    }*/

    public void onAfterInsert(List<Income_Capacity__c> newRecords, Map<ID, Income_Capacity__c> newMap) {
        if(IncomeTriggerHandler.fromIncomeTrigger == false){
            updateIncomeVerifiedAmount(newRecords,newMap,false);
        }
    }
    
    public void onAfterUpdate(List<Income_Capacity__c> oldRecords, List<Income_Capacity__c> newRecords,  
                              Map<ID, Income_Capacity__c> oldMap, Map<ID, Income_Capacity__c> newMap){

        if(IncomeTriggerHandler.fromIncomeTrigger == false){
            updateIncomeVerifiedAmount(newRecords,newMap,false);
        }
    }
    
    public void onAfterDelete(List<Income_Capacity__c> oldRecords, Map<ID, Income_Capacity__c> oldMap){
        if(IncomeTriggerHandler.fromIncomeTrigger == false){
            updateIncomeVerifiedAmount(oldRecords,oldMap,true);
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: March 28, 2014
     *Description: Method to populate verified income amount to parent income of income capacity.
     *@History:
        =====================================================================
        21-10-15: Updated Defect 952 - Update parent applicant poi verification type based on income capacity
        verification method
        =====================================================================
     */
    public void updateIncomeVerifiedAmount(List<Income_Capacity__c> icList, Map<ID, Income_Capacity__c> icMap, Boolean IsDeleteEvent){
        // Pull parent income set
        set<Id>incomeIdSet = new set<Id>();
        list<Income__c>incomeUpdateList = new list<Income__c>();
        map<Id,List<Income_Capacity__c>> otherICMap = new map<Id,List<Income_Capacity__c>>();
        map<Id,List<Income_Capacity__c>> triggerICMap = new map<Id,List<Income_Capacity__c>>();
        
        for(Income_Capacity__c icVar:icList){
            incomeIdSet.add(icVar.Income__c);
        }
        
        // Convert Income Id Set to list
        List<Id> incomeIdList=new List<Id>();
        incomeIdList.addAll(incomeIdSet);

        // Pull parent income details
        //Below SOQL query commented for POI Automation by Suneel 03/02/2021
        //map<Id,Income__c>incomeMap = new Map<Id,Income__c>([Select Id,Income_Amount__c, POI_Amount_Verified__c, Applicant__c from Income__c where Id In :incomeIdSet]);
         map<Id,Income__c>incomeMap = new Map<Id,Income__c>([Select Id,Income_Amount__c,Total_Income__c,POI_Amount_Verified__c,Applicant__c,Applicant__r.Application__r.Brand_Country__c from Income__c where Id In :incomeIdSet]);
    
        // Pull child income capacity
        list<Income_Capacity__c>otherICList = [Select Id,Annualised_Net_Income_per_Month__c,Income__c, Method_of_Verification__c, income__r.Applicant__c from Income_Capacity__c 
                                                where Annualised_Net_Income_per_Month__c!=null 
                                                and Id not In :icMap.keySet() 
                                                and Income__c In :incomeIdSet];
        
        // Build other income capacity map
        for(Income_Capacity__c icVar:otherICList){
            if(otherICMap.get(icVar.Income__c) == null){
                list<Income_Capacity__c>icTempList = new list<Income_Capacity__c>();
                icTempList.add(icVar);
                otherICMap.put(icVar.Income__c,icTempList);
            }else{
                list<Income_Capacity__c>icTempList = otherICMap.get(icVar.Income__c);
                icTempList.add(icVar);
                otherICMap.put(icVar.Income__c,icTempList);
            }
        }
        
        // Build trigger income capacity map
        for(Income_Capacity__c icVar: icList){
            if(triggerICMap.get(icVar.Income__c) == null){
                list<Income_Capacity__c>icTempList = new list<Income_Capacity__c>();
                icTempList.add(icVar);
                triggerICMap.put(icVar.Income__c,icTempList);
            }else{
                if(!otherICMap.keySet().isEmpty()){
                    list<Income_Capacity__c>icTempList = otherICMap.get(icVar.Income__c);
                    icTempList.add(icVar);
                    triggerICMap.put(icVar.Income__c,icTempList);
                }
            }
        }

        //Added by DYU 04-21-2015 Defect 952 - Build income capacity verification method map
        Map<Id, String> incomeVerificationMap = new Map<Id, String>();
        for(Income_Capacity__c icVar: [Select Id,Annualised_Net_Income_per_Month__c,Income__c, Method_of_Verification__c, income__r.Applicant__c,Income__r.Applicant__r.Application__c from Income_Capacity__c 
                                                where Income__c In :incomeIdSet]){
            incomeVerificationMap.put(icVar.income__r.Applicant__c, icvar.Method_of_Verification__c);
            incomeProvisoMap.put(icVar.Income__r.Applicant__r.Application__c, icvar.Method_of_Verification__c);
        }
        
        Decimal totalIncome = 0;
        Decimal totalVerifiedIncome =0;
        Map<Id, Decimal> applicantMap = new Map<Id, Decimal>();
        Map<Id, Decimal> applicantVerifiedMap = new Map<Id, Decimal>();
        List<Decimal> incomeValues = new List<Decimal>();

        // Loop thru parent income Ids
        for(Id incomeId: incomeIdList){
            Income__c iVar = incomeMap.get(incomeId);
            
            if(iVar!=null){
                
                iVar.POI_Amount_Verified__c = 0;
                
                if(otherICMap.get(incomeId)!=null){
                    List<Income_Capacity__c> otherICTempList = otherICMap.get(incomeId);
                    for(Income_Capacity__c icTempVar:otherICTempList){
                        if(icTempVar.Annualised_Net_Income_per_Month__c!=null){
                            iVar.POI_Amount_Verified__c = iVar.POI_Amount_Verified__c + icTempVar.Annualised_Net_Income_per_Month__c;
                            iVar.Verification_Type__c = icTempVar.Method_Of_Verification__c;
                        }
                    }
                }
                
                if(IsDeleteEvent == false){
                    if(triggerICMap.get(incomeId)!=null){
                        List<Income_Capacity__c> triggerICTempList = triggerICMap.get(incomeId);
                        for(Income_Capacity__c icTempVar:triggerICTempList){
                            if(icTempVar.Annualised_Net_Income_per_Month__c!=null){
                                iVar.POI_Amount_Verified__c = iVar.POI_Amount_Verified__c + icTempVar.Annualised_Net_Income_per_Month__c;
                                iVar.Verification_Type__c = icTempVar.Method_Of_Verification__c;
                            }
                        }
                    }
                }
                //Commented as part of Verifier changes Prod Fix
                //iVar.Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH;
                //TXU added to fix Total Income not calculated correctly               
                incomeUpdateList.add(iVar); 
                if(iVar.Applicant__r.Application__r.Brand_Country__c == 'AU'){   
                //Commented as part of Verifier changes Prod Fix            
                //totalIncome += iVar.Income_Amount__c;
                totalIncome += iVar.Total_Income__c;  
               } else if(iVar.Applicant__r.Application__r.Brand_Country__c == 'NZ'){
               totalIncome += iVar.Total_Income__c;  
               }             
                totalVerifiedIncome += iVar.POI_Amount_Verified__c.setScale(2);
                incomeValues.add(iVar.POI_Amount_Verified__c.setScale(2));
                applicantMap.put(iVar.Applicant__c, totalIncome);
                applicantVerifiedMap.put(iVar.Applicant__c, totalVerifiedIncome);
            }
        }
                //Below two lines added for POI Automation by Suneel 04/02/2021
                incomeValues.sort();
                Decimal highestIncome;
                try{
                highestIncome = incomeValues.get(incomeValues.size()-1);
                }catch(Exception e){}
                //End
        
        List<Applicant__c> applicantList = [SELECT Id, Total_Income__c,Capacity_Flag__c,Application__r.Remaining_Capacity__c, Application__c FROM Applicant__c WHERE Id IN: applicantMap.keySet()];
        Set<Id> applicationIds = new Set<Id>();
        if(!applicantList.isEmpty()){
            for(Applicant__c a: applicantList){
                a.Total_Income__c = applicantMap.get(a.Id).setScale(2);
                a.POI_Financial_Situation_Verified__c = false;
                //Updated by DYU 04-21-2015 Defect 952 - Update Applicant verification type to Policy Exception
                //When income capacit verification method is Policy Exception.  This a change in webservice verification type
                //for this specific value only
                if(incomeVerificationMap.get(a.id) != null && incomeVerificationMap.get(a.id) == 'Policy Exception'){   
                    a.POI_Verification_Type__c = incomeVerificationMap.get(a.id);
                }else{
                    a.POI_Verification_Type__c = 'Branch';
                }
                if(incomeVerificationMap.get(a.id) != null && incomeVerificationMap.get(a.id) != 'Verifier' && applicantVerifiedMap.get(a.Id)!=null){
                    a.Capacity_Flag__c = true;
                }
                
                applicationIds.add(a.Application__c);
            }
        }

        try{
            update applicantList;
        } catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'IncomeCapacityTriggerHandler', 'Applicant__c', 'Class', null);
        }
        
        
       //Added by Suneel POI Automation 04/02/2021
     List<Applicant__c> applicantVerifiedList = [SELECT Id, Total_Income__c, Total_Verified_Additional_Income__c,Application__c  FROM Applicant__c WHERE Id IN: applicantVerifiedMap.keySet()];

                      Set<Id> applicationVerifiedIds = new Set<Id>();
                      if(!applicantList.isEmpty()){
                          for(Applicant__c av: applicantVerifiedList){
                          av.Total_Verified_Additional_Income__c= applicantVerifiedMap.get(av.Id).setScale(2) - highestIncome;                
                          applicationVerifiedIds.add(av.Application__c);
                      }
                  }
                        try{
                            update applicantVerifiedList;
                           } catch(DMLException e){
                            ErrorHandlerException.recordException(e.getMessage(), 'IncomeCapacityTriggerHandler', 'Applicant__c', 'Class', null);
                        } 
     
       //End
    // Added coniditon Proviso to stop sync for EPOI
   
      Set<Id> newAppIds = new Set<Id>();
        if(!applicationIds.isEmpty()) {
             for (id applID: applicationIds) {
                 if(incomeProvisoMap.get(applID) != 'Proviso' && incomeProvisoMap.get(applID) != 'Verifier') {
                     newAppIds.add(applID);
                  }
                  
               }  
        DebitTriggerHandler.setAppOutOfSync(newAppIds); 
      }

        // flag static boolean variable to avoid recurssive triggers in income 
        IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger = true;
        try{
            update incomeUpdateList;
        }catch(exception e){
            system.debug('Income Update Error:' + string.valueOf(e));
        }
    }
}