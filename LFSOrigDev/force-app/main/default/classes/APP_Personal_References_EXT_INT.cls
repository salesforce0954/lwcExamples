public with sharing class APP_Personal_References_EXT_INT{
    
    //public Id applicationId;
    public Application__c application {get;set;}
    
    public APP_Personal_References_EXT_INT(ApexPages.StandardController applicationController) {
        application = [SELECT Id, Brand_Country__c FROM Application__c WHERE Id =: applicationController.getRecord().Id];
    }

    public PageReference refreshPRCList(){
        prcList = null;
        return null;
    }

    public List<Personal_Reference_Check__c> prcList{
        get {
            if(prcList==null) {
                prcList = [SELECT   Id,
                                    Name, 
                                    Name__c,
                                    Relationship__c,
                                    Phone_Number__c,
                                    Personal_Ref_Address__c, 
                                    Country__c, 
                                    Postcode__c, 
                                    Property_Name__c, 
                                    State__c, 
                                    Street_Name__c, 
                                    Street_Number__c, 
                                    Street_Type__c, 
                                    Suburb__c, 
                                    Town_City__c,
                                    CreatedById, 
                                    CreatedDate
                           FROM     Personal_Reference_Check__c 
                           WHERE    Application__c =: application.Id
                           ORDER BY CreatedDate DESC];    
            }
            return prcList;
        }
        set;
    }
}