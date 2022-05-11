/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: January 21, 2014
Description: Trigger Handler for VerifiedType field
*/
public class AMLVerifiedTypeHandler {
    /**  Description: Method to update the Verified Type picklist
     *  Author: Louis Augusto Del Rosario
     *  Date Created: 1-21-2014
     *  Input Parameters: Trigger.new - newly inserted AML records
     *  Return: void
     */
     public void insertVerifiedType(List<AML__c> AMLList){
        
        List<AML__c> insertAMLList = new List<AML__c>();
        
        /*if(AMLList.size() > 0){
            for(AML__c aml:AMLList){
                if(aml.AML_Pos_Verified_Type__c != null){
                    if(aml.AML_Pos_Verified_Type__c == 'B'){
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c;
                    }else if(aml.AML_Pos_Verified_Type__c == 'T'){
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c;
                    }else if(aml.AML_Pos_Verified_Type__c == 'A'){
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c;
                    }else if(aml.AML_Pos_Verified_Type__c == 'E'){
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c;
                    }else if(aml.AML_Pos_Verified_Type__c == 'X'){
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c;
                    }else{
                        aml.AML_Ver__c = aml.AML_Pos_Verified_Type_Code__c ;
                    }
                }               
            }
        }*/
     }
}