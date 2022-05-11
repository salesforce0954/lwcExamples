/**
 * @Description: Offer Presentation Extension Controller.
 * @Author: Fel Saliba
 * @Date Created: MARCH-03-2014
 * @History:
   =====================================================================
        MAR-03 (Fel): Created.
   =====================================================================
 */ 
 
public class APP_FaxCoverSheetEXT{
//===============================================================
//                     VARIABLE DECLARATIONS
//===============================================================

    public Application__c application {get;set;}
    public String applicationId {get;set;}
    
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Constructor used for all initializations
     *  Author: Fel Saliba
     *  Date Created: MARCH-03-2014
     *  Input: None
     *  Return: void
     */
    public APP_FaxCoverSheetEXT(ApexPages.StandardController applicationController) {
       applicationId = ApexPages.currentPage().getParameters().get('id');
       application = new Application__c();
       if(applicationId != null){
           application = [Select Id, UID__c, Branch__r.Name, Branch__r.Address__c, Branch__r.Phone__c, 
                           Brand_String__c, Branch__r.Suburb__c, Branch__r.State__c, Branch__r.Postcode__c,
                           Brand_Lookup__r.Fax_Number__c, Brand_Lookup__r.Contact_Number__c 
                           FROM Application__c
                           WHERE Id =: applicationId];
       }            
    }
}