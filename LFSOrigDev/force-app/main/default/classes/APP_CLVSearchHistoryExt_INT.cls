/* @Description: Controller for Applicant CLV Search History page (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: 13-NOV-2015
 * @History:
   =====================================================================
       13-11-15: CREATED - MLASALA
   =====================================================================
 */ 
public with sharing class APP_CLVSearchHistoryExt_INT {
	
    transient public List<Debug_Log__c> searchHistoryList {get;set;}
    public Id applicationId;

	public APP_CLVSearchHistoryExt_INT(ApexPages.StandardController applicationController){
        applicationId = applicationController.getRecord().Id;
	}

	/* Description: Populates list of Applicant CLV Search History from Debug_Log__c object
    *  Author: Mike Lasala
    *  Date Created: 13-NOV-2015
    *  Input Parameters: None
    *  Return: Void
    */
    public void refresh(){     
    
        searchHistoryList = new List<Debug_Log__c>();

        //Retrieve Debug Log Insurance Record Type
        Schema.DescribeSObjectResult resSchema = Debug_Log__c.sObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
        String recordTypeId = recordTypeInfo.get('CLV').getRecordTypeId();
        
        //Retrieve Debug logs records related to application
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Debug_Log__c.FieldSets.Debug_Log_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Debug_Log__c WHERE Application__c =: applicationId AND RecordTypeId =: recordTypeId '
                +'ORDER BY CreatedDate ASC';

        searchHistoryList = Database.query(query);
    }
}