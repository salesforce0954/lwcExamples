/*
 * @Description: Test class for APP_JointAssetsExt_INT class
 * @Author: Russell Cadapan
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
private class APP_JointAssetsExt_INT_Test {
    
    static testMethod void Asset_Test() {
        //Single with no Asset
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssets ass = new APP_JointAssets();
            ass.getAssetCategory();
            ass.getOwnershipStatus();
            APP_JointAssetsExt_INT assetExt = new APP_JointAssetsExt_INT(standardCon);
            assetExt.bankAccountHeld='None';
            assetExt.getTotalAsset();
            assetExt.redirectTo = 'Back';
            assetExt.pageRedirect();
            assetExt.redirectTo = 'Cancel';
            assetExt.pageRedirect();
            assetExt.redirectTo = 'Save';
            assetExt.pageRedirect();
            assetExt.addAsset();
            assetExt.assetAddList.get(0).asset.Asset_Category__c = 'Caravan';
            assetExt.assetAddList.get(0).asset.Asset_Value__c = 1000;
            assetExt.assetAddList.get(0).asset.Ownership_Status__c = 'Owe money on';
            assetExt.addAsset();
            assetExt.assetAddList.get(1).asset.Asset_Category__c = 'House';
            assetExt.assetAddList.get(1).asset.Asset_Value__c = 1000;
            assetExt.assetAddList.get(1).asset.Ownership_Status__c = 'Owe money on';
            assetExt.addAsset();
            assetExt.assetAddList.get(2).asset.Asset_Category__c = 'Car';
            assetExt.assetAddList.get(2).asset.Asset_Value__c = 1000;
            assetExt.assetAddList.get(2).asset.Ownership_Status__c = 'Owe money on';
            assetExt.assetAddList.get(2).asset.Vehicle_make__c = 'Make';
            assetExt.assetAddList.get(2).asset.Vehicle_model__c = 'Model';
            assetExt.assetAddList.get(2).asset.Vehicle_year__c = '2014';
            assetExt.pageRedirect();
        Test.StopTest();

        system.assertEquals(assetExt.assetAddList.size(), 4);
        system.assertEquals(3000, assetExt.totalAssets);
        system.assertEquals('Save', assetExt.redirectTo);
    }
    
    static testMethod void Asset_Test2() {
        Brand__c brand=TestDataBuilder.createBrandNZ();
        insert brand;
        //Single with existing Asset
        Application__c testApplication = TestDataBuilder.createApplicationNZ(brand);
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        testApplicant.Is_Primary_Applicant__c = true;
        insert testApplicant;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Asset__c testAsset2 = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset2;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt_INT assetExt = new APP_JointAssetsExt_INT(standardCon);
            assetExt.selectedRow = 0;
            assetExt.removethisAsset();
            assetExt.redirectTo = 'Next';
            assetExt.pageRedirect();
        Test.StopTest();

        system.assertEquals(assetExt.assetAddList.size(), assetExt.assetListSize);
        system.assertEquals(assetExt.totalAssets, testAsset2.Asset_Value__c);
        system.assertEquals('Next', assetExt.redirectTo);
        system.assertEquals(0, assetExt.selectedRow);
        system.assertEquals(1, assetExt.assetListToDel.size());
    }

    static testMethod void Asset_Test3() {
        //Single with existing Asset
        Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        Applicant__c testApplicant = TestDataBuilder.createApplicant(null, testApplication.Id);
        insert testApplicant;

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Asset__c testAsset = TestDataBuilder.createAsset(testApplicant.Id);
        insert testAsset;

        Test.StartTest();
            ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testApplication);
            APP_JointAssetsExt_INT assetExt = new APP_JointAssetsExt_INT(standardCon);
            assetExt.selectedRow = 0;
            assetExt.removethisAsset();
        Test.StopTest();

        system.assertEquals(assetExt.assetAddList.size(), assetExt.assetListSize);
        system.assertEquals(0, assetExt.selectedRow);
    }
}