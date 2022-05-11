/**
 * @Description: Common class for Web Service class
 * @Author: Dan Crisologo
 * @Date Created: DECEMBER 10 2013
 * @History:
   =====================================================================
        12-10 (Dan): Created.
   =====================================================================
 */ 
public without sharing virtual class WS_WebserviceCommons{

    protected Boolean mockEnable;
 
    private String REQUESTED_BY;
    private String MAIN_BUSINESS_UNIT;
    private String SUB_BUSINESS_UNIT;
    private String REQUESTED_NAME;
    private String SERVICE_VERSION;
    private String TARGET_SERVICE_APPSUBMIT;
    private String TARGET_SERVICE_CUSTOMERSEARCH;
    private String TARGET_SERVICE_DOCGEN;
    private String TARGET_SERVICE_RETRIEVEPAYOFFFIGURE; //DBHZL386 Tony xu
    private String CERTIFICATE_NAME;
    private String APPLICATION_SERVICE_ENDPOINT;
    private String CUSTOMER_SEARCH_ENDPOINT;
    private String GENERATE_DOCUMENT_ENDPOINT;
    private STring RETRIEVE_PAYOFF_FIGURE_ENDPOINT; //DBHZL386 Tony xu
    private String MOCK_BASE_ENDPOINT;
    private String MOCK_APPLICATION_ENDPOINT;
    private String MOCK_CUSTOMER_SEARCH_ENDPOINT;
    private String MOCK_GENERATE_DOCUMENT_ENDPOINT;
    private String REQUESTEDNAME_SALES;
    private String SOLCODE_SALES;
    private String SOLCODE_CUSTOMER;
    private String SOLCODE_BROKER;
    private String GENERAL_TIMEOUT;
    //12-03-2014 Added to be used by web service classes to send login user's country when needed by Tony Xu    
    public String country{
        get{
            if(country == null)
                country = Util.getUser().country__c;
            return country;
        }
        set;
    } 
    
    public WS_WebserviceCommons(Boolean mockEnable) {
        this.mockEnable = mockEnable;
        loadCustomSettingsInfo();
    }
    
    /*  *Description: get custom settings data.
        *Author: Fahad Akhtar                
        *return: custom settings. 
    */
    private void loadCustomSettingsInfo(){
        REQUESTED_BY = Web_Service_Settings__c.getValues((mockEnable?'Mock Enabled Requested By':country + ' Requested By')).Value__c;
        MAIN_BUSINESS_UNIT = Web_Service_Settings__c.getValues('Main Business Unit').Value__c;
        SUB_BUSINESS_UNIT = Web_Service_Settings__c.getValues('Sub-Business Unit').Value__c;
        SERVICE_VERSION = Web_Service_Settings__c.getValues('Service Version').Value__c;
        TARGET_SERVICE_APPSUBMIT = Web_Service_Settings__c.getValues('Target Service App Submit').Value__c;
        TARGET_SERVICE_CUSTOMERSEARCH = Web_Service_Settings__c.getValues('Target Service Customer Search').Value__c;
        CERTIFICATE_NAME = Web_Service_Settings__c.getValues('Certificate Name').Value__c;  
        APPLICATION_SERVICE_ENDPOINT = Web_Service_Settings__c.getValues('Application Service Endpoint').value__c;
        CUSTOMER_SEARCH_ENDPOINT = Web_Service_Settings__c.getValues('Customer Search Endpoint').value__c;
        GENERATE_DOCUMENT_ENDPOINT = Web_Service_Settings__c.getValues('Generate Document Endpoint').value__c;
        RETRIEVE_PAYOFF_FIGURE_ENDPOINT = Web_Service_Settings__c.getValues('Retrieve Payoff Figure Endpoint').value__c; //DBHZL386 Tony Xu
        MOCK_BASE_ENDPOINT = Web_Service_Settings__c.getValues('Webservice Base Endpoint').value__c;
        MOCK_APPLICATION_ENDPOINT = Web_Service_Settings__c.getValues('Webservice Endpoint - Application').value__c;
        MOCK_CUSTOMER_SEARCH_ENDPOINT = Web_Service_Settings__c.getValues('Webservice Endpoint - Customer Search').value__c;
        MOCK_GENERATE_DOCUMENT_ENDPOINT = Web_Service_Settings__c.getValues('Webservice Endpoint - Documents').value__c;
        REQUESTEDNAME_SALES = Web_Service_Settings__c.getValues('Requested Name Sales').Value__c;
        SOLCODE_SALES = Web_Service_Settings__c.getValues('SOLCode Sales').Value__c;
        SOLCODE_CUSTOMER = Web_Service_Settings__c.getValues('SOLCode Customer').Value__c;
        SOLCODE_BROKER = Web_Service_Settings__c.getValues('SOLCode Broker').Value__c;
        TARGET_SERVICE_DOCGEN = Web_Service_Settings__c.getValues('Target Service Doc Generation').Value__c;
        TARGET_SERVICE_RETRIEVEPAYOFFFIGURE = Web_Service_Settings__c.getValues('Target Service Retrieve Payoff Figure').Value__c; //DBHZL386 Tony xu
        GENERAL_TIMEOUT = Web_Service_Settings__c.getValues('General WS Timeout').Value__c; 
    }

    /*  *Description: get requested by.
        *Author: Fahad Akhtar 
        *Param: None
        *return: String. 
    */
    protected String getRequestedBy(){
     system.debug('Requested Country for SQ'+REQUESTED_BY);
        return REQUESTED_BY;
    }

    /*  *Description: get main business unit.
        *Author: Fahad Akhtar 
        *Param: None
        *return: String. 
    */
    protected String getMainBusinessUnit(){
        return MAIN_BUSINESS_UNIT;
    }

    /*  *Description: get sub business unit.
        *Author: Fahad Akhtar 
        *Param: None
        *return: String. 
    */
    protected String getSubBusinessUnit(){
        return SUB_BUSINESS_UNIT;
    } 

    /*  *Description: get Service Version.
        *Author: Fahad Akhtar 
        *Param: None
        *return: String. 
    */
    protected String getServiceVersion(){
        return SERVICE_VERSION;
    }

    /*  *Description: get Target Service for App Submit.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getTargetServiceAppSubmit(){
        return TARGET_SERVICE_APPSUBMIT;
    }
    
    /*  *Description: get Target Service for Customer Search
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getTargetServiceCustomerSearch(){
        return TARGET_SERVICE_CUSTOMERSEARCH;
    }
    
    /*  *Description: get Target Service for Document Generation
        *Author: Fel Saliba
        *Param: None
        *return: String. 
    */
    protected String getTargetServiceDocGen(){
        return TARGET_SERVICE_DOCGEN;
    }

    /*  *Description: get Certificate.
        *Author: Fahad Akhtar 
        *Param: None
        *return: String. 
    */
    protected String getCertificateName(){
        return CERTIFICATE_NAME;
    }
    
     /*  *Description: get Application Services Endpoint.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getApplicationServiceEndpoint() {
        if(this.mockEnable) {
            return MOCK_BASE_ENDPOINT + MOCK_APPLICATION_ENDPOINT;
        }
        return APPLICATION_SERVICE_ENDPOINT; 
    }
    
    /*  *Description: get Customer Search.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getCustomerSearchEndpoint() {
        if(this.mockEnable) {
            return MOCK_BASE_ENDPOINT + MOCK_CUSTOMER_SEARCH_ENDPOINT;
        }
        return CUSTOMER_SEARCH_ENDPOINT; 
    }
    
    /*  *Description: get Generate Document Endpoint.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getGenerateDocumentEndpoint() {
        if(this.mockEnable) {
            return MOCK_BASE_ENDPOINT + MOCK_GENERATE_DOCUMENT_ENDPOINT;
        }
        return GENERATE_DOCUMENT_ENDPOINT; 
    }
    
    /*  *Description: get solcode value based on channel
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getSolcode(String channel) {
        if(channel==REQUESTEDNAME_SALES) {
            return SOLCODE_SALES;
        } else if(channel==GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER) {
            return SOLCODE_BROKER;
        }
        //solcode will be defaulted to customer
        return SOLCODE_CUSTOMER;
    }
    
    /*  *Description: get Timeout for general webservices.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getGeneralTimeout() {
        return GENERAL_TIMEOUT; 
    }

    /*  *Description: get Timeout for search and match service, use general timeout if not present.
        *Author: Dan Crisologo
        *Param: None
        *return: String. 
    */
    protected String getSearchAndMatchTimeout() {
        if(Web_Service_Settings__c.getValues('Search and Match Timeout')!=null) {
            return Web_Service_Settings__c.getValues('Search and Match Timeout').value__c;
        }
        return GENERAL_TIMEOUT; 
    }

    /**  Description: Set-up endpoint and certificate name
    *  Author: Dan Crisologo
    *  Date Created: 12-13-13
    *  Input Parameters: None
    *  Return: OriginationApplicationServiceSOAP 
    */
    protected ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP setupApplicationServiceSOAP() {
        ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP cacgco = new ConsumerAnzCapitalGeComOriginations.OriginationApplicationServiceSOAP();
        cacgco.endpoint_x = getApplicationServiceEndpoint();   
        cacgco.clientCertName_x = getCertificateName(); 
        cacgco.timeout_x = Integer.valueOf(getGeneralTimeout());
        return cacgco;
    }
    
    /**  Description: Set-up endpoint and certificate name
    *  Author: Dan Crisologo
    *  Date Created: 03-17-14
    *  Input Parameters: None
    *  Return: PLDocManagementPort
    */
    protected GenerateDocumentGeComOriginations.PLDocManagementPort setupPLDocManagementPort() {
        GenerateDocumentGeComOriginations.PLDocManagementPort pldocPort = new GenerateDocumentGeComOriginations.PLDocManagementPort();
        pldocPort.endpoint_x = getGenerateDocumentEndpoint();
        pldocPort.clientCertName_x = getCertificateName();
        pldocPort.timeout_x = Integer.valueOf(getGeneralTimeout());
        return pldocPort;
    } 
    /**  Description: Set-ups all common application submit/update data
    *  Author: Dan Crisologo
    *  Date Created: 12-16-13
    *  Input Parameters: None
    *  Return: GenericApplicationData
    */
    protected GenericApplicationData setupGenericApplicationData(Application__c application, 
                                                               List<Loan_Purpose__c> loanPurposeList,
                                                               List<ONR__C> onrList,
                                                               GEProduct__c product,
                                                               Branch__c branch,
                                                               User appOwner,
                                                               List<Debit__c> debits,
                                                               List<Fees_Charges__c> feesAndCharges,
                                                               Applicant__c applicant, 
                                                               List<Income__c> incomeList, 
                                                               List<Asset__c> assetList, 
                                                               List<Liability__c> debtList, 
                                                               List<Expense__c> expList, 
                                                               Applicant__c applicant2, 
                                                               List<Income__c> incomeList2, 
                                                               List<Asset__c> assetList2, 
                                                               List<Liability__c> debtList2, 
                                                               List<Expense__c> expList2, 
                                                               List<Collateral__c> collaterals,
                                                               List<Personal_Reference_Check__c> personalReferenceList,
                                                               List<Applicant_CLV__c> applicant1CLVList,
                                                               List<Applicant_CLV__c> applicant2CLVList,
                                                               List<Disbursement__c> refinances,
                                                               String channel) {
    
        GenericApplicationData appData = new GenericApplicationData();
        try {
            //***** Set-up Service Context *****
            appData.serviceContextParam = createOASSServiceContext(channel);
            //***** Set-up Application Customer Data Type *****
            appData.applicationCustomerData = createApplicationCustomerDataType(application, 
                                                                        loanPurposeList,
                                                                        product,
                                                                        debits,
                                                                        feesAndCharges,
                                                                        applicant, 
                                                                        incomeList, 
                                                                        assetList, 
                                                                        debtList, 
                                                                        expList, 
                                                                        applicant2, 
                                                                        incomeList2, 
                                                                        assetList2, 
                                                                        debtList2, 
                                                                        expList2, 
                                                                        collaterals,
                                                                        personalReferenceList,
                                                                        applicant1CLVList,
                                                                        applicant2CLVList,
                                                                        refinances,
                                                                        channel);
            //***** Set-up Application Supporting Data Type *****
            appData.applicationSupportingData = createApplicationSupportingData(application,
                                                                        product,
                                                                        loanPurposeList,
                                                                        onrList,
                                                                        branch,
                                                                        appOwner);
            
            //appData.thirdpartyData = createThirdPartyDetails(application);
            appData.reportDetailsData = createReportDetails(application);
            
            
            
                                                                        
        } catch (Exception e) {
            throw e;
        }
                                                                    
        return appData;
    }
    
    
    
    /**  Description: Set-ups all common Quote submit/update data
    *  Author: Madhusudhan Seethala    
    *  Date Created: Mar-25-20
    *  Input Parameters: Quote object
    *  Return: GenericApplicationData
    */
    protected consumerAnzCapitalGeComOriginations.amlApplicantsCollection generateAMLData(Quote__c quote) {
    
        consumerAnzCapitalGeComOriginations.amlApplicantsCollection quoteAMLData= new consumerAnzCapitalGeComOriginations.amlApplicantsCollection();
        
        try {
            //***** Set-up AML Data *****
            quoteAMLData= WS_QuoteWebServiceHelper.generatAmlApplicantCollection(quote);
            
        } catch (Exception e) {
            throw e;
        }
                                                                    
        return quoteAMLData;
    }
    
    /**  Description: Set-ups all common Quote submit/update data
    *  Author: Madhusudhan Seethala    
    *  Date Created: Mar-25-20
    *  Input Parameters: Quote object
    *  Return: GenericApplicationData
    */
    protected GenericApplicationData setupGenericQuoteData(Quote__c quote) {
    
        GenericApplicationData appData = new GenericApplicationData();
        
        try {
            //***** Set-up Service Context *****
            appData.serviceContextParam = createOASSServiceContext(quote.Channel__c);
            //***** Set-up quote Customer Data Type *****
            appData.applicationCustomerData = createQuoteCustomerDataType(quote);
             system.debug('Quote Customer Data SQ'+createQuoteCustomerDataType(quote));
            //***** Set-up quote Supporting Data Type *****
            system.debug('Quote Check SQ'+QUOTE);
            appData.applicationSupportingData = createQuoteSupportingData(quote);
            system.debug('Quote Supporting data SQ'+createQuoteSupportingData(quote));
                                                                                   
        } catch (Exception e) {
            throw e;
        }
                                                                    
        return appData;
    }
    
    
    /**  Description: Creates ApplicationSupportingDataType for webservice request
    *  Input Parameters: Quote channel
    *  Return: applicationSupportingData
    */
    protected ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType createQuoteSupportingData(Quote__c quote) {
                                                                                                              
        ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType quoteSupportingData;
        
        quoteSupportingData = WS_QuoteWebServiceHelper.generatequoteSupportingDataType(quote); 
        return quoteSupportingData;
    }
    
    /**  Description: Creates ApplicationCustomerDataType for webservice request
     *  Input Parameters: Quote Object
    *  Return: ApplicationCustomerDataType
    */
    protected ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType createQuoteCustomerDataType(Quote__c  quote) {
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType applicationCustomerData;    
        //create collection of applicant                                   
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
    
        applicantTypeList.add(WS_QuoteWebServiceHelper.generateQuoteApplicantType(quote));
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicantCollection = WS_QuoteWebServiceHelper.generateApplicantCollection(applicantTypeList); 
      /*  ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetails = WS_QuoteWebServiceHelper.generateQuoteProductDetailsType(quote.Residential_Country__c);
        ConsumerAnzCapitalGeComOriginations.LoanDetailsType loanDetails = WS_QuoteWebServiceHelper.generateLoanDetailsType(quote); */

        applicationCustomerData = WS_QuoteWebServiceHelper.generateQuoteCustomerDataType(quote);
        return applicationCustomerData;
    }
    
    
    /** Description: Creates third Party Details for webservice request
     *  Author: Afreen Khan
     *  Date Created: 22-06-2016
     *  Input Parameters: Application
     *  Return: thirdPartyDetailsDataType 
     */
    /*protected ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType createThirdPartyDetails(Application__c application) {
        ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType thirdpartyData;
        thirdpartyData = WS_WebServiceHelper.generateThirdPartyDetails(application);
        
        return thirdpartyData;
    }*/
    
     /** Description: Creates Report Details for webservice request
     *  Author: Afreen Khan
     *  Date Created: 22-06-2016
     *  Input Parameters: Application
     *  Return: reportDetails 
     */
    
    protected ConsumerAnzCapitalGeComOriginations.reportDetails createReportDetails(Application__c application) {
        ConsumerAnzCapitalGeComOriginations.reportDetails reportDetailsData;
        reportDetailsData = WS_WebServiceHelper.generateReportDetails(application);
        
        return reportDetailsData;
    }


   /**  Description: Creates service context for webservice request
    *  Author: Dan Crisologo
    *  Date Created: 12-13-13
    *  Input Parameters: channel
    *  Return: ServiceContext 
    */
    protected ConsumerAnzCapitalGeComOriginations.ServiceContext createOASSServiceContext(String channel) {
        ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        //Build business and customer context
        ConsumerAnzCapitalGeComOriginations.BusinessContext businessContext = WS_WebServiceHelper.generateBusinessContext(getMainBusinessUnit(), getSubBusinessUnit());
        ConsumerAnzCapitalGeComOriginations.ConsumerContext consumerContext = WS_WebServiceHelper.generateConsumerContext(getRequestedBy(), channel, getServiceVersion(), getTargetServiceAppSubmit(), businessContext);
        
        //build exception collection (when to populate this?)
        ConsumerAnzCapitalGeComOriginations.Exception_x[] exceptionXList = new ConsumerAnzCapitalGeComOriginations.Exception_x[]{WS_WebServiceHelper.generateExceptionX(null, null, null, null, null, null)}; //still need to populate?
        ConsumerAnzCapitalGeComOriginations.ExceptionCollection exceptionCollection = WS_WebServiceHelper.generateExceptionCollection(exceptionXList);
        
        //build service context
        serviceContextParam = WS_WebServiceHelper.generateServiceContext(consumerContext, exceptionCollection);
        return serviceContextParam;
    }
    
    /**  Description: Creates ApplicationCustomerDataType for webservice request
    *  Author: Dan Crisologo
    *  Date Created: 12-13-13
    *  Input Parameters: channel
    *  Return: ApplicationCustomerDataType
    */
    protected ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType createApplicationCustomerDataType(Application__c application, 
                                                                                                              List<Loan_Purpose__c> loanPurposeList,
                                                                                                              GEProduct__c product,
                                                                                                              List<Debit__c> debits,
                                                                                                              List<Fees_Charges__c> feesAndCharges,
                                                                                                              Applicant__c applicant, 
                                                                                                              List<Income__c> incomeList, 
                                                                                                              List<Asset__c> assetList, 
                                                                                                              List<Liability__c> debtList, 
                                                                                                              List<Expense__c> expList, 
                                                                                                              Applicant__c applicant2, 
                                                                                                              List<Income__c> incomeList2, 
                                                                                                              List<Asset__c> assetList2, 
                                                                                                              List<Liability__c> debtList2, 
                                                                                                              List<Expense__c> expList2,
                                                                                                              List<Collateral__c> collaterals,
                                                                                                              List<Personal_Reference_Check__c> personalReferenceList,
                                                                                                              List<Applicant_CLV__c> applicant1CLVList,
                                                                                                              List<Applicant_CLV__c> applicant2CLVList,
                                                                                                              List<Disbursement__c> refinances,
                                                                                                              String channel) {
        ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType applicationCustomerData;    
        //create collection of applicant                                   
        List<ConsumerAnzCapitalGeComOriginations.ApplicantType> applicantTypeList = new List<ConsumerAnzCapitalGeComOriginations.ApplicantType>();
    
        applicantTypeList.add(WS_WebServiceHelper.generateApplicantType(applicant.Id,
                                                                        applicant,
                                                                        incomeList,
                                                                        expList,
                                                                        applicant1CLVList,
                                                                        refinances,
                                                                        application));
        
        if(application.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            applicantTypeList.add(WS_WebServiceHelper.generateApplicantType(applicant2.Id,
                                                                            applicant2,
                                                                            incomeList2,
                                                                            expList2,
                                                                            applicant2CLVList,
                                                                            refinances,
                                                                            application));
        } 
        ConsumerAnzCapitalGeComOriginations.ApplicantCollection applicantCollection = WS_WebServiceHelper.generateApplicantCollection(applicantTypeList); 
                                                                          
        //create product details 
        //Fel Saliba Modified parameters 20/07/2015
        //need to remove the rollup summary field to avoid Self Trigger Reference Error in flushing insurance 
        
        Integer insuranceCount = [SELECT count() FROM Product_Item__c 
                                  WHERE Application__c =: application.Id
                                  AND   Product_Version__r.Type__c !=: GEN_OriginationsConstants.PRODUCT_TYPE
                                  AND   Product_Version__r.Type__c !=: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN];
        
        //Below line commented by Suneel - Added new parameter - Better start
        Better_Start_Offer__c bsOffer = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
        //ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetails = WS_WebServiceHelper.generateProductDetailsType(product, application.Is_Secured__c, insuranceCount, applicant.State_Res__c);
        ConsumerAnzCapitalGeComOriginations.ProductDetailsType productDetails = WS_WebServiceHelper.generateProductDetailsType(application,product, application.Is_Secured__c, insuranceCount, applicant.State_Res__c,bsOffer);

        //get the loan purpose with the highest loan amount
        Decimal loanAmount = 0;
        String purposeValue = '';
        if(loanPurposeList.size()>0) {
            for(Loan_Purpose__c lps: loanPurposeList) {
                if(lps.Loan_Amount__c!=null) {
                    if(loanAmount<lps.Loan_Amount__c) {
                        loanAmount = lps.Loan_Amount__c;
                        purposeValue = lps.Value__c;
                    }
                }
            }
        }
        
        // --- Code added by Akash -- Start
        Brand__c brand;
        if(application.Brand_Lookup__c != NULL) {
          List<Brand__c> lstBrand = [Select Country__c FROM Brand__c WHERE Id = :application.Brand_Lookup__c];
          if(!lstBrand.isEmpty()) {
            brand = lstBrand[0]; 
          }
        }
        
        String country_channel_Key = GEN_OriginationsConstants.SOLE_CODE + brand.Country__c + '-'+ application.channel__c;
        String solCode = '';
        solCode =  Web_Service_Settings__c.getValues(country_channel_Key).value__c;
        
      //  String solCode = Web_Service_Settings__c.getValues('SOLCode-AU-Sales').value__c;
        
        
        // --- Code Commented by Akash -- Start
        /* Commented by - Akash 
        * To add new code for solcode extraction
        * Date - 28th oct
        //identify solcode to use
        String solCode = '';
        if(application.channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER) { //get solcode if channel__c = broker
            //solCode = getSolcode(GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER);
            solCode = SOLCODE_BROKER;
        } 
        else if(application.channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES){
            solCode = SOLCODE_SALES;
        }
        else{
            solCode = SOLCODE_CUSTOMER;
        }
        */
        
               
        /*else {
            solCode = getSolcode(channel);
        }*/
        
        //create loan details
        ConsumerAnzCapitalGeComOriginations.LoanDetailsType loanDetails = WS_WebServiceHelper.generateLoanDetailsType(application, loanPurposeList, product, solCode, debits, feesAndCharges); 

        applicationCustomerData = WS_WebServiceHelper.generateApplicationCustomerDataType(application,
                                                                                          applicantCollection,
                                                                                          productDetails,
                                                                                          loanDetails,
                                                                                          assetList,
                                                                                          debtList,
                                                                                          assetList2,
                                                                                          debtList2,
                                                                                          applicant,
                                                                                          applicant2,
                                                                                          collaterals,
                                                                                          personalReferenceList);
         return applicationCustomerData;
    }
    
    /**  Description: Creates service context for webservice request
    *  Author: Dan Crisologo
    *  Date Created: 12-13-13
    *  Input Parameters: channel
    *  Return: ServiceContext 
    */
    @testVisible
    protected ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType createApplicationSupportingData(Application__c application,
                                                                                                              GEProduct__c product,
                                                                                                              List<Loan_Purpose__c> loanPurposeList,
                                                                                                              List<ONR__C> onrList,
                                                                                                              Branch__c branch,
                                                                                                              User appOwner) {
                                                                                                              
        ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType applicationSupportingData;
        
        //create finger print details
        ConsumerAnzCapitalGeComOriginations.FingerPrintDetailsType fingerPrintDetailsType = WS_WebServiceHelper.generateFingerPrintDetailsType(application);
        
        //caseX Param 1: case owner  
        CommonModelServicingGeCom.User_x caseOwner = WS_WebServiceHelper.generateUserx(appOwner, application); //user name and SSO // May-05-2016 - Afreen- Method signature is changed to include application
        
        //caseX Param 2: contact List 
        List<ContactModelServicingGeCom.Contact> contactList = new List<ContactModelServicingGeCom.Contact>();
        
        //caseX Param 3: product List 
        List<ProductModelServicingGeCom.Product> productList = new List<ProductModelServicingGeCom.Product>();
        productList.add(WS_WebServiceHelper.generateProduct(product));
        
        //caseX Param 4: ProductArrangement List: has 5 class parameters
        List<CaseModelServicingGeCom20.ProductArrangement> productArrangement = new List<CaseModelServicingGeCom20.ProductArrangement>();
        
            //ProductArrangement Class Param 1: Sales Dialog
            List<ProductModelServicingGeCom.Product> salesDialogProducts = new List<ProductModelServicingGeCom.Product>(); 
            
            //create sales dialog input from loan purpose
            List<SalesModelServicingGeCom.SalesDialogInput> loanPurposeSalesDialogInput = new List<SalesModelServicingGeCom.SalesDialogInput>();
            Integer loanPurposeCount = 0;
            System.debug('loanPurposeList.size():' + loanPurposeList.size());
            for(Loan_Purpose__c lp: loanPurposeList) {
                //create salesInput for purpose
                String onrPurposeId = GEN_OriginationsConstants.META_ID_PURPOSE;
                onrPurposeID = onrPurposeID.replace('int1', String.valueOf(loanPurposeCount));
                onrPurposeID = onrPurposeID.replace('int2', String.valueOf(GEN_OriginationsConstants.SALES_INPUT_PURPOSE_SUFFIX)); //default to 0
                loanPurposeSalesDialogInput.add(WS_WebServiceHelper.generateSalesDialogInput(onrPurposeID,
                                                                                             GEN_OriginationsConstants.ONR_STATUS_KNOWN,
                                                                                             GEN_OriginationsConstants.ONR_PROMPT_LOAN_PURPOSE,
                                                                                             lp.Value__c,
                                                                                             GEN_OriginationsConstants.ONR_TYPE_CHOICE));
                //create salesInput for amount                                                                            
                String onrAmountId = GEN_OriginationsConstants.META_ID_PURPOSE;
                onrAmountId = onrAmountId.replace('int1', String.valueOf(loanPurposeCount));
                onrAmountId = onrAmountId.replace('int2', String.valueOf(GEN_OriginationsConstants.SALES_INPUT_AMOUNT_SUFFIX)); //default to 1
                loanPurposeSalesDialogInput.add(WS_WebServiceHelper.generateSalesDialogInput(onrAmountId,
                                                                                             GEN_OriginationsConstants.ONR_STATUS_KNOWN,
                                                                                             GEN_OriginationsConstants.ONR_PROMPT_AMOUNT,
                                                                                             String.valueOf(lp.Loan_Amount__c),
                                                                                             GEN_OriginationsConstants.ONR_TYPE_AMOUNT));
                //create salesInput for other purpose
                String onrOtherPurposeId = GEN_OriginationsConstants.META_ID_OTHER_PURPOSE;
                onrOtherPurposeId = onrOtherPurposeId.replace('int1', String.valueOf(loanPurposeCount));
                onrOtherPurposeId = onrOtherPurposeId.replace('int2', String.valueOf(GEN_OriginationsConstants.SALES_INPUT_OTHER_PURPOSE_SUFFIX)); //default to 2
                loanPurposeSalesDialogInput.add(WS_WebServiceHelper.generateSalesDialogInput(onrOtherPurposeId,
                                                                                             GEN_OriginationsConstants.ONR_STATUS_INADMISSIBLE,
                                                                                             GEN_OriginationsConstants.ONR_PROMPT_DESCRIPTION,
                                                                                             lp.Other_Loan_Purpose__c,
                                                                                             GEN_OriginationsConstants.ONR_TYPE_TEXT));
                loanPurposeCount++;
            }
            List<SalesModelServicingGeCom.SalesDialogInput> onrSalesDialogInput = new List<SalesModelServicingGeCom.SalesDialogInput>();
            
            System.debug('loanPurposeSalesDialogInput.size()' + loanPurposeSalesDialogInput.size());
            for(ONR__c onrs: onrList) {
                System.debug('onrs.geId__c:' + onrs.geId__c);
                System.debug('GEN_OriginationsConstants.META_ID_PURPOSE_TABLE:' + GEN_OriginationsConstants.META_ID_PURPOSE_TABLE);
                List<SalesModelServicingGeCom.SalesDialogInput> salesDialogInputs = new List<SalesModelServicingGeCom.SalesDialogInput>();
                List<CommonModelServicingGeCom.Variable> attributesList = new List<CommonModelServicingGeCom.Variable>(); 
                if(onrs.geId__c == GEN_OriginationsConstants.META_ID_PURPOSE_TABLE) {
                    //if purposetable is found, populate the loan purpose sales dialog
                    salesDialogInputs.addAll(loanPurposeSalesDialogInput);
                }
                System.debug('salesDialogInputs.size()' + salesDialogInputs.size());
                onrSalesDialogInput.add(WS_WebServiceHelper.generateSalesDialogInput(onrs, 
                                                                                     GEN_OriginationsConstants.ONR_STATUS_KNOWN, 
                                                                                     attributesList,
                                                                                     salesDialogInputs));
            }
            
            SalesModelServicingGeCom.SalesDialog salesDialog = WS_WebServiceHelper.generateSalesDialog('', onrSalesDialogInput, salesDialogProducts);
            
            //ProductArrangement Class Param 2: Product 
            ProductModelServicingGeCom.Product prodArrangementProduct = WS_WebServiceHelper.generateProduct(product);
            
            //ProductArrangement Class Param 3: Application 
            ApplicationModelServicingGeCom.Application wsApp = new ApplicationModelServicingGeCom.Application();
            
            //ProductArrangement Class Param 4: Contract 
            ContractModelServicingGeCom.Contract contract = WS_WebServiceHelper.generateContract(null); 
            
            //ProductArrangement Class Param 5: Product Arrangement Role List
            List<CaseModelServicingGeCom20.ProductArrangementRole> productArrangementRoleList = new List<CaseModelServicingGeCom20.ProductArrangementRole>();

        productArrangement.add(WS_WebServiceHelper.generateProductArrangement('', //id
                                                                              salesDialog,
                                                                              DateTime.now(),
                                                                              DateTime.now(),
                                                                              '', 
                                                                              getRequestedBy(), //channel
                                                                              prodArrangementProduct,
                                                                              wsApp,
                                                                              contract,
                                                                              productArrangementRoleList,
                                                                              '',
                                                                              ''));
        
        //caseX Param 5: notes //Leave notes blank as per Andrew
        List<CommonModelServicingGeCom.Note> notesList = new List<CommonModelServicingGeCom.Note>();
        
        //create caseX
        CaseModelServicingGeCom20.Case_x caseX = WS_WebServiceHelper.generateCasex(caseOwner, 
                                                                                   contactList , 
                                                                                   productList,
                                                                                   productArrangement,
                                                                                   notesList);

        applicationSupportingData = WS_WebServiceHelper.generateApplicationSupportingDataType(fingerPrintDetailsType, 
                                                                                              application.Acceptance_Channel_Code__c,
                                                                                              caseX,
                                                                                              branch,
                                                                                              appOwner, application.Channel__c); // May-09-2016 - Afreen updated the signature to include the application channel
        return applicationSupportingData;
    }
    
    /**  Description: Creates service context for Generate Document service
    *  Author: Dan Crisologo
    *  Date Created: 02-04-14
    *  Input Parameters: 
    *  Return: String     
    */
    protected GenerateDocumentGeComOriginations.ServiceContext createPLDOCServiceContext(String channel) {
        GenerateDocumentGeComOriginations.ServiceContext serviceContext;
        //create business context
        GenerateDocumentGeComOriginations.BusinessContext businessContext = new GenerateDocumentGeComOriginations.BusinessContext();
        businessContext.mainBusinessUnit = getMainBusinessUnit();
        businessContext.subBusinessUnit = getSubBusinessUnit();
    
        //create consumer context
        GenerateDocumentGeComOriginations.ConsumerContext consumer = new GenerateDocumentGeComOriginations.ConsumerContext();
        consumer.requestedBy = getRequestedBy();
        consumer.requestedName = channel; 
        consumer.serviceVersion = getServiceVersion();
        consumer.targetService = getTargetServiceDocGen();
        consumer.businessUnit = businessContext;
        serviceContext = new GenerateDocumentGeComOriginations.ServiceContext();
        serviceContext.consumer = consumer;
        
        return serviceContext;

    }

    /**  Description: Write a record to the Web_Service_Log__c table for debugging and logging purposes
    *  Author: Andrew Manetakis
    *  Date Created: 02-04-14
    *  Input Parameters: Application Id (if known) 
    *  Return: void   
    */
    public void insertWebServiceLog(String serviceCalled, boolean callSuccessful, String responseCode, String responseDescription, ID applicationId, String endPoint, String certificateName, String channel, Integer timeout, Long callTime) {
        try {
            Web_Service_Log__c log = new Web_Service_Log__c();
            if(applicationId != null) log.application__c = applicationId;
            if(endPoint!=null) log.Endpoint__c = endpoint;
            if(certificateName!=null) log.certificate_name__c = certificateName;
            if(channel!=null) log.channel__c = channel;
            if(timeout!=null) log.timeout__c = timeout; 
            if(serviceCalled!=null) log.service_called__c = serviceCalled;
            if(Math.abs(callTime)< 999999999999999999L) log.Call_Duration_ms__c = callTime;
            if(callSuccessful!=null) log.Call_Successful__c = callSuccessful; 
            if(responseCode!=null) log.response_Code__c = responseCode;
            log.Time__c = String.ValueOf(System.now());  
            if(responseDescription!=null) log.response_Description__c = responseDescription; 
            //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
            // if(Web_Service_Log__c.SObjectType.getDescribe().isCreateable()) {
            //     insert log;
            // }
            insert log;
        }
        catch(Exception e) {
            System.debug('Failed to insert Web Service Log - ' + e.getMessage());
        }
    } 
    
    
    /**  Description: Write a record to the Web_Service_Log__c table for debugging and logging purposes
    *  Author: Andrew Manetakis
    *  Date Created: 02-04-14
    *  Input Parameters: QuoteId (if known) 
    *  Return: void   
    */
    public void insertQuoteWebServiceLog(String serviceCalled, boolean callSuccessful, String responseCode, String responseDescription, ID quoteId, String endPoint, String certificateName, String channel, Integer timeout, Long callTime) {
        try {
            Web_Service_Log__c log = new Web_Service_Log__c();
            if(quoteId != null) log.Quote__c = quoteId;
            if(endPoint!=null) log.Endpoint__c = endpoint;
            if(certificateName!=null) log.certificate_name__c = certificateName;
            if(channel!=null) log.channel__c = channel;
            if(timeout!=null) log.timeout__c = timeout; 
            if(serviceCalled!=null) log.service_called__c = serviceCalled;
            if(Math.abs(callTime)< 999999999999999999L) log.Call_Duration_ms__c = callTime;
            if(callSuccessful!=null) log.Call_Successful__c = callSuccessful; 
            if(responseCode!=null) log.response_Code__c = responseCode;
            log.Time__c = String.ValueOf(System.now());  
            if(responseDescription!=null) log.response_Description__c = responseDescription; 
            
            insert log;
        }
        catch(Exception e) {
            System.debug('Failed to insert Web Service Log - ' + e.getMessage());
        }
    }
    
    /**  Description: Creates service context for Generate Payoff Figure Service
    *  Author: Tony Xu  
    *  Date Created: 2015-03-02
    *  Input Parameters: 
    *  Return: String     
    */
    protected PayoffQuoteAnzCapitalGeCom.ServiceContext createPayoffQuoteServiceContext(String channel) {
        PayoffQuoteAnzCapitalGeCom.ServiceContext serviceContext;
        //create business context
        PayoffQuoteAnzCapitalGeCom.BusinessContext businessContext = new PayoffQuoteAnzCapitalGeCom.BusinessContext();
        businessContext.mainBusinessUnit = getMainBusinessUnit();
        businessContext.subBusinessUnit = getSubBusinessUnit();
    
        //create consumer context
        PayoffQuoteAnzCapitalGeCom.ConsumerContext consumer = new PayoffQuoteAnzCapitalGeCom.ConsumerContext();
        consumer.requestedBy = getRequestedBy();
        consumer.requestedName = channel; 
        consumer.serviceVersion = getServiceVersion();
        consumer.targetService = getTargetServiceRetrievePayoffFigure();
        consumer.businessUnit = businessContext;
        serviceContext = new PayoffQuoteAnzCapitalGeCom.ServiceContext();
        serviceContext.consumer = consumer;
        
        return serviceContext;

    }
    
    /**Description: get Target Service for Retrieve Payoff Figure
    *Author: Tony Xu
    *Param: None
    *return: String. 
    */
    protected String getTargetServiceRetrievePayoffFigure(){
        return TARGET_SERVICE_RETRIEVEPAYOFFFIGURE;
    }
    
    /**  Description: Set-up endpoint and certificate name for retrieve payoff quote
    *  Author: Tony Xu
    *  Date Created: 2015-03-02
    *  Input Parameters: None
    *  Return: PayOffQuoteServiceSOAP  
    */
    protected PayoffQuoteAnzCapitalGeCom.PayOffQuoteServiceSOAP setupGeneratePayoffFigureServiceSOAP() {
        PayoffQuoteAnzCapitalGeCom.PayOffQuoteServiceSOAP cacgco = new PayoffQuoteAnzCapitalGeCom.PayOffQuoteServiceSOAP();
        cacgco.endpoint_x = getRetrievePayoffFigureEndpoint();   
        cacgco.clientCertName_x = getCertificateName(); 
        cacgco.timeout_x = Integer.valueOf(getGeneralTimeout());
        return cacgco;
    }
    
    /**Description: get Retrieve Payoff Figure Services Endpoint. 
      *Author: Tony Xu
      *Param: None
      *return: String. 
    */
    protected String getRetrievePayoffFigureEndpoint() {
        return RETRIEVE_PAYOFF_FIGURE_ENDPOINT; 
    }
    
    
    
    //================================ 
    //======== INNER CLASSES =========
    //================================
    
    /**  Description: This is the wrapper class used mainly for Application-related data.
    *  Author: Dan Crisologo
    *  Date Created: 12-16-13
    */
    public class GenericApplicationData {
    
        public ConsumerAnzCapitalGeComOriginations.ServiceContext serviceContextParam;
        public ConsumerAnzCapitalGeComOriginations.ApplicationCustomerDataType applicationCustomerData; 
        public ConsumerAnzCapitalGeComOriginations.ApplicationSupportingDataType applicationSupportingData;
        public ConsumerAnzCapitalGeComOriginations.reportDetails reportDetailsData;    // Added by Afreen - June 22, 2016
       //public ConsumerAnzCapitalGeComOriginations.thirdPartyDetailsDataType thirdpartyData;   // Added by Afreen - June 22, 2016
    }
}