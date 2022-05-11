/* @Description: Controller for Direct Debit Details (Staff UI)
 * @Author: Mike Lasala
 * @Date Created: DEC-11-2013
 * @History:
   =====================================================================
       12-11-13: Created - Mike
       12-12-13: Completed update logic - Mike
       03/17-14: Removed all logic - Mike
   =====================================================================
 */ 
public with sharing class APP_DirectDebitDetailsExt_INT{
    //===============================================================
    //                     VARIABLE DECLARATIONS
    //===============================================================
    transient public List<Debit__c> debitList     {get;set;}  //Debit records
    transient public String debitObjId            {get;set;}  //Debit custom object id
    transient public String keyPrefix             {get;set;}  //Key prefix ob Debit custom object
    transient public String applicationFieldId    {get;set;}  //Application field on debit object id
    transient public Boolean newEditContract      {get;set;}  //Enable/disable of buttons
    
    public Application__c application {get;set;}
    public String currentApplicationId;

    /*  Description: Main Controller class used for all initializations
     *  Author: Mike Lasala
     *  Date Created: DEC-20-2013
     *  Input: None
     *  Return: void
     */
    public APP_DirectDebitDetailsExt_INT(ApexPages.StandardController applicationController) {
        application = [SELECT   Id, 
                                Name, 
                                Response_Code__c, 
                                Brand_Lookup__r.Country__c 
                       FROM     Application__c 
                       WHERE    Id =: applicationController.getRecord().Id];

        currentApplicationId = this.application.Id;

        debitObjId  = Object_Definition__c.getInstance(GEN_OriginationsConstants.OBJECT_DEBIT).Object_id__c;    //Retrieve object definition id
        Schema.DescribeSObjectResult r = Debit__c.sObjectType.getDescribe();
        keyPrefix = r.getKeyPrefix();   //Retrieve object key prefix
        applicationFieldId = Object_Definition__c.getInstance(GEN_OriginationsConstants.OBJECT_DEBIT).Application__c; //Retrieve application field id

        //Retrieve direct debit record type id
        Schema.DescribeSObjectResult debitSchema = Schema.SObjectType.Debit__c; 
        Map<String,Schema.RecordTypeInfo> debitRecordTypeInfo = debitSchema.getRecordTypeInfosByName();
        
        responseCodeProfileControl(application.Response_Code__c);

        refreshDebit();
    }
    
    /*  Description: Refresh debit records
     *  Author: Mike Lasala
     *  Date Created: JAN-10-2014
     *  Input Parameters: None
     *  Return: Void
     */ 
    public void refreshDebit(){
        debitList = new List <Debit__c>();
        if (currentApplicationId != null) {
            for (sObject o: GEN_RecordRetrievalUtility.queryRelatedRecords(SObjectType.Debit__c.FieldSets.Direct_Debit_Commons.getFields(), 'Debit__c', 'Application__c', currentApplicationId)) {
                debitList.add((Debit__c) o);
            }
        }
    }

    /*  Description: This will control button rendering
     *  Author: Jade Serrano
     *  Date Created: 21-Jan-2014
     *  Input Parameters: String
     *  Return: Void
     */
    public void responseCodeProfileControl(String status) {
        List<Response_Code_Control__c> rList = new List<Response_Code_Control__c>();
        rList = [Select Id From Response_Code_Control__c Where Name =: status];
        
        if(rList.size()>0){
            Boolean resNewEditContract = Response_Code_Control__c.getInstance(status).New_Edit_Contract_Prerequisites__c;
            Boolean proNewEditContract = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_Edit_Contract_Prerequisites__c;

            if(resNewEditContract && proNewEditContract){
                newEditContract = false;
            }else{
                newEditContract = true;
            }
        }
    }
}