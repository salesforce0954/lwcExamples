public class DisbursementController{

    public DisbursementController(ApexPages.StandardController controller) {
    id = ApexPages.currentPage().getParameters().get('id');
    disb = [select BillerCode__c,BillerName__c from Disbursement__c where Id = :id]; 
     
    }
public String id {get;set;}
public Disbursement__c disb {get;set;}
}