/**
 * @Description: Main Class for GE Customer UI
 * @Author: Dan Crisologo
 * @Date Created: OCTOBER-01-2013
 * @History:
   =====================================================================
        OCT-01-13 Dan Crisologo : Created.
        OCT-22-13 Mac Domingo   : Updated - Re factored code to get related records based on Application Id
        DEC-03-13 Mike Lasala   : Added eligibility population per applicant
        FEB-17-13 Adrian Recio  : Added preEmploymentStatusOptions method that pulls piclist values of pre 
                                  employment status field in applicant
        FEB-19-13 Adrian Recio  : Added retrieveIncomeMap method to pull income 
                                  records in map format related to specific applicant record
        MAR-07-13 Mat Isidro    : Modified applicant query to include related objects  
        MAR-31-14 Mat Isidro    : Refactoring of Admin Settings custom settings
        OCT-30-14 Davey Yu      : Jira #DBHZL-30 Update - Address Field Localisation. Field handling for New Zealand Addresses
        DEC-10-14 Devendra Babu : Added Constants and initialized which are used in common for DBHZL-143         
        FEB-11-2014 Keerthan    : DBHZL-81 story - Updated create AML method              
        APR-15-2015 Davey Yu    : Defect 896 - Updated pattern for License
        APR-23-2015 Davey       : Defect 1112 - Add new flag for Previous Suburb field if accessible
        SEPT-17-15: MLASALA     : ASYNC TO SYNC CALL OUT
   =====================================================================
 */
public without sharing virtual class APP_CommonExt {

    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================

    public Boolean isBrokerChannel {get; set;}
    
    //Better Start field
    public Boolean isBSOfferActive {get;set;}
    public Boolean isBSOfferNZActive {get;set;}
    public Boolean isBetterStart {get;set;}
    public String productSelected {get;set;}
    
    public String sessionId ;
   
    public Boolean showCancel {
        get;
        set;
    }
    public Boolean showHideCloseButton {
        get;
        set;
    }
    public Boolean showHideCPUCaseButton {
        get;
        set;
    }
    public Boolean showHideEditButton {
        get;
        set;
    }
    public Boolean showHideOfferButton {
        get;
        set;
    }
    public Boolean showHideSubmitButton {
        get;
        set;
    }
    // Adding this as part of NZ CR Code
      public Boolean showHideSubmitButtonNZ {
        get;
        set;
    }
     public Boolean showHideSaveQuoteButton {
        get;
        set;
    }
    public Boolean verifyPOIButton {
        get;
        set;
    }
    public Boolean updateApplicationButton {
        get;
        set;
    }
    public Boolean userLoginButton {
        get;
        set;
    }
    public Boolean userLoginButton2 {
        get;
        set;
    }
    public Boolean showGenerateDoc {
        get;
        set;
    }
    public Boolean showOffers {
        get;
        set;
    }
    public Boolean isRegistered {
        get;
        set;
    }
    public Boolean faxCoverSheetButton {
        get;
        set;
    }
    public Boolean changeOwnerButton {
        get;
        set;
    }
    //ADDED RCADAPAN @ 08-MAR-2016 for TQLQW-29
    public Decimal validLPAmount{
        get;
        set;
    }
    public static Boolean isCustomer;
    
    transient public Decimal totalIncome {
        get;
        set;
    }
    transient public Decimal totalExpense {
        get;
        set;
    }
    transient public Decimal totalDebt {
        get;
        set;
    }
    transient public Decimal totalAsset {
        get;
        set;
    }

    transient public List < Income__c > incomeList {
        get;
        set;
    }
    transient public List < Asset__c > assetList {
        get;
        set;
    }
    transient public List < Expense__c > expenseList {
        get;
        set;
    }
    transient public List < Liability__c > debtList {
        get;
        set;
    }

    //For Status Tracking on Applicant Level
    transient public String app1Status {
        get;
        set;
    }
    transient public String app1AboutMe {
        get;
        set;
    }
    transient public String app1Income {
        get;
        set;
    }
    transient public String app1Asset {
        get;
        set;
    }
    transient public String app1Expense {
        get;
        set;
    }
    transient public String app1Debts {
        get;
        set;
    }

    transient public String app2Status {
        get;
        set;
    }
    transient public String app2AboutMe {
        get;
        set;
    }
    transient public String app2Income {
        get;
        set;
    }
    transient public String app2Asset {
        get;
        set;
    }
    transient public String app2Expense {
        get;
        set;
    }
    transient public String app2Debts {
        get;
        set;
    }

    transient public List < Income__c > incomeList2 {
        get;
        set;
    }
    transient public List < Expense__c > expenseList2 {
        get;
        set;
    }
    
    public static Boolean isAppBroker; //  ADDED by RUSSELL CADAPAN for Fix Pack 2 @ 05/05/2016
    public static String appBrandString; //  ADDED by RUSSELL CADAPAN for Fix Pack 2 @ 05/05/2016
    public Applicant__c applicant {
        get{
            this.applicant = new Applicant__c();
            if(this.applicantList != null && !this.applicantList.isEmpty()){
                for(Applicant__c a: this.applicantList){
                    if(a.Is_Primary_Applicant__c){
                        this.applicant = a;
                    }
                }
            }
            return this.applicant;
        }
        set;
    }

    public Applicant__c applicant2 {
        get{
            this.applicant2 = new Applicant__c();
            if(this.applicantList != null && this.applicantList.size() > 1){
                for(Applicant__c a: this.applicantList){
                    if(!a.Is_Primary_Applicant__c){
                        this.applicant2 = a;
                    }
                }
            }
            return this.applicant2;
        }
        set;
    }

    public List < Applicant__c > applicantList { 
        get{
            //this.applicantList = new List<Applicant__c>();
            //if(this.application.Id != null && this.applicantList != null){
            if(this.applicantList == null && this.application.id != null){    
                this.applicantList = APP_CommonVariables.retrieveApplicants(this.application.Id);
            }
            return this.applicantList;
        }
        set;
    }

    public String productId {
        get{
            if(this.application != null){
                this.productId = this.application.Product_Id__c;
            }
            return this.productId;
        }
        set;
    }
    
// Added by Arshad 
    public Better_Start_Offer__c bsoffer {get;set;}
// End
    public Product_Version__c pversion;
    public String type;
    public String channel;
    public Boolean insurance;
    public Boolean interestOnOtherServices;
    public String applicant1FirstName;

    //Applicant 2
    public Boolean insurance2;
    public Boolean interestOnOtherServices2;
    public String applicant2FirstName;

    //*** Objectives and Requirements *** //
    public Product_Item__c pItem;

    //*** PersonalDetails Variables ***//
    Public String birthYear {
        get;
        set;
    }
    Public String birthMonth {
        get;
        set;
    }
    Public String birthDate {
        get;
        set;
    }
    Public Boolean disableDrvLic {
        get;
        set;
    }
    Public String disableDrvcAst {
        get;
        set;
    }

    //*** Joint PersonalDetails Variables ***//
    Public String birthYear2 {
        get;
        set;
    }
    Public String birthMonth2 {
        get;
        set;
    }
    Public String birthDate2 {
        get;
        set;
    }

    Public String destinationPage {
        get;
        set;
    }
    Public String callingPage {
        get;
        set;
    }

    public String blackBox {
        get;
        set;
    } //iOvation fingerprint container

    //Loan Purpose
    //Loan Purpose variables
    public List < loanWrapper > loanWrapList {
        get;
        set;
    }
    public Integer loanPurposeSize {
        get;
        set;
    }
    public String loanFrequencySelected {
        get;
        set;
    }
    public String loanTermSelected {
        get;
        set;
    }
    public Boolean loanTermNotValid {
        get;
        set;
    }
    public Boolean paymentNotValid {
        get;
        set;
    }
    public Boolean loanAmountNotValid {
        get;
        set;
    }
    public Decimal totAmount {
        get;
        set;
    }
    public Boolean loanValidationResults {
        get;
        set;
    }

    @TestVisible private ApexPages.StandardController applicationController;

    // Custom Settings for Admin Settings
    public String AS_APPLICATION {
        get {
            return Admin_Settings__c.getValues('Application').Value__c;
        }
        set;
    }

    public String AS_APPLICATIONRESPONSE {
        get {
            return Admin_Settings__c.getValues('Application Response').Value__c;
        }
        set;
    }

    public Integer AS_INACTIVITY {
        get {
            return Integer.valueOf(Admin_Settings__c.getValues('Inactivity').Value__c);
        }
        set;
    }
    
    public String AS_LIABILITY {
        get {
            return Admin_Settings__c.getValues('Liability').Value__c;
        }
        set;
    }
    
    public String AS_OMNITURESOURCE {
        get {
            return Admin_Settings__c.getValues('Omniture Source').Value__c;
        }
        set;
    }
    
    public String AS_ONLINEBRANCH {
        get {
            return Admin_Settings__c.getValues('Online Branch').Value__c;
        }
        set;
    }
    
    public String AS_ONLINEBRANCH_KIWIBANK {
        get {
            return Admin_Settings__c.getValues('Online Branch Kiwibank').Value__c;
        }
        set;
    }
    
    public Integer AS_PLANDELETEBATCHSIZE {
        get {
            return Integer.valueOf(Admin_Settings__c.getValues('Plan Delete Batch Size').Value__c);
        }
        set;
    }
    
    public Integer AS_PLANDELETEQUERYSIZE {
        get {
            return Integer.valueOf(Admin_Settings__c.getValues('Plan Delete Query Size').Value__c);
        }
        set;
    }
    
    public Integer AS_TIMEOUT {
        get {
            return Integer.valueOf(Admin_Settings__c.getValues('Timeout').Value__c);
        }
        set;
    }
    
    public Integer AS_WARNING {
        get {
            return Integer.valueOf(Admin_Settings__c.getValues('Warning').Value__c);
        }
        set;
    }
    
    // Custom Settings for Admin Settings 

    public Application__c application {
        get {
            if (this.application == null) {
                this.application = APP_CommonVariables.retrieveApplication(((Application__c) applicationController.getRecord()).Id);
            }
            System.debug('sysdbg-this.application.Id:' + this.application);
            isAppBroker = this.application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER ? true : false; //  ADDED by RUSSELL CADAPAN for Fix Pack 2 @ 05/05/2016
            appBrandString = this.application.Brand_String__c; //  ADDED by RUSSELL CADAPAN for Fix Pack 2 @ 05/05/2016
            return this.application;
        }
        set;
    }
   
    public static String brandCountry {
        get;
        set;
    }

    /*  Description: Get Country based on application's brand
     *  Author: Davey Yu
     *  Date Created: NOV-5-2014
     *  Input Parameters: None
     *  Return: String
     */
    public Brand__c brand {
        get {
            system.debug('brand application: ' + this.application.Brand_Lookup__c);
            if (this.application != null && this.application.Brand_Lookup__c != null) {
                this.brand = [SELECT id, name, country__c FROM Brand__c where id = : this.application.Brand_Lookup__c];
                brandCountry = this.brand.country__c;
                system.debug('brand country s: ' + brandCountry);
            }
            return this.brand;
        }
        set;
    }

    /*  Description: Get AU country from static variable to Intanse variable to use on VF pages
     *  Author: Fahad Akhtar
     *  Date Created: NOV-30-2014
     *  Input Parameters: None
     *  Return: String
     */
    public String au_Country {
        get {
            if (this.au_Country == null) {
                this.au_Country = GEN_OriginationsConstants.AU_REGION;
            }
            return this.au_Country;
        }
        set;
    }

    /*  Description: Get NZ country from static variable to Intanse variable to use on VF pages
     *  Author: Fahad Akhtar
     *  Date Created: NOV-30-2014
     *  Input Parameters: None
     *  Return: String
     */
    public String nz_Country {
        get {
            if (this.nz_Country == null) {
                this.nz_Country = GEN_OriginationsConstants.NZ_REGION;
            }
            return this.nz_Country;
        }
        set;
    }
    
    public List < SelectOption > countryOpts {
        get{
            system.debug('brand country : ' + brandCountry);
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
            if (brandCountry == 'NZ') {
                options.add(new SelectOption('New Zealand', 'New Zealand'));
            } else {
                options.add(new SelectOption('Australia', 'Australia'));
            }
            return options;
        }
        set;
    }
    public List < SelectOption > streetTypeOptions {
        get{
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
            List < Street_Type_Setting__c > streetTypeSetting = [SELECT Value_Abbreviated__c, Value_Abbreviated_NZ__c, Value__c, Region__c FROM Street_Type_Setting__C ORDER BY Value__c limit :limits.getLimitQueryRows()]; //changed by Tony Xu, NZ street type abbreviation different with AU street type abbreviation
            for (Street_Type_Setting__c sts: streetTypeSetting) {
                if (brandCountry != null) { //Added by Tony Xu
                    if (brandCountry == 'NZ' && (sts.Region__c.trim() == 'Both' || sts.Region__c.trim() == 'NZ')) {
                        options.add(new SelectOption(sts.Value_Abbreviated_NZ__c, sts.Value__c)); //changed by Tony Xu, NZ street type abbreviation different with AU street type abbreviation
                    }
                    if (brandCountry == 'AU' && (sts.Region__c.trim() == 'Both' || sts.Region__c.trim() == 'AU')) {
                        options.add(new SelectOption(sts.Value_Abbreviated__c, sts.Value__c));
                    }
                }
            }
            return options;
        }
        set;
    }

    //added as part of DBHZL-143 -  Devendra 
    public String AssetDeposit {
        get{
            return GEN_OriginationsConstants.ASSET_CATEGORY_DEPOSITS;
        }
        set;
    }
    public String AssetKiwiSaver {
        get{
            return GEN_OriginationsConstants.ASSET_CATEGORY_KIWISAVER;
        }
        set;
    }

    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Main Controller class used for all initializations of common variables
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: None
     *  Return: void
     */
    public APP_CommonExt() {
        isBrokerChannel = false;
        this.pItem      = new Product_Item__c();
        this.pversion   = new Product_Version__c();
        this.brand      = new Brand__c();
       
        // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
        /*isBSOfferActive = false;
        isBSOfferNZActive = false;
        bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        isBSOfferNZActive = bsoffer.BetterStartNZActive__c;  */  
    }

    /*  Description: Main Controller class used for all initializations of common variables
     *  Author: Dan Crisologo
     *  Date Created: OCT-01-2013
     *  Input: ApexPages.StandardController -- applicationController
     *  Return: void
     */
    public APP_CommonExt(ApexPages.StandardController applicationController) {
        //TODO -- url parameters (we might need to encrypt the url parameter values)
        System.debug('******* APPLICATION CONTOLLER ' + applicationController);
        this.applicationController = applicationController;
        if(test.isrunningtest()){
            if(this.applicant == null)
                this.applicant = new Applicant__c();
            if(this.application == null)
                this.application = new Application__c();
        }
        
        
         // Added by Arshad for turning ON/OFF Better Start functionality for Broker UI
       /* isBSOfferActive = false;
        isBSOfferNZActive = false;
        bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        isBSOfferActive = bsoffer.BetterStartAUActive__c;
        System.debug('isBSOfferActive' +isBSOfferActive);
        isBSOfferNZActive = bsoffer.BetterStartNZActive__c; */
    }

    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================

    /*  Description: retrieves the Profile Name of the Current User
     *  Author: Mac Domingo
     *  Date Created: Nov-4-2013
     *  Input: None
     *  Return: Boolean
     */
    public static Boolean isCustomer() {
        if (isCustomer != null) {
            return isCustomer;
        } else {
            String cust = ApexPages.currentPage().getParameters().get('cust');
            if (cust != null && cust.toUpperCase() == 'y')
                return true;
            Boolean isCustomerUser = false;
            String profId = UserInfo.getProfileId();
            Profile p = [SELECT UserLicenseId
                FROM Profile
                WHERE Id = : profId
            ];

            List < UserLicense > userLicenses = [SELECT Id
                FROM UserLicense
                WHERE Id = : p.UserLicenseId
                AND Name IN: GEN_OriginationsConstants.USERLICENSE_COMMUNITY
            ];

            if (!userLicenses.isEmpty()) {
                isCustomerUser = true;
            }

            isCustomer = isCustomerUser;
            return isCustomer;
        }
    }

    /*
     * Description: This method performs redirect to app main post submit page if current application is not new
     * If not it will redirect to authorization page
     * Author: Adrian Recio
     * Date Created: 8-APR-2014
     * Input Parameters: None
     * Return: pagereference
     */
    public PageReference commonAuthorizationRequired() {

        List < User > currentUser = [SELECT Id,
            IsRegistered__c,
            Brand__c,
            AppId__c
            FROM User
            WHERE Id = : UserInfo.getUserId() LIMIT 1
        ];

        List < Brand__c > currentBrand = [SELECT Id,
            Name
            FROM Brand__c
            WHERE Site__c = : Site.getName() LIMIT 1
            // 
        ];
   System.debug('currentUser:'+currentUser[0].Brand__c+ 'Brand__c:'+Site.getName());
        if (!currentUser.isEmpty()) {
            isRegistered = currentUser.get(0).IsRegistered__c;

            if (!currentBrand.isEmpty()) {

                if (currentUser.get(0).Brand__c != currentBrand.get(0).Name) {

                    //exception log
                    ErrorHandlerException.recordException('current user != current user', 'APP_CommonExt', 'commonAuthorizationRequired', 'Class', currentUser.get(0).AppId__c);

                    pageReference pgRef = Page.APP_Login;
                    pgRef.setRedirect(true);

                    return pgRef;

                }

            } else {

                //exception log
                ErrorHandlerException.recordException('current brand isEmpty', 'APP_CommonExt', 'commonAuthorizationRequired', 'Class', currentUser.get(0).AppId__c);

                pageReference pgRef = Page.APP_Login;
                pgRef.setRedirect(true);

                return pgRef;

            }

        } else {

            //exception log
            ErrorHandlerException.recordException('current user isEmpty', 'APP_CommonExt', 'commonAuthorizationRequired', 'Class', currentUser.get(0).AppId__c);

            pageReference pgRef = Page.APP_Login;
            pgRef.setRedirect(true);

            return pgRef;

        }

        if (application.Id != null) {
            if(application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){
                isBrokerChannel = true;
            }

            if (application.Status__c != 'New') {
                
                //BEGIN MLASALA: 04-FEB-16 TQLQW-20 Templates & Configuration
                pageReference pgRef;
                
                //Validate if GSD Enabled custom setting exists and set to true 
                if(Admin_Settings__c.getValues('GSD Enabled') != null && 
                   Boolean.valueOf(Admin_Settings__c.getValues('GSD Enabled').Value__c)){
                    
                    //BEGIN MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
                    //Check if offer has been locked by either the applicant or an agent
                    if(!application.Customer_Confirmed_Online_Offer__c && 
                       !application.Staff_Hide__c && 
                       (application.Online_Self_serve_Upsell_Eligibility__c || 
                        application.Online_Self_serve_Insurance_Eligibility__c)){
                            
                        //Eligible for upsell and/or insurance, redirect to upsell and insurance page
                        pgRef = Page.APP_GSD_Upsell_Insurance;
                            
                    } else {
                    
                        //Redirect to new GSD response page
                        pgRef = Page.APP_GSD_Response;
                    }
                    //END MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
                    
                } else {
                    
                    //Redirect to old post submit page
                    pgRef = Page.APP_Main_PostSubmit;
                }
                //END MLASALA: 04-FEB-16 TQLQW-20 Templates & Configuration
                
                pgRef.getParameters().put('Id', application.Id);
                pgRef.setRedirect(true);

                return pgRef;

            }

        }

        return null;

    }

    /*  Description: Method called by main page's action attribute, executed on page load.
     *  Author: Dan Crisologo
     *  Date Created: SEPT-24-2013
     *  Input: None
     *  Return: void
     */
    public void createGenericRecords() {
        //Gets the product version of the Selected Product 
        if(this.productId != null){
            try{
                pversion = [Select Id, End_Date__c, GEProduct__c, Start_Date__c from Product_Version__c where GEProduct__c = :this.productId];
            }
            catch(System.QueryException e){
                System.debug('###error: ' + e.getMessage());
                System.debug('###error: ' + e.getLineNumber());
                System.debug('###error: ' + e.getStackTraceString());
                
                ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Application__c', 'Class', null);
                Util.addMessage(ApexPages.Severity.Error, Label.Product_Version);
            }
        }
        //Create Application Record
        if (this.application.Id == null) {
            try {
                String BranchId = '';

                String Mode = ApexPages.currentPage().getParameters().get('ui');

                if (Mode == null) {
                    type = ApexPages.currentPage().getParameters().get('type');
                    channel = 'Online';
                    interestOnOtherServices = Boolean.valueOf(ApexPages.currentPage().getParameters().get('othInt'));
                }
                system.debug('$$$ type: ' + type + ' (Common)');
                GEProduct__c prod = new GEProduct__c();

                if (this.productId != null) {
                    prod = [Select Id, Brands__c, Brands__r.Name from GEProduct__c where Id = : this.productId];
                }
                if (insurance == null) {
                    insurance = false;
                }
                
                //defect 1391-devendra
                if(prod.Brands__r.Name==GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ){
                    if (Util.nullCheck(AS_ONLINEBRANCH)) {  //05.14.15 Mike Lasala: Code Scan fix
                        BranchId = AS_ONLINEBRANCH;
                    } else {
                        BranchId = Admin_Settings__c.getInstance('Online Branch').Value__c;
                    }
                }
                else if(prod.Brands__r.Name==GEN_OriginationsConstants.BRAND_NAME_KIWI){
                    if (Util.nullCheck(AS_ONLINEBRANCH_KIWIBANK)) {//05.14.15 Mike Lasala: Code Scan fix
                        BranchId = AS_ONLINEBRANCH;
                    } else {
                        BranchId = Admin_Settings__c.getInstance('Online Branch').Value__c;
                    }
                }
                
                this.application = new Application__c(Branch__c = BranchId, Brand_String__c = prod.Brands__r.Name, Brand_Lookup__c = prod.Brands__c, Application_Type__c = type, Channel__c = channel, Interested_in_other_services__c = interestOnOtherServices, Loan_Insurance_Consent__c = insurance, Product_Id__c = this.productId);
                insert application;
                system.debug('!@#share created application');

                //share custom object
                Application__Share customObjectShare = new Application__Share();
                //id of the record being shared
                customObjectShare.ParentId = application.Id;
                //id of user or group being granted access
                customObjectShare.UserOrGroupId = UserInfo.getUserId();
                //access level
                customObjectShare.AccessLevel = 'Edit'; //'Edit'

                upsert customObjectShare;

                String onrValue = 'No';

                if (this.application.Interested_in_other_services__c) {
                    onrValue = 'Yes';
                }

                List < Meta_ONR__c > metaONR = [SELECT Prompt__c
                    FROM meta_onr__c
                    WHERE type__c = : GEN_OriginationsConstants.ONR_TYPE_YESNO
                    AND onr_type__c = : GEN_OriginationsConstants.ONR_GENERAL
                    AND geId__c = : GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES
                ];

                Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c;
                Map < String, Schema.RecordTypeInfo > onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
                Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();
                if (metaONR.size() > 0) {
                    ONR__c interestOtherServiceONR = new ONR__c(type__c = GEN_OriginationsConstants.ONR_TYPE_YESNO,
                        recordTypeId = onrGeneral,
                        geId__c = GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES,
                        prompt__c = metaONR[0].Prompt__c,
                        value__c = onrValue,
                        application__c = this.application.Id);
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    if(ONR__c.SObjectType.getDescribe().isCreateable()) {
                        upsert interestOtherServiceONR;
                    }
                }
                
            }
            catch(DmlException e){
                System.debug('###error: ' + e.getMessage());
                System.debug('###error: ' + e.getLineNumber());
                System.debug('###error: ' + e.getStackTraceString());
                
                ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Application__c', 'Class', null); 
                Util.addMessage(ApexPages.Severity.Error, Label.Application_Error);
            }
        }

        //Create Applicant Record
        if (this.applicant.Id == null) {
            try {
                applicant1FirstName = String.valueOf(ApexPages.currentPage().getParameters().get('fName'));
                this.applicant = new Applicant__c(Application__c = this.application.Id, Is_Primary_Applicant__c = true, Loan_Insurance_Consent__c = insurance, Interested_in_other_services__c = interestOnOtherServices, First_Name__c = applicant1FirstName);
                insert this.applicant;
            }
            catch(DmlException e){
                System.debug('###error: ' + e.getMessage());
                System.debug('###error: ' + e.getLineNumber());
                System.debug('###error: ' + e.getStackTraceString());
                
                ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));                 
                Util.addMessage(ApexPages.Severity.Error, Label.Applicant_Error);
            }
        }
        if (type == 'Joint') {
            if (this.applicant2.Id == null) {
                try {
                    applicant2FirstName = String.valueOf(ApexPages.currentPage().getParameters().get('fName2'));
                    interestOnOtherServices2 = Boolean.valueOf(ApexPages.currentPage().getParameters().get('othInt2'));
                    if (insurance2 == null) {
                        insurance2 = false;
                    }

                    this.applicant2 = new Applicant__c(Application__c = this.application.Id, Loan_Insurance_Consent__c = insurance2, Interested_in_other_services__c = interestOnOtherServices2, First_Name__c = applicant2FirstName);
                    insert this.applicant2;
                    system.debug('**appplicant2.Id: '+applicant2.Id);
                }
                catch(DmlException e){
                    System.debug('###error: ' + e.getMessage());
                    System.debug('###error: ' + e.getLineNumber());
                    System.debug('###error: ' + e.getStackTraceString());
                
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Applicant__c', 'Class', String.valueOf(this.application.Id));                 
                    Util.addMessage(ApexPages.Severity.ERROR, Label.Applicant_Error);    
                }
            }
        }

        //Create Product Item Record
        if (pversion.Id != null) {
            try {
                pItem = new Product_Item__c(Application__c = this.application.Id, Product_Version__c = pversion.Id);
                insert pItem;
            }
            catch(DmlException e){
                System.debug('###error: ' + e.getMessage());
                System.debug('###error: ' + e.getLineNumber());
                System.debug('###error: ' + e.getStackTraceString());
                
                ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Product_Item__c', 'Class', String.valueOf(this.application.Id)); 
                Util.addMessage(ApexPages.Severity.ERROR, Label.Product_Item_Error);                
            }
        }
    }

    public static List < String > isEmailAvailable(Applicant__c applicant) {
        System.debug('300 ISSUE-1: '+applicant);
        List < String > flagMessage = new List < String > ();
        List < Application__c > application = new List < Application__c > ();
        List < User > user = new List < User > ();
        Set<id> set_appIds = new Set<id>();
        List<Applicant__c> lst_Applicant = new List<Applicant__c>();
        try {
            String searchQuery = 'FIND \'' + applicant.Email_Address__c + '\' IN EMAIL FIELDS RETURNING Applicant__c(Application__c)';
            List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
            lst_Applicant = ((List<Applicant__c>)ListOfListOfSObjects[0]);
            System.debug('300 ISSUE-2: '+lst_Applicant);
            for(Integer i=0; i<lst_Applicant.size(); i++){
                set_appIds.add(lst_Applicant[i].Application__c);
            }
            System.debug('300 ISSUE-3: '+set_appIds);
            application = [
                            SELECT 
                                    Id,
                                    Name,
                                    Brand_Country__c,
                                    Response_Code__c,
                                    Final_Approved_Date__c,
                                    UID__c,
                                    Brand_Lookup__r.LPE_Phone_Number__c,
                                    Brand_Lookup__r.NZ_Contact_Details__c
                            FROM 
                                    Application__c
                            WHERE Id IN : set_appIds
                ORDER BY CreatedDate DESC LIMIT 1
            ];
            System.debug('300 ISSUE-4: '+application);
            if (application.size() > 0) {

                if (application[0].Response_Code__c == 'FIC' || application[0].Response_Code__c == 'FID') {
                    System.debug('300 ISSUE-5: ');
                    flagMessage.add('true');
                    flagMessage.add('');

                } else if (application[0].Response_Code__c == 'FIA') {
                    System.debug('300 ISSUE-6: ');
                    Date finalApprovedDate = application[0].Final_Approved_Date__c;
                    Date dueDate = Date.today();
                    Integer daysBetween = finalApprovedDate.daysBetween(dueDate);

                    if (daysBetween <= 7) {
                        System.debug('300 ISSUE-7: ');
                        flagMessage.add('false');
                        flagMessage.add('Your application is still active');

                    } else if (daysBetween > 7) {
                        System.debug('300 ISSUE-8: ');
                        flagMessage.add('true');
                        flagMessage.add('');

                    }
                //BEGIN 08-AUG-2015 DYU PMIHM 1922 - ALLOW USER TO REUSE THE SAME EMAIL ADDRESS WHEN PREVIOUS APP IS FINALISED
                } else if (application[0].Response_Code__c != 'FFID' && application[0].Response_Code__c != 'Abandoned' && application[0].Response_Code__c != 'FIA' && application[0].Response_Code__c != 'FIC' && application[0].Response_Code__c != 'FID') {
                //BEGIN 08-AUG-2015 DYU PMIHM 1922 
                System.debug('300 ISSUE-9: ');   
                    flagMessage.add('false');
                    if (UserInfo.getUserType() == 'Guest' || UserInfo.getUserType() == 'CspLitePortal') {
                        System.debug('300 ISSUE-10: ');
                        // START - UPDATED by RUSSELL CADAPAN for Fix Pack 2
                        Brand__c siteBrand = [SELECT Id, Name, Country__c, NZ_Contact_Details__c, LPE_Phone_Number__c, Inbound_Phone_Number__c FROM Brand__c WHERE Site__c =: Site.getName()];
                        System.debug('300 ISSUE-10.1: '+siteBrand);
                        System.debug('300 ISSUE-10.2: '+appBrandString);
                        System.debug('300 ISSUE-10.3: '+isAppBroker);
                        if(siteBrand.Country__c == GEN_OriginationsConstants.AU_REGION){
                            System.debug('300 ISSUE-10.4: ');
                            if(appBrandString == GEN_OriginationsConstants.BRAND_NAME_GEMONEY){
                                System.debug('300 ISSUE-10.5: ');
                                if(isAppBroker){
                                    System.debug('300 ISSUE-10.6: ');
                                    flagMessage.add('There is already an application for this customer in progress. Please contact us on ' + siteBrand.Inbound_Phone_Number__c + ' for assistance. ');
                                }
                                else{
                                    System.debug('300 ISSUE-11: ');
                                    flagMessage.add('You already have an application in progress. Please contact us on ' + siteBrand.Inbound_Phone_Number__c + ' for assistance. ');
                                }
                            }
                            else if(appBrandString == GEN_OriginationsConstants.BRAND_NAME_AUSSIE){
                                System.debug('300 ISSUE-12: ');
                                flagMessage.add('You already have an application in progress. Please contact us on ' + siteBrand.LPE_Phone_Number__c + ' for assistance. ');
                            }
                        }
                        else{
                            System.debug('300 ISSUE-13: ');
                            flagMessage.add('You already have an application in progress. Please contact us on ' + siteBrand.NZ_Contact_Details__c + ' for assistance. ');
                        }
                        // END - UPDATED by RUSSELL CADAPAN for Fix Pack 2
                        
                    } else if (application[0].UID__c != null) {
                        flagMessage.add('Your application is still in progress ' + application[0].UID__c);
                    } else {
                        flagMessage.add('Your application is still in progress ' + application[0].Name);
                    }


                }

            } else {

                flagMessage.add('true');
                flagMessage.add('');

            }

        } catch (Exception e) {

            //exception log
            System.debug('!@#EXCEPTION: ' + e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'isEmailAvailable()', 'APP_CommonExt', 'Class', null);

        }
        System.debug('300 ISSUE flagMessage: '+flagMessage);
        return flagMessage;

    }

    public static List < String > isEmailAvailable(String email) {

        List < String > flagMessage = new List < String > ();
        List < Application__c > application = new List < Application__c > ();
        List < User > user = new List < User > ();
        Set<id> set_appIds = new Set<id>();
        List<Applicant__c> lst_Applicant = new List<Applicant__c>();
        
        try {
            
            String searchQuery = 'FIND \'' + email + '\' IN EMAIL FIELDS RETURNING Applicant__c(Application__c)';
            List<List<sObject>> ListOfListOfSObjects = search.query(searchQuery);
            lst_Applicant = ((List<Applicant__c>)ListOfListOfSObjects[0]);
            for(Integer i=0; i<lst_Applicant.size(); i++){
                set_appIds.add(lst_Applicant[i].Application__c);
            }

            application = [SELECT Id,
                Name,
                Response_Code__c,
                Final_Approved_Date__c,
                UID__c
                FROM Application__c
                WHERE Id IN : set_appIds
                ORDER BY CreatedDate DESC LIMIT 1
            ];

            if (application.size() > 0) {
                if (application[0].Response_Code__c == 'FIC' || application[0].Response_Code__c == 'FID') {

                    flagMessage.add('true');
                    flagMessage.add('');

                } else if (application[0].Response_Code__c == 'FIA') {

                    Date finalApprovedDate = application[0].Final_Approved_Date__c;
                    Date dueDate = Date.today();
                    Integer daysBetween = finalApprovedDate.daysBetween(dueDate);

                    if (daysBetween <= 7) {

                        flagMessage.add('false');
                        flagMessage.add('Your application is still active');

                    } else if (daysBetween > 7) {

                        flagMessage.add('true');
                        flagMessage.add('');

                    }

                } else if (application[0].Response_Code__c != 'FIA' && application[0].Response_Code__c != 'FIC' && application[0].Response_Code__c != 'FID') {

                    flagMessage.add('false');
                    if (UserInfo.getUserType() == 'Guest' || UserInfo.getUserType() == 'CspLitePortal') {
                        flagMessage.add('Your application is still in progress');
                    } else if (application[0].UID__c != null) {
                        flagMessage.add('Your application is still in progress ' + application[0].UID__c);
                    } else {
                        flagMessage.add('Your application is still in progress ' + application[0].Name);
                    }


                }

            } else {

                flagMessage.add('true');
                flagMessage.add('');

            }

        } catch (Exception e) {

            //exception log
            System.debug('!@#EXCEPTION: ' + e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'isEmailAvailable()', 'APP_CommonExt', 'Class', null);

        }

        return flagMessage;

    }

    public static Boolean validatePhone(String numberType, String phone) {
        Boolean flag = false;

        Pattern phonePattern = Pattern.compile(GEN_OriginationsConstants.patternPhone);
        Pattern phonePattern2 = Pattern.compile(GEN_OriginationsConstants.patternPhone2);
        Pattern phonePattern3 = Pattern.compile(GEN_OriginationsConstants.patternPhone3);
        Pattern phonePattern4 = Pattern.compile(GEN_OriginationsConstants.patternPhone4);
        Pattern phonePattern5 = Pattern.compile(GEN_OriginationsConstants.patternPhone5);
        Pattern phonePattern6 = Pattern.compile(GEN_OriginationsConstants.patternPhone6);

        Matcher phoneMatcher = phonePattern.matcher(phone.trim());
        Matcher phoneMatcher2 = phonePattern2.matcher(phone.trim());
        Matcher phoneMatcher3 = phonePattern3.matcher(phone.trim());
        Matcher phoneMatcher4 = phonePattern4.matcher(phone.trim());
        Matcher phoneMatcher5 = phonePattern5.matcher(phone.trim());
        Matcher phoneMatcher6 = phonePattern6.matcher(phone.trim());
        if (numberType == 'Regular') {
            flag = phoneMatcher.matches();
        }
        if (numberType == 'Home') {
            if (flag == false) {
                flag = phoneMatcher2.matches();
            }
            if (flag == false) {
                flag = phoneMatcher3.matches();
            }
            if (flag == false) {
                flag = phoneMatcher5.matches();
            }
            if (flag == false) {
                flag = phoneMatcher6.matches();
            }
        }
        if (numberType == 'Work') {
            if (flag == false) {
                flag = phoneMatcher2.matches();
            }
            if (flag == false) {
                flag = phoneMatcher3.matches();
            }
            if (flag == false) {
                flag = phoneMatcher4.matches();
            }
            if (flag == false) {
                flag = phoneMatcher5.matches();
            }
            if (flag == false) {
                flag = phoneMatcher6.matches();
            }
        }
        if (numberType == 'Mobile') {
            flag = phoneMatcher4.matches();
        }
        return flag;
    }

    public static Boolean validateName(string name) {
        Boolean flag;
        String patternName = '([a-zA-Z \\-\\' + '\']+)';

        Pattern namePattern = Pattern.compile(patternName);
        Matcher nameMatcher = namePattern.matcher(name.trim());
        flag = nameMatcher.matches();
        return flag;
    }

    public static Boolean validateLicense(String license) {
        Boolean flag;
        //Updated by DYU 04-15-2015 - Update the pattern for license
        //String patternLicense = '([a-zA-Z0-9]+)';
        String patternLicense = '([a-z0-9A-Z_]+)';
        Pattern licensePattern = Pattern.compile(patternLicense);
        Matcher licenseMatcher = licensePattern.matcher(license.trim());
        flag = licenseMatcher.matches();

        return flag;
    }

    public static boolean isEmailValid(String userEmail) {
        Boolean flag = false;

        String emailRegex = GEN_OriginationsConstants.patternEmail;
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(userEmail.trim());
        flag = emailMatcher.matches();

        return flag;
    }

    public static Boolean validateEmployerName(string name) {
        Boolean flag;
        String patternName = '([a-zA-Z0-9 \\-_]+)';
        Pattern namePattern = Pattern.compile(patternName);
        Matcher nameMatcher = namePattern.matcher(name.trim());
        flag = nameMatcher.matches();
        return flag;
    }

    //===============================================================
    //                       PRIVATE METHODS
    //===============================================================

    /*  Description: retrieves application record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: applicationId -- Id of the application record to query
     *  Return: Application__c
     */
    @TestVisible protected Application__c retrieveApplication(String applicationId) {
        //TODO -- remove hard code (dan)
        return (Application__c) querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), 'Application__c', applicationId);
    }

    /*  Description: retrieves applicant record
     *  Author: Mac Domingo
     *  Date Created: OCT-22-2013
     *  Input: applicantionId -- Id of the applicant record to application
     *  Return: Applicant__c
     */
    @TestVisible private Applicant__c retrieveApplicant(String applicationId) {
        return (Applicant__c) querySingleRelatedRecord(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId);
    }

    /*  Description: retrieves applicant record
     *  Author: Mac Domingo
     *  Date Created: OCT-22-2013
     *  Input: applicationId -- Id of the application record to query
     *  Return: List of Applicant__c
     */
    @TestVisible private List < Applicant__c > retrieveApplicants(String applicationId) {
        List < Applicant__c > appList = new List < Applicant__c > ();
        if (applicationId != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields(), 'Applicant__c', 'Application__c', applicationId)) {
                appList.add((Applicant__c) o);
            }
        }
        return appList;
    }

    /*  Description: retrieves Person Account record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: personAccountId -- Id of the Person Account record to query
     *  Return: Account
     */
    @TestVisible private Account retrievePersonAccount(String personAccountId) {
        return (Account) querySingleRecord(SObjectType.Account.FieldSets.Person_Origins_Accounts_Common.getFields(), 'Account', personAccountId);
    }

    /*  Description: retrieves lists of income related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Income__c>
     */
    @TestVisible protected List < Income__c > retrieveIncomeList(Id applicantId) {
        List < Income__c > incomeList = new List < Income__c > ();
        if (this.applicant.Id != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Income__c.FieldSets.Income_Commons.getFields(), 'Income__c', 'Applicant__c', applicantId)) {
                incomeList.add((Income__c) o);
            }
        }
        return incomeList;
    }
    
    /*  Description: retrieves lists of income related to the quote and applicant record
     *  Author: Madhusudhan Seethala
     *  Date Created: Aug-26-2020
     *  Input: None
     *  Return: List<Income__c>
     */
    @TestVisible protected List < Income__c > createIncomeList(Id applicantId) {
        List < Income__c > incomeList = new List < Income__c > ();
        List<Quote__c> qList = new List<Quote__c>();
        List<Applicant__c> appList = new List<Applicant__c>();
               
        if (this.applicant.Id != null) {
        
            incomeList = [Select Id,Months_With_Employer__c,Years_With_Employer__c,
                          Income_Source__c, Industry__c,Applicant__c 
                          from 
                          Income__c where Applicant__c =:this.applicant.Id];
               
          if(incomeList.isEmpty()){       
         
              //Get the Application ID
              appList = [Select Id, Application__c from Applicant__c Where Id=:this.applicant.Id LIMIT 1];
               system.debug('Check applicants application'+appList[0].Application__c);
                if (!appList.isEmpty()){
                String appID = appList[0].Application__c;
                    //Get the Quote related feilds
                  qList = [SELECT Id, Months_at_Current_Employment__c, Years_at_Current_Employment__c, 
                           Income_Source__c, Occupation__c, Name, Application__c 
                           FROM 
                           Quote__c 
                           where 
                           Application__c =:appID];
               system.debug('Check quote List'+qList);
                }
                if (!qList.isEmpty()){
                    try {
                      Income__c inc = new Income__c(Applicant__c = this.applicant.Id,
                                            Months_With_Employer__c = qList[0].Months_at_Current_Employment__c,
                                            Years_With_Employer__c = qList[0].Years_at_Current_Employment__c,
                                            Income_Source__c = qList[0].Income_Source__c,
                                            Occupation__c = qList[0].Occupation__c);
                      incomeList.add(inc);  
                       system.debug('Check income after insert List'+inc); 
                     }catch (DMLException err) {
                        System.debug('###ERROR: ' + err.getMessage());
                        System.debug('###ERROR: ' + err.getLineNumber());
                        System.debug('###ERROR: ' + err.getStackTraceString());
                        ErrorHandlerException.recordException(err.getMessage(), 'APP_CommonExt', 'Income__c', 'Class', String.valueOf(this.application.Id));
                    }
                }                
           }
       }
     return incomeList;
    }

    /*  Description: retrieves map of income related to the applicant record
     *  Author: Adrian Recio
     *  Date Created: FEB-19-2014
     *  Input: None
     *  Return: Map<Id,Income__c>
     */
    @TestVisible protected Map < Id, Income__c > retrieveIncomeMap(Id applicantId) {
        Map < Id, Income__c > incomeMap = new Map < Id, Income__c > ();
        if (applicantId != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Income__c.FieldSets.Income_Commons.getFields(), 'Income__c', 'Applicant__c', applicantId)) {
                Income__c iVar = (Income__c) o;
                incomeMap.put(iVar.Id, iVar);
            }
        }
        return incomeMap;
    }

    /*  Description: retrieves lists of Asset related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Asset__c>
     */
    @TestVisible protected List < Asset__c > retrieveAssetList(Id applicantId) {
        List < Asset__c > assetList = new List < Asset__c > ();
        if (this.applicant.Id != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Asset__c.FieldSets.Asset_Commons.getFields(), 'Asset__c', 'Applicant__c', applicantId)) {
                assetList.add((Asset__c) o);
            }
        }
        return assetList;
    }

    /*  Description: retrieves lists of Expense related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Expense__c>
     */
    @TestVisible protected List < Expense__c > retrieveExpenseList(Id applicantId) {
        List < Expense__c > expenseList = new List < Expense__c > ();
        if (this.applicant.Id != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Expense__c.FieldSets.Expense_Commons.getFields(), 'Expense__c', 'Applicant__c', applicantId)) {
                expenseList.add((Expense__c) o);
            }
        }
        return expenseList;
    }

    /*  Description: retrieves list of Expense related to both applicant records
     *  Author: Mike Lasala
     *  Date Created: FEB-05-2014
     *  Input: None
     *  Return: List<Expense__c>
     */
    @TestVisible protected List < Expense__c > retrieveAllExpenses(Set < Id > applicantIds) {
        List < Expense__c > expenseList = new List < Expense__c > ();
        if (!applicantIds.isEmpty()) {
            for (sObject o: queryAllRelatedRecords(SObjectType.Expense__c.FieldSets.Expense_Commons.getFields(), 'Expense__c', 'Applicant__c', applicantIds)) {
                expenseList.add((Expense__c) o);
            }
        }
        return expenseList;
    }

    /*  Description: retrieves lists of Liability related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Liability__c>
     */
    @TestVisible protected List < Liability__c > retrieveDebtList(Id applicantId) {
        List < Liability__c > debtList = new List < Liability__c > ();
        if (this.applicant.Id != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Liability__c.FieldSets.Liability_Commons.getFields(), 'Liability__c', 'Applicant__c', applicantId)) {
                debtList.add((Liability__c) o);
            }
        }
        return debtList;
    }

    /*  Description: retrieves lists of Loan Purpose related to the application record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Loan_Purpose__c>
     */
    @TestVisible protected List < Loan_Purpose__c > retrieveLoanPurposeList() {
        List < Loan_Purpose__c > loanPurposeList = new List < Loan_Purpose__c > ();
        if (this.application.Id != null) {
            String query = 'SELECT ';
            for (Schema.FieldSetMember f: SObjectType.Loan_Purpose__c.FieldSets.Loan_Purpose_Commons.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.subString(0, query.length() - 1); //trim last comma
            query += ' FROM Loan_Purpose__c WHERE Application__c =\'' + application.Id + '\'ORDER BY Id ASC';
            System.debug('###query: ' + query);
            loanPurposeList = Database.query(query);
        }
        return loanPurposeList;
    }

    /* Description: retrieves list of Disbursement records realted to the application record
     *  Author: Mat Isidro
     *  Date Created: March 19, 2014
     *  Input: None
     *  Return: List<Disbursement__c>
     */
    @TestVisible protected List < Disbursement__c > retrieveDisbursementList() {
        List < Disbursement__c > disbursementList = new List < Disbursement__c > ();
        if (this.application != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Disbursement__c.FieldSets.Disbursement_Commons.getFields(), 'Disbursement__c', 'Application__c', this.application.Id)) {
                disbursementList.add((Disbursement__c) o);
            }
        }
        return disbursementList;
    }

    /*  Description: retrieves list of Disbursement records related to the application record
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input: None
     *  Return: List<Disbursement__c>
     */
    @TestVisible protected List < Disbursement__c > retrieveRefinanceDisbursementList() {
        List < Disbursement__c > disbursementList = new List < Disbursement__c > ();
        if (this.application != null) {
            for (sObject o: [Select Id, Principal_Amount__c, Penalty_Interest_Due__c, Payout_Effective_Date__c,
                    Late_Fees_Due__c, Interest_Due__c, Insurance_Rebate__c, Fees_or_Charges_Due__c, Early_Termination_Fee__c,
                    Disbursement_Outcome__c, Disbursement_Account_Type__c, Charge_Off_Amount__c, Bank_Acc_No__c, Loan_Purpose__c, Interest_Rate__c, Payee__c, Applicable_Party__c
                    From Disbursement__c
                    where Application__c = : this.application.Id
                    and Record_Type_Name__c in ('Refinance', 'Re-Finance')
                ]) {

                disbursementList.add((Disbursement__c) o);
            }
        }
        return disbursementList;
    }

    /*  Description: retrieves lists of AML records related to the application
     *  Author: Dan Crisologo
     *  Date Created: DEC-19-2013
     *  Input: applicantId
     *  Return: List<AML__c>
     */
    @TestVisible protected List < AML__c > retrieveAMLList(Id applicantId) {
        List < AML__c > amlList = new List < AML__c > ();
        if (applicantId != null) {
            for (sObject o: queryRelatedRecords(SObjectType.AML__c.FieldSets.AML_Commons.getFields(), 'AML__c', 'Applicant__c', applicantId)) {
                amlList.add((AML__c) o);
            }
        }
        return amlList;
    }

    /*  Description: retrieves lists of Related Documents 
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Related_Document__c>
     */
    @TestVisible protected List < Related_Document__c > retrieveRelatedDocuments(Id applicantId) {
        List < Related_Document__c > documentList = new List < Related_Document__c > ();
        if (applicantId != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Related_Document__c.FieldSets.Income_Document_Commons.getFields(), 'Related_Document__c', 'Applicant__c', applicantId)) {
                documentList.add((Related_Document__c) o);
            }
        }
        return documentList;
    }

    /*  Description: retrieves lists of Direct Debit records related to the Application with specified recodtype
     *  Author: Mike Lasala
     *  Date Created: FEB-04-2014
     *  Input: None
     *  Return: Debit
     */
    @TestVisible protected List < Debit__c > retrieveDirectDebit(Id applicantionId, Id recordTypeId) {
        List < Debit__c > debitList = new List < Debit__c > ();
        if (applicantionId != null) {
            for (sObject o: queryRelatedRecordsWithRecordType(SObjectType.Debit__c.FieldSets.Direct_Debit_Commons.getFields(), 'Debit__c', 'Application__c', applicantionId, recordTypeId)) {
                debitList.add((Debit__c) o);
            }
        }
        return debitList;
    }

    /*  Description: retrieves all lists of Direct Debit records related to the Application
     *  Author: Mike Lasala
     *  Date Created: FEB-04-2014
     *  Input: None
     *  Return: Debit
     */
    @TestVisible protected List < Debit__c > retrieveAllDirectDebit(Id applicantionId) {
        List < Debit__c > debitList = new List < Debit__c > ();
        if (applicantionId != null) {
            for (sObject o: queryRelatedRecords(SObjectType.Debit__c.FieldSets.Direct_Debit_Commons.getFields(), 'Debit__c', 'Application__c', applicantionId)) {
                debitList.add((Debit__c) o);
            }
        }
        return debitList;
    }

    /*  Description: retrieves the ProductItem related to the Application
     *  Author: Mac Domingo
     *  Date Created: OCT-22-2013
     *  Input: None
     *  Return: Product Item
     */
    @TestVisible protected Product_Item__c retrieveProductItem(String applicationId) {
        return (Product_Item__c) querySingleRelatedRecord(SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields(), 'Product_Item__c', 'Application__c', applicationId);
    }

    /*  Description: retrieves all the ProductItem related to the Application
     *  Author: Dan Crisologo
     *  Date Created: Nov-7-2013
     *  Input: None
     *  Return: List<Product Item>
     */
    @TestVisible protected List < Product_Item__c > retrieveAllProductItems(String applicationId) {

        String query = 'SELECT ';
        for (Schema.FieldSetMember f: SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,Product_Version__r.GEProduct__c, Product_Version__r.GEProduct__r.Insurance_Type__c FROM Product_Item__c where Application__c =: applicationId and Product_Version__c != null';
        return Database.query(query);

    }

    /*  Description: retrieves the ProductVersion related to the Product Item
     *  Author: Mac Domingo
     *  Date Created: OCT-22-2013
     *  Input: None
     *  Return: Product Item
     */
    @TestVisible protected Product_Version__c retrieveProductVersion(String productId) {
        return (Product_Version__c) querySingleRecord(SObjectType.Product_Version__c.FieldSets.Product_Version_Commons.getFields(), 'Product_Version__c', 'productId');
    }

    @TestVisible protected Boolean isStandardUser() {
        String cust = ApexPages.currentPage().getParameters().get('cust');
        if (cust != null && cust.toUpperCase() == 'y')
            return true;
        Boolean renderHeaderFooter = true;
        String uType = UserInfo.getUserType();
        if (uType == 'Standard') {
            renderHeaderFooter = false;
        }
        return renderHeaderFooter;
    }

    /*  Description: retrieves the Profile Name of the Current User
     *  Author: Mac Domingo
     *  Date Created: Nov-22-2013
     *  Input: None
     *  Return: Boolean
     */
    @TestVisible protected Boolean isJoint() {
        Boolean joint;
        joint = this.application.Application_Type__c == 'Joint' ? true : false;
        return joint;
    }

    /*  Description: generic method to query a single record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: sObject
     */
    @TestVisible private sObject querySingleRecord(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String recordId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE Id=:recordId';
        return Database.query(query);
    }

    /*  Description: generic method to query a single record with record type
     *  Author: Mike Lasala
     *  Date Created: FEB-04-2014
     *  Input: None
     *  Return: sObject
     */
    @TestVisible private sObject querySingleRecordWithRecordType(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String recordId, String recordTypeId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE Id=:recordId AND RecordTypeId =: recordTypeId';
        return Database.query(query);
    }

    @TestVisible private sObject querySingleRelatedRecord(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String recordId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + '=:recordId';
        return Database.query(query);
    }

    /*  Description: generic method to query related records of a single object record id from a single object
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: fieldSetMembers -
               objectName -
               parentObjectFieldName -
               recordId -
     *  Return: sObject 
     */
    @TestVisible private List < sObject > queryRelatedRecords(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate ASC';
        System.debug('###query: ' + query);
        return Database.query(query);
    }

    @TestVisible private List < sObject > queryAllRelatedRecords(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, Set < Id > parentRecordIds) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' IN: parentRecordIds ORDER BY CreatedDate ASC';
        return Database.query(query);
    }

    /*  Description: generic method to query a related records with record type
     *  Author: Mike Lasala
     *  Date Created: FEB-04-2014
     *  Input: None
     *  Return: sObject
     */
    @TestVisible private List < sObject > queryRelatedRecordsWithRecordType(List < Schema.FieldSetMember > fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId, String recordTypeId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f: fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + '=:parentRecordId AND RecordTypeId =: recordTypeId ORDER BY CreatedDate ASC';
        return Database.query(query);
    }

    @TestVisible protected String getRequestedName() {
            String requestedName = '';
            if (!isCustomer()) {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c;
            } else {
                requestedName = Web_Service_Settings__c.getValues('Requested Name Customer').Value__c;
            }
            return requestedName;
        }
        /*  Description: Address flag Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > PostalOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('Yes', 'Yes'));
            options.add(new SelectOption('No', 'No'));
            return options;
        }
        set;
    }

    /*  Description: EDIEV Picklist values
     *  Author: Mike Lasala
     *  Date Created: DEC-04-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > identityOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('Yes', 'Yes'));
                options.add(new SelectOption('No', 'No'));
                return options;
            }
            set;
        }
        /*  Description: BirthDate Field Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
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
    Public List < SelectOption > getDateOptions2() {
        List < SelectOption > options = new List < SelectOption > ();
        Integer dateNum = 31;
        options.add(new SelectOption('Select', 'Select'));
        if (Util.nullCheck(birthMonth2)) {  //05.14.15 Mike Lasala: Code Scan fix
            if (birthMonth2 == '02') {
                dateNum = 29;
            }
            if (birthMonth2 == '01' || birthMonth2 == '03' || birthMonth2 == '05' || birthMonth2 == '07' || birthMonth2 == '08' || birthMonth2 == '10' || birthMonth2 == '12') {
                dateNum = 31;
            }
            if (birthMonth2 == '04' || birthMonth2 == '06' || birthMonth2 == '09' || birthMonth2 == '11') {
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

    /*  Description: Relationship status Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    Public List < SelectOption > relationshipStatusOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('Please Select', 'Please Select'));
                Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
                fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
                List < Schema.PicklistEntry > pickList = fieldMap.get('Rel_Status__c').getDescribe().getPickListValues();

                for (Schema.PicklistEntry pickvar: pickList) {
                    if(String.valueOf(pickVar.getValue()) == 'Seperated' && 
                       brandCountry == GEN_OriginationsConstants.NZ_REGION){

                        //Empty condition so as not to add picklistentry
                        
                    } else if(String.valueOf(pickVar.getValue()) == 'Separated' && 
                       brandCountry == GEN_OriginationsConstants.AU_REGION){

                        //Empty condition so as not to add picklistentry

                    } else{
                        options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
                    }
                }
                return options;
            }
            set;
        }
        /*  Description: Years at address Field Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    Public List < SelectOption > yearAtAddressOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('0', 'Years'));
                for (Integer i = 0; i <= 9; i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
                options.add(new SelectOption('10', 'More than 9 years'));
                return options;
            }
            set;
        }
        /*  Description: Months at address Field Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > monthsAtAddressOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('', 'Months')); // Defect 467 - Afreen , made the value as ' ' for Months as it was required for performing the validation.
                for (Integer i = 0; i <= 11; i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
                return options;
            }
            set;
        }
        /*  Description: Residential Status Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > residentialStatusOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('Please Select', 'Please Select'));
                Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
                fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
                List < Schema.PicklistEntry > pickList = fieldMap.get('Res_Status__c').getDescribe().getPickListValues();

                for (Schema.PicklistEntry pickvar: pickList) {
                    options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
                }
                return options;
            }
            set;
        }
        /*  Description: Preffered Contact Method Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > preferredContactMethodOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Select'));
            Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
            fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
            List < Schema.PicklistEntry > pickList = fieldMap.get('Pref_Contact_Method__c').getDescribe().getPickListValues();

            for (Schema.PicklistEntry pickvar: pickList) {
                options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
            }
            return options;
        }
        set;
    }


    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > titleOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();

                Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
                fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
                List < Schema.PicklistEntry > pickList = fieldMap.get('Title__c').getDescribe().getPickListValues();

                options.add(new SelectOption('Select', 'Select'));

                for (Schema.PicklistEntry pickvar: pickList) {
                    options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
                }
                return options;
            }
            set;
        }
        /*  Description: BirthMonths Field Picklist values
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
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
        /*  Description: Gender Field Picklist values
         *  Author: Mike Lasala
         *  Date Created: NOV-11-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > genderOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();

                Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
                fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
                List < Schema.PicklistEntry > pickList = fieldMap.get('Gender__c').getDescribe().getPickListValues();

                options.add(new SelectOption('', 'Select'));

                for (Schema.PicklistEntry pickvar: pickList) {
                    options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
                }
                return options;
            }
            set;
        }
        /*  Description: Setting Date Options when selecting month
         *  Author: Russell Cadapan
         *  Date Created: SEPT-24-2013
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public void setDate() {
        getDateOptions();
        getDateOptions2();
    }

    /*  Description: Sets current application record out-of-sync to true
     *  Author: Dan Crisologo
     *  Date Created: 01-15-14
     *  Input Parameters: None
     *  Return: none
     */
    protected void updateAndSetApplicationOutOfSync(Application__c appParam) {
        //ensure that application is not null and is already inserted
        if (appParam != null) {
            if (appParam.id != null) {
                appParam.Out_Of_Sync__c = true;
                if (bankAccountHeld != '' && bankAccountHeld != null) {
                    appParam.Bank_Accounts_Held__c = bankAccountHeld;
                }
                try {
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Application__c.SObjectType.getDescribe().isCreateable()) {
                        upsert appParam;
                    //}
                    APP_CommonVariables.setApplication(appParam); //set the static again
                } catch (Exception e) {
                    throw e;
                }
            }
        }
    }

    /*  Description: Sets rollback and error handler exception
     *  Author: Mike Lasala
     *  Date Created: 01-17-14
     *  Input Parameters: SavePoint, Class Name, Object, Class
     *  Return: none
     */
    @TestVisible protected void setRollbackAndErrorHandler(SavePoint sp, String exceptionMessage, String className, String obj, String clss, String appId) {
        ErrorHandlerException.recordException(exceptionMessage, className, obj, clss, appId);
        if (sp != null) {
            Database.rollback(sp); //rollback if an exception occured
        }
    }

    /*  Description: Street Type Picklist values
     *  Author: Russell Cadapan
     *  Date Created: JAN-20-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > getStreetTypeOptions() {
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
            List < Street_Type_Setting__c > streetTypeSetting = [SELECT Value_Abbreviated__c, Value_Abbreviated_NZ__c, Value__c, Region__c FROM Street_Type_Setting__C ORDER BY Value__c]; //changed by Tony Xu, NZ street type abbreviation different with AU street type abbreviation
            for (Street_Type_Setting__c sts: streetTypeSetting) {
                if (brandCountry != null) { //Added by Tony Xu
                    if (brandCountry == 'NZ' && (sts.Region__c.trim() == 'Both' || sts.Region__c.trim() == 'NZ')) {
                        options.add(new SelectOption(sts.Value_Abbreviated_NZ__c, sts.Value__c)); //changed by Tony Xu, NZ street type abbreviation different with AU street type abbreviation
                    }
                    if (brandCountry == 'AU' && (sts.Region__c.trim() == 'Both' || sts.Region__c.trim() == 'AU')) {
                        options.add(new SelectOption(sts.Value_Abbreviated__c, sts.Value__c));
                    }
                }

            }
            return options;
        }

        /*  Description: State Picklist values
         *  Author: Russell Cadapan
         *  Date Created: JAN-20-2014
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > stateOptions {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('', 'Please Select'));
                List < State_Setting__c > StateSetting = [SELECT Value__c FROM State_Setting__c ORDER BY Value__c];

                for (State_Setting__c st: StateSetting) {
                    options.add(new SelectOption(st.Value__c, st.Value__c));
                }
                return options;
            }
            set;
        }
        /*  Description: Country Picklist values
         *  Author: Russell Cadapan
         *  Date Created: FEB-06-2014
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > countryOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();

            String australia = Country_Setting__c.getInstance('Australia').Country_Name__c;
            String newZed = Country_Setting__c.getInstance('New Zealand').Country_Name__c;
            options.add(new SelectOption('', 'Please Select'));
            options.add(new SelectOption(australia, australia));
            options.add(new SelectOption(newZed, newZed));
            List < Country_Setting__c > countrySetting = [SELECT id, Name, Country_Name__c, ISO__c FROM Country_Setting__c ORDER BY Country_Name__c];


            for (Country_Setting__c ct: countrySetting) {
                if (ct.Name != australia && ct.Name != newZed) {
                    options.add(new SelectOption(ct.Country_Name__c, ct.Country_Name__c));
                }
            }
            return options;
        }
        set;
    }

    /*  Description: State Picklist values
     *  Author: Mac Domingo
     *  Date Created: APR-22-2014
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > getCountryOpts() {
        system.debug('brand country : ' + brandCountry);
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', 'Please Select'));
        if (brandCountry == 'NZ') {
            options.add(new SelectOption('New Zealand', 'New Zealand'));
        } else {
            options.add(new SelectOption('Australia', 'Australia'));
        }
        return options;
    }

    /*  Description: Method to get Frequncy Repayment without Service Fee.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getRepaymentWithFrequency(Application__c application, String Frequency) {

        Decimal frqcyRepayment = 0;
        if (Frequency == 'Weekly') {
            frqcyRepayment = (application.Offered_Repayments__c / 4);
        } else if (Frequency == 'Fortnightly') {
            frqcyRepayment = (application.Offered_Repayments__c / 2);
        } else {
            frqcyRepayment = application.Offered_Repayments__c;
        }
        return frqcyRepayment;
    }

    /*  Description: Method to navigate from a page to another used by the Customer UI Tiles
     *  Author: Russell Cadapan
     *  Parameters: callingPage - String value of the page where the redirect will be coming from
     *              destinationPage - String value the tile where will the redirect will go
     *  Return: pageReference
     */
    Public PageReference pageNavigation() {
            PageReference pageRef;

            if (callingPage.equals(destinationPage)) {
                return null;
            } else {
                if (destinationPage == GEN_OriginationsConstants.PAGE_ELIGIBILITY) {
                    pageRef = Page.APP_Eligibility;
                } else if (destinationPage == GEN_OriginationsConstants.PAGE_INCOME) {
                    pageRef = Page.APP_JointIncome;
                } else if (destinationPage == GEN_OriginationsConstants.PAGE_ASSET) {
                    pageRef = Page.APP_JointAssets;
                } else if (destinationPage == GEN_OriginationsConstants.PAGE_DEBT) {
                    pageRef = Page.APP_JointDebtAndLiabilities;
                } else if (destinationPage == GEN_OriginationsConstants.PAGE_EXPENSE) {
                    pageRef = Page.APP_JointExpenses;
                } else if (destinationPage == GEN_OriginationsConstants.PAGE_ABOUTME) {
                    pageRef = Page.APP_JointPersonalDetails;
                }
                pageRef.getParameters().put('Id', this.application.Id);

            }
            pageRef.setRedirect(true);
            return pageRef;
        }
        /*  Description: Employment status picklist values
         *  Author: Russell Cadapan
         *  Date Created: FEB-13-2014
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > employmentStatusOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();

            Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
            fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
            List < Schema.PicklistEntry > pickList = fieldMap.get('Primary_Employment_Status__c').getDescribe().getPickListValues();

            options.add(new SelectOption('None', 'Please Select'));

            for (Schema.PicklistEntry pickvar: pickList) {
                options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
            }
            return options;
        }
        set;
    }

    /*  Description: Previous Employment status picklist values
     *  Author: Adrian Recio
     *  Date Created: FEB-17-2014
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > preEmploymentStatusOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();

            Map < String, Schema.SObjectField > fieldMap = new Map < String, Schema.SObjectField > ();
            fieldMap = Schema.SObjectType.Applicant__c.fields.getMap();
            List < Schema.PicklistEntry > pickList = fieldMap.get('Previous_Employment_Status__c').getDescribe().getPickListValues();

            options.add(new SelectOption('', 'Please Select'));

            for (Schema.PicklistEntry pickvar: pickList) {
                options.add(new SelectOption(String.valueOf(pickVar.getValue()), String.valueOf(pickVar.getLabel())));
            }
            return options;
        }
        set;
    }

    /*
     * @Description: Validation to check if application is new
     * @Author: Adrian Recio
     * @Date Created: MAR-21-2014
     */
    public Boolean applicationIsSubmitted(Application__c appVar) {
        if (appVar.Status__c != 'New') {
            return true;
        }
        return false;
    }

    /*  Description: Validate Application
     *  Author: Adrian Recio
     *  Input Parameters: None
     *  Return: PageReference
     */
    public pageReference validateApply() {
        Boolean appStepStatus = UserUtility.checkApplicationStatus(application.Id);

        if (application.Status__c != 'New') {
            Util.addMessage(ApexPages.Severity.ERROR, 'Sorry this application has already been submitted and the application details are not editable.');
        } else if (appStepStatus == false) {
            Util.addMessage(ApexPages.Severity.ERROR, 'Please complete all steps required before submitting application.');
        } else {
            //Added by Mike (4/4/14) for fingerprint update
            application.FP_IP_Address__c = getIPAddress();
            application.FP_Black_Box__c = blackBox;
            application.Fingerprint_Step__c = GEN_OriginationsConstants.IOVATION_FINGERPRINT_STEP;

            if (this.application.FP_IP_Address__c == null ||
                this.application.FP_IP_Address__c == '' ||
                this.application.FP_IP_Address__c == 'ERR1') {

                this.application.FP_IP_Address__c = 'ERR1';
            }

            if (this.application.Brand_Lookup__c != null) {
                // June 29, 2016- Afreen - Added the field iOvation_Type_3rd_Party__c
                Brand__c appBrand = [SELECT iOvation_Type_Online__c, iOvation_Type_3rd_Party__c  
                    FROM Brand__c
                    WHERE Id = : this.application.Brand_Lookup__c
                ];

                 // June 29, 2016- Afreen - assign the iovation type based on the channel
                if(this.application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_3RD_PARTY){
                    this.application.iOvation_Type__c = appBrand.iOvation_Type_3rd_Party__c;
                }else{
                    this.application.iOvation_Type__c = appBrand.iOvation_Type_Online__c;
                }
            }
            
            //MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
            this.application.Initial_Requested_Amount__c = this.application.Total_Loan_Amount__c;
            
            try {
                update application;
            } catch (DMLException e) {
                ErrorHandlerException.recordException(e.getMessage(), 'APP_CommonExt', 'Application__c', 'Class', String.valueOf(application.Id));
            }

            //BEGIN MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT
            //String requestedName = getRequestedName();
            //List < IS_ValidationError > validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(this.application.id, Util.getUser().Mock_Enable__c, requestedName, null);
            //PageReference ref = Page.APP_SubmitWait;
            //ref.getParameters().put('id', String.valueOf(application.Id));
            //ref.setRedirect(true);
            //return ref;
            //END MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT
        }
        return null;
    }
    //BEGIN MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT
    /* 
    *  Description: Method to move async to sync calls SUBMIT
    *  Author: Michael Lasala
    *  Input Parameters: None
    *  Return: PageReference
    */
    public PageReference submitServiceCallCustomer(){
            String requestedName = getRequestedName();
           
            List < IS_ValidationError > validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(this.application.id, Util.getUser().Mock_Enable__c, requestedName, null);
            updateQuoteStatus();
            PageReference ref = Page.APP_SubmitWait;
            ref.getParameters().put('id', String.valueOf(application.Id));
            ref.setRedirect(true);
            return ref;
    }
    /**
     * Name: updateQuoteStatus
     * Description: Take the application Id in context and check if there are any Quotes linked to the Application.
     *              If there are, then change the status of that Quote to 'Converted to Application'. Else ignore and continue.
     */
    private void updateQuoteStatus(){
        Id appId = String.valueOf(application.Id);
        if(appId != null){
            List<Quote__c> quoteObjList = [SELECT Id FROM Quote__c WHERE Application__c = :appId LIMIT 1];
            if(quoteObjList.size() == 1){
                Id quoteId = quoteObjList[0].Id;
                Quote__c quoteObj = new Quote__c();
                quoteObj.Quote_Stage__c = 'Converted to Application';
                quoteObj.Converted_To_App_On__c = System.now();
                quoteObj.Id = quoteId;
                update quoteObj;
            }
        }
}
    //END MLASALA: 23-SEPT-15 - ASYNC TO SYNC CALL OUT

    /*  Description: Expose application boolean status to visualforce
     *  Author: Adrian Recio
     *  Input Parameters: None
     *  Return: Boolean
     */
    public Boolean getApplicationStatus() {
        return UserUtility.checkApplicationStatus(application.Id);
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

        ipAddress = ApexPages.currentPage().getHeaders().get('HTTP_CLIENT_IP');
        System.debug('HTTP_CLIENT_IP' + ipAddress);

        /**Comment out by TXU, value always NULL
        ipAddress = ApexPages.currentPage().getHeaders().get('X-PRS-ClientIP');
        System.debug('X-PRS-ClientIP is' + ipAddress);
        **/

        if (ipAddress == '' || ipAddress == null) {
            // get IP address when no caching (sandbox, dev, secure urls)
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            System.debug('X-Salesforce-SIP is' + ipAddress);
        }
        return ipAddress;
    }

    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
   /* public List < SelectOption > getloanTermOptions() {
        Brand__c brand;
        
        if (isCustomer()) {
            brand = [SELECT Loan_Term__c,country__c FROM Brand__c WHERE Site__c = : site.getName()];
        } else {
            brand = [SELECT Loan_Term__c,country__c FROM Brand__c WHERE Id = : this.application.Brand_Lookup__c];
        }*/
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
       /* List < SelectOption > options = new List < SelectOption > ();
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
    }*/
    /*
    Description : Loan Term dependent on Product SubType Dropdown
    Author : Suneel Desiraju
    Date Created : 29/05/2019
    */
    public void getLoanTermOnProduct(){
    getloanTermOptions();
    }
     public void getProductOnLoanSelection(){
     System.debug('Success Five');
         getproductOptions();      
    }
    /* End */
    public List < SelectOption > getloanTermOptions() {
   
        List < SelectOption > options = new List < SelectOption > ();
       Brand__c brand;
               list <string> values = new list <string>();

        if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' || productSelected == 'Better Start PL' ){
// commented on 12-06-19     if(ApexPages.currentPage().getParameters().get('subType') == 'betterStart' || productSelected == 'Better Start PL – 3mths interest free & no payment')         
       if (isCustomer()) {
        brand = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c = : site.getName()];
        } else {
        brand = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Id = : this.application.Brand_Lookup__c];
        }
       //Brand__c brand_bs = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
        
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
        options.add(new SelectOption('', 'Please Select'));
        try{
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
        }catch(Exception e){}
       
        }
        else if(productSelected == 'Standard PL' || this.application.Product_SubType__c == 'Standard PL' || this.application.Product_SubType__c == null) {
        if (isCustomer()) {
            brand = [SELECT Loan_Term__c,country__c FROM Brand__c WHERE Site__c = : site.getName()];
        } else {
            brand = [SELECT Loan_Term__c,country__c FROM Brand__c WHERE Id = : this.application.Brand_Lookup__c];
        }
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
        options.add(new SelectOption('', 'Please Select'));
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
        }else if(this.application.Product_SubType__c == 'Better Start PL'){

       if (isCustomer() || isBrokerChannel==true) {
        brand = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c = : site.getName()];
        } else {
        brand = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Id = : this.application.Brand_Lookup__c];
        }
       //Brand__c brand_bs = [SELECT Loan_Term_Better_Start__c,country__c FROM Brand__c WHERE Site__c =: site.getName()];
        
        /*Changed by: Fahad AKhtar for following defects:
            Defect # 943
            Defect # 939
            Defect # 881                        
        */
        options.add(new SelectOption('', 'Please Select'));
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
        
               }
  
        
       
        return options;
    }

    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > getloanFrequencyOptions() {
            List < SelectOption > options = new List < SelectOption > ();
            options.add(new SelectOption('', 'Please Select'));
            Schema.DescribeFieldResult fieldResult = Application__c.Payment_Frequency__c.getDescribe();
            List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry p: ple) {
                options.add(new SelectOption(p.getValue(), p.getValue()));
            }
            return options;
        }
        /*  Description: Add new Loan Purpose record
         *  Author: Fel Saliba
         *  Date Created: SEPT-25-2013
         *  Input Parameters: None
         *  Return: void
         */
    public void addLoanPurpose() {
            loanWrapList.add(new loanWrapper());
            loanPurposeSize++;
            calculateLoanAmountTotal();
            refreshLoanCount();
        }
        /*  Description: Remove Loan Purpose record
         *  Author: Fel Saliba
         *  Date Created: SEPT-25-2013
         *  Input Parameters: None
         *  Return: void
         */
    public void removeLoanPurpose() {
            if (loanWrapList.get(loanWrapList.size() - 1).loan.Id != null) {
                Loan_Purpose__c lpToDelete = new Loan_Purpose__c();
                lpToDelete.Id = loanWrapList.get(loanWrapList.size() - 1).loan.Id;
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Loan_Purpose__c.sObjectType.getDescribe().isDeletable()){
                    delete lpToDelete;
                }
                */
                delete lpToDelete;
            }
            loanWrapList.remove(loanWrapList.size() - 1);
            loanPurposeSize--;
            calculateLoanAmountTotal();
        }
        /*  Description: Calculate the Total Loan Amount
         *  Author: Jan Mark Domingo
         *  Date Created: OCT-1-2013
         *  Input Parameters: None
         *  Return: void
         */
    public void calculateLoanAmountTotal() {
        totAmount = 0;
        System.debug('IN THE MAIN AMOUNT XXX');
        if (loanWrapList != null) {
            for (loanWrapper lp: loanWrapList) {
                if (lp.loan.Loan_Amount__c != null) {
                    totAmount += lp.loan.Loan_Amount__c;
                    System.debug('AFTER THE totAmount XXX '+totAmount);
                }
            }
        }
    }

    /*  Description: Refresh rowCount of wrapper lists
     *  Author: Mike Lasala
     *  Date Created: JAN-14-2014
     *  Input Parameters: None
     *  Return: void
     */
    public void refreshLoanCount() {
            Integer i = 0;
            for (loanWrapper loa: loanWrapList) {
                loa.rowCount = i;
                i++;
            }
            loanPurposeSize = loanWrapList.size();
            
            System.debug('!@#NEW LOAN AMOUNT SIZE: ' + loanPurposeSize);
        }
        /*  Description: Validate Loan Fields throughout other pages that extends this class
         *  Author: Russell Cadapan
         *  Input Parameters: None
         *  Return: PageReference
         */
    public void initializeLoanPurposes() {
            totAmount = 0;
            loanWrapList = new List < loanWrapper > ();
            loanValidationResults = false;
            List < Loan_Purpose__c > temporaryLoanPurposeList = new List < Loan_Purpose__c > ();
            temporaryLoanPurposeList = retrieveLoanPurposeList();
            if (!temporaryLoanPurposeList.isEmpty()) {
                loanTermSelected = application.loan_term__c;
                productSelected = application.Product_SubType__c;
                for (Loan_Purpose__c lp: temporaryLoanPurposeList) {
                    loanWrapper lw = new loanWrapper();
                    lw.loan = lp;
                    this.loanWrapList.add(lw);
                    if (lp.Loan_Amount__c != null) {
                        totAmount += lp.Loan_Amount__c;
                    }
                }
                loanPurposeSize = temporaryLoanPurposeList.size();
                loanValidationResults = true;
            } else {
                loanWrapList = new List < loanWrapper > ();
                loanPurposeSize = 0;
                addLoanPurpose();
            }
        }
        /*  Description: Save Loan Purpose records throughout other pages that extends this class
         *  Author: Russell Cadapan
         *  Input Parameters: None
         *  Return: void
         */
    public void saveLoanPurposes() {
            List < Loan_Purpose__c > loanList = new List < Loan_Purpose__c > ();
            Id onrId = parentONRId(this.application.Id);

            for (loanWrapper lp: loanWrapList) {
                if (lp.loan.Application__c == null) {
                    lp.setLoanApplicationAndONR(this.application.Id, onrId);
                }
                loanList.add(lp.loan);
            }
            //Below line commented for Better Start -- Added by Suneel - 21/05/2019
            //application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0]) * 12;
             /*  Description: Loan Term conditions for Better Start PL
                 *  Author: Suneel
                 *  Input Parameters: None
                 *  Return: void
                 */
            if(ApexPages.currentPage().getParameters().get('subType')=='betterStart'){
                this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
                this.application.Loan_Term__c = loanTermSelected;
                //Decimal month = Decimal.valueOf(loanTermSelected.substring(9,loanTermSelected.length()-8));
                //this.application.Loan_Term_Months__c += month;
            }else 
                if((ApexPages.currentPage().getParameters().get('form')=='broker') && this.application.Product_SubType__c == 'Better Start PL'){
                this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
                this.application.Loan_Term__c = loanTermSelected;
                //Decimal month = Decimal.valueOf(loanTermSelected.substring(9,loanTermSelected.length()-8));
                //this.application.Loan_Term_Months__c += month;
                this.application.Product_SubType__c = productSelected;
            }
            else 
                if(this.application.Product_SubType__c == 'Better Start PL'){
                this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
                this.application.Loan_Term__c = loanTermSelected;
                //Decimal month = Decimal.valueOf(loanTermSelected.substring(9,loanTermSelected.length()-8));
                //this.application.Loan_Term_Months__c += month;
            }else{
                this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*
                    (loanTermSelected.ToLowerCase().contains('months')?1:12);
                this.application.Loan_Term__c = loanTermSelected;
            }
            
            //Below code added for Threatmatrix to pass the web session id to downstreams
            sessionId =UserInfo.getSessionId();
            this.application.User_Session_ID__c = sessionId;
            
                isBetterStart = false;
            this.application.Product_SubType__c = productSelected;           
            if(ApexPages.currentPage().getParameters().get('subType')=='betterStart'  || productSelected == 'Better Start PL'){
            isBetterStart = true;
            this.application.Product_SubType__c = 'Better Start PL';
            }
           /* Id appId= ApexPages.currentPage().getParameters().get('Id');
            List<Loan_Purpose__c> loanPurpose = [select Value__c from Loan_Purpose__c where Application__r.Id =:appId];
            for(Loan_Purpose__c loanp : loanPurpose){
               if(ApexPages.currentPage().getParameters().get('form') == 'broker' && totAmount >= 20000 && loanp.value__c == 'Debt consolidation'){
            isBetterStart = true;
            this.application.Product_SubType__c = 'Better Start PL';
            }        
            }   */
            /* commented by Arshad for turning on/off Better Start features and adding the below code. 
            if(isBetterStart == false){
            this.application.Product_SubType__c = 'Standard PL';
            } */
            if(isBetterStart == false){
            Better_Start_Offer__c bsoffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
                if(this.application.Brand_Country__c == 'AU' && bsOffer.BetterStartAUActive__c == true){
                    this.application.Product_SubType__c = 'Standard PL';
                }else if (this.application.Brand_Country__c == 'NZ' && bsOffer.BetterStartNZActive__c == true){
                    this.application.Product_SubType__c = 'Standard PL';
                }
           }

            application.Total_Loan_Amount__c = totAmount;
            //if form is equal to broker,totamt more than or equal to 20000 and loan purpose is debt consolidation
           /* if(ApexPages.currentPage().getParameters().get('form')=='broker' && totAmount >= 20000){            
            this.application.Product_SubType__c = 'Better Start PL';
            }*/
            
            if (!loanList.isEmpty()) {
                try {
                    //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Loan_Purpose__c.SObjectType.getDescribe().isCreateable()) {
                        upsert loanList;
                    //}
                } catch (DMLException err) {
                    System.debug('###ERROR: ' + err.getMessage());
                    System.debug('###ERROR: ' + err.getLineNumber());
                    System.debug('###ERROR: ' + err.getStackTraceString());
                    ErrorHandlerException.recordException(err.getMessage(), 'APP_CommonExt', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));
                }

                try {
                    update application;
                } catch (DMLException err) {
                    System.debug('###ERROR: ' + err.getMessage());
                    System.debug('###ERROR: ' + err.getLineNumber());
                    System.debug('###ERROR: ' + err.getStackTraceString());
                    ErrorHandlerException.recordException(err.getMessage(), 'APP_CommonExt', 'Loan_Purpose__c', 'Class', String.valueOf(application.Id));
                }
            }
        }
        /*  Description: Retrieve/Create parentONR Id
         *  Author: Mike Lasala
         *  Date Created: JAN-24-2014
         *  Input Parameters: application Id
         *  Return: Id
         */
    public Id parentONRId(Id appId) {
            ONR__c parentONR;

            List < ONR__c > onrList = [SELECT Id
                FROM ONR__c
                WHERE Type__c = : GEN_OriginationsConstants.ONR_TYPE_TABLE
                AND recordType.Name = : GEN_OriginationsConstants.ONR_GENERAL
                AND Application__c = : appId
                LIMIT 1
            ];

            if (onrList.size() < 1) {
                //create new onr based on meta onr if there is no existing ONR yet
                List < Meta_ONR__c > metaONR = [SELECT GeId__c
                    FROM Meta_onr__c
                    WHERE Type__c = : GEN_OriginationsConstants.ONR_TYPE_TABLE
                    AND Onr_type__c = : GEN_OriginationsConstants.ONR_GENERAL
                ];

                Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c;
                Map < String, Schema.RecordTypeInfo > onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
                Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();

                if (!metaONR.isEmpty()) {
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
        /*  Description: Validate Loan Fields throughout other pages that extends this class
         *  Author: Russell Cadapan
         *  Input Parameters: None
         *  Return: PageReference
         */
    public void validateLoanFields() {
        totAmount = 0;
        loanTermNotValid = false;
        paymentNotValid = false;
        loanAmountNotValid = false;
        loanValidationResults = true;

        calculateLoanAmountTotal();
        if (loanTermSelected == null || loanTermSelected == 'None') {
            loanTermNotValid = true;
            loanValidationResults = false;
        }

        //Start - UPDATED RCADAPAN 08-MAR-2016 for TQLQW-29 - Reduce Total Loan Amount to 2 Grand for NZ Applications
        validLPAmount = GEN_OriginationsConstants.AU_VALID_LOAN_TOTAL_AMOUNT;
        if(this.application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
            validLPAmount = GEN_OriginationsConstants.NZ_VALID_LOAN_TOTAL_AMOUNT;
        }
        if (totAmount < validLPAmount) {
            loanAmountNotValid = true;
            loanValidationResults = false;
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
        //END TQLQW-29
        
        for (loanWrapper lp: loanWrapList) {
            if (lp.Loan.Value__c == 'Please Select') {
                lp.loanPurposeNotValid = true;
                loanValidationResults = false;
            }
            if (lp.loan.Loan_Amount__c == null || lp.loan.Loan_Amount__c == 0 || lp.loan.Loan_Amount__c < 0) {
                lp.amtNotValid = true;
                loanValidationResults = false;
            }
            if (lp.Loan.Value__c == 'Other' && (lp.Loan.Other_Loan_Purpose__c == '' || lp.Loan.Other_Loan_Purpose__c == null)) {
                lp.loanPurNotValid = true;
                loanValidationResults = false;
            }
        }

        if (loanValidationResults) {
            saveLoanPurposes();
        }
    }

    /*  Description: Validate postcode fields
     *  Author: Russell Cadapan
     *  Input Parameters: String - fieldValue
     *  Return: Boolean
     */
    public static Boolean isPostcodeValid(String fieldValue) {
            Boolean flag = true;

            Pattern postCodePattern = Pattern.compile(GEN_OriginationsConstants.patternPhone);
            Matcher postCodeMatcher = postCodePattern.matcher(fieldValue.trim());

            if (fieldValue.length() < 4 || fieldValue.length() > 4) {
                flag = false;
            } else {
                if (!postCodeMatcher.matches()) {
                    flag = false;
                }
            }
            return flag;
        }
        /** Code updated for  DBHZL-81 story  -BEGIN**/
        //Method to create/update AMLs based on parameter passed to it
    public AML__c createAMLs(personalDetailsWrapper applicantWrapper, ID id, String type) {
        System.debug('ID:' + Id + 'TYPE:' + type);
        AML__c aml;
        Date issueDate = null;
        Date expiryDate = null;
        Date issueDateSec = null;
        Date expiryDateSec = null;

        if (applicantwrapper.expiryYear != null && applicantwrapper.expiryYear != '' &&
            applicantwrapper.expiryMonth != null && applicantwrapper.expiryMonth != '' && applicantwrapper.expiryMonth != 'Select' &&
            applicantwrapper.expiryDate != null && applicantwrapper.expiryDate != '' && applicantwrapper.expiryDate != 'Select')
            expiryDate = date.newinstance(
                Util.stringToInteger(applicantwrapper.expiryYear),
                Util.stringToInteger(applicantwrapper.expiryMonth),
                Util.stringToInteger(applicantwrapper.expiryDate)
            );
        if (applicantwrapper.issueYear != null && applicantwrapper.issueYear != '' &&
            applicantwrapper.issueMonth != null && applicantwrapper.issueMonth != '' && applicantwrapper.issueMonth != 'Select' &&
            applicantwrapper.issueDate != null && applicantwrapper.issueDate != '' && applicantwrapper.issueDate != 'Select')
            issueDate = date.newinstance(
                Util.stringToInteger(applicantwrapper.issueYear),
                Util.stringToInteger(applicantwrapper.issueMonth),
                Util.stringToInteger(applicantwrapper.issueDate)
            );

        if (applicantwrapper.expiryYearSec != null && applicantwrapper.expiryYearSec != '' &&
            applicantwrapper.expiryMonthSec != null && applicantwrapper.expiryMonthSec != '' && applicantwrapper.expiryMonthSec != 'Select' &&
            applicantwrapper.expiryDateSec != null && applicantwrapper.expiryDateSec != '' && applicantwrapper.expiryDateSec != 'Select')
            expiryDateSec = date.newinstance(
                Util.stringToInteger(applicantwrapper.expiryYearSec),
                Util.stringToInteger(applicantwrapper.expiryMonthSec),
                Util.stringToInteger(applicantwrapper.expiryDateSec)
            );
        if (applicantwrapper.issueYearSec != null && applicantwrapper.issueYearSec != '' &&
            applicantwrapper.issueMonthSec != null && applicantwrapper.issueMonthSec != '' && applicantwrapper.issueMonthSec != 'Select' &&
            applicantwrapper.issueDateSec != null && applicantwrapper.issueDateSec != '' && applicantwrapper.issueDateSec != 'Select')
            issueDateSec = date.newinstance(
                Util.stringToInteger(applicantwrapper.issueYearSec),
                Util.stringToInteger(applicantwrapper.issueMonthSec),
                Util.stringToInteger(applicantwrapper.issueDateSec)
            );

        if (type == 'Primary') {
            aml = new AML__c(
                id = Id,
                applicant__C = applicantwrapper.applicant.id,
                Version__c = applicantwrapper.applicant.version__c,
                NZ_Residency_Number__c = applicantwrapper.applicant.NZ_Residency_Number__c,
                ID_No__c = applicantwrapper.applicant.ID_Number__c,
                Identification__c = applicantwrapper.applicant.Customer_ID_Type__c,
                ID_1__c = applicantwrapper.applicant.Customer_ID_Type__c,
                Issue_Country__c = applicantwrapper.applicant.Issuing_Country__c,
                ID_Issue_Date__c = issueDate,
                ID_Expiry_Date__c = expiryDate,
                Id_Sequence_No__c = 0,
                Type_of_Identity__c = GEN_OriginationsConstants.AML_IDENTIFICATION_TYPE
            );
        } else {
            aml = new AML__c(
                id = ID,
                applicant__C = applicantwrapper.applicant.id,
                ID_No__c = applicantwrapper.applicant.ID_No__c,
                Identification__c = applicantwrapper.applicant.ID_1__c,
                ID_2__c = applicantwrapper.applicant.ID_1__c,
                Issue_Country__c = applicantwrapper.applicant.Sec_ID_Issue_Country__c,
                ID_Issue_Date__c = applicantwrapper.applicant.Sec_ID_Issue_Date__c,
                ID_Expiry_Date__c = applicantwrapper.applicant.Sec_ID_Expiry_Date__c,
                Id_Sequence_No__c = 0,
                Type_of_Identity__c = GEN_OriginationsConstants.AML_IDENTIFICATION_TYPE
            );
        }
        return aml;
    }


    /*  Description: Applicant record to AML mapping
     *  Author: Fahad Akhtar
     *  Date Created: NOV-11-2014
     *  Input Parameters: None
     *  Return: List<AML>
     */
    public list < AMl__c > createAML(List < personalDetailsWrapper > applicantWrapperList) {

        Map < String, AML__c > identificationAML_Map = new Map < String, AML__c > ();
        List < AML__c > lst_aml = new List < AML__c > ();

        for (personalDetailsWrapper applicantwrapper: applicantWrapperList) {
            System.debug(applicantwrapper.applicant.ID + '-->' + applicantwrapper.applicant.AMLs__r.size());
            if (applicantwrapper.applicant.AMLs__r.size() > 0) {
                for (AML__c aml: applicantwrapper.applicant.AMLs__r) {

                    identificationAML_Map.put(aml.Identification__c + applicantwrapper.applicant.Id, aml);
                    System.debug('AMl-ID:' + aml.Id);
                }


            }
        }

        List<AML__c> toDeleteList = new List<AML__c>();

        System.debug('inside createAML:' + identificationAML_Map.Values());
        for (personalDetailsWrapper applicantwrapper: applicantWrapperList) {
            if (applicantwrapper.applicant.AMLs__r.size() > 0) {
                //Edit operation -Personal detail page
                System.debug('createAML-Edit:' + identificationAML_Map.keySet() + 'CID:' + applicantwrapper.applicant.ID);

                //get AML associated for primary Identification
                //If not found it means Primary AML is changed - So update  AML
                if (identificationAML_Map.get(applicantwrapper.applicant.Customer_ID_Type__c + applicantwrapper.applicant.ID) == NULL) {
                    System.debug('inside createAML-Edit-0:' + applicantwrapper.applicant.Customer_ID_Type__c + applicantwrapper.applicant.ID);
                    System.debug('inside createAML-Edit-0:' + applicantwrapper.applicant.AML__c);
                    
                    if(applicantwrapper.applicant.Customer_ID_Type__c != null){
                        lst_aml.add(createAMls(applicantwrapper, applicantwrapper.applicant.AML__c, 'Primary'));
                    } else {
                        if(applicantwrapper.applicant.AMLs__r.size() > 0){
                            for(AML__c a: applicantwrapper.applicant.AMLs__r){
                                toDeleteList.add(a);
                            }
                        }
                    }
                } else {

                    //Else update the associated AML with new information
                    System.debug('update::' + applicantwrapper.applicant.Customer_ID_Type__c + applicantwrapper.applicant.ID);
                    lst_aml.add(createAMls(applicantwrapper, identificationAML_Map.get(applicantwrapper.applicant.Customer_ID_Type__c + applicantwrapper.applicant.ID).ID, 'Primary'));
                }
                //If the change was to below 2 pickLists then create or update the same.
                if (applicantwrapper.applicant.Customer_ID_Type__c == 'NZ Birth Certificate' || applicantwrapper.applicant.Customer_ID_Type__c == 'NZ Certificate of Citizenship') {
                    System.debug('inside createAML-Edit-1');
                    if (identificationAML_Map.get(applicantwrapper.applicant.ID_1__c + applicantwrapper.applicant.ID) == NULL) {
                        System.debug('inside createAML-Edit-2:' + applicantwrapper.applicant.ID_1__c + applicantwrapper.applicant.ID);
                        lst_aml.add(createAMls(applicantwrapper, NULL, 'Secondary'));
                    } else {
                        System.debug('inside createAML-Edit-3:' + identificationAML_Map.get(applicantwrapper.applicant.ID_1__c + applicantwrapper.applicant.ID).ID);
                        lst_aml.add(createAMls(applicantwrapper, identificationAML_Map.get(applicantwrapper.applicant.ID_1__c + applicantwrapper.applicant.ID).ID, 'Secondary'));
                    }
                } else {
                    if(applicantwrapper.applicant.AMLs__r.size() > 1){
                        for(AML__c a: applicantwrapper.applicant.AMLs__r){
                            if(a.Identification__c == GEN_OriginationsConstants.AML_IDENTIFICATION_TYPE_SUPERGOLD){
                                toDeleteList.add(a);
                            }
                        }
                    }
                }
            } else {
                if(applicantwrapper.applicant.Customer_ID_Type__c != null){
                    //Insert operation
                    System.debug('inside createAML-Insert');
                    //If both primary and sec are available then create 2 new AMLs
                    if (applicantwrapper.applicant.Customer_ID_Type__c == 'NZ Birth Certificate' || applicantwrapper.applicant.Customer_ID_Type__c == 'NZ Certificate of Citizenship') {
                        lst_aml.add(createAMLs(applicantwrapper, NULL, 'Primary'));
                        lst_aml.add(createAMLs(applicantwrapper, NULL, 'Secondary'));
                    } else {
                        //If only primary is selected then create new AML
                        lst_aml.add(createAMLs(applicantwrapper, NULL, 'Primary'));
                    }
                }
            }
        }

        if(!toDeleteList.isEmpty()){
            /*CHECKMARX
            // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
            if(AML__c.sObjectType.getDescribe().isDeletable()){
                delete toDeleteList;
            }
            */
            delete toDeleteList;
        }
        
        System.debug('AML-Size:' + lst_aml.size());
        for (AML__c aml: lst_aml) {
            System.debug('##' + aml.ID + '##' + aml.ID_No__c);
        }
        return lst_aml;
    }

    /** Code updated for  DBHZL-81 story  -END**/


    /*  Description: Service Delivery Types Picklist values
     *  Author: Davey Yu
     *  Date Created: APR-22-2014
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List < SelectOption > serviceDeliveryTypes {
            get {
                List < SelectOption > options = new List < SelectOption > ();
                options.add(new SelectOption('', 'Please Select'));
                Schema.DescribeFieldResult fieldResult = Applicant__c.Service_Delivery_Type__c.getDescribe();
                List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry p: ple) {
                    options.add(new SelectOption(p.getValue(), p.getValue()));
                }
                return options;
            }
            set;
        }
        /*  Description: DBHZL-56 # List of values for Product type selection
         *  Author: Fahad Akhtar
         *  Date Created: NOV-12-2014
         *  Input Parameters: None
         *  Return: List<SelectOption>
         */
    public List < SelectOption > getTypeofProducts(String brand) {
        system.debug('Brand id ' + brand);
        List < SelectOption > options = new List < SelectOption > ();
        if (Schema.sObjectType.Application__c.fields.Type_of_Product__c.isUpdateable())
            options.add(new SelectOption('', 'Please Select'));
        for (GEProduct__c p: [SELECT id, type__c FROM GEProduct__c WHERE Brands__r.id = : brand AND type__c != : GEN_OriginationsConstants.PRODUCT_TYPE_INSURANCE]) {
            options.add(new SelectOption(p.type__c, p.type__c));
        }
        return options;
    }

    public string bankAccountHeld {
        get;
        set;
    }

    /*  Description: Validate System Reason Code based on System_Reason_Code_Control__c values 
     *  Author: Mike Lasala
     *  Date Created: MAY-20-2015
     *  Input: String (AML/POI)
     *  Return: Boolean
     */
    public Boolean isSystemReasonCode(String service){
        Boolean isOutstanding = false;

        String responseCodeDescription = application.Response_Description__c;
        
        if(responseCodeDescription != null){
            
            String[] decisions = responseCodeDescription.split(';');
            
            for(String d: decisions){

                String[] prefix = d.split('\\|');

                if(prefix.size()==2){

                    String codeSuffix = prefix[0].substring(prefix[0].length()-1, prefix[0].length());
                    
                    if(codeSuffix == 'S'){

                        String reasonCode = prefix[0].substring(0, prefix[0].length()-1);
                        System.debug('$$$ reasonCode: '+reasonCode);

                        if(!System_Reason_Code_Control__c.getAll().values().isEmpty()){
                            String reasonCodeSettingsValue = System_Reason_Code_Control__c.getInstance(service).Reason_Code__c;

                            System.debug('$$$ result: '+reasonCodeSettingsValue.contains(reasonCode));
                            if(reasonCodeSettingsValue.contains(reasonCode)){
                                isOutstanding = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
        return isOutstanding;
    }

    /*  Description: Validate POI code in the response code description based on region
     *  Author: Adrian Recio
     *  Date Created: MAY-20-2015
     *  Input: responseCodeDescription - response code description in application
               regionVar - application region suffix
               applicantVar - applicant type
     *  Return: Boolean
     */
    public static Boolean parsePOICodes(string responseCodeDescription, string applicantVar){
        Boolean poiIncomplete = false;
        String a = responseCodeDescription;
        if(a!=null){
            String[] resDes = a.split(';');
            for(String b: resDes){
                String[] d = b.split('\\|');
                if(d.size()==2){
                    
                    String e = d[0].substring(d[0].length()-1,d[0].length());
                    
                    if(e=='S'){
                        if(applicantVar=='Applicant 1'){
                            if(d[0]=='C90AS'){
                                poiIncomplete = true;
                            }else if(d[0]=='C91AS'){
                                poiIncomplete = true;
                            }
                        }else if(applicantVar=='Applicant 2'){
                                if(d[0]=='C90BS'){
                                    poiIncomplete = true;
                                }else if(d[0]=='C91BS'){
                                    poiIncomplete = true;
                                }
                        }    
                    }
                }
            }
        }
        return poiIncomplete;
    }
    
    /*  Description: Method to determine previous page on the application process based on current page.
     *  Author: Mike Lasala
     *  Date Created: 09-SEPT-16
     *  Input Parameters: Id
     *  Return: Pagereference
     */
    public static PageReference backPage(){
        string pageName = '';
        pageReference pgRef = null;
        
        if(UserUtility.pageName()!=null){
            pageName = UserUtility.pageName().toLowerCase();
        }
        
        if(pageName == 'app_jointincome'){
            pgRef = Page.app_jointpersonaldetails;
        }else if(pageName == 'app_jointexpenses'){
            pgRef = Page.app_jointincome;
        }else if(pageName == 'app_jointassets'){
            pgRef = Page.app_jointexpenses;
        }else if(pageName == 'app_jointdebtandliabilities'){
            pgRef = Page.app_jointassets;
        }        
        // Put application parameter if pagereference is not null
        if(pgRef!=null){
            pgRef.setRedirect(true);
            pgRef.getParameters().put('Id',ApexPages.currentPage().getParameters().get('Id')); 
            Id appid = ApexPages.currentPage().getParameters().get('Id');
            Application__c app = [select Product_SubType__c from Application__c where Id=:appid];
            if(app.Product_SubType__c == 'Better Start PL' && ApexPages.currentPage().getParameters().get('form') != 'broker'){
            pgRef.getParameters().put('subType','betterStart');  }    
             if(ApexPages.currentPage().getParameters().get('form') == 'broker'){
            pgRef.getParameters().put('form','broker');
            }   
        }
        return pgRef;
    }
    
    /**
     * @Description: TO pass the App_CommonExt as parameter to the Web Analytic component
     * @Author: Afreen Khan
     * @Date Created: 28-SEPT-2016
     */
    public APP_CommonExt getThis(){
        return this;
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
}