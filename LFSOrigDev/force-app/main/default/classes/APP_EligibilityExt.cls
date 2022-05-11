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
public without sharing class APP_EligibilityExt{

    //public Decimal loanTermBetterStartOptions  {get;set;}
   // public String lpValues {get;set;}
   // public String lpOutput {get;set;}
   /* public void loanPurposeValues(){
        for(loanWrapper lp: loanWrapList){
        lpValues = null;
            if(lp.loan.Value__c != null){
                lpValues = lp.loan.Value__c;
                lpOutput += lpValues;

            }
            
        }
      
    }*/
    //Start Suneel
    public String selectedDay {get;set;}
    public String selectedMonth {get;set;}
    public String selectedYear {get;set;}
    public Boolean failedAttempt {get;set;}
    public List<Quote_Validation_Tracker__c> qv {get;set;}
    public Quote_Validation_Tracker__c a ;
    public Quote_Validation_Tracker__c getQVT;
    public Quote_Validation_Tracker__c updateQVT;
    public Boolean qvtCheck;
    

    
    public Boolean errorDOBValidation {get;set;}
    public string errorDOBValidationMsg {get;set;}
    
    
    
    //public string birthdate;
    public string birthmonth1;
    public string birthyear;
    
    Public String birthMonth {
        get;
        set;
    }
    public String birthdate;
    //End Suneel
    //Loan Purpose variables
    public String url;
    public String partnerURL;
    public Boolean isPartner {get;set;}
    // Added by Arshad- Better Start
    public Boolean isBetterStart {get;set;}
    public Boolean isBSOfferActive {get;set;}
    public Better_Start_Offer__c bsoffer {get;set;}
    // End - Better Start Arshad
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
    
    //Added for POI Automation by Suneel
    public Boolean confirmAgreedToIncomeVerification{get;set;}  
    
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
    
    //Added for POI Automation by Suneel
    public Boolean confirm2AgreedToIncomeVerification {get;set;}

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
    
    //Added by Suneel for POI Automation on 15/06/2020
    public String isBrokerVerified                   {get;set;}
    public String isCustomerVerified                 {get;set;}
    
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
    
    
    public String productSelected {get;set;}
    //Added for Softquote Changes
    public Static Quote__c quote  {get;set;}
    public String quoteId;  
    public String qId;  
    public Boolean isAppFromQuote;  
    public Quote__c quoteToApp;
    public String sqDOB;
    public APP_EligibilityExt() {
      qvtCheck = true;
      errorDOBValidation = false;
      errorDOBValidationMsg = '';
        try{ 
             //TQLQW-481 [PL - AU] PicStarter - MDAVID - 8/30/2016 
             securityTokenValid = true;
         isPromo = false;                    
             //omnitureURL = Admin_Settings__c.getValues('Omniture Source').Value__c;   //AFREEN 23-SEPT-16 TQLQW-519 Web Analytics - Ensighten
             if(site.getName() == GEN_OriginationsConstants.BRAND_NAME_GEMONEY){

                 System.debug('Inside Latitude check');
                 System.debug('Get SUID From URL: '+ApexPages.currentPage().getParameters().get('suid'));

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
            System.debug('Get SOURCEID From URL: '+vSourceId);
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
             try{
            poiVerificationConsent();}catch(Exception e){}
            retrieveQuestions();    //Get eligibility questions by site
            applicationId = ApexPages.currentPage().getParameters().get('id');
            System.debug('Get ID From URL: '+applicationId);
            quoteId = ApexPages.currentPage().getParameters().get('qId');
            System.debug('APP Eligibility QId: '+quoteId);
            //quoteId = BrokerSubmittedEntities.decryptQuoteId(quoteId);
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
            isAppFromQuote =false;
            //check for existing application
            if(quoteID==null && applicationId==null){
                System.debug('Inside App Id Null Check');
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
            }else if(quoteID <> null){
                quoteID = EncryptionManager.decryptQuoteId(quoteID);
                System.debug('DECRYPTED QID: '+quoteID);
                existingApplication = false;
                disableApplicationType = false;
                isAppFromQuote =true;
                Quote__c currentQuote = [SELECT Id, Name, Quote_Privacy_Consent__c, Loan_Amount__c, Loan_Purpose__c,Channel__c, Sub_Type__c,
                                         Loan_Term__c,First_name__c,Last_Name__c,Middle_Name__c,Mobile_Number__c,Date_of_Birth__c,Other_Loan_Purpose__c,
                                         Months_at_Residential_Address__c,Years_at_Residential_Address__c,Gender__c,Drivers_Lic_Flag__c,
                                         Driver_s_Licence_Number__c,Driver_s_License_Issue_Date__c,Driver_s_License_Expiry_Date__c,
                                         Driver_s_License_Version__c,Title__c,Residential_Unit_Number__c,Residential_Suburb__c,Region__c,
                                         Residential_Street_Type__c,Residential_Street_Number__c,Residential_Street_Name__c,Residential_Status__c,
                                         Email_ID__c,Residential_State__c,Residential_Postcode__c,Residential_Country__c,Residential_City__c,Property_Name__c,
                                         Previous_City__c,Previous_Country__c,Previous_Postcode__c,Previous_State__c,Previous_Street_Name__c,Previous_Property_Name__c,
                                         Previous_Street_Type__c,Previous_Street_Number__c,Previous_Suburb__c,Previous_Unit_Number__c,
                                         Brokerage_Fee__c,Broker_ID__c,UID__c
                                         FROM 
                                         Quote__c 
                                         WHERE Id= :quoteId];
                //Better start change
                 if(currentQuote.Sub_Type__c == null || currentQuote.Sub_Type__c != 'Better Start') {
                     productSelected = 'Standard PL';
                 } else {
                     productSelected = 'Better Start PL';
                 }
                 loanTermSelected = currentQuote.Loan_Term__c;
                 loanWrapList = new List<loanWrapper>(); 
                 loanWrapper lw = new loanWrapper();
                 lw.loan.Value__c  = currentQuote.Loan_Purpose__c;
                 lw.loan.Loan_Amount__c =currentQuote.Loan_Amount__c;
                 lw.loan.Other_Loan_Purpose__c =currentQuote.Other_Loan_Purpose__c;
                 loanWrapList.add(lw);
                 totAmount = currentQuote.Loan_Amount__c;
                 applicant1FirstName = currentQuote.First_name__c;                  
                 brokerFee = currentQuote.Brokerage_Fee__c;
                 brokerId = currentQuote.Broker_ID__c;
                 sqDOB = currentQuote.Date_of_Birth__c;
                 sqDOB=sqDOB.replaceAll('/', '');
                 
                 quoteToApp = currentQuote;
                 loanPurposeSize = 1;
                  

            
            }else{
                existingApplication = true;
                
                //Below line commented by Suneel for adding new field produt_subtype__c in the below query
                /*Application__c currentApplication = [SELECT Id, Campaign_Id__c, Broker_ID__c, Broker_First_Name_Captured__c, Broker_Last_Name_Captured__c, Brokerage_Fee__c, Broker_Contact_Number__c, Application_Type__c, Loan_Term_Months__c, Payment_Frequency__c, Higher_Approval_Consent__c, Loan_Term__c,Promo_ID__c
                                                     FROM   Application__c
                                                     WHERE  Id =: applicationId]; */       
                Application__c currentApplication = [SELECT Id, Product_SubType__c,Campaign_Id__c, Broker_ID__c, Broker_First_Name_Captured__c, Broker_Last_Name_Captured__c, Brokerage_Fee__c, Broker_Contact_Number__c, Application_Type__c, Loan_Term_Months__c, Payment_Frequency__c, Higher_Approval_Consent__c, Loan_Term__c,Promo_ID__c
                                                     FROM   Application__c
                                                     WHERE  Id =: applicationId];             

                applicationType = currentApplication.Application_Type__c;
                // Added by Arshad for Better start
                productSelected = currentApplication.Product_SubType__c;
                
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
                                           //Added for POI Automation by Suneel
                                          Agrees_to_Income_Verification__c,
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
                     // Added for POI Automation by Suneel on 21st Jan 2021
                    confirmAgreedToIncomeVerification = applicantList[0].Agrees_to_Income_Verification__c;
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
                        
                        //Added for POI Automation by Suneel on 21st Jan 2021
                        confirm2AgreedToIncomeVerification = applicantList[1].Agrees_to_Income_Verification__c;
                                                
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
        
        // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
        isBSOfferActive = false;
        Better_Start_Offer__c bsoffer = [select BetterStartAUActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        
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
        
        //Start Suneel
        
        //End Suneel  
    }

    /*  Description: Populate Sys User Id
     *  Author: Afreen Khan
     *  Date Created: March-10-2016
     *  Return: void
     */
    private void populateSystemUser(){
       systemUser = [Select Id From User where Username Like 'gewsprod@ge.com%' Limit 1];
    }
     
     /* Description : Get values of Custom settings to 
     *
     */
     public void poiVerificationConsent(){
        isBrokerVerified = Admin_Settings__c.getValues('Broker Verification').Value__c;
        isCustomerVerified = Admin_Settings__c.getValues('Customer Verification').Value__c;     
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
        getProductOptions();
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
            eligiblityQuestions = [SELECT Brand__r.Name, Output_HTML__c, Brand__r.Site__c FROM Brand_Content__c WHERE Brand__r.Site__c =: site.getName() AND Description__c = 'Eligibility Broker Questions' ORDER BY Name ASC];
        }else{
            eligiblityQuestions = [SELECT Brand__r.Name, Output_HTML__c, Brand__r.Site__c FROM Brand_Content__c WHERE Brand__r.Site__c =: site.getName() AND Description__c = 'Eligibility Questions' ORDER BY Name ASC];
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
            if(ApexPages.currentPage().getParameters().get('subType')=='betterStart'){
            currentApplication.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
            currentApplication.Loan_Term__c = loanTermSelected;
            //Decimal month = Decimal.valueOf(loanTermSelected.substring(9,loanTermSelected.length()-8));
            //currentApplication.Loan_Term_Months__c += month;
            }else 
            if(currentApplication.Product_SubType__c == 'Better Start PL'){
            currentApplication.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
            currentApplication.Loan_Term__c = loanTermSelected;
            //Decimal month = Decimal.valueOf(loanTermSelected.substring(9,loanTermSelected.length()-8));
            //currentApplication.Loan_Term_Months__c += month;
            //currentApplication.Product_SubType__c = productSelected; 
            }else{
            currentApplication.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*
                (loanTermSelected.ToLowerCase().contains('months')?1:12);
            currentApplication.Loan_Term__c = loanTermSelected;   
            //currentApplication.Product_SubType__c = productSelected; 
         
            }
            //Added by Arshad for Better Start
            isBetterStart = false;
           // currentApplication.Product_SubType__c = productSelected;
            productSelected = currentApplication.Product_SubType__c; 
            System.debug('Product Selected +++++'+productSelected);        
            if(ApexPages.currentPage().getParameters().get('subType')=='betterStart' || productSelected == 'Better Start PL'){
            isBetterStart = true;
            currentApplication.Product_SubType__c = 'Better Start PL';
            }else
            if(ApexPages.currentPage().getParameters().get('form')=='broker' || productSelected == 'Standard PL'){
            isBetterStart = true;
            currentApplication.Product_SubType__c = 'Standard PL';
            }
           if(ApexPages.currentPage().getParameters().get('form') == 'broker' && totAmount >= 20000 && (loanTermSelected.ToLowerCase().contains('months'))){
            isBetterStart = true;
            currentApplication.Product_SubType__c = 'Better Start PL';
            currentApplication.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
            System.debug('Product Selected One+++++' + productSelected);
            }    
             
           /* if(ApexPages.currentPage().getParameters().get('form') == 'broker' && totAmount >= 20000){
            isBetterStart = true;
            currentApplication.Product_SubType__c = 'Better Start PL';
            }*/
            /* Commented by Arshad for turning on/off Better Start Features and added code just below after this.
            if(isBetterStart == false){
            currentApplication.Product_SubType__c = 'Standard PL';
            } */
            if(isBetterStart == false){
                if(currentApplication.Brand_Country__c == 'AU' && bsOffer.BetterStartAUActive__c == true){
                    currentApplication.Product_SubType__c = 'Standard PL';
                }else if (currentApplication.Brand_Country__c == 'NZ' && bsOffer.BetterStartNZActive__c == true){
                    currentApplication.Product_SubType__c = 'Standard PL';
                }
           }
           
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
            //Soft quote 2020 Changes to Enable the Submit Flag for Soft quotes
            String quoteId = ApexPages.currentPage().getParameters().get('qId');
            if(quoteId != null){
              //Prepopulate the UID (Loan number) from quote to App
              if((quoteToApp.UID__c <> null && quoteToApp.UID__c <> '') ){
                   currentApplication.UID__c= quoteToApp.UID__c;
              }
              if((quoteToApp.Region__c <> null && quoteToApp.Region__c == 'AU') ){
                    currentApplication.AU_Submit_Flag__c = true;
                    
              }else if((quoteToApp.Region__c <> null && quoteToApp.Region__c == 'NZ')){
                    currentApplication.NZ_Submit_Flag__c = true;
              }
              if((quoteToApp.Region__c <> null && quoteToApp.Region__c == 'AU' && quoteToApp.Channel__c=='Broker')){
                 searchBroker(); 
              
                currentApplication.Broker__c                        = brokerContact.Id;
                currentApplication.Channel__c                       = GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER;
                currentApplication.Broker_ID__c                     = quoteToApp.Broker_ID__c;
                currentApplication.Broker_First_Name_Captured__c    = brokerFName;
                currentApplication.Broker_Last_Name_Captured__c     = brokerLName;
                currentApplication.Broker_Contact_Number__c         = brokerContactNumber;
                currentApplication.Mirror__c                        = GEN_OriginationsConstants.MIRROR_BROKER_LOAN;
                currentApplication.Business_Source__c               = GEN_OriginationsConstants.BUSINESS_SOURCE_BROKER_LOAN;
                  
              }
              
            }
            
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
                    System.debug('currentApplication 2020: '+currentApplication.Id);
                    System.debug('Quote Number From URL: '+ApexPages.currentPage().getParameters().get('qno'));
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
            
            //Soft Quote Changes: Link Application to Quote if the URL has a quote number
            
            System.debug('NEW CHECKPOINT: '+quoteId);
            if(quoteId != null){
                try{
               
                    linkApplicationToQuote(currentApplication.Id, quoteId);
                    System.debug('NEW CHECKPOINT 2: '+currentApplication.Id);
                }
                catch(Exception err){
                    System.debug(err.getMessage()+err.getCause()+err.getLineNumber()+err.getStackTraceString());
                    ErrorHandlerException.recordException(err.getStackTraceString(), 'APP_EligibilityExt', 'Link Application to Quote', 'Class', String.valueOf(currentApplication.Id));
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
                                            Application__c,
                                            Gender__c,
                                            Mobile__c,
                                            Date_Of_Birth__c                                            
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
                
                // Added for POI Automation by Suneel on 21st Jan 2021
                primaryApplicant.Agrees_to_Income_Verification__c = confirmAgreedToIncomeVerification;
                
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
                //Added as part of Soft Quote Changes
                if(isAppFromQuote){
                    primaryApplicant.Last_Name__c = quoteToApp.Last_Name__c;
                    primaryApplicant.Middle_Name__c = quoteToApp.Middle_Name__c;
                    primaryApplicant.Gender__c = quoteToApp.Gender__c;
                    primaryApplicant.Mobile__c = quoteToApp.Mobile_Number__c;
                    primaryApplicant.Date_Of_Birth__c  = sqDOB.subString(0,2) + '-' + sqDOB.subString(2,4) + '-' + sqDOB.subString(4,8);
                    primaryApplicant.Res_Status__c = quoteToApp.Residential_Status__c;
                    primaryApplicant.Years_At_Addr__c= util.integerToString(quoteToApp.Years_at_Residential_Address__c.intValue());
                    primaryApplicant.Months_At_Addr__c = util.integerToString(quoteToApp.Months_at_Residential_Address__c.intValue());
                    primaryApplicant.Drivers_Lic_Flg__c = quoteToApp.Drivers_Lic_Flag__c;
                    primaryApplicant.Drivers_Lic_No__c = quoteToApp.Driver_s_Licence_Number__c;
                   
                   if (quoteToApp.Region__c <> null && quoteToApp.Region__c == 'NZ'){
                        primaryApplicant.Customer_ID_Type__c = GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE;
                        primaryApplicant.ID_Number__c = quoteToApp.Driver_s_Licence_Number__c;
                        primaryApplicant.Issuing_Country__c = quoteToApp.Residential_Country__c;
                       if(quoteToApp.Previous_Property_Name__c <> null){
                           primaryApplicant.Previous_Property_Name__c = quoteToApp.Previous_Property_Name__c;
                       } 
                       if(quoteToApp.Property_Name__c <> null){
                          primaryApplicant.Residential_Property_Name__c = quoteToApp.Property_Name__c;    
                       } 
                   }
                    if(quoteToApp.Driver_s_License_Issue_Date__c <> null ){
                      primaryApplicant.Issue_Date__c = date.parse(quoteToApp.Driver_s_License_Issue_Date__c);
                    }
                    if(quoteToApp.Driver_s_License_Expiry_Date__c<> null ){                     
                      primaryApplicant.Expiry_Date__c = date.parse(quoteToApp.Driver_s_License_Expiry_Date__c);
                    }
                    if(quoteToApp.Driver_s_License_Version__c <> null ){                     
                       primaryApplicant.Version__c = quoteToApp.Driver_s_License_Version__c;
                    }

                    primaryApplicant.Email_Address__c = quoteToApp.Email_ID__c;
                    primaryApplicant.Title__c = quoteToApp.Title__c;
                    primaryApplicant.City_Res__c = quoteToApp.Residential_City__c;
                    primaryApplicant.Country_Res__c = quoteToApp.Residential_Country__c;
                    primaryApplicant.Postcode_Res__c = quoteToApp.Residential_Postcode__c;
                    primaryApplicant.State_Res__c = quoteToApp.Residential_State__c;
                    primaryApplicant.Street_Res__c = quoteToApp.Residential_Street_Name__c;
                    primaryApplicant.Street_No_Res__c = quoteToApp.Residential_Street_Number__c;
                    if(quoteToApp.Residential_Street_Type__c <> null && quoteToApp.Region__c <> null){
                       primaryApplicant.Street_Type_Res__c = SoftQuoteUtil.checkStreetType(quoteToApp.Residential_Street_Type__c,quoteToApp.Region__c); 
                    }
                    
                    primaryApplicant.Suburb_Res__c = quoteToApp.Residential_Suburb__c;
                    primaryApplicant.Unit_No_Res__c = quoteToApp.Residential_Unit_Number__c;  
                    // Previous Address details
                    primaryApplicant.City_Pre__c = quoteToApp.Previous_City__c;
                    primaryApplicant.Country_Pre__c = quoteToApp.Previous_Country__c;
                    primaryApplicant.Postcode_Pre__c = quoteToApp.Previous_Postcode__c;
                    primaryApplicant.State_Pre__c= quoteToApp.Previous_State__c;
                    primaryApplicant.Street_Pre__c= quoteToApp.Previous_Street_Name__c;
                    primaryApplicant.Street_No_Pre__c = quoteToApp.Previous_Street_Number__c;
                    if(quoteToApp.Previous_Street_Type__c <> null && quoteToApp.Region__c <> null){
                        system.debug('Street type check '+quoteToApp.Previous_Street_Type__c);
                        system.debug('Quote region check'+quoteToApp.Region__c);
                    system.debug('Quote region check'+SoftQuoteUtil.checkStreetType(quoteToApp.Previous_Street_Type__c,quoteToApp.Region__c));
                        primaryApplicant.Street_Type_Pre__c = SoftQuoteUtil.checkStreetType(quoteToApp.Previous_Street_Type__c,quoteToApp.Region__c);
                        
                    }
                    primaryApplicant.Suburb_Pre__c = quoteToApp.Previous_Suburb__c;
                    primaryApplicant.Unit_No_Pre__c = quoteToApp.Previous_Unit_Number__c;                   
                    primaryApplicant.City_Pre__c = quoteToApp.Previous_City__c;
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
                    
                    //Added for POI Automation by Suneel on 21st Jan 2021
                    secondaryApplicant.Agrees_to_Income_Verification__c = confirm2AgreedToIncomeVerification;         
                    
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
                       //Added for POI Automation by Suneel on 21st Jan 2021
                        secondaryApplicant.Agrees_to_Income_Verification__c = confirm2AgreedToIncomeVerification;        
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
                        
                        //Added for POI Automation by Suneel on 21st Jan 2021
                        primaryApplicant.Agrees_to_Income_Verification__c = confirmAgreedToIncomeVerification;           
                            
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
                        
                         //Added for POI Automation by Suneel on 21st Jan 2021
                        primaryApplicant.Agrees_to_Income_Verification__c = confirmAgreedToIncomeVerification;           
                        
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
                        
                        //Added for POI Automation by Suneel on 21st Jan 2021
                        primaryApplicant.Agrees_to_Income_Verification__c = confirmAgreedToIncomeVerification;           
                        
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
                        
                        //Added for POI Automation by Suneel on 21st Jan 2021
                        secondaryApplicant.Agrees_to_Income_Verification__c = confirm2AgreedToIncomeVerification;        
                        
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
            List<Loan_Purpose__c> loanList;
            Id onrId;
            
            /** loanList = new List<Loan_Purpose__c>();
             onrId = parentONRId(currentApplication.Id);
            
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
            } **/
            
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
           
            if(ApexPages.currentPage().getParameters().get('qid') != null ){
             //Start Suneel
             
            quoteId = ApexPages.currentPage().getParameters().get('qId');
            quoteId = EncryptionManager.decryptQuoteId(quoteId);
            Quote__c currentQuote = [SELECT Id,Date_of_Birth__c,Quote_Stage__c,Channel__c,Region__c
                                             FROM 
                                             Quote__c 
                                             WHERE Id= :quoteID];
              string vDOB = currentQuote.Date_of_Birth__c;
              //currentQuote.Date_Of_Birth__c  = vDOB.subString(0,2) + '-' + vDOB.subString(3,5) + '-' + vDOB.subString(6,10);
              String date1 = vDOB.subString(0,2);
              String month = vDOB.subString(3,5);
              String year = vDOB.subString(6,10);
              
              birthdate = selectedDay;
              birthmonth1 = selectedMonth;
              birthYear = selectedYear;                          
       
             if(selectedDay == '' || selectedMonth == '' || selectedYear == ''){
               validateDOB();
             }else
            
              if(date1 != birthdate || month != birthmonth1 || year != birthYear){
             try{
         qv = [select Failed_Attempts__c from Quote_Validation_Tracker__c where Quote__c =:currentQuote.id];
         if(qv.size() < 1){
                a = new Quote_Validation_Tracker__c();
                a.Quote__c = currentQuote.id;
                a.Failed_Attempts__c =  1;  
                insert a;                       
               
                ValidateDOB();  
        }
        if(qv.size() >= 1){
            getQVT = [select id from Quote_Validation_Tracker__c where Quote__c =:currentQuote.id];
            updateQVT = [select id,Failed_Attempts__c,Quote__c from Quote_Validation_Tracker__c where id= :getQVT.id];        
            updateQVT.Failed_Attempts__c = updateQVT.Failed_Attempts__c + 1;
            update updateQVT;             
           
            ValidateDOB();
                       
        }
            
        
    }catch(Exception e){}                             
             }else if(date1 == birthdate && month == birthmonth1 && year == birthYear && qvtCheck && currentQuote.Quote_Stage__c ==GEN_OriginationsConstants.QUOTE_CONVERTED_TO_APP){
                  errorDOBValidation = true;
                 if(currentQuote.Channel__c !='Broker' && currentQuote.Region__c == 'AU'){
                     errorDOBValidationMsg = 'You already have an application in progress. Please contact us on 1300 973 422 for assistance.';   
                 }else if(currentQuote.Channel__c =='Broker' && currentQuote.Region__c == 'AU'){
                     errorDOBValidationMsg = 'You already have an application in progress. Please contact us on 1800 035 902 for assistance.';   
                 }
                 if( currentQuote.Region__c == 'NZ'){
					errorDOBValidationMsg = 'You already have an application in progress. Please contact us on 0800 422 898 for assistance.';                        
                 }
                     
                  
                 
             } else if(date1 == birthdate && month == birthmonth1 && year == birthYear && qvtCheck && currentQuote.Quote_Stage__c !=GEN_OriginationsConstants.QUOTE_CONVERTED_TO_APP){
                 
              
                 
             try{
                                          
                     System.debug('Verify Identity Passed');
           
                    loanList = new List<Loan_Purpose__c>();
                    onrId = parentONRId(currentApplication.Id);
            
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
                        
               return pageRef;
          
             }catch(Exception e){}
  
             }
             
           }else{  //End Suneel  
           
           loanList = new List<Loan_Purpose__c>();
             onrId = parentONRId(currentApplication.Id);
            
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
         //  pageRef.setRedirect(true);                 
           return pageRef;
          }
           
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
    /*
    Description : Loan Term dependent on Product SubType Dropdown
    Author : Suneel Desiraju
    Date Created : 29/05/2019
    */
    public void getProductOnLoanSelection(){
    getproductOptions();
    }
    public void getLoanTermOnProduct(){
    getloanTermOptions();
    }
        
    /* End */
    /* End */
    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> getloanTermOptions() { 
       if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' || productSelected == 'Better Start PL'){
//       if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' || productSelected == 'Better Start PL – 3mths interest free & no payment'){
         Brand__c brand_bs = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
        
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
        List < SelectOption > options_bs = new List < SelectOption > ();
        options_bs.add(new SelectOption('', 'Please Select'));
        list <string> values_bs = new list <string>();
        values_bs = (brand_bs.Loan_Term_Better_Start__c.split(';'));
        values_bs.sort();
        for(String s : values_bs){
            if(s.toLowerCase().contains('months'))
                options_bs.add(new SelectOption(s, s));    
        }
          
        for (String s: values_bs) {
            if (!s.toLowerCase().contains('months')) {
                options_bs.add(new SelectOption(s, s));
            }
        }
        
        return options_bs;
        }
     /* else if(ApexPages.currentPage().getParameters().get('form') == 'broker' && totAmount >=20000 ){
       Brand__c brand_bs = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
        
        
        List < SelectOption > options_bs = new List < SelectOption > ();
        options_bs.add(new SelectOption('', 'Please Select'));
        list <string> values_bs = new list <string>();
        values_bs = (brand_bs.Loan_Term_Better_Start__c.split(';'));
        values_bs.sort();
        for(String s : values_bs){
            if(s.toLowerCase().contains('months'))
                options_bs.add(new SelectOption(s, s));    
        }
          
        for (String s: values_bs) {
            if (!s.toLowerCase().contains('months')) {
                options_bs.add(new SelectOption(s, s));
            }
        }
        
        return options_bs;
        } */
       else { 
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
    }
    
    /*  Description: Loan Term Better Start
     *  Author: Suneel Desiraju
     *  Date Created: 08/05/2019
     *  Input Parameters: None
     *  Return: List<SelectOption>
     
    public List<SelectOption> getloanTermBetterStartOptions() { 
        Brand__c brand = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
       
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', 'Please Select'));
        list <string> values = new list <string>();
        values = (brand.Loan_Term_Better_Start__c.split(';'));
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
    } */
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
      //Added softquote check for Valid brokers  
      if (quoteID == null){
            if(isBrokerChannel() && !searchBroker()){
                isNotValidBroker = true;
                loanValidationResults = false;
                System.debug('$$$ 1');
            }
        }else if(quoteID != null && quoteToApp.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
            //perform broker search for  broker quotes 
            //searchBroker();
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
        //Below code Added by Suneel - Loan Amount Validation - Better Start
      if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart'){
        validLPAmount = 20000;
         if(totAmount < validLPAmount){
            loanAmountNotValid = true;
            loanValidationResults = false;
            System.debug('$$$ 3');
        }
        
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
        System.debug('applicationId is: '+applicationId);
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
                        String qIdFromUrl = ApexPages.currentPage().getParameters().get('qId');
                        System.debug('qIdFromUrl: '+qIdFromUrl);
                        System.debug('$$$ authenticated');
                        pageReference pageRef = Page.APP_Logout;
                        pageRef.getParameters().put('broker', 'true');
                        /**For Soft Quote Enhancement, when the APP Eligibility page is invoked from Broker Portal, the Broker will be logged out from the portal
                         * and will be redirected to Logout Page and from there to APP_Eligibility again with public guest user (Latitude S). While doing so, if 
                         * qId is present in the URL then append that to the Logout page so that when APP_Eligibitly page is loaded post logout, the redirected
                         * URL contains the qId that originated from the Broker Portal.
                         */
                        if(qIdFromUrl != null){
                            pageRef.getParameters().put('qId', qIdFromUrl);
                        }
                        pageRef.setRedirect(true);
                        return pageRef;
                    //}
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
        
      //Product Dropdown Better
     public List < SelectOption > getproductOptions(){
        
               System.debug('Value Entered Two');

            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
             if (loanWrapList != null) {
            for (loanWrapper lp: loanWrapList) {
             if(lp.loan.Value__c == 'Debt consolidation' && totAmount >= 20000){
                         options.add(new SelectOption('Better Start PL', 'Better Start PL')); 
                         options.add(new SelectOption('Standard PL', 'Standard PL'));           
                         break;
             }else {
             
             options.add(new SelectOption('Standard PL', 'Standard PL')); 
             break; 
             }
             
            }
            }
            return options;
           /* if(totAmount <= 0 || totAmount >= 20000 ){
            
            options.add(new SelectOption('Better Start PL', 'Better Start PL'));            
            options.add(new SelectOption('Standard PL', 'Standard PL')); 
            }
            else{
            options.add(new SelectOption('Standard PL', 'Standard PL'));         
            }
            return options;*/
      
     
        
    }

    /*  Description: Link the quote number to the generated application Id
     *  Author: Gautam Kasukhela
     *  Date Created: 05-Mar-2020
     *  Input Parameters: applicationId, quoteId
     * 
     */
    
    private void linkApplicationToQuote(Id applicationId, String quoteId){
        //Validate if 'Soft Quote' is enabled in custom settings for AU or NZ based on the brand.
        System.debug('ENCRYPT QUOTE ID: '+quoteId);
        //Decrypt the Quote Id 
        if(quoteId != null){
            quoteId = EncryptionManager.decryptQuoteId(quoteId);
            System.debug('DECRYPT QUOTE ID: '+quoteId);
        }else{
            return;
        }
        if(SoftQuoteUtil.checkSoftQuoteOrgEnabled()){
            System.debug('Inside Check SQ: '+applicationId);
            List<Quote__c> quoteList = new List<Quote__c>();
            quoteList = [SELECT Id,Application__c
                        FROM Quote__c
                        WHERE Id=: quoteId];
           System.debug('QUOTE LIST: '+quoteList);
            if(quoteList.size() == 1 ){    
                Quote__c quoteObj = new Quote__c();
                quoteObj.Id = quoteList[0].Id;
                quoteObj.Application__c = applicationId;
                update quoteObj;
            }
            
        }
        
    }
    
    
    //Start Suneel
     /*  Description: BirthDate Field Picklist values
         *  Author: Suneel Desiraju
         *  Date Created: Nov 12 2020
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    Public List < SelectOption > getDateOptions() {
        List < SelectOption > options = new List < SelectOption > ();
        Integer dateNum = 31;
        options.add(new SelectOption('Select', 'Select'));
        if (Util.nullCheck(birthMonth)) {   //05.14.15 Mike Lasala: Code Scan fix
            if (birthMonth == '02') {
                dateNum = 29;
            }
            if (birthMonth == '01' || birthMonth == '03' || birthMonth == '05' || birthMonth == '07' || birthMonth == '08' || birthMonth == '10' || birthMonth == '12') {
                dateNum = 31;
            }
            if (birthMonth == '04' || birthMonth == '06' || birthMonth == '09' || birthMonth == '11') {
                dateNum = 30;
            }
        }
        for (Integer i = 1; i <= dateNum; i++) {
            if (i <= 9) {
                options.add(new SelectOption('0' + String.valueOf(i), String.valueOf(i)));
            } else {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
        }
        return options;
    }
    
     /*  Description: BirthMonths Field Picklist values
         *  Author: Suneel Desiraju
         *  Date Created: Nov 11 2020
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    Public List < SelectOption > monthOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('Select', 'Select'));
                options.add(new SelectOption('01', 'January'));
                options.add(new SelectOption('02', 'February'));
                options.add(new SelectOption('03', 'March'));
                options.add(new SelectOption('04', 'April'));
                options.add(new SelectOption('05', 'May'));
                options.add(new SelectOption('06', 'June'));
                options.add(new SelectOption('07', 'July'));
                options.add(new SelectOption('08', 'August'));
                options.add(new SelectOption('09', 'September'));
                options.add(new SelectOption('10', 'October'));
                options.add(new SelectOption('11', 'November'));
                options.add(new SelectOption('12', 'December'));
                return options;
            }
            set;
        }
        
       public Boolean ValidateDOB(){
           Boolean validationResult = true;
          
           
            if(selectedDay == '' || selectedMonth == '' || selectedYear =='' ){
                        errorDOBValidation = true;
                        errorDOBValidationMsg= 'Enter a date of birth';
                        validationResult = false;
          } else{
           quoteId = ApexPages.currentPage().getParameters().get('qId');
            quoteId = EncryptionManager.decryptQuoteId(quoteId);
            
             //currentQuote.Date_Of_Birth__c  = vDOB.subString(0,2) + '-' + vDOB.subString(3,5) + '-' + vDOB.subString(6,10);
              
              
              
            Quote__c currentQuote = [SELECT Id,Channel__c,Region__c,Date_of_Birth__c,Quote_Stage__c
                                             FROM 
                                             Quote__c 
                                             WHERE Id= :quoteID];
              
              
               
               List<Quote_Validation_Tracker__c> qv = [select Quote__r.Date_of_Birth__c,Failed_Attempts__c from Quote_Validation_Tracker__c where Quote__c =:currentQuote.id];

       for(Quote_Validation_Tracker__c qvt : qv){
       
              string vDOB = qvt.Quote__r.Date_of_Birth__c;
              String date1 = vDOB.subString(0,2);
              String month = vDOB.subString(3,5);
              String year = vDOB.subString(6,10);
              
              birthdate = selectedDay;
              birthmonth1 = selectedMonth;
              birthYear = selectedYear; 
       
          if (qvt.Failed_Attempts__c ==  1 ){
                        errorDOBValidation = true;
                        errorDOBValidationMsg= 'Date of birth is incorrect. Please try again.';
                        validationResult = false;
                    } 
                    
                     if (qvt.Failed_Attempts__c ==  2 ){
                        errorDOBValidation = true;
                        errorDOBValidationMsg= 'Date of birth is incorrect. Please try again.';
                        validationResult = false;
                    }  
         
                  
      if (qvt.Failed_Attempts__c > 2 ){
                      errorDOBValidation = true;
                      if(currentQuote.Channel__c !='Broker' && currentQuote.Region__c == 'AU'){
                         errorDOBValidationMsg= 'You’ve reached the maximum number of attempts to verify your identity. Please call us on 1300 973 422 so we can assist you with your application.';
                      }else if(currentQuote.Channel__c =='Broker' && currentQuote.Region__c == 'AU'){
                         errorDOBValidationMsg= 'You’ve reached the maximum number of attempts to verify your identity. Please call us on 1800 035 902 so we can assist you with your application.';
                      } if( currentQuote.Region__c == 'NZ'){
                         errorDOBValidationMsg= 'You’ve reached the maximum number of attempts to verify your identity. Please call us on 0800 422 898 so we can assist you with your application.';
                      }
                      validationResult = false;
                      qvtCheck = false;
                    }
                     
          
       }
           
              
       }
                    
       return validationResult;
       }
    //End Suneel
  }