/*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Test Class for CompliancecheckUpdateTrigger
*/
@isTest
public class ComplianceCheckUpdateTrigger_Test {
	/*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Test Method to capture Bm Check and PFR Values
	*/
	static testMethod void updateComplianceDate(){

		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

        List<Compliance_Check__c> testComplianceList = new List<Compliance_Check__c>();

        for(Integer i = 0 ; i < 20; i ++){
			testComplianceList.add(TestDatabuilder.createComplianceCheck(testApplication.Id));
        }
		insert testComplianceList;

		Test.StartTest();
			List<Compliance_Check__c> testComplianceUpdate = new List<Compliance_Check__c>();
			for(Compliance_Check__c cc: testComplianceList){
				cc.BM_Check__c = 'NA';
				cc.PFR_Check__c  = 'NA';
				testComplianceUpdate.add(cc);
			}	
			update testComplianceUpdate;
		Test.StopTest();

		Set<Id> complianceId = new Set<Id>();

		for(Compliance_Check__c cc: testComplianceList){
			complianceId.add(cc.Id);
		}
		List<Compliance_Check__c> updatedCompliance = [SELECT BM_Check__c,
														PFR_Check__c
														FROM  Compliance_Check__c
														where Id IN: complianceId];

		for(Compliance_Check__c cc: updatedCompliance){												
			System.assertEquals('NA',cc.BM_Check__c);
			System.assertEquals('NA',cc.PFR_Check__c);
		}
	}
	/*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Test Method to capture Bm Check and PFR Values when Null
	*/
	static testMethod void updateComplianceDateNMPFRNulls(){

		Application__c testApplication = TestDataBuilder.createApplication();
        insert testApplication;

		Compliance_Check__c testCompliance = TestDatabuilder.createComplianceCheck(testApplication.Id);
		insert testCompliance;

		Test.StartTest();
			testCompliance.BM_Check__c = null;
			testCompliance.PFR_Check__c  = null;	
			update testCompliance;
		Test.StopTest();

		Compliance_Check__c updatedCompliance = [SELECT BM_Check__c,
														PFR_Check__c,
														PFR_Date__c,
														PFR_ID__c,
														PFR_User_ID__c,
														BM_Date__c,
														BM_ID__c,
														BM_User_ID__c
														FROM  Compliance_Check__c
														where Id =: testCompliance.Id];

		System.assertEquals(null,updatedCompliance.PFR_Date__c );
		System.assertEquals(null,updatedCompliance.PFR_ID__c );
		System.assertEquals(null,updatedCompliance.PFR_User_ID__c );
		System.assertEquals(null,updatedCompliance.BM_Date__c );
		System.assertEquals(null,updatedCompliance.BM_ID__c );
		System.assertEquals(null,updatedCompliance.BM_User_ID__c );
	}

	static testMethod void metaComplianceCheckOveralapDatesTest(){
		Meta_Compliance_Check__c testMMC = TestDatabuilder.createMetaComplianceCheck();
		insert testMMC;

		Test.StartTest();			
			Meta_Compliance_Check__c testMMCOverlapDates = TestDatabuilder.createMetaComplianceCheck();
			testMMCOverlapDates.Start_Date__c = Date.Today().addDays(1);
	        testMMCOverlapDates.End_Date__c = Date.Today().addDays(20);
			try {
	            insert testMMCOverlapDates;
	        } catch (DmlException e) {
	            System.assert(e.getMessage().contains('The start and end dates of the meta compliance check that you are about to insert / update will overlap on an existing record with Start Date:'), e.getMessage());
	            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
	        }
		Test.StopTest();

		List<Meta_Compliance_Check__c> mccList = [SELECT Id FROM Meta_Compliance_Check__c];
        System.assertEquals(mccList.get(0).Id, testMMC.Id);
        System.assertEquals(1, mccList.size());
	}

	static testMethod void metaComplianceNullDatesTest(){
		Meta_Compliance_Check__c testMMC = new Meta_Compliance_Check__c();
		insert testMMC;

		Test.StartTest();
			Meta_Compliance_Check__c testMMCNullDates = new Meta_Compliance_Check__c();
			try {
	            insert testMMCNullDates;
	        } catch (DmlException e) {
	            System.assert(e.getMessage().contains('You can only have empty start and end dates if there is only one meta compliance check.'), e.getMessage());
	            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
	        }
		Test.StopTest();

		List<Meta_Compliance_Check__c> mccList = [SELECT Id FROM Meta_Compliance_Check__c];
        System.assertEquals(mccList.get(0).Id, testMMC.Id);
        System.assertEquals(1, mccList.size());
	}
}