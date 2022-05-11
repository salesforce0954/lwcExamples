/*
    Author: Michael Lasala (Cloud Sherpas)
    Created Date: June 12, 2014
    Description: Trigger Handler for meta compliance check
*/
public class MetaComplianceCheckTriggerHandler {
    
    public static void validateStartEndDate(List<Meta_Compliance_Check__c> metaCompCheckList) {        
        
        Set<Id> metaCompIds = new Set<Id>();

        for(Meta_Compliance_Check__c p: metaCompCheckList) {
            metaCompIds.add(p.Id);
        }

        List<Meta_Compliance_Check__c> metaComplianceToCheck = new List<Meta_Compliance_Check__c>();
        
        metaComplianceToCheck = [SELECT Start_Date__c, 
                                        End_Date__c
                                 FROM   Meta_Compliance_Check__c
                                 WHERE  Id NOT IN: metaCompIds];

        //iterate through to-be-inserted meta compliance check
        for(Meta_Compliance_Check__c p: metaCompCheckList) {
        
            for(Meta_Compliance_Check__c pv: metaComplianceToCheck) {
        
                if(pv.Start_Date__c!=null && pv.End_Date__c!=null) { //check if start and end dates are overlapping.
                    
                    if(p.Start_Date__c <= pv.End_Date__c && 
                       p.End_Date__c >= pv.End_Date__c ||
                       p.Start_Date__c <= pv.Start_Date__c && 
                       p.End_Date__c >= pv.Start_Date__c ||
                       p.Start_Date__c >= pv.Start_Date__c && 
                       p.Start_Date__c <= pv.End_Date__c ||
                       p.End_Date__c >= pv.Start_Date__c && 
                       p.End_Date__c <= pv.End_Date__c) {
                       
                        p.addError('The start and end dates of the meta compliance check that you are about to insert / update will overlap on an existing record with Start Date: ' + 
                        pv.Start_Date__c + 'and End Date: ' + pv.End_Date__c);
                        break; //break out of the inner loop
                    }

                } else if(pv.Start_Date__c!=null && pv.End_Date__c==null) { //if end date is empty, check that the start date doesn't overlap with an existing record's start date
                    
                    if(p.Start_date__c >= pv.Start_Date__c) {
                        p.addError('The start date of the meta compliance check that you are about to insert / update will overlap on an existing record with Start Date: ' + pv.Start_date__c);
                        break; //break out of the inner loop
                    }

                } else if(pv.Start_Date__c==null && pv.End_Date__c!=null) {
                    
                    if(p.End_Date__c <= pv.End_Date__c) {
                        p.addError('The end date of the meta compliance check that you are about to insert / update will overlap on an existing record with End Date: ' + pv.End_Date__c);
                        break; //break out of the inner loop
                    }
                    
                } else if(pv.Start_Date__c==null && pv.End_Date__c==null) {
                    p.addError('You can only have empty start and end dates if there is only one meta compliance check.');
                    break; //break out of the inner loop
                }
            }
        }
    }
}