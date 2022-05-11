public with sharing class APP_StatusHistory_EXT_INT{
    transient public List<Application__History> applicationHistoryList {get;set;}
    public Id applicationId;

    public APP_StatusHistory_EXT_INT(ApexPages.StandardController applicationController) {
        applicationId = applicationController.getRecord().Id;
    }

    /* Description: Populates a List of from the Application History object. For display in SCC App History Tab.
    *  Author: Campbell McKay
    *  Date Created: 24-NOV-2013
    *  Input Parameters:
    *  Return:
    */
    public void applicationHistoryList(){     
    
        applicationHistoryList = new List<Application__History>();
        applicationHistoryList = [SELECT    Field, 
                                            NewValue, 
                                            OldValue, 
                                            CreatedById, 
                                            CreatedDate
                                  FROM      Application__History 
                                  WHERE     Parent.Id =: applicationId 
                                  ORDER BY  CreatedDate DESC];
    }
   
}