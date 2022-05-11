/*
 * @Description: Test class for APP_JointAssets class
 * @Author: Russell Cadapan
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
private class APP_JointAssets_Test {
    
    @isTest static void SelectOptions_Test() {
        List<SelectOption> testAssetCategoryList = Util.getPicklistValues(new Asset__c(), 'Asset_Category__c');
        List<SelectOption> testOwnershipStatusList = Util.getPicklistValues(new Asset__c(), 'Ownership_Status__c');
        List<SelectOption> testApplicablePartyList = Util.getPicklistValues(new Asset__c(), 'Applicable_Party__c');
        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_JointAssets asset = new APP_JointAssets();
            List<SelectOption> AssetCategoryList = asset.getAssetCategory();
            List<SelectOption> OwnershipStatus = asset.getOwnershipStatus();
            List<SelectOption> ApplicantPartyList = asset.getApplicablePartyOptions();
            
        Test.StopTest();

        System.assertEquals(testAssetCategoryList.size()+1, AssetCategoryList.size());
        System.assertEquals(testOwnershipStatusList.size()+1, OwnershipStatus.size());
        System.assertEquals(testApplicablePartyList.size(), ApplicantPartyList.size());
    }
}