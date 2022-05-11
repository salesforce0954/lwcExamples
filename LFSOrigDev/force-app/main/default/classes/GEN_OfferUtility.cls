/**
 * @Description: General class for Offer fields recalculation and flushing offers
 * @Author: Fel Saliba
 * @Date Created: February-12-2014
 * @History:
   =====================================================================
       02-12-14: Created. - Fel
       05-02-15: Updated DYU Defect 1287 - Updated calculateProductItems method to update GST as zero for life insurance policy - DY
   =====================================================================
 */ 
public without sharing class GEN_OfferUtility{
    
    
    
    /*  Description: Method that deletes flush Offer (Delete Insurances and Debt consolidation)
     *  Author: Fel Saliba
     *  Date Created: Feb-12-2014
     *  Input: List<Applicant__c>
     *  Return: List<Applicant__c>
     */
    public static void flushOffers(List<Application__c> appToReset){
        
        Set<Id> appIdToReset = new Set<Id>();
        for(Application__c app:appToReset){
            appIdToReset.add(app.Id);
        }

        //query on the Product Items
        String personal = GEN_OriginationsConstants.PRODUCT_TYPE;
        List<Product_Item__c> prodItemList = new List<Product_Item__c>();
        prodItemList = [Select 	Id 
        				from 	Product_Item__c 
        				Where 	Application__c 
        				IN: 	appIdToReset 
                        AND 	Product_Version__r.Type__c !=: personal
                        AND 	Product_Version__r.Type__c !=: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN];
        
        //if size greater than 0 delete the product items to clear insurance             
        if(!prodItemList.isEmpty()){
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Product_Item__c.sObjectType.getDescribe().isDeletable()){
                    delete prodItemList;
                }
                */
                delete prodItemList;
            }
            catch(DMLException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_OfferUtility', 'Product_Item__c', 'Class');
            }
        }
    }

    /*  Description: Method that flush Offers for applicant 2.
     *  Author: Fel Saliba
     *  Date Created: June-23-2014
     *  Input: List<Applicant__c>
     *  Return: List<Applicant__c>
     */
    public static void flushApplicant2(List<Application__c> appToRecalculate){
        
        Set<Id> appIdToReset = new Set<Id>();
        for(Application__c app:appToRecalculate){
            appIdToReset.add(app.Id);
        }
           
        //query on the Product Items
        String personal = GEN_OriginationsConstants.PRODUCT_TYPE;
        List<Product_Item__c> prodItemList = new List<Product_Item__c>();
        for(Product_Item__c prodItems:[Select 	Id, 
        										Applicant2__c 
        							   from 	Product_Item__c 
        							   Where 	Application__c 
        							   IN: 		appToRecalculate
                        			   AND 		Product_Version__r.Type__c !=: personal
                        		 	   AND 		Product_Version__r.Type__c !=: GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN]){
            
            //set Applicant 2 look up to null            
            prodItems.Applicant2__c = null;
            prodItemList.add(prodItems);
        }        
        
        //if size greater than 0 update the product items            
        if(!prodItemList.isEmpty()){
            try{
                update prodItemList;
            }
            catch(DMLException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_OfferUtility', 'Product_Item__c', 'Class');
            }
        }
    }
    
    
    /*  Description: Method that will populate/recalculate Offer Fields in Application
     *  Author: Fel Saliba
     *  Date Created: Feb-12-2014
     *  Input: Application__c
     *  Return: Application__c
     */
    public static Application__c populateOfferFields(Application__c application,Boolean riskGrade){
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItems(application);
        application.Offered_PPSR_Search_Fee__c  = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_PPSR_SEARCH);
        application.Offered_PPSR_Registration_Fee__c  = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_PPSR_REGISTRATION);
	
	//MLASALA 26-SEPT-16 TQLQW-497 Promo engine
	//Added condition for promo engine
        if(application.Adjusted_Interest_Fee_Locked__c == false && 
           application.Offered_Establishment_Fee__c == null){
            application.Offered_Establishment_Fee__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);        
        }
        application.Offered_Monthly_Loan_Service_Fee__c  = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_LOAN_SERVICE);
        
        System.debug(LOGGINGLEVEL.ERROR,'Before-->'+application.Offered_Interest_Rate__c);

        //Decimal offeredInterestRateOrig = offerCalculator.getBlendedRate(application, offerCalculator.getInterestRate(application));
        
        //if(application.Adjusted_Interest_Rate__c == null){
        //    application.Offered_Interest_Rate__c = offerCalculator.getBlendedRate(application, offerCalculator.getOfferedInterestRateWithAppResponse(application));

        //    System.debug(LOGGINGLEVEL.ERROR,'AfterAdjustedNull-->'+application.Offered_Interest_Rate__c);    
        //}
        //else{
            // if it is risk grade, get the new rate and clear adjusted fields.
            // if not used adjusted rate.
            if(riskGrade){
                //application.Offered_Interest_Rate__c = offeredInterestRateOrig;
                //System.debug(LOGGINGLEVEL.ERROR,'AfterAdjustedNotNull-->'+application.Offered_Interest_Rate__c); 
                
                //since we will not be using the adjusted rate, set the adjusted fields to null and false.
                //this will allow the agent in case he wants to do another rate reduction. 
                application.Adjusted_Interest_Rate_Locked__c = false;
                application.Adjusted_Interest_Rate_Reason__c = '';
                application.Adjusted_Interest_Rate__c = null;
                application.Workflow_In_Progress__c = false;
            }            
        //}
        System.debug('$$$ OFFERED INTEREST RATE INSIDE OFFER UTILITY: '+application.Offered_Interest_Rate__c);
        application.EMI_with_Service_Fee__c = offerCalculator.getRepaymentWithServiceFee(application);
        application.Offered_Repayments__c  = offerCalculator.getRepaymentEMI(application);
        application.Offered_Frequency_Repayments__c = offerCalculator.getFrequencyRepayment(application);
        
        //Added by Fel Saliba 1/20/2014
        //get Original Values
        if(application.Offered_PPSR_Search_Fee_Orig__c == null){
           application.Offered_PPSR_Search_Fee_Orig__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_PPSR_SEARCH);
        }
        if(application.Offered_PPSR_Registration_Fee_Orig__c == null){
           application.Offered_PPSR_Registration_Fee_Orig__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_PPSR_REGISTRATION);
        }
        if(application.Offered_Monthly_Loan_Service_Fee_Orig__c == null){
            application.Offered_Monthly_Loan_Service_Fee_Orig__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_LOAN_SERVICE);
        }
        if(application.Offered_Establishment_Fee_Orig__c == null){
            application.Offered_Establishment_Fee_Orig__c = offerCalculator.getFee(application, GEN_OriginationsConstants.FEE_ESTABLISHMENT);
        }
        //application.Offered_Interest_Rate_Orig__c = offeredInterestRateOrig;
        if(application.Offered_Repayments_Orig__c == null){
            application.Offered_Repayments_Orig__c = offerCalculator.getRepaymentEMI(application);
        }        
        
       Application__c app = getIndividualInsuranceAndPayable(application);                
       return app;
    }
    
    /*  Description: Method that will calculate Product Item Insurance fields
     *  Author: Fel Saliba
     *  Date Created: Feb-12-2014
     *  Input: List<Application__c> application
     *  Return: NONE
     */
    public static Application__c getIndividualInsuranceAndPayable(Application__c application){
        //call the class to compute for Individual Insurance
        RUL_InsurancePremiumCalculator rule = new RUL_InsurancePremiumCalculator();
        
        /*Decimal singleLifeInsurancePremium = rule.getIndividualPremium(application,true,false,false,false,false,false);
        application.Insurance_Life_Premium_Single__c = rule.singleLifeInsurancePremium;
        
        Decimal jointLifeInsurancePremium = rule.getIndividualPremium(application,false,true,false,false,false,false);
        application.Insurance_Life_Premium_Joint__c = rule.jointLifeInsurancePremium;
        
        Decimal singleDisabInsurancePremium = rule.getIndividualPremium(application,false,false,true,false,false,false);
        application.Insurance_Disability_Premium_Single__c = rule.singleDisabInsurancePremium;
        
        Decimal jointDisabInsurancePremium = rule.getIndividualPremium(application,false,false,false,true,false,false);
        application.Insurance_Disability_Premium_Joint__c = rule.jointDisabInsurancePremium;
        
        Decimal singleIuiInsurancePremium = rule.getIndividualPremium(application,false,false,false,false,true,false);
        application.Insurance_IUI_Premium_Single__c = rule.singleIuiInsurancePremium;
        
        Decimal jointIuiInsurancePremium = rule.getIndividualPremium(application,false,false,false,false,false,true);
        application.Insurance_IUI_Premium_Joint__c = rule.jointIuiInsurancePremium; */
        
        if(application.Offered_Interest_Rate__c != null && application.Offered_Interest_Rate__c != 0 && application.Loan_Term_Months__c != null && application.Loan_Term_Months__c != 0){            
            application.Total_Loan_Interest_Amount_Payable__c = rule.computeTotalInterestAmountPayable(application);
            if(application.Total_Insurance_Premium__c != null && application.Total_Insurance_Premium__c != 0){
                application.Total_Insurance_Interest_Amount_Payable__c = rule.computeTotalAmountInsurancePayable(application);
            }
            else{
                application.Total_Insurance_Interest_Amount_Payable__c = 0;
            }
        }
                
        return application;    
    }
     
    
    /*  Description: Method that will calculate Product Item Insurance fields
     *  Author: Fel Saliba
     *  Date Created: Feb-12-2014
     *  Input: List<Application__c> application
     *  Return: NONE
     */
    public static void calculateProductItems(List<Application__c> applicationList){
        
        List<Product_Item__c> uProdItem = new List<Product_Item__c>();
        Map<Id,Application__c> prodAppMap = new Map<Id,Application__c>();
        
        Set<Id> applicationIds = new Set<Id>();
        for(Application__c app:applicationList){
            applicationIds.add(app.Id);
            prodAppMap.put(app.Id,app);
        }
        
        List<Product_Item__c> prodItemList = new List<Product_Item__c>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        String insurance = 'Insurance';
        query += 'Product_Version__r.Product_Name__c, ' + 
                 'Application__r.Total_Loan_Amount__c, ' +
                 'Application__r.Total_Insurance_Premium__c, ' +
                 'Application__r.Offered_Establishment_Fee__c, ' +
                 'Application__r.Offered_PPSR_Registration_Fee__c, ' +
                 'Application__r.Offered_PPSR_Search_Fee__c, ' +
                 'Application__r.Brokerage_Fee__c, ' +
                 'Application__r.Is_Secured__c, ' +
                 'Application__r.Channel__c, ' +
                 'Application__r.Brand_Country__c, ' +
                 'Application__r.Loan_Term_Months__c ' + 
                 'FROM Product_Item__c where Application__c IN: applicationIds ' + 
                 'AND Product_Version__r.Type__c =: ' + insurance;
        prodItemList =  Database.query(query);
        
        Boolean isLifeSingle       = false;
        Boolean isDisabilitySingle = false;
        Boolean isIUISingle        = false;
        Boolean isLifeJoint        = false;
        Boolean isDisabilityJoint  = false;
        Boolean isIUIJoint         = false;
        
        for(Product_Item__c prodItem: prodItemList){
            if(prodItem.Applicant2__c !=  null){
                if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                    isLifeJoint = true;
                }
                else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                    isDisabilityJoint = true;
                }
                else{
                    isIUIJoint = true; 
                }
            }
            else{
                if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                    isLifeSingle = true;
                }
                else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                    isDisabilitySingle = true;
                }
                else{
                    isIUISingle = true;
                }
            }
        }
        System.debug('genOfferVAlues-->'+isLifeSingle+ ' ' +isDisabilitySingle+ ' '+isIUISingle+ ' ' +isLifeJoint+ ' ' +isDisabilityJoint+ ' ' +isIUIJoint);
        for(Product_Item__c prodItem: prodItemList){

            RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();
            prodItem.Ins_Term__c = prodItem.Application__r.Loan_Term_Months__c;              
            prodItem.Policy_Num__c = 0;
            //Added by Fel Saliba 12/16/2014 - Check for Country of origin to apply correct calculation
            RUL_InsurancePremiumCalculatorNZ rulNZ = new RUL_InsurancePremiumCalculatorNZ();
            if(prodItem.Application__r.Brand_Country__c == 'NZ'){
                rulNZ.calculateInsurnaceNZ(prodAppMap.get(prodItem.Application__c),
                                       isLifeSingle,
                                       isDisabilitySingle,
                                       isIUISingle,
                                       isLifeJoint,
                                       isDisabilityJoint,
                                       isIUIJoint);
                prodItem.Policy_Type__c = 0;
                if(prodItem.Applicant2__c !=  null){
                    prodItem.Policy_Type__c = 1;
                }
                if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                    prodItem.Fixed_Premium_Amount__c = rulNZ.lifeTotal;
                    prodItem.Insurance_GST__c = 0;
                    prodItem.Insurance_Stamp_Duty__c = 0;
                    prodItem.Insurance_Stamp_Duty_Amount__c = 0;
                }
                else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                    prodItem.Fixed_Premium_Amount__c = rulNZ.disabilityTotalWithGST;
                    prodItem.Insurance_GST__c = rulNZ.disabilityGSTPremiumRounded;
                    prodItem.Insurance_Stamp_Duty__c = 0;
                    prodItem.Insurance_Stamp_Duty_Amount__c = 0;
                }
                else{
                    prodItem.Fixed_Premium_Amount__c = rulNZ.iuiTotalWithGST;
                    prodItem.Insurance_GST__c = rulNZ.iuiGSTPremiumRounded;
                    prodItem.Insurance_Stamp_Duty__c = 0;
                    prodItem.Insurance_Stamp_Duty_Amount__c = 0;       
                }
            }
            else if(prodItem.Application__r.Brand_Country__c == 'AU'){ 
                if(prodItem.Applicant2__c !=  null){
                    //prodItem.Applicant2__c = applicant2.Id;
                    prodItem.Policy_Type__c = 1;
                    if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                        Decimal idividualLifeJoint = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.jointLifeInsurancePremium;
                        prodItem.Insurance_GST__c = 0;
                        prodItem.Insurance_Stamp_Duty__c = rul.lifeStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointLifeSdRounded;
                    }
                    else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                        Decimal idividualDisabilityJoint = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.jointDisabInsurancePremium;
                        prodItem.Insurance_GST__c = rul.jointDisabGstAmount;
                        prodItem.Insurance_Stamp_Duty__c = rul.disabilityStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointDisabStampDuty;
                    }
                    else{
                        Decimal idividualIUIJoint = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.jointIuiInsurancePremium;
                        prodItem.Insurance_GST__c = rul.jointIuiGstAmount;
                        prodItem.Insurance_Stamp_Duty__c = rul.iuiStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.jointIuiSdRounded;
                    }                 
                }
                else{
                    if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.LIFE_INSURANCE){
                        Decimal idividualLifeSingle = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.singleLifeInsurancePremium;
                        prodItem.Insurance_GST__c = 0;
                        prodItem.Insurance_Stamp_Duty__c = rul.lifeStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleLifeSdRounded;
                    }
                    else if(prodItem.Product_Version__r.Product_Name__c == GEN_OriginationsConstants.DISABILITY_INSURANCE){
                        Decimal idividualDisabilitySingle = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.singleDisabInsurancePremium;
                        prodItem.Insurance_GST__c = rul.singleDisabGstAmount;
                        prodItem.Insurance_Stamp_Duty__c = rul.disabilityStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleDisabSdRounded;
                    }
                    else{
                        Decimal idividualIUISingle = rul.getIndividualPremium(prodAppMap.get(prodItem.Application__c),isLifeSingle,isDisabilitySingle,isIUISingle,isLifeJoint,isDisabilityJoint,isIUIJoint);
                        prodItem.Fixed_Premium_Amount__c = rul.singleIuiInsurancePremium;
                        prodItem.Insurance_GST__c = rul.singleIuiGstAmount;
                        prodItem.Insurance_Stamp_Duty__c = rul.iuiStampDuty;
                        prodItem.Insurance_Stamp_Duty_Amount__c = rul.singleIuiSdRounded;
                    }
                    prodItem.Policy_Type__c = 0;                 
                }
            }
            uProdItem.add(prodItem);
        }
        
        //check the list size prior update
        if(uProdItem.size() > 0){
            System.debug('uProdItem-->'+uProdItem);
            try{
                update uProdItem;
            }
            catch(DMLException e){
                ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'GEN_OfferUtility', 'Product_Item__c', 'Class');
            }
        }
    }
}