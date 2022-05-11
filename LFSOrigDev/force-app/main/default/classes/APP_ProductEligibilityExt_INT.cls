/*
 * @Description: Controller for Product Selection & Eligibility (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: OCT-23-2013
 * @History:
   =====================================================================
        23-10-13: Created - Mike
        29-11-13: Added logic for joint - Mike
        23-01-14: Refactor the query from brand to product version - August
        20-02-14: Added Identity Verification - Mike
        12-03-14: Added Channel disable
        25-11-14: DBHZL-54 Eligibility Copy & Acknowledgements - vijay
        05-05-15: DBHZL-1381 Added branch exemption filter based on branch and custom setting - Adrian Recio       
        20-AUG-15: PMIHM-1858 - MLASALA
        23-SEPT-15: INSURANCE ISSUE (DUPLICATE PERSONAL LOAN PRODUCT ITEM) -MLASALA
        Mar-02-2016 : Afreen - Updated the valid broker error condition to accomodate additional Product called PL
        09-Sept-16: Vasu - Updated for Story TQLQW-487 - Promo engine change
   =====================================================================
 */
public without sharing class APP_ProductEligibilityExt_INT extends APP_CommonExt{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public Boolean confirmEligibleForLoan           {get;set;}
    public Boolean confirmApplicationMeetsNeeds     {get;set;}
    public Boolean confirmAgreedToPolicy            {get;set;}
    public Boolean confirmAllowInsuranceOffers      {get;set;}
    public Boolean confirmReadCreditGuide           {get;set;}
    public Boolean confirmInterestedInOtherOffer    {get;set;}
    public Boolean confirmIdentifyVerification      {get;set;}
    
    //Added by Suneel POI Automation 25/01/2021 
    public Boolean ConfirmVerifierVerification      {get;set;}
    public Boolean confirmAgreedToIncomeVerification {get;set;}
    

    //Added by ARSHAD: 10/05/2018 -  BDR-105
    public Boolean confirmConsentLpi                {get;set;}

    //Added by Fel Saliba 16/05/2014
    public Boolean confirmHigherApprovalConsent     {get;set;}
    //Vasu: added for TQLQW-487 - Promo engine change
    public String PromoId                           {get;set;}
    
    //Applicant 2
    public Boolean confirm2EligibleForLoan          {get;set;}
    public Boolean confirm2ApplicationMeetsNeeds    {get;set;}
    public Boolean confirm2AgreedToPolicy           {get;set;}
    public Boolean confirm2AllowInsuranceOffers     {get;set;}
    public Boolean confirm2ReadCreditGuide          {get;set;}
    public Boolean confirm2InterestedInOtherOffer   {get;set;}
    public Boolean confirm2IdentifyVerification     {get;set;}
    
    //Added by Suneel POI Automation 25/01/2021 
    public Boolean Confirm2VerifierVerification      {get;set;}
    public Boolean confirm2AgreedToIncomeVerification {get;set;}

    //Added by ARSHAD: 10/05/2018 -  BDR-105
    public Boolean confirm2ConsentLpi               {get;set;}

    //public String applicationId                   {get;set;}
    public String Channel                           {get;set;}
    public String businessSource                    {get;set;}
    public String mirror                            {get;set;}
    
    //Added by Arshad: 13/05/2019 - Better Start
    public String pSubType                          {get;set;}
    
    public String applicationType                   {get;set;}
    public String fromList                          {get;set;}
    public String Mode                              {get;set;}
    public String pItemId                           {get;set;}
    public String picklistMessage                   {get;set;}

    //@jade 12-Dec-2013
    public Boolean disableProductSelection          {get;set;}
    public Boolean disableSaveAndNextButton         {get;set;}
    public Boolean disableChannel                   {get;set;}
    public String selectedBrand                     {get;set;}
    
    //315
    public String kiwiBankAccess1                   {get;set;}
    public String kiwiBankAccess2                   {get;set;}
    
    //Better Start
        public Boolean isBSAUActive {get;set;}
        public Boolean isBSNZActive {get;set;}
      
    public Boolean flag;
    public String errorMessage;
    public String productType {get; set;}    
    List<Brand__c> brandList = new List<Brand__c>();
    List<Product_Version__c> pvList = new List<Product_Version__c>();
    List<Applicant__c> appList = new List<Applicant__c>();
    List<GEProduct__c> geProductList;
    Public List<SelectOption> lst_TypeOfProducts{
        get{
                if(lst_TypeOfProducts == null){
                    getTypeOfProd();
                }
                return lst_TypeOfProducts;            
            } 
        set;
    
    }
    
    String selProd;
    String selectedProd;
    String selectedProdVer;
    String currentApplicationBrand;
    String appId;
    String brokerRecordTypeid;
    //Added by vijay on 24/11/2014
    public string region{get;set;}
    
    //Added by Fsaliba 16/1/2015 -DBHZL-213
    public Boolean app2Optional {get;set;} 
    //===============================================================
    //                       CONSTRUCTOR
    //===============================================================
    public APP_ProductEligibilityExt_INT(ApexPages.StandardController applicationController){
    
        super(applicationController);
          //Better Start
        isBSAUActive = false;
        isBSNZActive = false;
         Better_Start_Offer__c bso = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
         isBSAUActive = bso.BetterStartAUActive__c;
         isBSNZActive = bso.BetterStartNZActive__c;
        //End  
  
        try{
            
            geProductList = new List<GEProduct__c>();
            Mode = ApexPages.currentPage().getParameters().get('mode');
            fromList = ApexPages.currentPage().getParameters().get('list');
            //Added by Suneel
            //brokerRecordTypeid = Schema.SObjectType.Disbursement__c.RecordTypeInfosByName.get('Broker Fee EFT').RecordTypeId;
            List<Disbursement__c> disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(this.application.Id);
              if(disbursementList.size() > 0){
                  Set<Id> disbursementIDs = new Set<Id>();
                    Id disbursementBrokerFeeEFT =[SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Broker_Fee_EFT' LIMIT 1].Id;
                    Id disbursementBrokerFee = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Broker_Fee' LIMIT 1].Id;
                   for(Disbursement__c d: disbursementList){
                            disbursementIDs.add(d.Id);
                                        if(d.RecordTypeId ==  disbursementBrokerFee){
                                                      brokerRecordTypeid = Schema.SObjectType.Disbursement__c.RecordTypeInfosByName.get('Broker Fee').RecordTypeId;
                                                      }
                                        if(d.RecordTypeId == disbursementBrokerFeeEFT){
                                          brokerRecordTypeid = Schema.SObjectType.Disbursement__c.RecordTypeInfosByName.get('Broker Fee EFT').RecordTypeId;
                                          }
                        }
                    }
            //End 
            //Added by FSaliba 16/1/2015 DBHZL - 213            
            if(this.application.Status__c == 'Referred: Pre-Bureau'){
                app2Optional = true;
            }else{
                app2Optional = false;
            }
 
            //Added by vijay on 24/11/2014
            region=[select Country__c from user where id=:userinfo.getUserId()].Country__c;
            
            if(this.application.Id != null){
                productType = this.application.Type_of_Product__c;
                if(!Schema.sObjectType.Application__c.fields.Type_of_Product__c.isUpdateable())
                    productType = GEN_OriginationsConstants.PRODUCT_TYPE;

                currentApplicationBrand     = this.application.Brand_Lookup__c;
                applicationType             = this.application.Application_Type__c;
                confirmAllowInsuranceOffers = this.application.Loan_Insurance_Consent__c;
                Channel                     = this.application.Channel__c;
                this.businessSource         = this.application.Business_Source__c;
                this.mirror                 = this.application.Mirror__c;
                // Added by Arshad: Better Start PL
                this.pSubType               = this.application.Product_SubType__c;
                //Vasu: added for TQLQW-487 - Promo engine change
                this.PromoID                = this.application.Promo_Id__c;
                
                if(this.application.Response_Code__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
                    /*Sept 1, 2016, MDAVID - Make Channel field editable for 3rd Party Applications
                    this.application.Channel__c == GEN_OriginationsConstants.APPLICATION_CHANNEL_3RD_PARTY){ //Afreen - June 29, 2016 - added condition to disable the channel field when channel is 3rd party, regardless of status*/
                    disableChannel = true;
                } else {
                    disableChannel = false;
                }
                
                //TQLQW-481 [PL - AU] PicStarter - MDAVID - 9/06/2016 
                if(this.mirror == GEN_OriginationsConstants.MIRROR_PICSTARTER){
                    disableChannel = false;
                }

                if(applicationType != null){

                    //BEGIN 23-SEPT-15 MLASALA: INSURANCE ISSUE (DUPLICATE PERSONAL LOAN PRODUCT ITEM)
                    //Added filter for Created Date since Personal Loan always gets created first 
                    List<Product_Item__c> pItem = [SELECT   Id, 
                                                            Product_Version__r.GEProduct__c
                                                   FROM     Product_Item__c 
                                                   WHERE    Application__c =: this.application.Id 
                                                   ORDER BY CreatedDate ASC LIMIT 1];
                    //END 23-SEPT-15 MLASALA: INSURANCE ISSUE (DUPLICATE PERSONAL LOAN PRODUCT ITEM)

                    if(pItem.size() > 0){
                        pItemId = pItem[0].Id;                          
                        selProd = pItem[0].Product_Version__r.GEProduct__c;
                    }                                             
                    system.debug('this.applicant.Agrees_to_Fees__c: '+this.applicant.Agrees_to_Fees__c);
                    confirmEligibleForLoan = this.applicant.Meets_Eligibility_Criteria__c;
                    confirmApplicationMeetsNeeds = this.applicant.Agrees_to_Fees__c;
                    confirmAgreedToPolicy = this.applicant.Agrees_to_Privacy_Policy__c; 
                        
                    confirmAllowInsuranceOffers = this.applicant.Loan_Insurance_Consent__c;
                    confirmAllowInsuranceOffers = this.application.Loan_Insurance_Consent__c;
                    confirmHigherApprovalConsent = this.application.Higher_Approval_Consent__c;
                    system.debug('confirmHigherApprovalConsent++$$'+confirmHigherApprovalConsent);
                    
                    //Added by Suneel POI Automation 25/01/2021
                     confirmAgreedToIncomeVerification = this.applicant.Agrees_to_Income_Verification__c;
                     //system.debug('confirmVerifierVerification++$$'+ConfirmVerifierVerification);
                    
                    //Added by ARSHAD: 10/05/2018 -  BDR-105
                    confirmConsentLpi = this.applicant.Consent_to_Lpi__c;
                    
                    //boolean variable, value will be based on applicant.EIDV__c field
                    confirmIdentifyVerification = false;
                    

                    if(this.applicant.EIDV__c != null || this.applicant.EIDV__c != ''){
                        if(this.applicant.EIDV__c == GEN_OriginationsConstants.CHOICE_YES){
                            confirmIdentifyVerification = true;
                        }
                    }
                    
                    confirm2EligibleForLoan = this.applicant2.Meets_Eligibility_Criteria__c;
                    confirm2ApplicationMeetsNeeds = this.applicant2.Agrees_to_Fees__c;
                    confirm2AgreedToPolicy = this.applicant2.Agrees_to_Privacy_Policy__c; 
                        
                    confirm2AllowInsuranceOffers = this.applicant2.Loan_Insurance_Consent__c;
                    confirm2IdentifyVerification = false;
                    
                    //Added by Suneel POI Automation 25/01/2021
                    confirm2AgreedToIncomeVerification = this.applicant2.Agrees_to_Income_Verification__c;

                    //Added by ARSHAD: 10/05/2018 -  BDR-105
                    confirm2ConsentLpi = this.applicant2.Consent_to_Lpi__c;
                    
                    if(this.applicant2.EIDV__c != null || this.applicant2.EIDV__c != ''){
                        if(this.applicant2.EIDV__c == GEN_OriginationsConstants.CHOICE_YES){
                            confirm2IdentifyVerification = true;
                        }
                    }

                }                
                //@August 23-Jan-2014
                if(this.application.Brand_Lookup__c !=null){
                    selectedBrand = this.application.Brand_Lookup__c;
                    //Query to know the Brand and Brand asignment for the user
                    brandList = [Select Id,
                                        Name,
                                        Status__c
                                From    Brand__c
                                Where   Id IN(Select Brand__c 
                                              From Brand_Assignment__c 
                                              Where User__c =: UserInfo.getUserId())
                                And     Status__c = 'Active'
                                And     Id =: selectedBrand];

                    Set<Id> brandListSet = new Set<Id>();
                    
                    for(Brand__c b: brandList){
                        brandListSet.add(b.Id);
                    }

                    //Querry to get the Brands from the Product version
                    pvList =[SELECT Id,
                                    Name,
                                    Brand__c,
                                    End_Date__c,
                                    Start_Date__c,
                                    GEProduct__c,
                                    GEProduct__r.Brands__c,
                                    GEProduct__r.Brands__r.Name
                                FROM Product_Version__c 
                                WHERE (GEProduct__r.Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE 
                                OR  GEProduct__r.Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)
                                AND (Start_Date__c = null OR Start_Date__c <= TODAY)
                                AND  (End_Date__c = null  OR End_Date__c >= TODAY)
                                And GEProduct__r.Brands__c =: brandListSet ];

                    if(pvList.size()>0){
                        selProd = pvList[0].GEProduct__c;
                        disableSaveAndNextButton = false;
                    }else{
                        disableSaveAndNextButton = true;
                        Util.addMessage(ApexPages.Severity.ERROR, 'User does not exist in Brand Assignment, No valid product version or there is no active Brand. You cannot proceed!');
                    }
                
                    disableProductSelection = true;
                }else{
                    //Query to know the Brand and Brand asignment for the user
                    brandList = [Select Id,
                                        Name,
                                        Status__c
                                From    Brand__c
                                Where   Id IN(Select Brand__c 
                                              From Brand_Assignment__c 
                                              Where User__c =: UserInfo.getUserId())
                                And     Status__c = 'Active'];

                    Set<Id> brandListSet = new Set<Id>();
                    for(Brand__c b: brandList){
                        brandListSet.add(b.Id);
                    }

                //Querry to get the Brands from the Product version
                    pvList =[SELECT Id,
                                    Name,
                                    Brand__c,
                                    End_Date__c,
                                    Start_Date__c,
                                    GEProduct__c,
                                    GEProduct__r.Brands__c,
                                    GEProduct__r.Brands__r.Name
                                FROM Product_Version__c
                                WHERE (GEProduct__r.Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE 
                                OR  GEProduct__r.Type__c =: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN)
                                AND (Start_Date__c = null OR Start_Date__c <= TODAY)                                 
                                AND (End_Date__c = null  OR End_Date__c >= TODAY)
                                And GEProduct__r.Brands__c IN: brandListSet];
                    
                    if(pvList.size()>0){
                        selProd = pvList[0].GEProduct__c;
                        disableSaveAndNextButton = false;
                    }else{
                        disableSaveAndNextButton = true;
                    }
                    
                    if(brandList.isEmpty()) {
                        Util.addMessage(ApexPages.Severity.ERROR, 'User does not exist in Brand Assignment, No valid product version or there is no active Brand. You cannot proceed!');  
                    }

                    disableProductSelection = false;
                }
                //@August 23-Jan-2014
            }                       
        }catch(Exception e){
            System.debug('###error: ' + e.getMessage());
            System.debug('###error: ' + e.getLineNumber());
            System.debug('###error: ' + e.getStackTraceString());
        }
       
        
    }
    /*  Description: Field Validations
     *  Author: Mike Lasala
     *  Date Created: OCT-24-2013
     *  Input Parameters: None
     *  Return: Boolean
     */
    public boolean validateFields(){
        
        flag = true;
        errorMessage = '';
        
        if(selectedBrand == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please choose a Product');
        } else if(applicationType == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please choose a Application Type');
        }
        if(Schema.sObjectType.Application__c.fields.Type_of_Product__c.isUpdateable() && productType == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please choose a Product Type');
        }  
        if(Channel == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please select a Channel');
        } else {
            if(Channel == GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER){                
                if(application.Broker__c == null){
                    flag = false;
                    Util.addMessage(ApexPages.Severity.Error, 'Please enter Broker');
                } else {
                    Id brokerAccountRTid = Schema.SObjectType.Contact.RecordTypeInfosByName.get('APAC Contact').RecordTypeId;
                    Contact broker = [SELECT RecordTypeId, Contact_Accreditation_Status__c, Broker_Product__c FROM Contact WHERE Id = :application.Broker__c LIMIT 1];
                    
                    //BEGIN MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                    if(broker.RecordTypeId != brokerAccountRTid || 
                       broker.Contact_Accreditation_Status__c != 'Active' || 
                       (broker.Broker_Product__c != GEN_OriginationsConstants.PL_BROKER_PRODUCT_FILTER && 
                        broker.Broker_Product__c != GEN_OriginationsConstants.MOTOR_BROKER_PRODUCT_FILTER)){
                        flag = false;
                        Util.addMessage(ApexPages.Severity.Error, 'Please enter a valid Broker');
                    }
                    //END MLASALA: 21-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                }
                if(disbursement.Amount__c == null){
                    flag = false;
                    Util.addMessage(ApexPages.Severity.Error, 'Please enter Broker fee');
                }
            } else {
                application.Broker__c = null;
                disbursement.Amount__c = null;
            }
        }
        
        if(application.Branch__c == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please select Branch');
        }
        
        if(this.businessSource == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please select Business Source');
        }
        
        if(this.mirror == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please select Mirror');
        }
        //Added by Arshad - Better Start PL
        if(this.pSubType == null){
            flag = false;
            Util.addMessage(ApexPages.Severity.Error, 'Please select SubType');
        }                      
        //315
         if(!String.isBlank(application.PBUID__c) && (application.PBUID__c.length() > 5 || !application.PBUID__c.isNumeric())) {
         Util.addMessage(ApexPages.Severity.Error, 'Please enter a valid PBUID i.e it should be numeric and less than 5 character in length');
         flag = false;
       }     
       if(!String.isBlank(kiwiBankAccess1) && (kiwiBankAccess1.length() > 15 || !kiwiBankAccess1.isNumeric())) {
         Util.addMessage(ApexPages.Severity.Error, 'Please enter a valid access number i.e it should be numeric and less than 15 character in length');
         flag = false;
       }
       if(!String.isBlank(kiwiBankAccess2) && (kiwiBankAccess2.length() > 15 || !kiwiBankAccess2.isNumeric())) {
         Util.addMessage(ApexPages.Severity.Error, 'Please enter a valid access number i.e it should be numeric and less than 15 character in length');
         flag = false;
       }
        
        return flag;
    }
    
     public PageReference getTypeOfProd(){
        // Added by: adrian recio - empty product type everytime its list of selection is refreshed.
        //productType = '';
        lst_TypeOfProducts = getTypeofProducts(selectedBrand);         
        return null;
    }

     public Disbursement__c disbursement{
        get{
            if(disbursement == null){
                try{
                    return disbursement = [SELECT id,name,Amount__c FROM Disbursement__c WHERE Application__c =: this.application.id AND RecordTypeid =: brokerRecordTypeid LIMIT 1];  
                }catch(exception e){
                    return disbursement = new Disbursement__c(Application__c = this.application.id);
                }
                
            }else{
                return disbursement;
            }
        }
        set;
     }
    /*  Description: Create Application and Applicant records
     *  Author: Mike Lasala
     *  Date Created: OCT-24-2013
     *  Input Parameters: None
     *  Return: void
     */
    public void createRecords() {
        try {
            if(this.application.Type_of_Product__c != null & this.application.Type_of_Product__c != productType){
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Product_Item__c.sObjectType.getDescribe().isDeletable()){
                    DELETE([SELECT id FROM Product_Item__c WHERE Application__c =: this.application.id AND Product_Version__r.GEProduct__r.type__c = : GEN_OriginationsConstants.PRODUCT_TYPE_INSURANCE]);
                }
                */
                DELETE([SELECT id FROM Product_Item__c WHERE Application__c =: this.application.id AND Product_Version__r.GEProduct__r.type__c = : GEN_OriginationsConstants.PRODUCT_TYPE_INSURANCE]);
                this.application.Benji_Rule_Results__c = '';
            }
            this.application.Type_of_Product__c = productType;
            
            Product_Version__c prodId = [Select Id,GEProduct__c FROM Product_Version__c
                                WHERE GEProduct__r.Type__c =: productType 
                                AND (Start_Date__c = null OR Start_Date__c <= TODAY)                                 
                                AND (End_Date__c = null  OR End_Date__c >= TODAY)
                                And GEProduct__r.Brands__c =:selectedBrand];

            selectedProd = prodId.GEProduct__c;
            this.productId = selectedProd;
            this.type = applicationType;
            this.insurance = confirmAllowInsuranceOffers;           
            Applicant__c secondApplicant;
            if(applicationType == 'Joint'){
                this.insurance2 = confirm2AllowInsuranceOffers;
                this.interestOnOtherServices2 = confirm2InterestedInOtherOffer;

            }
            
            appId = this.application.Id;
            Brand__c b = new Brand__c();
            
            
            if(selectedBrand !=null){
                b = [Select Id, Name, Status__c From Brand__c WHERE Id =:selectedBrand];
            }

            SavePoint sp = Database.setSavePoint();
            
            // Process Application
            this.Application.Application_Type__c = applicationType;
            this.Application.Channel__c = this.channel;
            this.Application.Business_Source__c = this.businessSource;
            this.Application.Mirror__c = this.mirror;
            //Added by Arshad - Better Start PL
            this.Application.Product_SubType__c = this.pSubType;               
            
            if(this.channel==GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER) {
                this.Application.Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_REFERRAL;
            } else if(this.channel==GEN_OriginationsConstants.APPLICATION_CHANNEL_SALES) {
                this.Application.Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_WALKIN;
            } else if(this.channel==GEN_OriginationsConstants.APPLICATION_CHANNEL_ONLINE) {
                this.Application.Application_Source__c = GEN_OriginationsConstants.APPLICATION_SOURCE_INTERNET;
            }
            this.Application.Loan_Insurance_Consent__c = confirmAllowInsuranceOffers;
            this.Application.Brand_String__c = b.Name;
            this.Application.Product_Id__c = selectedProd;
            this.Application.Brand_Lookup__c = selectedBrand;
            this.Application.Higher_Approval_Consent__c = confirmHigherApprovalConsent;
            upsert this.Application;
            upsertOtherServiceInterestONR();
            this.Applicant.Loan_Insurance_Consent__c = confirmAllowInsuranceOffers;
            
            //BEGIN MLASALA 20-SEPT-16 TQLQW-487 Promo engine
            //Flush promo messaging when promo id is removed
            if(application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
                
                if(application.Promo_Id__c == null){
                    application.Promo_Ineligible__c = true;
                    
                    if(application.Promo_Message__c != null){
                        application.Promo_Message__c = null;
                    }
                    
                    OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
                    offerCalculator.getProdutctItems(application);
                    if(application.Adjusted_Interest_Fee_Locked__c == false){
                        application.Offered_Establishment_Fee__c = 
                        offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);        
                    }
                } else {
                    application.Promo_Ineligible__c = false;
                }
            }
            //END MLASALA 20-SEPT-16 TQLQW-487 Promo engine
            
            // 1381
            // Determine if application is branch exempted 
            // based on existing list of exempted branches  
            // via Branch POI Exemption custom setting
            Branch__c br = new Branch__c();
            Boolean isBranchExempted = false;
            
            try{
                if(application.Branch__c!=null){
                    br = [Select Id, Branch_ID__c From Branch__c WHERE Id =:application.Branch__c];
                    Branch_POI_Exemption__c bpe = Branch_POI_Exemption__c.getValues(br.Branch_ID__c);
                    if(bpe!=null){
                        if(bpe.Name!=null){
                            isBranchExempted = true;
                        }
                    }   
                }
            }catch(exception e){
                system.debug('Branch Exemption Failed:' + string.valueOf(e));
            }
            system.debug('IsBranchExempted:' + isBranchExempted);
            
            // Process Applicant 1
            this.applicant.Meets_Eligibility_Criteria__c = confirmEligibleForLoan;
            this.applicant.Agrees_to_Fees__c = confirmApplicationMeetsNeeds; 
            this.applicant.Agrees_to_Privacy_Policy__c = confirmAgreedToPolicy;
            this.applicant.Agrees_to_Income_Verification__c = confirmAgreedToIncomeVerification;
            //Added by ARSHAD: 10/05/2018 -  BDR-105
            this.applicant.Consent_to_Lpi__c = confirmConsentLpi;
            
            
            
           // system.debug('Income Verification'+this.applicant.Agrees_to_Income_Verification__c);
           
          
            //315
            this.Applicant.Kiwi_Bank_Access_Number__c = kiwiBankAccess1;
            System.debug('####this.Applicant.Kiwi_Bank_Access_Number__c:'+this.Applicant.Kiwi_Bank_Access_Number__c+'***'+kiwiBankAccess1);
            this.Applicant.Accept_Terms_and_Conditions__c = false;
            if(region!=system.label.NZ_Site_Name){
                if(confirmEligibleForLoan && confirmApplicationMeetsNeeds && confirmAgreedToPolicy){
                    this.Applicant.Accept_Terms_and_Conditions__c = true;
                }
            }else{
                if(confirmEligibleForLoan){
                    this.Applicant.Accept_Terms_and_Conditions__c = true;
                }
            }
            
            //1381
            if(this.application.Promotional_Campaign_Code__c=='' || this.application.Promotional_Campaign_Code__c==null){
                this.Applicant.POI_Financial_Situation_Verified__c = isBranchExempted;
            }
            
            this.Applicant.Is_Primary_Applicant__c = true;
            
            // Process Applicant 2
            System.debug('**this.applicantList.size()**'+this.applicantList.size());
            if(this.applicantList.size() > 1){
                this.applicant2.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;
                this.applicant2.Agrees_to_Fees__c = confirm2ApplicationMeetsNeeds; 
                this.applicant2.Agrees_to_Privacy_Policy__c = confirm2AgreedToPolicy;
                
                //Added by ARSHAD: 10/05/2018 -  BDR-105
                this.applicant2.Consent_to_Lpi__c = confirm2ConsentLpi;
                //Added by Suneel POI Automation 25/01/2021
                 this.applicant2.Agrees_to_Income_Verification__c = confirm2AgreedToIncomeVerification;
                 
                 
                
                //315
                this.applicant2.Kiwi_Bank_Access_Number__c = kiwiBankAccess2;
                System.debug('####this.Applicant2.Kiwi_Bank_Access_Number__c:'+this.Applicant2.Kiwi_Bank_Access_Number__c+'***'+kiwiBankAccess2);
                this.Applicant2.Accept_Terms_and_Conditions__c = false;
                if(region!=system.label.NZ_Site_Name){
                    if(confirm2EligibleForLoan && confirm2ApplicationMeetsNeeds && confirm2AgreedToPolicy){
                        this.Applicant2.Accept_Terms_and_Conditions__c = true;
                    }
                }else{
                    if(confirm2EligibleForLoan){
                        this.Applicant2.Accept_Terms_and_Conditions__c = true;
                    }
                }
                this.Applicant2.Loan_Insurance_Consent__c = confirm2AllowInsuranceOffers;
                
                if(confirm2IdentifyVerification == true){
                    this.Applicant2.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                } else {
                    this.Applicant2.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                }
                
                //1381
                if(this.application.Promotional_Campaign_Code__c=='' || this.application.Promotional_Campaign_Code__c==null){
                    this.Applicant2.POI_Financial_Situation_Verified__c = isBranchExempted;
                }

            }
                
            if(confirmIdentifyVerification == true){
                this.applicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
            } else {
                this.applicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
            }

            try {
                upsert Applicant;                                                        
            } catch (Exception e) {
                system.debug('###error: ' + e.getMessage());
                system.debug('###error: ' + e.getLineNumber());
                system.debug('###error: ' + e.getStackTraceString());
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Applicant__c', 'Class', null);
                if(sp!=null) {
                    Database.rollback( sp ); //rollback if an exception occured
                }
            }
            
            try{
                if(this.applicantList.size()>1){
                    if(confirm2IdentifyVerification == true){
                        this.applicant2.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                    } else {
                        this.applicant2.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                    }

                    upsert applicant2;
                }
            } catch (Exception e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Applicant__c', 'Class', null);
                if(sp!=null) {
                    Database.rollback( sp ); //rollback if an exception occured
                }
            }
            
            //Existing Application                 
            if(appId != null){
                Boolean deleteApplicant2 = false;
                
            
                Applicant__c applicnt;             

                if(applicationType == 'Single'){
                    if(this.applicantList.size() > 1){
                        for(Applicant__c a : this.applicantList){
                            if(a.Is_Primary_Applicant__c == false){
                                deleteApplicant2 = true;                            
                            }
                        }
                    }
                }else{
                    if(this.applicantList.size() == 1){
                        secondApplicant = new applicant__c(); 
                        secondApplicant.application__c = this.application.Id; 
                        secondApplicant.Loan_Insurance_Consent__c = confirm2AllowInsuranceOffers;
                        
                        secondApplicant.Meets_Eligibility_Criteria__c = confirm2EligibleForLoan;
                        secondApplicant.Agrees_to_Fees__c = confirm2ApplicationMeetsNeeds; 
                        secondApplicant.Agrees_to_Privacy_Policy__c = confirm2AgreedToPolicy;
                        
                        //Added by ARSHAD: 10/05/2018 -  BDR-105
                        secondApplicant.Consent_to_Lpi__c = confirm2ConsentLpi;
                        
                        //Added by Suneel for POI Automation
                        secondApplicant.Agrees_to_Income_Verification__c = confirm2AgreedToIncomeVerification;
                        
                        
                        secondApplicant.Accept_Terms_and_Conditions__c = false;
                        if(region!=system.label.NZ_Site_Name){
                            if(confirm2EligibleForLoan && confirm2ApplicationMeetsNeeds && confirm2AgreedToPolicy){
                                secondApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }else{
                            if(confirm2EligibleForLoan){
                                secondApplicant.Accept_Terms_and_Conditions__c = true;
                            }
                        }
                        secondApplicant.Loan_Insurance_Consent__c = confirm2AllowInsuranceOffers;
                        
                        if(confirm2IdentifyVerification == true){
                            secondApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_YES;
                        } else {
                            secondApplicant.EIDV__c = GEN_OriginationsConstants.CHOICE_NO;
                        }
                        secondApplicant.Kiwi_Bank_Access_Number__c = kiwiBankAccess2;
                        //if(Applicant__c.SObjectType.getDescribe().isCreateable()) {
                            upsert secondApplicant;       
                        //}
                        if(this.application.Response_Code__c != 'New'){                          
                            updateAppResponseCode(GEN_OriginationsConstants.APPLICANT_ADDED);                
                        }                     
                    }
                }
                if(deleteApplicant2){
                    try {
                        /*CHECKMARX
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Applicant__c.sObjectType.getDescribe().isDeletable()){
                            delete this.applicantList[1];
                        }
                        */
                        delete this.applicantList[1];
                    } catch (Exception e) {
                        system.debug('###error: ' + e.getMessage());
                        system.debug('###error: ' + e.getLineNumber());
                        system.debug('###error: ' + e.getStackTraceString());
                        ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Applicant__c', 'Class', String.valueOf(this.Application.Id));
                        if(sp!=null) {
                            Database.rollback( sp ); //rollback if an exception occured
                        }
                    }
                }
                
                //Create Product Item Record
                Product_Version__c prodver = [Select Id FROM Product_Version__c
                                WHERE GEProduct__r.Type__c =: productType 
                                AND (Start_Date__c = null OR Start_Date__c <= TODAY)                                 
                                AND (End_Date__c = null  OR End_Date__c >= TODAY)
                                And GEProduct__r.Brands__c =:selectedBrand];
                selectedProdVer = prodver.Id;
                if(pvList[0].Id != null){
                    try{
                        pItem = new Product_Item__c(Id=pItemId, Application__c = appId, Product_Version__c = selectedProdVer);
                        upsert pItem;
                    }
                    catch(DmlException e){
                        System.debug('###error: ' + e.getMessage());
                        System.debug('###error: ' + e.getLineNumber());
                        System.debug('###error: ' + e.getStackTraceString());
                        
                        Util.addMessage(ApexPages.Severity.ERROR, Label.Product_Item_Error);                
                        if(sp!=null) {
                            Database.rollback( sp ); //rollback if an exception occured
                        }
                    }
                }
                
                try {
                    updateAndSetApplicationOutOfSync(this.application);
                    
                    //BEGIN MLASALA 20-AUG-15 PMIHM-1858 
                    if(Util.nullCheck(application.Credit_Score__c) && 
                       application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
                        List<Id> applicationIdList = new List<Id>();
            
                        applicationIdList.add(application.Id);
            
                        if(!applicationIdList.isEmpty()){
                          //BEGIN MLASALA 17-OCT-16 Recalcualte establishment fee is promo est fee is null
                            //Run Pricing Rule engine
                            //RUL_Engine.runPricingEngineAsync(applicationIdList);
              
                          List<Application__c> applicationList = RUL_Engine.getAllApplication(applicationIdList);
                          
                          if(!applicationList.isEmpty()){
                            applicationList = RUL_Engine.runPricingEngine(applicationList);
                          
                            application = applicationList.get(0);
                
                      OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
                      offerCalculator.getProdutctItems(application);
                      
                      if(application.Offered_Establishment_Fee__c == 0.00 || 
                         application.Offered_Establishment_Fee__c == null){
                         application.Offered_Establishment_Fee__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);
                      }
                      
                      update application;  
                          }
                          //END MLASALA 17-OCT-16 Recalcualte establishment fee is promo est fee is null                        
                        }
          }
                    //END MLASALA 20-AUG-15 PMIHM-1858
                    
                } catch(DMLException e) {
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Application__c', 'Class', String.valueOf(this.Application.Id));
                    if(sp!=null) {
                        Database.rollback( sp ); //rollback if an exception occured
                    }
                }
            } else {
                createGenericRecords();
            }
            
            //Insert a disbursenment if channel is broker
            if(this.channel==GEN_OriginationsConstants.APPLICATION_CHANNEL_BROKER) {
                
                //Get Payee broker name information from brkoer account
                //Application__c app = [SELECT id,Broker__r.Account.Broker_Payee_Name__c FROM Application__c WHERE id =: this.Application.id];
                Application__c app = [SELECT id,Broker__r.Account.Broker_Payee_Name__c,Broker__r.Name FROM Application__c WHERE id =: this.Application.id];
                //upsert a disbursement with the broker information  
                try{
                    //Below Line Commented By Suneel 
                    //disbursement.payee__c = app.Broker__r.Account.Broker_Payee_Name__c;
                    disbursement.payee__c = app.Broker__r.Name;
                    disbursement.RecordTypeid = brokerRecordTypeid;
                //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
                    //if(Disbursement__c.SObjectType.getDescribe().isCreateable()) {
                        upsert disbursement;
                    //}
                }catch(DMLException e){
                    ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Disbursement__c', 'Class', app.Id);
                    if(sp!=null) {
                        Database.rollback( sp ); //rollback if an exception occured
                    }
                    flag = false;
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        Util.addMessage(ApexPages.Severity.ERROR, e.getDMLMessage(i));
                    }
                }
            }else{
                //Delete disbursement record, if channel is not brkoer and disbursement exist.
                if(disbursement.id != null)   
                    try{
                        /*
                        // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                        if(Disbursement__c.sObjectType.getDescribe().isDeletable()){
                            delete(disbursement);    
                        }
                        */
                        delete(disbursement); 
                    }catch(exception e){
                        ErrorHandlerException.recordException(e.getMessage(), 'APP_ProductEligibilityExt_INT', 'Disbursement__c', 'Class', null);
                        if(sp!=null) {
                            Database.rollback( sp ); //rollback if an exception occured
                        }
                        flag = false;
                        Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
                    }
            }
        } catch (Exception e) {
            System.debug('###error: ' + e.getMessage());
            System.debug('###error: ' + e.getLineNumber());
            System.debug('###error: ' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'APP_ProductEligibility_INTCC', 'createRecords', 'Class', null);   
            Util.addMessage(ApexPages.Severity.ERROR, e.getMessage());
        }
    }
    
    /*  Description: Create / Update interest ONR related to application
     *  Author: Dan Crisologo
     *  Date Created: OCT-23-2013
     *  Input Parameters: None
     *  Return: None
     */
    private void upsertOtherServiceInterestONR() {
        ONR__c interestOtherServiceONR;
        String onrValue = 'No';
        
        if(this.application.Interested_in_other_services__c) {
            onrValue = 'Yes';
        }
        //query for the existing ONR
        for(ONR__c onr: [SELECT Id,
                                value__c 
                         FROM   ONR__c 
                         WHERE  type__c =: GEN_OriginationsConstants.ONR_TYPE_YESNO
                          AND   recordType.Name =: GEN_OriginationsConstants.ONR_GENERAL
                          AND   application__c =: this.application.Id
                         LIMIT  1]) {
            interestOtherServiceONR = onr;
        }
        //create new ONR based on meta ONR if no existing onr found
        if(interestOtherServiceONR==null) {
            List<Meta_ONR__c> metaONR = [SELECT Prompt__c
                                         FROM   meta_onr__c 
                                         WHERE  type__c =: GEN_OriginationsConstants.ONR_TYPE_YESNO
                                          AND   onr_type__c =: GEN_OriginationsConstants.ONR_GENERAL
                                          AND   geId__c =: GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES];

            Schema.DescribeSObjectResult onrSchema = Schema.SObjectType.ONR__c; 
            Map<String,Schema.RecordTypeInfo> onrRecordTypeInfo = onrSchema.getRecordTypeInfosByName();
            Id onrGeneral = onrRecordTypeInfo.get(GEN_OriginationsConstants.ONR_GENERAL).getRecordTypeId();
            if(metaONR.size()>0) {
                interestOtherServiceONR = new ONR__c(type__c = GEN_OriginationsConstants.ONR_TYPE_YESNO, 
                                                     recordTypeId = onrGeneral,
                                                     geId__c = GEN_OriginationsConstants.META_ID_INTERESTED_IN_OTHER_SERVICES,
                                                     prompt__c = metaONR[0].Prompt__c,
                                                     application__c = this.application.Id);
            }
        }
        interestOtherServiceONR.value__c = onrValue;
        //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
        //if(ONR__c.SObjectType.getDescribe().isCreateable()) {
            upsert interestOtherServiceONR;
        //}
        
    }
    
    /*  Description: Redirect Application record (Staff UI)
     *  Author: Mike Lasala
     *  Date Created: OCT-24-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference saveClose(){
        validateFields();
        
        if(flag == true){
            createRecords();
        } else {
            return null;
        }
        
        if(this.application.Id != null && flag){
            PageReference pageRef = Page.APP_ApplicationMain_INT;
            pageRef.getParameters().put('Id',String.valueOf(this.application.Id));
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    
    /*  Description: Redirect to Loan Purpose page (Staff UI)
     *  Author: Mike Lasala
     *  Date Created: OCT-23-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageNext(){
        
        validateFields();

        if(flag == true){
            createRecords();
        } else {
            return null;
        }
        
        if(this.application.Id != null && flag){
            PageReference pageRef;
            pageRef = Page.APP_LoanPurpose_INT;
            pageRef.getParameters().put('Id',String.valueOf(this.application.Id));
            //added by vijay
            pageRef.getParameters().put('country',region);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    
    /*  Description: Redirect to Application record (Staff UI)
     *  Author: Mike Lasala
     *  Date Created: OCT-28-2013
     *  Input Parameters: None
     *  Return: PageReference
     */
    public PageReference pageCancel(){                        
        PageReference pageRef = Page.APP_ApplicationMain_INT;
        pageRef.getParameters().put('Id',String.valueOf(this.application.Id));
        pageRef.getParameters().put('tab', 'appTab');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*  Description: Gets all Products for GE
     *  Author: Jan Mark Domingo
     *  Date Created: OCT-1-2013
     *  Input: None
     *  Return: options - values for the picklist where the user will select the product.
     */
    public List<SelectOption> getProducts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'Please Select'));
        geProductList = [Select Id, Name from GEProduct__c where Type__c = : GEN_OriginationsConstants.PROD_TYPE];
        if(geProductList.size() > 0){
            for(GEProduct__c geProd : geProductList){
                options.add(new SelectOption(geProd.Id, geProd.Name));
            }
        }
        return options;
    }

    /*  Description: populate brand via brand assignment
     *  Author: August Del Rosario
     *  Date Created: 23-Jan-2014
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> getBrands() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'Please Select'));

        for(brand__c br : brandList){
            options.add(new SelectOption(br.id, br.Name));
        }
        return options;
    }
    /*  Description: Product SubType picklist
     *  Author: Mohammed Arshad
     *  Date Created: 13-May-2019
     *  Input: None
     *  Return: options          
     */
       public List < SelectOption > productSubTypeOptions {
        get{
            List < SelectOption > options = new List < SelectOption > ();
            Better_Start_Offer__c bso = [select BetterStartAUActive__c,BetterStartNZActive__c from Better_Start_Offer__c];
            if(application.Brand_Country__c == GEN_OriginationsConstants.AU_REGION){
            if(bso.BetterStartAUActive__c == true){
                options.add(new SelectOption('', 'Please Select'));                       
                options.add(new SelectOption('Better Start PL', 'Better Start PL'));
                options.add(new SelectOption('Standard PL', 'Standard PL'));
                }else if(bso.BetterStartAUActive__c == false && this.Application.Product_SubType__c=='Better Start PL'){
                    options.add(new SelectOption('', 'Please Select'));                       
                    options.add(new SelectOption('Better Start PL', 'Better Start PL'));
                    options.add(new SelectOption('Standard PL', 'Standard PL'));
                }else if(bso.BetterStartAUActive__c == false){
                    options.add(new SelectOption('Standard PL', 'Standard PL'));
                }
               } 
                else if(application.Brand_Country__c == GEN_OriginationsConstants.NZ_REGION){
                   if(bso.BetterStartNZActive__c == true){
                    options.add(new SelectOption('', 'Please Select'));                       
                    options.add(new SelectOption('Better Start PL', 'Better Start PL'));
                    options.add(new SelectOption('Standard PL', 'Standard PL'));
                 }else if(bso.BetterStartNZActive__c == false && this.Application.Product_SubType__c=='Better Start PL'){
                    options.add(new SelectOption('', 'Please Select'));                       
                    options.add(new SelectOption('Better Start PL', 'Better Start PL'));
                    options.add(new SelectOption('Standard PL', 'Standard PL'));
                }else if(bso.BetterStartNZActive__c == false){
                     options.add(new SelectOption('Standard PL', 'Standard PL'));
                 }
                }
            return options;
        }
        set;
    }
    /*  Description: Channel picklist
     *  Author: Russell Cadapan
     *  Date Created: 17-Dec-2013
     *  Input: None
     *  Return: options
     */
    public List<SelectOption> getChannels(){
        List<SelectOption> options = new List<SelectOption>();
         Map<String, Schema.SObjectField> fieldMap=new Map<String, Schema.SObjectField>();
        fieldMap=Schema.SObjectType.Application__c.fields.getMap();
        List<Schema.PicklistEntry> pickList = fieldMap.get('Channel__c').getDescribe().getPickListValues();
        options.add(new SelectOption('', 'Please Select'));
        for(Schema.PicklistEntry pickvar: pickList){
            options.add(new SelectOption(String.valueOf(pickVar.getValue()),String.valueOf(pickVar.getLabel())));
        }
        return options;

    }
    
    /*  Description: Application Source Picklist
     *  Author: Dan Crisologo
     *  Date Created: 06-MAR-2014
     *  Input: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> getBusinessSources(){
        List<SelectOption> options = new List<SelectOption>();
         Map<String, Schema.SObjectField> fieldMap=new Map<String, Schema.SObjectField>();
        fieldMap=Schema.SObjectType.Application__c.fields.getMap();
        List<Schema.PicklistEntry> pickList = fieldMap.get('Business_Source__c').getDescribe().getPickListValues();
        options.add(new SelectOption('', 'Please Select'));
        map<string,string> ATMAP=new map<string,string>();
        ATMAP.putAll(APP_CommonVariables.retreiveAppMaps('AT', region));
        for(Schema.PicklistEntry pickvar: pickList){
            if(ATMAP.containskey(pickVar.getValue()))
            options.add(new SelectOption(String.valueOf(pickVar.getValue()),String.valueOf(pickVar.getLabel())));
        }
        return options;

    }
    
    /*  Description: Application Source Picklist
     *  Author: Dan Crisologo
     *  Date Created: 06-MAR-2014
     *  Input: None
     *  Return: List<SelectOption>
     */
    public List<SelectOption> getMirrorSelections(){
        List<SelectOption> options = new List<SelectOption>();
         Map<String, Schema.SObjectField> fieldMap=new Map<String, Schema.SObjectField>();
        fieldMap=Schema.SObjectType.Application__c.fields.getMap();
        List<Schema.PicklistEntry> pickList = fieldMap.get('Mirror__c').getDescribe().getPickListValues();
        options.add(new SelectOption('', 'Please Select'));
        map<string,string> BSMAP=new map<string,string>();
        BSMAP.putAll(APP_CommonVariables.retreiveAppMaps('BS', region));
        for(Schema.PicklistEntry pickvar: pickList){
            if(BSMAP.containskey(pickVar.getValue())){
                options.add(new SelectOption(String.valueOf(pickVar.getValue()),String.valueOf(pickVar.getLabel())));
            }else if(pickVar.getValue() == GEN_OriginationsConstants.SOCIETY_ONE && mirror == GEN_OriginationsConstants.SOCIETY_ONE){ //June 14,2016 Afreen - Add Society One option when the application is already from Society One
                options.add(new SelectOption(String.valueOf(pickVar.getValue()),String.valueOf(pickVar.getLabel())));
            }
        }
        
        return options;

    }
    
    /*  Description: Method to navigate back to Search and Match Page 
     *  Author: Fel
     *  Date Created: JAN-10-2014
     *  Input Parameters: None
     *  Return: PageReference
     */
     public PageReference backSearchAndMatch() {                                 
         PageReference pageRef = Page.APP_SearchAndMatch;
         pageRef.getParameters().put('id', String.valueOf(this.application.Id));
         pageRef.setRedirect(true);
         return pageRef;         
     }

     /*  Description: Method called after adding applicant. This updates the Application Response Code
     *  Author: Mac Domingo
     *  Date Created: FEB-11-2014
     *  Input Parameters: None
     *  Return: N/A
     */
     public void updateAppResponseCode(String applicantAction) {                                 
        List<Application_Response__c> appRes = new List<Application_Response__c>();
        List<Application_Response__c> appResUp = new List<Application_Response__c>();
        appRes = [Select Id, Name, Response_Code__c from Application_Response__c where Application__c = : this.application.Id order by CreatedDate DESC Limit 1] ;     
        if(appRes.size() > 0){            
            for(Application_Response__c a : appRes){                
                a.Response_Code__c = applicantAction;
                appResUp.add(a);
            }                      
            try{
                System.debug('** UPDATING APP RESPONSE CODE ' + appResUp);                
                if(appResUp.size() > 0){               
                    update appResUp;  
                }                
            }
            catch(Exception e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_ProductEligibility_INTCC', 'updateAppResponseCode', 'Class');
            }            
        }            
     }    
   
}