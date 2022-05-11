public class APP_Disbursement_List{
    public String id {get;set;}
    public Disbursement__c disb {get;set;}
/****************Constructor***************/
        public APP_Disbursement_List(ApexPages.StandardController controller) {
        id = ApexPages.currentPage().getParameters().get('id');
        disb = [select BillerCode__c,BillerShortName__c,BillerLongName__c,BillerMinThresholdValue__c,BillerMaxThresholdValue__c,BillerCheckDigitRule__c from Disbursement__c where Id = :id]; 
         
    }

}