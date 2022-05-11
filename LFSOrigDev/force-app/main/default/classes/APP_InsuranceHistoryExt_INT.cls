/* @Description: Controller for Insurance History page (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: AUG-10-2015
 * @History:
   =====================================================================
       08-10-15: CREATED - MLASALA
   =====================================================================
 */ 
public with sharing class APP_InsuranceHistoryExt_INT {
	
    transient public List<Debug_Log__c> insuranceHistoryList {get;set;}
    public Id applicationId;

	public APP_InsuranceHistoryExt_INT(ApexPages.StandardController applicationController){
        applicationId = applicationController.getRecord().Id;
	}

	/* Description: Populates list of Insurance History from Debug_Log__c object
    *  Author: Mike Lasala
    *  Date Created: 10-AUG-2015
    *  Input Parameters: None
    *  Return: Void
    */
    public void refresh(){     
    
        insuranceHistoryList = new List<Debug_Log__c>();

        //Retrieve Debug Log Insurance Record Type
        Schema.DescribeSObjectResult resSchema = Debug_Log__c.sObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
        String recordTypeId = recordTypeInfo.get('Insurance').getRecordTypeId();
        
        //Retrieve Debug logs records related to application
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Debug_Log__c.FieldSets.Debug_Log_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Debug_Log__c WHERE Application__c =: applicationId AND RecordTypeId =: recordTypeId AND Insurance_Type__c != null '
                +'ORDER BY CreatedDate ASC';

        insuranceHistoryList = Database.query(query);
    }

}