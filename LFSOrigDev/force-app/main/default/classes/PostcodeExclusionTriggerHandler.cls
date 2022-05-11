/**
* @author Original: Adrian Recio Cloud Sherpas
* @date Original: 11 Feb 2013 
* @description Class to handle PostcodeExclusionTrigger Logic
*/

public with sharing class PostcodeExclusionTriggerHandler {

    /**
    * @author Original: Adrian Recio Cloud Sherpas
    * @date Original: 11 Feb 2013
    * @description  
    * @param 
    */   
    public void setPostCode(List<Postcode_Exclusion__c> pcExclusionList, string EventStr){
        
         // Variable Declaration
         set<String>pcSet = new set<String>();
         
         // Put postcodes in a set
         for(PostCode_Exclusion__c peVar: pcExclusionList){
            pcSet.add(peVar.Postcode__c);
         }// End For
         system.debug('code set:' + pcSet);
         List<Opportunity> exclusionUpdateList = new List<Opportunity>();

         for(List<Opportunity> oppDummyList:[Select Id, 
                                                    Branch_Name__c, 
                                                    Branch_Postcode__c, 
                                                    PostCode_Exclusion__c from 
                                                    Opportunity where 
                                                    Branch_Postcode__c!=null 
                                                    and Branch_Postcode__c In :pcSet]){
        
             for(Opportunity oppVar:oppDummyList){
                // If event is insert, set Postcode Exclusion to true
                if(EventStr == 'Insert'){
                    oppVar.PostCode_Exclusion__c = true;
                // If event is delete, set Postcode Exclusion to false
                }else if(EventStr == 'Delete'){
                    oppVar.PostCode_Exclusion__c = false;
                }// End Else
             }// End For
             
             exclusionUpdateList.addAll(oppDummyList);
             
         }// End For
         
         if(exclusionUpdateList.size()>0){
            update exclusionUpdateList;
         }
    }// End setPostCode Method
    
}// End PostcodeExclusionTriggerHandler