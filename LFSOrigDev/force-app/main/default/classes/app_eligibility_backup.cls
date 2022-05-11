/*
 * @Description: APP_Eligibility apex class
 * @Author: Jade Serrano
 * @Date Created: 13-MAR-2014
 * @History:
 *  =====================================================================
 *      Jade - 13-MAR-2014: Created
        vijay  25-NOV-2014: DBHZL-54 Eligibility Copy & Acknowledgements 
        04-09-2015 - Updated to remove validation from PRS - DY
    25-Feb-2015 - Updated to add the Broker details functionalities
 *  =====================================================================
 */
public without sharing class app_eligibility_backup {
    //Loan Purpose variables
    public String url;
    public String partnerURL;
    public Boolean isPartner {get;set;}
    public List<loanWrapper> loanWrapList           {get;set;}
    public Integer loanPurposeSize                  {get;set;}
    public String loanFrequencySelected             {get;set;}
    public String loanTermSelected                  {get;set;}
    public Boolean loanTermNotValid                 {get;set;}
    public Boolean paymentNotValid                  {get;set;}
    public Boolean loanAmountNotValid               {get;set;}
    public Decimal totAmount                        {get;set;}
    
    //315
   // public Boolean pbuidNotValid               {get;set;}
    public String pbuid                             {get;set;}
    public Boolean isApp1AccessNumber              {get;set;}
    public String app1AccessNumber           {get;set;}
    public Boolean isApp2AccessNumber                {get;set;}
    public String app2AccessNumber           {get;set;}
       
    public String result                            {get;set;}
    public String applicationType                   {get;set;}
    public Boolean disableApplicationType           {get;set;}
    public Boolean confirmHigherApprovalConsent     {get;set;}

    //applicant 1
    //checkboxes
    public Boolean confirmEligibleForLoan           {get;set;}
    public Boolean confirmApplicationMeetsNeeds     {get;set;}
    public Boolean confirmAgreedToPolicy            {get;set;}

    //Added by Arshad as per BDR - 105
    public Boolean confirmConsentToLpi              {get;set;}
    
    public Boolean confirmAllowInsuranceOffers      {get;set;}
    public Boolean confirmReadCreditGuide           {get;set;}
    public Boolean confirmInterestedInOtherOffer    {get;set;}
    //applicant 1 first name
    public String applicant1FirstName               {get;set;}
    public Boolean confirmKBHLGraduateCustomer          {get;set;}
    
    //applicant 2
    //checkboxes
    public Boolean confirm2EligibleForLoan          {get;set;}
    public Boolean confirm2ApplicationMeetsNeeds    {get;set;}
    public Boolean confirm2AgreedToPolicy           {get;set;}

    //Added by Arshad as per BDR - 105
    public Boolean confirm2ConsentToLpi             {get;set;}

    public Boolean confirm2AllowInsuranceOffers     {get;set;}
    public Boolean confirm2ReadCreditGuide          {get;set;}
    public Boolean confirm2InterestedInOtherOffer   {get;set;}
    //applicant 2 first name
    public String applicant2FirstName               {get;set;}
    public Boolean confirm2KBHLGraduateCustomer          {get;set;}

    public List<Brand_Content__c> eligiblityQuestions {get;set;}
    public String brandName {get;set;}

    transient public Boolean isJoint;
    public Boolean loanValidationResults            {get;set;}
    public Boolean existingApplication;
    public String prodId;

    public Boolean errorFName1                      {get;set;}
    public Boolean errorFName2                      {get;set;}
    public String errorFName1Msg                    {get;set;}
    public String errorFName2Msg                    {get;set;}
    public String titleStyle                        {get;set;}
    List<Applicant__c> applicantList;
    public String applicationId;
    //Added by vijay on 24/11/2014
    public string siteName{get;set;}
    
    //
    public Brand__c currentBrand{get;set;}
    
    
    public Contact brokerContact                        {get;set;}
    public Boolean isNotValidBroker                     {get;set;}
    public String brokerId                              {get;set;}
    public String brokerFName                           {get;set;}
    public String brokerLName                           {get;set;}
    public Decimal brokerFee                            {get;set;}
    public String brokerContactNumber                   {get;set;}
    public Id brokerRecordTypeId                        {get;set;}
    public Decimal validLPAmount                        {get;set;}  //ADDED RCADAPAN @ 08-MAR-2016 for TQLQW-29

    public Task callLog                                 {get; set;}
    public String kiwiComments                          {get; set;}

    private User systemUser;
    
    public Boolean securityTokenValid                   {get; set;}
    public String applicationSource                     {get; set;}
    
    // ADDED By Russell Cadapan for TQLQW-489 (Veda Qoute) - Veda URL Parameters
    public String vFName;
    public String vLName;
    public String vMName;
    public String vGender;
    public String vEmail;
    public String vMPhone;
    public String vLPhone;
    public String vDOB;
    public String vAddress;
    public String vExtId;
    public String vSourceId;
    public String vLAmount;
    public Boolean isAppFromVeda;
    public Boolean vedaAppError         {get;set;}
    public String vedaAppErrorMessage   {get;set;}
    //MLASALA 20-SEPT-16 TQLQW-487 Promo engine
    public String  promoId           {get;set;}
    public Boolean isPromo          {get;set;}
    public Boolean isValidPromo {get;set;}
    //AFREEN 23-SEPT-16 TQLQW-519 Web Analytics - Ensighten
   
    //public String omnitureURL {get;set;}   
            
    public app_eligibility_backup() {

        try{ 
             //TQLQW-481 [PL - AU] PicStarter - MDAVID - 8/30/2016 
             securityTokenValid = true;
         isPromo = false;
             //omnitureURL = Admin_Settings__c.getValues('Omniture Source').Value__c;   //AFREEN 23-SEPT-16 TQLQW-519 Web Analytics - Ensighten
             if(site.getName() == GEN_OriginationsConstants.BRAND_NAME_GEMONEY){
                 if (ApexPages.currentPage().getParameters().get('suid') != null){
                    String securityToken = ApexPages.currentPage().getParameters().get('suid'); 
                    List<Application__c> app = new List<Application__c>();
                    if(securityToken != ''){
                        app = [Select Id, X3rd_Party_Application_Source__c, X3rd_Party_Security_Token_Expiry_Date__c, Is_URL_Accessed__c from Application__c WHERE X3rd_Party_Security_Token__c =: securityToken LIMIT 1];
                    }
                    
                    DateTime currentDate = DateTime.now();
                    if(app.size() > 0){
                        if(app[0].X3rd_Party_Security_Token_Expiry_Date__c != null && app[0].X3rd_Party_Security_Token_Expiry_Date__c >= currentDate){
                            securityTokenValid = true;
                        }else{
                            securityTokenValid = false;
                        }
                        if(app[0].Is_URL_Accessed__c == true){
                            securityTokenValid = false;
                        }
                        
                        applicationSource = app[0].X3rd_Party_Application_Source__c;
                    }else{
                        securityTokenValid = false;
                    }
                    
                    if(securityTokenValid){
                        ApexPages.currentPage().getParameters().put('id', app[0].Id);
                    }else{
                        ApexPages.currentPage().getParameters().put('id', null);
                    }
                }
            }
            // Start - Verify that the customer UI is triggered via Veda redirection - by Russell Cadapan @ 02-SEP-2016
            isAppFromVeda = false;
            // try to pull parameter 'vSourceId', this indicates that the customer UI is triggered by Veda with parameters
            vSourceId = ApexPages.currentPage().getParameters().get('sourceid');
            
            if(vSourceId != null){
                // validate if the sourceId = '3', If so, set the boolean indicator and get all paramaters from URL
                if(vSourceId == '3'){
                    // set boolean indicator
                    isAppFromVeda = true;
                    
                    // set veda veda variables with the url parameters
                    getVedaParameters();
                }
            }
            // End
            
            brokerContact = new Contact();
            callLog       = new Task();
            brokerId = '';
            populateSystemUser();
            retrieveQuestions();    //Get eligibility questions by site
            applicationId = ApexPages.currentPage().getParameters().get('id');
            totAmount = 0;
            loanWrapList = new List<loanWrapper>(); 
            confirmInterestedInOtherOffer = false;
            confirm2InterestedInOtherOffer = false;
            confirmKBHLGraduateCustomer    = false;
            confirm2KBHLGraduateCustomer   = false;
            brokerRecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(GEN_OriginationsConstants.BROKER_RECORD_TYPE_APAC).RecordTypeId;
            
            // initialize veda error variables - ADDED by RCADAPAN for TQLQW-489
            vedaAppError = false;
            vedaAppErrorMessage = '';
            
            //MLASALA 22-SEPT-16 TQLQW-487 Promo Engine
            isValidPromo = false;
            
            //check for existing application
            if(applicationId==null){
                existingApplication = false;
                disableApplicationType = false;
                loanWrapList = new List<loanWrapper>();
                loanPurposeSize = 0;
                addLoanPurpose();
                confirmHigherApprovalConsent = false;
                // Start - Added by Russell Cadapan @ 02-SEP-2016 for TQLQW-489
                // if the customer is triggered by Veda, pre-fill fields in the page
                if(isAppFromVeda){
                    totAmount = Decimal.valueOf(vLAmount);
                    loanWrapList[0].loan.Loan_Amount__c = Decimal.valueOf(vLAmount);
                    applicant1FirstName = vFName;
                }
                //End
            }else{
                existingApplication = true;
                

                Application__c currentApplication = [SELECT Id, Campaign_Id__c, Broker_ID__c, Broker_First_Name_Captured__c, Broker_Last_Name_Captured__c, Brokerage_Fee__c, Broker_Contact_Number__c, Application_Type__c, Loan_Term_Months__c, Payment_Frequency__c, Higher_Approval_Consent__c, Loan_Term__c,Promo_ID__c
                                                     FROM   Application__c
                                                     WHERE  Id =: applicationId];                            

                applicationType = currentApplication.Application_Type__c;
                confirmHigherApprovalConsent = currentApplication.Higher_Approval_Consent__c;
                promoId            = currentApplication.Promo_ID__c;

                applicantList = [SELECT   Id, 
                                          Interested_in_other_services__c,
                                          First_Name__c,
                                          Is_Primary_Applicant__c,
                                          Meets_Eligibility_Criteria__c,
                                          Agrees_to_Fees__c,
                                          Agrees_to_Privacy_Policy__c,
                //Added by Arshad as per BDR - 105
                                          Consent_to_Lpi__c,
                                          KB_HL_or_Graduate__c,
                                          EIDV__c 
                                 FROM     Applicant__c 
                                 WHERE    Application__c =: applicationId 
                                 ORDER BY Is_Primary_Applicant__c DESC];
                if(applicationType == 'Single'){
                    disableApplicationType = false;
                }else{
                    disableApplicationType = true;
                }
                //check if there is an applicant attach to the application
                if(applicantList.size()>0){
                    confirmEligibleForLoan = applicantList[0].Meets_Eligibility_Criteria__c;
                    confirmApplicationMeetsNeeds = applicantList[0].Agrees_to_Fees__c;
                    confirmAgreedToPolicy = applicantList[0].Agrees_to_Privacy_Policy__c;
                    //confirmAgreedToPolicy = applicantList[0].Consent_to_Lpi__c;
                    //confirmConsentToLpi   = confirmAgreedToPolicy;
                    confirmAllowInsuranceOffers = true;
                    confirmReadCreditGuide = false;
                    if(util.nullCheck(applicantList[0].EIDV__c)) {
                        if(applicantList[0].EIDV__c == GEN_OriginationsConstants.CHOICE_YES){
                            confirmReadCreditGuide = true;
                        }
                    }
                    confirmInterestedInOtherOffer = applicantList[0].Interested_in_other_services__c;
                    confirmKBHLGraduateCustomer   = applicantList[0].KB_HL_or_Graduate__c;
                    applicant1FirstName           = applicantList[0].First_Name__c;

                    //Afreen- 28/04/2016 : User story 271 changes to put the details back on screen when the page is access again from Loan Details button (Side bar component) 
                    brokerId                      = currentApplication.Broker_ID__c;
                    brokerFName                   = currentApplication.Broker_First_Name_Captured__c;
                    brokerLName                   = currentApplication.Broker_Last_Name_Captured__c;
                    brokerFee                     = currentApplication.Brokerage_Fee__c;
                    brokerContactNumber           = currentApplication.Broker_Contact_Number__c;

                    isJoint = false;
                    //check if there is a second applicant
                    if(applicantList.size()>1){
                        confirm2EligibleForLoan       = applicantList[1].Meets_Eligibility_Criteria__c;
                        confirm2ApplicationMeetsNeeds = applicantList[1].Agrees_to_Fees__c;
                        confirm2AgreedToPolicy        = applicantList[1].Agrees_to_Privacy_Policy__c; 
                    //Added by Arshad as per BDR - 105
                        //confirm2ConsentToLpi          = confirm2AgreedToPolicy;
                        confirm2KBHLGraduateCustomer  = applicantList[1].KB_HL_or_Graduate__c;

                        confirm2AllowInsuranceOffers = true;
                        confirm2ReadCreditGuide = false;
                        if(util.nullCheck(applicantList[1].EIDV__c)){
                            if(applicantList[1].EIDV__c == GEN_OriginationsConstants.CHOICE_YES){
                                confirm2ReadCreditGuide = true;
                            }
                        }
                        confirm2InterestedInOtherOffer = applicantList[1].Interested_in_other_services__c;
                        applicant2FirstName = applicantList[1].First_Name__c;
                        isJoint = true;
                    }
                }

                List<Loan_Purpose__c> temporaryLoanPurposeList = new List<Loan_Purpose__c>();
                temporaryLoanPurposeList = GEN_RecordRetrievalUtility.retrieveLoanPurposeList(applicationId);
                if(!temporaryLoanPurposeList.isEmpty()){
                    loanTermSelected = currentApplication.Loan_Term__c;
                    loanWrapList = new List<loanWrapper>();
                    for(Loan_Purpose__c lp: temporaryLoanPurposeList){
                      loanWrapper lw = new loanWrapper();
                      lw.loan = lp;
                      loanWrapList.add(lw);
                      if(lp.Loan_Amount__c != null)
                        totAmount += lp.Loan_Amount__c;                            
                    }
                    loanPurposeSize = temporaryLoanPurposeList.size();
                } else {
                    loanWrapList = new List<loanWrapper>();
                    loanPurposeSize = 0;
                    addLoanPurpose();
                }
            }
            
            Brand__c bVar = pullBrandBySite(site.getName());
            if(bVar != null){
              brandName = bVar.Brand_Display_Name__c;
              //Added by vijay on 24/11/2014
              siteName=bVar.country__c;
              
              //
              currentBrand = bVar;
            }
        }
        catch(VisualforceException err){
            Util.addMessage(ApexPages.Severity.ERROR, Label.Application_ID_Error);
        }    
        
        /* Unique Partner URL for Latitude and GEM as part of 3rd Party Applications
           Added by Arshad 14/08/2018 */
       
        List<Partner__c> urlPattern = [select Name,Country__c from Partner__c];
        isPartner = false;
        for(Partner__c partnr : urlPattern){
           if(ApexPages.currentPage().getParameters().get('partnername') != null && ApexPages.currentPage().getParameters().get('partnername') ==  'partner_'+partnr.Name+'_'+partnr.Country__c){
           //if(ApexPages.currentPage().getParameters().get('partner') != null && ApexPages.currentPage().getParameters().get('partner') == partnr.Name){
           isPartner = true;
        }
        }              
    }

    /*  Description: Populate Sys User Id
     *  Author: Afreen Khan
     *  Date Created: March-10-2016
     *  Return: void
     */
    private void populateSystemUser(){
       systemUser = [Select Id From User where Username Like 'gewsprod@ge.com%' Limit 1];
    }
    /*  Description: Add new Loan Purpose record
     *  Author: Fel Saliba
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void addLoanPurpose(){
        loanWrapList.add(new loanWrapper());
        loanPurposeSize++;        
        calculateLoanAmountTotal();
        refreshCount();
    }
    /*  Description: Remove Loan Purpose record
     *  Author: Fel Saliba
     *  Date Created: SEPT-25-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void removeLoanPurpose(){
        if(loanWrapList.get(loanWrapList.size()-1).loan.Id!=null) {
                Loan_Purpose__c lpToDelete = new Loan_Purpose__c();
                lpToDelete.Id = loanWrapList.get(loanWrapList.size()-1).loan.Id;
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Loan_Purpose__c.SObjectType.getDescribe().isDeletable()){
                  delete lpToDelete;
                }
                */
                delete lpToDelete;
        }
        loanWrapList.remove(loanWrapList.size()-1);
        loanPurposeSize--;
        calculateLoanAmountTotal();
    }
    
    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshCount(){
        Integer i = 0;
        for(loanWrapper loa: loanWrapList){
            loa.rowCount = i;
            i++;
        }
    }
    
    /*  Description: Calculate the Total Loan Amount
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-1-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void calculateLoanAmountTotal(){
        totAmount = 0;
        for(loanWrapper lp: loanWrapList){
            if(lp.loan.Loan_Amount__c != null){
                totAmount += lp.loan.Loan_Amount__c;
            }
        }
    }
    
     /*  Description: Method to pull brand based on current site name
     *  Author: Adrian Recio
     *  Date Created: 3/19/2014
     *  Input Parameters: siteName(string)
     *  Return: Brand__c
     */
    public Brand__c pullBrandBySite(string siteName){
        // query brand based on site
        List<Brand__c> brandVar = [SELECT   Id, 
                                            Name, 
                                            Getting_Started_HTML__c, 
                                            Eligibility_HTML__c, 
                                            Brand_Display_Name__c, 
                                            Site__c, 
                                            Country__c, 
                                            Online_Branch__c,
                                            Contact_Number__c
                                   FROM     Brand__c 
                                   WHERE    Site__c = :siteName LIMIT 1];
        if(brandVar.size()>0){
            return  brandVar[0];
        }
        
        return null;
    }
    
    /*  Description: Method to retrieve eligibility questions based on Site
     *  Author: Mike Lasala
     *  Date Created: 5/22/2014
     *  Input Parameters: None
     *  Return: List<Brand_Content__c>
     */
    public List<Brand_Content__c> retrieveQuestions(){
        if(isBrokerChannel()){
            eligiblityQuestions = [SELECT Brand__r.Name, Output_HTML__c, Brand__r.Site__c FROM Brand_Content__c ];//WHERE Brand__r.Site__c =: site.getName() AND Description__c = 'Eligibility Broker Questions' ORDER BY Name ASC];
        }else{
            eligiblityQuestions = [SELECT Brand__r.Name, Output_HTML__c, Brand__r.Site__c FROM Brand_Content__c];// WHERE Brand__r.Site__c =: site.getName() AND Description__c = 'Eligibility Questions' ORDER BY Name ASC];
        }      

        if(eligiblityQuestions.get(0).Brand__r.Name==GEN_OriginationsConstants.BRAND_NAME_AUSSIE) {
            titleStyle = 'txt-purple';
        } else if(eligiblityQuestions.get(0).Brand__r.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY) {
            titleStyle = 'txt-blue';
        }

        return eligiblityQuestions;
    }

    /*  Description: 
     *  Author: Afreen Khan
     *  Date Created: Mar-04-2016
     *  Input Parameters: None
     *  Return: List<Brand_Content__c>
     */
    public Boolean isBrokerChannel(){
        if(ApexPages.currentPage().getParameters().get('form') != null && ApexPages.currentPage().getParameters().get('form') == GEN_OriginationsConstants.ELIGIBITIY_BROKER_PARAMETER){
            return true;
        }
        else{
            return false;
        }
    }
        
    /*  Description: 
     *  Author: Afreen Khan
     *  Date Created: Mar-10-2016
     *  Input Parameters: None
     *  Return: List<Brand_Content__c>
     */
    public Boolean isKiwiBankPostShop(){
        if(ApexPages.currentPage().getParameters().get('form') != null && ApexPages.currentPage().getParameters().get('form') == GEN_OriginationsConstants.ELIGIBILTY_KIWIBANK_POSTSHOP_PRAMETER){
            return true;
        }
        else{
            return false;
        }
    }

    /*  Description: Method to product version based on brand
     *  Author: Adrian Recio
     *  Date Created: 3/19/2014
     *  Input Parameters: siteName(string)
     *  Return: Brand__c
     */
    public Product_Version__c pullprVersion(Id brandId){
        List<Product_Version__c> prodVer = [Select Id,GEProduct__c FROM Product_Version__c
                                                            WHERE GEProduct__r.Type__c = 'Personal Loan' 
                                                            AND (Start_Date__c = null OR Start_Date__c <= TODAY)
                                                            AND  (End_Date__c = null  OR End_Date__c >= TODAY)
                                                            And GEProduct__r.Brands__c =:brandId limit 1];
        if(prodVer!=null){
            return prodVer[0];
        }                       
        
        return null;                
    }
    
    /*  Description: Method to assign product and brand to application
     *  Author: Adrian Recio
     *  Date Created: 3/19/2014
     *  Input Parameters: siteName(string)
     *  Return: Brand__c
     */
    public void assignProductAndBrand(Application__c appVar){
        //Pull brand by current site
        Brand__c bVar = pullBrandBySite(site.getName());

        if(bVar!=null){
            
            // Assign brand lookup and brand name
            appVar.Brand_Lookup__c = bVar.Id;
            appVar.Brand_String__c = bVar.Name;
            appVar.Mirror__c = GEN_OriginationsConstants.APPLICATION_SOURCE_INTERNET; //P-88
            appVar.Type_of_Product__c = GEN_OriginationsConstants.PRODUCT_TYPE;

            if(util.nullCheck(bVar.Online_Branch__c)){
                appVar.Branch__c = bVar.Online_Branch__c;
            }

            //assign business source based on brand
           if(bVar.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY) {
                appVar.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_INTERNET_APPLICATION;
            } else if(bVar.Name==GEN_OriginationsConstants.BRAND_NAME_AUSSIE) {
                appVar.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_WL_INTERNET_APPLICATION;
                //appVar.Mirror__C = GEN_OriginationsConstants.APPLICATION_SOURCE_INTERNET; //P-88
            } 
            //BEGIN MLASALA 03-AUG-2016 PRODUCTION ISSUE, MIRROR MISMATCH IN CUSTOMER UI FOR NZ APPLICATIONS
            else if(bVar.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ || 
                    bVar.Name==GEN_OriginationsConstants.BRAND_NAME_KIWI){
                        
                appVar.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_INTERNET_APPLICATION;
            }
            //END MLASALA 03-AUG-2016 PRODUCTION ISSUE, MIRROR MISMATCH IN CUSTOMER UI FOR NZ APPLICATIONS
            
            // Pull product version by brand
            Product_Version__c prodVer = pullprVersion(bVar.Id);
            if(prodVer!=null){
                // Assign parent product of product version
                appVar.Product_Id__c = prodVer.GEProduct__c;
            }
        }
    }
    
    /*  Description: Method to create product item for application.
                     Product item is a junction object of Application and Product Version
                     where product version is based on the brand.
     *  Author: Adrian Recio
     *  Date Created: 3/19/2014
     *  Input Parameters: application
     *  Return: void
     */
    public void createProductItem(Application__c appVar){
        if(appVar.Id!=null && appVar.Brand_Lookup__c!=null){
            Product_Item__c pItem = new Product_Item__c(Application__c = appVar.Id, 
                                                        Product_Version__c = pullprVersion(appVar.Brand_Lookup__c).Id);
            insert pItem;
        }
    }
    
    public PageReference nextPage() {
        // reset veda error variables - ADDED by RCADAPAN for TQLQW-489
        vedaAppError = false;
        vedaAppErrorMessage = '';
        validateFields();
        system.debug('==========> pbiud '+ pbuid);
        if(loanValidationResults){
            Application__c currentApplication = new Application__c();
            
            List<Applicant__c> applicationApplicants = new List<Applicant__c>();
            
            if(applicationId != null){
                currentApplication.Id = applicationId;
            }

            system.debug('brand name: '+brandName);
                                
            //Populating Application fields
            currentApplication.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*
                (loanTermSelected.ToLowerCase().contains('months')?1:12);
            currentApplication.Loan_Term__c = loanTermSelected;

            currentApplication.Payment_Frequency__c = GEN_OriginationsConstants.APPLICATION_PAYMENT_FREQUENCY;
            currentApplication.Total_Loan_Amount__c = totAmount;
            currentApplication.Application_Type__c = applicationType;
            currentApplication.Channel__c = 'Online';
            currentApplication.Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_INTERNET;
            currentApplication.Higher_Approval_Consent__c = confirmHigherApprovalConsent;
            
            String gemid1 = ApexPages.currentPage().getParameters().get('gemid1');
            String gemid2 = ApexPages.currentPage().getParameters().get('gemid2'); 
            
            if(currentApplication.Campaign_Id__c == null && gemid1 != null && gemid1 != ''){
                currentApplication.Campaign_Id__c = gemid1;
            }
            else if(currentApplication.Campaign_Id__c == null && gemid2 != null && gemid2 != ''){
                currentApplication.Campaign_Id__c = gemid2;
            }
            
            //BEGIN MLASALA 20-SEPT-16 TQLQW-487 Promo engine
            if(currentApplication.Campaign_Id__c != null){
                
                try{
                    //Retrieve promo id based url parameter
                    Promo__c urlPromo = [SELECT   Promo_ID__c 
                                         FROM     Promo__c 
                                         WHERE    Campaign__r.Campaign_ID__c =: currentApplication.Campaign_Id__c 
                                         AND      Campaign__r.Campaign_ID__c != null 
                                         ORDER BY Promo_Start__c DESC 
                                         LIMIT 1];
                    
                    if(urlPromo != null){
                        currentApplication.Promo_ID__c = urlPromo.Promo_ID__c;
                    }
                } catch(QueryException err){
                    currentApplication.Promo_ID__c = currentApplication.Campaign_Id__c;
                    System.debug('$$$ No promo found based on campaign id');
                }
            } else {
                currentApplication.Promo_ID__c = promoId;
            }
            //END MLASALA 20-SEPT-16 TQLQW-487 Promo engine
            
            //315
            currentApplication.PBUID__c = pbuid;
            
            if(site.getName() == GEN_OriginationsConstants.BRAND_NAME_GEMONEY){
                 if (ApexPages.currentPage().getParameters().get('suid') != null){
                    String securityToken = ApexPages.currentPage().getParameters().get('suid'); 
                    List<Application__c> app = new List<Application__c>();
                    if(securityToken != ''){
                        app = [Select Id, X3rd_Party_Security_Token_Expiry_Date__c, Is_URL_Accessed__c from Application__c WHERE X3rd_Party_Security_Token__c =: securityToken LIMIT 1];
                    }
                    
                 }
            }
            //TQLQW-481 [PL - AU] PicStarter - MDAVID - 8/30/2016
            if(applicationSource != null && applicationSource == GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER){
                currentApplication.Is_URL_Accessed__c = true;
            }
            
            // set brand and product of application
            try{
                assignProductAndBrand(currentApplication);
            }catch(exception e){
                system.debug('Product and brand assignment error:' + string.valueOf(e.getMessage()));
                system.debug('Product and brand assignment error:' + string.valueOf(e.getLineNumber()));
                system.debug('Product and brand assignment error:' + string.valueOf(e.getStackTraceString()));
            }
            
            // Defect 488 fix:  Afreen - changed the location of this section to be called after assignProductAndBrand
            if(brokerContact.Id!= null &&  isBrokerChannel()){
                currentApplication.Broker__c                        = brokerContact.Id;
                currentApplication.Channel__c                       = GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER;
                currentApplication.Broker_ID__c                     = brokerContact.Broker_ID__c;
                currentApplication.Broker_First_Name_Captured__c    = brokerFName;
                currentApplication.Broker_Last_Name_Captured__c     = brokerLName;
                currentApplication.Broker_Contact_Number__c         = brokerContactNumber;
                //currentApplication.Mirror__c                        = GEN_OriginationsConstants.MIRROR_PLRC_BRANCH;// MAY-06-2016 Afreen - Commented to update the diffrenent mirror code and added below line
                currentApplication.Mirror__c                        = GEN_OriginationsConstants.MIRROR_BROKER_LOAN;
                //currentApplication.Business_Source__c               = GEN_OriginationsConstants.BUSINESS_SOURCE_PERSONAL_LOAN_REF_CENTER; // MAY-06-2016 Afreen - Commented to update the diffrenent business source and added the below line
                currentApplication.Business_Source__c               = GEN_OriginationsConstants.BUSINESS_SOURCE_BROKER_LOAN;
            }
            
            if(isPartner == true){
            url = ApexPages.currentPage().getParameters().get('partnername');
            partnerURL = url.Substring(8,url.length()-3);
            }
            List<Partner__c> partner = [select Name,Country__c from Partner__c where Name = : partnerURL];
            Brand__c bVar = pullBrandBySite(site.getName());
            for(Partner__c p : partner){                                                                                              
               if(isPartner == true){
               if( bVar.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY){ 
                    currentApplication.Channel__c                       = '3rd Party Application';
                    currentApplication.Mirror__c                        = p.Name;
                    currentApplication.Business_Source__c               = 'Internet Application';
                }
               if( bVar.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ || bVar.Name==GEN_OriginationsConstants.BRAND_NAME_KIWI){ 
                    currentApplication.Channel__c                       ='3rd Party Application';
                    currentApplication.Business_Source__c               = 'Internet Application'; 
                    currentApplication.Mirror__c                        = p.Name;
                 }
            }
            }
            /* End -- Added by Arshad */
            
            // Start - Added by Russell Cadapan for TQLQW-489 - Veda Quote
            // if the CUI is triggered from Veda, set defaults to the application record
            if(isAppFromVeda){
                currentApplication.Channel__c = GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE;
                currentApplication.Mirror__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
                currentApplication.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_INTERNET_APPLICATION;
                currentApplication.X3rd_Party_Application_Number__c = vExtId;
                currentApplication.X3rd_Party_Application_Source__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
                currentApplication.Promotional_Campaign__c = GEN_OriginationsConstants.MIRROR_VEDA_QUOTE;
                currentApplication.Trigger_Dedupe__c = true;
            }
            // End
            
            //TQLQW-481 [PL - AU] PicStarter - MDAVID - 9/07/2016
            if(applicationId != null) {
                String appSource = [Select X3rd_Party_Application_Source__c from Application__c WHERE Id =: applicationId].X3rd_Party_Application_Source__c;
                if(appSource == GEN_OriginationsConstants.APPLICATION_SOURCE_PICSTARTER) {
                    currentApplication.Channel__c = GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE;
                    currentApplication.Mirror__c = GEN_OriginationsConstants.MIRROR_PICSTARTER;
                    currentApplication.Business_Source__c = GEN_OriginationsConstants.BUSINESS_SOURCE_INTERNET_APPLICATION;
                    currentApplication.Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_INTERNET;
                }
            }
            
            try{
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Application__c.SObjectType.getDescribe().isCreateable()) {
                    upsert currentApplication;
                //}
            }
            catch(Exception err){
                ErrorHandlerException.recordException(err.getMessage(), 'APP_EligibilityExt', 'Application', 'Class', String.valueOf(currentApplication.Id));
                
                // Generic error handling for Veda Application. ADDED by RCADAPAN for TQLQW-489 Veda Quote Qualification @ 08-SEP-2016
                if(isAppFromVeda){
                    if(err.getMessage().contains('duplicate value found') && err.getMessage().contains('X3rd_Party_Application_Number__c')){
                        vedaAppError = true;
                        vedaAppErrorMessage =  'There is an application in progress with this reference Id: ' + vExtId + '. Please contact us on ' + currentBrand.Contact_Number__c + '.';
                    }
                }
            }
            
            //create Broker Disbursement
            try{
                createBrokerDisbursement(currentApplication);
            }catch(Exception err){
                System.debug(err.getMessage()+err.getCause()+err.getLineNumber()+err.getStackTraceString());
                ErrorHandlerException.recordException(err.getStackTraceString(), 'APP_EligibilityExt', 'Broker Disbursement', 'Class', String.valueOf(currentApplication.Id));
            }

            // create Kiwibank Comments
            try{
                createKiwiBankCallNote(currentApplication);
            }catch(Exception err){
                ErrorHandlerException.recordException(err.getStackTraceString()+':'+err.getMessage(), 'APP_EligibilityExt', 'Broker Disbursement', 'Class', String.valueOf(currentApplication.Id));
            }
            
            
            // create product line item for application
            try{
                createProductItem(currentApplication);
            }catch(Exception e){
                system.debug('Product Item creation error:' + string.valueOf(e));
            }
            system.debug('chekii'+currentApplication.id);
            //Setting up the applicant(s)
            applicationApplicants = [SELECT Id,
                                            First_Name__c,
                                            Is_Primary_Applicant__c,
                                            Interested_in_other_services__c,
                                            Application__c
                                     FROM   Applicant__c
                                     WHERE  Application__c =:
                                            currentApplication.id
                                     ORDER BY Is_Primary_Applicant__c DESC];
                                            
            Applicant__c primaryApplicant = new Applicant__c();
            Applicant__c secondaryApplicant = new Applicant__c();

            List<Applicant__c> applicantsToUpsert = new List<Applicant__c>();
            List<Applicant__c> applicantsToDelete = new List<Applicant__c>();
            
            //If the application has no existing applicant
            if(applicationApplicants.isEmpty()){
                //Automatic create a primary applicant
                primaryApplicant.Application__c = currentApplication.Id;
                primaryApplicant.Is_Primary_Applicant__c = true;
                primaryApplicant.First_Name__c = applicant1FirstName;
                primaryApplicant.Interested_in_other_services__c = confirmInterestedInOtherOffer;
                
                primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;
                primaryApplicant.Agrees_to_Fees__c = confirmApplicationMeetsNeeds; 
                primaryApplicant.Agrees_to_Privacy_Policy__c = confirmAgreedToPolicy;
                
                // Added by Arshad as per BDR - 105
                primaryApplicant.Consent_to_Lpi__c = confirmAgreedToPolicy; 

                primaryApplicant.KB_HL_or_Graduate__c       = confirmKBHLGraduateCustomer;
                
                primaryApplicant.Accept_Terms_and_Conditions__c = false;
                if(siteName!=system.label.NZ_Site_Name){
                    if(confirmEligibleForLoan && confirmApplicationMeetsNeeds && confirmAgreedToPolicy){
                        primaryApplicant.Accept_Terms_and_Conditions__c = true;
                    }
                }else{
                       
                     primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;//confirmAgreedToPolicy;
                     primaryApplicant.Agrees_to_Privacy_Policy__c= confirmEligibleForLoan;
                    if(confirmEligibleForLoan){
                        primaryApplicant.Accept_Terms_and_Conditions__c = true; 
                    }
                }
                
                primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                if(confirmReadCreditGuide == true){
                    primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                }
                
                //315
                primaryApplicant.Kiwi_Bank_Access_Number__c = app1AccessNumber;
                
                // set applicant details collected from Veda - Added by RCADAPAN for TQLQW-489
                if(isAppFromVeda){
                    primaryApplicant.First_Name__c = applicant1FirstName;
                    primaryApplicant.Last_Name__c = vLName;
                    primaryApplicant.Middle_Name__c = vMName;
                    if(vGender.toLowerCase() == 'm'){
                        primaryApplicant.Gender__c = 'Male';
                    }
                    else if(vGender.toLowerCase() == 'f'){
                        primaryApplicant.Gender__c = 'Female';
                    }
                    primaryApplicant.Mobile__c = vMPhone;
                    primaryApplicant.Date_Of_Birth__c  = vDOB.subString(0,2) + '-' + vDOB.subString(2,4) + '-' + vDOB.subString(4,8);
                }
                
                applicantsToUpsert.add(primaryApplicant);

                //If the application type is Joint, create the secondary applicant
                if(currentApplication.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){
                    System.debug('###JOINT: ' + applicationType);
                    secondaryApplicant.Application__c = currentApplication.Id;
                    secondaryApplicant.First_Name__c = applicant2FirstName;
                    secondaryApplicant.Interested_in_other_services__c = confirm2InterestedInOtherOffer;
                    
                    secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;
                    secondaryApplicant.Agrees_to_Fees__c = confirm2ApplicationMeetsNeeds; 
                    secondaryApplicant.Agrees_to_Privacy_Policy__c = confirm2AgreedToPolicy;                    
                    
                    //Added by Arshad
                    //secondaryApplicant.Consent_to_Lpi__c           = confirm2ConsentToLpi;
                    
                    secondaryApplicant.KB_HL_or_Graduate__c         = confirm2KBHLGraduateCustomer;
                    secondaryApplicant.Accept_Terms_and_Conditions__c = false;
                    if(siteName!=system.label.NZ_Site_Name){
                        if(confirm2EligibleForLoan && confirm2ApplicationMeetsNeeds && confirm2AgreedToPolicy){
                            secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                        }
                    }else{
                        secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;//confirm2AgreedToPolicy;
                        secondaryApplicant.Agrees_to_Privacy_Policy__c= confirm2EligibleForLoan;
                        if(confirm2EligibleForLoan){
                            secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                        }
                    }    
                    
                    secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                    if(confirm2ReadCreditGuide == true){
                        secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                    }
                    //315
                    secondaryApplicant.Kiwi_Bank_Access_Number__c = app2AccessNumber;
                    
                    applicantsToUpsert.add(secondaryApplicant);
                }
            }else{
                //If the application has atleast one applicant
                if(applicationApplicants.size() < 2){
                    //If the application is changed to joint, create the secondary applicant
                    if(currentApplication.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT){
                        secondaryApplicant.Application__c = currentApplication.Id;
                        secondaryApplicant.First_Name__c = applicant2FirstName;
                        secondaryApplicant.Interested_in_other_services__c = confirm2InterestedInOtherOffer;
                        
                        secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;
                        secondaryApplicant.Agrees_to_Fees__c = confirm2ApplicationMeetsNeeds; 
                        secondaryApplicant.Agrees_to_Privacy_Policy__c = confirm2AgreedToPolicy;
                        
                        //Added by Arshad
                        //secondaryApplicant.Consent_to_Lpi__c  = confirm2AgreedToPolicy;
                        
                        secondaryApplicant.KB_HL_or_Graduate__c        = confirm2KBHLGraduateCustomer;
                        secondaryApplicant.Accept_Terms_and_Conditions__c = false;
                        if(siteName!=system.label.NZ_Site_Name){
                            if(confirm2EligibleForLoan && confirm2ApplicationMeetsNeeds && confirm2AgreedToPolicy){
                                secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;//confirm2AgreedToPolicy;
                            secondaryApplicant.Agrees_to_Privacy_Policy__c= confirm2EligibleForLoan;
                            if(confirm2EligibleForLoan){
                                secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }
                        
                        secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        if(confirm2ReadCreditGuide == true){
                            secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        }
                        applicantsToUpsert.add(secondaryApplicant);

                        primaryApplicant = applicationApplicants[0];
                        primaryApplicant.First_Name__c = applicant1FirstName;
                        primaryApplicant.Interested_in_other_services__c = confirmInterestedInOtherOffer;
                        
                        primaryApplicant.KB_HL_or_Graduate__c            = confirmKBHLGraduateCustomer;

                        primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;
                        primaryApplicant.Agrees_to_Fees__c = confirmApplicationMeetsNeeds; 
                        primaryApplicant.Agrees_to_Privacy_Policy__c = confirmAgreedToPolicy;
                        
                        //Added by Arshad 
                        //primaryApplicant.Consent_to_Lpi__c = confirmAgreedToPolicy;
                    
                        primaryApplicant.Accept_Terms_and_Conditions__c = false;
                        if(siteName!=system.label.NZ_Site_Name){
                            if(confirmEligibleForLoan && confirmApplicationMeetsNeeds && confirmAgreedToPolicy){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;//onfirmAgreedToPolicy;
                            primaryApplicant.Agrees_to_Privacy_Policy__c= confirmEligibleForLoan;
                            if(confirmEligibleForLoan){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true; 
                            }
                        }
                        
                        primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        if(confirmReadCreditGuide == true){
                            primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        }
                        applicantsToUpsert.add(primaryApplicant);
                    }else{
                        primaryApplicant = applicationApplicants[0];
                        primaryApplicant.First_Name__c = applicant1FirstName;
                        primaryApplicant.Interested_in_other_services__c = confirmInterestedInOtherOffer;

                        primaryApplicant.KB_HL_or_Graduate__c            = confirmKBHLGraduateCustomer;
                        
                        primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;
                        primaryApplicant.Agrees_to_Fees__c = confirmApplicationMeetsNeeds; 
                        primaryApplicant.Agrees_to_Privacy_Policy__c = confirmAgreedToPolicy;
                        //Added by Arshad
                        //primaryApplicant.Consent_to_Lpi__c = confirmAgreedToPolicy;
                    
                        primaryApplicant.Accept_Terms_and_Conditions__c = false;
                        if(siteName!=system.label.NZ_Site_Name){
                            if(confirmEligibleForLoan && confirmApplicationMeetsNeeds && confirmAgreedToPolicy){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;//confirmAgreedToPolicy;
                            primaryApplicant.Agrees_to_Privacy_Policy__c = confirmEligibleForLoan;
                            if(confirmEligibleForLoan){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true; 
                            }
                        }
                        
                        primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        if(confirmReadCreditGuide == true){
                            primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        }
                        applicantsToUpsert.add(primaryApplicant);
                    }
                }else{
                    //If the application changed to single, delete the secondary applicant
                    if(currentApplication.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE){
                        secondaryApplicant = applicationApplicants[1];
                        applicantsToDelete.add(secondaryApplicant);
                    }else{
                        primaryApplicant = applicationApplicants[0];
                        primaryApplicant.First_Name__c = applicant1FirstName;
                        primaryApplicant.Interested_in_other_services__c = confirmInterestedInOtherOffer;
                        primaryApplicant.KB_HL_or_Graduate__c            = confirmKBHLGraduateCustomer;
                        primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;
                        primaryApplicant.Agrees_to_Fees__c = confirmApplicationMeetsNeeds; 
                        primaryApplicant.Agrees_to_Privacy_Policy__c = confirmAgreedToPolicy;
                        
                        //Added by Arshad
                        //primaryApplicant.Consent_to_Lpi__c = confirmAgreedToPolicy;
                        
                        primaryApplicant.Accept_Terms_and_Conditions__c = false;
                        if(siteName!=system.label.NZ_Site_Name){
                            if(confirmEligibleForLoan && confirmApplicationMeetsNeeds && confirmAgreedToPolicy){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            primaryApplicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;//confirmAgreedToPolicy;
                            primaryApplicant.Agrees_to_Privacy_Policy__c= confirmEligibleForLoan;
                            if(confirmEligibleForLoan){
                                primaryApplicant.Accept_Terms_and_Conditions__c = true; 
                            }
                        }
                        primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        if(confirmReadCreditGuide == true){
                            primaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        }
                        
                        secondaryApplicant = applicationApplicants[1];
                        secondaryApplicant.First_Name__c = applicant2FirstName;
                        secondaryApplicant.Interested_in_other_services__c = confirm2InterestedInOtherOffer;
                        
                        secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;
                        secondaryApplicant.Agrees_to_Fees__c = confirm2ApplicationMeetsNeeds; 
                        secondaryApplicant.Agrees_to_Privacy_Policy__c = confirm2AgreedToPolicy;
                        
                        //Added by Arshad
                        //secondaryApplicant.Consent_to_Lpi__c = confirm2AgreedToPolicy;
                        
                        secondaryApplicant.KB_HL_or_Graduate__c         = confirm2KBHLGraduateCustomer;
                        secondaryApplicant.Accept_Terms_and_Conditions__c = false;
                        if(siteName!=system.label.NZ_Site_Name){
                            if(confirm2EligibleForLoan && confirm2ApplicationMeetsNeeds && confirm2AgreedToPolicy){
                                secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            secondaryApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;//confirm2AgreedToPolicy;
                            secondaryApplicant.Agrees_to_Privacy_Policy__c = confirm2EligibleForLoan;
                            if(confirm2EligibleForLoan){
                                secondaryApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }
                        secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        if(confirm2ReadCreditGuide == true){
                            secondaryApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        }
                        
                        applicantsToUpsert.add(primaryApplicant);
                        applicantsToUpsert.add(secondaryApplicant);
                    }
                }
            }
            if(!applicantsToUpsert.isEmpty()){
                try{
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Applicant__c.SObjectType.getDescribe().isCreateable()) {
                        upsert applicantsToUpsert;
                    //}
                }
                catch(Exception err){
                    ErrorHandlerException.recordException(err.getMessage(), 'APP_EligibilityExt', 'Applicant__c', 'Class', String.valueOf(currentApplication.Id));
                }
            }
            if(!applicantsToDelete.isEmpty()){
                try{
                  /*CHECKMARX
                  // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                  if(Applicant__c.SObjectType.getDescribe().isDeletable()){
                    delete applicantsToDelete;
                  }
                  */
                  delete applicantsToDelete;
                }
                catch(Exception err){
                    ErrorHandlerException.recordException(err.getMessage(), 'APP_EligibilityExt', 'Applicant__c', 'Class', String.valueOf(currentApplication.Id));
                }
            }
            
            List<Loan_Purpose__c> loanList = new List<Loan_Purpose__c>();
            Id onrId = parentONRId(currentApplication.Id);
            
            for(loanWrapper lp: loanWrapList){
                if(lp.loan.Application__c == null){
                    lp.setLoanApplicationAndONR(currentApplication.Id, onrId);
                }
                loanList.add(lp.loan);
            }
            
            if(!loanList.isEmpty()){
                try{
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Loan_Purpose__c.SObjectType.getDescribe().isCreateable()) {
                        upsert loanList;
                    //}
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_Eligibility', 'Loan_Purpose__c', 'Class', String.valueOf(currentApplication.Id));
                }
            }
            
            UserUtility userUtility;
            
            // ADDED by RCADAPAN for TQLQW-489 Veda Quote. Address URL parameter should be sent from Veda to CUI Eligibility, and from CUI Eligibility to Personal details page
            if(isAppFromVeda){
                 userUtility = new UserUtility(vEmail);
            }
            else{
                userUtility = new UserUtility();
            }
            
            PageReference pageRef = userUtility.createCommunityUser(currentApplication, applicantsToUpsert[0]);
            system.debug('Has Pagreference:' + pageRef);

            return pageRef;
        }

        system.debug('Null Pagreference');
        return null;
    }

     /*  Description: Create Kiwi Bank Call note
     *  Author: Afreen Khan
     *  Date Created: Mar-08-2016
     */
    public void createKiwiBankCallNote(Application__c currentApp){

        if(currentApp.Id != null && isKiwiBankPostShop() && String.isNotBlank(kiwiComments)) {
          QuickAction.QuickActionRequest req  = new QuickAction.QuickActionRequest();
          req.quickActionName                 = Schema.Application__c.QuickAction.Call_Note;
          req.record                          = getCallNoteTask();
          req.contextId                       = currentApp.Id;
          QuickAction.QuickActionResult res   = QuickAction.performQuickAction(req);
        }
    }

    /*  Description: Task details for call note
     *  Author: Afreen Khan
     *  Date Created: Mar-08-2016
     */
    public Task getCallNoteTask(){
        callLog.Subject     = 'Kiwibank Branch Note';
        callLog.Description = kiwiComments;
        callLog.OwnerId     = systemUser.Id;
        return callLog;
    }
    
    /*  Description: Create Broker Disbursment
     *  Author: Afreen Khan
     *  Date Created: Feb-25-2016
     */
    public void createBrokerDisbursement(Application__c currentApp){
        System.debug(currentApp.Id);
        System.debug(currentApp.Channel__c);
        System.debug(ApexPages.currentPage().getParameters().get('form'));
       
        if(currentApp.Id != null && currentApp.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER &&  isBrokerChannel() ){
            Id disbursementId                   = getBrokerDisbursementId(currentApp); // May-09-2016 Afreen- Updated to get the already existing broker disbursement id.
            
            Disbursement__c brokerDisbursement  = new Disbursement__c();
            brokerDisbursement.Amount__c        = brokerFee;
            brokerDisbursement.Payee__c         = brokerContact.Name;
            //Passing Default values for BSB and Account number - Added by Suneel -  Broker FEE EFT 08/02/2018
            brokerDisbursement.BSB__c = '000000';
            brokerDisbursement.Bank_Acc_No__c = '000000';
            //End 
          // Commented the below line by Suneel to make Broker Fee EFT as default Record Type
          //brokerDisbursement.RecordTypeId     = Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Broker Fee').getRecordTypeId();
          //Added by Suneel -  new record type Broker Fee EFT as part of Cheque removal disbursement project on 12/11/2017
            brokerDisbursement.RecordTypeId     = Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Broker Fee EFT').getRecordTypeId();
            brokerDisbursement.Application__c   = currentApp.Id;
            
            if(disbursementId != null){
                  brokerDisbursement.id = disbursementId;
            }
           
            upsert brokerDisbursement;
       }
    }
    
    /*  Description: Identify if there is already a broker disbursement or not
     *  Author: Afreen Khan
     *  Date Created: May-09-2016
     *  Input Parameters: None
     * 
     */
    
    private Id getBrokerDisbursementId(Application__c currentApp){
        List<Disbursement__c> disbursementList =  [Select id From Disbursement__c Where RecordTypeId = :Schema.Sobjecttype.Disbursement__c.getRecordTypeInfosByName().get('Broker Fee EFT').getRecordTypeId() and Application__c = :currentApp.Id];
        if(disbursementList.size()>0){
            return disbursementList[0].id;
        }
        return null;
    }
    
    
    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> getloanTermOptions() { 
        Brand__c brand = [SELECT Loan_Term__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
        
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', 'Please Select'));
        list <string> values = new list <string>();
        values = (brand.Loan_Term__c.split(';'));
        values.sort();
        for(String s : values){
            if(s.toLowerCase().contains('months'))
                options.add(new SelectOption(s, s));    
        }
          
        for (String s: values) {
            if (!s.toLowerCase().contains('months')) {
                options.add(new SelectOption(s, s));
            }
        }
        
        return options;
    }
    
    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> getloanFrequencyOptions() { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        Schema.DescribeFieldResult fieldResult = Application__c.Payment_Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
    /*  Description: Method called in validating Multiple Loan Purpose
     *  Author: Fel Saliba
     *  Date Created: SEPT-26-2013
     *  Input Parameters: None
     *  Return: N/A
     */
    public boolean validateFields(){
        List<Loan_Purpose__c> loanList = new List<Loan_Purpose__c>();
        totAmount = 0; 
        loanTermNotValid = false;
        paymentNotValid = false;
        loanAmountNotValid = false;
        loanValidationResults = true;
      //  pbuidNotValid = false;
        errorFName1 = false;
        errorFName2 = false;     
        errorFName1Msg = '';
        errorFName2Msg = '';
        isNotValidBroker = false;
        System.debug('1 result'+ loanValidationResults);
        System.debug('2 result'+ ApexPages.currentPage().getParameters().get('form'));
        
        if(isBrokerChannel() && !searchBroker()){
            isNotValidBroker = true;
            loanValidationResults = false;
            System.debug('$$$ 1');
        }

        calculateLoanAmountTotal();
        if(loanTermSelected == null || loanTermSelected == ''){
            loanTermNotValid = true;
            loanValidationResults = false;
            System.debug('$$$ 2');
        }

        //Start - UPDATED RCADAPAN 08-MAR-2016 for TQLQW-29 - Reduce Total Loan Amount to 2 Grand for NZ Applications
        validLPAmount = GEN_OriginationsConstants.AU_VALID_LOAN_TOTAL_AMOUNT;
        if(currentBrand.Country__c == GEN_OriginationsConstants.NZ_REGION){
            validLPAmount = GEN_OriginationsConstants.NZ_VALID_LOAN_TOTAL_AMOUNT;
        }

        if(totAmount < validLPAmount){
            loanAmountNotValid = true;
            loanValidationResults = false;
            System.debug('$$$ 3');
        }
        //End TQLQW-29
        //  315
        //  if(ApexPages.currentPage().getParameters().containsKey('form') && pbuid == NULL){
        //     pbuidNotValid = true;
        //    loanValidationResults = false;
      //  }
                
        for(loanWrapper lp: loanWrapList){
            lp.loanPurposeNotValid = false;
            lp.amtNotValid = false;
            if(lp.Loan.Value__c == 'Please Select'){
                lp.loanPurposeNotValid = true;
                loanValidationResults = false;
                System.debug('$$$ 4');
            }
            if(lp.loan.Loan_Amount__c == null || lp.loan.Loan_Amount__c == 0){
                lp.amtNotValid = true;
                loanValidationResults = false;
                System.debug('$$$ 5');
            }
            if(lp.loan.Value__c == 'Other' && (lp.loan.Other_Loan_Purpose__c == null || lp.loan.Other_Loan_Purpose__c == '')){
                lp.loanPurNotValid = true;
                loanValidationResults = false;
                System.debug('$$$ 6');
            }
        }
        //Removed validation from PRS 
        /*if(applicant1FirstName == 'ERR1'){
            errorFName1 = true;
            errorFName1Msg = 'Primary applicant' + '\'' +'s first name contains invalid characters.';
            loanValidationResults = false;
        }
        if(applicant2FirstName == 'ERR1'){
            errorFName2 = true;
            errorFName2Msg = 'Secondary applicant' + '\'' +'s first name contains invalid characters.';
            loanValidationResults = false;
        }*/
        
        //BEGIN MLASALA 22-SEPT-16 TQLQW-487 Promo Engine
        //Validate if promo code is valid
        if(promoId != ''){
            isPromo = true;
            try{
                //Retrieve promo id based url parameter
                Promo__c urlPromo = [SELECT   Id 
                                     FROM     Promo__c 
                                     WHERE    Promo_ID__c =: promoId 
                                     ORDER BY Promo_Start__c DESC 
                                     LIMIT 1];
            } catch(QueryException err){
                loanValidationResults = false;
                isValidPromo = true;
                System.debug('$$$ 7');
            }
        }
        //END MLASALA 22-SEPT-16 TQLQW-487 Promo Engine
        System.debug('$$$ loanValidationResults: '+loanValidationResults);
        return loanValidationResults;
    }
    /*  Description: Retrieve/Create parentONR Id
     *  Author: Mike Lasala
     *  Date Created: JAN-24-2014
     *  Input Parameters: None
     *  Return: Id
     */
    public Id parentONRId(Id appId){
        ONR__c parentONR;
        
        List<ONR__c> onrList = [SELECT  Id 
                                FROM    ONR__c 
                                WHERE   Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                AND     recordType.Name =: GEN_OriginationsConstants.ONR_GENERAL
                                AND     Application__c =: appId
                                LIMIT   1];
                             
        if(onrList.size()<1){
            //create new onr based on meta onr if there is no existing ONR yet
            List<Meta_ONR__c> metaONR = [SELECT GeId__c
                                         FROM   Meta_onr__c 
                                         WHERE  Type__c =: GEN_OriginationsConstants.ONR_TYPE_TABLE
                                         AND    Onr_type__c =: GEN_OriginationsConstants.ONR_GENERAL];
            
            Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c; 
            Map<String,Schema.RecordTypeInfo> onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
            Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();
            
            if(!metaONR.isEmpty()){
                parentONR = new ONR__c(Type__c = GEN_OriginationsConstants.ONR_TYPE_TABLE, 
                                       RecordTypeId = onrGeneral,
                                       GeId__c = metaONR[0].geId__c,
                                       Application__c = appId);
                insert parentONR;
            }
        } else {
            parentONR = onrList.get(0);
        }
        
        return parentONR.Id;
    }
    
    /*  Description: Method that performs redirect to customer ui post submit page
                     if application steps is not yet complete
     *  Author: Adrian Recio
     *  Date Created: 4-APR-2014
     *  Parameter 
     *  Return: pagereference
     */
    public pageReference validatePostSubmit(){
        System.debug('$$$ site.getName(): '+site.getName());
        if(applicationId != null){
            List<Application__c> appStatVar = [Select Id, Status__c from Application__c where Id=:applicationId];
        
            if(appStatVar.size()>0){
                if(appStatVar[0].Status__c!='New'){
                    pageReference pgRef = Page.APP_Main_PostSubmit;
                    pgRef.getParameters().put('Id',applicationId);
                    pgRef.setRedirect(true);
                    return pgRef;
                }
            }
        }
        
        //BEGIN MLASALA 15-NOV-16 Logout broker if user is still authenticated
        else {
            if(isBrokerChannel()){
                System.debug('$$$ getUserType: '+UserInfo.getUserType());
                if(UserInfo.getUserType().equalsIgnoreCase('CspLitePortal')){
                    System.debug('$$$ authenticated');
                    pageReference pageRef = Page.APP_Logout;
                    pageRef.getParameters().put('broker', 'true');
                    pageRef.setRedirect(true);
                    return pageRef;
                } else {
                    System.debug('$$$ not authenticated');
                }
            }
        }
        //END MLASALA 15-NOV-16 Logout broker if user is still authenticated
        
        return null;
    }
    
    /*  Description: Serach Broker record using broker Id
     *  Author: Afreen Khan
     *  Date Created: 24-Feb-2016
     */

    public Boolean searchBroker(){
        System.debug('brokerId' + brokerId+ 'Broker Record Type'+ brokerRecordTypeId+ brokerId);
        List<Contact> brokerList = [Select Id, Name, Broker_ID__c From Contact Where Broker_ID__c = :brokerId 
                                    and Contact_Accreditation_Status__c = : GEN_OriginationsConstants.ELIGIBITIY_BROKER_STATUS_ACTIVE 
                                    and (Broker_Product__c Like '%PL%' OR Broker_Product__c Like '%Motor Solutions%'  ) //Changed by TXU, to include motor in Broker Product
                                    and recordTypeId = :brokerRecordTypeId Limit 1];  
        if(brokerList.size() >0 && brokerList[0].Id != null ){
            brokerContact = brokerList[0] ;
            return true;
        }else{
            return false;
        }
    }
    
    // Added by RUSSELL CADAPAN to fetch URL parameter values sent by Veda and map it to necessary Salesforce fields
    public void getVedaParameters(){
        vFName = ApexPages.currentPage().getParameters().get('firstname');
        vLName = ApexPages.currentPage().getParameters().get('lastname');
        vMName = ApexPages.currentPage().getParameters().get('middlename');
        vGender = ApexPages.currentPage().getParameters().get('gender');
        vEmail = ApexPages.currentPage().getParameters().get('email');
        vMPhone = ApexPages.currentPage().getParameters().get('mobile');
        vLPhone = ApexPages.currentPage().getParameters().get('vLPhone');
        vDOB = ApexPages.currentPage().getParameters().get('dob');
        vAddress = ApexPages.currentPage().getParameters().get('address');
        vExtId = ApexPages.currentPage().getParameters().get('uniqueid');
        vSourceId = ApexPages.currentPage().getParameters().get('sourceid');
        vLAmount = ApexPages.currentPage().getParameters().get('amount'); 
    }


}