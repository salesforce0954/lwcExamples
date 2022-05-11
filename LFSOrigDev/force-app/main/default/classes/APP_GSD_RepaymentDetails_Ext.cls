/* @Description: Controller for Page APP_GSD_RepaymentDetails
* @Author : Marvin
* @Date : 03-02-2016
* @History:
=========================================================================================================
FEB-03-2016 : Created - Marvin David
FEB-09-2016 : Updated - Afreen Khan - added all the remote methods
=========================================================================================================
*/
public with sharing class APP_GSD_RepaymentDetails_Ext extends APP_GSD_BaseController{

    /*
    * Description : Method to upsert Repayment details
    */
    
    @RemoteAction
    public static String confirmRepaymentDetails(Debit__c disObject, String recordTypeName){
        System.debug('Object Details'+ disObject);
        try{
            RecordType recType = [Select Id, Name From RecordType Where Name = : recordTypeName and sObjectTyPe = 'Debit__c'];
            
            disObject.recordTypeId = recType.Id;
            upsert disObject;
            
            return disObject.id;
            
        }catch(Exception e){
            System.debug('Object Details'+ e );
            return e.getMessage();
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