public without sharing class PersonalDetailsController {
  

    @AuraEnabled
    public static List<StreetTypes> getStreetTypeValues(){
       List<StreetTypes> streetTypesList = new List<StreetTypes>();
        for(Street_Type_Setting__c stObj : [SELECT  Value__c,
                                                    Value_Abbreviated__c
                                            FROM    Street_Type_Setting__c
                                            WHERE   Region__c IN ('AU','Both')
                                            ORDER BY Value__c ASC]){
            StreetTypes streetType = new StreetTypes();
            streetType.label = stObj.Value__c;
            streetType.value = stObj.Value_Abbreviated__c;
            streetTypesList.add(streetType);
        }
        return streetTypesList;
    }
    


    public class StreetTypes{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
    }

    
}