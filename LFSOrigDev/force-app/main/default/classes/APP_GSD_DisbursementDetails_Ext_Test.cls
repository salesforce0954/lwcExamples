/* @Description: Test class for APP_GSD_DisbursementDetails_Ext
 * @Author : Afreen Khan
 * @Date : 17-FEB-2016
 * @History:
   =========================================================================================================
   		17-FEB-2016 : Created - Afreen Khan
   =========================================================================================================
 */


@isTest
public with sharing class APP_GSD_DisbursementDetails_Ext_Test {
	public static testmethod void searchBSB_test(){
		createTestData();
		Test.startTest();
			BSB__c bsbrecord = APP_GSD_DisbursementDetails_Ext.searchBSB('123456');
			System.assertNotEquals(bsbrecord, null);

			BSB__c bsbrecordnull = APP_GSD_DisbursementDetails_Ext.searchBSB('234675');
			System.assertEquals(bsbrecordnull, null);
		Test.stopTest();

	}

	public static testmethod void searchBankNumber_test(){
		createTestData();
		Test.startTest();
			Bank__c bankrecord = APP_GSD_DisbursementDetails_Ext.searchBankNumber('11');
			System.assertNotEquals(bankrecord, null);

			Bank__c bankrecordnull = APP_GSD_DisbursementDetails_Ext.searchBankNumber('33');
			System.assertEquals(bankrecordnull, null);
		Test.stopTest();

	}

	public static testmethod void searchBankBranch_test(){
		createTestData();
		Test.startTest();
			Bank_Branch__c branchrecord = APP_GSD_DisbursementDetails_Ext.searchBranchNumber('13', '11');
			System.assertNotEquals(branchrecord, null);

			Bank_Branch__c branchrecordnull = APP_GSD_DisbursementDetails_Ext.searchBranchNumber('150', '11');
			System.assertEquals(branchrecordnull, null);
		Test.stopTest();

	}

	public static testmethod void confirmDisbursementDetails_test(){
		createTestData();
		
		Application__c apprecord = TestDataBuilder.createApplication();
		insert apprecord;	

		Disbursement__c disRecord = TestDataBuilder.createDisbursement(apprecord.Id);
		disRecord.Amount__c = apprecord.Total_Loan_Amount__c;

		Test.startTest();
			String recordId = APP_GSD_DisbursementDetails_Ext.confirmDisbursementDetails(disRecord, 'Direct Credit', apprecord.Id, 1000);
			System.assertEquals(recordId.length(), 18);

			String recordException = APP_GSD_DisbursementDetails_Ext.confirmDisbursementDetails(disRecord, 'Direct Credit', apprecord.Id, 8000);
			System.assertNotEquals(recordException.length(), 18);
		Test.stopTest();

	}




	public static void createTestData(){
		Response_Code_Control__c rc = TestDataBuilder.createResponseCodeControl(true, 'PA') ;
		insert rc;

		List<BSB__c> bsbList = TestDataBuilder.createBSBList();
		insert bsbList;

		//List<Bank__c> bankList = TestDataBuilder.createBankrecords();
		//Insert bankList;

		List<Bank_Branch__c> branchList = TestDataBuilder.createBankBranchrecords();
		insert branchList;
	}
}