public with sharing class ComparisionRateCalculator {
    
    /**
     * Calculate Comparison rate based on IRR excel formula. Source for the below logic is 
     * https://gist.github.com/ghalimi/4591338
     * The same source is used by Digital. 
     */
    public static void getRate(Quote__c quoteObj){
        List<Decimal> values = new List<Decimal>();
        Double loanAmount = quoteObj.Loan_Amount__c;
        Integer loanTermMonths = (Integer)quoteObj.Loan_Term_Months__c;
        Decimal monthlyRepayment = quoteObj.Monthly_Repayment__c;
        Decimal resultRate = 0.06;
        System.debug('loanAmount: '+loanAmount);
        System.debug('loanTermMonths: '+loanTermMonths);
        System.debug('monthlyRepayment: '+monthlyRepayment);
        Decimal comparisonRate;
        values.add(-loanAmount);
        for(Integer i =0; i <loanTermMonths ;i++){
            values.add(monthlyRepayment);
        }
          // Initialize dates and check that values contains at least one positive value and one negative value
        List<Integer> dates = new List<Integer>();
        Boolean positive = false;
        Boolean negative = false;
        for(Integer j =0; j < values.size(); j++){
            //dates[j] = (j == 0) ? 0 : dates[j-1] +365;
            if(j == 0){
                dates.add(0);
            }else{
                dates.add(dates[j-1]+365);
            }
            if(values[j] > 0){
                positive = true;
            }
            if(values[j] < 0){
                negative = true;
            }
        }
        System.debug('values: '+values);
        System.debug('dates: '+dates);
        // Return error if values does not contain at least one positive value and one negative value
        if (!positive || !negative){
            return;
        } 
          // Set maximum epsilon for end of iteration
        Decimal epsMax = Decimal.valueOf('1e-10');
          // Set maximum number of iterations
        Integer iterMax = 50;
        // Implement Newton's method
        Decimal newRate, epsRate, resultValue;
        Integer iteration = 0;
        Boolean contLoop = true;
        do{ 
            resultValue = irrResult(values,dates,resultRate);
            newRate = resultRate - resultValue / irrResultDeriv(values,dates,resultRate);
            epsRate = Math.abs(newRate - resultRate);
            resultRate = newRate;
            System.debug('resultRate Loop: '+resultRate);
            contLoop = (epsRate > epsMax) && (Math.abs(resultValue) > epsMax);
        }while (contLoop && (++iteration < iterMax));

        if(contLoop){
            return;
        }
        // Return internal rate of return
        comparisonRate = (resultRate*12*100).setScale(2);
        
        System.debug('resultRate: '+comparisonRate);
        quoteObj.Comparison_Rate__c = comparisonRate;
        
    }   

    // Calculates the resulting amount
    private static Double irrResult(List<Decimal> values, List<Integer> dates, Decimal rate){
        Double r = rate + 1;
        Double result = values[0];
        for(Integer k = 1;k < values.size();k++){
            result += values[k]/Math.pow(r, (dates[k]-dates[0])/365);
        }
        return result;
    }


    // Calculates the first derivation
    private static Double irrResultDeriv(List<Decimal> values, List<Integer> dates, Decimal rate){

        Double r = rate + 1;
        Double result = 0;
        for(Integer m = 1;m < values.size();m++){
            Double frac = (dates[m]-dates[0])/365;
            result -= frac * values[m] / Math.pow(r, frac+1);
        }
        return result;
    }

}