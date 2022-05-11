/* @Description: Controller for Fees and Charges
 * @Author: Fel Saliba
 * @Date Created: APR-08-2014
 * @History:
   =====================================================================
       APR-08-2014: Created - Fel
   =====================================================================
 */ 
public class APP_FeesChargesEXT{
    
    transient public String ppsrSearchFee {get;set;}
    transient public String ppsrRegistrationFee {get;set;}
    transient public String establishmentFee {get;set;}
    transient public String loanServiceFee {get;set;}
    transient public String paymentHandlingFee {get;set;}
    transient public String latePaymentFee {get;set;}
    transient public String terminationFee1 {get;set;}
    transient public String terminationFee2 {get;set;}
    public Application__c application;
    
    
    public APP_FeesChargesEXT(ApexPages.StandardController applicationController) {
        
        this.application = (Application__c)applicationController.getRecord();
        Application__c app = [Select Id, 
                                     LastModifiedDate, 
                                     Brand_String__c, 
                                     Total_Loan_Amount__c, 
                                     Adjusted_Interest_Fee_Locked__c, 
                                     Offered_Establishment_Fee__c, 
                                     Offered_Establishment_Fee_Orig__c,
                                     Offered_PPSR_Registration_Fee__c,
                                     Offered_PPSR_Search_Fee__c, 
                                     Promotional_Campaign__c, 
                                     Promo_Id__c            //Added by MLASALA 15-SEPT-16 TQLQW-487 - Promo Engine
                              from   Application__c 
                              where  Id =: application.Id];
        
        OFF_OfferFieldsCalculator offerCalculator = new OFF_OfferFieldsCalculator();
        offerCalculator.getProdutctItems(app);
        ppsrSearchFee = String.valueOf(app.Offered_PPSR_Search_Fee__c);
        ppsrRegistrationFee = String.valueOf(app.Offered_PPSR_Registration_Fee__c);
        
        //MLASALA 15-SEPT-16 TQLQW-487 - Promo Engine
        //Added promo id checking condition
        if(app.Adjusted_Interest_Fee_Locked__c || 
           app.Promo_Id__c != null){
            
            establishmentFee = String.valueOf(app.Offered_Establishment_Fee__c);
        } else if(app.Promotional_Campaign__c == GEN_OriginationsConstants.BUSINESS_SOURCE_60_DAY_CERTIFICATE){     //MLASALA 02-AUG-16 CVP2 Fix Pack
            establishmentFee = '0.00';
        } else {
            establishmentFee = String.valueOf(app.Offered_Establishment_Fee_Orig__c);
        }
        loanServiceFee = String.valueOf(offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_LOAN_SERVICE));
        paymentHandlingFee = String.valueOf(offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_PAYMENT_HANDLING));
        latePaymentFee = String.valueOf(offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_LATE_PAYMENT));
        terminationFee1 = String.valueOf(offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_EARLY_TERMINATION1));
        terminationFee2 = String.valueOf(offerCalculator.getFee(app, GEN_OriginationsConstants.FEE_EARLY_TERMINATION2));
    }
}