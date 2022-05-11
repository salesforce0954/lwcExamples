public with sharing class QuoteMonthlyRepaymentCalculator {

	/*
	 * Calculate the Monthly Repayment for a Loan amount period and interest rate.
	 * Fees and other charges apply based on the region. 
	*/
    public static void getMonthlyRepayment(Quote__c quoteObj){
        Double loanAmount = quoteObj.Loan_Amount__c;
        Double totalLoanValue = loanAmount;
        Decimal quoteRate = quoteObj.Quote_Rate__c;
        Integer loanTerm = (Integer)quoteObj.Loan_Term_Months__c;
        String region = quoteObj.Region__c;
        String product = quoteObj.Product__c;

        if(loanAmount != null && quoteRate != null && loanTerm != null){    
            if(quoteRate == 0.0){
                quoteObj.Monthly_Repayment__c = 0;
            }else{
                Decimal emi;
                if(quoteObj.Brokerage_Fee__c != null){
                    totalLoanValue += quoteObj.Brokerage_Fee__c;
                }
                //Add Establishment Fees
                if(region == GEN_OriginationsConstants.AU_REGION){
                    if(loanAmount >= 5000){
                        totalLoanValue += 299.0;
                    }else{
                        totalLoanValue += 140.0;
                    }
                }else if(region == GEN_OriginationsConstants.NZ_REGION){
                    //NZ Establishment fees is a flat fee
                    totalLoanValue += 240;
                }
                
                Decimal rate = (quoteRate/12)/100;
                Decimal e = Math.exp((-loanTerm)*Math.log((1+rate)));

                //ICBS fator included LM-1058 JIRA ticket 
                emi = (totalLoanValue*rate)/(1-(e))*1.0018;
                //emi = (totalLoanValue*rate)/(1-(e));
                //emi = Math.ceil(emi);
                
                //Add Monthly Service Fees of $13 to the EMI (for AU)
                if(region == GEN_OriginationsConstants.AU_REGION){
                    emi += 13;
                }
                quoteObj.Monthly_Repayment__c = emi;
        }
    }


    }
}