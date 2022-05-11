public with sharing class APP_Workflow_EXT_INT{
    public Id applicationId;
    
    public List<Workflow__c> workflowList{
        get {
            if(workflowList==null) {
                workflowList = [Select      Id, 
                                            CreatedById, 
                                            CreatedDate, 
                                            Description__c, 
                                            Status__c, 
                                            Assigned_To_1__c, 
                                            RecordType.Name, 
                                            Priority__c, 
                                            Name, 
                                            Application__c
                                From        Workflow__c 
                                Where       Application__c =: applicationId 
                                ORDER BY    CreatedDate DESC];    
            }
            return workflowList;
        }
        set;
    }
    public APP_Workflow_EXT_INT(ApexPages.StandardController applicationController) {
        applicationId = applicationController.getRecord().Id;
    }
    public PageReference refreshWorkFlowList() {
        workflowList = null;
        return null;
    }
}