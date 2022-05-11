public with sharing class AssetDetailsWrapper {

    @AuraEnabled public List<Asset> AssetInfo {get;set;}

    @AuraEnabled public Boolean NoAssets {get;set;}

    //Used to hold the Asset Information
    public class Asset {
        @AuraEnabled public String id {get;set;}

        @AuraEnabled public String AssetType {get;set;}

        @AuraEnabled public String AssetValue {get;set;}

        @AuraEnabled public String AssetOwnership {get;set;}

        @AuraEnabled public String VehicleMake {get;set;}

        @AuraEnabled public String VehicleModel {get;set;}

        @AuraEnabled public String YearOfManufacture {get;set;}
    }

    public AssetDetailsWrapper() {

    }
}