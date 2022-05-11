/*
 * @Description: Test class for APP_JointDebtAndLiabilities class
 * @Author: Russell Cadapan
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
private class APP_JointDebtAndLiabilities_Test { 
    
    @isTest static void SelectOptions_Test() { 
        List<SelectOption> testDebtCategory = Util.getPicklistValues(new Liability__c(), 'Debt_Category__c');
        List<SelectOption> testConsolidatedDebtCategory = Util.getPicklistValues(new Liability__c(), 'Consolidate_Debt_Reduce_Limit__c');
        List<SelectOption> testCarPersonalInterval = Util.getPicklistValues(new Liability__c(), 'Car_Personal_Repay_Int__c');
        List<SelectOption> testOtherRepayInterval = Util.getPicklistValues(new Liability__c(), 'Other_Repay_Int__c');
        List<SelectOption> testMortgageRepayInterval = Util.getPicklistValues(new Liability__c(), 'Mortgage_Repayment_Interval__c');
        List<SelectOption> testApplicableParty = Util.getPicklistValues(new Liability__c(), 'Applicable_Party__c');

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.StartTest();
         Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            
        APP_JointDebtAndLiabilities debt = new APP_JointDebtAndLiabilities();
        
        List<SelectOption> debtCategory = debt.getDebtCategory();
        List<SelectOption> debtConsolidatedDebtCategory = debt.getConsolidatedDebtCategory();
        List<SelectOption> debtCarPersonalInterval = debt.getCarPersonalInterval();
        List<SelectOption> debtOtherRepayInterval = debt.getOtherRepayInterval();
        List<SelectOption> debtMortgageRepayInterval = debt.getMortgageRepayInterval();
        List<SelectOption> debtApplicableParty = debt.getApplicablePartyOptions();
        List<SelectOption> debtApplicableParty2 = debt.getSelectPersonalHirePurchase();
        List<SelectOption> debtApplicableParty3 = debt.getSelectCarLoan();
        List<SelectOption> debtApplicableParty4 = debt.getSelectCreditStoreCharge();
        List<SelectOption> debtApplicableParty5 = debt.getSelectOverdraft();
        List<SelectOption> debtApplicableParty6 = debt.getSelectDebtCategory();

        Test.StopTest();

        System.assertEquals(testDebtCategory.size() + 1, debtCategory.size());
        System.assertEquals(testConsolidatedDebtCategory.size() + 1, debtConsolidatedDebtCategory.size());
        System.assertEquals(testCarPersonalInterval.size() + 1, debtCarPersonalInterval.size());
        System.assertEquals(testOtherRepayInterval.size() + 1, debtOtherRepayInterval.size());
        System.assertEquals(testMortgageRepayInterval.size() + 1, debtMortgageRepayInterval.size());
        System.assertEquals(testApplicableParty.size(), debtApplicableParty.size());

    }
}