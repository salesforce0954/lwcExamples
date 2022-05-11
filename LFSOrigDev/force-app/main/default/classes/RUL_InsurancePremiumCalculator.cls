/*
 * @Description: Build Insurance Premium Calculation Engine
 * @Author: Jade Serrano
 * @Date Created: 19-NOV-2013
 * @History:
 * =====================================================================
 * Jade - 19-NOV-13: Created
 * =====================================================================
 */
public without sharing class RUL_InsurancePremiumCalculator {
    
    Decimal apr = 0;
    Decimal loanTerm = 0;
    Decimal term = 0;
    Decimal incsPerCov = 0;
    Decimal startingPrincipalExcludingPremium = 0;
    Decimal principalLnFaceLoanAmt = 0;
    Decimal fee = 0;

    //LIFE
    Decimal lifeInsPremRate = 0;
    Decimal lifeStampDutyRate = 0;
    Decimal lifeJoint = 0;

    //DISAB
    Decimal disabInsPremRate = 0;
    Decimal disabJoint = 0;
    Decimal disabFee = 0;
    Decimal disabGst = 0;
    Decimal disabStampDutyrate = 0;

    //IUI
    Decimal iuiFee = 0;
    Decimal iuiGst = 0;
    Decimal iuiStampDutyRate = 0;


    Decimal monthlyApr = 0;
    Decimal creditLifeRateMonthly = 0;
    Decimal n = 0;
    Decimal an7 = 0;
    Decimal principal = 0;
    Decimal monthlyEmi = 0;
    Decimal creditLifePremium = 0;
    Decimal monthlyEmiForDisabilityPremiumCalculation = 0;

    //LIFE
    Decimal singleCreditLifePremium = 0;
    Decimal jointCreditLifePremium = 0;
    Decimal singleLifeStampDuty = 0;
    Decimal jointLifeStampDuty = 0;
    Decimal singleLifeTotal = 0;
    Decimal jointLifeTotal = 0;
    Decimal singleGrossLifeRounded = 0;
    Decimal jointGrossLifeRounded = 0;
    Decimal singleNetLifePremium = 0;
    Decimal jointNetLifePremium = 0;

    //DISAB
    Decimal singleDisab = 0;
    Decimal jointDisab = 0;
    Decimal singleDisabPrem = 0;
    Decimal jointDisabPrem = 0;
    Decimal singleDisabGst = 0;
    Decimal jointDisabGst = 0;
    Decimal singleDisabGSTRounded = 0;
    Decimal jointDisabGSTRounded = 0;
    Decimal singleDisabStampDuty = 0;
    Decimal jointDisabSdRounded = 0;
    Decimal singleDisabTotal = 0;
    Decimal jointDisabTotal = 0;
    Decimal singleGrossDisabRounded = 0;
    Decimal jointGrossDisabRounded = 0;
    Decimal singleNetDisabPremium = 0;
    Decimal jointNetDisabPremium = 0;

    //IUI
    Decimal singleIuiPrem = 0;
    Decimal jointIuiPrem = 0;
    Decimal singleIuiGst = 0;
    Decimal jointIuiGst = 0;
    Decimal singleIuiGstRounded = 0;
    Decimal jointIuiGstRounded = 0;
    Decimal singleIuiStampDuty = 0;
    Decimal jointIuiStampDuty = 0;
    Decimal singleIuiTotal = 0;
    Decimal joinrIuiTotal = 0;
    Decimal singleGrossIuiRounded = 0;
    Decimal jointGrossIuiRounded = 0;
    Decimal singleNetIuiPremium = 0;
    Decimal jointNetIuiPremium = 0;

    Decimal counter = 1;
    Decimal counterMax = Insurance_Premium_Calculation_Variables__c.getInstance('counter').Value__c;
    Decimal maxMonthlyEmi = Insurance_Premium_Calculation_Variables__c.getInstance('maxMonthlyEmi').Value__c;
    Decimal maxPrincipal = Insurance_Premium_Calculation_Variables__c.getInstance('maxPrincipal').Value__c;

    Boolean lifePremiumSingle = false;
    Boolean lifePremiumJoint = false;
    Boolean disabilityPremiumSingle = false;
    Boolean disabilityPremiumJoint = false;
    Boolean iUIPremiumSingle = false;
    Boolean iUIPremiumJoint = false;

    public Decimal lifeStampDuty{get;set;}
    public Decimal disabilityStampDuty{get;set;}
    public Decimal iuiStampDuty{get;set;}
    public Decimal pubDisabilityGst{get;set;}
    public Decimal pubIuiGst{get;set;}

    public Decimal singleLifeInsurancePremium{get;set;}
    public Decimal jointLifeInsurancePremium{get;set;}
    public Decimal singleDisabInsurancePremium{get;set;}
    public Decimal jointDisabInsurancePremium{get;set;}
    public Decimal singleIuiInsurancePremium{get;set;}
    public Decimal jointIuiInsurancePremium{get;set;}

    public Decimal singleLifeSdRounded{get;set;}
    public Decimal jointLifeSdRounded{get;set;}
    public Decimal jointDisabStampDuty{get;set;}
    public Decimal singleDisabSdRounded{get;set;}
    public Decimal singleIuiSdRounded{get;set;}
    public Decimal jointIuiSdRounded{get;set;}

    public Decimal singleLifeSdRound{get;set;}

    public Decimal singleDisabGstAmount{get;set;}
    public Decimal singleIuiGstAmount{get;set;}
    public Decimal jointDisabGstAmount{get;set;}
    public Decimal jointIuiGstAmount{get;set;}

    public RUL_InsurancePremiumCalculator() {
        singleLifeInsurancePremium = 0;
        jointLifeInsurancePremium = 0;
        singleDisabInsurancePremium = 0;
        jointDisabInsurancePremium = 0;
        singleIuiInsurancePremium = 0;
        jointIuiInsurancePremium = 0;

        singleLifeSdRounded = 0;
        jointLifeSdRounded = 0;
        jointDisabStampDuty = 0;
        singleDisabSdRounded = 0;
        singleIuiSdRounded = 0;
        jointIuiSdRounded = 0;

        singleDisabGstAmount = 0;
        singleIuiGstAmount = 0;
        jointDisabGstAmount = 0;
        jointIuiGstAmount = 0;
    }

    public Decimal calculateInsurancePremiums(RUL_InsuranceSelection rul){

        System.debug('!@#rul>>>>>>>>>> '+rul);

        try{

            String state = rul.inputState;
            System.debug('!@#state: '+state);
            if(state==null || state==''){
                ErrorHandlerException.recordException('Your application does not have a state', 'calculateInsurancePremiums()', 'RUL_InsurancePremiumCalculator', 'Class', null);
            }

            Set<String> insuranceSet = new Set<String>();
            insuranceSet.add(GEN_OriginationsConstants.INSURANCE_LIFE);
            insuranceSet.add(GEN_OriginationsConstants.INSURANCE_DISABILITY);
            insuranceSet.add(GEN_OriginationsConstants.INSURANCE_IUI);
            System.debug('!@#insuranceSet: '+insuranceSet);

            List<Fees_Charges__c> stampDuties = new List<Fees_Charges__c>();
            stampDuties = [SELECT   Stamp_Duty_Amount__c,
                                    Product_Version__r.Product_Name__c
                           FROM     Fees_Charges__c
                           WHERE    Product_Version__r.Product_Name__c IN: insuranceSet
                           AND      Fee_Type__c = 'Stamp Duty'
                           AND      State__c LIKE: state
                           AND      (Effective_Start_Date__c <=: Date.valueOf(rul.lastModDate) OR Effective_Start_Date__c = null)
                           AND      (Effective_End_Date__c >=: Date.valueOf(rul.lastModDate) OR Effective_End_Date__c = null)
                           AND      (Low_Value__c <=: rul.inputTotalLoanAmount OR Low_Value__c = null)
                           AND      (High_Value__c >=: rul.inputTotalLoanAmount OR High_Value__c = null)
                           AND      Active__c = true
                           ORDER BY Effective_Start_Date__c Desc];

            System.debug('!@#stampDuties: '+stampDuties);
            System.debug('!@#stampDuties.size(): '+stampDuties.size());

            Map<String,Decimal> stampDutyMap = new Map<String,Decimal>();
            for(Fees_Charges__c fc: stampDuties){
                stampDutyMap.put(fc.Product_Version__r.Product_Name__c, fc.Stamp_Duty_Amount__c);

            }

            if(stampDutyMap.size()>0){
                System.debug('!@#stampDutyMap: '+stampDutyMap);
            }else{
                System.debug('!@#stampDutyMap: 0');
            }

            lifeStampDuty = 0;
            disabilityStampDuty = 0;
            iuiStampDuty = 0;
            Decimal finalLoanAmount = 0;

            if(rul.lifePremiumSingle!=null){
                this.lifePremiumSingle = rul.lifePremiumSingle;
            }
            System.debug('!@#rul.lifePremiumSingle: '+lifePremiumSingle);

            if(rul.lifePremiumJoint!=null){
                this.lifePremiumJoint = rul.lifePremiumJoint;
            }            
            System.debug('!@#rul.lifePremiumJoint: '+lifePremiumJoint);

            if(rul.disabilityPremiumSingle!=null){
                this.disabilityPremiumSingle = rul.disabilityPremiumSingle;
            }            
            System.debug('!@#rul.disabilityPremiumSingle: '+disabilityPremiumSingle);

            if(rul.disabilityPremiumJoint!=null){
                this.disabilityPremiumJoint = rul.disabilityPremiumJoint;
            }
            System.debug('!@#rul.disabilityPremiumJoint: '+disabilityPremiumJoint);

            if(rul.iUIPremiumSingle!=null){
                this.iUIPremiumSingle = rul.iUIPremiumSingle;
            }
            System.debug('!@#rul.loaiUIPremiumSinglenTerm: '+iUIPremiumSingle);

            if(rul.iUIPremiumJoint!=null){
                this.iUIPremiumJoint = rul.iUIPremiumJoint;
            }
            System.debug('!@#rul.iUIPremiumJoint: '+iUIPremiumJoint);

            //covert percent to decimal
            apr = rul.inputAPR/100;
            System.debug('!@#rul.apr: '+apr);

            loanTerm = rul.inputLoanTerm;
            System.debug('!@#rul.loanTerm: '+loanTerm);

            if(loanTerm > 84 ){
                term = 84;
            }else{
                term = loanTerm;
            }
            System.debug('!@#term: '+term);

            startingPrincipalExcludingPremium = rul.inputTotalLoanAmount + rul.inputFees;
            System.debug('!@#startingPrincipalExcludingPremium: '+startingPrincipalExcludingPremium);
            System.debug('!@#rul.inputTotalLoanAmount: '+rul.inputTotalLoanAmount);
            System.debug('!@#rul.inputFees: '+rul.inputFees);      

            //LIFE
            //tables
            //InsPremRate
            lifeInsPremRate = Insurance_Premium_Calculation_Variables__c.getInstance('lifeInsPremRate').Value__c;
            System.debug('!@#lifeInsPremRate: '+lifeInsPremRate);

            //Stamp duty rate
            if(stampDutyMap.containsKey(GEN_OriginationsConstants.INSURANCE_LIFE)){
                if(stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_LIFE)!=null){
                    lifeStampDutyRate = stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_LIFE);
                }                   
            }
            System.debug('!@#lifeStampDutyRate: '+lifeStampDutyRate);

            //Joint
            lifeJoint = Insurance_Premium_Calculation_Variables__c.getInstance('lifeJoint').Value__c;
            System.debug('!@#lifeJoint: '+lifeJoint);

            //DISAB
            //tables
            //InsPremRate
            List<Fees_Charges__c> disabInsPremRateFeesChargesList = new List<Fees_Charges__c>();
            disabInsPremRateFeesChargesList = [SELECT   Disability_Plus_Premium_Rate__c
                                               FROM     Fees_Charges__c
                                               WHERE    Disability_Plus_Premium_Term__c =: term
                                               AND      Product_Version__r.Product_Name__c = 'Disability Insurance'
                                               AND      Fee_Type__c = 'Disability Plus Premium Rate'
                                               AND      (Effective_Start_Date__c <=: Date.valueOf(rul.lastModDate) OR Effective_Start_Date__c = null)
                                               AND      (Effective_End_Date__c >=: Date.valueOf(rul.lastModDate) OR Effective_End_Date__c = null)
                                               AND      (Low_Value__c <=: rul.inputTotalLoanAmount OR Low_Value__c = null)
                                               AND      (High_Value__c >=: rul.inputTotalLoanAmount OR High_Value__c = null)
                                               AND      Active__c = true
                                               ORDER BY Effective_Start_Date__c Desc LIMIT 1];                                               
            
            if(disabInsPremRateFeesChargesList.size()>0){
                disabInsPremRate = disabInsPremRateFeesChargesList[0].Disability_Plus_Premium_Rate__c;
            }
            System.debug('!@#disabInsPremRate: '+disabInsPremRate);

            //Joint
            disabJoint = Insurance_Premium_Calculation_Variables__c.getInstance('disabJoint').Value__c;
            System.debug('!@#disabJoint: '+disabJoint);

            //Fee
            disabFee = Insurance_Premium_Calculation_Variables__c.getInstance('disabFee').Value__c;
            System.debug('!@#disabFee: '+disabFee);

            //GST
            //10%
            disabGst = Insurance_Premium_Calculation_Variables__c.getInstance('disabGst').Value__c;
            System.debug('!@#disabGst: '+disabGst);

            //Stamp  duty rate
            if(stampDutyMap.containsKey(GEN_OriginationsConstants.INSURANCE_DISABILITY)){
                if(stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_DISABILITY)!=null){
                    disabStampDutyrate = stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_DISABILITY);
                }                   
            }       
            System.debug('!@#disabStampDutyrate: '+disabStampDutyrate);

            //IUI
            //tables
            //Fee
            iuiFee = Insurance_Premium_Calculation_Variables__c.getInstance('iuiFee').Value__c;
            System.debug('!@#iuiFee: '+iuiFee); 

            //GST
            //10%
            iuiGst = Insurance_Premium_Calculation_Variables__c.getInstance('iuiGst').Value__c;
            System.debug('!@#iuiGst: '+iuiGst); 

            //Stamp  duty rate
            if(stampDutyMap.containsKey(GEN_OriginationsConstants.INSURANCE_IUI)){
                if(stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_IUI)!=null){
                    iuiStampDutyRate = stampDutyMap.get(GEN_OriginationsConstants.INSURANCE_IUI);
                }                   
            } 
            System.debug('!@#iuiStampDutyRate: '+iuiStampDutyRate);           

            //public stamp duty
            lifeStampDuty = lifeStampDutyRate;
            System.debug('!@#lifeStampDuty: '+lifeStampDuty);
            
            disabilityStampDuty = disabStampDutyrate;
            System.debug('!@#disabilityStampDuty: '+disabilityStampDuty);
            
            iuiStampDuty = iuiStampDutyRate;
            System.debug('!@#iuiStampDuty: '+iuiStampDuty);
            //public stam duty
            
            //public gst
            pubDisabilityGst = disabGst;
            System.debug('!@#pubDisabilityGst: '+pubDisabilityGst);
            pubIuiGst = iuiGst;
            System.debug('!@#pubIuiGst: '+pubIuiGst);

            finalLoanAmount = calculateIteration(999999,startingPrincipalExcludingPremium,startingPrincipalExcludingPremium);
            System.debug('!@#finalLoanAmount: '+finalLoanAmount);
            
            return finalLoanAmount;
        
        }catch(Exception e){   

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'calculateInsurancePremiums()', 'RUL_InsurancePremiumCalculator', 'Class', null);
            return 0;

        }

    }

    public decimal calculateIteration(Decimal previousLoanAmount, Decimal currentLoanAmount, Decimal originalLoanAmount){

        try{

            System.debug('!@#counter: '+counter+++' previousLoanAmount='+previousLoanAmount+' currentLoanAmount='+currentLoanAmount);
            
            if(counter==counterMax){
                return currentLoanAmount-originalLoanAmount;
            }
            
            Decimal y = currentLoanAmount-previousLoanAmount;
            System.debug('!@#currentLoanAmount - previousLoanAmount: '+y);

            if(Math.abs(currentLoanAmount-previousLoanAmount) < 0.01) {

                System.debug('!@#currentLoanAmount RETURN: '+currentLoanAmount);
                return currentLoanAmount-originalLoanAmount;

            }

            Decimal newCurrentLoanAmount = 0;

            //******************************************************************************
            //newCurrentLoanAmount CALCULATION
            //******************************************************************************
            System.debug('!@#apr: '+apr);
            if(apr==0){
                return 0;
            }

            //Monthly APR
            monthlyApr = apr/12;
            System.debug('!@#Monthly APR: '+monthlyApr);

            //Credit Life Rate (monthly)
            creditLifeRateMonthly = lifeInsPremRate/12;
            System.debug('!@#Credit Life Rate (monthly): '+creditLifeRateMonthly);
            
            //n 
            n = loanTerm;
            System.debug('!@#n: '+n);

            //an^7
            //an7 = (1-(1/(1+monthlyApr)^n))/monthlyApr;
            //Math.pow(x,y)
            Decimal d = Math.exp(n*Math.log((1+monthlyApr)));
            an7 = (1-(1/d))/monthlyApr;
            System.debug('!@#an^7: '+an7);

            //Principal
            //Max Principal is $100K
            if(currentLoanAmount > maxPrincipal){
                principal = maxPrincipal;
            }else{
                principal = currentLoanAmount;
            }
            System.debug('!@#Principal: '+principal);

            //Monthly EMI
            //monthlyEmi = (principal*monthlyApr)/(1-((1+monthlyApr)^-n))*1.0018;
            //Math.pow(x,y)
            Decimal e = Math.exp(-n*Math.log((1+monthlyApr)));
            monthlyEmi = (principal*monthlyApr)/(1-(e))*1.0018;
            System.debug('!@#Monthly EMI: '+monthlyEmi);

            //Credit Life Premium
            creditLifePremium = (creditLifeRateMonthly*monthlyEmi)*((n-an7)/monthlyApr);
            System.debug('!@#Credit Life Premium: '+creditLifePremium);

            //Monthly EMI for Disability Premium Calculation
            //Max EMI for Disability calc is $750
            if(monthlyEmi > maxMonthlyEmi){
                monthlyEmiForDisabilityPremiumCalculation = maxMonthlyEmi;
            }else{
                monthlyEmiForDisabilityPremiumCalculation = monthlyEmi;
            }
            System.debug('!@#Monthly EMI for Disability Premium Calculation: '+monthlyEmiForDisabilityPremiumCalculation);


            //================//
            //===== LIFE =====//
            //================// 

            //Single CreditLifepremium
            singleCreditLifePremium = creditLifePremium;
            System.debug('!@#Single CreditLifepremium: '+singleCreditLifePremium);

            //Joint CreditLifepremium
            Decimal jointCreditLifePremiumToRound = singleCreditLifePremium*lifeJoint;
            //TAKE NOTE: Why the value on excel is rounded off
            //jointCreditLifePremium = jointCreditLifePremiumToRound.setScale(2);
            jointCreditLifePremium = jointCreditLifePremiumToRound;
            System.debug('!@#Joint CreditLifepremium: '+jointCreditLifePremium);

            //Single Life stamp duty
            singleLifeStampDuty = lifeStampDutyRate * singleCreditLifePremium;
            System.debug('!@#Single Life stamp duty: '+singleLifeStampDuty);

            //Joint Life stamp duty
            jointLifeStampDuty = lifeStampDutyRate * jointCreditLifePremium;
            System.debug('!@#Joint Life stamp duty: '+jointLifeStampDuty);

            //Single Life SD Rounded
            //round to the nearest cent
            singleLifeSdRounded = singleLifeStampDuty.setScale(2);
            System.debug('!@#Single Life SD Rounded: '+singleLifeSdRounded);

            //Joint Life SD Rounded
            //round to the nearest cent
            jointLifeSdRounded = jointLifeStampDuty.setScale(2);
            System.debug('!@#Joint Life SD Rounded: '+jointLifeSdRounded);


            //Single Life total
            singleLifeTotal = singleCreditLifePremium + singleLifeStampDuty;
            System.debug('!@#Single Life total: '+singleLifeTotal);

            //Joint Life total
            jointLifeTotal = jointCreditLifePremium + jointLifeStampDuty;
            System.debug('!@#Joint Life total: '+jointLifeTotal);

            //******************************************************************************
            //LIFE FINAL COMPUTATION
            //******************************************************************************
            System.debug('******************LIFE FINAL COMPUTATION');
            //Single Gross Life Rounded
            singleGrossLifeRounded = singleLifeTotal.setScale(2);
            singleLifeInsurancePremium = singleLifeTotal.setScale(2);
            System.debug('!@#counter: '+counter+' : !@#Single Gross Life Rounded: '+singleGrossLifeRounded);


            //Joint Gross Life Rounded
            jointGrossLifeRounded   = jointLifeTotal.setScale(2);
            jointLifeInsurancePremium = jointLifeTotal.setScale(2);
            System.debug('!@#counter: '+counter+' : !@#Joint Gross Life Rounded: '+jointGrossLifeRounded);
            System.debug('******************LIFE FINAL COMPUTATION');
            //******************************************************************************

            //Single Net Life Premium
            singleNetLifePremium = singleGrossLifeRounded-singleLifeSdRounded;
            System.debug('!@#Single Net Life Premium: '+singleNetLifePremium);

            //Joint Net Life Premium
            jointNetLifePremium = jointGrossLifeRounded-jointLifeSdRounded;
            System.debug('!@#Joint Net Life Premium: '+jointNetLifePremium);

            //=================//
            //===== DISAB =====//
            //=================//

            //Single DISAB
            singleDisab = disabInsPremRate*monthlyEmiForDisabilityPremiumCalculation*n/100;
            System.debug('!@#Single DISAB: '+singleDisab);

            //Joint DISAB
            jointDisab = disabInsPremRate*monthlyEmiForDisabilityPremiumCalculation*n*disabJoint/100;
            System.debug('!@#Joint DISAB: '+jointDisab);

            //Single Disab prem
            singleDisabPrem = singleDisab+disabFee;
            System.debug('!@#Single Disab prem: '+singleDisabPrem);

            //Joint Disab prem
            jointDisabPrem = jointDisab+disabFee;
            System.debug('!@#Joint Disab prem: '+jointDisabPrem);

            //Single Disab GST
            singleDisabGst = disabGst*singleDisabPrem;
            System.debug('!@#Single Disab GST: '+singleDisabGst);

            //Joint Disab GST
            jointDisabGst = disabGst*jointDisabPrem;
            System.debug('!@#Joint Disab GST: '+jointDisabGst);

            //Single Disab GST Rounded
            singleDisabGSTRounded = singleDisabGst.setScale(2);
            System.debug('!@#Single Disab GST Rounded: '+singleDisabGSTRounded);
            singleDisabGstAmount = singleDisabGSTRounded;

            //Joint Disab GST Rounded
            jointDisabGSTRounded = jointDisabGst.setScale(2);
            System.debug('!@#Joint Disab GST Rounded: '+jointDisabGSTRounded);
            jointDisabGstAmount = jointDisabGSTRounded;

            //Single Disab Stamp duty
            singleDisabStampDuty = disabStampDutyrate*(singleDisabPrem+singleDisabGst);
            System.debug('!@#Single Disab Stamp duty: '+singleDisabStampDuty);

            //Joint Disab Stamp duty
            jointDisabStampDuty = disabStampDutyrate*(jointDisabPrem+jointDisabGst);
            System.debug('!@#Joint Disab Stamp duty: '+jointDisabStampDuty);

            //Single Disab SD Rounded
            singleDisabSdRounded = singleDisabStampDuty.setScale(2);
            System.debug('!@#Single Disab SD Rounded: '+singleDisabSdRounded);

            //Joint Disab SD Rounded
            jointDisabSdRounded = jointDisabStampDuty.setScale(2);
            System.debug('!@#Joint Disab SD Rounded: '+jointDisabSdRounded);

            //Single Disab Total
            singleDisabTotal = singleDisabPrem+singleDisabGst+singleDisabStampDuty;
            System.debug('!@#Single Disab Total: '+singleDisabTotal);

            //Joint Disab Total
            jointDisabTotal = jointDisabPrem+jointDisabGst+jointDisabStampDuty;
            System.debug('!@#Joint Disab Total: '+jointDisabTotal);

            //******************************************************************************
            //DISAB FINAL COMPUTATION
            //******************************************************************************
            System.debug('******************DISAB FINAL COMPUTATION');
            //Single Gross Disab Rounded
            singleGrossDisabRounded = singleDisabTotal.setScale(2);
            singleDisabInsurancePremium = singleDisabTotal.setScale(2);
            System.debug('!@#counter: '+counter+' : !@#Single Gross Disab Rounded: '+singleGrossDisabRounded);

            //Joint Gross Disab Rounded
            jointGrossDisabRounded = jointDisabTotal.setScale(2);
            jointDisabInsurancePremium = jointDisabTotal.setScale(2);
            System.debug('!@#counter: '+counter+' : !@#Joint Gross Disab Rounded: '+jointGrossDisabRounded);
            System.debug('******************DISAB FINAL COMPUTATION');
            //******************************************************************************

            //Single Net Disab Premium
            singleNetDisabPremium = singleGrossDisabRounded-singleDisabSdRounded-singleDisabGSTRounded;
            System.debug('!@#Single Net Disab Premium: '+singleNetDisabPremium);

            //Joint Net Disab Premium
            jointNetDisabPremium = jointGrossDisabRounded-jointDisabSdRounded-jointDisabGSTRounded;
            System.debug('!@#Joint Net Disab Premium: '+jointNetDisabPremium);

            //===============//
            //===== IUI =====//
            //===============//

             //TAKE NOTE: This is dependent on Single Disab prem
             //Single  IUI prem 
             singleIuiPrem = 0.4*singleDisabPrem+iuiFee;
             System.debug('!@#Single IuiPrem: '+singleIuiPrem);

             //TAKE NOTE: This is dependent on Joint Disab prem
             //Joint  IUI prem 
             jointIuiPrem = 0.4*jointDisabPrem+iuiFee;
             System.debug('!@#Joint IuiPrem: '+jointIuiPrem);

             //Single IUI unpackaged/classes/GEPlayPage2Controller_SFDCTest
             singleIuiGst = iuiGst*singleIuiPrem;
             System.debug('!@#Single IUI GST: '+singleIuiGst);

             //Joint IUI GST
             jointIuiGst = iuiGst*jointIuiPrem;
             System.debug('!@#Joint IUI GST: '+jointIuiGst);

             //Single IUI GST Rounded
             singleIuiGstRounded = singleIuiGst.setScale(2);
             System.debug('!@#Single IUI GST Rounded: '+singleIuiGstRounded);
             singleIuiGstAmount = singleIuiGstRounded;

             //Joint IUI GST Rounded
             jointIuiGstRounded = jointIuiGst.setScale(2);
             System.debug('!@#Joint IUI GST Rounded: '+jointIuiGstRounded);
             jointIuiGstAmount = jointIuiGstRounded;

             //Single IUI Stamp duty
             singleIuiStampDuty = iuiStampDutyRate*(singleIuiPrem+singleIuiGst);
             System.debug('!@#Single IUI Stamp duty: '+singleIuiStampDuty);

             //Joint IUI Stamp duty
             jointIuiStampDuty = iuiStampDutyRate*(jointIuiPrem+jointIuiGst);
             System.debug('!@#Joint IUI Stamp duty: '+jointIuiStampDuty);

             //Single IUI SD Rounded
             singleIuiSdRounded = singleIuiStampDuty.setScale(2);
             System.debug('!@#Single IUI SD Rounded: '+singleIuiSdRounded);

             //Joint IUI SD Rounded
             jointIuiSdRounded = jointIuiStampDuty.setScale(2);
             System.debug('!@#Joint IUI SD Rounded: '+jointIuiSdRounded);

             //Single IUI total
             singleIuiTotal = singleIuiPrem+singleIuiGst+singleIuiStampDuty;
             System.debug('!@#Single IUI total: '+singleIuiTotal);

             //Joint IUI total
             joinrIuiTotal = jointIuiPrem+jointIuiGst+jointIuiStampDuty;
             System.debug('!@#Single IUI total: '+joinrIuiTotal);


             //******************************************************************************
             //IUI FINAL COMPUTATION
             //******************************************************************************
             System.debug('******************IUI FINAL COMPUTATION');
             //Single Gross IUI Rounded
             singleGrossIuiRounded = singleIuiTotal.setScale(2);
             singleIuiInsurancePremium = singleIuiTotal.setScale(2);
             System.debug('!@#counter: '+counter+' : !@#Single Gross IUI Rounded: '+singleGrossIuiRounded);

             //Joint Gross IUI Rounded
             jointGrossIuiRounded = joinrIuiTotal.setScale(2);
             jointIuiInsurancePremium = joinrIuiTotal.setScale(2);
             System.debug('!@#counter: '+counter+' : !@#Joint Gross IUI Rounded: '+jointGrossIuiRounded);
             System.debug('******************IUI FINAL COMPUTATION');
             //******************************************************************************

             //Single Net IUI Premium
             singleNetIuiPremium = singleGrossIuiRounded-singleIuiSdRounded-singleIuiGstRounded;
             System.debug('!@#Single Net IUI Premium: '+singleNetIuiPremium);

             //Joint Net IUI Premium
             jointNetIuiPremium = jointGrossIuiRounded-jointIuiSdRounded-jointIuiGstRounded;
             System.debug('!@#Joint Net IUI Premium: '+jointNetIuiPremium);

             if(!lifePremiumSingle){
                singleGrossLifeRounded = 0;
             }
             if(!lifePremiumJoint){
                jointGrossLifeRounded = 0;
             }else{
                singleGrossLifeRounded = 0;
             }
             if(!disabilityPremiumSingle){
                singleGrossDisabRounded = 0;
             }  
             if(!disabilityPremiumJoint){
                jointGrossDisabRounded = 0;
             }else{
                singleGrossDisabRounded = 0;
             }
             if(!iUIPremiumSingle){
                singleGrossIuiRounded = 0;
             }
             if(!iUIPremiumJoint){
                jointGrossIuiRounded = 0;
             }else{
                singleGrossIuiRounded = 0;
             }
             //loan ammount + premiums
             System.debug('!@# lifePremiumSingle='+lifePremiumSingle + ' disabilityPremiumSingle='+disabilityPremiumSingle+' iUIPremiumSingle='+iUIPremiumSingle);
             System.debug('!@# lifePremiumJoint='+lifePremiumJoint + ' disabilityPremiumJoint='+disabilityPremiumJoint+' iUIPremiumJoint='+iUIPremiumJoint);
             System.debug('!@# singleGrossLifeRounded='+singleGrossLifeRounded + ' singleGrossDisabRounded='+singleGrossDisabRounded+' singleGrossIuiRounded='+singleGrossIuiRounded+' currentLoanAmount='+currentLoanAmount + ' newCurrentLoanAmount='+newCurrentLoanAmount);
             System.debug('!@# jointGrossLifeRounded='+jointGrossLifeRounded + ' jointGrossDisabRounded='+jointGrossDisabRounded+' jointGrossIuiRounded='+jointGrossIuiRounded+' currentLoanAmount='+currentLoanAmount + ' newCurrentLoanAmount='+newCurrentLoanAmount);
             newCurrentLoanAmount = singleGrossLifeRounded+singleGrossDisabRounded+singleGrossIuiRounded+jointGrossLifeRounded+jointGrossDisabRounded+jointGrossIuiRounded+originalLoanAmount;     

             return calculateIteration(currentLoanAmount, newCurrentLoanAmount, originalLoanAmount);

         }catch(Exception e){       

            //exception log
            System.debug('!@#EXCEPTION: '+e.getMessage() + ':' + e.getStackTraceString());
            ErrorHandlerException.recordException(e.getMessage() + ':' + e.getStackTraceString(), 'calculateIteration()', 'RUL_InsurancePremiumCalculator', 'Class', null);
            return 0;

        }
    }

    /*  Description: Method that computes for individual premiums.
     *  Author: Fel Saliba
     *  Date Created: 11-28-13
     *  Input Parameters: application Object, Premium Type 
     *  Return: Decimal
     */
    public Decimal getIndividualPremium(Application__c application,Boolean isLifeSingle,Boolean isDisabilitySingle, Boolean isIUISingle,Boolean isLifeJoint,Boolean isDisabilityJoint,Boolean isIUIJoint){
        
        //RUL_InsurancePremiumCalculator.
        RUL_InsuranceSelection ruleSelection = new RUL_InsuranceSelection();  
        
        if(isLifeSingle){
            ruleSelection.lifePremiumSingle = true;
        }
        else{
            ruleSelection.lifePremiumSingle = false;
        }
        
        if(isLifeJoint){
            ruleSelection.lifePremiumJoint = true;
        }
        else{
            ruleSelection.lifePremiumJoint = false;
        }
        
        if(isDisabilitySingle){
            ruleSelection.disabilityPremiumSingle = true;
        }
        else{
            ruleSelection.disabilityPremiumSingle = false;
        }
        
        if(isDisabilityJoint){
            ruleSelection.disabilityPremiumJoint = true;
        }
        else{
            ruleSelection.disabilityPremiumJoint = false;
        }
        
        if(isIUISingle){
            ruleSelection.iUIPremiumSingle = true;
        }
        else{
            ruleSelection.iUIPremiumSingle = false;
        }
        
        if(isIUIJoint){
            ruleSelection.iUIPremiumJoint = true;
        }
        else{
            ruleSelection.iUIPremiumJoint = false;
        }

        ruleSelection.lastModDate = application.LastModifiedDate;
        
        ruleSelection.inputTotalLoanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
        
        Decimal establishmentFee = application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        Decimal SearchFee = application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        Decimal RegistrationFee = application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        ruleSelection.inputFees =   establishmentFee + SearchFee + RegistrationFee + brokerFee;
        
        ruleSelection.inputLoanTerm = application.Loan_Term_Months__c != null ? application.Loan_Term_Months__c : 0;
        
        Decimal repayments = application.Offered_Repayments__c != null ? application.Offered_Repayments__c : 0;
        Decimal monthlyServiceFee = application.Offered_Monthly_Loan_Service_Fee__c != null ? application.Offered_Monthly_Loan_Service_Fee__c : 0;
        ruleSelection.inputEMI =  repayments; //- monthlyServiceFee;
        
        ruleSelection.inputAPR = application.Offered_Interest_Rate__c != null ? application.Offered_Interest_Rate__c : 0;        
        
        //hardcoded for now
        ruleSelection.inputState = application.State__c;
        
        System.debug('@@@@@@@ruleSelection-->'+ruleSelection);
        //RUL_InsurancePremiumCalculator rul = new RUL_InsurancePremiumCalculator();

        Decimal premium = -1;
        try {
            System.debug('ruleSelection>>>>>>>>>> '+ruleSelection);
            premium = calculateInsurancePremiums(ruleSelection);
        } catch (Exception e) {
            System.debug('**EXCEPTION: '+e.getStackTraceString()+': '+e.getMessage());
            ErrorHandlerException.recordException(e.getStackTraceString()+': '+e.getMessage(), 'getPremium', 'AppResponseTriggerHandler', 'Class', String.valueOf(application.Id));
        }
    
        return premium;
    
    }

    /*  Description: Method that computes Total Amount Insurance Payable
     *  Author: Jade Serrano
     *  Date Created: 22-Jan-2014
     *  Input Parameters: Application  
     *  Return: Decimal
     */
     public Decimal computeTotalAmountInsurancePayable(Application__c app){

        Decimal insApr = 0;
        Decimal insLoanTerm = 0;
        Decimal insMonthlyApr = 0;
        Decimal insPrincipal = 0;
        Decimal insFee = 0;
        Decimal fee1 = 0;
        Decimal fee2 = 0;
        Decimal fee3 = 0;
        Decimal fee4 = 0;
        Decimal insInsurance = 0;

        if(app.Offered_Interest_Rate__c!=null){
            //apr
            insApr = app.Offered_Interest_Rate__c;
            //monthly apr
            insMonthlyApr = (app.Offered_Interest_Rate__c/12)/100;
        }
        if(app.Loan_Term_Months__c!=null){
            //loan term
            insLoanTerm = app.Loan_Term_Months__c;
        }
        if(app.Total_Loan_Amount__c!=null){
            //total loan amount
            insPrincipal = app.Total_Loan_Amount__c;
        }
        if(app.Offered_Establishment_Fee__c!=null){
            fee1 = app.Offered_Establishment_Fee__c;
        }
        if(app.Offered_PPSR_Search_Fee__c!=null){
            fee2 = app.Offered_PPSR_Search_Fee__c;
        }
        if(app.Offered_PPSR_Registration_Fee__c!=null){
            fee3 = app.Offered_PPSR_Registration_Fee__c;
        }
        if(app.Brokerage_Fee__c != null){
            fee4 = app.Brokerage_Fee__c;
        }
        insFee = fee1+fee2+fee3+fee4;
        if(app.Total_Insurance_Premium__c!=null){
            //insurance premium
            insInsurance = app.Total_Insurance_Premium__c;
        }

        System.debug('$%^insApr: '+insApr);
        System.debug('$%^insLoanTerm: '+insLoanTerm);
        System.debug('$%^insMonthlyApr: '+insMonthlyApr);
        System.debug('$%^insPrincipal: '+insPrincipal);
        System.debug('$%^insFee: '+insFee);
        System.debug('$%^fee1: '+fee1);
        System.debug('$%^fee2: '+fee2);
        System.debug('$%^insInsurance: '+insInsurance);

        //compute total insurance amount payable
        
        if(insMonthlyApr != 0 && insLoanTerm !=0){

            Decimal e = Math.exp(-insLoanTerm*Math.log((1+insMonthlyApr)));
            Decimal incrementalRepayment = (insInsurance*insMonthlyApr)/(1-(e))*1.0018;
            Decimal incrementalRepaymentRounded = incrementalRepayment.setScale(2);
    
            Decimal totalInsuranceAmountPayable = incrementalRepaymentRounded*insLoanTerm-insInsurance;
            Decimal totalInsuranceAmountPayableRounded = totalInsuranceAmountPayable.setScale(2);
    
            System.debug('$%^totalInsuranceAmountPayableRounded: '+totalInsuranceAmountPayableRounded);
    
            return totalInsuranceAmountPayableRounded;

        }else{
            return 0;
        }

     }

     /*  Description: Method that computes Total Interest Amount Payable
     *  Author: Jade Serrano
     *  Date Created: 22-Jan-2014
     *  Input Parameters: Application  
     *  Return: Decimal
     */
     public Decimal computeTotalInterestAmountPayable(Application__c app){

        Decimal intApr = 0;
        Decimal intLoanTerm = 0;
        Decimal intMonthlyApr = 0;
        Decimal intPrincipal = 0;
        Decimal intFee = 0;
        Decimal fee1 = 0;
        Decimal fee2 = 0;
        Decimal fee3 = 0;
        Decimal fee4 = 0;
        Decimal intInsurance = 0;

        if(app.Offered_Interest_Rate__c!=null){
            //apr
            intApr = app.Offered_Interest_Rate__c;
            //monthly apr
            intMonthlyApr = (app.Offered_Interest_Rate__c/12)/100;
        }
        if(app.Loan_Term_Months__c!=null){
            //loan term
            intLoanTerm = app.Loan_Term_Months__c;
        }
        if(app.Total_Loan_Amount__c!=null){
            //total loan amount
            intPrincipal = app.Total_Loan_Amount__c;
        }
        if(app.Offered_Establishment_Fee__c!=null){
            fee1 = app.Offered_Establishment_Fee__c;
        }
        if(app.Offered_PPSR_Search_Fee__c!=null){
            fee2 = app.Offered_PPSR_Search_Fee__c;
        }
        if(app.Offered_PPSR_Registration_Fee__c!=null){
            fee3 = app.Offered_PPSR_Registration_Fee__c;
        }
        if(app.Brokerage_Fee__c != null){
            fee4 = app.Brokerage_Fee__c;
        }
        intFee = fee1+fee2+fee3+fee4;
        if(app.Total_Insurance_Premium__c!=null){
            //insurance premium
            intInsurance = app.Total_Insurance_Premium__c;
        }

        System.debug('$%^intApr: '+intApr);
        System.debug('$%^intLoanTerm: '+intLoanTerm);
        System.debug('$%^intMonthlyApr: '+intMonthlyApr);
        System.debug('$%^intPrincipal: '+intPrincipal);
        System.debug('$%^intFee: '+intFee);
        System.debug('$%^fee1: '+fee1);
        System.debug('$%^fee2: '+fee2);
        System.debug('$%^intInsurance: '+intInsurance);

        //compute total interest amount payable
        Decimal totalCredit = intPrincipal + intFee + intInsurance;

        System.debug('$%^totalCredit: '+totalCredit);
        
        if(intMonthlyApr != 0 && intLoanTerm !=0){
            Decimal f = Math.exp(-intLoanTerm*Math.log((1+intMonthlyApr)));
            Decimal totalCreditRepayment = (totalCredit*intMonthlyApr)/(1-(f))*1.0018;
            Decimal totalCreditRepaymentRounded = totalCreditRepayment.setScale(2);
            System.debug('$%^totalCreditRepaymentRounded: '+totalCreditRepaymentRounded);
            
            Decimal totalInterestAmountPayable = (totalCreditRepaymentRounded*intLoanTerm)-totalCredit;
            System.debug('$%^totalInterestAmountPayable: '+totalInterestAmountPayable);
            
            Decimal totalInsuranceAmountPayableRounded = computeTotalAmountInsurancePayable(app);
            System.debug('$$$: '+totalInsuranceAmountPayableRounded);
            
            Decimal totalInterestAmountPayableFinal = totalInterestAmountPayable - totalInsuranceAmountPayableRounded ;
            return totalInterestAmountPayableFinal;
        }else{            
            return 0;

        }

     }
    
    
    public class RUL_InsuranceSelection{

        public Boolean lifePremiumSingle;
        public Boolean lifePremiumJoint;
        public Boolean disabilityPremiumSingle;
        public Boolean disabilityPremiumJoint;
        public Boolean iUIPremiumSingle;
        public Boolean iUIPremiumJoint;
        
        public Decimal inputTotalLoanAmount;        
        public Decimal inputFees;
        public Decimal inputLoanTerm;
        public Decimal inputEMI;
        public Decimal inputAPR;
        public Decimal insurancePremium;

        public String inputState;
        public Datetime lastModDate;

        public RUL_InsuranceSelection(){

            inputFees = 0;
            inputLoanTerm = 0;
            inputEMI = 0;
            inputAPR = 0;
            insurancePremium = 0;

        }

    }

}