/* @Description: Extension class for the POA Response Page
 * @Author : Afreen Khan
 * @Date : 15-FEB-2016
 * @History:
   =========================================================================================================
   		15-FEB-2016 : Created - Afreen Khan
   =========================================================================================================
 */


public with sharing class APP_GSD_POA_Response_Ext extends APP_GSD_BaseController{

    @RemoteAction
	public static List<Meta_Document__c> queryPOADocumentList(){
	 	return [SELECT Name, Document_Type__c, Description__c FROM Meta_Document__c WHERE Category__c =: GEN_OriginationsConstants.NZ_META_DOCUMENTS_POA Order By Document_Type__c DESC];
	}
}