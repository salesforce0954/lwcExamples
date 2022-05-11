/*
 *Author: Adrian Recio Cloud Sherpas
 *Created Date: February 18, 2014
 *Description: Trigger Handler Class for Income 
 *History: 2015-12-16 TXU To Calculdate additional income on change of income through POI
 */
public without sharing class IncomeTriggerHandler {
    
    public static Boolean fromIncomeTrigger = false; 
    public static Boolean SixtyDayCertClone = false;
    
    //**************************************************// 
    // Uncomment this snippet if before insert          //
    // and update conditions is needed in this trigger  //
    //**************************************************//
    /*public void onBeforeInsert(List<Income__c> newRecords) {

    }
    
    public void onBeforeUpdate(List<Income__c> oldRecords, List<Income__c> newRecords,  
                               Map<ID, Income__c> oldMap, Map<ID, Income__c> newMap){
                    
    }*/

    public void onBeforeDelete(List<Income__c> oldRecords, Map<ID, Income__c> oldMap) {
        setParentApplicantTotalIncome(oldRecords, oldMap, null, false, true);
    }
    
    public void onAfterInsert(List<Income__c> newRecords, Map<ID, Income__c> newMap) {
        setParentApplicantTotalIncome(newRecords, newMap, null , false, false);
        if(IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger == false && SixtyDayCertClone==false){
            insertIncomeCapacity(newRecords);
        }
    }
    
    public void onAfterUpdate(List<Income__c> oldRecords, List<Income__c> newRecords,  
                              Map<ID, Income__c> oldMap, Map<ID, Income__c> newMap){
        setParentApplicantTotalIncome(newRecords, newMap, oldMap , true, false);                        
        if(IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger == false){
            updateIncomeCapacity(newRecords,newMap);
        }
    }
        
    /*
     *Author: Adrian Recio Cloud Sherpasf
     *Created Date: April 7, 2014
     *Description: Method to populate parent applicants total income
     */
    public void setParentApplicantTotalIncome(List<Income__c>incomeTrigList, Map<ID, Income__c> newMap, Map<ID, Income__c> oldMap, Boolean IsUpdate, Boolean IsDelete){
            
        // Method variable declaration
        set<Id>applicantSet = new set<Id>();
        map<Id, List<Income__c>> appIncomeMap = new map<Id,List<Income__c>>();
        list<Income__c> incomeExistList = new list<Income__c>();
        list<Applicant__c>appUpdateList = new list<Applicant__c>();
        
        for(Income__c incomeVar: incomeTrigList){
            try{
                if(incomeVar.Applicant__c!=null){
                    // Pull applicant Id where POI Amount verified is updated
                    system.debug('Check Income++'+incomeVar.Income_Amount__c);
                    Boolean includeApplicant = true;
                    if(IsUpdate == true){
                        if(oldMap.containsKey(incomeVar.Id)){
                            if(incomeVar.Income_Amount__c == oldMap.get(incomeVar.Id).Income_Amount__c){
                                includeApplicant = false;
                            }
                        }
                    }
                    
                    if(includeApplicant){
                        applicantSet.add(incomeVar.Applicant__c);
                    }
                    
                    if(IsDelete == false){
                        // Build map where applicant is map Id and value is it's child income records stored in a list
                        if(appIncomeMap.get(incomeVar.Applicant__c)==null){
                            List<Income__c>incomeDList = new List<Income__c>();
                            incomeDList.add(incomeVar);
                            appIncomeMap.put(incomeVar.Applicant__c,incomeDList);
                        }else{
                            List<Income__c>incomeDList = appIncomeMap.get(incomeVar.Applicant__c);
                            incomeDList.add(incomeVar);
                            appIncomeMap.put(incomeVar.Applicant__c,incomeDList);
                        }
                    }
                }
            }catch(Exception e){
                incomeVar.addError('An error has occured: '+e.getMessage());

                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setParentApplicantTotalIncome()', 'IncomeTriggerHandler', 'Class', String.valueOf(incomeVar.Applicant__r.Application__c));
            }
        }
        
        // Pull other child income records not in the trigger record list and add it to the map
        incomeExistList = [Select Id,Applicant__c, Income_Amount__c, Total_Income__c from Income__c where Id not In :newMap.keySet() and Applicant__c In :applicantSet];
        
        for(Income__c incomeVar: incomeExistList){
            try{
                if(appIncomeMap.get(incomeVar.Applicant__c)==null){
                    List<Income__c>incomeDList = new List<Income__c>();
                    incomeDList.add(incomeVar);
                    appIncomeMap.put(incomeVar.Applicant__c,incomeDList);
                }else{
                    List<Income__c>incomeDList = appIncomeMap.get(incomeVar.Applicant__c);
                    incomeDList.add(incomeVar);
                    appIncomeMap.put(incomeVar.Applicant__c,incomeDList);
                }
            }catch(Exception e){
                incomeVar.addError('An error has occured: '+e.getMessage());

                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setParentApplicantTotalIncome()', 'IncomeTriggerHandler', 'Class', String.valueOf(incomeVar.Applicant__r.Application__c));
            }
        }
        
        // Convert applicant Id Set to list
        List<Id> applicantIdList=new List<Id>();
        applicantIdList.addAll(applicantSet);
        
        for(Id appId: applicantIdList){
            List<Income__c>incomeList = appIncomeMap.get(appId);
            if(incomeList!=null){
                Decimal totalAmount = 0;
                //2015-12-16 TXU
                Decimal highestIncome = 0;
                for(Income__c incomeVar: incomeList){
                    try{
                        //totalAmount = totalAmount + incomeVar.Income_Amount__c;
                        totalAmount = totalAmount + incomeVar.Total_Income__c;
                        //2015-12-16 TXU
                        if(incomeVar.Total_Income__c > highestIncome){
                            highestIncome = incomeVar.Total_Income__c;
                        }
                    }catch(Exception e){
                        incomeVar.addError('An error has occured: '+e.getMessage());

                        //exception log
                        System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                        ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setParentApplicantTotalIncome()', 'IncomeTriggerHandler', 'Class', String.valueOf(incomeVar.Applicant__r.Application__c));
                    }
                }
                
                Applicant__c appVar = new Applicant__c(Id = appId,Total_Income__c = totalAmount, Additional_Income__c = totalAmount - highestIncome);
                appUpdateList.add(appVar);
            }
        }
        
        // Update parent applicant total income records
        if(appUpdateList.size()>0){
            update appUpdateList;
        }
        
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 18, 2014
     *Description: Method to populate income capacity 
                 records based on inserted income records
     */
    public void insertIncomeCapacity(List<Income__c> incomeList){
        // Instantiate new income capacity list
        List<Income_Capacity__c>icList = new List<Income_Capacity__c>();
         system.debug('Inside Insert Income Capacity ++');
                        
        for(Income__c incomeVar: incomeList){
            try{
                // Instantiate new Income Record
                Income_Capacity__c icVar = new Income_Capacity__c();
                
                // Populate updates to child income capacity
                populateIncomeCapacity(incomeVar,icVar,false);
                 system.debug('Inserted Income Capacity ++');
                
                icList.add(icVar);

            }catch(Exception e){
                incomeVar.addError('An error has occured: '+e.getMessage());

                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setParentApplicantTotalIncome()', 'IncomeTriggerHandler', 'Class', String.valueOf(incomeVar.Applicant__r.Application__c));
            }
        }
        
        if(icList.size()>0){
            // flag static boolean variable to avoid recurssive triggers in income capacity
            IncomeTriggerHandler.fromIncomeTrigger = true;
            insert icList;
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 18, 2014
     *Description: Method to update child income capacity records
                 based on updated values of it's parent income
     */
    public void updateIncomeCapacity(List<Income__c> incomeList, Map<Id,Income__c> incomeMap){

        // Method Variable Declaration
        List<Income_Capacity__c> icUpdateList = new List<Income_Capacity__c>(); // List to income capacity records for update
        //Map<Id, Income_Capacity__c> icMap = new Map<Id, Income_Capacity__c>();    // Map to hold income capacity records where Id is it's parent Income
        Map<Id, List<Income_Capacity__c>> icMap = new Map<Id, List<Income_Capacity__c>>();  // Map to hold income capacity records where Id is it's parent Income
        
        // Pull child income capacity records of updated income records
        List<Income_Capacity__c> icList = [Select Id,Employment_Type__c,Income__c from Income_Capacity__c where Income__c In :incomeMap.keySet()];
        
        List<Income_Capacity__c> incomeCapacityToInsert = new List<Income_Capacity__c>();

        // Build Income Capacity Map
        //for(Income_Capacity__c icVar: icList){
        //  icMap.put(icVar.Income__c,icVar);
        //}
        
        for(Income_Capacity__c icVar: icList){
            if(icMap.containsKey(icVar.Income__c)){
                icMap.get(icVar.Income__c).add(icVar);
            } else {
                List<Income_Capacity__c> tempList = new List<Income_Capacity__c>();
                tempList.add(icVar);
                icMap.put(icVar.Income__c, tempList);
            }
        }

        // Populate updates to child income capacity from it's parent income record
        for(Income__c incomeVar: incomeList){
            try{
                // Pull child income capacity record related to the current income record
                //Income_Capacity__c icVar = icMap.get(incomeVar.Id);
                
                //if(icVar!=null){
                //  // Populate updates to child income capacity
                //  populateIncomeCapacity(incomeVar,icVar,true);
                    
                //  icUpdateList.add(icVar);
                //}

                for(Income_Capacity__c ic: icMap.get(incomeVar.Id)){
                    // Pull child income capacity record related to the current income record
                    Income_Capacity__c icVar = ic;
                    
                    if(ic!=null){
                        // Populate updates to child income capacity
                        populateIncomeCapacity(incomeVar, ic, true);
                        
                        icUpdateList.add(ic);
                    }
                }

            }catch(Exception e){
                incomeVar.addError('An error has occured: '+e.getMessage());

                //exception log
                System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'setParentApplicantTotalIncome()', 'IncomeTriggerHandler', 'Class', String.valueOf(incomeVar.Applicant__r.Application__c));
            }
        }
        
        if(!incomeCapacityToInsert.isEmpty()){
            insert incomeCapacityToInsert;
        }

        if(icUpdateList.size()>0){
            // flag static boolean variable to avoid recurssive triggers in income capacity
            IncomeTriggerHandler.fromIncomeTrigger = true;
            update icUpdateList;
        }
    }
    
    /*
     *Author: Adrian Recio Cloud Sherpas
     *Created Date: February 19, 2014
     *Description: Method that performs assignment of income capacity record values based on it's parent income
     */
    public void populateIncomeCapacity(Income__c incomeVar, Income_Capacity__c icVar, Boolean IsUpdate){
        If(IsUpdate == false){
            icVar.Income__c = incomeVar.Id;
        }
        //icVar.Employment_Type__c = incomeVar.Income_Source__c;
    }

    /*
    *   Replacement for the Income_Capacity__c.Income_Detail__c formula field as cannot comtain encrypted fields
    */
    public void setIncomeCapacityFields(List<Income__c> incomes, Map<Id,Income__c> oldIncomeMap){
        Map<Id, Income__c> incomesWithCapsMap = new Map<Id, Income__c>([select Id, Income_Source__c, (select Id from Income_Capacities_Calculator__r) from Income__c where Id in :incomes]);

        List<Income_Capacity__c> incomeCapacities;
        List<Income_Capacity__c> incomeCapacitiesToUpdate;
        for(Income__c income : incomes){
            if(oldIncomeMap.containsKey(income.Id) && (income.Income_Source__c != oldIncomeMap.get(income.Id).Income_Source__c || income.Emp_Bus_Name__c != oldIncomeMap.get(income.Id).Emp_Bus_Name__c)){
                incomeCapacities = incomesWithCapsMap.get(income.Id).Income_Capacities_Calculator__r;

                for(Income_Capacity__c cap : incomeCapacities){
                    cap.Income_Detail__c = income.Income_Source__c + ' ' + income.Emp_Bus_Name__c;
                }
                incomeCapacitiesToUpdate.addAll(incomeCapacities);
            }
        }

        update incomeCapacitiesToUpdate;
    }
}