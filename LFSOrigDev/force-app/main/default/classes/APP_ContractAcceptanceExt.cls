/*
 * @Description: Controller extension for APP_ContractAcceptance Page
 * @Author: Adrian Recio
 * @Date Created: Feb-03-2014
 * @History:
   =====================================================================
       Adrian Recio  -  03-02-14: Created
   =====================================================================
 */
public without sharing class APP_ContractAcceptanceExt extends APP_CommonExt{

    public String responseCodeControlType   {get;set;}

    /*  Description: Class contructor
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter standard controller
     *  Return: na
     */
    public APP_ContractAcceptanceExt(ApexPages.StandardController applicationController){
        super(applicationController);
        pullApplicationReponseCode();
    }

    /*  Description: Method to pull current application response code
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public void pullApplicationReponseCode(){
        //List<Application_Response__c> applicationResponseList = new List<Application_Response__c>();
        //Application_Response__c applicationResponse = new Application_Response__c();

        //applicationResponseList = [SELECT   Response_Code__c
        //                          FROM      Application_Response__c
        //                          WHERE     Application__c =: this.application.Id
        //                          ORDER BY  createdDate DESC];
        
        //if(!applicationResponseList.isEmpty()){
        //    applicationResponse = applicationResponseList.get(0);

            try {
                //responseCodeControlType = Response_Code_Control__c.getValues(applicationResponse.Response_Code__c).Type__c;
                responseCodeControlType = Response_Code_Control__c.getValues(application.Response_Code__c).Type__c;
                
            } catch(Exception e){
                responseCodeControlType = '';
            }
        //}
    }
        
    /*  Description: Method that redirects page to app main or post submit page dependending on application status
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference validatePostSubmit(){
        
        // Redirect to app complete page if response code is FIA
        if(application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_ACCEPTED){
            pageReference pgRef = Page.APP_Complete;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        
        // Redirect page to app main if appliction is still new
        if(application.Status__c== GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
            pageReference pgRef = Page.APP_Main;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }

        // Redirect page to app main post submit if application is not 
        // new but response code is not valid and channel is not specified for the contract acceptance
        if(application.Response_Code__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA && 
           application.Response_Code__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1 && 
           application.Response_Code__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2 &&  
           application.Acceptance_Channel__c == null){
            pageReference pgRef = Page.APP_Main_PostSubmit;
            pgRef.getParameters().put('Id',application.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        
        return null;
    }
    
     /*  Description: Redirect to  logoutPage
     *  Author: Fel Saliba
     *  Date Created: 15-JULY-2014
     *  Input: None
     *  Return: PageReference
     */
    public PageReference logout(){

        PageReference pageRef = Page.APP_Logout;
        pageRef.setRedirect(true);

        return pageRef;

    }
}