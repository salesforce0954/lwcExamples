/**
 * @Description: Test Data Builder used for webservice test classes. This serves as a DTO for all interrelated app objects 
 * @Author: Dan Crisologo
 * @Date Created: FEB-18-2014
 * @History:
   =====================================================================
        02-18 (Dan): Created.
        2015-08-24(Tony Xu): Update the create broker method to represent latest filter change to Application__c.Broker__c
   =====================================================================
 */ 
public class WS_TestApplicationBuilder {

    //Application-Related objects
    public Application__c application;
    public GEProduct__c product;
    
    //Applicant-Related objects
    public Applicant__c applicant1;
    public Applicant__c applicant2;

    public List<Income__c> incomeList;
    public List<Expense__c> expenseList;
    public List<Asset__c> assetList;
    public List<Liability__c> debtList;
    public List<Applicant_CLV__c> appCLVList;
    
    //private variables
    public Brand__c brand;
    public Product_Version__c productVersion;
    public ONR__c tableONR;
    public Branch__c branch;
    
    public Contact broker;
    public List<Disbursement__c> disList;
    public List<Related_Document__c> relatedDocument;
    public List<Product_Item__c> prodItemList;
    
    /*  *Description: Constructs main application data
        *Author: Dan Crisologo
        *Param: applicationType - determine if application is single or joint
                sourceChannel - configure if application channel is customer, sales or broker
        *return: None
    */
    public WS_TestApplicationBuilder (String applicationType,
                                      String acceptanceChannel,
                                      String sourceChannel) {
    
        initializeCustomSettings();
        createProductRecords();
        createDistrictAndBranch();
        createAccountAndBroker();
        
        this.application = new Application__c(Application_Type__c = applicationType,
                                         Acceptance_Channel__c = acceptanceChannel,
                                         Broker__c = this.broker.Id,
                                         Channel__c = sourceChannel,
                                         Product_Id__c = product.Id,
                                         Loan_Insurance_Consent__c = true,
                                         Interested_in_other_services__c = true,
                                         Credit_Card_Eligibility_Flag__c = true,
                                         Loan_Term_Months__c = 10,
                                         Total_Loan_Amount__c = 5000,
                                         Total_Loan_Interest_Amount_Payable__c = 5000,
                                         Total_Insurance_Interest_Amount_Payable__c = 2000,
                                         Offered_Interest_Rate__c = 5,
                                         Offered_Monthly_Loan_Service_Fee__c = 100,
                                         Correlation_ID__c = '123456789',
                                         FP_Black_Box__c = 'testbb',
                                         FP_IP_Address__c = 'testaddress',
                                         iOvation_Type__c = 'type',
                                         Fingerprint_Step__c = '5',
                                         Response_Code__c = 'SAR',
                                         Submission_Status__c = 'Not Submitted',
                                         Offered_PPSR_Registration_Fee__c = 1000.00,
                                         Offered_PPSR_Search_Fee__c = 1000.00,
                                         Out_Of_Sync__c = false,
                                         Is_Manager_Approved__c = true,
                                         Branch__c = this.branch.id);
        
        insert this.application;

        createResponseCodeControl(true,String.valueOf(application.Response_Code__c));
        
        List<Applicant__c> applicantList = new List<Applicant__c>();
        
        this.applicant1 = createApplicant('MrApplicant1',
                                          'Ruffles',
                                          this.application.Id,
                                          true);
        applicantList.add(this.applicant1);
        
        if(applicationType==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            this.applicant2 = createApplicant('MrApplicant1',
                                          'Ruffles',
                                          this.application.Id,
                                          false);
            applicantList.add(this.applicant2);
        }
        
        insert applicantList;
        
        createProductItem();
        createONR();
        createLoanPurpose();
        createAssetsAndLiabilities();
        createIncomes();
        
        expenseList = new List<Expense__c>();
        expenseList.add(createExpense(this.applicant1.id));
        if(applicationType==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            expenseList.add(createExpense(this.applicant2.id));
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Expense__c.SObjectType.getDescribe().isCreateable()) {
        //     insert expenseList;
        // }
        insert expenseList;
        createCLVs();
        createCollaterals();
        createDirectDebits();
        createFeesAndCharges();
        disList = new List<Disbursement__c>();
        disList.add(createDisbursement(Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId(),'Close',1000, GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP1));
        disList.add(createDisbursement(Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Direct Credit').getRecordTypeId(),'Reduce',1000, GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP1));
        if(applicationType==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            disList.add(createDisbursement(Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId(),'Reduce',2000, GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP2));
            disList.add(createDisbursement(Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId(),'Reduce',1000, GEN_OriginationsConstants.APP_APPLICABLE_PARTY_BOTH));
        } else {
            disList.add(createDisbursement(Schema.SObjectType.Disbursement__c.getRecordTypeInfosByName().get('Re-Finance').getRecordTypeId(),'Close',3000, GEN_OriginationsConstants.APP_APPLICABLE_PARTY_APP1));
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Disbursement__c.SObjectType.getDescribe().isCreateable()) {
        //     insert disList;
        // }
        insert disList;
        System.debug('disList-->'+disList);
        
        List<AML__c> amlList = new List<AML__c>();
        amlList.add(createAMLRecords(this.applicant1.Id));
        if(applicationType==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            amlList.add(createAMLRecords(this.applicant2.Id));
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(AML__c.SObjectType.getDescribe().isCreateable()) {
        //     insert amlList;
        // }
        insert amlList;

        relatedDocument = new List<Related_Document__c>();
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, 'Contract', 'Sent'));
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, 'O and Rs', 'Received'));
       relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_DIRECT_DEBIT, 'Received'));
       relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_LPI, 'Received'));
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_PRIVACY, 'Received'));
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_CLOSURE_AUTH, 'Received'));
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_PAYOUT_STATEMENT, 'Received'));                                  
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_IFREBATE, 'Received'));                                   
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_DISBURSEMENT_AUTH, 'Received'));                                  
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id, GEN_OriginationsConstants.DOCUMENT_TYPE_NZ_SIGNUP_LETTER, 'Received'));  
        relatedDocument.add(createRelatedDocument(this.applicant1.Id, this.application.Id,GEN_OriginationsConstants.DOCUMENT_TYPE_REDUCTION_AUTH, 'Received'));  
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Related_Document__c.SObjectType.getDescribe().isCreateable()) {
        //     insert relatedDocument;
        // }
        insert relatedDocument;
        Meta_Compliance_Check__c testMCC = TestDataBuilder.createMetaComplianceCheck();
        insert testMCC;

        List<Meta_Compliance_Check_Line_Item__c> testMCCLI_List = TestDataBuilder.createMetaComplianceCheckLinteItem(2, true, false, testMCC.Id);
        testMCCLI_List.get(1).Section__c = '0';
        insert testMCCLI_List;

        List<Meta_Compliance_Pre_Settle__c> testMCPreS_List = TestDataBuilder.createMetaCompliancePreSettle(2, true, false, testMCC.Id);
        testMCPreS_List.get(1).Section__c = '0';
        insert testMCPreS_List;
        
        List<Meta_Compliance_Post_Settle__c> testMCPostS_List = TestDataBuilder.createMetaCompliancePostSettle(2, true, false, testMCC.Id);
        testMCPostS_List.get(1).Section__c = '0';
        insert testMCPostS_List;

        Compliance_Check__c compliance = createComplianceCheckWithPreSettleIndicator(this.application.Id);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Compliance_Check__c.SObjectType.getDescribe().isCreateable()) {
        //     insert compliance;
        // }
        insert compliance;
        GEProduct__c lifeProduct = TestDataBuilder.createGEProductInsurance(this.Brand.Id, 'Life Insurance');
        insert lifeProduct;

        Product_Version__c lifeProductVersion = new Product_Version__c(GEProduct__c = lifeProduct.Id,
                                                Start_Date__c = Date.Today()-30,
                                                End_Date__c = Date.Today()+150);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Product_Version__c.SObjectType.getDescribe().isCreateable()) {                                        
        //     insert lifeProductVersion;
        // }
        insert lifeProductVersion;
        prodItemList = new List<Product_Item__c>();
        prodItemList.add(createProductItemInsurance(this.application.Id,lifeProductVersion.Id,'Life Insurance'));
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Product_Item__c.SObjectType.getDescribe().isCreateable()) {
        //     insert prodItemList;
        // }
        insert prodItemList;
        this.application.Out_Of_Sync__c = false;
        update this.application;
    }
    
    /*  *Description: Constructs webservice custom settings
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void initializeCustomSettings() {
    
        List<Web_Service_Settings__c> wss = new List<Web_Service_Settings__c>();
        wss.add(new Web_Service_Settings__c(Name ='Application Service Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OASS'));
        wss.add(new Web_Service_Settings__c(Name ='Certificate Name',
                                            Value__c = 'GE_TEST_CERT'));
        wss.add(new Web_Service_Settings__c(Name ='Customer Search Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OCSS'));
        wss.add(new Web_Service_Settings__c(Name ='Generate Document Endpoint',
                                            Value__c = 'https://www.testendpointtest.test/testEndpoint/OGDS'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Main Business Unit',
                                            Value__c = 'GE-TESTBU'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Mock Enabled Requested By',
                                            Value__c = 'SFDC_TEST1'));   
        wss.add(new Web_Service_Settings__c(Name ='General WS Timeout',
                                            Value__c = '10000'));
        wss.add(new Web_Service_Settings__c(Name ='Product Code Override - VIC',
                                            Value__c = '111'));                                                                        
        wss.add(new Web_Service_Settings__c(Name ='Requested By',
                                            Value__c = 'SFDC_TEST2'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name',
                                            Value__c = 'RequestedNameTest'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name Customer',
                                            Value__c = 'CustomerUI'));
        wss.add(new Web_Service_Settings__c(Name ='Requested Name Sales',
                                            Value__c = 'SalesUI'));                                    
        wss.add(new Web_Service_Settings__c(Name ='Service Version',
                                            Value__c = '0.0'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Broker',
                                            Value__c = 'AA1'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Customer',
                                            Value__c = 'AA2'));                                    
        wss.add(new Web_Service_Settings__c(Name ='SOLCode Sales',
                                            Value__c = 'AA3'));                                                                        
        wss.add(new Web_Service_Settings__c(Name ='Sub-Business Unit',
                                            Value__c = 'SubBusinessTest')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service App Submit',
                                            Value__c = 'TEST_CLASS')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service Customer Search',
                                            Value__c = 'TEST_CLASS2')); 
        wss.add(new Web_Service_Settings__c(Name ='Target Service Doc Generation',
                                            Value__c = 'TEST_CLASS2')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Base Endpoint',
                                            Value__c = 'http://endpoint2.testurl.test:port/')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Application',
                                            Value__c = 'oass')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Customer Search',
                                            Value__c = 'ocss')); 
        wss.add(new Web_Service_Settings__c(Name ='Webservice Endpoint - Documents',
                                            Value__c = 'odgs'));
        wss.add(new Web_Service_Settings__c(Name ='Max Retry', 
                                            Value__c = '1'));
        //DBHZL386 Tony Xu Added
        wss.add(new Web_Service_Settings__c(Name = 'Retrieve Payoff Figure Endpoint',
        									Value__c = 'https://sf2geservices-dev3.gemoney.com.au/PayOffQuote/PayOffQuoteService'));
        wss.add(new Web_Service_Settings__c(Name = 'Target Service Retrieve Payoff Figure',
        									Value__c = 'GE_PAYOFF_QUOTE'));
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Web_Service_Settings__c.SObjectType.getDescribe().isCreateable()) {									
        //     insert wss;
        // }
        insert wss;
        List<Webservice_Decline_Reasons__c> wdrList = new List<Webservice_Decline_Reasons__c>();
        wdrList.add(new Webservice_Decline_Reasons__c(Name ='sc1',
                                                      Reason_Name__c = 'SCORE � TD'));
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Webservice_Decline_Reasons__c.SObjectType.getDescribe().isCreateable()) {
        //     insert wdrList;
        // }
        insert wdrList;
        List<Insurance_Premium_Calculation_Variables__c> ipcvList = new List<Insurance_Premium_Calculation_Variables__c>();
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='counter',
                                                                    Value__c = 7.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabFee',
                                                                    Value__c = 20.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabGst',
                                                                    Value__c = 0.0500,
                                                                    Description__c = 'test'));                                                            
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='disabJoint',
                                                                    Value__c = 0.9000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='iuiFee',
                                                                    Value__c = 6.5000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='iuiGst',
                                                                    Value__c = 0.0500,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='lifeInsPremRate',
                                                                    Value__c = 0.075,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='lifeJoint',
                                                                    Value__c = 0.8000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='maxMonthlyEmi',
                                                                    Value__c =1500.0000,
                                                                    Description__c = 'test'));
        ipcvList.add(new Insurance_Premium_Calculation_Variables__c(Name ='maxPrincipal',
                                                                    Value__c = 100000.0000,
                                                                    Description__c = 'test'));
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Insurance_Premium_Calculation_Variables__c.SObjectType.getDescribe().isCreateable()) {
        //     insert ipcvList;
        // }
        insert ipcvList;
        List<Collateral_Settings__c> csList = new List<Collateral_Settings__c>();
        csList.add(TestDataBuilder.createCollateralSetting());
        insert csList;
    }
    
    /*  *Description: Constructs brand, products and product items
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createProductRecords() {
    
        //insert brands
        this.brand = new Brand__c(Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY,		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
                             External_ID__c = '123456789012345678',
                             Status__c = 'Active'
                            );
        insert this.brand;
        
        //insert product
        this.product = new GEProduct__c(Name = GEN_OriginationsConstants.BRAND_NAME_GEMONEY+'Personal Loan',		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
                                   Brands__c = brand.Id,
                                   GE_ProductId__c = '12345678901234567',
                                   Insurance_Type__c = 'Life Insurance',
                                   Logo_Id__c = '226',
                                   Logo_Id_Secured__c = '226',
                                   Org_Id__c = '000',
                                   Product_Name__c = 'Money AU Personal Loan',
                                   Type__c = 'Personal Loan');
        
        insert this.product;
        
        //insert product version
        this.productVersion = new Product_Version__c(GEProduct__c = product.Id,
                                                Start_Date__c = Date.Today()-30,
                                                End_Date__c = Date.Today()+150);
                                                
        insert this.productVersion;

    }
    
    /*  *Description: Create applicant record
        *Author: Dan Crisologo
        *Param: None
        *return: appFirstName, appLastName, applicationId, primaryApplicant
    */
    private Applicant__c createApplicant(String appFirstName,
                                         String appLastName,
                                         Id applicationId,
                                         Boolean primaryApplicant) {
                                        
        Applicant__c applicant = new Applicant__c(Application__c = applicationId,
                                                  POI_Amount_Verified_Frequency__c = 'Month',
                                                  POI_Verification_Type__c = 'Branch',
                                                  Is_Primary_Applicant__c = primaryApplicant,
                                                  Date_of_Birth__c = '05-05-1991',
                                                  Title__c = 'Mr',
                                                  First_Name__c = appFirstName,
                                                  Middle_Name__c = 'T',
                                                  Last_Name__c = appLastName,
                                                  Date_of_Birth_WS__c = '1991-05-05',
                                                  Gender__c = 'Male',
                                                  Rel_Status__c = 'Single',
                                                  Drivers_Lic_Flg__c = false,
                                                  Unit_No_Res__c = '50',
                                                  Street_No_Res__c = '55',
                                                  Street_Res__c = 'StrName',
                                                  Street_Type_Res__c = 'Ally',
                                                  Street_Type_Pos__c = 'Ally',
                                                  Street_Type_Pre__c = 'Ally',
                                                  Suburb_Res__c = 'Res Suburb',
                                                  Postcode_Res__c = '4321',
                                                  State_Res__c = 'QLD',
                                                  Country_Res__c = 'Australia',
                                                  Unit_No_Pos__c = '10',
                                                  Street_No_Pos__c = '15',
                                                  Street_Pos__c = 'StrName2',
                                                  Suburb_Pos__c = 'City',
                                                  Postcode_Pos__c = '4321',
                                                  State_Pos__c = 'QLD',
                                                  Country_Pos__c = 'Australia',
                                                  Postal_Addr_Flg__c = true,
                                                  Years_At_Addr__c = '2',
                                                  Months_At_Addr__c = '2',
                                                  Years_At_Prev_Addr__c = '1',
                                                  Months_At_Prev_Addr__c = '1',
                                                  Res_Status__c = 'Living with friends/family',
                                                  Mobile__c = '1234567890',
                                                  Home_Area_Code__c = '04',
                                                  Home_WS__c = '12345678',
                                                  Work_Area_Code__c = '04',
                                                  Work_WS__c = '12345678',
                                                  Pref_Contact_Method__c = 'Phone',
                                                  Email_Address__c = 't@t.com',
                                                  Unit_No_Pre__c = '20',
                                                  Street_No_Pre__c = '25',
                                                  Street_Pre__c = 'Pre Street',
                                                  Suburb_Pre__c = ' City',
                                                  Postcode_Pre__c = '4321',
                                                  State_Pre__c = 'QLD',
                                                  Country_Pre__c = 'Australia',
                                                  Accept_Terms_and_Conditions__c = true,
                                                  EIDV__c = 'Yes',
                                                  Total_Income__c = 5000,
                                                  Total_Expense__c = 1000,
                                                  Total_Assets__c = 25000,
                                                  Total_Debts__c = 500,
                                                  Additional_Income__c = 10000,
                                                  Primary_Employment_Status__c = 'Permanent (work over 20 hours per week)',
                                                  Previous_Employment_Status__c = 'Permanent (work over 20 hours per week)',
                                                  Time_at_previous_employer_years__c = 4,
                                                  Time_at_previous_employer_months__c = 1,
                                                  Prev_Emp_Bus_Name__c = 'test',        //DBHZL64 Tony Xu
                                                  Has_Uploaded__c = true);
        

        return applicant;
                                        
    }
    
    /*  *Description: Constructs onr
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createONR() {
        List<ONR__c> onrList = new List<ONR__c>();
        
        ONR__c onr = new ONR__c(application__c = this.application.id,
                                prompt__c = 'Consumer is open for other products?',
                                value__c = 'Yes',
                                type__c = 'YesOrNo');
        onrList.add(onr);
        
        this.tableONR = new ONR__c(application__c = this.application.id,
                                   type__c = 'Table',
                                   geId__c = GEN_OriginationsConstants.META_ID_PURPOSE_TABLE);
        onrList.add(this.tableONR);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(ONR__c.SObjectType.getDescribe().isCreateable()) {
        //     insert onrList;
        // }
        insert onrList;
    }
    
    /*  *Description: Constructs loan purpose
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createLoanPurpose() {
    
        List<Loan_Purpose__c> lpList = new List<Loan_Purpose__c>();
        Loan_Purpose__c lp = new Loan_Purpose__c();
        lp.Application__c = this.application.id;
        lp.Loan_Amount__c = 10000.00;
        lp.ONR__c = this.tableONR.Id;
        lp.Value__c = 'Household furnishings';
        lpList.add(lp);
        
        Loan_Purpose__c lp2 = new Loan_Purpose__c();
        lp2.Application__c = this.application.id;
        lp2.Loan_Amount__c = 5000.00;
        lp2.ONR__c = this.tableONR.Id;
        lp2.Value__c = 'Debt consolidation';
        lpList.add(lp2);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Loan_Purpose__c.SObjectType.getDescribe().isCreateable()) {
        //     insert lpList;
        // }
        insert lpList;
    }
    
    /*  *Description: Constructs assets and liabilities
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createAssetsAndLiabilities() {
    
        Id assetRecId = Schema.SObjectType.Asset__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
    
        assetList = new List<Asset__c>();
        
        Asset__c asset1 = new Asset__c(Asset_Value__c = 50000.00,
                                       Asset_Category__c = 'Caravan',
                                       Ownership_Status__c = 'Own outright',
                                       Total_Assets__c = 50000.00,
                                       recordTypeId = assetRecId,
                                       Applicant__c = this.applicant1.id
                                       );                
        assetList.add(asset1);
        
        Asset__c asset2 = new Asset__c(Asset_Value__c = 10000.00,
                                       Asset_Category__c = 'Superannuation',
                                       Ownership_Status__c = 'Own outright',
                                       Total_Assets__c = 10000.00,
                                       recordTypeId = assetRecId,
                                       Applicant__c = this.applicant1.id
                                       );
        assetList.add(asset2);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Asset__c.SObjectType.getDescribe().isCreateable()) {
        //     insert assetList;
        // }
        insert assetList;
        debtList = new List<Liability__c>();
        
        Liability__c debt1 = new Liability__c(Debt_Category__c = 'Personal loan',
                                              Type_of_Debt__c = 'test',     //DBHZL64 Tony Xu
                                              Financier_Name__c = 'Bank3',
                                              Car_Personal_Repay_Amt__c = 200.00,
                                              Car_Personal_Repay_Int__c = 'Fortnight',
                                              Car_Personal_Borrowed_Amt__c = 1000.00,
                                              Acknowledge_Payout__c = true,
                                              Car_Personal_Bal_Amt__c = 500.00,
                                              Applicant__c = this.applicant1.id,
                                              Original_Total_Debt_Monthly__c = 440.00);
        debtList.add(debt1);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Liability__c.SObjectType.getDescribe().isCreateable()) {
        //     insert debtList;
        // }
        insert debtList;
    }
    
    /*  *Description: Constructs income records
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createIncomes() {

        Id fullTimeRecId = Schema.SObjectType.Income__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
        Id contractingRecId = Schema.SObjectType.Income__c.getRecordTypeInfosByName().get('AU').getRecordTypeId();
    
        incomeList = new List<Income__c>();
    
        Income__c income1 = new Income__c(Applicant__c = this.applicant1.id,
                                          Income_Source__c = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_FULLTIME,
                                          Income_Amount__c = 2000.00,
                                          Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_WEEK,
                                          Occupation__c = 'Insurance',
                                          Emp_Bus_Name__c = 'Cloud Sherpas',
                                          Emp_Bus_Contact_No__c = '1234567890',
                                          Employer_Business_Contact_No_Area_Code__c = '02',
                                          Employer_Business_Contact_No_WS__c = '12345678',
                                          Months_With_Employer__c = 5,
                                          Years_With_Employer__c = 2,
                                          POI_Amount_Verified__c = 2000.00,
                                          Months_Self_Employed__c = 5,
                                          Years_Self_Employed__c = 2,
                                          Total_Income__c = 8000.00,
                                          Industry__c = 'Advertising',  //DBHZL64 Tony Xu
                                          recordTypeId = fullTimeRecId);
        
        incomeList.add(income1);
        
        if(this.application.Application_Type__c==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            Income__c income2 = new Income__c(Applicant__c = this.applicant2.id,
                                              Income_Source__c = GEN_OriginationsConstants.INCOME_SOURCE_PERMANENT_PARTTIME,
                                              Income_Amount__c = 10000.00,
                                              Income_Interval__c = GEN_OriginationsConstants.PAYMENT_INTERVAL_MONTH,
                                              Occupation__c = 'Contracting',
                                              Emp_Bus_Name__c = 'SMART',
                                              Emp_Bus_Contact_No__c = '1234567890',
                                              Employer_Business_Contact_No_Area_Code__c = '02',
                                              Employer_Business_Contact_No_WS__c = '12345678',
                                              Months_With_Employer__c = 3,
                                              Years_With_Employer__c = 3,
                                              POI_Amount_Verified__c = 10000.00,
                                              Months_Self_Employed__c = 2,
                                              Years_Self_Employed__c = 7,
                                              Total_Income__c = 10000.00,
                                              recordTypeId = contractingRecId);
            incomeList.add(income2);
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Income__c.SObjectType.getDescribe().isCreateable()) {
        //     insert incomeList;
        // }
        insert incomeList;
    }
    
    /*  *Description: Constructs expenditures
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private Expense__c createExpense(Id applicantId) {
        Expense__c expense = new Expense__c(Applicant__c = applicantId,
                                            Living_Exp__c = 300.00,
                                            Living_Exp_Int__c = 'Month',
                                            Total_Exp__c = 300.00);                                       

        return expense;
    }
    
    /*  *Description: Constructs clv records
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createCLVs() {
    
        appCLVList = new List<Applicant_CLV__c>();
        
        Applicant_CLV__c appCLV = new Applicant_CLV__c(Applicant__c = this.applicant1.id,
                                                       CLV__c = '1234567890123456',
                                                       ICBS_Customer_ID__c = '3213213321312313',
                                                       GE_Contact_ID__c = '123123123123123123',
                                                       Date_of_Birth__c = '09-09-1990',
                                                       Drivers_License__c = '93847914320984',
                                                       Title__c = 'Miss',
                                                       First_Name__c = 'CLVRec',
                                                       Middle_Name__c = 'L',
                                                       Surname__c = 'CLVSur',
                                                       Work__c = '041234999543',
                                                       Mobile__c = '041234567890',
                                                       Home__c = '0273849528',
                                                       Street_Address__c = 'testAddr',
                                                       Suburb__c = 'city',
                                                       State__c = 'QLD',
                                                       Post_Code__c = '4321');
        appCLVList.add(appCLV);
        if(this.application.Application_Type__c==GEN_OriginationsConstants.APPLICATION_TYPE_JOINT) {
            Applicant_CLV__c appCLV2 = new Applicant_CLV__c(Applicant__c = this.applicant2.id,
                                                       CLV__c = '9999444433332222',
                                                       ICBS_Customer_ID__c = '1111222233334444',
                                                       GE_Contact_ID__c = '1234432112344321',
                                                       Date_of_Birth__c = '10-09-1992',
                                                       Title__c = 'Miss',
                                                       First_Name__c = 'CLVRec2',
                                                       Middle_Name__c = 'D',
                                                       Surname__c = 'CLVSur2',
                                                       Work__c = '041234999543',
                                                       Mobile__c = '041234567890',
                                                       Home__c = '0273849528',
                                                       Street_Address__c = 'testAddr2',
                                                       Suburb__c = 'city2',
                                                       State__c = 'VIC',
                                                       Post_Code__c = '1234');
                                                       
            appCLVList.add(appCLV2);
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Product_Item__c.SObjectType.getDescribe().isCreateable()) { 
        //     insert appCLVList;
        // }
        insert appCLVList;
        
        Id icbsRecType = Schema.SObjectType.Applicant_Account__c.getRecordTypeInfosByName().get('ICBS').getRecordTypeId();
        Applicant_Account__c appAcc = new Applicant_Account__c(Account_Number__c = '453543564564756',
                                                               Selected_ICBS_Customer_Number__c = '453543564564756',
                                                               Applicant_CLV__c = appCLV.Id,
                                                               Account_Balance__c = '1000.00',
                                                               RecordTypeId = icbsRecType);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Applicant_CLV__c.SObjectType.getDescribe().isCreateable()) {                                                       
        //     insert appAcc;
        // }
        insert appAcc;
        
    }
    
    /*  *Description: Constructs clv records
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createCollaterals() {
        
        Id motorcycleRecId = Schema.SObjectType.Collateral__c.getRecordTypeInfosByName().get('Motorcycle').getRecordTypeId();
    
        Collateral__c collateral = new Collateral__c(Collateral_Reg_No__c = '2123131313212',
                                                     Collateral_VIN_No__c = '1112223334444',
                                                     Collateral_HIN_Number__c = '000999888777762',
                                                     Collateral_Eng_No__c = '888444333999234',
                                                     Collateral_Year__c = String.valueOf(Date.Today().Year()-1),
                                                     Collateral_Model__c = 'Test Model',
                                                     Collateral_Val__c = 1000.00,
                                                     Collateral_Body_Type__c = 'MOTOR CYCLE',
                                                     Collateral_State_of_Registration__c = 'QUEENSLAND',
                                                     Collateral_Insurance_expiry_date__c = Date.Today()+100,
                                                     Collateral_Date_Valued__c = Date.Today(),
                                                     Collateral_Total_Value__c = 1000.00,
                                                     Collateral_Insurance_Policy_number__c = '5555555',
                                                     Collateral_Insurance_company_name__c = 'Mugiwara CS',
                                                     Collateral_NVIC__c = '88447755660011',
                                                     Collateral_Type__c = 'Boats',
                                                     Collateral_Make__c = 'MONARCH',
                                                     Collateral_Owner__c = 'Applicant 1',
                                                     Application__c = this.application.id,
                                                     PPSR_Reference_Number_1__c = '123456789012345',
                                                     RecordTypeId = motorcycleRecId);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Collateral__c.SObjectType.getDescribe().isCreateable()) {
        //     insert collateral;
        // }
        insert collateral;
    }
    
    /*  *Description: Constructs Debit record
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createDirectDebits() {
        Id directDebitRecType = Schema.SObjectType.Debit__c.getRecordTypeInfosByName().get(GEN_OriginationsConstants.DEBIT_RECORD_DIRECTDEBIT).getRecordTypeId();
        
        BSB__c bsb = new BSB__c();
        bsb.Name = '123456';
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(BSB__c.SObjectType.getDescribe().isCreateable()) {
        //     insert bsb;
        // }
        insert bsb;
        Debit__c debit = new Debit__c(Application__c = this.application.id,
                                      RecordTypeId = directDebitRecType,
                                      Type__c = 'Direct Debit',
                                      Account_Holders__c = 'Mr Tester',
                                      Bank_Name__c = 'Universal Bank of the Universe',
                                      Branch_Location__c = 'Uranus',
                                      BSB_Number__c = bsb.Name,
                                      Account_Number__c = '12345678',
                                      Frequency__c = 'D7',
                                      Specify_Higher_Amount__c = 50000.00,
                                      Commencement_Date__c = Date.Today());
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Debit__c.SObjectType.getDescribe().isCreateable()) {
        //     insert debit; 
        // }
        insert debit; 
    }
    
    /*  *Description: Constructs Fees and Charges
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createFeesAndCharges() {
        
        //Query all fee types that are required for webservice
        Set<String> feesToInsert = new Set<String>();
        feesToInsert.add(GEN_OriginationsConstants.FEE_ESTABLISHMENT);
        feesToInsert.add(GEN_OriginationsConstants.FEE_PPSR_SEARCH);
        feesToInsert.add(GEN_OriginationsConstants.FEE_PPSR_REGISTRATION);
        feesToInsert.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION1);
        feesToInsert.add(GEN_OriginationsConstants.FEE_EARLY_TERMINATION2);
        feesToInsert.add(GEN_OriginationsConstants.FEE_PAYMENT_HANDLING);
        feesToInsert.add(GEN_OriginationsConstants.FEE_LOAN_SERVICE);
        feesToInsert.add(GEN_OriginationsConstants.FEE_LATE_PAYMENT);
        
        List<Fees_Charges__c> feesAndChargesList = new List<Fees_Charges__c>();
        
        for(String f: feesToInsert) {
            Fees_Charges__c fc = new Fees_Charges__c(Fee_Amount__c = 200.00,
                                                     Fee_Type__c = f,
                                                     Effective_Start_Date__c = Date.Today()-100,
                                                     Effective_End_Date__c = Date.Today() + 100,
                                                     Low_Value__c = 10.00,
                                                     High_Value__c = 999999.99,
                                                     Product_Version__c = this.productVersion.Id);
        
            feesAndChargesList.add(fc);
        
        }
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Fees_Charges__c.SObjectType.getDescribe().isCreateable()) {
        //     insert feesAndChargesList;
        // }
        insert feesAndChargesList;
    }
    
    /*  *Description: Constructs AML Records
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private AML__c createAMLRecords(Id applicantId) {
    
        return new AML__c(Applicant__c = applicantId,
                          Id_Sequence_No__c = 1,
                          Staff_ID_Sighted_By__c = 'Mr Sales Tester',
                          Staff_ID_SSO__c = '1234512345',
                          Date_Verified__c = Date.today(),
                          AML_Pos_Verified_Type__c = 'Certified Document',
                          Identification__c = 'Birth Certificate',
                          ID_No__c = '777888999000111',
                          ID_Issue_Date__c = Date.today(),
                          ID_Expiry_Date__c = Date.today(),
                          ID_Expiry_State__c = 'NSW',
                          Issue_Country__c = 'Australia',
                          ID_Issuer__c = 'Mr Issuer');

    }
    
    /*  *Description: Constructs Branch record
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createDistrictAndBranch() {
    
        District__c district = new District__c(Name = '',
                                               External_ID__c = 'tst123');
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(District__c.SObjectType.getDescribe().isCreateable()) {
        //     insert district;
        // }
        insert district;
        this.branch = new Branch__c(District__c = district.id,
                                    Branch_Id__c = '000',
                                    Phone__c = '1234 5678 9012',
                                    Fax__c = '1234 5678',
                                    Primary_Contact__c = UserInfo.getUserId(),
                                    Name = 'BRANCHNAME',
                                    Suburb__c = 'BranchSuburb',
                                    State__c = 'QLD',
                                    Postcode__c = '4321',
                                    Address__c = '123 St',
                                    Country__c = 'AUS');
                                    
        
        insert this.branch;

    }
    
    /*  *Description: Constructs Product Item record
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createProductItem() {

        Product_Item__c productItem = new Product_Item__c(Application__c = this.application.Id,
                                                          Policy_Type__c = 0,
                                                          Ins_Term__c = 12,
                                                          Product_Version__c = this.productVersion.Id,
                                                          Fixed_Premium_Amount__c = 500.00,
                                                          Insurance_GST__c = 800.00,
                                                          Insurance_Stamp_Duty__c = 200.00);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Product_Item__c.SObjectType.getDescribe().isCreateable()) {
        //     insert productItem;
        // }
        insert productItem;
    }
    
    /*  *Description: Create broker and account record
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private void createAccountAndBroker() {
    	/**TXU update to represent latest broker lookup filter Start**/
        Id brokerRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Originations - Broker').getRecordTypeId();
    	Id contactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('APAC Contact').getRecordTypeId();
    	
    	
        Account brokerAccount = new Account(Name = 'Broker Account',
                                            Trust_Entity_Name__c = 'Entity Name',
                                            Aggregator_Account_Name__c = 'Aggregator Acc Name',
                                            recordTypeId = brokerRecType);
        //check if user has insert access before performing DML insert - Marvin @ JAN.18.2016 (Code Scan/Security Issues) - CHECKMARX
        // if(Account.SObjectType.getDescribe().isCreateable()) {                                    
        //     insert brokerAccount;
        // }
        insert brokerAccount;
        this.broker = new Contact(AccountId = brokerAccount.Id,
                                     firstName = 'TestName',
                                     lastName = 'TestLastName',
                                     MailingCity = 'TestCity',
                                     MailingState = 'Melbourne',
                                     MailingPostalCode = '4321',
                                     HomePhone = '1234567890',
                                     MobilePhone  = '1234567890',
                                     Contact_Accreditation_Status__c = 'Active',
                                     Broker_Product__c = GEN_OriginationsConstants.PL_BROKER_PRODUCT_FILTER,		//MLASALA: 21-MAR-16 TQLQW-127 Re-brand
                                     recordTypeID = contactRecType,
                                     primary_contact__c = true);
        
        insert this.broker;
        
    }

    /*
    Author: Jade Serrano
    Created Date: 30/04/2014
    Description: Create Response Code Control
    */
    private void createResponseCodeControl(Boolean status, String responseCode){

        Response_Code_control__c rcc = TestDataBuilder.createResponseCodeControl(status, responseCode);

        insert rcc;
        
    }
    
    /*  *Description: Create disbursement record related to the application
        *Author: Dan Crisologo
        *Param: None
        *return: None
    */
    private Disbursement__c createDisbursement(Id disbursementRecType, String outcome, Decimal amount, String applicableParty){

        Disbursement__c disbursement = new Disbursement__c(BSB__c = '123456', 
                                                          Bank_Acc_No__c =  '453543564564756', 
                                                          Amount__c = amount,
                                                          GE_Debt__c = false,
                                                          Disbursement_Outcome__c = outcome,
                                                          Disbursement_Adj_Amt__c = 1029421,
                                                          Disbursement_Outcome_Comments__c = 'Test Comments',
                                                          Fin_Institution__c = 'Test Fin',
                                                          Financial_Institution_Postcode__c = '1234',
                                                          Application__c = this.application.id,
                                                          Applicable_Party__c = applicableParty,
                                                          Payee__c = 'TestPayee',
                                                          Interest_Rate__c = 10,
                                                          RecordTypeId = disbursementRecType);
         return disbursement;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 17/03/2014
    Description: create Related Document Record
    */
    private Related_Document__c createRelatedDocument(Id applicantId, Id applicationId, String type, String status){
        Related_Document__c relatedDocument = new Related_Document__c();
        relatedDocument.GE_Document_ID__c = 'Sent';
        relatedDocument.Status__c = status;
        relatedDocument.Type__c = type;
        //relatedDocument.isAccepted__c = true;
        
        relatedDocument.GE_Link_Type__c = 'Evolve';
        relatedDocument.Document_Category__c = 'Loan Documents';
        relatedDocument.Applicant__c = applicantId;
        relatedDocument.Application__c = applicationId;
        relatedDocument.Title__c = type;
        relatedDocument.Template_Name__c = 'AussieContract';
        return relatedDocument;
    }

    /*
    Author: Fel Saliba Cloud Sherpas
    Created Date: 18/03/2014
    Description: create Product Item Record
    */
    private Product_Item__c createProductItemInsurance(Id applicationId, String prodVersion, String type){
        Product_Item__c productItem = new Product_Item__c();
        productItem.Application__c = applicationId;
        productItem.Applicant1__c = this.applicant1.Id;
        productItem.Insurance_Stamp_Duty__c = 0.0200;
        productItem.Insurance_Stamp_Duty_Amount__c = 1.60;
        productItem.Fixed_Premium_Amount__c = 81.70; 
        productItem.Product_Version__c = prodVersion;
        return productItem;
    }

    /*
    Author: Russell Cadapan Cloud Sherpas
    Created Date: 01/11/2013
    Description: Create Compliance Check Record
    */
    public static Compliance_Check__c  createComplianceCheckWithPreSettleIndicator(Id applicationId){
        Compliance_Check__c compliance = new Compliance_Check__c();
        compliance.Application__c = applicationId;
        compliance.BM_Check__c = 'Yes';
        compliance.BM_ID__c = 'BMUser123';
        compliance.BM_Only__c = true;
        compliance.PFR_Date__c = Date.today();
        compliance.BM_Date__c = Date.Today();
        compliance.PFR_Check__c = 'Yes';
        compliance.PFR_ID__c = 'SamplePFR123';
        compliance.PFR_Only__c = true;
        compliance.PFR_User_ID__c = 'PFRUser123';
        compliance.Pre_Settlement_Indicator__c = true;
        return compliance;
    }

}