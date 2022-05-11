public class APP_AlertStatusHistory_EXT_INT{
    transient public List<Verify_POI_Check__History> verifyPOICheckHistoryList {get;set;}
    public Id applicationId;

    public APP_AlertStatusHistory_EXT_INT(ApexPages.StandardController applicationController) {
        applicationId = applicationController.getRecord().Id;
    }

    /* Description: Populates a List of from the Application History object. For display in SCC App History Tab.
    *  Author: Campbell McKay
    *  Date Created: 24-NOV-2013
    *  Input Parameters:
    *  Return:
    */
    public void applicationHistoryList(){     
    List<Verify_POI_Check__c> vpc;
       try{
        vpc = [select id,Applicant__r.Application__c from Verify_POI_Check__c where Applicant__r.Application__c=:applicationId];
     
        verifyPOICheckHistoryList = new List<Verify_POI_Check__History>();
        verifyPOICheckHistoryList  = [SELECT Id, Parent.Applicant__r.Full_Name__c,IsDeleted, ParentId, CreatedById, CreatedDate, Field, DataType, OldValue, NewValue FROM Verify_POI_Check__History
                                  WHERE     Parent.Id IN:vpc 
                                  ORDER BY  CreatedDate DESC];
                                   }catch(Exception e){}
                                  
            
    }
   
}