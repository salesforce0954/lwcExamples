/*
 * @Description: Decisioning controller
 * @Author: Jade Serrano
 * @Date Created: 
 * @History:
   =====================================================================
       Jade - : Created
   =====================================================================
 */
public with sharing class APP_Notes_EXT_INT{
    
    transient public List<Task> taskList{get;set;}
    public Id applicationId;

    public APP_Notes_EXT_INT(ApexPages.StandardController controller) {
        applicationId = controller.getRecord().Id;
        refreshNotesTabTable();
    }

    /* Description: Used to display task
     *  Author: Jade Serrano
     *  Date Created:
     *  Input Parameters:
     *  Return:
     */
    public void refreshNotesTabTable(){        
      taskList = new List<Task>();
      taskList = [Select      WhoId,
                              Subject,
                              Description,
                              CreatedById,
                              CreatedDate,
                              RecordType.Name,
                              Status,
                              ActivityDate,
                              OwnerId         
                  From        Task
                  Where       WhatId =: applicationId ORDER BY CreatedDate DESC];
                    
    }
}