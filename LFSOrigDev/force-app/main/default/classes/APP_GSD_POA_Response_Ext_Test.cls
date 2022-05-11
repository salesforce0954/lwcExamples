/* @Description: Test class for APP_GSD_POA_Response_Ext
 * @Author : Afreen Khan
 * @Date : 17-FEB-2016
 * @History:
   =========================================================================================================
   		17-FEB-2016 : Created - Afreen Khan
   =========================================================================================================
 */

@isTest
public with sharing class APP_GSD_POA_Response_Ext_Test {
	
	public static testmethod void queryPOADocumentList_Test(){
		createTestData();
        
		Test.startTest();
			List<Meta_Document__c> documentList = new List<Meta_Document__c>();
			documentList = APP_GSD_POA_Response_Ext.queryPOADocumentList();

			System.assertEquals(documentList.size(),2);
		Test.stopTest();

	}

	public static void createTestData(){	
		List<Meta_Document__c> docList =  TestDataBuilder.createMetaDocument();
        insert docList;
	}
}