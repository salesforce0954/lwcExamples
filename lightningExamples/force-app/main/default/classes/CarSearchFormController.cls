public with sharing class CarSearchFormController {
    public CarSearchFormController() {

    }
   @AuraEnabled(cacheable=true)  
    public static List<Car_Type__c> getCarTypes(){
        return [select id,Name from Car_Type__c];
    }
}