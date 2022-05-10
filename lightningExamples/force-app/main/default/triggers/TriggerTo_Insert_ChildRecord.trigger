trigger TriggerTo_Insert_ChildRecord on BPAY__c (after undelete) {
    
    //To store parent ids
    list<id> BpayIds=new list<id>();
    for(BPAY__c bpay:trigger.old)
    {
        BpayIds.add(bpay.id);
    }  
    //Collecting all child records related to Parent records
    list<Disbursement__c> listOfDisbursements=[select Biller_Code__r.Name,isDeleted,Biller_Code__r.Biller_Name__c from Disbursement__c where Biller_Code__c in :BpayIds];
    list<Disbursement__c> disbResult = new list<Disbursement__c>();
    System.debug('+++++++++++ List of Disbursements +++++++++++++' +listofDisbursements);
    for(Disbursement__c disb :listofDisbursements){
      for(BPAY__c bpayau : [select Name,Biller_Name__c from BPAY__c]){
              
         disb.Biller_Code__r.Name = bpayau.Name;
         disb.Biller_Code__r.Biller_Name__c= bpayau.Biller_Name__c;
         
       }
               disbResult.add(disb);

    }
    system.debug('+++++++++++++++Disbursement Result @@@@@@@@@@@@@@'+disbResult);
    insert disbResult;
}