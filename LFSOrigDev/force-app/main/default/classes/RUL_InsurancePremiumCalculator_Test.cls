/*
 * @Description: RUL_InsurancePremiumCalculator test class
 * @Author: Jade Serrano
 * @Date Created: 26-MAR-2014
 * @History:
 *  =====================================================================
 *      Jade - 26-MAR-2014: Created
 *  =====================================================================
 */
@isTest
private class RUL_InsurancePremiumCalculator_Test {

	@isTest static void test_method_one() {

		List<Insurance_Premium_Calculation_Variables__c> insurancePremiumCalculationVariables = TestDataBuilder.createInsurancePremiumCalculationVariables();
		insert insurancePremiumCalculationVariables;
		System.assertNotEquals(0,insurancePremiumCalculationVariables.size());//assert inserted Insurance_Premium_Calculation_Variables__c;

		Brand__c brand = TestDataBuilder.createBrand();
		insert brand;

		GEProduct__c product = TestDataBuilder.createGEProduct(brand.Id);
		product.Name = 'Life Insurance';
		insert product;

		Product_Version__c productVersion = TestDataBuilder.createProductVersion(product.Id);
		insert productVersion;
		/*Product_Version__c pv = [SELECT Id, Product_Name__c FROM Product_Version__c];
		System.debug('!@#$%^pv: '+pv);*/

		Fees_Charges__c feesCharges = TestDataBuilder.createFeesAndcharges(productVersion.Id);
		feesCharges.Stamp_Duty_Amount__c = 10;
		feesCharges.Fee_Type__c = 'Stamp Duty';
		feesCharges.State__c = 'VIC';
		feesCharges.Effective_Start_Date__c = Date.today();
		insert feesCharges;

		/*Fees_Charges__c f = [SELECT Stamp_Duty_Amount__c, Fee_Type__c, State__c, Effective_Start_Date__c, Product_Version__r.Product_Name__c FROM Fees_Charges__c];
		System.debug('!@#$%^f: '+f);*/

		GEProduct__c product2 = TestDataBuilder.createGEProduct(brand.Id);
		product2.Name = 'Disability Insurance';
		insert product2;

		Product_Version__c productVersion2 = TestDataBuilder.createProductVersion(product2.Id);
		insert productVersion2;

		Fees_Charges__c feesCharges2 = TestDataBuilder.createFeesAndcharges(productVersion2.Id);
		feesCharges2.Stamp_Duty_Amount__c = 10;
		feesCharges2.Fee_Type__c = 'Stamp Duty';
		feesCharges2.State__c = 'VIC';
		feesCharges2.Effective_Start_Date__c = Date.today();
		insert feesCharges2;

		GEProduct__c product3 = TestDataBuilder.createGEProduct(brand.Id);
		product3.Name = 'Involuntary Unemployment Insurance';
		insert product3;

		Product_Version__c productVersion3 = TestDataBuilder.createProductVersion(product3.Id);
		insert productVersion3;

		Fees_Charges__c feesCharges3 = TestDataBuilder.createFeesAndcharges(productVersion3.Id);
		feesCharges3.Stamp_Duty_Amount__c = 10;
		feesCharges3.Fee_Type__c = 'Stamp Duty';
		feesCharges3.State__c = 'VIC';
		feesCharges3.Effective_Start_Date__c = Date.today();
		insert feesCharges3;

		RUL_InsurancePremiumCalculator controller = new RUL_InsurancePremiumCalculator();

		RUL_InsurancePremiumCalculator.RUL_InsuranceSelection wrapper = new RUL_InsurancePremiumCalculator.RUL_InsuranceSelection();
		
		wrapper.lifePremiumSingle = true;
		wrapper.lifePremiumJoint = true;
		wrapper.disabilityPremiumSingle = true;
		wrapper.disabilityPremiumJoint = true;
		wrapper.iUIPremiumSingle = true;
		wrapper.iUIPremiumJoint = true;

		wrapper.inputTotalLoanAmount = 10000;
		wrapper.inputFees = 250;
		wrapper.inputLoanTerm = 60;
		wrapper.inputEMI = 1;
		wrapper.inputAPR = 1;
		wrapper.insurancePremium = 0;

		wrapper.inputState = 'VIC';

		controller.calculateInsurancePremiums(wrapper);

	}

}