public class CampingListController {
    
    @AuraEnabled
    public static List<Camping_Item__c> getItems(){
    return [select Id,Name,Quantity__c,Price__c,Packed__c from Camping_Item__c];
    }
    
    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c campingItem){
    upsert campingItem;
    return campingItem;
    }
}