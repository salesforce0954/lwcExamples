/* @Description: Utility class for refinance related methods
 * @Author: Mike Lasala
 * @Date Created: MAY-20-2014
 * @History:
   =====================================================================
       05-20-14: Created - Mike
   =====================================================================
 */ 
public with sharing class GEN_RefinanceUtility {
    
    public GEN_RefinanceUtility() {
        
    }

    /*  Description: Validate applicant account number
     *  Author: Mike Lasala
     *  Date Created: MAY-20-2014
     *  Input Parameters: Applicant account number
     *  Return: Boolean
     */
    public String validateAppAccountNumber(String appAccountNumber, String applicationId){
        System.debug('DEBUG BOK VALIDATE ACCOUNT NUMBER');
        String errorMessage = null;
        /*** Commented out by Fel Saliba 30/06/2014
        //Retrieve applicant account record of account number entered
        List<Applicant_Account__c> appAccountList = [SELECT     Id, Account_Number__c, Applicant_CLV__r.Applicant__r.Application__c, Account_Balance__c
                                                     FROM       Applicant_Account__c 
                                                     WHERE      RecordType.Name = 'ICBS' 
                                                     AND        Account_Number__c =: appAccountNumber
                                                     AND        Applicant_CLV__r.Applicant__r.Application__r.Id =: applicationId
                                                     ORDER BY   CreatedDate DESC LIMIT 1];
        if(!appAccountList.isEmpty()){
            //Validate if account has an account balance
            if(appAccountList.get(0).Account_Balance__c < '0.0'){
                errorMessage = 'Account Balance is less than 0';
            }
        } else {    //No applicant account record found
            errorMessage = 'Invalid Account Number';
        }
        ****/
        System.debug('DEBUG BOK VALIDATE ACCOUNT NUMBER '+errorMessage);
        return errorMessage;
    }
}