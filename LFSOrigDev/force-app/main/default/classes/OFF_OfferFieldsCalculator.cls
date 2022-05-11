/**
 * @Description: Class for Computing Offer Fields in Application.
 * @Author: Fel Saliba
 * @Date Created: DECEMBER-19-2013
 * @History:
   =====================================================================
        OCT-24 (Fel): Created.
        23/04/2015 : Keerthan Defect Fix : 1017
   =====================================================================
 */ 
public class OFF_OfferFieldsCalculator{    
    
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    public List<Product_Item__c> prodItems;
    
      
    //===============================================================
    //                       CONSTRUCTORS
    //===============================================================

    /*  Description: Constructor used for all initializations
     *  Author: Fel Saliba
     *  Date Created: NOV-19-2013
     *  Input: None
     *  Return: void
     */
    public OFF_OfferFieldsCalculator(){
         prodItems = new List<Product_Item__c>();
    }
    
    /*  Description: Method to get List of Product Items.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public void getProdutctItems(Application__c application){
        String query = 'SELECT ';
        String appId = application.Id;
        for(Schema.FieldSetMember f : SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Product_Version__r.GEProduct__c, Product_Version__r.Type__c, Product_Version__r.GEProduct__r.Insurance_Type__c FROM Product_Item__c where Application__c =: appId and Product_Version__c != null';
        prodItems =  Database.query(query);
    }
    
    /*  Description: Method to get List of Product Items by set.
     *  Author: Russell Cadapan
     *  Input: None
     *  Return: void
     */
    public void getProdutctItemsBySet(Set<String> appIds){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Product_Item__c.FieldSets.Product_Item_Commons.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Product_Version__r.GEProduct__c, Product_Version__r.Type__c, Product_Version__r.GEProduct__r.Insurance_Type__c FROM Product_Item__c where Application__c IN: appIds and Product_Version__c != null';
        prodItems =  Database.query(query);
    }

    /*  Description: Method to get application interest rate from matrix.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getInterestRate(Application__c application){
        
        Decimal totalLoanAmount = application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
        Decimal totalRefinance = application.Total_Loan_Amount_Refinance__c != null ? application.Total_Loan_Amount_Refinance__c : 0;
        Decimal capacity = 0;                       
        capacity = totalLoanAmount - totalRefinance;
        //capacity += application.Total_Insurance_Premium__c != null ? application.Total_Insurance_Premium__c : 0;
        //capacity += application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        //capacity += application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        //capacity += application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        //capacity += application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
       
        List<Rate__c> maxCapacityRateList = new List<Rate__c>();
        if(prodItems!=null) {
            if(!prodItems.isEmpty()){
                String prodVersion = '';
                for(Product_Item__c p:prodItems){
                    if(p.Product_Version__r.Type__c == GEN_OriginationsConstants.PRODUCT_TYPE || p.Product_Version__r.Type__c == GEN_OriginationsConstants.PRODUCT_TYPE_AUTO_LOAN){
                        prodVersion = p.product_version__c;
                    }
                }
                maxCapacityRateList = [SELECT id, rate__c, rate_card__c
                                FROM Rate__c
                                WHERE rate_card__r.product_version__C =: prodVersion 
                                AND  credit_score__c =: application.credit_score__c
                                AND  Principal_Maximum__c >=: capacity
                                AND Principal_Minimum__c <=: capacity
                                AND rate_card__r.Start_Date__c <=: application.LastModifiedDate
                                AND rate_card__r.End_Date__c >=: application.LastModifiedDate                            
                                AND rate_card__r.Channel__c INCLUDES (:application.Channel__c)
                                ];
            }
        }
                        
        Decimal rate = 0;  
        System.debug('maxCapacityRateList-->'+maxCapacityRateList);      
        if(!maxCapacityRateList.isEmpty()){
            rate = maxCapacityRateList[0].rate__c;
        }       
        return rate;    
    }
    
    /*  Description: Method to get the correct Interest rate based on Rate Reduction Conditions without Application Response.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getOfferedInterestRateWithoutAppResponse(Application__c application){
        
        Decimal offeredRate = 0;
        if(application.Offered_Interest_Rate_Orig__c == null){
                offeredRate = getInterestRate(application);
                System.debug('1,offeredRate-->'+offeredRate);
        }
        else{            
            IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
            applicationDTO.app = application;
            
            RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();
            offeredRate = rateReduction.rateReductionWithoutAppResponse(applicationDTO);
            System.debug('2,offeredRate-->'+offeredRate);
        }
        
        return offeredRate;    
    }
    
    /*  Description: Method to get the correct Interest rate based on Rate Reduction Conditions with Application Response.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getOfferedInterestRateWithAppResponse(Application__c application){
        
        Decimal offeredRate = 0;
        if(application.Offered_Interest_Rate_Orig__c == null){
                offeredRate = getInterestRate(application);
                System.debug('1,offeredRate-->'+offeredRate);
        }
        else{
        
            if(application.Adjusted_Interest_Rate__c == null){
                offeredRate = getInterestRate(application);
                System.debug('2,offeredRate-->'+offeredRate);
            }
            else{              
                IS_ApplicationDTO applicationDTO = new IS_ApplicationDTO();
                applicationDTO.app = application;
                
                RUL_Rate_Reduction rateReduction = new RUL_Rate_Reduction();
                offeredRate = rateReduction.rateReductionWithAppResponse(applicationDTO);
                System.debug('3,offeredRate-->'+offeredRate);
            }
        }
        
        return offeredRate;    
    }
    
    /*  Description: Method to get input Fees.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Decimal getInputFees(Application__c application){
        
        Decimal inputFees = 0;
        
        Decimal establishmentFee = application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        Decimal SearchFee = application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        Decimal RegistrationFee = application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        Decimal brokerFee = application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        inputFees =   establishmentFee + SearchFee + RegistrationFee + brokerFee; 
        
        return inputFees;  
    }
    
    /*  Description: Method to get inputEMI.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: void
     */
    public Decimal getRepaymentEMI(Application__c application){
        
        Decimal overallTotal = 0;
        overallTotal += application.Total_Loan_Amount__c != null ? application.Total_Loan_Amount__c : 0;
        overallTotal += application.Total_Insurance_Premium__c != null ? application.Total_Insurance_Premium__c : 0;
        overallTotal += application.Offered_Establishment_Fee__c != null ? application.Offered_Establishment_Fee__c : 0;
        overallTotal += application.Offered_PPSR_Search_Fee__c != null ? application.Offered_PPSR_Search_Fee__c : 0;
        overallTotal += application.Offered_PPSR_Registration_Fee__c != null ? application.Offered_PPSR_Registration_Fee__c : 0;
        overallTotal += application.Brokerage_Fee__c != null ? application.Brokerage_Fee__c : 0;
        
        Decimal rate = application.Offered_Interest_Rate__c != null ? ((application.Offered_Interest_Rate__c.setScale(2)/12)/100) : 0;
        Decimal loanTerm = application.Loan_Term_Months__c != null ? application.Loan_Term_Months__c : 0;
        System.debug('rate-->'+rate);
        System.debug('overallTotal-->'+overallTotal);
        System.debug('application.Loan_Term_Months__c-->'+application.Loan_Term_Months__c);        
        
        Decimal inputEMI = 0;
        
        if(rate == 0 || rate == null){
            return inputEMI;
        }
        else{           
            Decimal e = Math.exp((-loanTerm)*Math.log((1+rate)));
            system.debug('!@e: '+e);
            inputEMI = ((overallTotal*rate)/(1-(e))*1.0018).setScale(2);
            system.debug('!@#Monthly EMI: '+inputEMI);
            
            return inputEMI;  
        }
    }
    
    /*  Description: Method to get Repayment with Service Fee.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getRepaymentWithServiceFee(Application__c application){
        
        Decimal repayment = 0;
        repayment  =  getRepaymentEMI(application) + (application.Offered_Monthly_Loan_Service_Fee__c != null ? application.Offered_Monthly_Loan_Service_Fee__c : 0); 
        return repayment;  
    }
    
    /*  Description: Method to get Frequncy Repayment without Service Fee.
     *  Author: Fel Saliba
     *  Input: None
     *  Return: Decimal
     */
    public Decimal getFrequencyRepayment(Application__c application){
        
        Decimal frqcyRepayment = 0;
        if(application.Payment_Frequency__c == 'Weekly'){
           frqcyRepayment = (application.Offered_Repayments__c/4);
        }
        else if(application.Payment_Frequency__c == 'Fortnightly'){
           frqcyRepayment = (application.Offered_Repayments__c/2);
        }
        else{
           frqcyRepayment = application.Offered_Repayments__c;
        }     
        return frqcyRepayment;  
    }
    
     /*  Description: Method to get fee value based on  type.
     *  Author: Fel Saliba
     *  Parameter: String type
     *  Return: Decimal
     */
    public Decimal getFee(Application__c application, String type){
        
        System.debug('***Application.Total_Loan_Amount__c:'+Application.Total_Loan_Amount__c);
        System.debug('***application.LastModifiedDate:'+application.LastModifiedDate);
        System.debug('*Application Type*' + application.Promotional_Campaign__c);
        Decimal totalFee = 0;
        if(!(application.Promotional_Campaign__c == GEN_OriginationsConstants.BUSINESS_SOURCE_60_DAY_CERTIFICATE && type == GEN_OriginationsConstants.FEE_ESTABLISHMENT)){
            Set<String> productVersionSet = new Set<String>();
            system.debug('......>> ' + prodItems);
            if(prodItems != NULL && !prodItems.isEmpty()){
                for(Product_Item__c pI:prodItems)
                    if(pI.product_version__c != null){
                        productVersionSet.add(pI.product_version__c);
                    }
            }
            system.debug('productVersionSet ' + productVersionSet);
            /***Keerthan Defect : 1017 ***/
           List<Fees_Charges__c> feeList = [SELECT id, fee_Amount__c, Product_Version__c
                    FROM Fees_Charges__c
                    WHERE Product_Version__c IN: productVersionSet
                    AND  Active__c =: true
                    AND Fee_Type__c = : type
                    AND (Effective_Start_Date__c <=: Date.valueOf(application.LastModifiedDate))
                    AND (Effective_End_Date__c >=: Date.valueOf(application.LastModifiedDate))
                    AND (Low_Value__c <=: application.Total_Loan_Amount__c OR Low_Value__c = null)
                    AND (High_Value__c >=: application.Total_Loan_Amount__c OR High_Value__c = null)
                    AND Brand__c =: application.Brand_String__c
                    AND Active__c = true
                    ];
              /***Keerthan Defect : 1017 ***/      
           System.debug('feeList-->'+feeList);
           
           
           if(!feeList.isEmpty()){
               for(Fees_Charges__c fee:feeList){
                   totalFee += fee.Fee_Amount__c != null ?  fee.Fee_Amount__c : 0;
               }
               if(type == GEN_OriginationsConstants.PPSR_REGISTRATION_FEE || type == GEN_OriginationsConstants.PPSR_SEARCH_FEE){
                   
                   Integer numberOfCollaterals = [SELECT COUNT()FROM Collateral__c WHERE Application__c =: application.Id];
                   totalFee = totalFee * numberOfCollaterals;          
               }                      
           }
        }
       
       return totalFee;
    }    

    /*  Description: Method to get application interest (Refinance) rate from matrix.
     *  Author: Mat Isidro
     *  Input:  Application__c application, Decimal dCapacity
     *  Return: Decimal rate
     */
    public Decimal getRefinanceInterestRate(Application__c application, Decimal dCapacity){
     
        List<Rate__c> maxCapacityRateList = new List<Rate__c>();
        if(!prodItems.isEmpty()){
            String prodVersion = '';
            for(Product_Item__c p:prodItems){
                if(p.Product_Version__r.Type__c == GEN_OriginationsConstants.PRODUCT_TYPE){
                    prodVersion = p.product_version__c;
                }
            }
            maxCapacityRateList = [SELECT id, rate__c, rate_card__c
                            FROM Rate__c
                            WHERE rate_card__r.product_version__C =: prodVersion 
                            AND  credit_score__c =: application.credit_score__c
                            AND  Principal_Maximum__c >=: dCapacity
                            AND Principal_Minimum__c <=: dCapacity
                            AND rate_card__r.Start_Date__c <=: application.LastModifiedDate
                            AND rate_card__r.End_Date__c >=: application.LastModifiedDate                            
                            AND rate_card__r.Channel__c INCLUDES (:application.Channel__c)
                            ];
        }
                        
        Decimal rate = 0;  
        System.debug('maxCapacityRateList-->'+maxCapacityRateList);      
        if(!maxCapacityRateList.isEmpty()){
            rate = maxCapacityRateList[0].rate__c;
        }       
        return rate;    
    } 

    /*  Description: Method to get Refinance Disbursement records under an application.
     *  Author: Mat Isidro
     *  Input:  Application application
     *  Return: List<Disbursement__c> disbursementList
     */
    public List<Disbursement__c> getRefinanceDisbursementRecords(Application__c application){
         
        List<Disbursement__c> disbursementList = [SELECT Id, Application__c, Net_Payoff_Due__c, Interest_Rate__c from Disbursement__c where Record_Type_Name__c = 'Re-Finance' and Application__c =: application.Id];
        return disbursementList;
    } 


    /*  Description: Method to get blended rate.
     *  Author: Mat Isidro
     *  Input:  Application application, Decimal dOriginalRate
     *  Return: Decimal (dOriginalRate OR new rate)
     */
    public Decimal getBlendedRate(Application__c application, Decimal dOriginalRate) {
        System.debug('SYSDBG - Total_Loan_Amount_New_Cash__c:' + application.Total_Loan_Amount_New_Cash__c);
        System.debug('SYSDBG - dOriginalRate:' + dOriginalRate);
        //Decimal dSubAmountA = application.Total_Loan_Amount_New_Cash__c; 
        //Decimal dSubAmountD = application.Total_Loan_Amount_New_Cash__c * dOriginalRate; 
        Decimal dSubAmountA = 0;
        for(Loan_Purpose__c lp : [SELECT Application__c ,Loan_Amount__c
                                  FROM Loan_Purpose__c
                                  WHERE Application__c =: application.Id AND Value__c !=: GEN_OriginationsConstants.META_ONR_VALUE_REFINANCE]){ 
                                  
                             dSubAmountA += lp.Loan_Amount__c;             
        }
        Decimal dSubAmountD = dSubAmountA * dOriginalRate;
                               
        System.debug('SYSDBG - INITIAL: dSubAmountD :' + dSubAmountD);

        List<Disbursement__c> disbursementList = getRefinanceDisbursementRecords(application);
        if (!disbursementList.isEmpty()) {
            for (Disbursement__c disbursement : disbursementList) {
                System.debug('SYSDBG - disbursement.Net_Payoff_Due__c:' + disbursement.Net_Payoff_Due__c);
                System.debug('SYSDBG - disbursement.Interest_Rate__c:' + disbursement.Interest_Rate__c);
                System.debug('SYSDBG - disbursement.Net_Payoff_Due__c * disbursement.Interest_Rate__c:' + disbursement.Net_Payoff_Due__c * disbursement.Interest_Rate__c);
                dSubAmountA += disbursement.Net_Payoff_Due__c;
                dSubAmountD += disbursement.Net_Payoff_Due__c * disbursement.Interest_Rate__c;
                System.debug('SYSDBG - dSubAmountD:' + dSubAmountD);
            }
            return (dSubAmountD/dSubAmountA).setScale(2);
            
        } else {
            return (dSubAmountD/dSubAmountA).setScale(2);
        }
        
    } 

}