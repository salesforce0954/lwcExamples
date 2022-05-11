/*
Author: Louis Augusto Del Rosario Cloud Sherpas
Created Date: Febuary 07, 2014
Description: Trigger Handler for Disbursement Object 
@History:
* =====================================================================
  30-APR-15: Updated Defect 1055 - Add new method updateOutOfSync to update application as out of sync when new risk referral is inserted
* =====================================================================
*/
public class DisbursementTriggerHandler {
    /**  Description: Method to add the Disbursement if count is > 0
     *  Author: Louis Augusto Del Rosario
     *  Date Created: Febuary 07, 2014
     *  Input Parameters: Trigger.new - newly inserted Disbursement records
     *  Return: void
     */
    public void saveDisbursement(List<Disbursement__c> dList){
        Set<Id> dAppIdSet = new Set<Id>();
        Set<String> dAccNumberSet = new Set<String>();
        Map<ID, Set<String>> accByAppId = new Map<ID, Set<String>>();
        Id disRecTypeId;

        Schema.DescribeSObjectResult descSobjects = Disbursement__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> rtMapByNames = descSobjects.getRecordTypeInfosByName();
        disRecTypeId = rtMapByNames.get('Re-Finance').getRecordTypeId();

        if(dList.size() > 0){
            for(Disbursement__c d:dList){
                if(d.RecordTypeId == disRecTypeId){
                    dAppIdSet.add(d.Application__c);
                    dAccNumberSet.add(d.Bank_Acc_No__c);
                    dAccNumberSet.add(d.Bank_Acc_No_NZ__c);
                }
            }
        }
        System.debug('###dAppIdSet: ' + dAppIdSet);
        System.debug('###dAccNumberSet: ' + dAccNumberSet);
        
        List<Applicant_Account__c> appAccList = [SELECT Id, Account_Number__c, Account_Balance__c, Applicant_CLV__r.Applicant__r.Application__c
                                                        FROM Applicant_Account__c 
                                                        WHERE RecordType.Name = 'ICBS' 
                                                        AND Applicant_CLV__r.Applicant__r.Application__r.Id IN: dAppIdSet
                                                        ORDER BY CreatedDate DESC Limit 1];
        System.debug('###dAccNumberSet: ' + appAccList);
        
        if(appAccList.size() >0){
            for(Applicant_Account__c aa : appAccList){
                // Moved these checks from the query to here in code as canoot filter by encrypted fields in SOQL
                if(dAccNumberSet.contains(aa.Account_Number__c) && aa.Account_Balance__c > '0.0'){
                  Set<String> accNumberSet = accByAppId.get(aa.Applicant_CLV__r.Applicant__r.Application__c);
                  if(accNumberSet == null) {
                    accNumberSet = new Set<String>();
                    accByAppId.put(aa.Applicant_CLV__r.Applicant__r.Application__c, accNumberSet);
                  }
                  accNumberSet.add(aa.Account_Number__c);
                  System.debug('###accNumberSet: ' + accNumberSet);
                }
            }
        }
        System.debug('###accByAppId: ' + accByAppId);
        if(dList.size() > 0){
            for(Disbursement__c d:dList){
                if(d.RecordTypeId == disRecTypeId){
                    Set<String> accNumberSet = accByAppId.get(d.Application__c);
                    if(accByAppId.isEmpty()){
                        d.addError('Corresponding Account Number cannot be refinanced');
                    }
                }
            }
        }
    }
    
    
        //-------------------------------------------------------//
    // Method Called from before insert and before update trigger to populate values from payyee table
    // Added by : Akash (US 90,91)
    //-------------------------------------------------------//
    public void populateDisbursementFields (List<Disbursement__c> lstDisbursement,map<Id,Disbursement__c> mpOldDisbursement) {
      if(!Profile_Country__c.getInstance().NZ__c) {
        return;
      } 
      Schema.DescribeSObjectResult d = Schema.SObjectType.Disbursement__c; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
      String rtLimitReductionNZ =  rtMapByName.get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OD_LIMIT_REDUCT_NZ_RECORDTYPE).getRecordTypeId();      //UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
      String overDraftDisclosureNZ =  rtMapByName.get(GEN_OriginationsConstants.DISBURSEMENT_NON_GE_OD_CLOSURE_NZ_RECORDTYPE).getRecordTypeId();        //UPDATED by RCADAPAN 22-MAR-2016 for TQLQW-127
      String directCreditNZ =  rtMapByName.get(GEN_OriginationsConstants.DISBURSEMENT_RTYPE_DIRECT_CREDIT_NZ).getRecordTypeId();                        //MLASALA 30-MAR-16 DEFECT 443 FIX
      
      map<Id,Payee__c> mpPayee = new map<Id,Payee__c>(); 
      for(Disbursement__c disburse : lstDisbursement) {
        if(disburse.Lookup_a_payee__c != NULL) {
          mpPayee.put(disburse.Lookup_a_payee__c,NULL);
        } 
      }
      
      mpPayee = new map<Id,Payee__c>([Select Id,Name,Account_Name__c,Account_Number__c,Bank__c,
                                      Branch__c,Branch_Name__c,Suffix__c,AddressLine1__c,AddressLine2__c,City__c,Postcode__c,Suburb__c
                                      FROM Payee__c WHERE ID IN : mpPayee.keySet()]);
      list<Disbursement__c> lstDirectCredit = new list<Disbursement__c>();                                 
      for(Disbursement__c disburse : lstDisbursement) {
        if(disburse.Lookup_a_payee__c != NULL) {
          Payee__c payee = mpPayee.get(disburse.Lookup_a_payee__c);
          
          //Login runs only for Disclosure and Limit reduction  recordtypes
          if(disburse.RecordTypeId == overDraftDisclosureNZ || disburse.RecordTypeId == rtLimitReductionNZ) {
            //To populate address fields
            if(payee != NULL) {
           //   if(disburse.Financial_Institution_Address_1__c == NULL && payee.AddressLine1__c != NULL) {
                disburse.Financial_Institution_Address_1__c = payee.AddressLine1__c;
           //   }               
           //   if(disburse.Financial_Institution_Address_2__c == NULL && payee.AddressLine1__c != NULL) {
                disburse.Financial_Institution_Address_2__c = payee.AddressLine2__c;
           //   }
           //   if(disburse.Financial_Institution_City__c == NULL && payee.City__c != NULL) {
                disburse.Financial_Institution_City__c = payee.City__c;
           //   }
           //   if(disburse.Financial_Institution_Postcode__c == NULL && payee.Postcode__c != NULL) {
                disburse.Financial_Institution_Postcode__c  = payee.Postcode__c;
           //   }
           //   if(disburse.Financial_Institution_Suburb__c == NULL && payee.Suburb__c != NULL) {
                disburse.Financial_Institution_Suburb__c = payee.Suburb__c;
           //   }
           //   if(disburse.Fin_Institution__c == NULL && payee.Name != NULL) {
                disburse.Fin_Institution__c = payee.Name;
           //   }
              populateDisbursementFields(disburse,payee,mpOldDisbursement);
              populateExistingDisbursementFields(disburse);
            }
            //To create Direct credit record if closure or limit reduction
            if(mpOldDisbursement == NULL) {
              Disbursement__c disb = new Disbursement__c();            
              disb.Application__c = disburse.Application__c; 
              disb.RecordTypeId = directCreditNZ;
              disb.Amount__c = disburse.Amount__c;
              disb.Lookup_a_payee__c = disburse.Lookup_a_payee__c;
              lstDirectCredit.add(disb);
              continue;
            }
          }
          else { 
            populateDisbursementFields(disburse,payee,mpOldDisbursement);
          }          
        }
        populateExistingDisbursementFields(disburse); //defect #355 
      }                                   
    }
    
    //Populate existing fields from newly created for Integration purpose
    //Login does not run for Disclosure and Limit reduction recordtypes
    public void populateExistingDisbursementFields(Disbursement__c disburse) { 
      if(disburse.Bank_Number__c != NULL && disburse.Branch_Number__c != NULL) {
        disburse.BSB__c = disburse.Bank_Number__c + disburse.Branch_Number__c;
      } 
      if(disburse.Bank_Number__c != NULL && disburse.Branch_Number__c == NULL) {
        disburse.BSB__c = disburse.Bank_Number__c;
      }
      if(disburse.Bank_Number__c == NULL && disburse.Branch_Number__c != NULL) {
        disburse.BSB__c = disburse.Branch_Number__c; 
      }
      if(disburse.Account_Name__c != NULL) {
        disburse.Account_Holders__c = disburse.Account_Name__c;
      }
      
      if(disburse.ICBS_Loan_Number__c != NULL) { //defect 692
      	Payee__c p=[Select Suffix__c, Name, Branch__c, Branch_Name__c, Bank__c, Account_Number__c From Payee__c  where Name='GE PL' limit 1];
        //disburse.Bank_Acc_No__c = p.Account_Number__c;
        disburse.Bank_Acc_No_NZ__c = p.Account_Number__c;
        disburse.Bank_Number__c = p.Bank__c;
        disburse.Branch_Number__c = p.Branch__c;
        disburse.Suffix_Number__c = p.Suffix__c;
        disburse.BSB__c = disburse.Bank_Number__c + disburse.Branch_Number__c;
      }
      if(disburse.Branch_Name__c != NULL) {
        disburse.Branch__c = disburse.Branch_Name__c ;
      }
      if(disburse.Fin_Institution__c == NULL) {
        disburse.Fin_Institution__c = disburse.Bank_Name__c ;
      }
    }
    
    //Method to populate disbursement fields based on payee data
    public void populateDisbursementFields(Disbursement__c disburse,Payee__c payee,map<Id,Disbursement__c> mpOldDisbursement) {
      //if(disburse.Bank_Acc_No__c == NULL) {
      //  disburse.Bank_Acc_No__c = payee.Account_Number__c;
      if(disburse.Bank_Acc_No_NZ__c == NULL) {
        disburse.Bank_Acc_No_NZ__c = payee.Account_Number__c;
      }   
      if(disburse.Bank_Number__c == NULL) {
        disburse.Bank_Number__c = payee.Bank__c;
      }      
      if(disburse.Branch_Number__c == NULL) {
        disburse.Branch_Number__c = payee.Branch__c;
      }     
    //  if(disburse.Account_Name__c == NULL) {
     //   disburse.Account_Name__c = payee.Account_Name__c;
     // }   
      if(disburse.Bank_Name__c == NULL) {
        disburse.Bank_Name__c = payee.Branch_Name__c;
      }      
      if(disburse.Suffix_Number__c == NULL) {
        disburse.Suffix_Number__c = payee.Suffix__c;
      }      
      if(disburse.Payee__c == NULL) {
        disburse.Payee__c = payee.Name;
      }
      if(mpOldDisbursement == NULL) {
        return;
      }
      Disbursement__c oldDisbursement = mpOldDisbursement.get(disburse.Id);
      if(disburse.Payee__c == oldDisbursement.Payee__c) {
        disburse.Payee__c = payee.Name;
      }
      
       //if(disburse.Bank_Acc_No__c == oldDisbursement.Bank_Acc_No__c) {
       // disburse.Bank_Acc_No__c = payee.Account_Number__c;
       if(disburse.Bank_Acc_No_NZ__c == oldDisbursement.Bank_Acc_No_NZ__c) {
        disburse.Bank_Acc_No_NZ__c = payee.Account_Number__c;
      }
      
       if(disburse.Bank_Number__c == oldDisbursement.Bank_Number__c) {
        disburse.Bank_Number__c = payee.Bank__c;
      }
      
       if(disburse.Branch_Number__c == oldDisbursement.Branch_Number__c) {
        disburse.Branch_Number__c = payee.Branch__c;
      }
      
      if(disburse.Suffix_Number__c == oldDisbursement.Suffix_Number__c) {
        disburse.Suffix_Number__c = payee.Suffix__c;
      }
      
      if(disburse.Bank_Name__c == oldDisbursement.Bank_Name__c && payee.Branch_Name__c != NULL) {
        disburse.Bank_Name__c = payee.Branch_Name__c;
      }
    }
    
    public void flushInsurance(Set<Id> applicationIdSet){
        
        if(!applicationIdSet.isEmpty()){
                        
            if(!applicationIdSet.isEmpty()){

                List<Application__c> applicationList = [SELECT  Id 
                                                        FROM    Application__c 
                                                        WHERE   Id IN: applicationIdSet];

                                
                if(!applicationList.isEmpty()){
                    GEN_OfferUtility.flushOffers(applicationList);
                }

                try{
                    update applicationList;
                }catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'DisbursementTriggerHandler', 'Application__c', 'Class');
                }
            }
        }
    }

    //Added by DYU Defect 1055 - Update Dirty Flag when new risk referral workflow is added
    public void updateOutOfSync(Set<ID> applicationIdSet){
       if(!applicationIdSet.isEmpty()){
            List<Application__c> appForUpdate = new List<Application__c>();
            List<Application__c> applicationList = [SELECT Id, Out_Of_Sync__c FROM Application__c WHERE Id IN: applicationIdSet];

            if(!applicationList.isEmpty()){
                for(Application__c a: applicationList){
                  a.Out_Of_Sync__c = true;
                  appForUpdate.add(a);
                }

                if(appForUpdate.size() > 0){
                  update appForUpdate;
                }
            }
        }
    }
}