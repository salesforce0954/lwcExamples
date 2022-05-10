public with sharing class CarSearchResultController {
    public CarSearchResultController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Car__c> getCars(String carTypeId){
        
        if(String.isEmpty(carTypeId)){
            system.debug('Car Type Id '+carTypeId);
            system.debug('Entered');
            return [SELECT Id,Name,Contact__r.Name                  
                    FROM Car__c 
                    WHERE Available_For_Rent__c = true ];
        } else{
            system.debug('Car Type Id Else '+carTypeId);
            system.debug('Entered Else');
            return [SELECT Id,Name,Contact__r.Name                    
                    FROM Car__c 
                    WHERE Available_For_Rent__c = true 
                    AND Car_type__c =: carTypeId];
        }

    }
}