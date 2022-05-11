/*
 *Author: Adrian Recio Cloud Sherpas
 *Created Date: March 28, 2014
 *Description: Test Class for IncomeCapacityTriggerHandler Class
 */
 @IsTest
public with sharing class IncomeCapacityTriggerHandlerTest {
    public static testMethod void testIncomeCapacityTrigger(){
        // Instantiate IncomeTriggerHandler Class
        IncomeTriggerHandler iTrigHandler = new IncomeTriggerHandler();
        List<Income__c>inList = new List<Income__c>();
        Map<Id,Income__c>inMap = new Map<Id,Income__c>();
        
        // Create Test Person Account
        List<Account> accList = testDataBuilder.createPersonAccounts(1);
        accList[0].RecordTypeId = testDataBuilder.AccountRecordTypeInfo .get('Originations - Customer').getRecordTypeId();
        insert accList;
        
        // Create Test Application
        Application__c appVar = testDataBuilder.createApplication();
        insert appVar;
        
        // Create Applicant
        Applicant__c appliVar = testDataBuilder.createApplicant(accList[0].Id, appVar.Id);
        insert appliVar;
        
        // Create Test Income
        Income__c inVar = testDataBuilder.createIncome(appliVar.Id);
        insert inVar;
        IncomeTriggerHandler.fromIncomeTrigger = false;
        test.startTest();
            // Reset recurssive trigger flag
            IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger = false;
            
            // verify that a child income capacity is auto created
            // Pull updated capacity details                            
            Income_Capacity__c icVarAuto = [Select Id,Income__c, Employment_Type__c, Frequency_of_Payment__c, 
                                              Method_of_Calculation__c, Method_of_Verification__c , Annualised_Net_Income_per_Month__c
                                              from Income_Capacity__c where Income__c = :inVar.Id limit 1];
            
            icVarAuto.Annualised_Net_Income_per_Month__c = 100;
            update icVarAuto;

            // Assert parent income poi amount verified
            inVar = [Select Id, POI_Amount_Verified__c from Income__c where Id = :inVar.Id];
            system.assertEquals(100, inVar.POI_Amount_Verified__c);
            
            // Reset recurssive flag    
            IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger = false;       
            // Create child income capacity                             
            Income_Capacity__c icVarUpdate = testDataBuilder.createIncomeCapacity(inVar.Id);
            icVarUpdate.Annualised_Net_Income_per_Month__c = 100; 
            insert icVarUpdate;
            // Assert parent income poi amount verified
            inVar = [Select Id, POI_Amount_Verified__c from Income__c where Id = :inVar.Id];
            system.assertEquals(200, inVar.POI_Amount_Verified__c);
            
            // Reset recurssive flag    
            IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger = false;
            // Update child income capacity
            icVarUpdate.Annualised_Net_Income_per_Month__c = 200; 
            update icVarUpdate;
            // Assert parent income poi amount verified
            inVar = [Select Id, POI_Amount_Verified__c from Income__c where Id = :inVar.Id];
            system.assertEquals(300, inVar.POI_Amount_Verified__c);
            
            // Reset recurssive flag    
            IncomeCapacityTriggerHandler.fromIncomeCapacityTrigger = false;
            // delete child income capacity
            delete icVarUpdate;
            // Assert parent income poi amount verified
            inVar = [Select Id, POI_Amount_Verified__c from Income__c where Id = :inVar.Id];
            system.assertEquals(100, inVar.POI_Amount_Verified__c);
            
        test.stopTest();
    }
}