/* @Description: Controller for Page APP_GSD_DisbursementDetails
* @Author : Afreen
* @Date : 29-01-2016
* @History:
=========================================================================================================
JAN-29-2016 : Created - Afreen Khan
FEB-01-2016 : updated - Afreen - Added Remote Action searchBSB()
FEB-03-2016 : Updated - Afreen - Added Remote Action serachBankNumber()
FEB-03-2016 : Updated - Afreen - Added Remote Action serachBranchNumber()
FEB-04-2016 : Updated - Afreen - Added Remote Action confirmDisbursementDetails()
=========================================================================================================
*/
public with sharing class APP_GSD_DisbursementDetails_Ext extends APP_GSD_BaseController{

    /*
    * Description : Method to upsert Repayment details
    */
    
    @RemoteAction
    public static String confirmDisbursementDetails(Disbursement__c disObject, String recordTypeName, Id appRecordID , Decimal loanAmount){
        System.debug('Object Details'+ disObject);
        try{
            RecordType recType = [Select Id, Name From RecordType Where Name = : recordTypeName and sObjectTyPe = 'Disbursement__c'];
            
            Application__c currentApplication = [Select Id, Total_Loan_Amount__c From Application__c where id =:appRecordID];
            
            if(currentApplication.Total_Loan_Amount__c != loanAmount){
                return 'Application loan amount has been updated in the back-end. Please refresh the page to confirm the change.';
            }
            
            disObject.recordTypeId = recType.Id;
            upsert disObject;
            
            return disObject.id;
            
        }catch(Exception e){
            System.debug('Object Details'+ e );
            
        }
        return null;
    }
    
    
    /* 
    * Description : Added to validate input BSB
    */
    @RemoteAction
    public static BSB__c searchBSB(String searchString){
        String queryString = 'Select Id From BSB__c Where Name = \''+ searchString+'\'' ;
        
        List<BSB__c> bsbList = Database.query(queryString);
        
        if(bsbList.size() >0){
            return bsbList[0];
        }else{
            return null;
        }
    }
    
    /*
    * Description : Added to validate input Bank Number for NZ
    */
    @RemoteAction 
    public static Bank__c searchBankNumber(String searchString){
        String queryString = 'Select Id From Bank__c Where Name = \''+ searchString+'\'' ;
        
        List<Bank__c> bankList = Database.query(queryString);
        
        if(bankList.size() >0){
            return bankList[0];
        }else{
            return null;
        }
    }
    
    /*
    * Description : Added to validate input Branch Number for NZ
    */
    @RemoteAction 
    public static Bank_Branch__c searchBranchNumber(String searchString, String bankNumber){
        String bankqueryString = 'Select Id From Bank__c Where Name = \''+ bankNumber+'\'' ;
        List<Bank__c> bankList = Database.query(bankqueryString);
        
        if(bankList.size() >0){
            
            String queryString = 'Select Id From Bank_Branch__c Where Bank_Id__c =\''+  bankList[0].Id +'\' and Min_Range__c <= ' + Integer.valueOf(searchString) + 'and Max_Range__c >= ' + Integer.ValueOf(searchString) ;
            
            List<Bank_Branch__c> branchList = Database.query(queryString);
            
            if(branchList.size() >0){
                return branchList[0];
            }
        }
        
        return null;
        
    }
}