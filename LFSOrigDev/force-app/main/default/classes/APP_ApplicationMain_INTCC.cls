/* @Description: Controller for Application view record (Staff UI)
 * @Author: Mike Lasala
 * @History:
   =====================================================================
       02-13-14: Refactored - Mike
       04-30-15: Updated Defect 942 - Updated changeBrand method to auto-change brand for brances 191 and 190 -DY
       2015-06-30:  CHBRAND Tony Xu - Change of application brand need to change the corresponding community user's
       08-04-15: Updated PMIHM 1858 - Updated changeBrand method for brand swapping changes for kiwibank - Davey
       08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
       08-13-15: UPDATED - ADDED NEW METHOD TO DISPLAY INFO MESSAGE WHEN DEBTS ARE AUTO CREATED - DYU
       08-13-15: PMIHM-132 - Credit application - Submit service available after application has been submitted  - MDAVID
       17-SEPT-15: ASYNC TO SYNC CALL OUT -MLASALA
   =====================================================================
 */
public class APP_ApplicationMain_INTCC extends APP_CommonExt {
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<User> userList                          {get;set;}
    public String blackboxTxt                           {get;set;}
    public String currenTab                             {get;set;}
    public String docSub                                {get;set;}
    public Integer pfrCount                             {get;set;}
    public Integer bmCount                              {get;set;}
    public Boolean isCust;
    Id appId;
    transient public String applicationId               {get;set;}
    transient public String responseCode                {get;set;}
    transient public String settlementTab               {get;set;}
    transient public String contractTab                 {get;set;}
    transient public String applicantTab                {get;set;}
    transient public String decisionSubTab              {get;set;}
    transient public Boolean doesAppResponseExists      {get;set;}
    transient public Boolean isJoint                    {get;set;}

    //transient public String currenTab                   {get;set;}
    //transient public Boolean showSubmitApplication      {get;set;}
    //transient public Boolean showUpdateApplication      {get;set;}
    
    public Application_Response__c appResponse = new Application_Response__c();

    //BEGIN - DYU 13-AUG-2015 - DISPLAY INFO MESSAGE WHEN LIABILITY IS AUTO CREATED
    public Boolean debtAutoCreated                      {get;set;} 
    public String liabilityMessage                      {get;set;}
    //END - DYU 13-AUG-2015
    
    //BEGIN MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
    public Boolean isConditionallyApproved              {get;set;}
    public Id previousOwnerId;
    public Boolean isTOMEnabled                         {get;set;}
    //END MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES

    private User reportingUser; // 24-06-2016 - Afreen - Assign User Role - User Story 300
    
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================
    /*  Description: Main Controller class used for all initializations of common variables
     *  Author: Mike Lasala
     *  Input: None
     *  Return: void
     */
    public APP_ApplicationMain_INTCC(ApexPages.StandardController applicationController){
        try{            
            super(applicationController);
            
            String fromSubmit = ApexPages.currentPage().getParameters().get('submit');  //To identify whether process came from Applcation Submit
            String fromDocument = ApexPages.currentPage().getParameters().get('document');  //To identify whether process came from Applcation Submit
            isJoint = isJoint();
            
            if(fromSubmit != null){
                currenTab = 'offerTab';
            } else if(fromDocument == 'true'){
                currenTab = 'docTab';
                docSub = 'rdTab';
            } else {
                currenTab = 'appTab';
            }

            //Added by Fel Saliba 11/2/2014
            String tabInFocus = System.currentPageReference().getParameters().get('tab');
            String subTab = System.currentPageReference().getParameters().get('subTab');
            
            contractTab = 'preContractGenTab';
            settlementTab = 'disbursementTab';
            decisionSubTab = 'attachTab';
            if(tabInFocus != null){
                currenTab = tabInFocus;
                contractTab = 'contractAcceptanceTab';
                
                if(subTab != null){
                    decisionSubTab = subTab;
                }
            }
            system.debug('!@#this.application.Response_Code__c: '+this.application.Response_Code__c);
            
            //Added by Fel Saliba 4/11/2014
            //Check if the for time out error
            String timeout = System.currentPageReference().getParameters().get('timeout');
            if(timeout != null){
                 Util.addMessage(ApexPages.Severity.ERROR, 'Operation timed out - please re-try or contact Support Desk');
            }
            
            if(Util.nullCheck(this.application.Insurance_Error_Message__c)){

                //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                //Changed severity from ERROR to INFO
                Util.addMessage(ApexPages.Severity.INFO, this.application.Insurance_Error_Message__c);
                //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            }

            //Added by Fahad Akhtar 2/12/2014
            //If Applicaiton doesnt meet Benji Criteria show error
            if(this.application.Type_of_Product__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN && this.application.Benji_Rule_Results__c != null){
                Util.addMessage(ApexPages.Severity.Error, this.application.Benji_Rule_Results__c);
            }
            showHideButton(String.valueOf(this.application.Response_Code__c));
            
            doesAppResponseExists = checkAppResponse();
            
            //MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
            //Commented out because it is replacing the query results from APP_CommonExt. Redundant as well
            // this.applicantList = [SELECT    Id
            //                       FROM      Applicant__c 
            //                       WHERE     Application__c =: applicationController.getRecord().Id];

            if(!applicantList.isEmpty()){
                //Jade Serrano 30-OCT-2013 Check user if existing
                userList = [Select Id From User Where AppId__c LIKE: '%'+this.application.Id+'%' LIMIT 1];
                
                //Jade Serrano 06-NOV-2013 Cancel application button visibility
                showCancel = true;
                
                if(this.application.Status__c==null){
                    showCancel = true;
                }else if(this.application.Status__c!='New' 
                      && this.application.Status__c!='Submitted' 
                      && this.application.Status__c!='Declined' 
                      && this.application.Status__c!='Cancelled' 
                      && this.application.Status__c!='Settled' 
                      && this.application.Status__c!='Cancel Requested)'){
                    
                    showCancel = true;
                }else{
                    showCancel = false;
                }
            }

            applicationId = application.Id;
            responseCode = application.Response_Code__c;
            appId= application.Id;
            Map<String, Webservice_Message_Codes__c> asyncErrors = new Map<String, Webservice_Message_Codes__c>();
            for(Webservice_Message_Codes__c wmc : [Select Name, Error_Message__c, Message_Description__c from Webservice_Message_Codes__c where Synchronous__c = false]) {
                asyncErrors.put(wmc.Name, wmc);
            }

                        //P-182 start
            //Check if the broker is not active.
            if(application.Response_Code__c != 'FIA' && application.Response_Code__c != 'FIC' && application.Response_Code__c != 'FID'  && application.Response_Code__c != 'FFID'){
                if(application.Broker__c != null) {
                    Contact brokerstatus = [SELECT Contact_Accreditation_Status__c FROM Contact WHERE Id =: application.Broker__c LIMIT 1];

                    if(brokerstatus.Contact_Accreditation_Status__c != 'Active'){
                        Util.addMessage(ApexPages.Severity.Error, 'The broker selected for this applicaiton is no longer active. Please refer to policy before proceeding');
                    }
                }
            }

            //P-182 End

            //Display ASYNC webservice errors found in RESPONSE CODE field
            if(application.Response_Code__c!=null) {
                if(asyncErrors.containsKey(application.Response_Code__c)) {
                    String errorMessage = asyncErrors.get(application.Response_Code__c).Error_Message__c;
                    if(errorMessage!=null) {
                        if(application.Last_Webservice_Operation_Invoked__c!=null) {
                            errorMessage = errorMessage.replace(GEN_OriginationsConstants.MESSAGE_VARIABLE_OPERATION, application.Last_Webservice_Operation_Invoked__c);
                        }
                        if(asyncErrors.get(application.Response_Code__c).Message_Description__c!=null) {
                            errorMessage = errorMessage.replace(GEN_OriginationsConstants.MESSAGE_VARIABLE_DESCRIPTION, asyncErrors.get(application.Response_Code__c).Message_Description__c);
                        }
                        Util.addMessage(ApexPages.Severity.ERROR, errorMessage);
                    }
                } else {
                    //This shows webservice STATUS errors if response code doesn't reflect an ASYNC WS error
                    Map<String, Webservice_Status_Error_Messages__c> wsErrorMessages = Webservice_Status_Error_Messages__c.getAll();
                    for (String wsErrorMessage : wsErrorMessages.keySet()) {
                        Webservice_Status_Error_Messages__c wsem = wsErrorMessages.get(wsErrorMessage);
                        checkWebserviceStatusMessages(application, wsem.status_field__c, wsem.status_value__c, wsem.error_message__c);
                    }
                }
            }

            queryComplianceCheck(this.application.Id);

            //Added by fsaliba - 11/11/2014
            //check if deal reallocation is applicable - show message
            if(application.Need_Deal_Reallocation__c == true){
                Util.addMessage(ApexPages.Severity.ERROR, 'Brand Assignment should be Reallocated');
            }
            //BEGIN - DYU 13-AUG-2015 - DISPLAY INFO MESSAGE WHEN LIABILITY IS AUTO CREATED
            liabilityMessage = getLiabilityMessage();
            debtAutoCreated = checkLiabilities(this.application.id); 
            //END - DYU 13-AUG-2015
            
            //BEGIN MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
            isTOMEnabled = false;
            isConditionallyApproved = false;
            
            //Validate if TOM Enabled custom setting exists
            if(Admin_Settings__c.getValues('TOM Enabled') != null){
                
                //Validate if:
                //1. TOM is enabled
                //2. Application country = AU
                //3. Brand != Aussie
                if(Admin_Settings__c.getValues('TOM Enabled').Value__c == 'TRUE' && 
                   application.Brand_Country__c == GEN_OriginationsConstants.AU_REGION && 
                   application.Brand_String__c != GEN_OriginationsConstants.BRAND_NAME_AUSSIE){
                    
                    isTOMEnabled = true;
                
                    //Retrieve role developer name
                    UserRole loggedUserRole;
                    
                    if(Test.isRunningTest()){
                        loggedUserRole = [SELECT DeveloperName FROM UserRole WHERE DeveloperName = 'System_Administrator'];
                    } else {
                        loggedUserRole = [SELECT DeveloperName FROM UserRole WHERE Id =: UserInfo.getUserRoleId()];
                    }
                    
                    //BEGIN MLASALA 30-MAR-16 - DEFECT 439 FIX
                    User ownerUser;
                    
                    //If application owner is user, get owner role
                    if(application.OwnerId.getSObjectType() == User.SObjectType){
                        ownerUser = [SELECT UserRole.DeveloperName, UserRole.Name FROM User WHERE Id =: application.OwnerId];       //MLASALA 12-JUL-16 DEFECT 1114 FIX
                    }
                    
                       //Validate if: 
                       //1. Owner is not a queue
                       //2. Logged in user is not LPE
                       //3. Logged in user is system administrator/has correct role for LPE user
                       //4. Application response code is not pre/post-bureau 
                       //5. Application response code is not fraud/watch list
                    if(application.OwnerId.getSObjectType() == User.SObjectType && 
                       ownerUser.UserRole.DeveloperName != null &&      //MLASALA 05-MAY-2016   Added null checking of role for pre-submit online applications
                       !GEN_OriginationsConstants.LPE_USER_ROLE_PREFIX.contains(ownerUser.UserRole.DeveloperName.left(3)) &&
                       (GEN_OriginationsConstants.INBOUND_OUTBOUND_USER_ROLES.contains(loggedUserRole.DeveloperName) || 
                        GEN_OriginationsConstants.INBOUND_OUTBOUND_USER_ROLE_PREFIX.contains(loggedUserRole.DeveloperName.left(5))) && 
                       !GEN_OriginationsConstants.PRE_BUREAU_RESPONSE_CODE.contains(application.Response_Code__c) && 
                       !GEN_OriginationsConstants.POST_BUREAU_RESPONSE_CODE.contains(application.Response_Code__c) && 
                       !GEN_OriginationsConstants.FRAUD_WATCHLIST_RESPONSE_CDDE.contains(application.Response_Code__c)){
                        
                        //END MLASALA 30-MAR-16 - DEFECT 439 FIX
                        isConditionallyApproved = true;
                        previousOwnerId = application.OwnerId;
                        reportingUser   = ownerUser; // 24-06-2016 - Afreen - Assign User Role - User Story 300
                    }
                    
                    if(isConditionallyApproved && 
                       !this.applicantList.isEmpty()){
                        
                        for(Applicant__c a: this.applicantList){
                            
                            //Validate if applicant/s has response code. 
                            if(!Util.nullCheck(a.Response_Code__c)){
                                
                                isConditionallyApproved = false;
                                break;
                            }
                        }
                    }
                }
            }
            //END MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
            
            //BEGIN MLASALA: 19-SEPT-16 - TQLQW-487 Promo engine
            //Display promo messaging
            if(application.Promo_Message__c != null){
                Util.addMessage(ApexPages.Severity.INFO, application.Promo_Message__c);
            }
            //END MLASALA: 19-SEPT-16 - TQLQW-487 Promo engine
            
        } catch(VisualforceException e){
            Util.addMessage(ApexPages.Severity.ERROR, Label.Application_ID_Error);
        }   
    }

    /* 
    *  Description: Check if the corresponding field is equal to the given value. If matched, display the corresponding error message
    *  Author: Dan Crisologo
    *  Input Parameters: app - application record to check
                         statusField - field to match
                         statusValue - value of the webservice status
                         errorMessage - message to display if value matched
    *  Return: N/A
    */
    private void checkWebserviceStatusMessages(Application__c app, String statusField, String statusValue, String errorMessage) {
        if(app.get(statusField)==statusValue) {
            if(statusValue == GEN_OriginationsConstants.WSCODE_DOCGEN_SUCCESS || statusValue == GEN_OriginationsConstants.APP_RESPONSE_CODE_SUCCESS){
                Util.addMessage(ApexPages.Severity.INFO, errorMessage);
            } else {
                Util.addMessage(ApexPages.Severity.ERROR, errorMessage);
            }
        }
    }
    
    /* 
    *  Description: query if app response already exists
    *  Author: Mike Lasala
    *  Input Parameters: None
    *  Return: Boolean
    */
    public Boolean checkAppResponse(){
        List<Application_Response__c> appResponseList = new List<Application_Response__c>();
            
        appResponseList = [SELECT Credit_Score__c, 
                                  UID__c, 
                                  Max_Capacity_Secured__c, 
                                  Max_Capacity_Unsecured__c, 
                                  Response_Code__c 
                           FROM   Application_Response__c 
                           WHERE  Application__c =: this.application.Id LIMIT 1];
        
        if(!appResponseList.isEmpty()){
            appResponse = appResponseList[0];
            doesAppResponseExists = true;
        } else {
            appResponse = new Application_Response__c();
            doesAppResponseExists = false;
        }
        return doesAppResponseExists;
    }
    
   /* 
    *  Description: This will control button rendering
    *  Author: Jade Serrano
    *  Input Parameters: String
    *  Return: Boolean
    */
    public void showHideButton (String status) {
        List<Response_Code_Control__c> rList = new List<Response_Code_Control__c>();
        rList = [Select Id From Response_Code_Control__c Where Name =: status];
        if(rList.size()>0){
            Boolean statusAccessClose = Response_Code_Control__c.getInstance(status).Close_CLV__c;
            Boolean statusAccessCase = Response_Code_Control__c.getInstance(status).CPU_Case_CLV__c;
            Boolean statusAccessEdit = Response_Code_Control__c.getInstance(status).Edit_CLV__c;
            Boolean statusAccessSubmit = Response_Code_Control__c.getInstance(status).Submit_CLV__c;

            Boolean profileAccessClose = Profile_Control__c.getInstance(UserInfo.getProfileId()).Close_CLV__c;
            Boolean profileAccessCase = Profile_Control__c.getInstance(UserInfo.getProfileId()).CPU_Case_CLV__c;
            Boolean profileAccessEdit = Profile_Control__c.getInstance(UserInfo.getProfileId()).Edit_CLV__c;
            Boolean profileAccessSubmit = Profile_Control__c.getInstance(UserInfo.getProfileId()).Submit_CLV__c;
            
            Boolean statusAccessSubmitNZ = Response_Code_Control__c.getInstance(status).Submit_NZ__c;
            Boolean profileAccessSubmitNZ = Profile_Control__c.getInstance(UserInfo.getProfileId()).Submit_NZ__c;

            Boolean resVerifyPOI = Response_Code_Control__c.getInstance(status).Verify_POI__c;
            Boolean proVerifyPOI = Profile_Control__c.getInstance(UserInfo.getProfileId()).Verify_POI__c;

            Boolean resUpdateApplication = Response_Code_Control__c.getInstance(status).Update_Application__c;
            Boolean proUpdateApplication = Profile_Control__c.getInstance(UserInfo.getProfileId()).Update_Application__c;

            Boolean resUserLogin = Response_Code_Control__c.getInstance(status).User_Login_User_not_created__c;
            Boolean proUserLogin = Profile_Control__c.getInstance(UserInfo.getProfileId()).User_Login_User_not_created__c;

            Boolean resUserLogin2 = Response_Code_Control__c.getInstance(status).User_Login_User_created__c;
            Boolean proUserLogin2 = Profile_Control__c.getInstance(UserInfo.getProfileId()).User_Login_User_created__c;
            
            Boolean resGenDoc = Response_Code_Control__c.getInstance(status).Generate_Contract__c;
            Boolean proGenDoc = Profile_Control__c.getInstance(UserInfo.getProfileId()).Generate_Contract__c;

            Boolean resOffers = Response_Code_Control__c.getInstance(status).Offers__c;
            Boolean proOffers = Profile_Control__c.getInstance(UserInfo.getProfileId()).Offers__c;
            
            Boolean resCover = Response_Code_Control__c.getInstance(status).Fax_Cover_Sheet__c;
            Boolean proCover = Profile_Control__c.getInstance(UserInfo.getProfileId()).Fax_Cover_Sheet__c;

            Boolean resChangeOwner = Response_Code_Control__c.getInstance(status).Change_Owner__c;
            Boolean proChangeOwner = Profile_Control__c.getInstance(UserInfo.getProfileId()).Change_Owner__c;

            if(statusAccessClose && profileAccessClose){
                showHideCloseButton = false;
            }else{
                showHideCloseButton = true;
            }

            if(statusAccessCase && profileAccessCase){
                showHideCPUCaseButton = false;
            }else{
                showHideCPUCaseButton = true;
            }

            if(statusAccessEdit && profileAccessEdit){
                showHideEditButton = false;
            }else{
                showHideEditButton = true;
            }

            if(statusAccessSubmit && profileAccessSubmit){
                showHideSubmitButton = false;
               
            }else{
                showHideSubmitButton = true;
            
            }
            
            // NZ CR Code Changes
       /**   if(application.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){  
                showHideSubmitButtonNZ = false;
            }
            
            if(application.Brand_Country__c !='AU'){ 
                
                if(statusAccessSubmitNZ && !profileAccessSubmitNZ)   {
                    showHideSubmitButtonNZ = false;
                } else{
                    showHideSubmitButtonNZ = true;
                }
            } **/
         
              if(statusAccessSubmitNZ && profileAccessSubmitNZ)   {
                    showHideSubmitButtonNZ = false;
                    showHideSaveQuoteButton = false;
                } else{
                    showHideSubmitButtonNZ = true;
                    showHideSaveQuoteButton = true;
                }

            if(resVerifyPOI && proVerifyPOI && isSystemReasonCode(GEN_OriginationsConstants.STRING_POI)){
                verifyPOIButton = false;
            }else{
                verifyPOIButton = true;
            }
            
            if(resUpdateApplication && proUpdateApplication){

                updateApplicationButton = false;
             

            }else{
                updateApplicationButton = true;
                 
            }

            if(resUserLogin && proUserLogin){
                userLoginButton = false;
            }else{
                userLoginButton = true;
            }

            if(resUserLogin2 && proUserLogin2){
                userLoginButton2 = false;
            }else{
                userLoginButton2 = true;
            }
            
            if(resGenDoc && proGenDoc){
               showGenerateDoc = false; 
            }else{
               showGenerateDoc = true;
            }

            if(resOffers && proOffers){
                showOffers = true;
            }else{
                showOffers = false;
            }
           
            if(resCover && proCover){
                faxCoverSheetButton = false;
            }else{
                faxCoverSheetButton = true;
            }

            if(resChangeOwner && proChangeOwner){
                changeOwnerButton = false;
            }else{
                changeOwnerButton = true;
            }

            //Added by Fel Saliba 1/8/2014 - button enable/disable
            if(application.Submission_Status__c != null){

                Boolean statusAccessOffer = Response_Code_Control__c.getInstance(application.Submission_Status__c).Accept_Offer_CLV__c;
                if(statusAccessOffer){
                    showHideOfferButton = false;
                }else{
                    showHideOfferButton = true;
                }
            }
            else{
                showHideOfferButton = true;
            }

            //BEGIN MDAVID: 08/13/15 PMIHM-132 - Credit application - Submit service available after application has been submitted
            /*if (application.Submission_Status__c == GEN_OriginationsConstants.APP_SUBMITTION_STATUS_SUBMIT_FAILURE && this.application.UID__c != ''){
                showHideSubmitButton = true;
                updateApplicationButton = false;
            }*/
            //END MDAVID 08/13/15 PMIHM-132 - Credit application - Submit service available after application has been submitted
        }else{
            showHideCloseButton = true;
            showHideCPUCaseButton = true;
            showHideEditButton = true;
            showHideSubmitButton = true;
            showHideSubmitButtonNZ = true;
            showHideOfferButton = true;
            verifyPOIButton = true;
            updateApplicationButton = true;
            userLoginButton = true;
            userLoginButton2 = true;
            showGenerateDoc = true;
            showOffers = false;
            Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');            
        }
    }
    
    public APP_ApplicationMain_INTCC() {
        
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    /*  Description: Update blackbox related fields on Application object
     *  Author: Mike Lasala
     *  Date Created: OCT-08-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference updateFPfields(){
        this.application.FP_IP_Address__c = getIPAddress();
        
        //Determine whether Application came from Staff or Online
        isCust = isCustomer();
        
        this.application.FP_Black_Box__c = blackboxTxt;
        this.application.Fingerprint_Step__c = GEN_OriginationsConstants.IOVATION_FINGERPRINT_STEP;
        
        if(this.application.FP_IP_Address__c == null || this.application.FP_IP_Address__c == '' || this.application.FP_IP_Address__c == 'ERR1'){
            this.application.FP_IP_Address__c = 'ERR1';
        }
        if(this.application.Brand_Lookup__c != null){
            // June 29, 2016- Afreen - Added the field iOvation_Type_3rd_Party__c
            Brand__c appBrand = [SELECT iOvation_Type_Online__c, 
                                        iOvation_Type_Sales__c , iOvation_Type_3rd_Party__c 
                                 FROM   Brand__c 
                                 WHERE  Id =: this.application.Brand_Lookup__c];
            
            if(isCust){
                // June 29, 2016- Afreen - assign the iovation type based on the channel
                if(this.application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_3RD_PARTY){
                    this.application.iOvation_Type__c = appBrand.iOvation_Type_3rd_Party__c;
                }else{
                    this.application.iOvation_Type__c = appBrand.iOvation_Type_Online__c;
                }
            } else {
                this.application.iOvation_Type__c = appBrand.iOvation_Type_Sales__c;
            }
        }
        
        //MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
        this.application.Initial_Requested_Amount__c = this.application.Total_Loan_Amount__c;
        
        try{
            update application;
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'APP_ApplicationMain_INTCC', 'Application__c', 'Class', String.valueOf(this.application.Id));
            currenTab = 'appTab';    
        }
        
        //BEGIN MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
        return null;

        //String requestedName = getRequestedName();

        //List<IS_ValidationError> validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(this.application.id,Util.getUser().Mock_Enable__c, requestedName, null);
        
        //PageReference ref;
        //if(validationErrors.size()>0) {
        //    //validation failed
        //    Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors:');
        //    for(IS_ValidationError iv: validationErrors){
        //        Util.addMessage(ApexPages.Severity.ERROR, iv.errorDescription);
        //    }
        //    return null;
        //} else {
        //    // FS commented out, application extract should be called after the UID is populated.
        //    //generate an application extract if submit service is successful
        //    //IS_GenerateApplicationExtract.generateApplicationExtractRequest(this.application.id,Util.getUser().Mock_Enable__c, requestedName, null);
        //    currenTab = 'offerTab';            
        //    PageReference pageRef = Page.App_WaitPageStaff;
        //    pageRef.getParameters().put('id', String.valueOf(this.application.Id));        
        //    pageRef.setRedirect(true);
        //    return pageRef;
        //}
        //END MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
    }

    /*  Description: Get User's IP Address
     *  Author: Mike Lasala
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: String
     */     
    public static String getIPAddress() {
        string ipAddress = '';
    
       //  ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');
       
       ipAddress = ApexPages.currentPage().getParameters().get('HTTP_CLIENT_IP');
             
        if (ipAddress == '' || ipAddress == null) {
            // get IP address when no caching (sandbox, dev, secure urls)
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        
        return ipAddress;
    }

    /*  Description: Redirect to Product & Eligibility for editing current Application through wizard (Staff UI)
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: PageReference
     */ 
    public PageReference editApplication(){
        PageReference pageRef = Page.APP_ProductEligibility_INT;
        pageRef.getParameters().put('id', String.valueOf(this.application.Id));
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*  Description: Invoke web service and set focus tab
     *  Author: Mike Lasala
     *  Input Parameters: None
     *  Return: void
     */
    public PageReference submitApplication(){
        currenTab = 'offerTab'; 
        return null;
    }
    
    /*  Description: Method to update the application
     *  Author: Russell Cadapan
     *  Input Parameters: None
     *  Return: PageReference
     */
     
     public PageReference updateApplication(){
        //currenTab = 'offerTab';
        
        List<IS_ValidationError> validationErrors = IS_ApplicationUpdate.applicationUpdateRequest(this.application.id,Util.getUser().Mock_Enable__c, getRequestedName(), null);
    
        if(validationErrors.size()>0) {
            currenTab = 'appTab';
            //validation failed
            for(IS_ValidationError i: validationErrors){
                Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
            }
            
            return null;
        } else {
            
            //BEGIN MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
            
            //Requery application to check if doc gen was clicked
            this.application = APP_CommonVariables.retrieveApplication(this.application.Id);

            //Validate if doc gen was done
            if(application.Doc_Gen_Check__c){

                //Validate if update is because of doc gen
                if(application.Update_Doc_Gen_Check__c){

                    //Set update doc gen check flag
                    application.Update_Doc_Gen_Check__c = false;
                } else {

                    application.Update_Doc_Gen_Check__c = true;
                }

                try{
                    update application;
                }
                catch(Exception e){
                    ErrorHandlerException.recordException(e.getMessage(),'updateApplication','Application__c','APP_ApplicationMain_INTCC', String.valueOf(application.Id));
                }
            }
            //END MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT

            currenTab = 'offerTab';
            PageReference ref;
            ref = Page.APP_WaitPageStaff;
            ref.getParameters().put('id', String.valueOf(this.application.Id));            
            ref.getParameters().put('submit', String.valueOf('true'));
            ref.setRedirect(true);
            return ref;
        }
     }

    /* Description: Go to sales ui register user page
    *  Author: Jade Serrano
    *  Date Created: 30-OCT-2013
    *  Input Parameters:
    *  Return:
    */
    public PageReference creatUser(){
        PageReference pageRef = Page.APP_Register_INT;
        pageRef.getParameters().put('id', String.valueOf(this.application.Id));
        pageRef.getParameters().put('mode', 'Edit');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /* Description: Go to sales ui cancel application page
    *  Author: Jade Serrano
    *  Date Created: 04-NOV-2013
    *  Input Parameters:
    *  Return:
    *  History: 30-SEP-2014 : Updated to add cancellation of unsubmitted application
    */
    public PageReference cancelApplication(){
        if(this.application.Response_Code__c!='New'){       //check the status of the application
            
            PageReference pageRef = Page.APP_CancelApplication_INT;
            pageRef.getParameters().put('id', String.valueOf(this.application.Id));
            pageRef.setRedirect(true);
            return pageRef;
            
        }else{
            cancelUnsubmittedApplication();
            currenTab = 'appTab';
            PageReference pageRef = new PageReference('/apex/APP_ApplicationMain_INT?id='+applicationId+'&tab=appTab');
            pageRef.getParameters().put('id', String.valueOf(this.application.Id)); 
            pageRef.getParameters().put('tab', 'appTab');      
            pageRef.setRedirect(true);
            return pageRef;         
        }
    }
    
   /* Description: Capability to close an application even is not submitted
    *  Author: Ronaldo Dela Cruz(Oakton)
    *  Date Created: 30-SEPT-2014
    *  Input Parameters:
    *  Return:
    */
    private void cancelUnsubmittedApplication(){
        this.application.Status__c='Abandoned';
        this.application.Response_code__c= 'Abandoned';
        Savepoint sp;
        try{
            update this.application;
            System.debug('appId===>'+appId);
              APP_CancelApplication_INTCC.disablePortalUser(appId);
        
        }catch(Exception e){
            //exception log
            system.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'cancelUnsubmittedApplication()', 'APP_ApplicationMain_INTCC', 'Class', String.valueOf(applicationId));
            Util.addMessage(ApexPages.Severity.ERROR, 'There has been an error, please notify your administrator');
               
            if(sp!=null) {
                Database.rollback( sp ); //rollback if an exception occured
            }
        
        
        }
    
    }
    
    
    /* Description: Method for verifying AML
     *  Author: Fel Saliba
     *  Date Created: NOV-20-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference verifyPOI(){
       try{
            List<IS_ValidationError> validationErrors = IS_VerifyPOI.verifyPOIRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
            
            if(validationErrors.isEmpty()){

                refreshApplication();
            }
            else{
                //validation failed
                for(IS_ValidationError i: validationErrors){
                  Util.addMessage(ApexPages.Severity.ERROR, i.errorDescription);
                }
            }
            return null;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
            return null;   
        }       
    }
    
    /* Description: Method for accepting Offer
     *  Author: Fel Saliba
     *  Date Created: DEC-08-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
     /*
    public PageReference acceptOffer(){
       try{
            List<IS_ValidationError> validationErrors = IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null, null);
            
            if(validationErrors.isEmpty()){            
            PageReference ref;
            ref = Page.APP_GenerateDocumentWait;           
            ref.getParameters().put('id', String.valueOf(application.Id));            
            ref.setRedirect(true);
            return ref;
            }
            else{
                //validation failed
            
                //TODO: iterate through the errors and display properly
                //Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: ' + validationErrors);
            
                for(IS_ValidationError i: validationErrors){
                  Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
                }
                currenTab  = 'settleTab';
                settlementTab = 'securityTab';
                return null;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
            return null;
        }
    }
    */

     // Public variables for validatio errors in doc gen
    public List<IS_ValidationError> validationErrors;
    public Boolean docGenFailed;

    /* Description: Method for accepting Offer and document generation. Replacement method for the original method commented above.
                    The new method willl now only contain DMLs while all of its callouts is placed in a separate method called fireDocGenServiceCall.
     *  Author: Adrian Recio
     *  Date Created: -23-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public void acceptOffer(){
       validationErrors = new List<IS_ValidationError>();
       docGenFailed = false;

       try{
            validationErrors = IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null, null); 
        }catch(Exception e){
            docGenFailed = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
        }
    }

    /* Description: Second layer method to fire synchronous web service 
                    callout after a dml in acceptOffer Method.
     *  Author: Adrian Recio
     *  Date Created: 09-22-2015
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference fireDocGenServiceCall(){
        if(validationErrors.isEmpty() && docGenFailed==false){  
            try{ 
                // Call sync webservice to perform doc gen        
                IS_GenerateDocument.generateDocumentRequest(application.Id, Util.getUser().Mock_Enable__c,  Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));
                return null;
            }
            PageReference ref = Page.APP_GenerateDocumentWait;           
            ref.getParameters().put('id', String.valueOf(application.Id));            
            ref.setRedirect(true);
            return ref;
        }else{ 
            for(IS_ValidationError i: validationErrors){
              Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
            }
            currenTab  = 'settleTab';
            settlementTab = 'securityTab';
            return null;
        }
    }

   /* 
    *  Description: Refresh application when status has changed
    *  Author: Michael Lasala
    *  Input Parameters: None
    *  Return: Void
    */
    public void refreshApplication () {
        this.application = APP_CommonVariables.retrieveApplication(this.application.Id);
        queryComplianceCheck(this.application.Id);
    }

    public void queryComplianceCheck(String appId){
        pfrCount = 0;
        bmCount = 0;
        List<Compliance_Check__c> complianceList = new List<Compliance_Check__c>();
        complianceList = [SELECT     Id, PFR_Check__c, BM_Check__c
                          FROM       Compliance_Check__c 
                          WHERE      Application__c =: appId
                          AND        (Pre_Contract_Indicator__c = true OR Pre_Settlement_Indicator__c = true)];
        
        if(!complianceList.isEmpty()){
            for(Compliance_Check__c c: complianceList){
                if(c.PFR_Check__c != null){
                    pfrCount++;
                }
                if(c.BM_Check__c != null){
                    bmCount++;
                }
            }
        }
    }

    /* Description: Change Brand Button Action
    *  Author: Fel Saliba
    *  Date Created: 30-OCT-2014
    *  Input Parameters:
    *  Return:
    */
    public PageReference changeBrand(){

        String originalBrand = application.Brand_String__c;       
        List<Brand__c> brands = new List<Brand__c>();        
        List<Branch__c> branch = new List<Branch__c>();
        if(application.Branch_Id__c == '191' || application.Branch_Id__c == '181'){ //Modified by Davey 08/04/2015 - Change branch Id from 181 to 191
            branch = [Select Id, Branch_Id__c from Branch__c where Branch_Id__c =: '190' Limit 1]; //Modified by Davey 08/04/2015 - Change branch Id from 180 to 190
            brands = [Select Id, Name from Brand__c 
                      where Country__c =: 'NZ'
                      AND Name =: 'Kiwibank'];
        }
        
        //BEGIN MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        else if(application.Branch_Id__c == '190' || application.Branch_Id__c == '180'){  //Modified by Davey 08/04/2015 - Change branch Id from 180 to 190
            branch = [Select Id, Branch_Id__c from Branch__c where Branch_Id__c =: '191' Limit 1]; //Modified by Davey 08/04/2015 - Change branch Id from 181 to 191
            brands = [Select Id, Name from Brand__c 
                      where Country__c =: 'NZ'
                      AND Name =: GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ];
        }
        //Added by DYU 04-30-2015 Defect 942 - Auto change brand for branches 190 and 191
        else if(application.Branch_Id__c == '190'){
            branch = [Select Id, Branch_Id__c from Branch__c where Branch_Id__c =: '191' Limit 1];
            brands = [Select Id, Name from Brand__c 
                      where Country__c =: 'NZ'
                      AND Name =: GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ];
        }else if(application.Branch_Id__c == '191'){
            branch = [Select Id, Branch_Id__c from Branch__c where Branch_Id__c =: '190' Limit 1];
            brands = [Select Id, Name from Brand__c 
                      where Country__c =: 'NZ'
                      AND Name =: GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ];
        }
        //END MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        
        if(brands != null && brands.size()>0 && branch != null && branch.size()>0){

            application.Brand_Lookup__c = brands[0].Id;
            application.Brand_String__c = brands[0].Name;
            application.Branch__c = branch[0].Id;
            application.Out_Of_Sync__c = true;
            application.Need_Deal_Reallocation__c = false;
           
            String prodtype = GEN_OriginationsConstants.PRODUCT_TYPE;

            List<Product_Version__c> prodVersion = new List<Product_Version__c>();
            prodVersion = [Select Id, GEProduct__c from Product_Version__c
                           Where GEProduct__r.Brands__c =: brands[0].Id
                           And Type__c =: prodtype];

            List<Product_Item__c> prodItem = [Select Id, Product_Version__c from Product_Item__c
                                            Where Application__c =: application.Id
                                            And Product_Version__r.Type__c =: prodtype];
            if(prodVersion.size() == 1)
                application.product_id__c = prodVersion[0].GEProduct__c;
                               
            //CHBRAND Query Applicant1.2 account on application to determine whether community user has been created 
            List<ID> applicantList = new List<ID>();                              
            List<User> communityUserList = new List<User>();
            
            if(application.Applicant1__c != null || application.Applicant2__c != null){
                //If community users are created the Person Account will be placed in application
                communityUserList = [SELECT id FROM User WHERE AppId__c = : application.id];                
            }
                         
            //BEGIN MLASALA: 08/07/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            Debug_Log__c debugLog;
            
            //Check if application has insurance
            if(application.Brand_String__c != originalBrand && 
               application.Total_Insurance_Premium__c != null && 
               application.Total_Insurance_Premium__c != 0){

                //Populate insurance info message
                application.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(application.Id, 
                                                                                         application.Insurance_Error_Message__c, 
                                                                                         GEN_OriginationsConstants.BRAND_SWAP_INSURANCE_INFO_MESSAGE);
                //Create debug log record
                debugLog = Util.createInsuranceActivity(application.Id, 
                                                        'Flush', 
                                                        GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                        'System', 
                                                        application.Total_Insurance_Premium__c, 
                                                        0);

                //Set total insurance premium to zero.
                application.Total_Insurance_Premium__c = 0;
                
                if(debugLog != null){
                //Insert record
                    try{
                        insert debugLog;
                    } catch(DMLException e){
                        ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', debugLog.Application__c);
                    }
                }
            }
            //END MLASALA: 08/07/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                    
            try{

                update application;
                
                if(application.Brand_String__c != originalBrand){
                    if(prodItem != null && prodItem.size()>0){
                        prodItem[0].Product_Version__c = prodVersion[0].Id;
                        
                        update prodItem;                
                    }
                    List<Application__c> applist = new List<Application__c>();
                    applist.add(application);

                    //flush all the insurance product first
                    GEN_OfferUtility.flushOffers(appList);
    
                    //then flush compliance checklist and generated documents
                    GEN_PCAUtility.flushComplianceChecklistandLoanDocuments(applist);
                }
                
                //CHBRAND change the brand setting on all community users relate to this brand
                if(communityUserList.size() > 0){
                    for (User u : communityUserList){
                        u.Brand__c = brands[0].Name;
                    }
                }
                
                system.debug('!@#$communityUserList:'+communityUserList);
                
                update communityUserList;

                //BEGIN MLASALA 20-AUG-15 PMIHM-1858 
                if(Util.nullCheck(application.Credit_Score__c) && 
                   application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
                    List<Id> applicationIdList = new List<Id>();

                    applicationIdList.add(application.Id);

                    if(!applicationIdList.isEmpty()){
                        //Run Pricing Rule engine
                        RUL_Engine.runPricingEngineAsync(applicationIdList);
                    }
                }
                //END MLASALA 20-AUG-15 PMIHM-1858

                PageReference pageRef = Page.APP_ApplicationMain_INT;
                pageRef.getParameters().put('Id',this.application.Id);
                pageRef.setRedirect(true);

                return pageRef;   
            }
            catch(DmlException e){
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                return null;               
            }        
        }
        else{

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No other Brand found for NZ'));
            return null;   
        }
    }

    /* Description: Check liabilities if it is auto created from applicant account
     *  Author: Davey Yu
     *  Date Created: 13-AUG-2015
     *  Param: applicants - Applicant IDs
     *  Return: Boolean
     */
    public boolean checkLiabilities(String appId){
        List<Applicant__c> applicants = new List<Applicant__c>();
        applicants = [SELECT id FROM Applicant__c WHERE Application__c =: appId];
        if(applicants.size() > 0){
            List<Liability__c> liabilities = new List<Liability__c>();
            liabilities = [SELECT Debt_Auto_Created__c FROM Liability__c WHERE Applicant__c IN :applicants];
            if(liabilities.size() > 0){
                for(Liability__c debt: liabilities){
                    if(debt.debt_auto_created__c){
                        return true;
                        break;
                    }
                }
            }
        }
        return false;
    }

    /* Description: Get liability warning message if debt is auto created
     *  Author: Davey Yu
     *  Date Created: 13-AUG-2015
     *  Param: None
     *  Return: String
     */
    public string getLiabilityMessage(){
        Admin_Settings__c adSettings = Admin_Settings__c.getValues('Liability Warning');
        return adSettings.Value__c;
    }

    //BEGIN MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
    /* 
    *  Description: Method to move async to sync calls SUBMIT
    *  Author: Michael Lasala
    *  Input Parameters: None
    *  Return: PageReference
    */
    public PageReference submitServiceCall(){
        String requestedName = getRequestedName();

        List<IS_ValidationError> validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(this.application.id,Util.getUser().Mock_Enable__c, requestedName, null);

        currenTab = 'offerTab';            
        PageReference pageRef = Page.App_WaitPageStaff;
        pageRef.getParameters().put('id', String.valueOf(this.application.Id));        
        pageRef.setRedirect(true);
        return pageRef;
    }
    //END MLASALA: 17-SEPT-15 - ASYNC TO SYNC CALL OUT
    
    //BEGIN MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
    /* 
    *  Description: Assign to LPE Queue when Application is Conditionally Approved
    *  Author: Michael Lasala
    *  Date Created: 29-FEB-16
    *  Input Parameters: None
    *  Return: PageReference
    */
    public PageReference assignToLPE(){
        
        if(application.Out_Of_Sync__c){
            
            //Display error message when out of sync
            Util.addMessage(ApexPages.Severity.ERROR, 'Application is out of sync, please update Application before assigning to LPE Queue.');
            
            return null;
        } else {
            
            //Retrieve LPE Queue Id
            Group LPEQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =: GEN_OriginationsConstants.LPE_QUEUE_DEVELOPERNAME LIMIT 1];
            
            //Assign reporting fields
            application.Owner_at_Release_to_LPE_Queue__c = previousOwnerId;
            application.OwnerId = LPEQueue.Id;
            application.Release_to_LPE_Queue_Datetime__c = DateTime.now();
            application.Cash_Amount_on_Release_to_LPE_Queue__c = application.Total_Loan_Amount_New_Cash__c;
            application.Branch_Name_at_release_to_LPE_queue__c = reportingUser.UserRole.Name; // 24-06-2016 - Afreen - Assign User Role - User Story 300
            
            try {
                update application;
            } catch (DMLException e) {
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ApplicationMain_INTCC', 'Application__c', 'Class', String.valueOf(application.Id));
            }
            
            PageReference pageRef = Page.APP_ApplicationMain_INT;
            pageRef.getParameters().put('id', String.valueOf(application.Id));
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    //END MLASALA: 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
    
    //Redirects to Save Quote PAge for NZ CR Code changes 
     public PageReference saveQuote(){
        PageReference pageRef = Page.APP_SaveQuote_INT;
        pageRef.getParameters().put('id', String.valueOf(application.Id));
        pageRef.setRedirect(true);
        return pageRef;
    }
     
     public pagereference SubmitQuoteNZFlag(){
              this.application = APP_CommonVariables.retrieveApplication(this.application.Id);
             //Set update submit NZ flag    
               if(application.NZ_Submit_Flag__c == false){
                    application.Out_Of_Sync__c= true;
                   application.NZ_Submit_Flag__c = true;
                }
                try{        
                  update application;
                }
                catch(Exception e){
                    ErrorHandlerException.recordException(e.getMessage(),'SubmitQuoteNZFlag','Application__c','APP_ApplicationMain_INTCC', String.valueOf(application.Id));
                }
       return null;
     }
     
     public pagereference CallUpdateService(){
     
         List<IS_ValidationError> validationErrors = IS_ApplicationUpdate.applicationUpdateRequest(this.application.Id,Util.getUser().Mock_Enable__c,Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                                     
                     if(validationErrors.size()>0) {
                         currenTab = 'appTab';
                          for(IS_ValidationError i: validationErrors){
                            Util.addMessage(ApexPages.Severity.ERROR, 'Validation Errors: '+i.errorDescription);
                           }
                                        
                         return null;
                      }
                      else{
                        currenTab = 'offerTab';
                        PageReference ref;
                        ref = Page.APP_WaitPageStaff;
                        ref.getParameters().put('id', String.valueOf(this.application.Id));            
                        ref.getParameters().put('submit', String.valueOf('true'));
                        ref.setRedirect(true);
                        return ref;
                    
                      }              
                 
                   
     }
    
}