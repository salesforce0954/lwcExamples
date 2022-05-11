/**
 * @Description: Class to recalculate Rate Reduction
 * @Author: Fel Saliba
 * @Date Created: JANUARY 17, 2014
 * @History:
   =====================================================================
       JAN-17-14: Created. - Fel
   =====================================================================
 */
 
public class RUL_Rate_Reduction{

    private static Set<String> reasonSet1 = new Set<String>{'Blended Rate Calculation','General Discretion','Cousins Discretion','VIP'};
    private static Set<String> reasonSet2 = new Set<String>{'Refinance CreditLine/Buyers Edge','Refinance GE MasterCard/Other GE Card','Mango % Rule','Guaranteed Rate Loan'};
    

    public Decimal rateReductionWithAppResponse(IS_ApplicationDTO applicationDTO){
    
        OFF_OfferFieldsCalculator calculator = new OFF_OfferFieldsCalculator();
        calculator.getProdutctItems(applicationDTO.app);
        Decimal newOfferedRate = 0;
        newOfferedRate = calculator.getBlendedRate(applicationDTO.app, calculator.getInterestRate(applicationDTO.app));
        System.debug('newOfferedRate-->'+newOfferedRate );
        System.debug('Offered_Interest_Rate_Orig__c -->'+applicationDTO.app.Offered_Interest_Rate_Orig__c );
        
        if(applicationDTO.app.Adjusted_Interest_Rate__c != null && applicationDTO.app.Adjusted_Interest_Rate__c == applicationDTO.app.Offered_Interest_Rate__c){
            if(reasonSet1.contains(applicationDTO.app.Adjusted_Interest_Rate_Reason__c)){
                
                if(newOfferedRate < applicationDTO.app.Offered_Interest_Rate_Orig__c){
                    System.debug('first If');
                    return newOfferedRate;
                }
                else{            
                    if(newOfferedRate > (applicationDTO.app.Offered_Interest_Rate_Orig__c + 0.3)){
                        System.debug('if without appresponse');
                        return newOfferedRate;                    
                    } 
                    else{
                        System.debug('else appresponse');
                        return applicationDTO.app.Adjusted_Interest_Rate__c;
                    }
                }   
            
            }
            else if(reasonSet2.contains(applicationDTO.app.Adjusted_Interest_Rate_Reason__c)){
                
                if(newOfferedRate < applicationDTO.app.Adjusted_Interest_Rate__c){
                    System.debug('else if without appresponse');
                    return newOfferedRate;                
                }
                else{
                    System.debug('else2 appresponse');
                    return applicationDTO.app.Adjusted_Interest_Rate__c;
                }    
            
            }
            else{
                System.debug('else3 appresponse');
                if(applicationDTO.app.Adjusted_Interest_Rate__c < newOfferedRate){
                    System.debug('else3 if appresponse');
                    return applicationDTO.app.Adjusted_Interest_Rate__c;                    
                }
                else{
                    System.debug('else3 else appresponse');
                    return newOfferedRate;
                }          
            } 
        }
        else{
            System.debug('last else return');
            //return applicationDTO.app.Offered_Interest_Rate__c; 
            return newOfferedRate;
        }  
    }
    
    public Decimal rateReductionWithoutAppResponse(IS_ApplicationDTO applicationDTO){
    
        OFF_OfferFieldsCalculator calculator = new OFF_OfferFieldsCalculator();
        calculator.getProdutctItems(applicationDTO.app);
        //Decimal newOfferedRate = 0;
        //newOfferedRate = calculator.getInterestRate(applicationDTO.app);
       
        if(applicationDTO.app.Adjusted_Interest_Rate__c != null){
		    if(applicationDTO.app.Brand_Country__c == 'NZ') {
        	  return applicationDTO.app.Adjusted_Interest_Rate__c;           
        	}
            if(applicationDTO.app.Adjusted_Interest_Rate__c < applicationDTO.app.Offered_Interest_Rate__c){
                System.debug('id without appresponse');
                return applicationDTO.app.Adjusted_Interest_Rate__c;                   
            }
            else{
                System.debug('else 1 without appresponse');
                //return newOfferedRate;
                return applicationDTO.app.Offered_Interest_Rate__c;
            }
        }
        else{
            System.debug('else 2 without appresponse');
            return applicationDTO.app.Offered_Interest_Rate__c;
        } 
    }

}