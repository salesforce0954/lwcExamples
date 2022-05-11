/* 	  @Description: Controller for Personal Reference Page 
 	* @Author: Kabir Singh
    * @Date Created: 05-FEB-2016
    * @History:
    =====================================================================
        05-FEB-2016: Created -Kabir
    ===================================================================== 
 */
public with sharing class APP_GSD_Personal_Reference_Ext extends APP_GSD_BaseController{
	
	@RemoteAction
	public static String upsertPersonalReference(	Personal_Reference_Check__c personalRef){
		try{
			 List <Personal_Reference_Check__c> personalRefObjList = [select id, name from Personal_Reference_Check__c 
                 where Application__c = :personalRef.Application__c];
                 //If there are records already, update the first one.
             if(personalRefObjList.size()>=1){
             	System.debug(' ******* upsertPersonalReference: update ');
               Personal_Reference_Check__c personalRefObjDB = personalRefObjList.get(0);
               personalRefObjDB.Name__c = personalRef.Name__c;
               personalRefObjDB.Phone_Number__c = personalRef.Phone_Number__c;
               personalRefObjDB.State__c = personalRef.State__c;
               update personalRefObjDB;
               return personalRefObjDB.id;
             } else {//Else create a new record.
             	System.debug(' ******* upsertPersonalReference: insert ');
             	insert personalRef;
             	return personalRef.id;
             }			
			}catch(Exception e){
				System.debug('******** upsertPersonalReference Exception'+ e );
			}
		return null;
	}
	
	@RemoteAction
	public static Personal_Reference_Check__c getPersonalReference(String applicationId){		
		try{
			Personal_Reference_Check__c personalRefObj  = [select id, name__c, state__c, Phone_Number__c from Personal_Reference_Check__c 
                 where Application__c = :applicationId];
                 return personalRefObj;
		} catch (Exception e) {
			System.debug('******** getPersonalReference Exception'+ e );
		}
		return null;
	}

}