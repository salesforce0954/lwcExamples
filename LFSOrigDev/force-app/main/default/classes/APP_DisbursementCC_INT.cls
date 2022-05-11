/*
* @Description: APP_Disbursement_INT controller
* @Author: Jade Serrano
* @Date Created: 05-Feb-2014
* @History:
*  =====================================================================
*      Jade - 05-Feb-2014: Created
*  =====================================================================
*/
global with sharing class APP_DisbursementCC_INT{

    transient public List<Disbursement__c> disbursementList{get;set;}
    transient public String currentApplicationName    {get;set;}
    transient public String keyPrefix                 {get;set;}
    transient public String objectId                  {get;set;}
    transient public String applicationFieldId        {get;set;}
    transient public Boolean newButtonControl         {get;set;}

    public Application__c application {get;set;}
    //public String currentApplicationId      {get;set;}
    public String currentApplicationId;

    public APP_DisbursementCC_INT(ApexPages.StandardController controller){
        application = [SELECT   Id, 
                                Name, 
                                Response_Code__c, 
                                Brand_Lookup__r.Country__c 
                       FROM     Application__c 
                       WHERE    Id =: controller.getRecord().Id];

        currentApplicationId = this.application.Id;
        //currentApplicationName = this.application.Name;

        //get object id from custom setting
        objectId = Object_Definition__c.getInstance('Disbursement').Object_id__c;
        //get application field id from custom setting
        applicationFieldId = Object_Definition__c.getInstance('Disbursement').Application__c;

        //get object prefix
        Schema.DescribeSObjectResult r = Disbursement__c.sObjectType.getDescribe();
        keyPrefix = r.getKeyPrefix();

        disbursementList = new List<Disbursement__c>();
        disbursementList = getDisbursement();

        newButtonControl = buttonControl();
    }

    //refresh button
    public void refresh() {
        disbursementList = getDisbursement();
    }

    //get fieldsets
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Disbursement__c.FieldSets.Disbursement_Commons.getFields();
    }

    //get disbursemments
    private List<Disbursement__c> getDisbursement() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        // Added by Suneel - Cheque Disbursement Removal - 22/12/2017
        query += 'CreatedDate,Biller_Code__r.Name FROM Disbursement__c WHERE Application__c =: currentApplicationId';
       
        return Database.query(query);
    }

    //disbursement button rendering
    public Boolean buttonControl(){

        Boolean ret;

        List<Response_Code_Control__c> responseCodeControlList = new List<Response_Code_Control__c>();
        responseCodeControlList = [Select Id From Response_Code_Control__c Where Name =: this.application.Response_Code__c];

        if(responseCodeControlList.size()>0){

            Boolean newResponseCodeControl = Response_Code_Control__c.getInstance(this.application.Response_Code__c).New_DB__c;
            Boolean newProfileControl = Profile_Control__c.getInstance(UserInfo.getProfileId()).New_DB__c;

            if(newResponseCodeControl && newProfileControl){
                ret = false;
            }else{
                ret = true;
            }

            if(this.application.Response_Code__c=='PC'){
                ret = true;
            }

            return ret;

        }else{

            Util.addMessage(ApexPages.Severity.WARNING, 'Status not included in custom settings. Buttons will be disabled.');
            return ret;

        }
    }

    //get total disbursement amount
    public Decimal getTotalDisbursementAmount(){

        Decimal totalAmount; 

        List<Application__c> applicationList = [Select Total_Disbursements__c from Application__c where Id = :this.application.Id LIMIT 1];
        
        if(applicationList.size() > 0){

            if(applicationList[0].Total_Disbursements__c != null){
                totalAmount = applicationList[0].Total_Disbursements__c;
            }

        }

        return totalAmount;
         
    }

    /**
     This method is instrumental in fetching the details of the Disbursement record and use those
      details to pre-populate the Direct Debit details. The values are set in a string seperated
      by semi-colon.
      @Input :  disbursementId 
      @Output:  directDebitValues */
    @RemoteAction
    global static String createDirectDebit(String disbursementId){

        Id recordTypeId;
        String directDebitValues;
        String applicationCountry;
        String sfInstance;
        String debitObjPrefix;
        //Variables for Disbursement Field Ids
        String applicationName;
        String accountName;
        String accountNumber;
        String bsbNumber;
        String bankName;
        String branchLocation;
        String branchNumber;
        String suffixNumber;
        String bankNumber;
        //fetch the disbursement data that needs to be pre-populated. This data is for both AU & NZ.
        Disbursement__c disbursementData = [SELECT BSB__c, 
                                                   Bank_Acc_No__c, 
                                                   Branch__c, 
                                                   Fin_Institution__c, 
                                                   Payee__c,
                                                   Application__r.Name,
                                                   Application__r.Brand_Country__c,
                                                   Bank_Number__c,
                                                   Branch_Number__c,
                                                   Suffix_Number__c
                                              FROM Disbursement__c 
                                             WHERE Id =: disbursementId];
        //Fetch the record type Id for Direct Debit. 
        if(disbursementData != null){
               applicationCountry = disbursementData.Application__r.Brand_Country__c;
                List<RecordType> recordTypeList = [SELECT Id,
                                                          DeveloperName 
                                                     FROM RecordType 
                                                    WHERE (DeveloperName = 'Direct_Debit' OR DeveloperName = 'Direct_Debit_NZ') AND SobjectType = 'Debit__c' AND IsActive = true];
               if(applicationCountry.equals('AU'))
               {
                   for(RecordType r : recordTypeList)
                   {
                        if(r.DeveloperName == 'Direct_Debit')
                        {
                                recordTypeId = r.Id;
                        }
                   }
                            //1. Get the Salesforce Instance 
                    sfInstance = System.URL.getSalesforceBaseUrl().getHost();
                    //2. Get the prefix of the Debit object that we want to open
                    debitObjPrefix = Schema.getGlobalDescribe().get('Debit__c').getDescribe().getKeyPrefix();
                    //3. Fetch The input field Ids from Custom Settings
                    applicationName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').Application__c;
                    accountName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').Account_Name__c;
                    accountNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').Account_Number__c;
                    bsbNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').BSB_Number__c;
                    bankName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').Bank_Name__c;
                    branchLocation = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_AU').Branch_Location__c;
                    //4. Form the String
                    directDebitValues = applicationCountry+';'+debitObjPrefix+';'+recordTypeId+';'+applicationName+';'+disbursementData.Application__r.Name+';'+
                                        accountName+';'+disbursementData.Payee__c+';'+accountNumber+';'+
                                        disbursementData.Bank_Acc_No__c+';'+bsbNumber+';'+disbursementData.BSB__c+';'+
                                        bankName+';';
                    if(disbursementData.Fin_Institution__c == null)
                    {
                        directDebitValues = directDebitValues + ''+';';  
                    }
                    else
                    {
                        directDebitValues = directDebitValues + disbursementData.Fin_Institution__c +';';   
                    }

                    directDebitValues = directDebitValues +branchLocation+';';

                    if(disbursementData.Branch__c == null)
                    {
                        directDebitValues = directDebitValues + ''+';';  
                    }
                    else
                    {
                        directDebitValues = directDebitValues + disbursementData.Branch__c +';';   
                    }        
               }
               else if(applicationCountry.equals('NZ'))
               {
                   for(RecordType r : recordTypeList)
                   {
                        if(r.DeveloperName == 'Direct_Debit_NZ')
                        {
                                recordTypeId = r.Id;
                        }
                   }
                        //1. Get the Salesforce Instance 
                    sfInstance = System.URL.getSalesforceBaseUrl().getHost();
                    //2. Get the prefix of the Debit object that we want to open
                    debitObjPrefix = Schema.getGlobalDescribe().get('Debit__c').getDescribe().getKeyPrefix();
                    //3. Fetch The input field Ids from Custom Settings
                    applicationName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Application__c;
                    accountName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Account_Name__c;
                    accountNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Account_Number__c;
                    branchNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Branch_Number__c;
                    bankName = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Bank_Name__c;
                    branchLocation = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Branch_Location__c;
                    suffixNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Suffix_Number__c;
                    bankNumber = Direct_Debit_Field_Ids__c.getInstance('Prepopulate_DirectDebit_NZ').Bank_Number__c;

                    //4. Form the String
                    directDebitValues = applicationCountry+';'+debitObjPrefix+';'+recordTypeId+';'+applicationName+';'+disbursementData.Application__r.Name+';'+
                                        accountName+';'+disbursementData.Payee__c+';'+branchNumber+';'+disbursementData.Branch_Number__c+';'+accountNumber+';'+
                                        disbursementData.Bank_Acc_No__c+';'+suffixNumber+';'+disbursementData.Suffix_Number__c+';'+bankName+';';
                    if(disbursementData.Fin_Institution__c == null)
                    {
                        directDebitValues = directDebitValues + ''+';';  
                    }
                    else
                    {
                        directDebitValues = directDebitValues + disbursementData.Fin_Institution__c +';';   
                    } 
                    directDebitValues = directDebitValues + branchLocation+';';
                    if(disbursementData.Branch__c == null)
                    {
                        directDebitValues = directDebitValues + ''+';';  
                    }
                    else
                    {
                        directDebitValues = directDebitValues + disbursementData.Branch__c +';';   
                    } 
                    directDebitValues = directDebitValues + bankNumber+';'+disbursementData.Bank_Number__c+';';
               }
        }
    
        return directDebitValues;
    }


}