public Class MyController{
public static void UpdateChildValues(List<BPAY__c> bpayList){

  if(!bpayList.isEmpty()){
     List<Id> objIds = new List<Id>();
      for(BPAY__c obj : bpayList){
         objIds.add(obj.Id);
      }
      Map<Id,Disbursement__c> objDisb = new Map<Id,Disbursement__c>([select id,Biller_Code__r.Name,Biller_Code__r.Biller_Name__c from Disbursement__c where IsDeleted = false and Biller_Code__c in :objIds]);
      for(BPAY__c bpayobj:bpayList ){
        Disbursement__c disbObj = objDisb.get(bpayobj.Id);
        if(disbObj != null){
        disbobj.Biller_Code__r.Name = bpayobj.Name;
        disbobj.Biller_Code__r.Biller_Name__c = bpayobj.Biller_Name__c;
        objDisb.put(bpayobj.Id,disbObj);
        }
      }
        System.debug('+++++++++Result@@@@@@@@@@@@@'+objDisb.values());
        insert objDisb.values();
  }
}
}