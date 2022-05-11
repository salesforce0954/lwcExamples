/**
 * @Description: Helper Class that is used to calculate Insurance for NZ products 
 * @Author: Fel Saliba
 * @Date Created: Dec-15-2014
 * @History:
   =====================================================================
       12-15-14: Created. - Fel
       05-01-15: Updated Defect 1287 - Updated calculateIntialBundled method to calculate premium without 
       multiplying to policy type. Updated the calculateInsurnaceNZ method to remove condition if its a single policy
       or not to calculate for joint policies.
   =====================================================================
 */ 

public without sharing class RUL_InsurancePremiumCalculatorNZ {

    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    
    //Custom Setting variables
    public Decimal lifeSplitCoverNZ;
    public Decimal disabilitySplitCoverNZ;
    public Decimal iuiSplitCoverNZ;
    public Decimal jointCoverRateMultiplierNZ;
    public Decimal nZRepaymentMaxCoverAmt;
    public Decimal gstRateNZ;

    public Decimal stampDutyNZ;
    public Decimal rateBasedOnTerm;
    public Decimal policyFee;
    public Decimal loanAmountwithFees;
    public Decimal loanTerm;

    // life insurance variables
    public Decimal lifePremium;
    public Decimal lifePremiumRounded;
    public Decimal lifeTotal;
    public Integer lifepolicyType;

    // disability variables
    public Decimal disabilityPremium;
    public Decimal disabilityPremiumRounded;
    public Decimal disabilityTotal;
    public Decimal disabiltyGSTPremium;
    public Decimal disabilityGSTPremiumRounded;
    public Decimal disabilityTotalWithGST;
    public Integer dispolicyType;

    // iui variables
    public Decimal iuiPremium;
    public Decimal iuiPremiumRounded;
    public Decimal iuiTotal;
    public Decimal iuiGSTPremium;
    public Decimal iuiGSTPremiumRounded;
    public Decimal iuiTotalWithGST;
    public Integer iuipolicyType;

    //Income variable (Combination of disability and iui)
    public Decimal incomeTotalWithGST;

    //Total Insurance Premium
    public Decimal totalInsurancePremium;

    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Constructor used for all initializations
     *  Author: Fel Saliba
     *  Date Created: OCT-24-2013
     *  Input: None
     *  Return: void
     */
    public RUL_InsurancePremiumCalculatorNZ() {

        lifeSplitCoverNZ = Insurance_Premium_Calculation_Variables__c.getInstance('lifeSplitCoverNZ').Value__c;
        disabilitySplitCoverNZ = Insurance_Premium_Calculation_Variables__c.getInstance('disabilitySplitCoverNZ').Value__c;
        iuiSplitCoverNZ = Insurance_Premium_Calculation_Variables__c.getInstance('iuiSplitCoverNZ').Value__c;
        jointCoverRateMultiplierNZ = Insurance_Premium_Calculation_Variables__c.getInstance('jointCoverRateMultiplierNZ').Value__c;
        nZRepaymentMaxCoverAmt = Insurance_Premium_Calculation_Variables__c.getInstance('nZRepaymentMaxCoverAmt').Value__c;
        gstRateNZ = Insurance_Premium_Calculation_Variables__c.getInstance('gstRateNZ').Value__c;

        //currently set these variables to 0
        stampDutyNZ = 0;
        rateBasedOnTerm = 0;
        policyFee = 0;
        //policyType = 0;
        loanAmountwithFees = 0;
        loanTerm = 0;

        lifePremium = 0;
        lifePremiumRounded = 0;
        lifeTotal = 0;
        lifepolicyType = 0;

        disabilityPremium = 0;
        disabilityPremiumRounded = 0;
        disabilityTotal = 0;
        disabiltyGSTPremium = 0;
        disabilityGSTPremiumRounded = 0;
        disabilityTotalWithGST = 0;
        dispolicyType = 0;

        iuiPremium = 0;
        iuiPremiumRounded = 0;
        iuiTotal = 0;
        iuiGSTPremium = 0;
        iuiGSTPremiumRounded = 0;
        iuiTotalWithGST = 0;
        iuipolicyType = 0;

        incomeTotalWithGST = 0;

        totalInsurancePremium = 0;
    }

    public void calculateInsurnaceNZ(Application__c application,Boolean isLifeSingle,Boolean isDisabilitySingle, Boolean isIUISingle,Boolean isLifeJoint,Boolean isDisabilityJoint,Boolean isIUIJoint){

            Decimal loanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
            Decimal establishmentFee = application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
            Decimal searchFee = application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
            Decimal registrationFee = application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
            Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;        
            
            Decimal totalLoanAmt = loanAmount + establishmentFee + searchFee + registrationFee + brokerFee;
            
            loanAmountwithFees = totalLoanAmt > nZRepaymentMaxCoverAmt ? nZRepaymentMaxCoverAmt : totalLoanAmt;
            
            System.debug('loanAmountwithFees-------->'+loanAmountwithFees);

            //policyType = application.Application_Type__c != 'Single' ? 2 : 1;
            //ystem.debug('policyType-------->'+policyType);
            
            loanTerm = application.Loan_Term_Months__c < 84 ? application.Loan_Term_Months__c : 84;
            System.debug('loanTerm-------->'+loanTerm);

            rateBasedOnTerm = [SELECT rate__c 
                               FROM Rate__c
                               WHERE Rate_Card__r.Rate_Card_Name__c =: 'Rating Factor Table NZ'
                               AND Principal_Maximum__c >=: loanTerm
                               AND Principal_Minimum__c <=: loanTerm
                               AND Credit_Score__c =: 'AA'
                               AND rate_card__r.Start_Date__c <=: application.LastModifiedDate
                               AND rate_card__r.End_Date__c >=: application.LastModifiedDate].Rate__c;
            System.debug('rateBasedOnTerm-------->'+rateBasedOnTerm);

            //get bundled for Life Insurance
            Decimal bundledTotalLife;
            if(isLifeSingle != null && isLifeJoint != null && (isLifeSingle || isLifeJoint)){
                Decimal lifeFinRate = rateBasedOnTerm;
                lifepolicyType = 1;
                if(isLifeJoint){
                    lifeFinRate = rateBasedOnTerm * jointCoverRateMultiplierNZ;
                    lifepolicyType = 2;
                }
                System.debug('lifeFinRate-------->'+lifeFinRate);
                bundledTotalLife = calculateIntialBundled(lifeFinRate, 'Life', lifepolicyType);
                System.debug('bundledTotalLife-------->'+bundledTotalLife);
                
                //calculate Life 
                lifePremium = bundledTotalLife * lifeSplitCoverNZ;
                System.debug('lifePremium-------->'+lifePremium);
                lifePremiumRounded = lifePremium.setScale(2);
                System.debug('lifePremiumRounded-------->'+lifePremiumRounded);
                lifeTotal = lifePremiumRounded;
                System.debug('lifeTotal-------->'+lifeTotal);
            }

            //get bundled for Disability Insurance
            Decimal bundledTotalDisability;
            if(isDisabilitySingle != null && isDisabilityJoint != null && (isDisabilitySingle || isDisabilityJoint)){
                Decimal disabilityFinRate = rateBasedOnTerm;
                dispolicyType = 1;
                if(isDisabilityJoint){
                    disabilityFinRate = rateBasedOnTerm * jointCoverRateMultiplierNZ;
                    dispolicyType = 2;
                }
                bundledTotalDisability = calculateIntialBundled(disabilityFinRate, 'Disability',dispolicyType);

                //calculate Disability
                disabilityPremium = bundledTotalDisability * disabilitySplitCoverNZ;
                System.debug('disabilityPremium-------->'+disabilityPremium);
                disabilityPremiumRounded = disabilityPremium.setScale(2);
                System.debug('lifePremiumRounded-------->'+lifePremiumRounded);
                disabilityTotal = disabilityPremiumRounded;
                System.debug('disabilityTotal-------->'+disabilityTotal);
                disabiltyGSTPremium = disabilityPremium * (gstRateNZ/100);
                System.debug('disabiltyGSTPremium-------->'+disabiltyGSTPremium);
                disabilityGSTPremiumRounded = disabiltyGSTPremium.setScale(2);
                System.debug('disabilityGSTPremiumRounded-------->'+disabilityGSTPremiumRounded);
                disabilityTotalwithGST = disabilityTotal + disabilityGSTPremiumRounded;
                System.debug('disabilityTotalwithGST-------->'+disabilityTotalwithGST);

            }

            //get bundled for Involuntaty Unemployment Insurance
            Decimal bundledTotalIUI;
            if(isIUISingle != null && isIUIJoint != null && (isIUISingle || isIUIJoint)){
                Decimal iuiFinRate = rateBasedOnTerm;
                iuipolicyType = 1;
                if(isIUIJoint){
                    iuiFinRate = rateBasedOnTerm * jointCoverRateMultiplierNZ;
                    iuipolicyType = 2;
                }
                bundledTotalIUI = calculateIntialBundled(iuiFinRate, 'IUI',iuipolicyType);

                //calculate Iui
                iuiPremium = bundledTotalIUI * iuiSplitCoverNZ;
                System.debug('iuiPremium-------->'+iuiPremium);
                iuiPremiumRounded = iuiPremium.setScale(2);
                System.debug('iuiPremiumRounded-------->'+iuiPremiumRounded);
                iuiTotal = iuiPremiumRounded;
                System.debug('iuiTotal-------->'+iuiTotal);
                iuiGSTPremium = iuiPremium * (gstRateNZ/100);
                System.debug('iuiGSTPremium-------->'+iuiGSTPremium);
                iuiGSTPremiumRounded = iuiGSTPremium.setScale(2);
                System.debug('iuiGSTPremiumRounded-------->'+iuiGSTPremiumRounded);
                iuiTotalwithGST = iuiTotal + iuiGSTPremiumRounded;
                System.debug('iuiTotalwithGST-------->'+iuiTotalwithGST);
            }

            //calculate Income (Disability and IUI combination)
            incomeTotalWithGST = disabilityTotalwithGST + iuiTotalwithGST;

            //calculate totalInsurancePremium (Income + life)
            totalInsurancePremium = incomeTotalWithGST + lifeTotal;
    }

    public Decimal calculateIntialBundled(Decimal finRateBasedOnTerm, String insuranceType, Integer policyType){

        //calculate Bundled
        //Updated by DYU 05-01-2015 Defect 1287 - premium should not be multiplied by number of policy type
        //Decimal bundledPremium = ((loanAmountwithFees * (finRateBasedOnTerm/100)) * policyType) + policyFee;
         Decimal bundledPremium = (loanAmountwithFees * (finRateBasedOnTerm/100)) + policyFee;
        System.debug('bundledPremium-------->'+bundledPremium);
        Decimal bundledPremiumRounded = bundledPremium.setScale(2);
        System.debug('bundledPremiumRounded-------->'+bundledPremiumRounded);
        Decimal bundledTotal = bundledPremiumRounded;
        System.debug('bundledTotal- '+insuranceType+'-------->'+bundledTotal);

        return bundledTotal;
    }
}