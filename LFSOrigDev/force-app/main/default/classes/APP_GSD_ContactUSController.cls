/* @Description: Controller for component to display contact information based on brand and workflow status. 
 * @Author : Kabir Singh
 * @Date : 21-Mar-2016
 * @History:
   =========================================================================================================
   		21-Mar-2016 : Created - Kabir Singh

   =========================================================================================================
 */

global with sharing class APP_GSD_ContactUSController extends APP_GSD_BaseController {
	
	public APP_GSD_ContactUSController() {
		
	}
	
	@RemoteAction
	global static String getContactDetails(Id appId){
		system.debug('getContactDetails:');
		
		//BEGIN MLASALA 12-MAY-2016 Added Channel__c for fix pack 24052016 item 3
		Application__c app = [SELECT Id, 
		                             Response_code__c, 
		                             Brand_Lookup__r.Name, 
		                             Brand_Lookup__r.LPE_Phone_Number__c,  
			                         Brand_Lookup__r.Inbound_Phone_Number__c, 
			                         Brand_Lookup__r.NZ_Contact_Details__c, 
			                         Channel__c,                                        //Added by MLASALA 12-MAY-2016
			                         Brand_Lookup__r.Inbound_Skilled_Phone_Number__c    //Added by MLASALA 12-MAY-2016
			                  FROM   Application__c 
			                  WHERE  Id=:appId];
		//END MLASALA 12-MAY-2016 Added Channel__c for fix pack 24052016 item 3	                  
		system.debug('app.Brand_Lookup__r.name: '+ app.Brand_Lookup__r.name);
			
		if(app.Brand_Lookup__r.name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ ||
			app.Brand_Lookup__r.name==GEN_OriginationsConstants.BRAND_NAME_KIWI ){
				//NZ
         		return GEN_OriginationsConstants.CONTACT_US_EMAIL + app.Brand_Lookup__r.nz_contact_details__c;
        } else if (app.Brand_Lookup__r.name==GEN_OriginationsConstants.BRAND_NAME_AUSSIE){
        	// AU AUSSIE
        	return GEN_OriginationsConstants.CONTACT_US_CALL + app.Brand_Lookup__r.LPE_Phone_Number__c;
        } else {
        	//AU LATITUDE
        	
        	//BEGIN MLASALA 12-MAY-2016 Added Channel__c for fix pack 24052016 item 3
        	if(app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
        	    
        	    return GEN_OriginationsConstants.CONTACT_US_CALL + app.Brand_Lookup__r.Inbound_Skilled_Phone_Number__c;
        	
        	//END MLASALA 12-MAY-2016 Added Channel__c for fix pack 24052016 item 3
        	} else if(GEN_OriginationsConstants.PRE_BUREAU_RESPONSE_CODE.contains(app.Response_Code__c) ||
			          GEN_OriginationsConstants.POST_BUREAU_RESPONSE_CODE.contains(app.Response_Code__c) ||
			          GEN_OriginationsConstants.FRAUD_WATCHLIST_RESPONSE_CDDE.contains(app.Response_Code__c) ||
			          GEN_OriginationsConstants.CPU_RESPONSE_CODE.contains(app.Response_Code__c) || 
			          GEN_OriginationsConstants.SALES_RESPONSE_CODE.contains(app.Response_Code__c) ||				
			          GEN_OriginationsConstants.DECLINE_RESPONSE_CODE.contains(app.Response_Code__c)){
			              
         		return GEN_OriginationsConstants.CONTACT_US_CALL + app.Brand_Lookup__r.Inbound_Phone_Number__c;
	    
        } else if(GEN_OriginationsConstants.CA_RESPONSE_CODE.contains(app.Response_Code__c)){
	            return GEN_OriginationsConstants.CONTACT_US_CALL + app.Brand_Lookup__r.LPE_Phone_Number__c;
	        }
        }
		return '';
	}
}