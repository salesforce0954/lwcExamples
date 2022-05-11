/* @Description: Base Controller being used across all the extensions developed under GSD project 
 * @Author : 
 * @Date : 22-01-2016
 * @History:
   =========================================================================================================
        JAN-22-2016 : Created - Afreen Khan

   =========================================================================================================
 */
public with sharing class APP_GSD_Response_Ext extends APP_GSD_BaseController{
    
    //BEGIN MLASALA 05-APR-2016 eApps
    public String applicationNumber {get;set;}
    public String eAppsOutcome {get;set;}
    public String omnitureURL {get;set;}
    
    public APP_GSD_Response_Ext(){
        
    }

    /*  Description: Validate application (for multiple logins for broker applications issue)
     *  Author: Mike Lasala
     *  Date Created: 28-NOV-2016
     *  Input: None
     *  Return: PageReference
     */
    public PageReference validateBrokerApplication(){
        
        Id appId = ApexPages.currentPage().getParameters().get('id');

        //Validate if application id is not null
        if(util.nullCheck(appId)){
            
            //Retrieve application details
            try{
                Application__c app = [SELECT Id FROM Application__c WHERE Id =: appId];
            } catch (QueryException e){
                
                //Redirect to login page
                PageReference pageRef = Page.APP_Login;
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        return null;
    }
}