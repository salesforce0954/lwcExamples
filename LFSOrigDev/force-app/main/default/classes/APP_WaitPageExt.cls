/**
 * @Description: Main Controller for the Wait Page
 * @Author: Jan Mark Domingo
 * @Date Created: Nov.27,2013
 * @History:
   =====================================================================
       11-27-13: Created  - Mac
       03-19-14: Updated referenced Page - Mike
       04-10-14: Added redirect condition to change redirect to post 
                 submit main if current user is portal user else redirect to offers page.
   =====================================================================
 */
public class APP_WaitPageExt {

    public String name {get;set;}
    public String timeoutSettings  {get; set;}
    public String appId {get; set;}
    public String appRespId {get; set;}
    public String marketingContent {get;set;}
    public String titleStyle {get;set;}

    public Boolean isCust {get;set;}
    public Boolean showComponent {get; set;}

    public Id applicationId {get;set;}    

    public List<Application_Response__C> appResList {get;set;}    
    
    public DateTime timePageWasLoaded;
    
    Application__c application = new Application__c();
    Application__c app_Application;     
    
    public APP_WaitPageExt(ApexPages.StandardController controller){     
        
        Web_Service_Settings__c sto =  Web_Service_Settings__c.getInstance('ResponseTimeOut');
        
        if(sto!=null) {
            timeoutSettings = sto.value__c;
        }else{
            timeoutSettings = '45';//default
        }         

       applicationId = ApexPages.currentPage().getParameters().get('id');
       name = 'AppStatusUpdates';                                
        app_Application = (Application__c)controller.getRecord();
    }

    /*
      Retrieve the Marketing copy to be displayed on the Submit Wait page
    */
    public PageReference checkApplicationDetails(){

        PageReference ref = null;
        DateTime d;
        applicationId = (ID) ApexPages.currentPage().getParameters().get('id');

        if(Util.nullCheck(applicationId)){      //05.14.15 Mike Lasala: Code Scan fix
            application =  [Select Id, Product_SubType__c,Initial_Submit_Date__c, Brand_Lookup__c, Brand_Lookup__r.Name, Status__c, Submission_Status__c, OwnerId from Application__c where Id = :applicationId];
            System.debug('*** application ' + application);

            if(application.Brand_Lookup__r.Name == GEN_OriginationsConstants.BRAND_NAME_AUSSIE){
                titleStyle = '#711371';
            } else {
                titleStyle = '#3a73ba';
            }

            //Retrieve the marketing content to display on the Wait page to the customer
            //Condtion for removing the boxes on waiting page when product subtype is Better Start PL - Added by Suneel 11/07/2019
            if(application.Product_SubType__c != 'Better Start PL'){
                Brand_Content__c bCon = [Select Name, Brand__c, Output_HTML__c from Brand_Content__c where Brand__c = :application.Brand_Lookup__c AND Name = 'APP_SubmitWait' LIMIT 1];
                
                if(bCon.Output_HTML__c == null){
                    marketingContent = '';
                } else {
                    marketingContent = bCon.Output_HTML__c;
                }
              }
        }

        return ref;

    }

    /*  Description: Method to redirect the user to the Postsubmit Page
     *  Author: Jan Mark Domingo
     *  Date Created: APR-2-2013
     *  Input: None     
     */
    public PageReference proceedToPostSubmit(){
        
        //BEGIN MLASALA: 04-FEB-16 TQLQW-20 Templates & Configuration
        pageReference ref;
                
        //Validate if GSD Enabled custom setting is exists and set to true 
        if(Admin_Settings__c.getValues('GSD Enabled') != null && 
           Boolean.valueOf(Admin_Settings__c.getValues('GSD Enabled').Value__c)){
            
            //BEGIN MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
            Id applicationId = ApexPages.currentPage().getParameters().get('id');
            
            Application__c application = [SELECT Customer_Confirmed_Online_Offer__c, 
                                                 Staff_Hide__c, 
                                                 Online_Self_serve_Upsell_Eligibility__c, 
                                                 Online_Self_serve_Insurance_Eligibility__c
                                          FROM   Application__c
                                          WHERE  Id =: applicationId 
                                          LIMIT 1];
                                          
            //Check if offer has been locked by either the applicant or an agent
            if(application != null && 
               !application.Customer_Confirmed_Online_Offer__c && 
               !application.Staff_Hide__c && 
               (application.Online_Self_serve_Upsell_Eligibility__c || 
                application.Online_Self_serve_Insurance_Eligibility__c)){
                    
                //Eligible for upsell and/or insurance, redirect to upsell and insurance page
                ref = Page.APP_GSD_Upsell_Insurance;
                    
            } else {
            
                //Redirect to new GSD response page
                ref = Page.APP_GSD_Response;
            }
            //END MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
            
        } else {
            
            //Redirect to old post submit page
            ref = Page.APP_Main_PostSubmit;
        }
        //END MLASALA: 04-FEB-16 TQLQW-20 Templates & Configuration
        
        ref.getParameters().put('id',applicationId);        
        
        return ref;       

    }
    
    /**
     * @Description:  To pass the App_CommonExt as parameter to the Web Analytic component
     * @Author: Afreen Khan
     * @Date Created: 28-SEPT-2016
     */
   
    public APP_CommonExt getThis(){
        
        ApexPages.StandardController sc = new ApexPages.StandardController(app_Application);
        App_CommonExt appCommon = new App_CommonExt(sc);
        appCommon.initializeLoanPurposes();
        return appCommon.getThis();
    }

}