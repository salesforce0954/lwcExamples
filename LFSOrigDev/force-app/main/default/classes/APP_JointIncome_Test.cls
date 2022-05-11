/*
 * @Description: Test class for APP_JointIncome class
 * @Author: Russell Cadapan
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - Russell
   =====================================================================
 */
@isTest
private class APP_JointIncome_Test {
    
    @isTest static void SelectOption_Test() {
        List<SelectOption> testIncomeSource = Util.getPicklistValues(new Income__c(), 'Income_Source__c');
        List<SelectOption> testIncomeInterval = Util.getPicklistValues(new Income__c(), 'Income_Interval__c');
        List<SelectOption> testOccupation = Util.getPicklistValues(new Income__c(), 'Occupation__c');

        List<Admin_Settings__c> adminSettingsList =TestDataBuilder.adminSet();
        insert adminSettingsList;        

        Test.StartTest();
        Better_Start_Offer__c bsoffer = new Better_Start_Offer__c();           
            if(bsoffer==null){
            bsoffer.BetterStartAUActive__c = false;   
            bsoffer.BetterStartNZActive__c = false;        
            }
            insert bsoffer;
            APP_JointIncome income = new APP_JointIncome();
            List<SelectOption> incomeSource = income.getIncomeSource();
            List<SelectOption> incomeInterval = income.getIncomeInterval();
            List<SelectOption> occupation = income.getOccupation();
        Test.StopTest();

        System.assertEquals(testIncomeSource.size() + 1, incomeSource.size());
        System.assertEquals(testIncomeInterval.size() + 1, incomeInterval.size());
        System.assertEquals(testOccupation.size() + 1, occupation.size());
    }
}