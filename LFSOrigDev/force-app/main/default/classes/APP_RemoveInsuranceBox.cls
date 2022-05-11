public class APP_RemoveInsuranceBox{

    public APP_RemoveInsuranceBox() {

    }

    public String id {get;set;}
    public Application__c app {get;set;}
/****************Constructor***************/
        public APP_RemoveInsuranceBox(ApexPages.StandardController controller) {
        id = ApexPages.currentPage().getParameters().get('id');
        app = [select Product_SubType__c from Application__c where Id = :id]; 
         
    }

}