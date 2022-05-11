/**
 * @Description: Class that handles the Document Generation
 * @Author: Russell Cadapan (Cloud Sherpas)
 * @Date Created: 02/14/2014
 * @History:
    =========================================================================================
       12-17-13: Created. - Russell Cadapan
       22-04-15: Modified. - Neha Desor Payout statement should not be generated for NZ
       2016-03-29: Modified - TXU added new NZ Template Name for Direct Debit   
    =========================================================================================
**/
public with sharing class DOC_GenerateDocumentsUtil{
    /**  Description: retrieve required documents
     *  Author: Russell Cadapan
     *  Date Created: 02-04-2014
     *  Input Parameters: Id - Application Id
     *  Return: List<Related_Document__c>
     */
    public static final String DOCUMENT_STATUS_RECEIVED = 'Received';
    public static final String DOCUMENT_STATUS_DRAFT = 'Draft';
    public static final String PRODUCT_TYPE = 'Insurance';
    public static final String LINK_TYPE_GENERATED = 'Generated Document';
    public static final String LINK_TYPE_STATIC = 'Static';
    public static final String LINK_TYPE_EVOLVE = 'Evolve';
    public static final String DOCUMENT_CATEGORY = 'Loan Documents';
    public static final String DOCUMENT_TYPE_CONTRACT = 'Contract';
    public static final String DOCUMENT_TYPE_ONR = 'O and Rs';
    public static final String DOCUMENT_TYPE_DIRECT_DEBIT = 'Direct Debit';
    public static final String DOCUMENT_TYPE_DIRECT_DEBIT_NZ = 'Direct Debit'; //added as part of 197,198,199    
    public static final String DOCUMENT_TYPE_SIGN_UP_LETTER_NZ = 'SignUp Letter';   //added as part of 197,198,199
    public static final String DOCUMENT_TYPE_SIGN_UP_LETTER_KIWIBANK_NZ = 'SignUp Letter Kiwibank'; //added as part of 197,198,199
    public static final String DOCUMENT_TYPE_PRIVACY = 'Privacy';
    public static final String DOCUMENT_TYPE_TERMS_AND_CONDITIONS = 'Terms & Conditions';
    public static final String DOCUMENT_TYPE_CREDIT_GUIDE = 'Credit Guide';
    public static final String DOCUMENT_TYPE_COMPLAINTS_BROCHURE = 'Complaints Brochure';
    public static final String DOCUMENT_TYPE_IFREBATE = 'IF Rebate Letter';
    public static final String DOCUMENT_TYPE_CLOSURE = 'Closure Authority';
    public static final String DOCUMENT_TYPE_LIMIT = 'Decrease Authority';
    public static final String DOCUMENT_TYPE_LOAN = 'Loans closure';
    public static final String DOCUMENT_TYPE_LPI = 'LPI';
    public static final String DOCUMENT_TYPE_LPI_BROCHURE = 'LPI Complaints Brochure';
    public static final String DOCUMENT_TYPE_EIDV_CONSENT = 'Electronic ID Consent';
    public static final String DOCUMENT_DISBURSEMENT = 'Disbursement Authority';
    public static final String DOCUMENT_LOAN_PAYOUT = 'Payout Statement';
    public static final String SECTION_CONTRACT = 'Contract';
    public static final String SECTION_ONR = 'Objectives & Requirements';
    public static final String SECTION_PRIVACY = 'Privacy';
    public static final String SECTION_DIRECT_DEBIT = 'Direct Debit';
    public static final String SECTION_DIRECT_DEBIT_NZ = 'Direct Debit Form'; //added as part of 197,198,199
    public static final String SECTION_SIGN_UP_LETTER_NZ = 'SignUp Letter'; //added as part of 197,198,199
    public static final String SECTION_SIGN_UP_LETTER_KIWIBANK_NZ = 'SignUp Letter Kiwibank'; //added as part of 197,198,199
    public static final String SECTION_EFT_DISBURSEMENT = 'EFT Disbursement';
    public static final String SECTION_DEBT_CONSOLIDATION = 'Debt Consolidation';
    public static final String SECTION_INSURANCE = 'Insurance';
    public static final string DOCUMENT_TYPE_DISCLOSURE_STATEMENT='Disclosure Statement';
     //Added by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
    public static final string DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT='Financial Strength and Preferential Policyholder Disclosures Document';

    public static final string DOCUMENT_TYPE_RPI_POLICY='Repayment Protection Insurance Policy Document';
    public static final string DOCUMENT_TYPE_PLIDV_FORM='Personal Loans IDV Form';
    //MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure as part of acceptance pages (as per AU)
    public static final string DOCUMENT_TYPE_INSURANCE_COMPLAINTS_BROCHURE = 'Repayment Protection Insurance Complaints Brochure';
    public String CHANNEL = '';
    public String ACCEPTANCECHANNEL = '';
    map<string,id> docIdmap=new map<string,id>();
    List<Application__c> application;
    
    public List<Related_Document__c> retrieveDocumentsRequired (Id appId){
    
        application = [SELECT   Brand_Lookup__r.Brand_Template_Name__c,
                                Brand_Lookup__r.Name, 
                                Acceptance_Channel__c, 
                                Channel__c, 
                                Brand_Lookup__r.URL_LPI_Complaints_Brochure__c      //MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
                        FROM    Application__c 
                        WHERE   Id =: appId LIMIT 1];

        List<Related_Document__c> requiredDocuments = new List<Related_Document__c>();
        
        Boolean hasInsurance = false; 

            List<Product_Item__c> productItems = new List<Product_Item__c>();
            productItems = [SELECT Product_Version__r.GEProduct__r.Type__c FROM Product_Item__c where Application__c =: appId];
    
            if(productItems.size() > 0){
                for(Product_Item__c pi: productItems){
                    if(pi.Product_Version__r.GEProduct__r.Type__c == PRODUCT_TYPE){
                        hasInsurance = true;
                    }
                }
            }
        for(document d:[select id,DeveloperName from document where DeveloperName IN:GEN_OriginationsConstants.DOCUMENTNAMES]){
            if(GEN_OriginationsConstants.DOCUMENTNAMES.contains(d.DeveloperName)){
                docIdmap.put(d.DeveloperName,d.id);
            }
        }
        
        if(!application.isEmpty()){
            CHANNEL = application.get(0).Brand_Lookup__r.Brand_Template_Name__c;
            system.debug('=-=-=-=-=-<< ' + CHANNEL);
            ACCEPTANCECHANNEL= application.get(0).Acceptance_Channel__c;
            
            // ONRs Document Generation
            if(CHANNEL!=null && !CHANNEL.equalsIgnoreCase('NZPL')){
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_ONR, SECTION_ONR, LINK_TYPE_GENERATED));
            }
            
            //SignupLetter for NZ
            if(CHANNEL!=null && CHANNEL.equalsIgnoreCase('NZPL') && ACCEPTANCECHANNEL == GEN_OriginationsConstants.OFFLINE_ACCEPTANCE) {//
                if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase('kiwibank')){
                    requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_SIGN_UP_LETTER_KIWIBANK_NZ, SECTION_SIGN_UP_LETTER_KIWIBANK_NZ, LINK_TYPE_GENERATED));
                }else{
                    requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_SIGN_UP_LETTER_NZ, SECTION_SIGN_UP_LETTER_NZ, LINK_TYPE_GENERATED));
                }
            }

            // Generate documents required
            // Contract Document Generation
            requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_CONTRACT, SECTION_CONTRACT, LINK_TYPE_GENERATED));
            
            //Privacy Policy
            if(CHANNEL!=null && !CHANNEL.equalsIgnoreCase('NZPL')){//not there for NZ
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_PRIVACY, SECTION_PRIVACY, LINK_TYPE_GENERATED));
                
                //Credit Guide 
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_CREDIT_GUIDE, SECTION_PRIVACY, LINK_TYPE_STATIC));
                
                //Complaints Brochure
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_COMPLAINTS_BROCHURE, SECTION_PRIVACY, LINK_TYPE_STATIC));
            }
            
            // Static documents required
            if(application.get(0).Acceptance_Channel__c == GEN_OriginationsConstants.ONLINE_ACCEPTANCE){
                Applicant__c applicant = new Applicant__c();
                applicant = [SELECT Id, EIDV__c 
                             FROM   Applicant__c 
                             WHERE  Application__c =: appId 
                             AND    Is_Primary_Applicant__c = true LIMIT 1];
                             
                if(applicant.EIDV__c == GEN_OriginationsConstants.CHOICE_YES){
                    //EIDV Consent
                    requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_EIDV_CONSENT, SECTION_PRIVACY, LINK_TYPE_STATIC));
                }
            }
            
            //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
            if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI) || 
               application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ)){
                
                //Terms and Conditions 
                requiredDocuments.add(generateStaticDocument(appId, DOCUMENT_TYPE_TERMS_AND_CONDITIONS, SECTION_CONTRACT, LINK_TYPE_STATIC));
                //Disclosure Statement
                requiredDocuments.add(generateStaticDocument(appId, DOCUMENT_TYPE_DISCLOSURE_STATEMENT, SECTION_CONTRACT, LINK_TYPE_STATIC));
                
                //RPI DOC
               if(hasInsurance){                    
                     //Added Insurance Disclosure Statement by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
                    requiredDocuments.add(generateStaticDocument(appId, DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT, SECTION_INSURANCE, LINK_TYPE_STATIC)); 
                    
                    requiredDocuments.add(generateStaticDocument(appId, DOCUMENT_TYPE_RPI_POLICY, SECTION_INSURANCE, LINK_TYPE_STATIC));
                    
                    //MLASALA 25-JUL-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
                    requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_LPI_BROCHURE, SECTION_INSURANCE, LINK_TYPE_STATIC));      
                                  
                   
                }
                //personal loan IDV Form
                requiredDocuments.add(generateStaticDocument(appId, DOCUMENT_TYPE_PLIDV_FORM, SECTION_PRIVACY, LINK_TYPE_STATIC));
            }else{
                //Terms and Conditions 
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_TERMS_AND_CONDITIONS, SECTION_PRIVACY, LINK_TYPE_STATIC));
            }
        }

        // Condition to generate Direct Debit
        Boolean hasDebit = false;
        List<Debit__c> appDebitList = GEN_RecordRetrievalUtility.retrieveApplicationDebit(appId);
        Id debitRecordType = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' and DeveloperName = 'Direct_Debit' LIMIT 1].Id;
        Id debitRecordTypeNZ = [SELECT Id FROM RecordType where sObjectType = 'Debit__c' and DeveloperName = 'Direct_Debit_NZ' LIMIT 1].Id;

        //Iterate through the debit list if any
        if(appDebitList.size() > 0){
            for(Debit__c d: appDebitList){
                //if any of the debit has a record type of "Direct Debit"
                if(d.RecordTypeId == debitRecordType || d.RecordTypeId == debitRecordTypeNZ){
                    hasDebit = true;
                    break;
                }else{
                    continue;
                }
            }
        }

        // Direct Debit Generation
        if(hasDebit){
            if(CHANNEL!=null && CHANNEL.equalsIgnoreCase('NZPL')){
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_DIRECT_DEBIT_NZ, SECTION_DIRECT_DEBIT, LINK_TYPE_GENERATED));
            }
            else{
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_DIRECT_DEBIT, SECTION_DIRECT_DEBIT, LINK_TYPE_GENERATED));
            }
        }

        List<Disbursement__c> disbursementList = GEN_RecordRetrievalUtility.retrieveDisbursementsList(appId);
        
        if(disbursementList.size() > 0){
            Boolean hasIFRebate = false;
            Set<Id> disbursementIDs = new Set<Id>();
            
            //Added by Suneel - Cheque Disbursement Removal - From line number 211 - 216
            Id disbursementBPayId =[SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'BPAY_AU' LIMIT 1].Id;
            Id disbursementNonLFSCardClosureOverdraftBPay = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Non_LFS_Card_Closure_without_Interest_Free_BPAY' LIMIT 1].Id;
            
            Id disbursementLFSCardLimitReductionBPay = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'GE_Card_Limit_Reduction' LIMIT 1].Id;
            Id disbursementLFSCardLimitReductionwithInterestFreeBPay = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'LFS_Card_Limit_Reduction_with_Interest_Free' LIMIT 1].Id;
            Id disbursementNonLFSCardCardLimitReductionBPay = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Non_LFS_Card_Overdraft_Limit_Reduction_BPAY' LIMIT 1].Id;
           
            Id disbursementDirectCreditId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Direct_Credit' LIMIT 1].Id;
            Id disbursementRefinanceId = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Re_Finance' LIMIT 1].Id;
            Id disbursementGECardClosureIntFree = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'GE_Card_Closure_Interest_Free' LIMIT 1].Id;
            //Adding two new record types for LFS Int Free - IF Rebate - Suneel -10/07/2018
            //Id disbursementLFSCardLimitReductionIntFree = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'LFS_Card_Limit_Reduction_with_Interest_Free' LIMIT 1].Id;
            Id disbursementLFSCardPayDownIntFree = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'LFS_Card_Pay_down_with_Interest_Free' LIMIT 1].Id;
            //End
            Id disbursementGECardClosureNoIntFree = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'GE_Card_Closure_Without_Interest_Free' LIMIT 1].Id;
            Id disbursementGECardClosureOverdraft = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Non_GE_Card_Overdraft_Closure_Without_Interest_Free' LIMIT 1].Id;
            Id disbursementNonGECardOrOverdraftClosure = [SELECT Id FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'Non_GE_Card_OR_Overdraft_Closure_NZ' LIMIT 1].Id;
            // Iterate through the retrieved disbursement records
            for(Disbursement__c d: disbursementList){
                disbursementIDs.add(d.Id);
                // Condition for Closure Authority
                if(d.RecordTypeId == disbursementGECardClosureIntFree || d.RecordTypeId == disbursementGECardClosureNoIntFree || d.RecordTypeId == disbursementGECardClosureOverdraft || d.RecordTypeId == disbursementNonGECardOrOverdraftClosure || d.RecordTypeId == disbursementNonLFSCardClosureOverdraftBPay){
                    Related_Document__c rdClosure = generateDocument(appId, DOCUMENT_TYPE_CLOSURE, SECTION_DEBT_CONSOLIDATION, LINK_TYPE_GENERATED);
                    rdClosure.Disbursement__c = d.Id;
                    requiredDocuments.add(rdClosure);
                }
                // Condition to generate Loan Payout Statement
                if(CHANNEL!=null && !CHANNEL.equalsIgnoreCase('NZPL')){//Neha --- Payout Statement not valid for NZ
                    if(d.RecordTypeId == disbursementRefinanceId){
                        Related_Document__c rdLoanPayout = generateDocument(appId, DOCUMENT_LOAN_PAYOUT, SECTION_DEBT_CONSOLIDATION, LINK_TYPE_GENERATED);
                        rdLoanPayout.Disbursement__c = d.Id;
                        requiredDocuments.add(rdLoanPayout);
                    }
                }
                // Condition for Limit Reduction
                if(d.Disbursement_Outcome__c == 'Reduce' || d.Disbursement_Outcome__c == 'Reduce Limit'){
                    Related_Document__c rdLimit = generateDocument(appId, DOCUMENT_TYPE_LIMIT, SECTION_DEBT_CONSOLIDATION, LINK_TYPE_GENERATED);
                    rdLimit.Disbursement__c = d.Id;
                    requiredDocuments.add(rdLimit);
                }
                // Condition for Disbursement Authority
                if(d.RecordTypeId == disbursementDirectCreditId){
                    Related_Document__c rdCredit = generateDocument(appId, DOCUMENT_DISBURSEMENT, SECTION_EFT_DISBURSEMENT, LINK_TYPE_GENERATED);
                    rdCredit.Disbursement__c = d.Id;
                    requiredDocuments.add(rdCredit);
                }
                //Added By Suneel - Cheque Disbursment Removal
                //Adding disbursementLFSCardPayDownIntFree record type for LFS Int Free - IF Rebate - Suneel -10/07/2018
                 if((d.Amount__c > 0 ) && (d.RecordTypeId == disbursementBPayId || d.RecordTypeId == disbursementNonLFSCardClosureOverdraftBPay || d.RecordTypeId == disbursementGECardClosureIntFree || d.RecordTypeId == disbursementGECardClosureNoIntFree || d.RecordTypeId == disbursementLFSCardLimitReductionBPay || d.RecordTypeId == disbursementLFSCardLimitReductionwithInterestFreeBPay || d.RecordTypeId == disbursementNonLFSCardCardLimitReductionBPay || d.RecordTypeId == disbursementLFSCardPayDownIntFree)){
                    Related_Document__c rdBPay = generateDocument(appId, DOCUMENT_DISBURSEMENT, SECTION_EFT_DISBURSEMENT, LINK_TYPE_GENERATED);
                    rdBPay.Disbursement__c = d.Id;
                    requiredDocuments.add(rdBPay);
                }
            }
            // End of iteration

            Id disbursementPlanId;
            //Id disbursementGECardClosureIntFree = [SELECT ID FROM RecordType WHERE sObjectType =: 'Disbursement__c' AND DeveloperName =: 'GE_Card_Closure_Interest_Free' LIMIT 1].Id;
            Set<Id> disbursementIFRebate = new Set<Id>();
            // Condition to generate IF Rebate
            if(disbursementIDs.size() > 0){
                List<Disbursement_Plan__c> disbursementPlanList = new List<Disbursement_Plan__c>();
                disbursementPlanList = [SELECT Id, Disbursement__c, Disbursement__r.RecordTypeId FROM Disbursement_Plan__c where Disbursement__c IN: disbursementIDs];
                
                if(disbursementPlanList.size() > 0){
                    hasIFRebate = true;
                }
                //Adding disbursementLFSCardPayDownIntFree record type for LFS Int Free - IF Rebate - Suneel -10/07/2018
                for(Disbursement_Plan__c dp: disbursementPlanList){
                   if(dp.Disbursement__r.RecordTypeId == disbursementGECardClosureIntFree || dp.Disbursement__r.RecordTypeId == disbursementLFSCardLimitReductionwithInterestFreeBPay || dp.Disbursement__r.RecordTypeId == disbursementLFSCardPayDownIntFree){
                        disbursementIFRebate.add(dp.Disbursement__c);
                    }
                }
            }           
            //IF Rebate Generation
            if(hasIFRebate){
                if(disbursementIFRebate.size() > 0){
                    for(Id dId: disbursementIFRebate){
                        Related_Document__c rdIFRebate = generateDocument(appId,DOCUMENT_TYPE_IFREBATE, SECTION_DEBT_CONSOLIDATION, LINK_TYPE_GENERATED);
                        rdIFRebate.Disbursement__c = dId;
                        requiredDocuments.add(rdIFRebate);
                    }
                }
            }      
        }

        system.debug('=-CHANNEL=-=-=-=-<< ' + CHANNEL);
        system.debug('=-hasInsurance=-=-=-=-<< ' + hasInsurance);
        
        //BEGIN MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
        if(hasInsurance){
           //BEGIN SUNEEL 14-06-2018 - Include the LPI Complaints Brochure for Latitude
           if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_GEMONEY)){
            requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_LPI_BROCHURE, SECTION_INSURANCE, LINK_TYPE_STATIC));}
            
            if(!CHANNEL.equalsIgnoreCase('NZPL')){
                requiredDocuments.add(generateDocument(appId, DOCUMENT_TYPE_LPI, SECTION_INSURANCE, LINK_TYPE_GENERATED));
            }
        }
        //END MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
        system.debug(requiredDocuments);
        return requiredDocuments;   
    }

    /**  Description: generate required documents
     *  Author: Russell Cadapan
     *  Date Created: 02-04-2014
     *  Input Parameters: appId (Application Id), type (Document Type)
     *  Return: elated_Document__c
     */
    private Related_Document__c generateDocument(Id appId, String type, String section, String linkType){
    
        String typeWithoutSpace = type.replaceAll('\\s+',''); 
        
        Related_Document__c tempDoc = new Related_Document__c();
        tempDoc.Document_Category__c = DOCUMENT_CATEGORY;
        tempDoc.Type__c = type;
        tempDoc.Application__c = appId;
        if(type=='Contract') 
            tempDoc.Title__c = 'Loan Contract Schedule';
        else
            tempDoc.Title__c = type;
            
        tempDoc.Status__c = 'Sent';  
        tempDoc.Section__c = section; 
        tempDoc.GE_Link_Type__c = linkType; 
        tempDoc.Template_Name__c = CHANNEL + typeWithoutSpace;
        if(type == DOCUMENT_TYPE_LIMIT){
            //New template name for Kiwibank
            if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI)){
                tempDoc.Template_Name__c = CHANNEL + 'LimitReductionKiwiBank';
            }else{
                tempDoc.Template_Name__c = CHANNEL + 'LimitReduction';
            }
        }
        else if(type == DOCUMENT_TYPE_IFREBATE){
            tempDoc.Template_Name__c = CHANNEL + 'IFRebate';
        }
        else if(type == DOCUMENT_TYPE_LPI){
            tempDoc.Template_Name__c = 'LPI';
        }
        else if(type == DOCUMENT_TYPE_ONR){
            tempDoc.Template_Name__c = CHANNEL + 'OnR';
        }
        else if(type == DOCUMENT_TYPE_CLOSURE){
            //New template name for Kiwibank
            if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI)){
                tempDoc.Template_Name__c = CHANNEL + 'AccountClosureKiwiBank';
            }else{
                tempDoc.Template_Name__c = CHANNEL + 'AccountClosure';
            }
        }
        else if(type == DOCUMENT_TYPE_PRIVACY){
            tempDoc.Template_Name__c = CHANNEL + typeWithoutSpace + 'Notice';
        }
        else if(type == DOCUMENT_LOAN_PAYOUT){
            String brandTemplateName = [Select Application__c.Brand_Lookup__r.Brand_Template_Name__c from Application__c Where Id =: appId Limit 1].Brand_Lookup__r.Brand_Template_Name__c;
            tempDoc.Template_Name__c = brandTemplateName + typeWithoutSpace;
        }
        else if(type == DOCUMENT_TYPE_EIDV_CONSENT){
            tempDoc.Template_Name__c = CHANNEL + 'EIDV';
        }
        else if(type == DOCUMENT_TYPE_DIRECT_DEBIT_NZ){
            if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ)){
                tempDoc.Template_Name__c = CHANNEL + typeWithoutSpace+'GEM';
            }else{
                if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI)){
                    tempDoc.Template_Name__c = CHANNEL + typeWithoutSpace+'KiwiBank';
                }
            }
        }
        //Txu: 2016-04-12 New Template for NZ Brands
        else if(type == DOCUMENT_TYPE_CONTRACT && application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI)){
           tempDoc.Template_Name__c = CHANNEL + typeWithoutSpace + 'KiwiBank';
        }
        
        //BEGIN MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
        else if(type == DOCUMENT_TYPE_LPI_BROCHURE && 
                (application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ) || 
                 application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI))){
        
            tempDoc.Title__c = DOCUMENT_TYPE_INSURANCE_COMPLAINTS_BROCHURE;
        }
        //END MLASALA 28-JUN-16 TQLQW-276 - Include the NZ Insurance Complaints brochure
        
        else if(type == DOCUMENT_TYPE_SIGN_UP_LETTER_KIWIBANK_NZ){
            tempDoc.Template_Name__c = CHANNEL +'SignUpLetterKiwiBank';
        }
        
        if(linkType == LINK_TYPE_STATIC) {
            tempDoc.Status__c = 'Received';
        }
        
        
        return tempDoc;
    }
    
    private Related_Document__c generateStaticDocument(Id appId, String type, String section, String linkType){
        
        Related_Document__c tempDoc = new Related_Document__c();
        if(type==DOCUMENT_TYPE_PLIDV_FORM || type==DOCUMENT_TYPE_DISCLOSURE_STATEMENT)
            tempDoc.Document_Category__c = 'Internal';
        else
            tempDoc.Document_Category__c = DOCUMENT_CATEGORY;
            
        tempDoc.Type__c = type;
        tempDoc.Application__c = appId; 
        
       // tempDoc.Status__c = 'Sent';  
        tempDoc.Section__c = section; 
        tempDoc.GE_Link_Type__c = linkType;
        tempDoc.Status__c = 'Received';
        tempDoc.Template_Name__c ='Notice';
        
        //MLASALA: 18-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_GEMONEY_NZ) && type==DOCUMENT_TYPE_TERMS_AND_CONDITIONS){
            tempDoc.Title__c = GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' '+type;
            if(docIdmap.containsKey('GE_terms_and_conditions'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('GE_terms_and_conditions')?docIdmap.get('GE_terms_and_conditions'):'');
                //BEGIN MLASALA: 23-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
                tempDoc.AttachmentUrl__c = 'https://assets.gemfinance.co.nz/legals/terms-conditions/gemfinance-terms.pdf';
        }
        if(application.get(0).Brand_Lookup__r.Name.equalsIgnorecase(GEN_OriginationsConstants.BRAND_NAME_KIWI) && type==DOCUMENT_TYPE_TERMS_AND_CONDITIONS){
            tempDoc.Title__c = 'Kiwibank '+type;
            if(docIdmap.containsKey('Kiwibank_terms_and_conditions'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Kiwibank_terms_and_conditions')?docIdmap.get('Kiwibank_terms_and_conditions'):'');
                tempDoc.AttachmentUrl__c='https://assets.gemfinance.co.nz/legals/terms-conditions/kiwibank-terms.pdf';
        }
        if(type==DOCUMENT_TYPE_DISCLOSURE_STATEMENT){
            tempDoc.Title__c = type;
            if(docIdmap.containsKey('Disclosure_Statement'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Disclosure_Statement')?docIdmap.get('Disclosure_Statement'):'');
                tempDoc.AttachmentUrl__c='https://assets.gemfinance.co.nz/legals/product-disclosure-statements/gemoney-nz/financial-adviser-disclosure-statement.pdf';
        }
         //Added by Suneel - LFS RBNZ SF Checkboxes - 29/08/2017
        if(type==DOCUMENT_TYPE_Insurance_DISCLOSURE_STATEMENT){
            tempDoc.Title__c = type;
             if(docIdmap.containsKey('Insurance_DISCLOSURE_STATEMENT'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Disclosure_Statement')?docIdmap.get('Disclosure_Statement'):'');
                tempDoc.AttachmentUrl__c='https://assets.gemfinance.co.nz/legals/product-disclosure-statements/nz/hallmark-disclosure-statement.pdf';
        }
        if(type==DOCUMENT_TYPE_RPI_POLICY){
            tempDoc.Title__c = type;
            if(docIdmap.containsKey('Repayment_protection_brochure'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Repayment_protection_brochure')?docIdmap.get('Repayment_protection_brochure'):'');
                tempDoc.AttachmentUrl__c='https://assets.gemfinance.co.nz/brochures/nz/repayment-protection-brochure.pdf';
        }
        if(type==DOCUMENT_TYPE_PLIDV_FORM){
            tempDoc.Title__c = type;
            if(docIdmap.containsKey('Personal_Loan_IDV_form'))
                //tempDoc.AttachmentUrl__c='/servlet/servlet.FileDownload?file='+(docIdmap.containsKey('Personal_Loan_IDV_form')?docIdmap.get('Personal_Loan_IDV_form'):'');
                tempDoc.AttachmentUrl__c='http://assets.gemfinance.co.nz/forms/loans-nz/identity-verification-form.pdf';
                //END MLASALA: 23-MAR-16 TQLQW-127 Re-brand - Internal and Operational References in Salesforce
        }
        
        return tempDoc;
    } 
}