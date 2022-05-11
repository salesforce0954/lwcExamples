/**
 * @Description: Offer Presentation Extension Controller.
 * @Author: Fel Saliba    
 * @Date Created: OCTOBER-24-2013
 * @History:
   =====================================================================
        OCT-24 (Fel): Created.
        2015-02-27: DBHZL386 - Retrive Payoff Figure from ICBS added by Tony Xu
        March-15
        2015-3-18 -  Fahad Akhtar : Defect 18 - When type of product is Auto Loan, The only purpose show be avaialble is car purchase.
        23/4/2015 :   Keerthan Tantry -- Defect-1017 
        2015-05-02: Updated Defect 1287 - Updated insuranceOffer method to update GST amount for life insurance policy as zero 0 - DY
        05-19-15: Added debug logging - Mike
        26-05-15: Remove remaining capacity validation - Adrian
        08-06-15: PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING - MLASALA
        08-12-15: CAPINC0730846 - UNABLE TO PROCESS RATE REDUCTION WORKFLOWS - MLASALA
        31-AUG-15: WEEKLY CONTRACT PAYMENT ISSUE - MLASALA
        25-SEPT-15: TOTAL INSURANCE PREMIUM RULE FIX - MLASALA
   =====================================================================
 */ 
public class OFF_OfferPresentationExt extends APP_CommonExt{
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<OfferPresentationWrapper> offerList {get;set;}
    public List<HeaderWrapper> wrapperHeader{get;set;}
    public Loan_Purpose__c loan {get; set;}
    public List<Application_Response__c> appResponse{get;set;}
    public Integer globalCtr {get;set;}
    public Integer rowCount {get;set;}
    public Integer displayCtr {get;set;}
    public String loanToRemove {get;set;}
    public Boolean displayCalculated {get;set;}
    public Boolean isCustomer {get;set;}
    public Boolean noErrors {get;set;}
    public String loanTermSelected {get; set;}
    public List<Loan_Purpose__c> upsertLoanList;
    public List<Loan_Purpose__c> delLoanList;
    public Decimal totalLoanAmount {get;set;}
    public Decimal onLoadLoanAmount {get;set;}
    public Decimal capacity {get;set;}
    public Decimal remaining{get;set;}
    public Decimal fees{get;set;}
    public Decimal feesWidth {get;set;}
    public Decimal remainingWidth {get;set;}
    public List<String> headerColor {get;set;}
    public Boolean isJoint{get;set;}
    public Boolean ageValidation {get;set;}
    public Boolean renderInsurance {get;set;}
    public String dateOfBirthStr{get;set;}
    public String dateOfBirthStr2{get;set;}
    public Boolean hasLife {get;set;}
    public Boolean hasDisability {get;set;}
    public Boolean hasIUI {get;set;}
    public Boolean netIncomeEligible {get;set;}

    public List<Loan_Purpose__c> loanPurposeList {get;set;}
    public List<Asset__c> assetList {get; set;}
    public List<Liability__c> debtList {get; set;}
    //public List<DebtWrapper> wrapperDebt {get;set;} - part of Phase 2
    public List<Offer_Presented__c> creditList{get;set;}
    public List<Offer_Presented__c> insuranceList{get;set;}
    public List<Offer_Presented__c> offPresentedList{get;set;}
    public List<Product_Version__c> prodVersionList {get;set;}
    public List<Product_Item__c> prodItems;
    public Map<String,Product_Item__c> prodItemsMap;
    public Set<String> offerPresentedIds {get;set;}
    
    public Boolean displayHeader {get;set;}
    public Boolean disableFields{get;set;}
    
    public Boolean displayDebt{get;set;}
    public Boolean debtDisplayOffered{get;set;}
    
    public Boolean displayAsset{get;set;}
    public Boolean assetDisplayOffered{get;set;}
    
    public Boolean displayInsurance{get;set;}
    public List<InsuranceWrapper> wrapperInsure {get;set;}
    public List<Product_Collateral__c> prodCollateralList {get;set;}
    
    public Boolean displayCreditCard{get;set;}
    public List<CreditWrapper> wrapperCredit {get;set;}
    
    //===============================================================
    //                       Disbursement Variables
    //===============================================================
    public List<DisbursementWrapper> disbursementWrapperList {get; set;}
    public DisbursementWrapper currentDisbursementWrapper {get; set;}
    public Boolean bDisplayDisbursementPopup {get; set;}     
    public Boolean bAccountNumberOK {get; set;}  
    public Integer nRefinanceRow {get; set;}   
    public List<DisbursementWrapper> upsertDisbursementWrapperList {get; set;}
    public List<Disbursement__c> upsertDisbursementList {get; set;}
    public List<Disbursement__c> deleteDisbursementList {get; set;}
    public Id recTypeIdRefinance {get; set;} 
    public Map<Integer, Loan_Purpose__c> externalIdLoanPurposeMap {get;set;}
    public String sRefinanceIds {get; set;}
    public String sCurrentRefinance {get; set;}
    public Integer nRefinanceEditId {get; set;}
    public Integer disbursementRowCount {get;set;}
    public Decimal disbursementNetPayOff {get;set;}
    
    public Boolean showDisbursementFields {get;set;} //DBHZL386
    
    // Streaming API
    public static final String TOPIC_NAME = 'ApplicationResponse';   
    public Boolean bShowTimeOut {get; set;}
    public String sTimeOutMessage {get; set;}  
    public List<Application_Response__c> applicationResponseList {get; set;}  
    
    public DateTime onloadLMD;
    
    //Added by Mike Lasala 05/19/15 for calculation debugging
    public Application__c tempApplication;

    public Decimal totalInterest {get;set;}
    
    public String retrievalDate {get;set;}

    public Decimal originalRate;

    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Constructor used for all initializations
     *  Author: Fel Saliba
     *  Date Created: OCT-24-2013
     *  Input: None
     *  Return: void
     */
    public OFF_OfferPresentationExt(ApexPages.StandardController applicationController) {
       super(applicationController);
       appResponse = getAppRes();
       displayCalculated = false;   
       //this.assetList = getAssetList(); - part of phase 2
       //this.debtList = getDebtList(); - part of phase 2
       this.loanPurposeList = retrieveLoanPurposeList();
       this.prodVersionList = getProductVersionList();
       System.debug('prodVersionList-->'+prodVersionList);
       this.prodItems = new List<Product_Item__c>(); 
       this.prodItemsMap = new Map<String,Product_Item__c>();
       offPresentedList = new List<Offer_Presented__c>(); 
       wrapperInsure = new List<InsuranceWrapper>();
       prodCollateralList = new List<Product_Collateral__c>();
       wrapperCredit = new List<CreditWrapper>();
       //wrapperDebt = new List<DebtWrapper>(); - part of phase 2
       wrapperHeader = new List<HeaderWrapper>();
       noErrors = validaterecords();
       system.debug('###noErrors: ' + noErrors);       
       capacity = 0;
       remaining = 0;
       fees = 0;
       isJoint = false;
       bDisplayDisbursementPopup = false;
       recTypeIdRefinance = [select Id from RecordType where SObjectType = 'Disbursement__c' and Name = 'Re-Finance' limit 1].Id;
       externalIdLoanPurposeMap = new Map<Integer, Loan_Purpose__c>(); 
       upsertDisbursementWrapperList = new List<DisbursementWrapper>();
       upsertDisbursementList = new List<Disbursement__c>();
       deleteDisbursementList = new List<Disbursement__c>();
       sRefinanceIds = '';
       sCurrentRefinance = '';
       nRefinanceRow = 0;
       nRefinanceEditId = 0;
       
       bShowTimeOut = false;
       sTimeOutMessage = ''; 
       applicationResponseList = new List<Application_Response__c>();
       
       netIncomeEligible = false; 
       system.debug('==========TXU DEBUG 1==========='+this.application.id);
       system.debug('==========TXU DEBUG 2==========='+this.application.LastModifiedDate);
       onloadLMD = this.application.LastModifiedDate;    
       
       showDisbursementFields = false;     
     
     retrievalDate = Date.today().format();
          
        //Added by Mike Lasala 05/19/15 for calculation debugging
        tempApplication = GEN_RecordRetrievalUtility.retrieveApplication(this.application.Id);

        totalInterest = computeTotalInterest();

       if(noErrors){
           resetVariables();
       }     
       
    }
    
    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    
    /*  Description: Method to check records upon page load.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    
    public Boolean validateRecords(){
        Boolean validateOk = true; 
        
        //Check Application Loan Term Months       
        if(this.application.Loan_Term__c != null) {
            loanTermSelected = this.application.Loan_Term__c;
        }

        //Check Application Loan Amount
        if(application.Total_Loan_Amount__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Application Record'));
            validateOk = false;
        }
        //Check if Application Response record exists
        if(appResponse.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Decisioning Response Received'));
            validateOk = false;
        }
        //If Application and Application Response exist check other details.
        else{
            if(application.Offered_Interest_Rate__c == null || this.application.Offered_Interest_Rate__c == 0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Interest Rate is Required'));
                validateOk = false;
            }
            if(application.credit_score__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Application Record: Credit score should not be null'));
                validateOk = false;            
            }
            if(application.max_capacity_secured__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Application Record: Max Capacity Secured should not be null'));
                validateOk = false;
            }
            if(application.max_capacity_unsecured__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Application Record: Max Capacity Unsecured should not be null'));
                validateOk = false;            
            }
        }
        if(validateOk){
            return true;
        }else{
            return false;
        }
    }
    
    /*  Description: Method to determine if header will be visible for customer/staff.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Boolean checkHeader(){
        if(isCustomer()){
            List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
            offerPresentedList = getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_UNSECURED_UPSELL);
            
            if(offerPresentedList.size()>0){
                return true;
            }
            else{
                return false;
            }            
        }
        else{
            return false;
        }
    }
    
    //Commented out will be part of Phase 2 
    /*  Description: Method to determine if Debt Consolidation Offer will be visible for customer/staff.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */ 
    /*public Boolean checkDebt(){
        
        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        offerPresentedList = getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_PROMPTED_DEBT_CONSOLIDATION);
        
        if(isCustomer()){
            debtDisplayOffered = false;
            if(offerPresentedList.size()>0){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            if(offerPresentedList.size()>0){
                debtDisplayOffered = true;
            }
            else{
                debtDisplayOffered = false;
            }
            return true;                        
        }
    }*/
    
    //Commented out will be part of Phase 2
    /*  Description: Method to determine if Secure Offer will be visible for customer/staff.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    /*public Boolean checkAsset(){
        
        List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
        offerPresentedList = getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_SECURED_UPSELL);
        
        if(isCustomer()){
            assetDisplayOffered = false;
            if(offerPresentedList.size()>0){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            if(offerPresentedList.size()>0){
                assetDisplayOffered = true;
            }
            else{
                assetDisplayOffered = false;
            }
            return true;                        
        }
    }*/
    
    /*  Description: Method to determine if Insurance Offer will be visible for customer/staff.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Boolean checkInsurance(){
        if(isCustomer()){
            if(!insuranceList.isEmpty()){
                return true;
            }
            else{
                return false;
            }
        } 
        else {
            return true;
        }   
    }
    
    //Commented out will be part of Phase 2
    /*  Description: Method to determine if Credit Card Offer will be visible for customer/staff.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    /*public Boolean checkCreditCard(){
        if(isCustomer()){
            if(!creditList.isEmpty()){
                return true;
            }
            else{
                return false;
            }
        } 
        else {
            return true;
        }
    }*/
    
    /*  Description: Populate variables when there are no errors found on page load.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public void resetVariables(){
       offerList = new List<OfferPresentationWrapper>();
       //wrapperDebt = new List<DebtWrapper>(); - part of phase 2
       
       upsertLoanList = new List<Loan_Purpose__c>();
       delLoanList = new List<Loan_Purpose__c>();    
       totalLoanAmount = 0;   
       loan = new Loan_Purpose__c();
       isCustomer = isCustomer();
       System.debug('isCustomer-->'+isCustomer);
       globalCtr = 1;
       displayCtr = 0;
       rowCount = retrieveLoanPurposeList().size();
       loanToRemove = '';
       offPresentedList = [Select Id from Offer_Presented__c where Application_Response__c  =: appResponse[0].Id];
       wrapperInsure = new List<InsuranceWrapper>();
       wrapperCredit = new List<CreditWrapper>();
       headerColor = new List<String>();
       isJoint = isJoint();

       disbursementWrapperList = new List<DisbursementWrapper>();
       initializeDisbursement();
       externalIdLoanPurposeMap = new Map<Integer, Loan_Purpose__c>(); 
       upsertDisbursementWrapperList = new List<DisbursementWrapper>();
       upsertDisbursementList = new List<Disbursement__c>();
       deleteDisbursementList = new List<Disbursement__c>();
       sRefinanceIds = '';
       sCurrentRefinance = '';
       nRefinanceRow = 0;
       nRefinanceEditId = 0;
       hasLife = false;
       hasDisability = false;
       hasIUI = false;
       this.prodItems = retrieveAllProductItems(application.Id);

       //Get Header colors in the custom settings.
       for(HeaderColors__c color: [Select Name from HeaderColors__c]){
            headerColor.add(color.Name);
       }       
       
       //get capacity base on application type, secured or unsecured
       System.debug('appResponse-->'+appResponse);                           
       if(application.Is_Secured__c){
           capacity = application.max_capacity_secured__c;
       }
       else{
           capacity = application.max_capacity_unsecured__c;
       }
       
       Map<String,List<Product_Item__c>> prodItemAndVersionMap = new Map<String,List<Product_Item__c>>();
       if(!prodItems.isEmpty()){
           for(Product_Item__c pI: prodItems){
               prodItemsMap.put(pI.Product_Version__r.GEProduct__c, pI);
               
                if(prodItemAndVersionMap.containsKey(pI.Product_Version__c)){
                    prodItemAndVersionMap.get(pI.Product_Version__c).add(pI);
                }else{
                   prodItemAndVersionMap.put(pI.Product_Version__c, new List<Product_Item__c>{pI});
                }               
           }
       }
       
       //get Credit Card offers and put in a Wrapper for display in page.
       
       this.creditList = getCreditCardInsurance(offPresentedList,'New Product Offer','Credit Card');     
       Set<String> creditIds = new Set<String>();
       Set<String> acceptedIds = new Set<String>();
       if(!creditList.isEmpty()){
           for(Offer_Presented__c offer: creditList){
               creditIds.add(offer.Offer__r.Product__c);
               if(offer.Accepted__c){
                   acceptedIds.add(offer.Offer__r.Product__c);
               }
           }
       }
       
       //get Insurance offers and put in a Wrapper for display in page.
       this.insuranceList = getCreditCardInsurance(offPresentedList,'New Product Offer','Insurance');
       Set<String> insureIds = new Set<String>();
       if(!insuranceList.isEmpty()){
           for(Offer_Presented__c offer: insuranceList){
               insureIds.add(offer.Offer__r.Product__c);
               if(offer.Accepted__c){
                   acceptedIds.add(offer.Offer__r.Product__c);
               }
           }
       }
       System.debug('prodVersionList2-->'+prodVersionList);
       Set<String> collateralSet = new Set<String>();
       if(!prodVersionList.isEmpty()){
           for(Product_Version__c pv: prodVersionList){
               if(pv.Type__c == 'Insurance'){
                   collateralSet.add(pv.GEProduct__c);
                   InsuranceWrapper iw = new InsuranceWrapper();
                   iw.productVersion = pv;
                   
                   //check if offer exist
                   if(insureIds.contains(pv.GEProduct__c)){
                       iw.offerExist = true;
                   }
                   
                   //get the product items associated with the product version
                   List<Product_Item__c> prodItemList = new List<Product_Item__c>(); 
                   if(prodItemAndVersionMap.keySet().contains(pv.Id)){
                       prodItemList = prodItemAndVersionMap.get(pv.Id);
                   }
                   else{
                       
                       iw.applicant1 = false;
                       Product_Item__c pd = new Product_Item__c();
                       pd.Application__c = application.Id;
                       pd.Product_Version__c = iw.productVersion.Id;
                       pd.Applicant1__c = applicant.Id;
                       if(isJoint){
                           pd.Applicant2__c = applicant2.Id;
                       }
                       iw.prodItem = pd;
                   } 
                   //if prodItemList size > 0
                   Map<String,Product_Item__c> prodItemMap = new Map<String,Product_Item__c>();
                   
                   if(!prodItemList.isEmpty()){
                       for(Product_Item__c pi:prodItemList){
                           prodItemMap.put(pi.Applicant1__c,pi);
                       }                   
                   }
                   System.debug('prodItemMap-->'+prodItemMap);
                   if(prodItemMap.containsKey(applicant.Id)){
                       iw.applicant1 = true;
                       iw.prodItem = prodItemMap.get(applicant.Id);
                        
                       if(isJoint &&  prodItemMap.get(applicant.Id).Applicant2__c != null){
                           iw.applicant2 = true;
                        }
                   }
                   else {
                       iw.applicant1 = false;
                       iw.applicant2 = false;
                       Product_Item__c pd = new Product_Item__c();
                       pd.Application__c = application.Id;
                       pd.Product_Version__c = iw.productVersion.Id;
                       pd.Applicant1__c = applicant.Id;
                       if(isJoint){
                           pd.Applicant2__c = applicant2.Id;
                       }
                       iw.prodItem = pd;
                   }                                       
                                     
                   //check the Insurance Type and then put in wrapper
                   if(pv.GEProduct__r.Insurance_Type__c == 'Life Insurance'){
                       iw.insuranceType = 'Life Insurance';    
                       if(iw.applicant1){
                           hasLife = true;
                       }                  
                   }
                   else if(pv.GEProduct__r.Insurance_Type__c == 'Disability Insurance'){
                       iw.insuranceType = 'Disability Insurance'; 
                       if(iw.applicant1){
                           hasDisability = true;
                       }                      
                   }
                   else{
                        iw.insuranceType = 'Involuntary Unemployment Insurance';
                        if(iw.applicant1){
                            hasIUI = true;
                        }
                   }
                   
                   wrapperInsure.add(iw);
               }
               //Commented out will part of phase 2
               /*else if(pv.Type__c == 'Credit Card'){                  
                   CreditWrapper cw = new CreditWrapper();
                   cw.productVersion = pv;
                   if(creditIds.contains(pv.GEProduct__c)){
                       cw.offerExist = true;
                   }
                   if(acceptedIds.contains(pv.GEProduct__c)){
                       cw.isSelected = true;
                       cw.accepted = true;
                   }
                   else if(prodItemsMap.keySet().contains(pv.GEProduct__c)){
                       cw.isSelected = true;
                       cw.accepted = false;
                   }
                   else{
                       cw.isSelected = false;
                       cw.accepted = false;
                   }
                   wrapperCredit.add(cw);
               }*/
           }
       }
       System.debug('wrapperInsureBegin-->'+wrapperInsure);
       
       if(collateralSet.size()>0){
           prodCollateralList = getProductCollaterals(collateralSet);
       }
             
       remaining = capacity - this.application.Total_Loan_Amount_with_Insurance__c;
       fees = this.application.Total_Loan_Amount_with_Insurance__c -  this.application.Total_Loan_Amount__c;
       remainingWidth = getWidth(remaining, capacity);
       feesWidth = getWidth(fees, capacity);
       
       //Commented out will be part of Phase 2       
       /*Decimal creditCard = 0;
       Boolean consolidatedCreditCard = false;
       Decimal overdraft = 0;
       Boolean consolidatedOverdraft = false;
       Decimal carLoan = 0;
       Boolean consolidatedCarLoan = false;
       Decimal personalLoan = 0;
       Boolean consolidatedPersonalLoan = false;
       Decimal storeCard = 0;
       Boolean consolidatedStoreCard = false;
       
       if(debtList.size()>0){
           for(Liability__c l: debtList){
               if(l.Debt_Category__c == 'Credit card'){
                   creditCard += l.Total_Debts__c;
                   if(l.Consolidated__c){
                       consolidatedCreditCard = true;
                   }
               }
               else if(l.Debt_Category__c == 'Overdraft'){
                   overdraft += l.Total_Debts__c;
                   if(l.Consolidated__c){
                       consolidatedOverdraft = true;
                   }
               }
               else if(l.Debt_Category__c == 'Car Loan'){
                   carLoan += l.Total_Debts__c;
                   if(l.Consolidated__c){
                       consolidatedCarLoan = true;
                   }
               }
               else if(l.Debt_Category__c == 'Personal Loan'){
                   personalLoan += l.Total_Debts__c;
                   if(l.Consolidated__c){
                       consolidatedPersonalLoan = true;
                   }
               }
               else if(l.Debt_Category__c == 'Store Card'){
                   storeCard += l.Total_Debts__c;
                   if(l.Consolidated__c){
                       consolidatedStoreCard = true;
                   }
               }
           }
           
           if(creditCard != 0){
               DebtWrapper dw = new DebtWrapper();
               Decimal frequency = 0;
               if(application.Payment_Frequency__c == 'Weekly'){
                   frequency = (creditCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/4);
               }
               else if(application.Payment_Frequency__c == 'Fortnightly'){
                   frequency = (creditCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/2);
               }
               else{
                   frequency = (creditCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c);
               }
               dw.frequency = frequency.setScale(2);
               dw.isConsolidated = consolidatedCreditCard;
               dw.total = creditCard;
               dw.debtCategory = 'Credit Card';
               wrapperDebt.add(dw);
           }
           if(overdraft != 0){
               DebtWrapper dw = new DebtWrapper();
               Decimal frequency = 0;
               //Decimal frequency = (overdraft / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/divider);
               if(application.Payment_Frequency__c == 'Weekly'){
                   frequency = (overdraft / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/4);
               }
               else if(application.Payment_Frequency__c == 'Fortnightly'){
                   frequency = (overdraft / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/2);
               }
               else{
                   frequency = (overdraft / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c);
               }                   
               dw.frequency = frequency.setScale(2);
               dw.isConsolidated = consolidatedOverdraft;
               dw.total = overdraft;
               dw.debtCategory = 'Overdraft';
               wrapperDebt.add(dw);
           }
           if(carLoan != 0){
               DebtWrapper dw = new DebtWrapper();
               Decimal frequency = 0;
               //Decimal frequency = (carLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/divider);                   
               if(application.Payment_Frequency__c == 'Weekly'){
                   frequency = (carLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/4);
               }
               else if(application.Payment_Frequency__c == 'Fortnightly'){
                   frequency = (carLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/2);
               }
               else{
                   frequency = (carLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c);
               }
               dw.frequency = frequency.setScale(2);
               dw.isConsolidated = consolidatedCarLoan;
               dw.total = carLoan;
               dw.debtCategory = 'Car Loan';
               wrapperDebt.add(dw);
           }
           if(personalLoan != 0){
               DebtWrapper dw = new DebtWrapper();
               Decimal frequency = 0;
               //Decimal frequency = (personalLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/divider);                   
               if(application.Payment_Frequency__c == 'Weekly'){
                   frequency = (personalLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/4);
               }
               else if(application.Payment_Frequency__c == 'Fortnightly'){
                   frequency = (personalLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/2);
               }
               else{
                   frequency = (personalLoan / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c);
               }
               dw.frequency = frequency.setScale(2);
               dw.isConsolidated = consolidatedPersonalLoan;
               dw.total = personalLoan;
               dw.debtCategory = 'Personal Loan';
               wrapperDebt.add(dw);
           }
           if(storeCard != 0){
               DebtWrapper dw = new DebtWrapper();
               Decimal frequency = 0;
               //Decimal frequency = (storeCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/divider);                   
               if(application.Payment_Frequency__c == 'Weekly'){
                   frequency = (storeCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/4);
               }
               else if(application.Payment_Frequency__c == 'Fortnightly'){
                   frequency = (storeCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c/2);
               }
               else{
                   frequency = (storeCard / application.Total_Loan_Amount__c)* (application.Offered_Repayments__c);
               }
               dw.frequency = frequency.setScale(2);
               dw.isConsolidated = consolidatedStoreCard;
               dw.total = storeCard;
               dw.debtCategory = 'Store Card';
               wrapperDebt.add(dw);
           }
       }*/      
       
       this.displayHeader = checkHeader(); 
       //this.displayDebt = checkDebt(); - part of phase 2
       //this.displayAsset = checkAsset(); - part of phase 2
       this.displayInsurance = checkInsurance();
       //this.displayCreditCard = checkCreditCard(); - part of phase 2
       
       if(isCustomer()){
           if(displayHeader && this.application.Upsell_Opt_In__c){
               this.disableFields = false;
           }
           else{
               this.disableFields = true;
           } 
       }
       else{
           this.disableFields = false;       
       }
       
       System.debug('headerColor-->'+headerColor);
       for(Loan_Purpose__c loan: retrieveLoanPurposeList()){
           
           OfferPresentationWrapper offer = new OfferPresentationWrapper();
           offer.loan = loan;  
           offer.counter = globalCtr++; 
           displayCtr = displayCtr + 1;    
           offerList.add(offer);
           
           HeaderWrapper hw = new HeaderWrapper();
           hw.headerWidth = getWidth(loan.Loan_Amount__c,capacity);
           hw.name = loan.Value__c;  
           if(headerColor.size()>0){
               hw.headerColor = headerColor.get(0);
               System.debug('color-->'+headerColor.get(0));
               headerColor.remove(0); 
           }                           
           wrapperHeader.add(hw);
       }
       
       for(integer i=retrieveLoanPurposeList().size();i<10;i++){
          Loan_Purpose__c loan = new Loan_Purpose__c();
          OfferPresentationWrapper offer = new OfferPresentationWrapper();
          offer.loan = loan;
          offer.counter = globalCtr++;

          if (offer.loan.Value__c == 'Refinance') {
            sRefinanceIds = sRefinanceIds + String.valueof(offer.counter) + ','; 
          }

          offerList.add(offer);
       }
       if (sRefinanceIds != '') {
          sRefinanceIds = sRefinanceIds.subString(0, sRefinanceIds.length() - 1); //trim last comma
       }

       // Add the related disbursements for Refinance Loan Purposes
       for(OfferPresentationWrapper offer : offerList) {
          for (Disbursement__c disbursement : retrieveDisbursementList()) {
              system.debug('###disbursement: ' + disbursement);
              if (disbursement.Loan_Purpose__c == offer.loan.Id && disbursement.Record_Type_Name__c == GEN_OriginationsConstants.DISBURSEMENT_RECORD_REFINANCE) {
                      DisbursementWrapper dw = new DisbursementWrapper();
                      dw.disbursement = disbursement;
                      dw.counter = offer.counter;
                      disbursementWrapperList.add(dw);
              }                       
          }                                                                 
       }
       system.debug('###offerList: ' + offerList);
       system.debug('###disbursementWrapperList: ' + disbursementWrapperList);
       
       //Added by Fel Saliba 6/23/2014 - Net Monthly Income checking for applicant2
       if(applicant2 != null){
            String netIncome = Admin_Settings__c.getValues('Net Monthly Income Value').Value__c; 
            System.debug('netIncome -->'+netIncome );
            System.debug('applicant2.Total_Income__c -->'+applicant2.Total_Income__c);
            if(applicant2.Total_Income__c >= Decimal.valueOf(netIncome)){ 
                                         
                String netMonthlyMultiplier = Admin_Settings__c.getValues('Net Monthly Income Multiplier').Value__c;
                System.debug('netMonthlyMultiplier -->'+netMonthlyMultiplier );
                
                //get repayment without insurance Premium.
                Decimal insPrem = application.Total_Insurance_Premium__c != null ? application.Total_Insurance_Premium__c : 0;
                Decimal amount = application.Total_Loan_Amount_with_Insurance__c - insPrem ;
                Decimal rate = ((application.Offered_Interest_Rate__c.setScale(2)/12)/100);
                Decimal loanTerm = application.Loan_Term_Months__c != null ? application.Loan_Term_Months__c : 0;
                
                Decimal e = Math.exp((-loanTerm)*Math.log((1+rate)));
                system.debug('!@#$rate:'+application.Offered_Interest_Rate__c);
                system.debug('!@#$insprem:'+insPrem);
                system.debug('!@#$amount:'+amount);
                system.debug('!@#$rate:'+rate);
                system.debug('!@#$loanTerm:'+loanTerm);
                system.debug('!@#$%e:'+e);
                
                Decimal inputEMI = ((amount*rate)/(1-(e))*1.0018).setScale(2);                     
                if(inputEMI  <= (applicant2.Total_Income__c * Decimal.valueOf(netMonthlyMultiplier))){
                    netIncomeEligible = true;
                }                
            }
       }
    }

    /*  Description: Method to validate changes and compute Totals prior saving.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public pageReference save(){
        System.debug('************************* save *******************');
        //check firt on application last modifiedDate
        Application__c recentApp = retrieveApplication(this.application.Id); 
        system.debug('=======txu debug====='+recentApp);
        system.debug('=============TXU DEBUG=========='+ this.application.Id);
        system.debug('=============TXU DEBUG=========='+ onloadLMD);
        system.debug('============TXU DEBUG=========='+recentApp.id);
        system.debug('=============TXU DEBUG=========='+ recentApp.LastModifiedDate);
        /**
            Tony Xu: Because we are now making Web service callouts for Retrieving Payoff Amount, the web service response will always update the Application
                     with its latest status, hence the previous if(onloadLMD != recentApp.LastModifiedDate) will be true all the time as the application is updated
                     by the web service response. Here we put in a new condition, to check if the Application.Last_Webservice_Operation_Invoked__c == 'Generate Payoff Figure',
                     If it's true then we don't check the lastmodifieddate
        **/
        if(onloadLMD != recentApp.LastModifiedDate && recentApp.Last_Webservice_Operation_Invoked__c != 'Generate Payoff Figure'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Application has been updated in the back end. Please refresh page'));
            return null;
        }

        Set<String> removeSet = new Set<String>();
        Boolean validateOk = true;
        Boolean eachRowOk = true;
        system.debug('!@#$Loan to Remove:'+loanToRemove);
        if(loanToRemove != ''){
            for(String s:loanToRemove.split(',')){
                removeSet.add(s);
            }           
        }
        upsertLoanList = new List<Loan_Purpose__c>();
        externalIdLoanPurposeMap = new Map<Integer, Loan_Purpose__c>();
        upsertDisbursementWrapperList = new List<DisbursementWrapper>();

        List<ONR__c> onrList = GEN_RecordRetrievalUtility.retrieveApplicationONR(application.Id);
        for(OfferPresentationWrapper off: offerList){
            system.debug('!@#$off.counter:'+off.counter);
            system.debug('!@#$rowCount:'+rowCount);
            if(off.counter <= rowCount){
                if(removeSet.contains(String.valueOf(off.counter)) && off.loan.Id != null){
                    delLoanList.add(off.loan);
                }
                else if(!removeSet.contains(String.valueOf(off.counter))){
                    if(off.loan.Id == null){
                        off.loan.Application__c = application.Id;
                    }
                    if(off.loan.Value__c != 'Other'){
                        off.loan.Other_Loan_Purpose__c = null;
                    }
                    off.loan.ONR__c = onrList[0].Id;
                    upsertLoanList.add(off.loan);
                    externalIdLoanPurposeMap.put(off.counter, off.loan);
                }
            }
        }
        system.debug('!@#$Del Loan List:'+delLoanList);
        system.debug('!@#$upsert loan list:'+upsertLoanList);
        //
        deleteDisbursementList = new List<Disbursement__c>();
        for(DisbursementWrapper dw : disbursementWrapperList){
            if(dw.counter <= rowCount){
                if(removeSet.contains(String.valueOf(dw.counter)) && dw.disbursement.Id != null) {
                    deleteDisbursementList.add(dw.disbursement);
                }
                else if(!removeSet.contains(String.valueOf(dw.counter))) {
                    if(dw.disbursement.Id == null) {
                        dw.disbursement.Application__c = application.Id;
                        dw.disbursement.RecordTypeId = recTypeIdRefinance;
                        if (this.application.Application_Type__c == 'Single') {
                           dw.disbursement.Applicable_Party__c = 'Applicant 1';
                        }
                    }
                    upsertDisbursementWrapperList.add(dw);
                }
            }
        }
        System.debug('upsertDisbursementWrapperList@@@@@'+upsertDisbursementWrapperList);
        System.debug('!@#$delete disbursement list:'+deleteDisbursementList);
        if(!upsertLoanList.isEmpty()){
            for(Loan_Purpose__c lp:upsertLoanList){
                if(lp.Value__c == 'Please Select' || lp.Loan_Amount__c == null){
                    eachRowOk = false;                   
                }
                else if(lp.Value__c == 'Other' && lp.Other_Loan_Purpose__c == null){
                    eachRowOk = false;
                }
            }
        }
        System.debug('eachRowOk-->'+eachRowOk);
        if(!eachRowOk){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Each row should have a value populated'));
            validateOk = false;
        }
        else{
            totalLoanAmount = 0;
            for(Loan_Purpose__c loan:upsertLoanList){
                totalLoanAmount = totalLoanAmount + loan.Loan_Amount__c;
            }
            //Decimal totalWithPremium = this.application.Total_Insurance_Premium__c != null ?  totalLoanAmount + this.application.Total_Insurance_Premium__c : totalLoanAmount + 0;
            if(application.Payment_Frequency__c == 'Please Select'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Frequency should be valid'));
                validateOk = false;
            }
            if(loanTermSelected == '' || loanTermSelected == 'Please Select' || loanTermSelected == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Term should be valid'));
                validateOk = false;
            }
            
            if(application.Brand_Country__c == 'AU'){
                if(applicant.Date_of_Birth_WS__c == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Applicant Date of Birth is required'));
                    validateOk = false;
                }
                else{
                    Date dbirth = Date.valueOf(dateOfBirthStr);
                    Integer temp = dbirth.daysBetween(Date.Today());
                    Integer age = Integer.valueOf(temp/365);
                    Decimal loanMaturity = age + Decimal.valueOf(loanTermSelected.split(' ', 2)[0])/
                              (loanTermSelected.ToLowerCase().contains('months')? 12 : 1 );
                    Boolean isInsured = false;
                        for(InsuranceWrapper i: wrapperInsure){
                          if(i.applicant1){
                            isInsured = true;
                          }
                        }
                    if(loanMaturity > 70 && isInsured){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Age Exceeded '+loanMaturity));
                        validateOk = false;
                    }
                }
            
                if(isJoint){
                    if(applicant2.Date_of_Birth_WS__c == null){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Applicant 2 Date of Birth is required'));
                        validateOk = false;
                    }
                    else{
                       Date dbirth = Date.valueOf(dateOfBirthStr2);
                       Integer temp2 = dbirth.daysBetween(Date.Today());
                       Integer age2 = Integer.valueOf(temp2/365);
                       Decimal loanMaturity2 = age2 + Decimal.valueOf(loanTermSelected.split(' ', 2)[0])/
                              (loanTermSelected.ToLowerCase().contains('months')? 12 : 1 );
                       Boolean isInsured = false;
                        for(InsuranceWrapper i: wrapperInsure){
                          if(i.applicant2){
                            isInsured = true;
                          }
                        }
                       if(loanMaturity2 > 70 && isInsured){
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Age Exceeded '+loanMaturity2+ ' for Applicant 2'));
                           validateOk = false;
                       }
                    }
                }
            }
            ageValidation = validateAge();
            OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
            offerCalculator.getProdutctItems(this.application);
            onLoadLoanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;     //BEGIN MLASALA: 31-AUG-15 WEEKLY CONTRACT PAYMENT ISSUE
            this.application.Total_Loan_Amount__c = totalLoanAmount;
            System.debug('this.application.Total_Loan_Amount__c:'+this.application.Total_Loan_Amount__c);
            
            /**Defect-1017**/
              if(application.Adjusted_Interest_Fee_Locked__c == false)
            {
               this.application.Offered_Establishment_Fee__c = 
               offerCalculator.getFee(this.application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);        
             }
            /**Defect 1017**/
             System.debug('this.application.Offered_Establishment_Fee__c:'+this.application.Offered_Establishment_Fee__c);
             
            if(application.Offered_Repayments__c > application.Max_Monthly_Capacity__c){
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'EMI should not exceed Maximum Monthly Capacity'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'EMI should not exceed Maximum Monthly Capacity'));
                //validateOk = false;
            }

            //BEGIN MLASALA: 25-SEPT-15 - TOTAL INSURANCE PREMIUM RULE FIX
            //Moved validation rule to code due to misalignment of total loan amount in Application and Loan Purpose
            //Validate if Insurance amounts are not null
            if(application.Total_Insurance_Premium__c != null && 
               application.Total_Loan_Amount_with_Insurance__c != null){
                
                System.debug('$$$: '+application.Total_Insurance_Premium__c+' > '+(application.Total_Loan_Amount_with_Insurance__c * 0.25));
                
                //Total Insurance Premium should not exceed 25% of Total Loan Amount with Insurance
                if(application.Total_Insurance_Premium__c > (application.Total_Loan_Amount_with_Insurance__c * 0.25)){

                    //Display error
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Total Insurance Premium should not exceed 25% of the Total Loan Amount'));

                    //Set validation to false
                    validateOk = false;
                }
            }
            //END MLASALA: 25-SEPT-15 - TOTAL INSURANCE PREMIUM RULE FIX
        }
        
        if(validateOk){
            updateComputation(totalLoanAmount);
        }
        return null;       
    }
    
     /*  Description: Method save changes and update application record.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */ 
    public void updateComputation(Decimal totalLoanAmount){        
            
        List<Offer_Presented__c> updateOfferPresented = new List<Offer_Presented__c>();
        for(Offer_Presented__c offer: getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_UNSECURED_UPSELL)){
            offer.Accepted__c = true;
            updateOfferPresented.add(offer);
        }
        
        if(!updateOfferPresented.isEmpty()){
            try{
                update updateOfferPresented;

            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Offer_Presented__c', 'Class', String.valueOf(this.application.Id));    
            }
        }
        
        if(!delLoanList.isEmpty()){
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Loan_Purpose__c.sObjectType.getDescribe().isDeletable()){
                  delete delLoanList;
                }
                */
                delete delLoanList;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));    
            }
            
        }

/*            
        if(!upsertLoanList.isEmpty()){
            try{
                upsert upsertLoanList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class');    
            }
        }
*/
        // Use Map upsert instead of List upsert to preserve mapping information (ID and Loan_Purpose__c) 
        if(!externalIdLoanPurposeMap.isEmpty()){
            try{
                upsert externalIdLoanPurposeMap.values();
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class', String.valueOf(this.application.Id));    
            }
        }            

        // Upsert disbursement record/s that correspond to Loan Purpose record/s 
        System.debug('upsertDisbursementWrapperList-->'+upsertDisbursementWrapperList);
        if(!upsertDisbursementWrapperList.isEmpty()) {
            upsertDisbursementList = new List<Disbursement__c>();
            System.debug('externalIdLoanPurposeMapDebug-->'+externalIdLoanPurposeMap);
            for (DisbursementWrapper dw : upsertDisbursementWrapperList) {
                if (externalIdLoanPurposeMap.containsKey(dw.counter)) {
                    dw.disbursement.Loan_Purpose__c = externalIdLoanPurposeMap.get(dw.counter).Id;   
                    dw.disbursement.Amount__c = externalIdLoanPurposeMap.get(dw.counter).Loan_Amount__c; 
                    upsertDisbursementList.add(dw.disbursement);  
                }
            }
            if (!upsertDisbursementList.isEmpty()) {
              try {
                  //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                  //if(Disbursement__c.SObjectType.getDescribe().isCreateable()) {
                    upsert upsertDisbursementList;
                  //}
              }
              catch(DMLException e){
                  ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Disbursement_c', 'Class', String.valueOf(this.application.Id));    
              }
            }
        }
        System.debug('upsertDisbursementList-->'+upsertDisbursementList);


        // Delete disbursment records that are removed from the UI
        if(!deleteDisbursementList.isEmpty()){
            try{
              /*CHECKMARX
              // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
              if(Disbursement__c.sObjectType.getDescribe().isDeletable()){
                delete deleteDisbursementList;
              }
              */
              delete deleteDisbursementList;
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Disbursement__c', 'Class', String.valueOf(this.application.Id));    
            }
            
        }

        if(loanTermSelected != null && loanTermSelected != '0' && loanTermSelected != '') {
         //Added by Arshad for Better start
             if(this.application.Product_SubType__c != 'Better Start PL'){
               this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*
               (loanTermSelected.ToLowerCase().contains('months')?1:12);
               this.application.Loan_Term__c = loanTermSelected;  
            }else{
               this.application.Loan_Term_Months__c = Decimal.valueOf(loanTermSelected.split(' ', 2)[0])*12;
              this.application.Loan_Term__c = loanTermSelected;                           
            }
        }
        
        //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();
        
        //BEGIN MLASALA: 02-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
        //Recalculate interest rate before any other calculation is done so that repayments will use the correct interest rate
        //Mainly applicable to AU because secured and unsecured applications have different rate cards
        System.debug('$$$ compare: '+onLoadLoanAmount+' - '+totalLoanAmount);
        //if loan amount was changed, run Pricing Rule engine
        if(onLoadLoanAmount != totalLoanAmount){
            originalRate = this.application.Offered_Interest_Rate__c;

            //Update application prior to other calculation to compute new capacity that will be used to identify the correct rate card
            if(!application.Customer_Confirmed_Online_Offer__c && (application.Online_Self_serve_Upsell_Eligibility__c || application.Online_Self_serve_Insurance_Eligibility__c)){
                application.Staff_Hide__c = true;
            }
            update application;
            List<Id> applicationId = new List<Id>();
            applicationId.add(this.application.Id);
            //Run Pricing Rule engine
            RUL_Engine.runPricingEngineAsync(applicationId);
            //Refresh application
            this.application = APP_CommonVariables.retrieveApplication(this.application.Id);
            
            //MLASALA: 16-JUN-16 TQLQW-33 Upsell Eligibility, Offer and Acceptance
            //Create offer history
            debugLogList.add(Util.createInsuranceActivity(this.application.Id, 
                                                          'Upsell', 
                                                          null, 
                                                          UserInfo.getName(),
                                                          onLoadLoanAmount, 
                                                          totalLoanAmount));
        }
        //END MLASALA: 02-SEPT-15 WEEKLY CONTRACT PAYMENT ISSUE
        //this.application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(this.application);

        //Added by Mike Lasala 05/19/15 for calculation debugging
        Debug_Log__c debugLog = Util.createDebugLog(this.application.Id, 'Offers after update: '+System.now(), 'OFF_OfferPresentationExt', 'updateComputation');

        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItems(this.application);

        this.application.Total_Loan_Amount__c = totalLoanAmount; 
        
        //MLASALA 26-SEPT-16 TQLQW-497 Promo engine
        //Added condition for promo engine
        if(this.application.Adjusted_Interest_Fee_Locked__c == false && 
           application.Offered_Establishment_Fee__c == null){
            this.application.Offered_Establishment_Fee__c = offerCalculator.getFee(this.application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);
            debugLog.Calculation_Log__c += 'Offered_Establishment_Fee__c: '+tempApplication.Offered_Establishment_Fee__c+' --> '+this.application.Offered_Establishment_Fee__c+'\n';
        }

        //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        //Identifier if rate has changed
        Boolean isRateChange = false;
        Boolean hasInsurance = false;

        System.debug('!@#$TXU DEBUG originalRate:'+originalRate);
        system.debug('!@#$TXU DEBUG adjusted rate:'+this.application.Adjusted_Interest_Rate__c);
        
        Decimal tempTotalInsurancePremium = application.Total_Insurance_Premium__c;
        //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

        System.debug('$$$ Adjusted_Interest_Rate__c: '+application.Adjusted_Interest_Rate__c+' originalRate: '+originalRate);
        //check if the rate is currently the same with adjusted rate.
        if(this.application.Adjusted_Interest_Rate__c != null && this.application.Adjusted_Interest_Rate__c == originalRate){
            //Decimal newRate = application.Offered_Interest_Rate__c;
            //System.debug('newRate--->'+newRate);

            //if(this.application.Adjusted_Interest_Rate__c == newRate){
            //    //consider adjustedRate;
            //    this.application.Offered_Interest_Rate__c = newRate;
            //}
            //else{
            //    //they are not equal, get interestRate from the matrix and calculate blended.
            //    this.application.Offered_Interest_Rate_Orig__c  = offerCalculator.getBlendedRate(this.application, offerCalculator.getInterestRate(this.application));  
            //    this.application.Offered_Interest_Rate__c = offerCalculator.getBlendedRate(this.application, offerCalculator.getInterestRate(this.application)); 

            //    //BEGIN MLASALA: 08/12/15 CAPINC0730846 - UNABLE TO PROCESS RATE REDUCTION WORKFLOWS
            //    //debugLog.Calculation_Log__c += 'Adjusted_Interest_Rate__c: '+tempApplication.Adjusted_Interest_Rate__c+' --> '+this.application.Adjusted_Interest_Rate__c+'\n';
            //}

            //since we will not be using the adjusted rate, set the adjusted fields to null and false.
            //this will allow the agent in case he wants to do another rate reduction. 
            this.application.Adjusted_Interest_Rate_Locked__c = false;
            this.application.Adjusted_Interest_Rate_Reason__c = '';
            this.application.Adjusted_Interest_Rate__c = null;
            this.application.Workflow_In_Progress__c = false;
            //END MLASALA: 08/12/15 CAPINC0730846 - UNABLE TO PROCESS RATE REDUCTION WORKFLOWS

            //we need to flush insurance because there is an approved rate and there is a change in the loan amount.           
            //put application in a list            
            List<Application__c> applist = new List<Application__c>();
            applist.add(this.application);
           
            //call the method to flush insurance
            GEN_OfferUtility.flushOffers(applist);

            //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            if(this.application.Total_Insurance_Premium__c != null && 
               this.application.Total_Insurance_Premium__c != 0){

                hasInsurance = true;
            }

            //set Total_Insurance_Premium__c field to zero
            this.application.Total_Insurance_Premium__c = 0;

            //Set flag to true
            isRateChange = true;
            //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        }
        else{
            //BEGIN MLASALA: 31-AUG-15 WEEKLY CONTRACT PAYMENT ISSUE
            //system.debug('!@#$Tony DEBUG interestRate:'+offerCalculator.getInterestRate(this.application));
            //this.application.Offered_Interest_Rate_Orig__c = offerCalculator.getBlendedRate(this.application, offerCalculator.getInterestRate(this.application));
            //this.application.Offered_Interest_Rate__c = offerCalculator.getBlendedRate(this.application, offerCalculator.getInterestRate(this.application));
            //END MLASALA: 31-AUG-15 WEEKLY CONTRACT PAYMENT ISSUE
            //check if there is changes on the rate.
            if(originalRate != application.Offered_Interest_Rate__c){
                //put application in a list            
                List<Application__c> applist = new List<Application__c>();
                applist.add(this.application);
                
                //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                if(this.application.Total_Insurance_Premium__c != null && 
                   this.application.Total_Insurance_Premium__c != 0){

                    hasInsurance = true;
                }
            
                //call the method to flush insurance
                GEN_OfferUtility.flushOffers(applist);
                //set Total_Insurance_Premium__c field to zero
                this.application.Total_Insurance_Premium__c = 0;

                //Set flag to true
                isRateChange = true;
                //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            }
            else{
                this.application.Total_Insurance_Premium__c = getPremium();
            }
        }

        RUL_InsurancePremiumCalculator ruleSelection = new RUL_InsurancePremiumCalculator();

        this.application.Total_Insurance_Interest_Amount_Payable__c = ruleSelection.computeTotalAmountInsurancePayable(this.application);
        this.application.Total_Loan_Interest_Amount_Payable__c = ruleSelection.computeTotalInterestAmountPayable(this.application);
        
        //get the OverallTotal with the new Total Insurance Premium
        System.debug('$$$ application.Offered_Interest_Rate__c offers: '+application.Offered_Interest_Rate__c);
        this.application.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee (this.application);
        this.application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(this.application);
        this.application.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(this.application);
        this.application.Out_Of_Sync__c = true;
        
        //Added by Mike Lasala 05/19/15 for calculation debugging
        debugLog.Calculation_Log__c += 'Loan_Term_Months__c: '+tempApplication.Loan_Term_Months__c+' --> '+this.application.Loan_Term_Months__c+'\n';
        debugLog.Calculation_Log__c += 'Total_Loan_Amount__c: '+tempApplication.Total_Loan_Amount__c+' --> '+this.application.Total_Loan_Amount__c+'\n';
        debugLog.Calculation_Log__c += 'Offered_Interest_Rate_Orig__c: '+tempApplication.Offered_Interest_Rate_Orig__c+' --> '+this.application.Offered_Interest_Rate_Orig__c+'\n';
        debugLog.Calculation_Log__c += 'Offered_Interest_Rate__c: '+tempApplication.Offered_Interest_Rate__c+' --> '+this.application.Offered_Interest_Rate__c+'\n';
        debugLog.Calculation_Log__c += 'Total_Insurance_Premium__c: '+tempApplication.Total_Insurance_Premium__c+' --> '+this.application.Total_Insurance_Premium__c+'\n';
        debugLog.Calculation_Log__c += 'Total_Insurance_Interest_Amount_Payable__c: '+tempApplication.Total_Insurance_Interest_Amount_Payable__c+' --> '+this.application.Total_Insurance_Interest_Amount_Payable__c+'\n';
        debugLog.Calculation_Log__c += 'Total_Loan_Interest_Amount_Payable__c: '+tempApplication.Total_Loan_Interest_Amount_Payable__c+' --> '+this.application.Total_Loan_Interest_Amount_Payable__c+'\n';
        debugLog.Calculation_Log__c += 'EMI_with_Service_Fee__c: '+tempApplication.EMI_with_Service_Fee__c+' --> '+this.application.EMI_with_Service_Fee__c+'\n';
        debugLog.Calculation_Log__c += 'Offered_Repayments__c: '+tempApplication.Offered_Repayments__c+' --> '+this.application.Offered_Repayments__c+'\n';
        debugLog.Calculation_Log__c += 'Offered_Frequency_Repayments__c: '+tempApplication.Offered_Frequency_Repayments__c+' --> '+this.application.Offered_Frequency_Repayments__c;

        String errorMessage = '';

        //Verify if application has insurance and rate changed due to change of loan amount
        if(hasInsurance && 
           isRateChange && 
           onLoadLoanAmount != totalLoanAmount){

            //Populate error message on application
            this.application.Insurance_Error_Message__c = Util.updateInsuranceInfoMessage(this.application.Id, 
                                                                                          this.application.Insurance_Error_Message__c, 
                                                                                          GEN_OriginationsConstants.RATE_CHANGE_INSURANCE_INFO_MESSAGE);

            debugLogList.add(Util.createInsuranceActivity(application.Id, 
                                                          'Flush', 
                                                          GEN_OriginationsConstants.INSURANCE_TYPE_ALL, 
                                                          'System', 
                                                          tempTotalInsurancePremium, 
                                                          0));
        }
        //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

        try{
            if(!application.Customer_Confirmed_Online_Offer__c && (application.Online_Self_serve_Upsell_Eligibility__c || application.Online_Self_serve_Insurance_Eligibility__c)){
                application.Staff_Hide__c = true;
            }
            update application;

            tempApplication = GEN_RecordRetrievalUtility.retrieveApplication(this.application.Id);

            totalInterest = computeTotalInterest();
            if(application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA  && 
               application.Generated_Doc_Confirm_Sent__c){      //MLASALA 19-APR-2016 FLUSH ONLY ON POST DOC GEN
                List<Application__c> flushGenDoc = new List<Application__c>();
                flushGenDoc.add(application);
                GEN_PCAUtility.flushComplianceChecklistandLoanDocuments(flushGenDoc);
            }
        }
        catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Application__c', 'Class', String.valueOf(this.application.Id));    
        }


        //Added by Mike Lasala 05/19/15 for calculation debugging
        if(debugLog != null){

            //BEGIN MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
            debugLogList.add(debugLog);
        }
        
        if(!debugLogList.isEmpty()){
            try{
                insert debugLogList;
                //END MLASALA: 08/06/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Debug_Log__c', 'Class', String.valueOf(this.application.Id));
            }
        }
        
        //appResponse = getAppRes();
        remaining = capacity - this.application.Total_Loan_Amount_with_Insurance__c;
        fees = this.application.Total_Loan_Amount_with_Insurance__c -  this.application.Total_Loan_Amount__c;
        remainingWidth = getWidth(remaining, capacity);
        feesWidth = getWidth(fees, capacity);
        //wrapperDebt = new List<DebtWrapper>(); - part of phase 2
        wrapperHeader = new List<HeaderWrapper>();
        this.application = retrieveApplication(this.application.Id);
        onloadLMD = this.application.LastModifiedDate;
        System.debug('***Calling reset Variables ***');
        resetVariables();
        displayCalculated = true;
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Recalculated'));
    }
    
     /*  Description: Method to validate the total insurance premium and saving it against the application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Pagereference computePremium(Savepoint sp){
        
        Decimal premium = getPremium();
        System.debug('Premium-->'+premium);
        Decimal oldInsurance = application.Total_Insurance_Premium__c != null ? application.Total_Insurance_Premium__c : 0;        
        Decimal totalWithInsurance = premium + (application.Total_Loan_Amount_with_Insurance__c - oldInsurance);
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItems(this.application);
        
        this.application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(this.application);
        if(application.Offered_Repayments__c > application.Max_Monthly_Capacity__c){
             //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'EMI should not exceed Maximum Monthly Capacity'));
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'EMI should not exceed Maximum Monthly Capacity'));
             //database.rollback(sp);
             //this.application = retrieveApplication(this.application.Id);
             //resetVariables();
             //return null;
        }
        //else{
            try{
                update insuranceList;
             }
             catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Offer_Presented__', 'Class', String.valueOf(this.application.Id));    
             }
             
            this.application.Total_Insurance_Premium__c = premium;
            
            RUL_InsurancePremiumCalculator ruleSelection = new RUL_InsurancePremiumCalculator();
            this.application.Total_Insurance_Interest_Amount_Payable__c = ruleSelection.computeTotalAmountInsurancePayable(this.application);
            this.application.Total_Loan_Interest_Amount_Payable__c = ruleSelection.computeTotalInterestAmountPayable(this.application);
            
            //this.application.Offered_Interest_Rate__c = offerCalculator.getInterestRate(this.application);
            //this.application.Offered_Interest_Rate__c = offerCalculator.getBlendedRate(this.application, this.application.Offered_Interest_Rate__c);   
            this.application.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(this.application);
            this.application.Offered_Repayments__c = offerCalculator.getRepaymentEMI(this.application);
            this.application.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(this.application);
            
            //Added by Mike Lasala 05/19/15 for calculation debugging
            Debug_Log__c debugLog = Util.createDebugLog(this.application.Id, 'Offers after select/unselect of insurance: '+System.now(), 'OFF_OfferPresentationExt', 'computePremium');
            debugLog.Calculation_Log__c += 'Total_Insurance_Premium__c: '+tempApplication.Total_Insurance_Premium__c+' --> '+this.application.Total_Insurance_Premium__c+'\n';
            debugLog.Calculation_Log__c += 'Total_Insurance_Interest_Amount_Payable__c: '+tempApplication.Total_Insurance_Interest_Amount_Payable__c+' --> '+this.application.Total_Insurance_Interest_Amount_Payable__c+'\n';
            debugLog.Calculation_Log__c += 'Total_Loan_Interest_Amount_Payable__c: '+tempApplication.Total_Loan_Interest_Amount_Payable__c+' --> '+this.application.Total_Loan_Interest_Amount_Payable__c+'\n';
            debugLog.Calculation_Log__c += 'EMI_with_Service_Fee__c: '+tempApplication.EMI_with_Service_Fee__c+' --> '+this.application.EMI_with_Service_Fee__c+'\n';
            debugLog.Calculation_Log__c += 'Offered_Repayments__c: '+tempApplication.Offered_Repayments__c+' --> '+this.application.Offered_Repayments__c+'\n';
            debugLog.Calculation_Log__c += 'Offered_Frequency_Repayments__c: '+tempApplication.Offered_Frequency_Repayments__c+' --> '+this.application.Offered_Frequency_Repayments__c;

            if(debugLog != null){
                try{
                    insert debugLog;

                    tempApplication = GEN_RecordRetrievalUtility.retrieveApplication(this.application.Id);

                } catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Debug_Log__c', 'Class', String.valueOf(this.application.Id));
                }
            }

            return updateApplication(sp);
        //}         
    }
    
    /*  Description: Method to get the total insurance premium.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Decimal getPremium(){
        RUL_InsurancePremiumCalculator.RUL_InsuranceSelection ruleSelection = new RUL_InsurancePremiumCalculator.RUL_InsuranceSelection();  
        
        for(InsuranceWrapper iw:wrapperInsure){
            if(iw.insuranceType == 'Life Insurance'){
                ruleSelection.lifePremiumSingle = iw.applicant1;
                ruleSelection.lifePremiumJoint = iw.applicant2;
            }
            else if(iw.insuranceType == 'Disability Insurance'){
                ruleSelection.disabilityPremiumSingle = iw.applicant1;
                ruleSelection.disabilityPremiumJoint = iw.applicant2;
            }
            else if(iw.insuranceType == 'Involuntary Unemployment Insurance'){
                ruleSelection.iUIPremiumSingle = iw.applicant1;
                ruleSelection.iUIPremiumJoint = iw.applicant2;
            }
        }
        ruleSelection.inputTotalLoanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
        
        Decimal establishmentFee = application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        Decimal SearchFee = application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        Decimal RegistrationFee = application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        ruleSelection.inputFees =   establishmentFee + SearchFee + RegistrationFee + brokerFee;
        
        ruleSelection.inputLoanTerm = application.Loan_Term_Months__c != null ? application.Loan_Term_Months__c : 0;
        
        Decimal repayments = application.Offered_Repayments__c != null ? application.Offered_Repayments__c : 0;
        Decimal monthlyServiceFee = application.Offered_Monthly_Loan_Service_Fee__c != null ? application.Offered_Monthly_Loan_Service_Fee__c : 0;
        ruleSelection.inputEMI =  repayments; // - monthlyServiceFee;
        
        ruleSelection.inputAPR = application.Offered_Interest_Rate__c != null ? application.Offered_Interest_Rate__c : 0;        
        
        ruleSelection.inputState = application.State__c;
        
        ruleSelection.lastModDate = application.LastModifiedDate;
        
        System.debug('********ruleSelection-->'+ruleSelection);

        //Added by Fel Saliba 12/16/2014 - Check on the Country of origin first
        Decimal premium = 0;
        if(application.Brand_Country__c == 'AU'){
          RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
          premium = rul.calculateInsurancePremiums(ruleSelection);
        }
        else if(application.Brand_Country__c == 'NZ'){
          RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
          rulNZ.calculateInsurnaceNZ(application, 
                                     ruleSelection.lifePremiumSingle,
                                     ruleSelection.disabilityPremiumSingle,
                                     ruleSelection.iUIPremiumSingle,
                                     ruleSelection.lifePremiumJoint,
                                     ruleSelection.disabilityPremiumJoint,
                                     ruleSelection.iUIPremiumJoint);

          premium = rulNZ.totalInsurancePremium;
        }
        System.debug('premium--->'+premium);
        return premium;
    }
    
    /*  Description: Method to get the width for the header component.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Decimal getWidth(Decimal amount, Decimal capacity){        
        Decimal width = 0;
        if(capacity > 0)
            width = (amount/capacity)*100;
        System.debug('width-->'+width);
        return width;    
    }
    
    
    /*  Description: Method to get Asset fields to use in query.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    //public List<Schema.FieldSetMember> getAssetFields() {
    //    return SObjectType.Asset__c.FieldSets.Asset_Commons.getFields();
    //}
    
    // Commented out will be part of Phase 2
    /*  Description: Method to get List of Assets related to the Application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    /*private List<Asset__c> getAssetList() {
        String appId = applicant.Id;
        String query = 'SELECT ';
        String house = 'House';
        for(Schema.FieldSetMember f : this.getAssetFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'CreatedDate FROM Asset__c where Applicant__c =: appId AND Asset_Category__c !=: house';
        
        List<Collateral_Settings__c> au = Collateral_Settings__c.getall().values();
        if(au.size()>0){
            Decimal min;
            Decimal max;            
            if(au[0].Collateral_Maximum_Value__c != null && au[0].Collateral_Minimum_Value__c != null){
                min = au[0].Collateral_Minimum_Value__c;
                max = au[0].Collateral_Maximum_Value__c;
                query += ' AND Total_Assets__c >=: min AND Total_Assets__c <=: max';
            }
            else if(au[0].Collateral_Maximum_Value__c == null && au[0].Collateral_Minimum_Value__c != null){
                min = au[0].Collateral_Minimum_Value__c;
                query += ' AND Total_Assets__c >=: min';
            }
            else if(au[0].Collateral_Maximum_Value__c != null && au[0].Collateral_Minimum_Value__c == null){
                max = au[0].Collateral_Maximum_Value__c;
                query += ' AND Total_Assets__c <=: max';
            } 
        }
               
        System.debug('query-->'+query); 
        return Database.query(query);
    }*/
    
    // Commented out will be part of Phase 2
    /*  Description: Method to get Liability fields to use in query.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    /*public List<Schema.FieldSetMember> getDebtFields() {
        return SObjectType.Liability__c.FieldSets.Liability_Commons.getFields();
    }*/
    
    // Commented out will be part of Phase 2
     /*  Description: Method to get List of Liabilities related to the Application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
   /*private List<Liability__c> getDebtList() {
        String appId = applicant.Id;
        String mortgage = 'Mortgage';
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getDebtFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'CreatedDate FROM Liability__c where Debt_Category__c !=: mortgage AND Applicant__c =: appId';
        System.debug('query-->'+query); 
        return Database.query(query);
    }*/
    
    /*  Description: Method to get Product Version fields to use in query.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public List<Schema.FieldSetMember> getProductVersionFields() {
        return SObjectType.Product_Version__c.FieldSets.Product_Version_Commons.getFields();
    }
    
    /*  Description: Method to get List of Product Versions related to the Application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    private List<Product_Version__c> getProductVersionList() {
        String brand = application.Brand_String__c;
        String type = 'Personal Loan';
        Datetime today = System.now();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getProductVersionFields()) {
            query += f.getFieldPath() + ', ';
        } 
        query += 'CreatedDate, GEProduct__r.Insurance_Type__c FROM Product_Version__c where Brand__c =: brand AND Type__c !=: type AND (Start_date__c = null OR start_date__c <=: today)AND (end_date__c = null  OR end_date__c >=: today) Order by GEProduct__r.Insurance_Type__c';
        System.debug('queryProdVersion-->'+query); 
        return Database.query(query);
    }
    
    /*  Description: Method to get Application Response fields to use in query.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Application_Response__c.FieldSets.Application_Response_Commons.getFields();
    }
    
    /*  Description: Method to get List of Product Collateral records related to Application.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    private List<Product_Collateral__c> getProductCollaterals(Set<String> prodIds){
        Datetime today = System.now();
        String PDS = 'PDS';
        String FSG = 'FSG';
        String query = 'SELECT Id, Collateral_URL__c, Product__r.Name from Product_Collateral__c Where Product__c IN: prodIds AND (Type__c =: PDS OR Type__c =: FSG) AND (Start_date__c = null OR start_date__c <=: today)AND (end_date__c = null  OR end_date__c >=: today)';
        
        System.debug('ProdCollateral-->'+query); 
        List<Product_Collateral__c> prodCollateral = new List<Product_Collateral__c>(); 
        prodCollateral = Database.query(query);
        
        Set<String> collateralURL = new Set<String>();
        Map<String,Product_Collateral__c> prodCollateralMap = new Map<String,Product_Collateral__c>();
        if(!prodCollateral.isEmpty()){
            for(Product_Collateral__c pc: prodCollateral){
                if(!prodCollateralMap.containsKey(pc.Collateral_URL__c)){
                    prodCollateralMap.put(pc.Collateral_URL__c, pc);
                }
            }
        }
        System.debug('AFTER-->'+prodCollateralMap);
        if(prodCollateralMap.size()==1){
            return prodCollateralMap.Values();
        }
        else{
            return prodCollateral;
        }
        
    }
    
    /*  Description: Method to get Application Response record.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    private List<Application_Response__c> getAppRes() {
        String appId = application.Id;
        System.debug('appId -->'+appId);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Application_Response__c where Application__c =: appId Order by CreatedDate Desc';
        System.debug('queryApp-->'+query); 
        return Database.query(query);
    }
    
    /*  Description: Title Field Picklist values
     *  Author: Russell Cadapan
     *  Date Created: SEPT-24-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
/*    public List<SelectOption> loanTermOptions { 
        get {
            Brand__c brand = [SELECT Loan_Term__c FROM Brand__c WHERE Id =: this.application.Brand_Lookup__c];
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Please Select'));
            if(brand.Loan_Term__c != null && brand.Loan_Term__c != ''){
                for(String s: brand.Loan_Term__c.split(';')){
                    options.add(new SelectOption(s, s));
                }
            }
            return options;
        }
    set; 
    } */
    
    /*  Description: Title Field Picklist values
     *  Author: Dan Crisologo
     *  Date Created: OCT-22-2013
     *  Input Parameters: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> loanPurposeOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            List<Meta_ONR__c> metaONR = new List<Meta_ONR__c>(); 
            //Changed by Fahad Akhtar: When type of product is Auto Loan, The only purpose show be avaialble is car purchase.
            if(application.Type_of_Product__c != GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)            
               //Added By Suneel - Beat the Banks 18/01/2018
              if(application.Brand_String__c == 'Latitude' || application.Brand_String__c == 'Kiwibank') 
              metaONR = [ 
                          SELECT    Value__c 
                          FROM      Meta_ONR__c 
                          WHERE     ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                          AND      Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                          AND       (Region__c =: application.Brand_Lookup__r.Country__c 
                          OR         Region__c =: GEN_OriginationsConstants.BOTH)
                          ORDER BY  Value__c ASC
                        ];
            //Added By Suneel - Beat the Banks 18/01/2018
            if(application.Brand_String__c == 'GEM')
           
             metaONR = [ 
                          SELECT    Value__c 
                          FROM      Meta_ONR__c 
                          WHERE     ONR_Type__c =: GEN_OriginationsConstants.ONR_LOAN_PURPOSE
                          AND      Type__c =: GEN_OriginationsConstants.ONR_TYPE_CHOICE
                          AND       (Region__c =: application.Brand_Lookup__r.Country__c 
                          OR         Region__c =: GEN_OriginationsConstants.BOTH
                          OR         Region__c = 'Gem')
                          ORDER BY  Value__c ASC
                        ];
            
            options.add(new SelectOption('Please Select', 'Please Select'));
            //Changed by Fahad Akhtar: When type of product is Auto Loan, The only purpose show be avaialble is car purchase.
            if(application.Type_of_Product__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)
                options.add(new SelectOption(GEN_OriginationsConstants.ONR_CAR_PURCHASE, GEN_OriginationsConstants.ONR_CAR_PURCHASE));            
            String other = '';
            for(Meta_ONR__c mONR: metaONR){
                if(mONR.value__c == 'Other'){
                    other = mONR.value__c;    
                }else{
                    options.add(new SelectOption(mONR.value__c,mONR.value__c));
                }
            }
            //Changed by Fahad Akhtar: When type of product is Auto Loan, The only purpose show be avaialble is car purchase.            
            if(other!= '')            
              options.add(new SelectOption(other,other));
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
    public List<SelectOption> loanFrequencyOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            
            Map<String, Schema.SObjectField> fieldMap=new Map<String, Schema.SObjectField>();
            fieldMap=Schema.SObjectType.Application__c.fields.getMap();
            List<Schema.PicklistEntry> pickList = fieldMap.get('Payment_Frequency__c').getDescribe().getPickListValues();
            
            options.add(new SelectOption('Please Select', 'Please Select'));
            
            for(Schema.PicklistEntry pickvar: pickList){
                options.add(new SelectOption(String.valueOf(pickVar.getValue()),String.valueOf(pickVar.getLabel())));
            }
            return options;
        }
    set; 
    }
    
    /*  Description: Update Application Record 
     *  Author: Fel
     *  Date Created: NOV-19-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference updateApplicationConsent() {
        Savepoint sp = Database.setSavepoint();        
        return updateApplication(sp);
    }
    
    /*  Description: Update Application Record 
     *  Author: Fel
     *  Date Created: NOV-19-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
     public PageReference updateApplication(Savepoint sp) {
         try{
                application.Out_Of_Sync__c = true; 
                if(!application.Customer_Confirmed_Online_Offer__c && (application.Online_Self_serve_Upsell_Eligibility__c || application.Online_Self_serve_Insurance_Eligibility__c)){
                    application.Staff_Hide__c = true;
                }
                update application;
                this.application = retrieveApplication(application.Id);
                onLoadLMD = this.application.LastModifiedDate;
                totalInterest = computeTotalInterest();
                if(application.Response_Code__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_PCA  && 
                   application.Generated_Doc_Confirm_Sent__c){      //MLASALA 19-APR-2016 FLUSH ONLY ON POST DOC GEN
                    List<Application__c> flushGenDoc = new List<Application__c>();
                    flushGenDoc.add(application);
                    GEN_PCAUtility.flushComplianceChecklistandLoanDocuments(flushGenDoc);
                }
                PageReference pageRef = Page.OFF_OfferPresentation;
                pageRef.getParameters().put('id', String.valueOf(this.application.Id));
                pageRef.setRedirect(true);
                return pageRef;
         }
         catch(DMLException e){
            ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Application__c', 'Class', String.valueOf(this.application.Id));  
            ApexPages.addMessages(e); 
            database.rollback(sp);
            this.application = retrieveApplication(this.application.Id);
            resetVariables();
            return null; 
         }            
     }
    
    /*  Description: Check if MasterOfferFlag = true and no downsell offer is selected
     *  Author: Dan
     *  Date Created: OCT-31-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
     public PageReference validateRedirect() {
        
        PageReference ref;            
         if(isCustomer()){
             //validate that there is at least 1 app response
             /*List<Application_Response__c> appResponse = [Select   Id, 
                                                                   Master_Offer_Flag__c 
                                                          from     Application_Response__c 
                                                          where    Application__c =: this.application.Id 
                                                          order by CreatedDate DESC
                                                          limit    1];*/
                                                          
            offerPresentedIds = new Set<String>();
           
            if(!offPresentedList.isEmpty()){
                for(Offer_Presented__c offer: offPresentedList){
                    offerPresentedIds.add(offer.Id);
                }
            }
             
             if(appResponse == null || appResponse.size()==0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Application Record'));
             } else {
                 //validate master off flag should be true
                 if(!application.Master_Offer_Flag__c) {
                    ref =  Page.APP_ReferredResponse;
                    ref.getParameters().put('id', this.application.Id);
                    ref.setRedirect(true);
                 } else {
                    //validate that there are no downsell offers
                    if(offerPresentedIds.size()>0){
                        List<Offer_Presented__c> offerPresented = [Select  Id 
                                                                   from    Offer_Presented__c
                                                                   where   (Offer__r.type__c =: GEN_OriginationsConstants.OFFER_TYPE_SECURED_DOWNSELL
                                                                    OR     Offer__r.type__c =: GEN_OriginationsConstants.OFFER_TYPE_UNSECURED_DOWNSELL)
                                                                    AND Application_Response__c =: appResponse[0].Id];
                        if(offerPresented.size()>0) {
                            ref =  Page.APP_ReferredResponse;
                            ref.getParameters().put('id', this.application.Id);
                            ref.setRedirect(true);
                        }
                    }
                    else if(application.Offered_Interest_Rate__c == null || this.application.Offered_Interest_Rate__c == 0){

                        ref =  Page.APP_ReferredResponse;
                        ref.getParameters().put('id', this.application.Id);
                        ref.setRedirect(true);
                    }
                 }
             }
        }   
        //Afreen - 485
        /*if(ref == null){
          insuranceOffer();
        } */          
         return ref;
     }
     
    /*  Description: Method to insert new Loan from list of Debt records
     *  Author: Fel
     *  Date Created: NOV-04-2013
     *  Input Parameters: None
     *  Return: Page Reference
     */
     
    //Commented out Debt Consolidation will not be part of phase 1.
     
    /*
    public pageReference addLoanDebt(){
        
        //update the debt records
           Boolean consolidatedCreditCard = false;
           Boolean consolidatedOverdraft = false;
           Boolean consolidatedCarLoan = false;
           Boolean consolidatedPersonalLoan = false;
           Boolean consolidatedStoreCard = false;
        
        for(DebtWrapper dw: wrapperDebt){
            if(dw.debtCategory == 'Credit Card'){
                consolidatedCreditCard = dw.isConsolidated;
            }
            else if(dw.debtCategory == 'Overdraft'){
                consolidatedOverdraft = dw.isConsolidated;
            }
            else if(dw.debtCategory == 'Car Loan'){
                consolidatedCarLoan = dw.isConsolidated;
            }
            else if(dw.debtCategory == 'Personal Loan'){
                consolidatedPersonalLoan = dw.isConsolidated;
            }
            else if(dw.debtCategory == 'Store Card'){
                consolidatedStoreCard = dw.isConsolidated;
            }
        }
        for(Liability__c l: debtList){
           if(l.Debt_Category__c == 'Credit card'){
              l.Consolidated__c = consolidatedCreditCard;                  
           }
           else if(l.Debt_Category__c == 'Overdraft'){
              l.Consolidated__c = consolidatedOverdraft; 
           }
           else if(l.Debt_Category__c == 'Car Loan'){
              l.Consolidated__c = consolidatedCarLoan; 
           }
           else if(l.Debt_Category__c == 'Personal Loan'){
              l.Consolidated__c = consolidatedPersonalLoan; 
           }
           else if(l.Debt_Category__c == 'Store Card'){
              l.Consolidated__c = consolidatedStoreCard; 
           }
        }
        
        
        for(Loan_Purpose__c loan:retrieveLoanPurposeList()){
            if(loan.Value__c != 'Debt consolidation'){
                totalLoanAmount = totalLoanAmount + loan.Loan_Amount__c;
            }
        }         
        System.debug('Total-->'+totalLoanAmount);
        //this.debtList = getDebtList();
         //add consolidated debts
         Decimal totalDebt = 0;
         for(Liability__c debt:DebtList){
             if(debt.Consolidated__c){
                 totalDebt = totalDebt + debt.Total_Debts__c;
             }
         }
         
        Decimal oldInsurance = application.Total_Insurance_Premium__c != null ? application.Total_Insurance_Premium__c : 0; 
        application.Total_Loan_Amount__c = application.Total_Loan_Amount__c + totalDebt;
        Decimal premium = getPremium();     
        Decimal totalWithInsurance = premium + (application.Total_Loan_Amount_with_Insurance__c - oldInsurance);
        
        System.debug('premium in Add Debt-->'+premium);
        System.debug('totalWithInsurance in Add Debt-->'+totalWithInsurance+' ,' + totalDebt);
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItems(this.application);
        this.application.Offered_Repayment__c = offerCalculator..getRepaymentEMI(this.application);
        if(application.Offered_Repayment__c > application.Max_Monthly_Capacity__c){
            application.Total_Loan_Amount__c = application.Total_Loan_Amount__c - totalDebt;
            totalLoanAmount = 0;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'EMI should not exceed Maximum Monthly Capacity'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'EMI should not exceed Maximum Monthly Capacity'));
            //return null;
        }
        
        try{
            update debtList;
        }
        catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Liabilities__c', 'Class');    
        }
        
         List<Loan_Purpose__c> checkLoanPurpose = new List<Loan_Purpose__c>();
         checkLoanPurpose = [Select Id, Loan_Amount__c from Loan_Purpose__c where Value__c =: 'Debt consolidation' Limit 1];
         if(totalDebt != 0){
             
             totalLoanAmount = totalLoanAmount + totalDebt;
             System.debug('Total2-->'+totalLoanAmount);
             if(!checkLoanPurpose.IsEmpty()){
                 checkLoanPurpose[0].Loan_Amount__c = totalDebt;
                 
                try{
                    update checkLoanPurpose;
                }
                catch(DMLException e){
                        ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class');    
                }
             } 
             else{
                 List<ONR__c> onrList = GEN_RecordRetrievalUtility.retrieveApplicationONR(application.Id);
                 Loan_Purpose__c loan = new Loan_Purpose__c();
                 loan.Application__c = application.Id;
                 loan.Value__c = 'Debt consolidation';
                 loan.Loan_Amount__c = totalDebt;
                 loan.ONR__c = onrList[0].Id;
                 
                try{
                    insert loan;
                }
                catch(DMLException e){
                        ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class');    
                }                 
             }       
         }
         else{
            if(!checkLoanPurpose.isEmpty()){
                //totalLoanAmount = totalLoanAmount - checkLoanPurpose[0].Loan_Amount__c;
                System.debug('Total3-->'+totalLoanAmount);
                try{
                    delete checkLoanPurpose;
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Loan_Purpose__c', 'Class');    
                }
            }
         }
         updateComputation(totalLoanAmount);
         //save();
         Boolean isConsolidated = false;
         for(Liability__c l:debtList){
             if(l.Consolidated__c){
                isConsolidated = true; 
             }
         }
          
         List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
         offerPresentedList = getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_PROMPTED_DEBT_CONSOLIDATION);         
         if(offerPresentedList.size()>0){
             for(Offer_Presented__c offer: offerPresentedList){
                 offer.Accepted__c = isConsolidated;
                 if(isConsolidated){
                     offer.Time_Accepted__c = System.now();
                 }
                 else{
                     offer.Time_Accepted__c = null;
                 }
             }
             try{
                    update offerPresentedList;
             }
             catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Offer_Presented__', 'Class');    
             } 
         } 
                                
         PageReference pageRef = Page.OFF_OfferPresentation;
         pageRef.getParameters().put('id', String.valueOf(this.application.Id));
         pageRef.setRedirect(true);
         return pageRef;        
     }
     */
     
     // Commented out will be part of Phase 2
     /*  Description: Method for securing Assets
     *  Author: Fel
     *  Date Created: NOV-04-2013
     *  Input Parameters: None
     *  Return: Page Reference
     */
     /*public pageReference secureAsset(){
     
        //update the asset records
        try{
            update assetList;
        }
        catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Asset__c', 'Class');    
        }
        assetList = getAssetList();
        
        Boolean isSecured = false;
        for(Asset__c a:assetList){
            if(a.Is_Secured__c){
               isSecured = true;            
            }
        }
        
         List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
         offerPresentedList = getOfferPresented(offPresentedList,'Restructure', GEN_OriginationsConstants.OFFER_TYPE_SECURED_UPSELL);         
         if(offerPresentedList.size()>0){
             for(Offer_Presented__c offer: offerPresentedList){
                 offer.Accepted__c = isSecured;
                 if(isSecured){
                     offer.Time_Accepted__c = System.now();
                 }
                 else{
                     offer.Time_Accepted__c = null;
                 }
             }
             try{
                    update offerPresentedList;
             }
             catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Offer_Presented__', 'Class');    
             } 
         } 
     
         PageReference pageRef = Page.OFF_OfferPresentation;
         pageRef.getParameters().put('id', String.valueOf(this.application.Id));
         pageRef.setRedirect(true);
         return pageRef;
         
     }*/
     
     /*  Description: Method for Insurance Offer
     *  Author: Fel
     *  Date Created: NOV-06-2013
     *  Input Parameters: None
     *  Return: Page Reference
     */
     public pageReference insuranceOffer(){
        
        Application__c recentApp = retrieveApplication(this.application.Id); 
        if(onloadLMD != recentApp.LastModifiedDate){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Application has been updated in the back end. Please refresh page'));
            return null;
        }
        
        //BEGIN MLASALA: 29-NOV-15 - TOTAL INSURANCE PREMIUM RULE FIX
        //Moved validation rule to code due to misalignment of total loan amount in Application and Loan Purpose
        Double totalLoanAmountwithInsuranceFees = application.Total_Loan_Amount__c;
        totalLoanAmountwithInsuranceFees += getPremium();
        totalLoanAmountwithInsuranceFees += application.Offered_Establishment_Fee__c;
        totalLoanAmountwithInsuranceFees += application.Offered_PPSR_Search_Fee__c;
        totalLoanAmountwithInsuranceFees += application.Offered_PPSR_Registration_Fee__c;
        totalLoanAmountwithInsuranceFees += application.Offered_Establishment_Fee__c;
        totalLoanAmountwithInsuranceFees += application.Brokerage_Fee__c;
        
        if(getPremium() > (totalLoanAmountwithInsuranceFees * 0.25)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Total Insurance Premium should not exceed 25% of the Total Loan Amount'));
            return null;
        }
        //END MLASALA: 29-NOV-15 - TOTAL INSURANCE PREMIUM RULE FIX
        
        List<Product_Item__c> uProdItem = new List<Product_Item__c>();
        List<Product_Item__c> delProdItem = new List<Product_Item__c>();

        //BEGIN MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        Map<Id, Product_Item__c> productItemMap = new Map<Id, Product_Item__c>();
        //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

        System.debug('wrapperInsure-->'+wrapperInsure);
        Savepoint sp = Database.setSavepoint();
        
        Boolean isLifeSingle       = false;
        Boolean isDisabilitySingle = false;
        Boolean isIUISingle        = false;
        Boolean isLifeJoint        = false;
        Boolean isDisabilityJoint  = false;
        Boolean isIUIJoint         = false;
        
        //check if the combination is valid or not
        for(InsuranceWrapper iw:wrapperInsure){
            if(iw.insuranceType == 'Disability Insurance' && hasIUI && iw.applicant1 == false && application.Brand_Country__c != 'NZ'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Insurance combination, changes not saved. Please unselect IUI first'));
                this.application = retrieveApplication(this.application.Id);
                resetVariables();
                return null;
            }
        }
        
        //Added by Fel Saliba 11/12/2014 (DBHZL-84)
        //if NZ automatic check IUI if disability is selected
        if(application.Brand_Country__c == 'NZ'){
            Boolean applicant1hasDisability = false;
            Boolean applicant2hasDisability = false;
            
            //check for disability selection
            for(InsuranceWrapper iw:wrapperInsure){
                if(iw.applicant1){ 
                    if(iw.insuranceType == 'Disability Insurance'){
                        if(iw.applicant2){
                            applicant2hasDisability = true;
                        }
                        applicant1hasDisability = true;
                    }
                }                
            }
            
            //automatic true iui if disability is selected
            for(InsuranceWrapper iw:wrapperInsure){
                if(iw.insuranceType == 'Involuntary Unemployment Insurance'){
                    iw.applicant1 = applicant1hasDisability;
                    iw.applicant2 = applicant2hasDisability; 
                }                 
            }
        }

        System.debug('wrapperInsure1-->'+wrapperInsure);
        for(InsuranceWrapper iw:wrapperInsure){
            //check prodItems to insert
            
            if(iw.applicant1){ 
                if(iw.applicant2){
                    if(iw.insuranceType == 'Life Insurance'){
                        isLifeJoint = true;
                    }
                    else if(iw.insuranceType == 'Disability Insurance'){
                        isDisabilityJoint = true;
                    }
                    else{
                        isIUIJoint = true;
                    }                    
                }
                else{
                    if(iw.insuranceType == 'Life Insurance'){
                        isLifeSingle = true;
                    }
                    else if(iw.insuranceType == 'Disability Insurance'){
                        isDisabilitySingle = true;
                    }
                    else{
                        isIUISingle = true;
                    }                   
                }
            }
        }
        System.debug('wrapperInsure2-->'+wrapperInsure);
        System.debug('OfferPresetationVAlues-->'+isLifeSingle+ ' ' +isDisabilitySingle+ ' '+isIUISingle+ ' ' +isLifeJoint+ ' ' +isDisabilityJoint+ ' ' +isIUIJoint);
        
        //Added by Fel Saliba 12/16/2014 - for NZ products Calculation
        RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
        if(application.Brand_Country__c == 'NZ'){
            rulNZ.calculateInsurnaceNZ(application,
                                       isLifeSingle,
                                       isDisabilitySingle,
                                       isIUISingle,
                                       isLifeJoint,
                                       isDisabilityJoint,
                                       isIUIJoint);
      
            for(InsuranceWrapper iw:wrapperInsure){
                if(iw.applicant1){
                  iw.prodItem.Ins_Term__c = application.Loan_Term_Months__c;              
                  iw.prodItem.Policy_Num__c = 0;
                  iw.prodItem.Unique_Identifier__c = this.application.Id + '' + iw.productVersion.Id;
                  if(iw.applicant2){
                    iw.prodItem.Applicant2__c = applicant2.Id;
                    iw.prodItem.Policy_Type__c = 1;
                  }
                  else{
                    iw.prodItem.Applicant2__c = null;
                    iw.prodItem.Policy_Type__c = 0;
                  }
                  if(iw.insuranceType == 'Life Insurance'){
                    iw.prodItem.Fixed_Premium_Amount__c = rulNZ.lifeTotal;
                    iw.prodItem.Insurance_GST__c = 0;
                    iw.prodItem.Insurance_Stamp_Duty__c = 0;
                    iw.prodItem.Insurance_Stamp_Duty_Amount__c = 0;
                  }
                  else if(iw.insuranceType == 'Disability Insurance'){
                    iw.prodItem.Fixed_Premium_Amount__c = rulNZ.disabilityTotalWithGST;
                    iw.prodItem.Insurance_GST__c = rulNZ.disabilityGSTPremiumRounded;
                    iw.prodItem.Insurance_Stamp_Duty__c = 0;
                    iw.prodItem.Insurance_Stamp_Duty_Amount__c = 0;
                  }
                  else{
                    iw.prodItem.Fixed_Premium_Amount__c = rulNZ.iuiTotalWithGST;
                    iw.prodItem.Insurance_GST__c = rulNZ.iuiGSTPremiumRounded;
                    iw.prodItem.Insurance_Stamp_Duty__c = 0;
                    iw.prodItem.Insurance_Stamp_Duty_Amount__c = 0;         
                  }         
                  uProdItem.add(iw.prodItem);         
                }

                //check ProdItems to delete
                if(!iw.applicant1 && iw.prodItem.Id != null){
                    delProdItem.add(iw.prodItem);

                    //BEGIN MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                    productItemMap.put(iw.prodItem.Id, iw.prodItem);
                    //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                }
            }
        }

        else if(application.Brand_Country__c == 'AU'){
      
            for(InsuranceWrapper iw:wrapperInsure){
            //check prodItems to insert
        
                if(iw.applicant1){  
                  RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
                  iw.prodItem.Ins_Term__c = application.Loan_Term_Months__c;              
                  iw.prodItem.Policy_Num__c = 0;
                  iw.prodItem.Unique_Identifier__c = this.application.Id + '' + iw.productVersion.Id;
                  if(iw.applicant2){
                    iw.prodItem.Applicant2__c = applicant2.Id;
                    iw.prodItem.Policy_Type__c = 1;
                    if(iw.insuranceType == 'Life Insurance'){
                      Decimal idividualLifeJoint = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.jointLifeInsurancePremium;
                      iw.prodItem.Insurance_GST__c = 0;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.lifeStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointLifeSdRounded;
                    }
                    else if(iw.insuranceType == 'Disability Insurance'){
                      Decimal idividualDisabilityJoint = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.jointDisabInsurancePremium;
                      iw.prodItem.Insurance_GST__c = rul.jointDisabGstAmount;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.disabilityStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointDisabStampDuty;
                    }
                    else{
                      Decimal idividualIUIJoint = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.jointIuiInsurancePremium;
                      iw.prodItem.Insurance_GST__c = rul.jointIuiGstAmount;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.iuiStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointIuiSdRounded;
                    }                 
                  }
                  else{
                    if(iw.insuranceType == 'Life Insurance'){
                      Decimal idividualLifeSingle = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.singleLifeInsurancePremium;
                      iw.prodItem.Insurance_GST__c = 0;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.lifeStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleLifeSdRounded;
                    }
                    else if(iw.insuranceType == 'Disability Insurance'){
                      Decimal idividualDisabilitySingle = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.singleDisabInsurancePremium;
                      iw.prodItem.Insurance_GST__c = rul.singleDisabGstAmount;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.disabilityStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleDisabSdRounded;
                    }
                    else{
                      Decimal idividualIUISingle = rul.getIndividualPremium(application,isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                      iw.prodItem.Fixed_Premium_Amount__c = rul.singleIuiInsurancePremium;
                      iw.prodItem.Insurance_GST__c = rul.singleIuiGstAmount;
                      iw.prodItem.Insurance_Stamp_Duty__c = rul.iuiStampDuty;
                      iw.prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleIuiSdRounded;
                    }
                    iw.prodItem.Applicant2__c = null;
                    iw.prodItem.Policy_Type__c = 0;
                  }
                  uProdItem.add(iw.prodItem);
                }                     
                //check ProdItems to delete
                if(!iw.applicant1 && iw.prodItem.Id != null){
                    delProdItem.add(iw.prodItem);
                    
                    //BEGIN MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                    productItemMap.put(iw.prodItem.Id, iw.prodItem);
                    //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
                }
            }
        }

        //BEGIN MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING
        List<Debug_Log__c> debugLogList = new List<Debug_Log__c>();
        Decimal totalInsurancePremiumAdd = (application.Total_Insurance_Premium__c != 0 && application.Total_Insurance_Premium__c != null) ? application.Total_Insurance_Premium__c : 0;
        Decimal totalInsurancePremiumRemove = (application.Total_Insurance_Premium__c != 0 && application.Total_Insurance_Premium__c != null) ? application.Total_Insurance_Premium__c : 0;
        
        for(InsuranceWrapper iw:wrapperInsure){

            Decimal insurancePremium = 0;
            Decimal fixedPremiumAmount = (iw.prodItem.Fixed_Premium_Amount__c != null && iw.prodItem.Fixed_Premium_Amount__c != 0) ? iw.prodItem.Fixed_Premium_Amount__c : 0;

            //Identify added insurance/s
            if((iw.applicant1 || iw.applicant2) && !Util.nullCheck(iw.prodItem.Id)){
                
                insurancePremium = totalInsurancePremiumAdd + fixedPremiumAmount;
                System.debug('$$$ Add: '+totalInsurancePremiumAdd+' + '+fixedPremiumAmount+' = '+insurancePremium);
                
                //Create debug log record
                debugLogList.add(Util.createInsuranceActivity(application.Id, 
                                                              'Add', 
                                                              iw.insuranceType.removeEnd('Insurance'), 
                                                              UserInfo.getName(), 
                                                              totalInsurancePremiumAdd, 
                                                              insurancePremium));

                totalInsurancePremiumAdd += fixedPremiumAmount;
                
            } else if((!iw.applicant1 || !iw.applicant2)){
            //Identify removed insurance/s
                
                if(productItemMap.containsKey(iw.prodItem.Id)){
                    
                    insurancePremium = totalInsurancePremiumRemove - fixedPremiumAmount;
                    System.debug('$$$ Remove: '+totalInsurancePremiumRemove+' - '+fixedPremiumAmount+' = '+insurancePremium);

                    //Create debug log record
                    debugLogList.add(Util.createInsuranceActivity(application.Id, 
                                                                  'Remove', 
                                                                  iw.insuranceType.removeEnd('Insurance'), 
                                                                  UserInfo.getName(), 
                                                                  totalInsurancePremiumRemove, 
                                                                  insurancePremium));

                    totalInsurancePremiumRemove -= fixedPremiumAmount;
                }
            }
        }
        
        if(!debugLogList.isEmpty()){
            //Insert record
            try{
                insert debugLogList;
            } catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'Util', 'Debug_Log__c', 'Class', application.Id);
            }
        }
        //END MLASALA: 08/10/15 PMIHM-1484 - MESSAGING WHEN INSURANCE FLUSHES & ACTIVITY TRACKING

        if(uProdItem != null && uProdItem.size()>0){
            try{
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                //if(Product_Item__c.SObjectType.getDescribe().isCreateable()) {
                    upsert uProdItem;
                //}
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Product_Item__c', 'Class', application.Id);    
            }
        }
        
        /*Set<String> insuranceSet = new Set<String>();
        System.debug('uProdItem-->'+uProdItem);
        if(!uProdItem.isEmpty()){
            List<Product_Item__c> noDuplicatesPI = new List<Product_Item__c>();
            for(Product_Item__c pi:uProdItem){
                if(!insuranceSet.contains(pi.Product_Name__c)){
                   noDuplicatesPI.add(pi);
                   insuranceSet.add(pi.Product_Name__c);
                }
                else{ 
                    if(pi.Id != null){
                        delProdItem.add(pi);
                    }
                }            
            }
            if(noDuplicatesPI != null && noDuplicatesPI.size()>0){ 
                try{
                    upsert noDuplicatesPI;
                    System.debug('noDuplicatesPI-->'+noDuplicatesPI);
                }
                catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Product_Item__c', 'Class', application.Id);    
                }
            }          
        }*/
        
        if(!delProdItem.isEmpty()){
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Product_Item__c.sObjectType.getDescribe().isDeletable()){
                  delete delProdItem;
                  System.debug('delProdItem-->'+delProdItem);
                }
                */
                delete delProdItem;
                System.debug('delProdItem-->'+delProdItem);
            }
            catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Product_Item__c', 'Class', application.Id);    
            }
        }
        
        Set<String> prodIds = new Set<String>();
        for(Product_Item__c prodList: [Select Product_Version__r.GEProduct__c from Product_Item__c Where Id IN:uProdItem]){
            prodIds.add(prodList.Product_Version__r.GEProduct__c);
        }
        
        if(insuranceList.size()>0){
         for(Offer_Presented__c offer: insuranceList){
             if(prodIds.contains(offer.offer__r.Product__c)){
                 offer.Accepted__c = true;
                 offer.Time_Accepted__c = System.now();
             }
             else {
                 offer.Accepted__c = false;
                 offer.Time_Accepted__c = null;
             }
         }
       }

        return computePremium(sp); 
     }
     
     /*  Description: Method for Credit Card Offer
     *  Author: Fel
     *  Date Created: NOV-06-2013
     *  Input Parameters: None
     *  Return: Page Reference
     */
     
    //Commented out Credit card offer will not be part of phase 1.
     
    /*
     public pageReference creditOffer(){
         
         String pId = '';
         Set<String> offerIds = new Set<String>();
         Product_Item__c prodItemDel = new Product_Item__c();
         for(CreditWrapper cw:wrapperCredit){
             if(cw.isSelected && cw.accepted == false){
                 Product_Item__c pd = new Product_Item__c();
                 pd.Application__c = application.Id;
                 pd.Product_Version__c = cw.productVersion.Id;
                 insert pd;
                 
                 pId = cw.productVersion.GEProduct__c;
             }
             else if(cw.isSelected == false && cw.accepted){
                 offerIds.add(cw.productVersion.GEProduct__c);
             }
             if(cw.isSelected == false && prodItemsMap.keySet().contains(cw.productVersion.GEProduct__c)){
                 prodItemDel = prodItemsMap.get(cw.productVersion.GEProduct__c);
             }
         }
         
         if(prodItemDel.Id != null){
             try{
                    delete prodItemDel;
             }
             catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Product_Item__c', 'Class');    
             }
         }
         
         if(creditList.size()>0){
             for(Offer_Presented__c offer: creditList){
                 if(pId != ''){
                     if(offer.offer__r.Product__c == pId){
                         offer.Accepted__c = true;
                         offer.Time_Accepted__c = System.now();
                     }
                 }
                 else if(offerIds.contains(offer.offer__r.Product__c)){
                     offer.Accepted__c = false;
                     offer.Time_Accepted__c = null;
                 }
             }
             try{
                    update creditList;
             }
             catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'OFF_OfferPresentationExt', 'Offer_Presented__c', 'Class');    
             }
         }
         
         PageReference pageRef = Page.OFF_OfferPresentation;
         pageRef.getParameters().put('id', String.valueOf(this.application.Id));
         pageRef.setRedirect(true);
         return pageRef;
     }
    */
    
    /*  Description: Method to refresh the page
     *  Author: Fel
     *  Date Created: July-09-2014
     *  Return: pageRef
     */
    public PageReference refreshPage(){
        PageReference pageRef = Page.OFF_OfferPresentation;
        pageRef.getParameters().put('id', String.valueOf(this.application.Id));
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*  Description: Method to query related Offer Presented records
     *  Author: Fel
     *  Date Created: NOV-04-2013
     *  Input Parameters: Set of Offer presented Ids
     *  Return: List of Offer Presented records, Offer Record Type, Offer Type
     */
     public List<Offer_Presented__c> getOfferPresented(List<Offer_Presented__c> offerPresented, String recordType, String type) {
     
         List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
         offerPresentedList = [Select  Id, Accepted__c
                               from    Offer_Presented__c
                               where   Offer__r.type__c =: type
                               AND Offer__r.RecordType.Name =:recordType
                               AND Id IN: offerPresented];
         System.debug('offerPresentedList-->'+offerPresentedList);                      
         return offerPresentedList;
     }
     
    /*  Description: Method to query related Offer Presented records with Product Type = Insurance Or Credit Card
     *  Author: Fel
     *  Date Created: NOV-04-2013
     *  Input Parameters: Set of Offer presented Ids
     *  Return: List of Offer Presented records, Offer Record Type, Offer Product Type
     */
     public List<Offer_Presented__c> getCreditCardInsurance(List<Offer_Presented__c> offerPresented, String recordType, String ptype) {
     
         List<Offer_Presented__c> offerPresentedList = new List<Offer_Presented__c>();
         offerPresentedList = [Select  Id, Accepted__c, Offer__r.Product__c
                               from    Offer_Presented__c
                               where   Offer__r.Product__r.Type__c =: ptype
                               AND Offer__r.RecordType.Name =:recordType
                               AND Id IN: offerPresented];
         System.debug('offerPresentedListQuery-->'+offerPresentedList);                      
         return offerPresentedList;
     }
    
    /*  Description: Validate age of applicant
     *  Author: Mike Lasala
     *  Date Created: FEB-18-2014
     *  Input Parameters: None
     *  Return: Boolean
     */
     public Boolean validateAge(){
        Boolean ageValid = true;
        
        if(application.Brand_Country__c == 'AU'){
            if(applicant.Date_of_Birth_WS__c != null){
                
                Date dbirth = Date.valueOf(dateOfBirthStr);
                Integer temp = dbirth.daysBetween(Date.Today());
                //Integer temp = Date.valueOf(applicant.Date_of_Birth_WS__c).daysBetween(Date.Today());
                Integer age = Integer.valueOf(temp/365);
                Decimal loanMaturity = age + Decimal.valueOf(loanTermSelected.split(' ', 2)[0])/
                              (loanTermSelected.ToLowerCase().contains('months')? 12 : 1 );
                if(loanMaturity > 70){
                    ageValid = false;
                }
            }
            
            if(isJoint){
                if(applicant2.Date_of_Birth_WS__c != null){
                   Date dbirth = Date.valueOf(dateOfBirthStr2);
                   Integer temp2 = dbirth.daysBetween(Date.Today());
                   //Integer temp2 = Date.valueOf(applicant2.Date_of_Birth_WS__c).daysBetween(Date.Today());
                   Integer age2 = Integer.valueOf(temp2/365);
                   Decimal loanMaturity2 = age2 + Decimal.valueOf(loanTermSelected.split(' ', 2)[0])/
                              (loanTermSelected.ToLowerCase().contains('months')? 12 : 1 );
                   if(loanMaturity2 > 70){
                       ageValid = false;
                   }
                }
            }
        }
        
        return ageValid;
     }

     public void rerenderInsurance(){
         ageValidation = renderInsurance;
     }

    //===============================================================
    //                    INNER CLASSES / WRAPPERS
    //===============================================================
    
     /*  Description: Wrapper class for the Loan Purpose object
     *  Author: Fel Saliba
     *  Date Created: OCT-24-2013
     */
    public class OfferPresentationWrapper {
        
        public Loan_Purpose__c loan {get;set;}
        public Integer counter {get;set;} 
        
         /* Description: Wrapper constructor, creates new loan purpose.
         *  Author: Fel Saliba
         *  Date Created: OCT-24-2013
         *  Input Parameters: None
         *  Return: N/A
         */
        public OfferPresentationWrapper (){  
        
            this.loan =  new Loan_Purpose__c();     
        }
    }
    
    /*  Description: Wrapper class for Insurance product version
     *  Author: Fel Saliba
     *  Date Created: NOV-06-2013
     */
    public class InsuranceWrapper {
        
        public Product_Version__c productVersion {get;set;}
        //public Boolean accepted {get;set;} 
        public Boolean offerExist {get;set;} 
        public String insuranceType {get;set;}
        public Boolean applicant1 {get;set;}
        public Boolean applicant2 {get;set;}
        public Product_Item__c prodItem {get;set;}
        
         /* Description: Wrapper constructor, creates new  product version.
         *  Author: Fel Saliba
         *  Date Created: NOV-06-2013
         *  Input Parameters: None
         *  Return: N/A
         */
        public InsuranceWrapper (){  
        
            this.productVersion =  new Product_Version__c();
            this.prodItem = new Product_Item__c();
            this.applicant1 = false;
            this.applicant2 = false;  
        }
    }
    
    /*  Description: Wrapper class for Insurance product version
     *  Author: Fel Saliba
     *  Date Created: NOV-06-2013
     */
    public class CreditWrapper {
        
        public Product_Version__c productVersion {get;set;}
        public Boolean isSelected {get;set;}
        public Boolean offerExist {get;set;}  
        public Boolean accepted {get;set;}
        
         /* Description: Wrapper constructor, creates new  product version.
         *  Author: Fel Saliba
         *  Date Created: NOV-06-2013
         *  Input Parameters: None
         *  Return: N/A
         */
        public CreditWrapper (){          
            this.productVersion =  new Product_Version__c();   
        }
    }
    //Commented out will be part of Phase 2
    /*  Description: Wrapper class for Debt
     *  Author: Fel Saliba
     *  Date Created: NOV-06-2013
     */
   /* public class DebtWrapper {
        
        public String debtCategory {get;set;}
        public Decimal frequency {get;set;}
        public Decimal total{get;set;}
        public Boolean isConsolidated{get;set;}*/
        
         /* Description: Wrapper constructor, creates new debt record.
         *  Author: Fel Saliba
         *  Date Created: NOV-08-2013
         *  Input Parameters: None
         *  Return: N/A
         */
        //public DebtWrapper (){  
        
            //this.debt =  new Liability__c();
            //this.selected = false;    
        //}
    //}
    
    /*  Description: Wrapper class for Header Components
     *  Author: Fel Saliba
     *  Date Created: NOV-06-2013
     */
    public class HeaderWrapper {
        
        public Decimal headerWidth {get;set;}
        public String name {get;set;}
        public String headerColor {get;set;}
        
         /* Description: Wrapper constructor, creates new Header Component.
         *  Author: Fel Saliba
         *  Date Created: NOV-08-2013
         *  Input Parameters: None
         *  Return: N/A
         */
        public HeaderWrapper (){  
   
        }
    }

    /*  Description: Wrapper class for Disbursement
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     */
    public class DisbursementWrapper {
        public Disbursement__c disbursement {get;set;}
        public Integer counter {get;set;} 
        public Decimal netPayOffDue{get;set;}
        
        public DisbursementWrapper() {  
            this.disbursement =  new Disbursement__c();     
        }
    }

    /*  Description: Method to validate all disbursement fields
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: N/A
     *  Return: Boolean (Passed or failed validation)
     */
    public Boolean doFieldsValidation() {
        Boolean bOk = true;

        if (currentDisbursementWrapper.disbursement.Payee__c == null || currentDisbursementWrapper.disbursement.Payee__c == '') {
            currentDisbursementWrapper.disbursement.Payee__c.addError('Invalid value.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Applicable_Party__c == null || currentDisbursementWrapper.disbursement.Applicable_Party__c == '' || currentDisbursementWrapper.disbursement.Applicable_Party__c == '--None--') {
            currentDisbursementWrapper.disbursement.Applicable_Party__c.addError('Invalid value.');        
            bOk = false;
        }
        
        if ((currentDisbursementWrapper.disbursement.Applicable_Party__c == GEN_OriginationsConstants.BOTH || currentDisbursementWrapper.disbursement.Applicable_Party__c == GEN_OriginationsConstants.APPLICANT_2) &&
             this.application.Application_Type__c == GEN_OriginationsConstants.APPLICATION_TYPE_SINGLE) {
            currentDisbursementWrapper.disbursement.Applicable_Party__c.addError('You must select Applicant 1 as Applicable Party for single application.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == null || currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == '' || currentDisbursementWrapper.disbursement.Disbursement_Account_type__c == '--None--') {
            currentDisbursementWrapper.disbursement.Disbursement_Account_type__c.addError('Invalid value.');        
            bOk = false;
        }

        if (currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == null || currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == '' || currentDisbursementWrapper.disbursement.Disbursement_Outcome__c == '--None--') {
            currentDisbursementWrapper.disbursement.Disbursement_Outcome__c.addError('Invalid value.');     
            bOk = false;
        }

        //if (currentDisbursementWrapper.disbursement.Bank_Acc_No__c == null || currentDisbursementWrapper.disbursement.Bank_Acc_No__c == '') {
        //    currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError('Invalid value.');      
        //    bOk = false;
        //}           

        if (currentDisbursementWrapper.disbursement.Interest_Rate__c == null) {
            currentDisbursementWrapper.disbursement.Interest_Rate__c.addError('Invalid value.');        
            bOk = false;
        }  

        //17-01-2022 Changes by William: Add 0 interest rate validation for refinance
        if (currentDisbursementWrapper.disbursement.Interest_Rate__c == 0 && currentDisbursementWrapper.disbursement.RecordTypeId == recTypeIdRefinance) {
            currentDisbursementWrapper.disbursement.Interest_Rate__c.addError('Interest Rate cannot be 0%');        
            bOk = false;
        }          

        if (currentDisbursementWrapper.disbursement.Payout_Effective_Date__c == null) {
            currentDisbursementWrapper.disbursement.Payout_Effective_Date__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Principal_Amount__c == null) {
            currentDisbursementWrapper.disbursement.Principal_Amount__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Interest_Due__c == null) {
            currentDisbursementWrapper.disbursement.Interest_Due__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Late_Fees_Due__c == null) {
            currentDisbursementWrapper.disbursement.Late_Fees_Due__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c == null) {
            currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c == null) {
            currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c.addError('Invalid value.');      
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Charge_Off_Amount__c == null) {
            currentDisbursementWrapper.disbursement.Charge_Off_Amount__c.addError('Invalid value.');        
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Insurance_Rebate__c == null) {
            currentDisbursementWrapper.disbursement.Insurance_Rebate__c.addError('Invalid value.');     
            bOk = false;
        }           

        if (currentDisbursementWrapper.disbursement.Early_Termination_Fee__c == null) {
            currentDisbursementWrapper.disbursement.Early_Termination_Fee__c.addError('Invalid value.');        
            bOk = false;
        }           

        return bOk;
    }

    /*  Description: Method to save disbursement record in memory 
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public PageReference saveDisbursement() {
        Boolean bNew = true;
        //DBHZL386
        /**
        if(currentDisbursementWrapper.disbursement.Retrieved_Payout_Amount__c > 0){
            //Check both interest rate and payOffAmountRetrieved is provided
            Boolean bOK = true;         
            if (currentDisbursementWrapper.disbursement.Interest_Rate__c == null) {
                currentDisbursementWrapper.disbursement.Interest_Rate__c.addError('Please provide Interest Rate');        
                bOk = false;
            }  
            
            if(bok){
     
                for (OfferPresentationWrapper offer : offerList) {
                    if (offer.counter == nRefinanceRow) {
                        if (offer.loan.Id != null) {
                            currentDisbursementWrapper.disbursement.Loan_Purpose__c = offer.loan.Id;  
                        }
                        currentDisbursementWrapper.counter = offer.counter;
                        Decimal netPayOffDue = 0;
                        netPayOffDue += currentDisbursementWrapper.disbursement.Retrieved_Payout_Amount__c;
                        
                        currentDisbursementWrapper.netPayOffDue = netPayOffDue;
                        disbursementRowCount = offer.counter;
                        disbursementNetPayOff = netPayOffDue;

                    }  
                }
        
                for (DisbursementWrapper dw : disbursementWrapperList) {
                    if (dw.counter == nRefinanceRow) {
                        bNew = false;
                        dw = currentDisbursementWrapper;
                        break;  
                    }
                }   
        
                if (bNew) {
                    disbursementWrapperList.add(currentDisbursementWrapper);    
                }
        
                if (sRefinanceIds == '' || sRefinanceIds == null) {
                    sRefinanceIds = String.valueof(nRefinanceRow);
                } else {
                    sRefinanceIds = sRefinanceIds + ',' + String.valueof(nRefinanceRow);
                }  
        
                bDisplayDisbursementPopup = false; 
                initializeDisbursement();
            }
        }else{
        **/
            GEN_RefinanceUtility refinanceUtil = new GEN_RefinanceUtility();
            String bAccountNumberOK = refinanceUtil.validateAppAccountNumber(currentDisbursementWrapper.disbursement.Bank_Acc_No__c, this.application.Id);
            Boolean bOK = doFieldsValidation();
            if (bOk) {
                if (bAccountNumberOK == null) {
                    for (OfferPresentationWrapper offer : offerList) {
                        if (offer.counter == nRefinanceRow) {
                            if (offer.loan.Id != null) {
                                currentDisbursementWrapper.disbursement.Loan_Purpose__c = offer.loan.Id;  
                            }
                            currentDisbursementWrapper.counter = offer.counter;
                            Decimal netPayOffDue = 0;
                            netPayOffDue += currentDisbursementWrapper.disbursement.Principal_Amount__c;
                            netPayOffDue += currentDisbursementWrapper.disbursement.Interest_Due__c;
                            netPayOffDue += currentDisbursementWrapper.disbursement.Late_Fees_Due__c; 
                            netPayOffDue += currentDisbursementWrapper.disbursement.Penalty_Interest_Due__c; 
                            netPayOffDue += currentDisbursementWrapper.disbursement.Fees_or_Charges_Due__c;
                            netPayOffDue += currentDisbursementWrapper.disbursement.Charge_Off_Amount__c;
                            netPayOffDue -= currentDisbursementWrapper.disbursement.Insurance_Rebate__c;
                            netPayOffDue += currentDisbursementWrapper.disbursement.Early_Termination_Fee__c;
                            
                            currentDisbursementWrapper.netPayOffDue = netPayOffDue;
                            disbursementRowCount = offer.counter;
                            disbursementNetPayOff = netPayOffDue;
                        }  
                    }
    
                    for (DisbursementWrapper dw : disbursementWrapperList) {
                        if (dw.counter == nRefinanceRow) {
                            bNew = false;
                            dw = currentDisbursementWrapper;
                            break;  
                        }
                    }   
    
                    if (bNew) {
                        disbursementWrapperList.add(currentDisbursementWrapper);    
                    }
    
                    if (sRefinanceIds == '' || sRefinanceIds == null) {
                        sRefinanceIds = String.valueof(nRefinanceRow);
                    } else {
                        sRefinanceIds = sRefinanceIds + ',' + String.valueof(nRefinanceRow);
                    }  
    
                    bDisplayDisbursementPopup = false; 
                    initializeDisbursement();
                } else {
                    // ERROR!!!
                    currentDisbursementWrapper.disbursement.Bank_Acc_No__c.addError(bAccountNumberOK);
                }
            }
        //}
        return null;
    }      

    /*  Description: Method to retrieve selected disbursement record 
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: Disbursement record selected
     */
    public Disbursement__c retrieveDisbursement() {
        currentDisbursementWrapper.disbursement = null;
        for (DisbursementWrapper dw : disbursementWrapperList) {
            if (dw.counter == nRefinanceRow) {
               currentDisbursementWrapper.disbursement = dw.disbursement;
               break;
            }
        }
        return currentDisbursementWrapper.disbursement;
    }

    /*  Description: Method to display popup window for disbursement 
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public PageReference showDisbursement() {
        initializeDisbursement();
        bDisplayDisbursementPopup = true;     
        return null;
    }    

    /*  Description: Method to hide popup window for disbursement 
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: PageReference: Null
     */
    public PageReference cancelDisbursement() {
        bDisplayDisbursementPopup = false; 
        if (sRefinanceIds == '' || sRefinanceIds == null) {
            sRefinanceIds = String.valueof(nRefinanceRow);
        } else {
            sRefinanceIds = sRefinanceIds + ',' + String.valueof(nRefinanceRow);
        }   
        return null;
    }

    /*  Description: Method to initialize disbursement wrapper 
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: None
     */
    public void initializeDisbursement() {
        currentDisbursementWrapper = new DisbursementWrapper(); 
        currentDisbursementWrapper.disbursement.Application__c = this.application.Id;
        if (this.application.Application_Type__c == 'Single') {
            currentDisbursementWrapper.disbursement.Applicable_Party__c = 'Applicant 1';
        }
        currentDisbursementWrapper.disbursement.RecordTypeId = recTypeIdRefinance;
    
    /** 
        if(currentDisbursementWrapper.disbursement.Payout_Effective_Date__c == null){
            currentDisbursementWrapper.disbursement.Payout_Effective_Date__c = Date.Today();
        }**/

    }

    /*  Description: Method to display/edit selected disbursement record
     *  Author: Mat Isidro
     *  Date Created: March 17, 2014
     *  Input Parameter: None
     *  Return: None
     */
    public PageReference editDisbursement() {
        initializeDisbursement();
        for (DisbursementWrapper dw : disbursementWrapperList) {
            if (dw.counter == nRefinanceRow) {
                currentDisbursementWrapper = dw;
                break;
            }           
        }
        bDisplayDisbursementPopup = true;     
        return null;
    }
        
    
    
    /*  Description: Method to retrieve payoff figure from ICBS DBHZL386
     *  Author: Tony Xu
     *  Date Created: 2015-02-27
     *  Input Parameter: None
     *  Return: None
     */

     public void retrievePayoff(){
        system.debug('***********txu DEBUG*********'+currentDisbursementWrapper);
            //This is a new disbursement record
            //Then Check if Account Number is provided
            String bankAccountNumber;

            if(brand.Country__c == GEN_OriginationsConstants.AU_REGION){
                bankAccountNumber = currentDisbursementWrapper.disbursement.Bank_Acc_No__c;
            } else {
                bankAccountNumber = currentDisbursementWrapper.disbursement.Bank_Acc_No_NZ__c;
            }
            
            //if(currentDisbursementWrapper.disbursement.Bank_Acc_No__c != null && currentDisbursementWrapper.disbursement.Bank_Acc_No__c != ''){
            if(bankAccountNumber != null && bankAccountNumber != ''){
              system.debug('************TXU DEBUG: New Disbursement');
                  
                try{
                  system.debug('***********TXU DEBUG**********'+ApexPages.currentPage());
                    //IS_GeneratePayoffFigure.generatePayoffFigureRequest(application.Id, currentDisbursementWrapper.disbursement.Bank_Acc_No__c, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                    IS_GeneratePayoffFigure.generatePayoffFigureRequest(application.Id, bankAccountNumber, Util.getUser().Mock_Enable__c, Web_Service_Settings__c.getValues('Requested Name Sales').Value__c, null);
                } catch(Exception e){     
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An Error Occured'));  
                }
                    
            }
     }

    /*  Description: Method to calculate Interest on Insurance + Interest on Principal+Fees (NZ only)
     *  Author: Mike Lasala
     *  Date Created: MAY-20-2015
     *  Input Parameter: None
     *  Return: Decimal
     */
    public Decimal computeTotalInterest(){

        Decimal totalInsuranceInterentAmountPayable = 0;
        Decimal totalLoanInterentAmountPayable = 0;
        Decimal totalInterest = 0;
        System.debug('totalInsuranceInterentAmountPayable Constructor: '+totalInsuranceInterentAmountPayable);
        if(totalInsuranceInterentAmountPayable != null){
            totalInsuranceInterentAmountPayable = application.Total_Insurance_Interest_Amount_Payable__c;
        }
        System.debug('totalLoanInterentAmountPayable Constructor: '+totalLoanInterentAmountPayable);
        if(totalLoanInterentAmountPayable != null){
            totalLoanInterentAmountPayable = application.Total_Loan_Interest_Amount_Payable__c;
        }
        System.debug('totalLoanInterentAmountPayable Constructor: '+totalLoanInterentAmountPayable);
        if(totalLoanInterentAmountPayable != null && totalInsuranceInterentAmountPayable != null){
          totalInterest = totalInsuranceInterentAmountPayable + totalLoanInterentAmountPayable;
        }
        System.debug('totalInterest Constructor: '+totalInterest);
        return totalInterest;
    }
    
    public void lockDownOffer(){
        system.debug('!@#LOCKDOWN');
        update application;
    }
}