public with sharing class APP_Credit_File_Check_EXT_INT{
    public Id applicationId;
    
    public List<Credit_File_Check__c> cfcList{
        get {
            if(cfcList==null) {
                cfcList = [Select           Id,
                                            Name, 
                                            Applicant__r.First_Name__c,
                                            Applicant__r.Last_Name__c,
                                            Surname_Check__c,
                                            DOB_Check__c,
                                            Drivers_License_Check__c,
                                            Prior_Address_Check__c,
                                            Address_Check__c,
                                            CreatedById, 
                                            CreatedDate
                                From        Credit_File_Check__c 
                                Where       Application__c =: applicationId 
                                ORDER BY    CreatedDate DESC];    
            }
            return cfcList;
        }
        set;
    }
    public APP_Credit_File_Check_EXT_INT(ApexPages.StandardController applicationController) {
        applicationId = applicationController.getRecord().Id;
    }
    public PageReference refreshCFCList() {
        cfcList = null;
        return null;
    }
}