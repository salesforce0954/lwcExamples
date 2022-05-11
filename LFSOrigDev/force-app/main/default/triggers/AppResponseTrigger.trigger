/*
Author: Michael Lasala Cloud Sherpas
Created Date: September 17, 2013
Description: Trigger timings for Application Response object
Update: 2015-03-04 Tony Xu Added a new type of app response for Retrieve Payoff Amount, which does not need to fire insert trigger
*/

trigger AppResponseTrigger on Application_Response__c (before insert, after insert, after update) {

    List<Application_Response__c> arToBeProcessed = new List<Application_Response__c>();
    for(Application_Response__c ar : trigger.new){
        if(ar.Retrieve_Payoff_Response__c == false)    
            arToBeProcessed.add(ar);
    }

    AppResponseTriggerHandler trig = new AppResponseTriggerHandler();
    
    //Populate response recieved date and time with secords
    if(Trigger.isBefore){
        trig.populateDateTimeOnAppRes(trigger.new);
    }

    if(Trigger.isAfter){

        if(Trigger.isInsert){
            if(arToBeProcessed.size() > 0){
                trig.populateApplicationFields(arToBeProcessed);    //Method that populates the Fields on the Application from the App Response
                trig.createDecision(arToBeProcessed);   //Insert decisions that is compared response code
            }
        }
        
        if(Trigger.isUpdate){
            Map<Id, String> applicationRespMap = new Map<Id, String>();
            //Map Application Response code to it's corresponding Application
            for(Application_Response__c appRes: Trigger.new){
                applicationRespMap.put(appRes.Application__c, appRes.Response_Code__c);
            }
             if(applicationRespMap.size()>0){
                trig.updateApplication(applicationRespMap);     //Update Application Response Code
            }
        }
        
        //needed for rules engine call
        List<Id> appResIdFullList = new List<Id>();
        for(Application_Response__c appRes: Trigger.new){
            appResIdFullList.add(appRes.id);
        }
        //Run offer rules on the Application
        RUL_Engine.runOfferEngineAsync(appResIdFullList);
    }    
}