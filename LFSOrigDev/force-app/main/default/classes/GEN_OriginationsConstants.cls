/*
 * @Description: Holds non-custom setting constant values for GE Originations
 * @Author: Dan Crisologo
 * @Date Created: OCT-21-2013
 * @History:
   =====================================================================
       10-21-13: Created. - Dan
       02-13-14: Added variables from custom labels - Mike
       03-13-14 Added Phone Regex
       11-03-14 Added new Income Source for DBHZL34- Tony xu
       12-01-14 Added NZ Application Extract Template Name for DBHZL64  - Tony Xu
       12-10-14 Added constants for asset categories and ownership status for DBHZL-143-Devendra
       05-06-15: Updated Defect 1389 - Updated FIN_INTSTITUTION_KIWI_BANK constant to Kiwibank from kiwi bank
       08-03-15: Added new constant for business source - Marvin David
       08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
       08-13-15: PMIHM 1922 - ADDED NEW APPLICATION STATUS ABANDONED - DYU
       02-16-16: TQLQW-10 - ADDED CONSTANTS FOR POI DOCUMENT TYPES - DYU
       2016-02-26: TOM - ADDED CONSTANTS FOR RESPONSE CODE - TONY XU
   =====================================================================
 */ 
public class GEN_OriginationsConstants {

    //ONR Type
    public static final String ONR_GENERAL = 'General';
    public static final String ONR_LOAN_PURPOSE = 'Loan Purpose';

    public static final String ONR_TYPE_CHOICE = 'Choice';
    public static final String ONR_TYPE_TEXT = 'Text';
    public static final String ONR_TYPE_YESNO = 'YesOrNo';
    public static final String ONR_TYPE_AMOUNT = 'Amount';
    public static final String ONR_TYPE_TABLE = 'Table';
    
    public static final String ONR_STATUS_KNOWN = 'Known';
    public static final String ONR_STATUS_INADMISSIBLE= 'Inadmissible';

    public static final String ONR_PROMPT_AMOUNT = 'Amount Requested';
    public static final String ONR_PROMPT_LOAN_PURPOSE = 'Purposes of Loan';
    public static final String ONR_PROMPT_DESCRIPTION = 'Description';
    
    public static final String META_ID_INTERESTED_IN_OTHER_SERVICES = '/personal/need/openToOtherProduct';
    public static final String META_ID_PURPOSE_TABLE = '/personal/need/purposeTable';
    public static final String META_ID_PURPOSE = '/personal/need/purpose_int1_int2';
    public static final String META_ID_OTHER_PURPOSE = '/personal/need/otherPurpose_int1_int2';
    public static final String META_ID_REQUESTED_AMOUNT = '/personal/need/requestedAmount_int1_int2';

    public static final Integer SALES_INPUT_PURPOSE_SUFFIX = 0;
    public static final Integer SALES_INPUT_AMOUNT_SUFFIX  = 1;
    public static final Integer SALES_INPUT_OTHER_PURPOSE_SUFFIX  = 2;
    
    public static final String OFFER_TYPE_SECURED_DOWNSELL = 'Secured Downsell';
    public static final String OFFER_TYPE_SECURED_UPSELL = 'Secured Upsell';
    public static final String OFFER_TYPE_UNSECURED_DOWNSELL = 'Unsecured Downsell';
    public static final String OFFER_TYPE_UNSECURED_UPSELL = 'Unsecured Upsell';
    public static final String OFFER_TYPE_PROMPTED_DEBT_CONSOLIDATION = 'Prompted Debt Consolidation';
    
    public static final String APP_SUBMITTION_STATUS_SUBMITTED = 'Submitted';
    public static final String APP_SUBMITTION_STATUS_RESPONSE_RECEIVED = 'Response Received';
    public static final String APP_SUBMITTION_STATUS_SERVICE_UNAVAILABLE = 'Service Unavailable';
    public static final String APP_SUBMITTION_STATUS_NOT_SUBMITTED = 'Not Submitted';
    public static final String APP_SUBMITTION_STATUS_SUBMIT_FAILURE = 'Submission Failure';
    public static final String APP_SUBMITTION_STATUS_RETRY_IN_PROGRESS = 'Retry Pending';
    
    public static final String APP_RESPONSE_CODE_CANCELLED = 'Cancelled';
    public static final String APP_RESPONSE_CODE_DECLINED = 'Declined';    
    public static final String APP_RESPONSE_CODE_CLOSEDCANCEL = 'FIC';
    public static final String APP_RESPONSE_CODE_CLOSEDDECLINED = 'FID';
    public static final String APP_RESPONSE_CODE_SUBMITFAILURE = 'SF';
    public static final String APP_RESPONSE_CODE_SERVICEUNAVAILABLE = 'SU';
    public static final String APP_RESPONSE_CODE_SUCCESS = 'SUS01000';
    public static final String APP_RESPONSE_CODE_NEW = 'New';
    public static final String APP_RESPONSE_CODE_PCA = 'PCO';
    public static final String APP_RESPONSE_CODE_RETRY = 'RET';
    public static final String APP_RESPONSE_CODE_ACCEPTED = 'FIA';
    public static final String APP_RESPONSE_CODE_PENDING_FIA = 'Pending FIA';
    public static final String APP_RESPONSE_CODE_PCA_PENDING_APPLICANT1 = 'PCO Applicant 1 Pending';
    public static final String APP_RESPONSE_CODE_PCA_PENDING_APPLICANT2 = 'PCO Applicant 2 Pending';
    
    public static final String APP_STATUS_CLOSED = 'Closed';
    public static final String APP_STATUS_DECLINED = 'Declined';
    public static final String APP_STATUS_FINALIZED = 'Accepted';
    public static final String APP_STATUS_ABANDONED = 'Abandoned'; //ADDED BY DYU 13-AUG-2015 PMIHM 1922
    
    public static final String APPLICANT_TYPE_PRIMARY = 'primary';
    public static final String APPLICANT_TYPE_SECONDARY = 'secondary';
    
    public static final String APPLICANT_TYPE_PRIMARY_ABBR = 'PRI';
    public static final String APPLICANT_TYPE_SECONDARY_ABBR = 'SEC';
    
    public static final String UI_PARAMETER_STAFF = 'S';
    public static final String UI_PARAMETER_CUSTOMER = 'C';
    
    public static final String CHOICE_YES = 'Yes';
    public static final String CHOICE_NO = 'No';
    
    public static final String DOCUMENT_CATEGORY_POI = 'POI';
    public static final String DOCUMENT_CATEGORY_LOAN = 'Loan Documents';   
    public static final String DOCUMENT_CATEGORY_INTERNAL = 'Internal'; 
    
    public static final String DOCUMENT_TYPE_CONTRACT = 'Contract'; 
    public static final String DOCUMENT_TYPE_ONR = 'O and Rs'; 
    public static final String DOCUMENT_TYPE_LPI = 'LPI'; 
    public static final String DOCUMENT_TYPE_DIRECT_DEBIT = 'Direct Debit';
    public static final String DOCUMENT_TYPE_DIRECT_DEBIT_NZ = 'Direct Debit Form'; 
    public static final String DOCUMENT_TYPE_PRIVACY = 'Privacy'; 
    public static final String DOCUMENT_TYPE_CLOSURE_AUTH = 'Closure Authority'; 
    public static final String DOCUMENT_TYPE_REDUCTION_AUTH = 'Decrease Authority';
    public static final String DOCUMENT_TYPE_PAYOUT_STATEMENT = 'Payout Statement'; 
    public static final String DOCUMENT_TYPE_IFREBATE = 'IF Rebate Letter'; 
    public static final String DOCUMENT_TYPE_DISBURSEMENT_AUTH = 'Disbursement Authority';
    public static final String DOCUMENT_TYPE_COPY_OF_APPLICATION = 'Copy of Application';
    public static final String DOCUMENT_TYPE_NZ_SIGNUP_LETTER = 'SignUp Letter KiwiBank';
    public static final String DOCUMENT_TYPE_GEMONEY_NZ_SIGNUP_LETTER = 'SignUp Letter';
    
    public static final String DOCUMENT_TEMPLATENAME_APPEXTRACT = 'ApplicationExtract';    
    public static final String DOCUMENT_TEMPLATENAME_APPEXTRACT_NZ = 'ApplicationExtractNZ';
    
    public static final String DOCUMENT_SECTION_APPEXTRACT = 'Copy of Application';
    
    public static final String DOCUMENT_LINK_TYPE_GENERATED = 'Generated Document';
    
    public static final String MESSAGECODE_NORESULT_FOUND = '5555';

    public static final String APPLICATION_CHANNEL_BROKER = 'Broker';
    public static final String APPLICATION_CHANNEL_SALES = 'Sales';
    public static final String APPLICATION_CHANNEL_ONLINE = 'Online'; 
    public static final String APPLICATION_CHANNEL_3RD_PARTY = '3rd Party Application';    
    
    public static final String APPLICATION_SOURCE_WALKIN = 'WALK-IN';
    public static final String APPLICATION_SOURCE_INTERNET = 'INTERNET';
    public static final String APPLICATION_SOURCE_REFERRAL = 'PERSONAL LOAN REFERRAL CENTRE'; 
    public static final String APPLICATION_SOURCE_PICSTARTER = 'PicStarter'; //TQLQW-481 [PL - AU] PicStarter - MDAVID - 9/01/2016 
    
    public static final String ACCEPTANCE_CHANNEL_OFFLINE = 'offline';
    public static final String ACCEPTANCE_CHANNEL_ONLINE = 'online';  
    
    public static final String APPLICATION_TYPE_JOINT = 'Joint';
    public static final String APPLICATION_TYPE_SINGLE = 'Single';
    public static final String APPLICATION_PAYMENT_FREQUENCY = 'Monthly';
    
    public static final String RELATED_DOCUMENT_STATUS_DRAFT = 'Draft';
    
    public static final String RELATED_DOCUMENT_LINKTYPE_EVOLVE = 'Evolve';

    public static final String ERR_MESSAGE_WORKFLOW_NO_LONGER_EXISTS = 'Close application workflow no longer exists.';
    public static final String ERR_MESSAGE_APPID_NOT_FOUND = 'Application ID not found: ';
    public static final String ERR_MESSAGE_APPLICANTID_NOT_FOUND = 'No primary applicant found for application ID: ';
    public static final String ERR_MESSAGE_CONTACT_ADMIN_EXCEPTION = 'An internal error has occured. Please contact your Administrator.';
    
    public static final String SERVICENAME_GENERATEAPPEXTRACT = 'Generate Document(Application Extract)';
    public static final String SERVICENAME_GENERATEDOCUMENT = 'Generate Document';
    public static final String SERVICENAME_CANCELDECLINE = 'Cancel/Decline Application';
    //Added part of Soft Quote code changes 
    public static final String SERVICENAME_QUOTESUBMIT = 'Submit Quote';
    public static final String SERVICENAME_INTEREST_RATE_UPDATE = 'Interest Rate Update';
    public static final String SERVICENAME_QUOTEINTERESTUPDATE = 'Quote Partial Interest Update';
    public static final String SERVICENAME_SUBMIT = 'Submit Application';
    public static final String SERVICENAME_UPDATE = 'Update Application';
    public static final String SERVICENAME_CUSTOMERSEARCH = 'Customer Search';
    public static final String SERVICENAME_ACCOUNTSEARCH = 'Customer Account Search';
    public static final String SERVICENAME_VERIFYAML = 'Verify AML';
    public static final String SERVICENAME_VERIFYPOI = 'Verify POI';
    public static final String SERVICENAME_VERIFY_CAPACITY = 'Verify Capacity';
    public static final String SERVICENAME_ACCEPTCONTRACT = 'Accept Contract';
    public static final String SERVICENAME_CONFIRMCONTRACTRECEIVED = 'Confirm Contract Received';
    public static final String SERVICENAME_GENERATEPAYOFFFIGURE = 'Generate Payoff Figure'; //Tony Xu DBHZL386
    public static final String SERVICENAME_APPROVEAPPLICATION = 'Approve Application'; //Adrian Recio: New constant for approve application service used in IS_ApproveApplication class

    //Added part of Soft Quote code changes 
    public static final String WSCLASS_QUOTESUBMIT = 'IS_QuoteSubmitUpdate';
    public static final String WSCLASS_SUBMIT = 'IS_ApplicationSubmit';
    public static final String WSCLASS_UPDATE = 'IS_ApplicationUpdate';
    public static final String WSCLASS_ACCEPTCONTRACT = 'IS_AcceptContract';
    public static final String WSCLASS_CANCELDECLINE = 'IS_ApplicationCancel';
    public static final String WSCLASS_CONTRACTRECEIVED = 'IS_ConfirmContractReceived';
    public static final String WSCLASS_APPEXTRACT = 'IS_GenerateApplicationExtract';
    public static final String WSCLASS_GENERATEDOC = 'IS_GenerateDocument';
    public static final String WSCLASS_VERIFYAML = 'IS_VerifyAML';
    public static final String WSCLASS_VERIFYPOI = 'IS_VerifyPOI';
    public static final String WSCLASS_CUSTOMERSEARCH = 'IS_CustomerSearch';
    public static final String WSCLASS_GENERATEPAYOFFFIGURE = 'IS_GeneratePayoffFigure'; //DBHZL386 Tony Xu
    public static final String WSCLASS_APPROVEAPPLICATION = 'IS_ApproveApplication'; // Adrian Recio: New constant for approve application service used in IS_ApproveApplication class
    
    public static final String WS_STATUS_FAILED = 'Failed';
    public static final String WS_STATUS_RETRYPENDING = 'Retry Pending';
    public static final String WS_STATUS_SENT = 'Sent';
    public static final String WS_STATUS_RESPONSERECEIVED = 'Response Received';

    public static final String MESSAGE_VARIABLE_OPERATION = 'VAR_LAST_OP';
    public static final String MESSAGE_VARIABLE_DESCRIPTION = 'VAR_ERR_DESC';

    public static final String MESSAGE_CODE_SUCCESS = '0000';
    public static final String MESSAGE_CODE_OTHEREXCEPTION = '9998';
    public static final String MESSAGE_CODE_CALLOUTEXCEPTION = 'ERS01001';
    public static final String MESSAGE_CODE_SFTIMEOUTEXCEPTION = '9996';
    public static final String MESSAGE_CODE_PRESUBMIT_EXCEPTION = '9995';
    
    public static final String WSCODE_SUCCESS = '00';
    //public static final String WSCODE_SUCCESS2 = 'SYIN00';
    public static final String WSCODE_SUCCESS2 = 'SUS01000'; 
    public static final String WSCODE_SU = '01';
    public static final String WSCODE_SU2 = 'ERSYIN01'; //System Unavailable
    public static final String WSCODE_SYSTEM_ERROR = 'ERSYIN02'; //System Error
    public static final String WSCODE_DOCGEN_RETRYABLE = 'ERDG01'; 
    public static final String WSCODE_DOCGEN_SUCCESS= 'DG00'; 
    
    public static final String RETRY_STATUS_PENDING = 'Pending';
    public static final String RETRY_STATUS_SUCCESS = 'Successful';
    public static final String RETRY_STATUS_FAILED = 'Failed';
    
    public static final String CUSTOMER_STAFF_ID = '888888888';
    public static final String CUSTOMER_STAFF_NAME = 'Online';
    public static final String CUSTOMER_BRANCH_NUMBER = '998';
    public static final String BROKER_CUSTOMER_STAFF_ID = '99999999';
    public static final String BROKER_CUSTOMER_STAFF_NAME = 'Online Broker';
    
    public static final String FEE_ESTABLISHMENT = 'Establishment Fee';   
    public static final String FEE_PPSR_SEARCH = 'PPSR Search Fee';
    public static final String FEE_PPSR_REGISTRATION = 'PPSR Registration Fee';
    public static final String FEE_EARLY_TERMINATION1 = 'Early Termination Fee 1';
    public static final String FEE_EARLY_TERMINATION2 = 'Early Termination Fee 2';
    public static final String FEE_PAYMENT_HANDLING = 'Payment Handling Fee';
    public static final String FEE_LOAN_SERVICE = 'Loan Service Fee';
    public static final String FEE_LATE_PAYMENT = 'Late Payment Fee';
    
    public static final String ONLINE_ACCEPTANCE = 'Online Acceptance';
    public static final String OFFLINE_ACCEPTANCE = 'Offline Acceptance';
    
    public static final String DISBURSEMENT_RECORD_REFINANCE = 'Re-Finance';
    public static final String META_ONR_VALUE_REFINANCE = 'Refinance';
    
    public static final String DEBIT_RECORD_DIRECTDEBIT = 'Direct Debit';

    public static final String PRODUCT_NAME_GELOAN = 'Latitude Personal Loan';      //MLASALA 16-JUN-16 DEFECT 918 FIX
    
    public static final String PRODUCT_TYPE = 'Personal Loan';
    public static final String PRODUCT_TYPE_AUTO_LOAN = 'Auto Loan';
    public static final String PRODUCT_TYPE_INSURANCE = 'Insurance';

    public static final String APPLICANT_STATE_VIC = 'VIC';

    public static final String PAGE_ELIGIBILITY = 'Eligibility';
    public static final String PAGE_INCOME = 'Employment and Income';
    public static final String PAGE_INCOME1 = 'Income';
    public static final String PAGE_ASSET = 'Assets';
    public static final String PAGE_DEBT = 'Debts';
    public static final String PAGE_DEBTS = 'DebtAndLiabilities';
    public static final String PAGE_ABOUTME = 'Personal details';
    public static final String PAGE_PERSONAL = 'PersonalDetails';
    public static final String PAGE_EXPENSE = 'Expenses';
    public static final String PAGE_MAIN = 'Main';
    public static final String PAGE_CUIFILEUPLOAD = 'CustomerUIFileUpload';
    public static final String PAGE_CUICONTRACTACCEPTANCE = 'ContractAcceptance';
    
    public static final String RESIDENTIAL_STATUS_RENTING = 'Renting';
    public static final String RESIDENTIAL_STATUS_LIVING_FRIEND_FAMILY = 'Boarding with Parents';
    public static final String RESIDENTIAL_STATUS_OTHER = 'Boarding Other';
    public static final String STATUS_CHECK = 'status_check';
    public static final String STATUS_UNCHECK = 'status_uncheck';
    
    public static final String ASSET_CATEGORY_CAR = 'Car';
    public static final String ASSET_CATEGORY_MOTOR_VEHICLE = 'Motor vehicle';
    public static final String ASSET_CATEGORY_CARAVAN = 'Caravan';
    public static final String ASSET_CATEGORY_HOUSE = 'House';
    public static final String ASSET_CATEGORY_MOTORCYCLE = 'Motor cycle';
    public static final String ASSET_CATEGORY_MOTOR_HOME = 'Motor home';
    public static final String ASSET_OWNERSHIP_OWE = 'Owe money on';
    
    //Added as part of DBHZL-143: Ownership status field being displayed for non relevant asset types
    public static final String ASSET_CATEGORY_DEPOSITS = 'Deposits';
    public static final String ASSET_CATEGORY_KIWISAVER = 'Kiwisaver/Other Superannuation';
    public static final String ASSET_OWNERSHIP_NONE = 'None';
    
    public static final String DEBT_CATEGORY_CAR_LOAN = 'Car loan';
    public static final String DEBT_CATEGORY_CREDIT = 'Credit card';
    public static final String DEBT_CATEGORY_CHARGE_CARD = 'Charge card';
    public static final String DEBT_CATEGORY_MORTGAGE = 'Mortgage';
    public static final String DEBT_CATEGORY_OTHER = 'Other';
    public static final String DEBT_CATEGORY_OVERDRAFT = 'Overdraft';
    public static final String DEBT_CATEGORY_PERSONAL_LOAN = 'Personal loan';
    public static final String DEBT_CATEGORY_STORE_CARD = 'Store card';
    public static final String DEBT_CONSOLIDATE = 'Consolidate the debt';
    public static final String DEBT_REDUCE_LIMIT = 'Reduce the credit limit';
    public static final String DEBT_CATEGORY_HIRE_PURCHASE = 'Hire purchase';
    public static final Integer DEBT_MONTHLY_REPAYMENT = 20;

    
    public static final String EXPENSE_PAY_OPTION_YES = 'Yes, I pay all the expenses';
    public static final String EXPENSE_PAY_OPTION_NO = 'No, others contribute to expenses';
    
    public static final String INCOME_SOURCE_PERMANENT_FULLTIME = 'My permanent - full time job';
    public static final String INCOME_SOURCE_PERMANENT_PARTTIME = 'My permanent - part time job';
    public static final String INCOME_SOURCE_CONTRACT = 'My contracting job';
    public static final String INCOME_SOURCE_TEMPORARY = 'My casual/temporary job';
    public static final String INCOME_SOURCE_SELF_EMPLOYED = 'My self-employed business';
    public static final String INCOME_SOURCE_SEASONAL = 'My seasonal job';
    public static final String INCOME_SOURCE_OTHER_SOURCE = 'My other source of income';
    public static final String INCOME_SOURCE_WORKCOVER = 'My workers compensation';
    public static final String INCOME_SOURCE_NET_SALARY = 'Net Salary/Wages';   //DBHZL34
    public static final String INCOME_SOURCE_SELF_EMPLOYED_NZ = 'Self Employed'; //DBHZL34 
    public static final String INCOME_SOURCE_GOVERNMENT_BENEFIT = 'Government Benefit'; //DBHZL34
    public static final String INCOME_SOURCE_RENTAL_INCOME = 'Rental Income'; //DBHZL34
    
    
    public static final String BUSINESS_SOURCE_INTERNET_APPLICATION     = 'INTERNET APPLICATION';
    public static final String BUSINESS_SOURCE_WL_INTERNET_APPLICATION  = 'WL INTERNET APPLICATION';
    public static final String BUSINESS_SOURCE_60_DAY_CERTIFICATE       = '60 DAY CERTIFICATE'; //ADDED BY MDAVID 03-AUG-2015 PMIHM 1891
    public static final String BUSINESS_SOURCE_60_DAY_CERTIFICATE_AU       = '60Day Certificate AU'; //ADDED BY Fahad for 60D cert business source mapping for AU    
    public static final String BUSINESS_SOURCE_PERSONAL_LOAN_REF_CENTER = 'PERSONAL LOAN REFERRAL CENTRE'; //ADDED BY AFREEN 25-FEB-2016 
    public static final String BUSINESS_SOURCE_BROKER_LOAN = 'BROKER LOAN'; //ADDED BY AFREEN 05-MAY-2016 
    
    //public static final String MIRROR_PLRC_BRANCH                       = 'PLRC - Branch'; //ADDED BY AFREEN 25-FEB-2016 
    public static final String MIRROR_BROKER_LOAN                   = 'BROKER LOAN'; //ADDED BY AFREEN MAY-06-2016 for BROKER PORTAL Changes
    public static final String BRAND_NAME_AUSSIE = 'Aussie Money AU';
    
    //BEGIN MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
    public static final String BRAND_NAME_GEMONEY = 'Latitude';
    public static final String BRAND_NAME_KIWI = 'Kiwibank';
    public static final String BRAND_NAME_GEMONEY_NZ = 'GEM';
     
    //Added by Davey Yu 05-28-2015 New static string for brand display name
    public static final String BRAND_Display_NAME_AUSSIE = 'Aussie';
    public static final String BRAND_Display_NAME_GEMONEY = 'Latitude';
    //END MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
    
    public static final String PAYMENT_INTERVAL_FORTNIGHT = 'Fortnight';
    public static final String PAYMENT_INTERVAL_WEEK = 'Week';
    public static final String PAYMENT_INTERVAL_MONTH = 'Month';
    public static final String PAYMENT_INTERVAL_YEAR = 'Year';
    //Added as part of the Responsible lending
    public static final String PAYMENT_INTERVAL_QUARTER = 'Quarter';
    
    public static final String COMPLIANCE_BROKER = 'Originations - Broker';
    public static final String COMPLIANCE_OFFLINE_ACCEPTANCE = 'Offline Acceptance';
    public static final String COMPLIANCE_ONLINE_ACCEPTANCE = 'Online Acceptance';
    
    public static final String DISABILITY_INSURANCE = 'Disability Insurance';
    public static final String INVOLUNTARY_UNEMPLOYMENT_INSURANCE = 'Involuntary Unemployment Insurance';
    public static final String LIFE_INSURANCE = 'Life Insurance';
    
    public static final String GUEST_USERNAME = 'Customer Site Guest User';
    
    public static final String IOVATION_FINGERPRINT_STEP = 'app.submit';
    
    public static final String DEBIT_TYPE_DEBIT = 'Direct Debit';
    public static final String DEBIT_TYPE_POST_PAYMENT = 'Australia Post Payment Card';
    
    public static final String LOAN_DOCUMENTS = 'Loan Documents';
    
    public static final String PPSR_REGISTRATION_FEE = 'PPSR Registration Fee';
    public static final String PPSR_SEARCH_FEE = 'PPSR Search Fee';
    
    public static final String DIRECT_DEBIT_RECORDTYPE = 'Direct Debit';
    public static final String DIRECT_DEBIT_RECORDTYPE_NZ = 'Direct Debit NZ';
    
    public static final String DISBURSEMENT_GE_CARD_LIMIT_REDUC_RECORDTYPE = 'LFS Card Limit Reduction';                               // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String DISBURSEMENT_NON_GE_OV_LIMIT_REDUCT_RECORDTYPE = 'Non-LFS Card & Overdraft Limit Reduction';            // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String DISBURSEMENT_GE_CARD_CLOSURE_WITHOUT_INTEREST_FREE_RECORDTYPE = 'LFS Card Closure Without Interest Free';     // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String DISBURSEMENT_NON_GE_OV_CLOSURE_RECORDTYPE = 'Non-LFS Card & Overdraft Closure';                         // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    
    public static final String DISBURSEMENT_NON_GE_OD_LIMIT_REDUCT_NZ_RECORDTYPE = 'Non-LFS Card OR Overdraft Limit Reduction NZ';     // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String DISBURSEMENT_NON_GE_OD_CLOSURE_NZ_RECORDTYPE = 'Non-LFS Card OR Overdraft Closure NZ';                  // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    
    //Debit Frequency
    public static final String DEBIT_FREQUENCY_WEEKLY = 'D7';
    public static final String DEBIT_FREQUENCY_FORTNIGHTLY = 'D14';
    public static final String DEBIT_FREQUENCY_MONTHLY = 'M1';

    public static final String COLLATERAL_TYPE_MOTOR_VEHICLE = 'Motor Vehicle';
    public static final String COLLATERAL_TYPE_MOTORCYCLE = 'Motorcycle';
    public static final String COLLATERAL_TYPE_BOAT = 'Boat';
    public static final String COLLATERAL_CATEGORY_COLLATERAL = 'Collateral';
    public static final String COLLATERAL_CATEGORY_POI = 'POI';

    public static final String EMPLOYMENT_STATUS_HOME_DUTIES = 'Home Duties';
    public static final String EMPLOYMENT_STATUS_RETIRED = 'Retired';
    public static final String EMPLOYMENT_STATUS_DISABILITY_PENSION = 'Disability Pension';
    public static final String EMPLOYMENT_STATUS_OTHER_PENSION = 'Other Pension e.g. Carer\'s Pension';
    public static final String EMPLOYMENT_STATUS_WORKCOVER = 'Workcover / Workers Compensation';
    public static final String EMPLOYMENT_STATUS_UNEMPLOYED = 'Unemployed';

    public static final String RELATED_DOCUMENT_STATUS_RECEIVED = 'Received';
    public static final String RELATED_DOCUMENT_STATUS_SENT = 'Sent';

    //RUL_InsurancePremiumCalculator
    public static final String INSURANCE_LIFE = 'Life Insurance';
    public static final String INSURANCE_DISABILITY = 'Disability Insurance';
    public static final String INSURANCE_IUI = 'Involuntary Unemployment Insurance';
    
    public static final String DISBURSEMENT_RTYPE_BROKER_FEE = 'Broker_Fee';
    public static final String DISBURSEMENT_RTYPE_CHEQUE = 'Cheque';
    public static final String DISBURSEMENT_RTYPE_DIRECT_CREDIT = 'Direct_Credit';
    public static final String DISBURSEMENT_RTYPE_GECARD_CLOSURE_INTERES_FREE = 'GE_Card_Closure_Interest_Free';
    public static final String DISBURSEMENT_RTYPE_GECARD_CLOSURE_WITHOUT_INTEREST_FREE = 'GE_Card_Closure_Without_Interest_Free';
    public static final String DISBURSEMENT_RTYPE_GECARD_LIMIT_REDUCTION = 'GE_Card_Limit_Reduction';
    public static final String DISBURSEMENT_RTYPE_NON_GE_CLOSURE_WITHOUT_INTEREST_FREE = 'Non_GE_Card_Overdraft_Closure_Without_Interest_Free';
    public static final String DISBURSEMENT_RTYPE_NON_GE_CARD_LIMIT_REDUCTION = 'Non_GE_Card_Overdraft_Limit_Reduction';
    public static final String DISBURSEMENT_RTYPE_REFINANCE = 'Re_Finance';
    public static final String DISBURSEMENT_RTYPE_BROKER_INSURANCE = 'Broker_Insurance';
    public static final String DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE = 'Broker Insurance';
    public static final String DISBURSEMENT_RTYPE_NAME_BROKER_INSURANCE_NZ = 'Broker Insurance NZ';
    public static final String DISBURSEMENT_RTYPE_DIRECT_CREDIT_NZ = 'Direct Credit NZ';        //MLASALA 30-MAR-16 TQLQW-127 Re-brand

    public static final String APPLICANT_ADDED = 'Applicant Added';
    public static final String APPLICANT_REMOVED = 'Applicant Removed';

    public static final String LOAN_PURPOSE_TYPE_DEBT_CONSOLIDATION = 'Debt consolidation';  

    public static final String APPLICANT_1 = 'Applicant 1';
    public static final String APPLICANT_2 = 'Applicant 2';
    public static final String BOTH = 'Both';  
    public static final String GE_CARD_CLOSURE_INTEREST_FREE = 'LFS Card Closure Interest Free';                   // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String GE_CARD_CLOSURE_WITHOUT_INTEREST_FREE = 'LFS Card Closure Without Interest Free';   // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String NON_GE_CARD_OVERDRAFT_CLOSURE = 'Non-LFS Card & Overdraft Closure';                 // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String GE_CARD_LIMIT_REDUCTION = 'LFS Card Limit Reduction';                               // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String NON_GE_CARD_OVERDRAFT_LIMIT_REDUCTION = 'Non-LFS Card & Overdraft Limit Reduction'; // UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
    public static final String REFINANCE_GE_PERSONAL_LOAN = 'Re-Finance';
    
    public static final String APP_APPLICABLE_PARTY_APP1 = 'Applicant 1';
    public static final String APP_APPLICABLE_PARTY_APP2 = 'Applicant 2';
    public static final String APP_APPLICABLE_PARTY_BOTH = 'Both';
    
    public static final String COMPLIANCE_LPI_BY_PHONE = 'LPI_by_Phone';
    public static final String COMPLIANCE_MASTERCARD_XLIST = 'Mastercard_Application';
    public static final String COMPLIANCE_MVI_REFERRAL = 'MVI_Referral';
    
    public static final String WORKFLOW_STATUS_CLOSEAPP = 'Close Application';
    
    public static final String OBJECT_DEBIT = 'Debit';

    public static final String PROD_TYPE = 'Personal loan';

    public static final String patternPhone = '([0-9]+)';
    public static final String patternPhone2 = '(^02+[0-9]+)';
    public static final String patternPhone3 = '(^03+[0-9]+)';
    public static final String patternPhone4 = '(^04+[0-9]+)';
    public static final String patternPhone5 = '(^07+[0-9]+)';
    public static final String patternPhone6 = '(^08+[0-9]+)';
    public static final String patternEmail = '[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?';
    public static final String GE_SITE = 'www.gemoney.com.au';      //<-- MLASALA: 22-MAR-16 - NOT USED ANYWHERE 

    public static final String BUTTON_CLASS_COMPLETE = 'status_complete';
    public static final String BUTTON_CLASS_INCOMPLETE = 'status_incomplete';
    public static final String BUTTON_CLASS_INPROGRESS = 'status_inprogress';
    public static final String BUTTON_CLASS_BLANK = 'status_blank';

    public static final String PWDRESET_USER_PROFILE = 'B1 Customer Community Login';   //Changed by Tony Xu to get Customer UI Password reset working for NZ sites, this need to be changed to work with but AUS and NZ sites
    public static final String PWDRESET_EXCEPTION_LOG_RECORDTYPE = 'Password Reset';
    public static final String PWDRESET_TEMPLATE_NAME = 'Password Reset GE AU';
    public static final String PWDRESET_SUCCESS_MESSAGE = 'Please check your email for further instructions';
    
    /**Community user profile name added by Tony Xu**/
    public static final String COMMUNITY_USER_PROFILE_AU_APPLICANT1 = 'A1 Customer Community Login';
    public static final String COMMUNITY_USER_PROFILE_AU_APPLICANT2 = 'A1 Applicant 2 Customer Community Login';
    public static final String COMMUNITY_USER_PROFILE_NZ_APPLICANT1 = 'B1 Customer Community Login';
    public static final String COMMUNITY_USER_PROFILE_NZ_APPLICANT2 = 'B1 Applicant 2 Customer Community Login';
    /**END**/
    
    /**Site Name added by Tony Xu**/
    public static final String GEMONEY_AU_SITENAME = 'Latitude';
    public static final String AUSSIE_MONEY_SITENAME = 'Aussie';
    public static final String GEMONEY_NZ_SITENAME = 'Gem';     //MLASALA: 22-MAR-16 TQLQW-127 Re-brand
    public static final String KIWI_BANK_SITENAME = 'Kiwibank';    
    /**END**/

    public static final String ADMIN_SETTINGS_OMNITURE = 'Omniture Source';

    public static final String TILE_UPLOAD = 'Upload';
    public static final String TILE_CONTRACT = 'Contract';

    public static final String EXLOG_RECORDTYPE_NAME = 'Password Reset';
    public static final String PWDCHANGE_VALIDITY_MESSAGE = 'The password reset activation link has expired';
    public static final String PWDCHANGE_UNAVAILABLE_MESSAGE = 'Password Reset Unavailable';
    public static final String PWDCHANGE_MISMATCH_MESSAGE = 'Password does not match';
    public static final String PWDCHANGE_NULL_MESSAGE = 'Please fill up both fields';
    public static final String COMPLIANCE_ERROR_MESSAGE = 'No Meta Compliance Check records found';
    public static final String CONTRACTGENERATION_ERROR_MESSAGE = 'No Meta Pre Contract Check records found';
    public static final String PWDRESET_EXCEEDED_MESSAGE = 'Invalid entry, your account has been suspended - please contact Latitude on 1800 734 583 for assistance';     //MLASALA 06-MAY-2016 Updated brand reference
    public static final String PWDRESET_INCORRECT_MESSAGE = 'Incorrect email or date of birth';
    public static final String NO_RESULT_FOUND = 'No result found.';

    public static final String REQUIRED_BLOCK_NULL = 'requiredBlocknull';
    public static final String REQUIRED_BLOCK      = 'requiredBlock2';

    public static final String COMPLETED_DECISIONS_REPORT = 'Completed_Decisions';
    public static final String WF_CANCEL_RATE_REDUCTION = 'Cancel Rate Reduction';
    public static final String WF_APPROVED = 'Approved'; 
    public static final String BRAND_CONTENT_PRIVACY_POLICY = 'Privacy Policy';
    public static final String VICTORIA_STATE = 'VIC';
    public static final Set<String> USERLICENSE_COMMUNITY = new Set<String>{'Guest User License', 'Customer Community Login'};

    //user brand checking messages
    public static final String USER_NULL_BRAND = 'There is no brand attached to your user';
    public static final String BRAND_NULL_SITE = 'There is no site attached to your brand';
    
    //Solecode constant string -- added by Akash
    public static final String SOLE_CODE = 'SOLCode-';

    //Customer Id type for NZ customers
    public static final String CUSTOMERTYPEID_NZ_DRIVER_LICENSE = 'NZ Driver Licence';
    public static final String CUSTOMERTYPEID_NZ_PASSPORT= 'NZ Passport';
    public static final String CUSTOMERTYPEID_AUSTRALIA_PASSPORT = 'Australia/Cook Islands/Tokelau/Niue Passport';
    public static final String CUSTOMERTYPEID_OVERSEAS_PASSPORT = 'Overseas Passport';
    public static final String CUSTOMERTYPEID_NZ_FIREARMS_LICENCE = 'NZ Firearms Licence';
    public static final String CUSTOMERTYPEID_CERTIFIED_DOCUMENTS_REQUIRED = 'Other - Certified Documents required';                
    public static final String CUSTOMERTYPEID_NZ_BIRTH_CERTIFICATE = 'NZ Birth Certificate';
    public static final String CUSTOMERTYPEID_NZ_CERTIFICATE_OF_CITIZENSHIP = 'NZ Certificate of Citizenship';
    
    // Region constant string -- added by Fahad Akhtar
    public static final String AU_REGION = 'AU';
    public static final String NZ_REGION = 'NZ';
    public static final String FIN_INTSTITUTION_KIWI_BANK = 'Kiwibank';
    public static final decimal REPAYMENT_CALCULATION_THREE_PERCENT = 0.03;
    public static final decimal REPAYMENT_CALCULATION_FIVE_PERCENT = 0.05;
    
    public static final String POA = 'Proof of Address';
    public static final String AML_IDENTIFICATION_TYPE = 'Pre submit identification';
    public static final String AML_IDENTIFICATION_TYPE_SUPERGOLD = 'SuperGold card with Photo';

    public static final String ONR_CAR_PURCHASE = 'Car purchase'; //Modified by Tony Xu change from "Car Purchase" to "Car purchase" to match up with value in Meta ONR
    public static final String AUTO_RULE_FAIL_CAR_PURCHASE = 'Auto Loan Fail: Auto Loan must only have one loan purpose of car purchase.';
    public static final String AUTO_RULE_FAIL_SECURITY = 'Auto Loan Fail: Auto Loan must only have one security of motor vehicle.';
    public static final String AUTO_RULE_FAIL_SECURITY_RATIO = 'Auto Loan Fail: Loan to value ratio (LVR) should be greater than 0.1.';  // UPDATED by RCADAPAN @ 09-MAR-2016 for TQLQW-95
    public static final String AUTO_RULE_FAIL_SECURITY_VALUE = 'Auto Loan Fail: Security value must be greater than $1.00.'; // UPDATED by RCADAPAN @ 09-MAR-2016 for TQLQW-95
    public static final String AUTO_RULE_FAIL_SECURITY_AGE_OF_CAR = 'Auto Loan Fail: Age of car must be less then 20 years.'; // UPDATED by RCADAPAN @ 09-MAR-2016 for TQLQW-95
    public static final String AUTO_RULE_FAIL_SECURITY_NO_AGE_OF_CAR = 'Auto Loan Fail: Age of car is not provided.';
    public static final String AUTO_RULE_FAIL_SECURITY_RISK_GRADE = 'Auto Loan Fail: Risk grade should be greater than FS or TD.';    

    public static final String AUTO_RULE_FAIL = 'Fail to Qualify for Auto Loan';
    
    public static final String COLLATERAL_MOTOR_VEHICLE_RECORD_TYPE = 'Motor Vehicle NZ';    

    public static final String AML_VERIFICATION_METHOD = 'Not Applicable';

    public static final String AML_COUNTRY_AU = 'Australia';
    public static final String AML_COUNTRY_NZ = 'New Zealand';
    //Modified by: Fahad Akhtar to use in Data perge of applicaiton.
    public static final String APPLICATION = 'Application__c';
    public static final String TOKEN_VALUE = 'XXXXXXXXXXXXXXXXX';
    public static final String EMAIL_TOKEN_VALUE = 'XXXXXXXXXXXX@XXX.COM';    
    public static final set<string> DOCUMENTNAMES=new set<string>{'Disclosure_Statement','Repayment_protection_brochure','GE_terms_and_conditions','Kiwibank_terms_and_conditions','Personal_Loan_IDV_form'};
    public static final String APPLICATION_WORKFLOW_ARCHIVED = 'Archived';
    public static final String APPLICATION_RESPONSE_PURGED = 'Purged';

    public static final String APPLICANT_VERIFICATION_TYPE_MANUAL_AML = 'Manual AML';
    public static final String APPLICANT_VERIFICATION_TYPE_POA = 'Proof of Address';
    
    public static final String STRING_AML = 'AML';
    public static final String STRING_POI = 'POI';
    
    public static final String ONLINE_ACCEPTANCE_NOTIFICATION_TEMPLATE = 'Online_Acceptance_Notification';

    //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
    //INSURANCE ERROR MESSAGES CUSTOM SETTING NAME VALUES
    public static final String PREFIX_INFO_MESSAGE = 'Prefix';
    public static final String SUFFIX_INFO_MESSAGE = 'Suffix';
    public static final String MULTIPLE_SCENARIO_INSURANCE_INFO_MESSAGE = 'Multiple Scenario';
    public static final String BROKER_FEE_INSURANCE_INFO_MESSAGE = 'Broker Fee';
    public static final String ESTABLISHMENT_FEE_INSURANCE_INFO_MESSAGE = 'Establishment Fee';   //not yet used
    public static final String LOAN_AMOUNT_INSURANCE_INFO_MESSAGE = 'Loan Amount';
    public static final String NEGATIVE_CAPACITY_INSURANCE_INFO_MESSAGE = 'Negative Capacity';
    public static final String PPSR_FEE_INSURANCE_INFO_MESSAGE = 'PPSR Fee';
    public static final String RATE_CHANGE_INSURANCE_INFO_MESSAGE = 'Rate Change';
    public static final String BRAND_SWAP_INSURANCE_INFO_MESSAGE = 'Brand Swap';
    public static final String NBSM_FLAG_CHANGE_INSURANCE_INFO_MESSAGE = 'Employment Type';
    public static final String INSURANCE_TYPE_ALL = 'All';
    //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

    //ADDED RCADAPAN : 01/25/2016 TQLQW 19/20/32
    public static final String AU_LOAN_PURPOSE_CAR_PURCHASE = 'car purchase';
    public static final String AU_LOAN_PURPOSE_CAR_REPAIRS = 'car repairs';
    public static final String AU_LOAN_PURPOSE_EDUCATIONAL_EXPENSES = 'educational expenses';
    public static final String AU_LOAN_PURPOSE_HOME_IMPROVEMENTS = 'home improvements';
    public static final String AU_LOAN_PURPOSE_HOUSEHOLD_FURNISHINGS = 'household furnishings';
    public static final String AU_LOAN_PURPOSE_MEDICAL_DENTAL = 'medical / dental';
    public static final String AU_LOAN_PURPOSE_OTHER_VEHICLE = 'other vehicle purchase';
    public static final String AU_LOAN_PURPOSE_SMALL_DEBTS = 'small debts';
    public static final String AU_LOAN_PURPOSE_TRAVEL = 'travel';
    public static final String AU_LOAN_PURPOSE_OTHER = 'other';
    public static final Set<String> AU_STRAIGHT_LOAN_PURPOSE = new Set<String>{AU_LOAN_PURPOSE_CAR_PURCHASE, AU_LOAN_PURPOSE_CAR_REPAIRS, AU_LOAN_PURPOSE_EDUCATIONAL_EXPENSES,
                                                                AU_LOAN_PURPOSE_HOME_IMPROVEMENTS, AU_LOAN_PURPOSE_HOUSEHOLD_FURNISHINGS,
                                                                AU_LOAN_PURPOSE_MEDICAL_DENTAL, AU_LOAN_PURPOSE_OTHER_VEHICLE,
                                                                AU_LOAN_PURPOSE_SMALL_DEBTS, AU_LOAN_PURPOSE_TRAVEL, AU_LOAN_PURPOSE_OTHER};

    public static final String PAYMENT_OPTION_WEEKLY = 'weekly';
    public static final String PAYMENT_OPTION_FORTNIGHTLY = 'fortnightly';
    public static final String PAYMENT_OPTION_MONTHLY = 'monthly';    

    public static final Set<String> STRAIGHT_PAYMENT_OPTION = new Set<String>{PAYMENT_OPTION_WEEKLY,PAYMENT_OPTION_FORTNIGHTLY,PAYMENT_OPTION_MONTHLY};                                                        
    
    public static final String NZ_LOAN_PURPOSE_CAR_PURCHASE = 'auto purchase';
    public static final String NZ_LOAN_PURPOSE_CAR_REPAIRS = 'auto repairs';
    public static final String NZ_LOAN_PURPOSE_RECREATIONAL = 'caravan/boat/recreational';
    public static final String NZ_LOAN_PURPOSE_EDUCATIONAL_EXPENSES = 'education';
    public static final String NZ_LOAN_PURPOSE_HOME_IMPROVEMENTS= 'home improvements';
    public static final String NZ_LOAN_PURPOSE_HOUSEHOLD_FURNISHINGS = 'household furnishings';
    public static final String NZ_LOAN_PURPOSE_MEDICAL_DENTAL = 'medical & dental';
    public static final String NZ_LOAN_PURPOSE_TRAVEL = 'travel/holiday';
    public static final String NZ_LOAN_PURPOSE_OTHER = 'other';

    public static final Set<String> NZ_STRAIGHT_LOAN_PURPOSE = new Set<String>{NZ_LOAN_PURPOSE_CAR_PURCHASE, NZ_LOAN_PURPOSE_CAR_REPAIRS, NZ_LOAN_PURPOSE_RECREATIONAL,
                                                                NZ_LOAN_PURPOSE_EDUCATIONAL_EXPENSES, NZ_LOAN_PURPOSE_HOME_IMPROVEMENTS,
                                                                NZ_LOAN_PURPOSE_HOUSEHOLD_FURNISHINGS, NZ_LOAN_PURPOSE_MEDICAL_DENTAL,
                                                                NZ_LOAN_PURPOSE_TRAVEL, NZ_LOAN_PURPOSE_OTHER};
                                            
    public static final String AU_NZ_COMPLEX_LOAN_PURPOSE_REFINANCE = 're-finance';
    public static final String AU_COMPLEX_LOAN_PURPOSE_DEBT_CONSOLIDATION = 'debt consolidation';
    public static final String NZ_COMPLEX_LOAN_PURPOSE_CONSOLIDATION = 'consolidation';
    public static final Set<String> AU_COMPLEX_LOAN_PURPOSES = new Set<String>{AU_NZ_COMPLEX_LOAN_PURPOSE_REFINANCE, AU_COMPLEX_LOAN_PURPOSE_DEBT_CONSOLIDATION};
    public static final Set<String> NZ_COMPLEX_LOAN_PURPOSES = new Set<String>{AU_NZ_COMPLEX_LOAN_PURPOSE_REFINANCE, NZ_COMPLEX_LOAN_PURPOSE_CONSOLIDATION};
    //END RCADAPAN
    
    //ADDED RCADAPAN 03-FEB-2016
    public static final String GE_MONEY_IDV = 'GEM_Personal_Loan_IDV';
    public static final String KIWIBANK_IDV = 'KIWIBANK_Personal_Loan_IDV';
    public static final String AUSSIE_IDV = 'Aussie_Money_Personal_Loan_IDV';
    public static final String BRAND_CONTENT_AML_DOCUMENTS = 'AML_Documents';
    public static final String BRAND_CONTENT_AML_CERTIFIERS = 'AML_Certifiers';
    public static final String BRAND_CONTENT_AML_VERIFIERS = 'AML_Verifications';
    
    //END RCADAPAN
    public static final String REQUESTED_DOCUMENT_STATUS_REQUESTED = 'Requested';       //MLASALA 02-FEB-16

    public static final Decimal KIWIBANK_BAR_RATE_LIMIT = 22.95; //ADDED RCADAPAN 25-FEB-2016
    public static final String NZ_META_DOCUMENTS_POA = 'POA PL'; 

    //ADDED DYU 16-FEB-2016

    /* DOCUMENT TYPES */
    public static final String POI_PL_CATEGORY = 'POI PL';
    public static final String POI_PL_PAYSLIP = 'Payslip';
    public static final String POI_PL_LETTER_FROM_EMPLOYER = 'Letter from Employer';
    public static final String POI_PL_BANK_STATEMENT = 'Bank Statement';
    public static final String POI_PL_PAYG_SUMMARY = 'PAYG Summary';
    public static final String POI_PL_NOTICE_OF_ASSESSMENT = 'Notice of Assessment';
    public static final String POI_PL_TAX_RETURN = 'Individual Tax Return';
    public static final String POI_PL_LETTER_FROM_ACCOUNTANT = 'Letter from Accountant';
    public static final String POI_PL_PROFIT_STATEMENT = 'Profit and Loss Statement';
    public static final String POI_PL_LETTER_FROM_FUND_MANAGER = 'Letter from Fund Manager/Insurer';
    public static final String POI_PL_RETURN_TO_WORK_PLAN = 'Return to Work Plan';
    public static final String POI_PL_CURRENT_LEASE_AGREEMENT = 'Current Lease Agreement';
    public static final String POI_PL_LETTER_FROM_REAL_ESTATE = 'Letter from Real Estate';
    public static final String POI_PL_RENTAL_RECEIPTS = 'Last 3 Real Estate rental receipts/tax invoices';
    public static final String POI_PL_REAL_ESTATE_CONFIRMATION = 'Real Estate Confirmation (verbal/fax)';
    public static final String POI_PL_EXPIRED_LEASE_AGREEMENTS = 'Expired Lease Agreement with last 2 months bank statements';
    public static final String POI_PL_SUPERANNUATION_STATEMENT = 'Superannuation Statement';
    public static final String POI_PL_MAINTENANCE_DOCUMENT = 'Legal documentation and / or Child Support Agency documents';
    public static final String POI_PL_BANK_STATEMENTS = 'Bank Statements';
    public static final String POI_PL_CENTRELINK_STATEMENT = 'Centrelink/Department of Human Service statement (all pages)';
    public static final String POI_PL_CENTRELINK_ONLINE = 'Centrelink Online Payment History';
    public static final String POI_PL_VETERANS_AFFAIRS = 'Statement or letter from Veterans Affairs';
    public static final String POI_PL_1_PAYSLIP = '1 Payslip';
    public static final String POI_PL_IRD_SUMMARY = 'IRD Summary of Earnings issued within the last 30 days';
    public static final String POI_PL_BANK_STATEMENT_NZ = '30 days Bank Statement, showing a minimum of 2 pay entries';
    public static final String POI_PL_FINANCIAL_STATEMENT = 'Financial Statement from an accounting firm';
    public static final String POI_PL_ACC_BENEFIT_STATEMENT = 'ACC Benefit Statement';
    public static final String POI_PL_LETTER_FROM_WINZ_IRD = 'Letter from WINZ/IRD specifying the type of benefit and amount';
    public static final String POI_PL_RENTAL_LEASE = 'Rental Agreement / Lease';
    public static final String POI_PL_2_BANK_STATEMENT = '2 months statements from your Real Estate Agent';
    public static final String POI_PL_60_BANK_STATEMENT = 'A 60 day bank statement, showing a minimum of three consecutive rental income entries';
    public static final String POI_PL_CURRENT_LEASE_AGREEMENT_PRIVATE = 'Current Lease Agreement Private Rental';
    public static final String POI_PL_TAX_RETURN_PRIVATE = 'Individual Tax Return Private Rental';
    public static final String POI_PL_LETTER_FROM_FUND_MANAGER_WORKERS = 'Letter from Fund Manager';

    //Document Type Description
    public static final String POI_PL_LETTER_FROM_EMPLOYER_NZ = 'Letter from employer, stating duration of the benefit confirming income amount';
    public static final String POI_PL_LETTER_FROM_ACCOUNTANT_NZ = 'Letter from ACC confirming income amount';
    public static final String POI_PL_SE_IRD_SUMMARY_DESC = 'Summary of Earnings, issued by IRD within the last 30 days, OR';
    public static final String POI_PL_BANK_STATEMENT_DESC_NZ = 'One full month&#39s bank statement dated within the last 60 days, showing a minimum of 2 pay entries'; 
    public static final String POI_PL_RENTAL_LEASE_DESC_NZ = 'Copy of the rental agreement and a full month bank account statement, showing consistent rent as an entry';

    /* INCOME SOURCE CODES */
    public static final String POI_PL_INCOME_FT = 'FT'; //My permanent - full time job
    public static final String POI_PL_INCOME_CN = 'CN'; //My contracting job
    public static final String POI_PL_INCOME_PT = 'PT'; //My permanent - part time job
    public static final String POI_PL_INCOME_CA = 'CA'; //My Casual/Temporary Job
    public static final String POI_PL_INCOME_SJ = 'SJ'; //My Seasonal job 
    public static final String POI_PL_INCOME_SE = 'SE'; //My self-employed business || self employed
    public static final String POI_PL_INCOME_WC = 'WC'; //My workers compensation
    public static final String POI_PL_INCOME_RE = 'RE'; //My rental property
    public static final String POI_PL_INCOME_OT = 'OT'; //My other sources of income || Other
    public static final String POI_PL_INCOME_CS = 'CS'; //My child support
    public static final String POI_PL_INCOME_PE = 'PE'; //My pension
    public static final String POI_PL_INCOME_NE = 'NE'; //Net Salary/Wages
    public static final String POI_PL_INCOME_GB = 'GB'; //Government Benefit
    //END DYU 16-FEB-2016
    
    //Afreen 25-Feb_2016
    public static final String ELIGIBITIY_BROKER_STATUS_ACTIVE      = 'Active';
    public static final String ELIGIBITIY_BROKER_PARAMETER          = 'broker';
    public static final String BROKER_RECORD_TYPE_APAC              = 'APAC Contact';
    public static final String BROKER_PRODUCT_PL                    = 'PL';

    public static final String ELIGIBILTY_KIWIBANK_POSTSHOP_PRAMETER = 'postshop';

    //Tony Xu 2016-02-26
    public static final String PRE_BUREAU_RESPONSE_CODE = 'VAR,PRR,MAR';
    public static final String POST_BUREAU_RESPONSE_CODE = 'FAR,POR';
    public static final String FRAUD_WATCHLIST_RESPONSE_CDDE = 'FBR,WAR,FCR';
    public static final String CPU_RESPONSE_CODE = 'SCR';
    public static final String SALES_RESPONSE_CODE = 'SAR';
    public static final String CA_RESPONSE_CODE = 'PAO,PMO,PIO,PCO';
    public static final String DECLINE_RESPONSE_CODE = 'FID';
    public static final String SERVER_RESPONSE_CODE = 'SUS01000';
    
    //MLASALA 29-FEB-16 - TQLQW-102 UNDERLYING WORKFLOW ENGINE AND WORKFLOW RULES
    //BEGIN MLASALA 30-MAR-16 - DEFECT 439 FIX
    public static final String INBOUND_OUTBOUND_USER_ROLE_PREFIX = 'IB_TM,OB_TM,IB_SA,OB_SA';
    public static final String INBOUND_OUTBOUND_USER_ROLES = 'System_Administrator,GM_Inbound_Sales,GE_Outbound_Sales,Inbound_Sales_Manager,Outbound_Sales_Manager';
    public static final String LPE_USER_ROLE_PREFIX = 'LPE';
    //END MLASALA 30-MAR-16 - DEFECT 439 FIX
    public static final String LPE_QUEUE_DEVELOPERNAME = 'AU_LPE_Queue';

    //RCADAPAN 08-MAR-2016 - TQLQW-29
    public static final Decimal AU_VALID_LOAN_TOTAL_AMOUNT = 3000;
    public static final Decimal NZ_VALID_LOAN_TOTAL_AMOUNT = 2000;
    
    //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
    public static final String COMMUNITY_USER_EMAIL_PREFIX = '@ge.com';  //Change back to ge.com as the domain is white listed.
    public static final String PL_BROKER_PRODUCT_FILTER = 'PL';
    public static final String MOTOR_BROKER_PRODUCT_FILTER = 'PL;Motor Solutions';
    
    public static final String CONTACT_US_CALL = 'Need some help? Call us on ';
    public static final String CONTACT_US_EMAIL = 'Need some help? Email us on ';
    
    //BEGIN MLASALA 05-APR-2016 eApps
    public static final String EAPPS_OUTCOME_REFER = 'Refer';
    public static final String EAPPS_OUTCOME_DECLINED = 'Declined';
    public static final String EAPPS_OUTCOME_ERROR = 'Error';
    public static final String ERROR_RESPONSE_CODE_PREFIX = 'ER';
    //END MLASALA 05-APR-2016 eApps
    
    public static final String POA_RESPONSE_CODE = 'PDO,ADO';       //MLASALA 14-APR-2016 DEFECT 645 FIX
    
    // Society One constants 
    public static final String SOCIETY_ONE = 'SocietyOne';
    // Afreen - Constants for picStarter
    public static final String MIRROR_PICSTARTER = 'PicStarter';  // Afreen - US 481 
    public static final String PICSTARTER_COMPLETED_LEADS_CAMPAIGN = 'PicStarter Completed Leads';
    public static final String PICSTARTER_INCOMPLETE_LEADS_CAMPAIGN = 'PicStarter Incomplete Leads';
    
    // RCADAPAN - 05-SEP-2016
    public static final String VEDA_CAMPAIGN_NAME = 'Off-Dialler';
    public static final String MIRROR_VEDA_QUOTE = 'Veda Quote';
    public static final String ADMIN_SETTING_VEDA_WINDOW = 'Veda Quote Time Window';
    
    //BEGIN MLASALA 06-OCT-16 TQLQW-524 Fixes and tweaks to Promo Engine
    public static final String CA_RESPONSE_CODE_NZ = 'ADO,AMO,PAO,PDO,PIO';
    
    // RCADAPAN - 10-OCT-2016 CVP3 Fix Pack
    public static final String ADMIN_SETTING_UNASSIGNED_LEADS_WINDOW = 'Delete Unassigned Batch Month Window';
    public static final String ADMIN_SETTING_EPOI_ENDPOINT = 'ePOI link';
    //Added as part of EpoiNZ ODDS-13449
    public static final String ADMIN_SETTING_EPOI_ENDPOINT_NZ = 'ePOI Link NZ';
    
    //Added as part of Softquote
    public static final String Soft_Quote_WS_Success = 'Successful';
    public static final String Soft_Quote_WS_Retry = 'Retry';
    public static final String Soft_Quote_Broker_Not_Found = 'Broker_Not_Found';
    public static final String Soft_Quote_Broker_Message_Failure = 'Broker_Is_Invalid';
    public static final String Soft_Quote_Broker_Msg_Empty = 'Broker_ID_Empty';
    public static final String Soft_Quote_Broker_Message_Success = 'Broker_Is_Valid';
    public static final String SOFT_QUOTE_DUPLICATE_MSG_NOT_FOUND = 'Quote_does_not_exists';
    public static final String SOFT_QUOTE_DUPLICATE_MSG_SUCCESS = 'Quote_Already_exists';
    public static final String SOFT_QUOTE_SERVICE_ERROR = 'Service_Request_Body_Not_Valid';
    public static final String Soft_Quote_ID_Invalid = 'Quote_Id_Invalid';
    public static final String Soft_Quote_Decision_Pending = 'Quote_decision_pending';
    public static final String AU_COUNTRY_CODE = '+61';
    public static final String NZ_COUNTRY_CODE = '+64';
    public static final String ERROR_STATUS = 'ERROR';
    public static final String ERROR_MSG = 'ERROR_MSG';
    public static final String DOB_BLANK = 'DOB_BLANK';
    public static final String DOB_BLANK_MSG = 'Date of Birth is mandatory and cannot be blank.';
    public static final String EMAIL_ID_BLANK = 'EMAIL_ID_BLANK';
    public static final String EMAIL_ID_BLANK_MSG = 'Email Id is mandatory and cannot be blank.';
    public static final String INVALID_DOB_FORMAT = 'INVALID_DOB_FORMAT';
    public static final String INVALID_DOB_FORMAT_MSG = 'Date of Birth should be in DD/MM/YYYY format.';
    public static final String QUOTE_OFFERED_STAGE = 'Quote Offered';
    public static final String NO_ACTIVE_QUOTE = 'NO_ACTIVE_QUOTE';
    public static final String NO_ACTIVE_QUOTE_MSG = 'No active quote found.';
    public static final String MAX_SMS_ATTEMPTS_REACHED = 'MAX_SMS_ATTEMPTS_REACHED';
    public static final String MAX_SMS_ATTEMPTS_REACHED_MSG = 'You have exhausted your maximum attempts to generate an OTP.';
    public static final String ERROR_SENDING_SMS = 'ERROR_SENDING_SMS';
    public static final String ERROR_SENDING_SMS_MSG = 'An error was encountered while sending an SMS.';
    public static final String SUCCESS_STATUS = 'SUCCESS';
    public static final String SUCCESS_MSG = 'SUCCESS_MSG';
    public static final String OTP_GENERATED = 'OTP Generated Successfully.';
    public static final String OTP_VALIDATED = 'OTP Validated Successfully.';
    public static final String QUOTE_ID = 'QUOTE_ID';
    public static final String ENCRYPTED_QUOTE_ID = 'ENCRYPTED_QUOTE_ID';
    public static final String QUOTE_REFERENCE = 'QUOTE_REFERENCE';
    public static final String QUOTE_MOBILE_NUMBER = 'QUOTE_MOBILE_NUMBER';
    public static final String SF_TRANSACTION_ID = 'SF_TRANSACTION_ID';
    public static final String TRANSACTION_ID_BLANK = 'TRANSACTION_ID_BLANK';
    public static final String TRANSACTION_ID_BLANK_MSG = 'Transaction Id is mandatory and cannot be blank.';
    public static final String QUOTE_ID_BLANK = 'QUOTE_ID_BLANK';
    public static final String QUOTE_ID_BLANK_MSG = 'Quote Id is mandatory and cannot be blank.';
    public static final String OTP_BLANK = 'OTP_BLANK';
    public static final String OTP_BLANK_MSG = 'OTP is mandatory and cannot be blank.';
    public static final String LATITUDE_PL_LOAN = 'Latitude Personal Loan';
    public static final String GEM_PL_LOAN = 'GEM Personal Loan';
    public static final String KIWI_PL_LOAN = 'Kiwi Personal Loan';
    public static final String SOURCE_NUMBER_LATITUDE = 'Latitude';
    public static final String SOURCE_NUMBER_GEM = 'Gem Loans';
    public static final String SOURCE_NUMBER_KIWI = 'Kiwi';
    public static final String INCORRECT_DETAILS = 'INCORRECT_DETAILS';
    public static final String INCORRECT_DETAILS_MSG = 'Incorrect Details Provided for validation.';
    public static final String OTP_ALREADY_VERIFIED = 'OTP_ALREADY_VERIFIED';
    public static final String OTP_ALREADY_VERIFIED_MSG = 'The OTP has already been verified.';
    public static final String OTP_VERIFICATION_MAX_ATTEMPTS = 'OTP_VERIFICATION_MAX_ATTEMPTS';
    public static final String OTP_VERIFICATION_MAX_ATTEMPTS_MSG = 'Maximum number of attempts reached to verify the OTP.';
    public static final String OTP_EXPIRED = 'OTP_EXPIRED';
    public static final String OTP_EXPIRED_MSG = 'OTP has expired.';
    public static final String OTP_INCORRECT = 'OTP_INCORRECT';
    public static final String OTP_INCORRECT_MSG = 'OTP is incorrect.';
    public static final String QUOTE_FIRST_NAME = 'QUOTE_FIRST_NAME';
    public static final String QUOTE_INTEREST_RATE = 'QUOTE_INTEREST_RATE';
    public static final String QUOTE_SECURED_INTEREST_RATE = 'QUOTE_SECURED_INTEREST_RATE';
    public static final String QUOTE_LOAN_AMOUNT = 'QUOTE_LOAN_AMOUNT';
    public static final String QUOTE_LOAN_TERM = 'QUOTE_LOAN_TERM';
    public static final String QUOTE_LOAN_PURPOSE = 'QUOTE_LOAN_PURPOSE';
    public static final String QUOTE_COMPARISON_RATE = 'QUOTE_COMPARISON_RATE';
    public static final String QUOTE_REPAYMENTS = 'QUOTE_REPAYMENTS';
    public static final String QUOTE_SUBTYPE = 'QUOTE_SUBTYPE';
    public static final String QUOTE_STAGE = 'QUOTE_STAGE';
    public static final String ATTEMPTS_REMAINING = 'ATTEMPTS_REMAINING';
    public static final String VERIFICATION_ATTEMPTS_REMAINING = 'VERIFICATION_ATTEMPTS_REMAINING';
    public static final String QUOTE_DECLINED = 'Declined';
    public static final String QUOTE_INITIAL_SUBMIT = 'Initial Submit';
    public static final String QUOTE_OFFERED = 'Quote Offered';
    public static final String QUOTE_REFERRED = 'Referred';
    public static final String QUOTE_EXPIRED = 'Expired';
    public static final String QUOTE_MANUALLY_CANCELLED = 'Manually Cancelled';
    public static final String QUOTE_CONVERTED_TO_APP = 'Converted to Application';
    public static final String QUOTE_SERVICE_UNAVAILABLE = 'Service Unavailable';
    public static final String QUOTE_DECLINED_RESPONSE_CODE = 'FID';
    public static final String QUOTE_REFERRED_RESPONSE_VAR = 'VAR';
    public static final String QUOTE_REFERRED_RESPONSE_MAR = 'MAR';
    public static final String QUOTE_REFERRED_RESPONSE_POR = 'POR';
    public static final String QUOTE_REFERRED_RESPONSE_PRR = 'PRR';
    public static final String QUOTE_REFERRED_RESPONSE_SCR = 'SCR';
    public static final String QUOTE_EXPIRED_RESPONSE_FIC = 'FIC';
    public static final String QUOTE_CHANNEL_ONLINE = 'Online';
    public static final String QUOTE_CHANNEL_BROKER = 'Broker';
    public static final String QUOTE_Reminder_Email_3 = 'Quote Reminder Email Day 3';
    public static final String QUOTE_Reminder_Email_5 = 'Quote Reminder Email Day 5';
    public static final String QUOTE_Reminder_Email_10 = 'Quote Reminder Email Day 10';
    public static final String QUOTE_Reminder_Email_1 = 'Quote Reminder Email Day 1';
    public static final String QUOTE_BS_Reminder_Email_1 = 'Quote BS Reminder Email Day 1';
    public static final String QUOTE_BS_Reminder_Email_3 = 'Quote BS Reminder Email Day 3';
    public static final String QUOTE_BS_Reminder_Email_5 = 'Quote BS Reminder Email Day 5';
    public static final String QUOTE_BS_Reminder_Email_10 = 'Quote BS Reminder Email Day 10';    
    public static final String QUOTE_Reminder_EmailTemp_1 = 'Soft Quote Day1 Reminder AU';
    public static final String QUOTE_Reminder_EmailTemp_3 = 'Soft Quote Day3 Reminder AU';
    public static final String QUOTE_Reminder_EmailTemp_5 = 'Soft Quote Day5 Reminder AU';
    public static final String QUOTE_Reminder_EmailTemp_10 = 'Soft Quote Day10 Reminder AU';
    public static final String QUOTE_BS_Reminder_EmailTemp_1 = 'Soft Quote Day1 Reminder AU Better Start';
    public static final String QUOTE_BS_Reminder_EmailTemp_3 = 'Soft Quote Day3 Reminder AU Better Start';
    public static final String QUOTE_BS_Reminder_EmailTemp_5 = 'Soft Quote Day5 Reminder AU Better Start';
    public static final String QUOTE_BS_Reminder_EmailTemp_10 = 'Soft Quote Day10 Reminder AU Better Start';
    public static final String QUOTE_RemGem_EmailTemp_1 = 'GEM Soft Quote Day1 Reminder';
    public static final String QUOTE_RemGem_EmailTemp_3 = 'GEM Soft Quote Day3 Reminder';
    public static final String QUOTE_RemGem_EmailTemp_5 = 'GEM Soft Quote Day5 Reminder';
    public static final String QUOTE_RemGem_EmailTemp_10 = 'GEM Soft Quote Day10 Reminder';
    public static final String emailAddress_LFS = 'Latitude Personal Loans';
    public static final String emailAddress_GEM  = 'Gem Personal Loans';   
    public static final String emailAddress_OrgLFS = 'noreply-personalloan@latitudefinancial.com';
    public static final String emailAddress_OrgGEM  = 'noreply-personalloan@gemfinance.co.nz';  
    public static final String QUOTE_BROKER_SECURED_RATE = 'Secured Broker pricing';
    public static final String QUOTE_SALES_SECURED_RATE = 'Secured Sales Pricing';
    public static final String QUOTE_BROKER_UNSECURED_RATE = 'Unsecured Broker pricing';
    public static final String QUOTE_SALES_UNSECURED_RATE = 'Unsecured Sales Pricing';
    public static final String QUOTE_UNSECURED = 'Unsecured';
    public static final String QUOTE_SECURED = 'Secured';    
}