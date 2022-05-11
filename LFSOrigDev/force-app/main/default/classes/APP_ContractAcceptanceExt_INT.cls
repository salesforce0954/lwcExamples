/*
 * @Description: Controller for Contract Acceptance page
 * @Author: August Del Rosario
 * @Date Created: Jan-28-2014
 * @History:
   =====================================================================
       28-01-14: Created - August
   =====================================================================
 */

public with sharing class APP_ContractAcceptanceExt_INT {
    public Boolean objectivesAndRequirements {get;set;}
    public Boolean termsAndConditions {get;set;}
    public Boolean creditPolicy {get;set;}
    public Boolean complaiantsBrocure {get;set;}
    public Boolean privacyPolicy {get;set;}
    public Boolean directDebitRequest {get;set;}
    public Boolean directDebitRequestServiceAgreement {get;set;}
    public Boolean disbursementAuthority {get;set;}
    public Boolean insuranceIndemnityLetter {get;set;}
    public Boolean geCreditCardClosureAuthority {get;set;}
    public Boolean interestFreeRebateLetter {get;set;}
    public Boolean geCreditCardLimitDecreaseAuthority {get;set;}
    public Boolean dormantCreditCardClosureAuthority {get;set;}
    public Boolean creditCardClosureAuthority {get;set;}
    public Boolean creditCardLimitDecreaseAuthority{get;set;}
    public Boolean overdraftClosureAuthority {get;set;}
    public Boolean overdraftLimitDecreaseAuthority {get;set;}
    public Boolean loanProtectionPolicyScheduleAndPolicyWarning {get;set;}
    public Boolean contract {get;set;}
    
    public APP_ContractAcceptanceExt_INT(ApexPages.StandardController applicationController){
        
    }
    
}