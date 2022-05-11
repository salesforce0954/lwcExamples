/**
 * @Description: General class for generic record retrieval methods
 * @Author: Dan Crisologo
 * @Date Created: DECEMBER-10-2013
 * @History:
   =====================================================================
       12-10-13: Created. - Dan
       2015-08-12: PMIHM-1077 Added method to retrieve workflow
   =====================================================================
 */ 
public without sharing class GEN_RecordRetrievalUtility{

    public final static String OBJECTNAME_INCOME = 'Income__c';
    public final static String OBJECTNAME_ASSET = 'Asset__c';
    public final static String OBJECTNAME_EXPENSE = 'Expense__c';
    public final static String OBJECTNAME_LIABILITY = 'Liability__c';
    public final static String OBJECTNAME_COLLATERAL = 'Collateral__c';
    public final static String OBJECTNAME_DISBURSEMENT = 'Disbursement__c';
    public final static String OBJECTNAME_AML = 'AML__c';
    public final static String OBJECTNAME_APP_CLV = 'Applicant_CLV__c';

    public final static String OBJECTNAME_APPLICANT = 'Applicant__c';
    public final static String OBJECTNAME_APPLICATION = 'Application__c';
    
    /**2015-08-12 TXU START**/
    public final static String OBJECTNAME_WORKFLOW = 'Workflow__c';
    /**END**/
    //Added as part of Soft Quote 
    public final static String OBJECTNAME_QUOTE = 'Quote__c';
    
    /*  Description: retrieves quote record
     *  Author: Madhusudhan Seethala
     *  Date Created: Mar-23-2020
     *  Input: QuoteId -- Id of the quote record to query
     *  Return: Quote__c
     */
    public static Quote__c retrieveQuote(String quoteId) {
        return (Quote__c) querySingleRecord(SObjectType.Quote__c.FieldSets.Quote_Commons.getFields(), OBJECTNAME_QUOTE, quoteId);       
    }
    
   /*  Description: retrieves application record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: applicationId -- Id of the application record to query
     *  Return: Application__c
     */
    public static Application__c retrieveApplication(String applicationId) {
        return (Application__c) querySingleRecord(SObjectType.Application__c.FieldSets.Application_Commons.getFields(), OBJECTNAME_APPLICATION, applicationId);       
    }

    /*  Description: retrieves lists of Asset related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: Jan-20-2014
     *  Input: None
     *  Return: List<Applicant_CLV__c>
     */
    public static List<Applicant_CLV__c> retrieveApplicantCLVList(Id applicantId) {
        List<Applicant_CLV__c> clvList = new List<Applicant_CLV__c>();
        if(applicantId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Applicant_CLV__c.FieldSets.CLV_Commons.getFields(), OBJECTNAME_APP_CLV, OBJECTNAME_APPLICANT, applicantId)) {
                clvList.add((Applicant_CLV__c)o);
            }
        } 
        return clvList;
    }

    /*  Description: retrieves lists of income related to the applicant record parameter
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: applicantId
     *  Return: List<Income__c>
     */
    public static List<Income__c> retrieveIncomeList(Id applicantId) {
        List<Income__c> incomeList = new List<Income__c>();
        if(applicantId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Income__c.FieldSets.Income_Commons.getFields(), OBJECTNAME_INCOME, OBJECTNAME_APPLICANT, applicantId)) {
                incomeList.add((Income__c)o);
            }
        } 
        return incomeList;
    }
    
    /*  Description: retrieves lists of Asset related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Asset__c>
     */
    public static List<Asset__c> retrieveAssetList(Id applicantId) {
        List<Asset__c> assetList = new List<Asset__c>();
        if(applicantId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Asset__c.FieldSets.Asset_Commons.getFields(), OBJECTNAME_ASSET, OBJECTNAME_APPLICANT, applicantId)) {
                assetList.add((Asset__c)o);
            }
        } 
        return assetList;
    }
    
    /*  Description: retrieves lists of Expense related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Expense__c>
     */
    public static List<Expense__c> retrieveExpenseList(Id applicantId) {
        List<Expense__c> expenseList = new List<Expense__c>();
        if(applicantId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Expense__c.FieldSets.Expense_Commons.getFields(), OBJECTNAME_EXPENSE, OBJECTNAME_APPLICANT, applicantId)) {
                expenseList.add((Expense__c)o);
            }
        } 
        return expenseList;
    }
    
    /*  Description: retrieves lists of Liability related to the applicant record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Liability__c>
     */
    public static List<Liability__c> retrieveDebtList(Id applicantId) {
        List<Liability__c> debtList = new List<Liability__c>();
        if(applicantId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Liability__c.FieldSets.Liability_Commons.getFields(), OBJECTNAME_LIABILITY, OBJECTNAME_APPLICANT, applicantId)) {
                debtList.add((Liability__c)o);
            }
        } 
        return debtList;
    }
    
    /*  Description: retrieves lists of collateral records related to the application
     *  Author: Dan Crisologo
     *  Date Created: DEC-17-2013
     *  Input: applicationId
     *  Return: List<Collateral__c>
     */
    public static List<Collateral__c> retrieveCollateralList(Id applicationId) {
        List<Collateral__c> collateralList = new List<Collateral__c>();
        if(applicationId!=null) {
            for(sObject o: queryRelatedRecords(SObjectType.Collateral__c.FieldSets.Collateral_Commons.getFields(), OBJECTNAME_COLLATERAL, OBJECTNAME_APPLICATION, applicationId)) {
                collateralList.add((Collateral__c)o);
            }
        } 
        return collateralList;
    }
    
    /*  Description: retrieves lists of disbursement records related to the application
     *  Author: Dan Crisologo
     *  Date Created: DEC-18-2013
     *  Input: applicationId
     *  Return: List<Disbursement__c>
     */
    public static List<Disbursement__c> retrieveDisbursementsList(Id applicationId) {
        List<Disbursement__c> disbursementsList = new List<Disbursement__c>();
        if(applicationId!=null) {
            for(sObject o: queryRelatedDisbursementRecords(SObjectType.Disbursement__c.FieldSets.Disbursement_Commons.getFields(), OBJECTNAME_DISBURSEMENT, OBJECTNAME_APPLICATION, applicationId)) {
                disbursementsList.add((Disbursement__c)o);
            }
        } 
        return disbursementsList;
    }
    
    /*  Description: retrieves lists of AML records related to the application
     *  Author: Dan Crisologo
     *  Date Created: DEC-19-2013
     *  Input: applicantId
     *  Return: List<AML__c>
     */
    public static List<AML__c> retrieveAMLList(Id applicantId) {
        List<AML__c> amlList = new List<AML__c>();
        if(applicantId!=null) {
            //for(sObject o: queryRelatedRecords(SObjectType.AML__c.FieldSets.AML_Commons.getFields(), OBJECTNAME_AML, OBJECTNAME_APPLICANT, applicantId)) {
            //    amlList.add((AML__c)o);
            //}

            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.AML__c.FieldSets.AML_Commons.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.subString(0, query.length() - 1); //trim last comma
            query += ' FROM AML__c WHERE Applicant__c =: applicantId AND (Identification__c != null OR POA_Type__c != null) ORDER BY CreatedDate DESC';
            if(applicantId!=null) {
                for(sObject o: Database.query(query)) {
                    amlList.add((AML__c)o);
                }
            }
        } 
        return amlList;
    }
    
    /*  Description: retrieves lists of post submit AML records related to the application
     *  Author: Mike Lasala
     *  Date Created: APR-30-2015
     *  Input: applicantId
     *  Return: List<AML__c>
     */
    public static List<AML__c> retrieveAMLListPostSubmit(Id applicantId) {
        List<AML__c> amlList = new List<AML__c>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.AML__c.FieldSets.AML_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM AML__c WHERE Applicant__c =: applicantId AND (Verified_Flag__c = true OR POA_Type__c != null) ORDER BY CreatedDate DESC';
        if(applicantId!=null) {
            for(sObject o: Database.query(query)) {
                amlList.add((AML__c)o);
            }
        }
        return amlList;
    }

    /*  Description: retrieves lists of Loan Purpose related to the application record
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Loan_Purpose__c>
     */
    public static List<Loan_Purpose__c> retrieveLoanPurposeList(Id applicationId) {
        List<Loan_Purpose__c> loanPurposeList = new List<Loan_Purpose__c>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Loan_Purpose__c.FieldSets.Loan_Purpose_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Loan_Purpose__c WHERE Application__c =: applicationId ORDER BY Loan_Amount__c DESC';
        if(applicationId!=null) {
            for(sObject o: Database.query(query)) {
                loanPurposeList.add((Loan_Purpose__c)o);
            }
        } 
       return loanPurposeList;
    }
    
    /*  Description: Query a record via its' record ID
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input:   fieldSetMembers - object field set
                 objectName - object name
                 recordId - object record id
     *  Return: sObject
     */
    
    public static sObject querySingleRecord (List<Schema.FieldSetMember> fieldSetMembers, String objectName, String recordId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        if(objectName.equals(OBJECTNAME_APPLICATION))query +='Sales_Agent__r.name,';
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE Id=:recordId';
        return Database.query(query);
    }
    
    /*  Description: Query all object's related record based on parent record ID
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input:   fieldSetMembers - object field set of related object
                 objectName - object name of related object to query
                 parentObjectFieldName - field name of the parent / lookup
                 parentRecordId - parent record id
     *  Return: List<sObject>
     */
   public static List<sObject> queryRelatedRecords (List<Schema.FieldSetMember> fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        if(objectName == 'Applicant__c'){
        query += ' ,Application__r.Brand_Country__c FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate DESC';        
        }else if(objectName == 'Income__c'){
        query += ' ,Applicant__r.Application__r.Brand_Country__c FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate DESC';  
        }else{ 
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate DESC';
       }
        return Database.query(query);
    }
    
    /* Description: Retrieves a Biller Code - Cheque Disbursement Removal
     * Author: Suneel Desiraju              
     * Date Created: O7-01-2018
     * Input: objectName -Disbursement           
    */    
    public static List<sObject> queryRelatedDisbursementRecords (List<Schema.FieldSetMember> fieldSetMembers, String objectName, String parentObjectFieldName, String parentRecordId) {
        String query = 'SELECT ';
        query += 'Biller_Code__r.Name,Biller_Code__r.Biller_Short_Name__c,';
        for(Schema.FieldSetMember f : fieldSetMembers) {
            query += f.getFieldPath() + ',';
        }        
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM ' + objectName + ' WHERE ' + parentObjectFieldName + ' =: parentRecordId ORDER BY CreatedDate DESC';
        return Database.query(query);
    }
    
    /* Description: Retrieves a recordtype Id of an object
     * Author: Dan Crisologo              
     * Date Created: OCT-02-2013
     * Input: objectName - Name of object
              recordTypeName - recordtype label
     * return: RecordType - Exception Log object
    */
    public static RecordType getObjectRecordTypeId(String objectName, String recordTypeName) {
        return [Select Id From RecordType  where SobjectType =: objectName and Name =: recordTypeName];
    }
    
    /*  Description: retrieves lists of Related Documents 
     *  Author: Dan Crisologo
     *  Date Created: OCT-02-2013
     *  Input: None
     *  Return: List<Related_Document__c>
     */
    public static List<Related_Document__c> retrieveApplicationRelatedDocuments(Id applicationId) {
        List<Related_Document__c> relatedDocumentList = new List<Related_Document__c>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Related_Document__c.FieldSets.Income_Document_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Related_Document__c WHERE Application__c =: applicationId ORDER BY Document_Category__c ASC, CreatedDate ASC';
        if(applicationId!=null) {
            for(sObject o: Database.query(query)) {
                relatedDocumentList.add((Related_Document__c)o);
            }
        } 
        return relatedDocumentList;
    }
    
    /*  Description: query lists of income ordered by amount
     *  Author: Dan Crisologo
     *  Date Created: FEB-19-2014
     *  Input: applicantId
     *  Return: List<Income__c>
     */
    public static List<Income__c> retrieveIncomeSortedByAmount(Id applicantId) {
        List<Income__c> incomeList = new List<Income__c>();
        String query = 'SELECT Applicant__r.Application__r.Brand_Country__c,';
        for(Schema.FieldSetMember f : SObjectType.Income__c.FieldSets.Income_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Income__c WHERE Applicant__c =: applicantId ORDER BY Total_Income__c DESC, CreatedDate DESC';
        if(applicantId!=null) {
            for(sObject o: Database.query(query)) {
                incomeList.add((Income__c)o);
            }
        } 
        return incomeList;
    }
    
     /*  Description: retrieves ONR records 
     *  Author: Fel Saliba
     *  Date Created: NOV-13-2013
     *  Parameter: Application Id
     *  Return: List<ONR__c>
     */
    public static List<ONR__c> retrieveApplicationONR(Id applicationId) {
        List<ONR__c> relatedONRList = new List<ONR__c>();
        relatedONRList = [Select Id from ONR__c where Application__c =: applicationId
                         AND Type__c =: Gen_originationsconstants.ONR_TYPE_TABLE  
                         AND geID__c =: Gen_originationsconstants.META_ID_PURPOSE_TABLE 
                         Limit 1];
                         
        return relatedONRList;
    }
    /*  Description: retrieves Debit records 
     *  Author: Russell Cadapan
     *  Date Created: NOV-13-2013
     *  Parameter: Application Id
     *  Return: List<ONR__c>
     */
    public static List<Debit__c> retrieveApplicationDebit(Id applicationId) {
        List<Debit__c> relatedDebit = new List<Debit__c>();
        String query = 'SELECT ';
        // Better Start
        query += 'Application__r.Offered_Interest_Rate_Orig__c,Application__r.Loan_Term_Months__c,Application__r.Product_SubType__c,Application__r.EMI_with_Service_Fee__c,Application__r.Offered_Repayments__c,Application__r.Offered_Interest_Rate__c,Application__r.Brand_Country__c,';
        for(Schema.FieldSetMember f : SObjectType.Debit__c.FieldSets.Direct_Debit_Commons.getFields()) {
            query += f.getFieldPath() + ',';
        }
        query = query.subString(0, query.length() - 1); //trim last comma
        query += ' FROM Debit__c WHERE Application__c =: applicationId';
        if(applicationId!=null) {
            for(sObject o: Database.query(query)) {
                relatedDebit.add((Debit__c)o);
            }
        } 
        return relatedDebit;
    }
    
    
    /*  Description: retrieves risk referral Workflow records 
     *  Author: Tony Xu
     *  Date Created: 2015-08-12
     *  Parameter: Application Id
     *  Return: List<Workflow__c>
     */
    public static List<Workflow__c> retrieveWorkflow (Id applicationId) {
        List<Workflow__c> workflowList = new List<Workflow__c>();
        
        if(applicationId != null){
            //We only returns risk referral workflow, with a valid CPU/CMO decision
            workflowList = [SELECT id, recordTypeId, Assigned_To_2__c, Risk_CPU_Decision__c, CPU_Decision_Date_Time__c,
                                   Application__c
                            FROM Workflow__c
                            WHERE Application__c =: applicationId
                            AND recordTypeId =: getObjectRecordTypeId(OBJECTNAME_WORKFLOW, 'Risk Referral').id
                            AND Risk_CPU_Decision__c != ''
                            ORDER BY CPU_Decision_Date_Time__c DESC];
        }
        
        return workflowList;
    }
    
}