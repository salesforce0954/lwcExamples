/* @Description: Base Controller being used across all the extensions developed under GSD project 
 * @Author : Afreen Khan
 * @Date : 22-01-2016
 * @History:
   =========================================================================================================
        JAN-22-2016 : Created - Afreen Khan

   =========================================================================================================
 */
public with sharing class APP_GSD_LoadDetailHeader extends APP_GSD_BaseController{

    public Boolean controlStyle{get; set;}
    public String brandString{get; set;}
    
    //BEGIN MLASALA 12-JUL-2016 TQLQW-59 Web Analytics - Ensighten
    public String applicationNumber {get;set;}
    public String eAppsOutcome {get;set;}
    public String omnitureURL {get;set;}
    public Boolean isSocietyOne {get;set;}
    public Decimal loanAmount {get;set;}
    //AFREEN 23-SEPT-2016 TQLQW-519 Web Analytics - Ensighten
    public Boolean isPicStarter {get; set;}
    public Boolean isVeda {get; set;}
    public Boolean isAcceptedContract_App1{get; set;}
    public Boolean isAcceptedContract_App2{get; set;}
    //Added by Suneel 
    public List<Loan_Purpose__c> lp {get;set;}
    public String loanPurpose {get;set;}
    public Boolean isLPBB {get;set;}
    //Added by Suneel
    public List<Application__c> application {get;set;}
      
    public APP_GSD_LoadDetailHeader() {
        isLPBB = true;
        controlStyle = false;
        if(ApexPages.currentPage().getParameters().get('controlStyle')=='true'){
            controlStyle = true;
        }
        brandString = ApexPages.currentPage().getParameters().get('brandString');
        
        //Get Application Id
        Id appId = ApexPages.currentPage().getParameters().get('id');
        
        isSocietyOne            = false;
        isPicStarter            = false;
        isVeda                  = false;
        isAcceptedContract_App1 = false;
        isAcceptedContract_App2 = false;
        
        // Added by Suneel
        lp = [Select Application__c,Value__c from Loan_Purpose__c where Application__c = : appId];
        //Added Query for AU Region - Added by Suneel - 17/04/2018 
        application = [Select Brand_Country__c,Channel__c from Application__c WHERE Id =: appId];
        for(Application__c appBrand : application)
        {
            if(appBrand.Brand_Country__c == GEN_OriginationsConstants.AU_REGION)
            {
           /**Show the interest rate and Min. monthly repayment bubbles for cases for all credit scores. 
           Also do not show the Rate and Min. monthly repayment bubbles for Brokers. */
            if(appBrand.Channel__c == 'Broker')
                {
                        isLPBB = false;
                        break;
                }
            }
       }      
       //Added query fro NZ Region - Added by Suneel - 19/04/2018
       for(Application__c appBrand : application){
       if(appBrand.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
         for(Loan_Purpose__c loanp : lp)
                {
                                loanPurpose = loanp.Value__c;
                                if(loanPurpose == 'Beat Your Rate; Switch Now') {
                                                isLPBB = false;
                                                break;
                                }
                }
       }
         } 
        //End
        //Validate if application id is not null
        if(util.nullCheck(appId)){
            
            //Retrieve application details
            Application__c app = [SELECT UID__c, 
                                         Response_Code__c, 
                                         Channel__c, 
                                         X3rd_Party_Application_Source__c, 
                                         Mirror__c, 
                                         Initial_Requested_Amount__c,
                                         Is_Accepted_Primary__c,
                                         Is_Accepted_Secondary__c
                                  FROM   Application__c 
                                  WHERE Id =: appId];
            
            //Assign application unique id from external system
            applicationNumber = app.UID__c;
            
            loanAmount = app.Initial_Requested_Amount__c;
            
            //Assign outcome based on response code
            if(app.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_CLOSEDDECLINED){
                
                eAppsOutcome = GEN_OriginationsConstants.EAPPS_OUTCOME_DECLINED;
                
            } else if(app.Response_Code__c.left(2) == GEN_OriginationsConstants.ERROR_RESPONSE_CODE_PREFIX){
                
                eAppsOutcome = GEN_OriginationsConstants.EAPPS_OUTCOME_ERROR;
                
            } else {
                
                eAppsOutcome = GEN_OriginationsConstants.EAPPS_OUTCOME_REFER;
            }
            
            //AFREEN 23-SEPT-2016 TQLQW-519 Web Analytics - Ensighten
            if(app.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_3RD_PARTY) {
               if(app.X3rd_Party_Application_Source__c == 'Society One' &&  app.Mirror__c == GEN_OriginationsConstants.SOCIETY_ONE){
                    isSocietyOne = true;
               }
               if(app.X3rd_Party_Application_Source__c == GEN_OriginationsConstants.MIRROR_PICSTARTER &&  app.Mirror__c == GEN_OriginationsConstants.MIRROR_PICSTARTER){
                    isPicStarter = true;
               }
               if(app.X3rd_Party_Application_Source__c == GEN_OriginationsConstants.MIRROR_VEDA_QUOTE &&  app.Mirror__c == GEN_OriginationsConstants.MIRROR_VEDA_QUOTE){
                    isVeda = true;
               }
            }
            
            if(app.Is_Accepted_Primary__c){
                isAcceptedContract_App1 = true;
            }
            if(app.Is_Accepted_Secondary__c){
                isAcceptedContract_App2 = true;
            }
        }
        
        omnitureURL = Admin_Settings__c.getValues('Omniture Source').Value__c;
    }
    //END MLASALA 12-JUL-2016 TQLQW-59 Web Analytics - Ensighten
}