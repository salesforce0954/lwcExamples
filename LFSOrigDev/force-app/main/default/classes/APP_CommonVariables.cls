/*
 * @Description: Variable holder for app common class
 * @Author: Dan Crisologo    
 * @Date Created: Feb-24-2014
 * @History:
   =====================================================================
       Jade - 17-Dec-13: Created
   =====================================================================
 */
public class APP_CommonVariables {

    private static Application__c application;
    private static Applicant__c priApplicant;
    private static Applicant__c secApplicant;
    
    @TestVisible private static List<Applicant__c> applicantList;
    
    private static List<Schema.FieldSetMember> applicantFieldSet;
    private static List<Schema.FieldSetMember> amlFieldSet;
    private static List<Schema.FieldSetMember> assetFieldSet;
    private static List<Schema.FieldSetMember> expenseFieldSet;
    private static List<Schema.FieldSetMember> incomeFieldSet;
    private static List<Schema.FieldSetMember> liabilityFieldSet;
    private static List<Schema.FieldSetMember> relateddocumentFieldSet;
    private static map<string,string> applicationTypeMap;
    private static map<string,string> applicationBusinessMap;
    
    /*  Description: Construct picklist values for product eligibility
     *  Author: Vijay
     *  Date Created: FEB-23-2015
     *  Input: None
     *  Return: Map<String,String>
     */
    public static map<string,string> retreiveAppMaps(string mapType,string country){
        applicationTypeMap=new map<string,string>();
        applicationBusinessMap=new map<string,string>();
        if(mapType=='BS'){
            if(country=='AU'){
                applicationBusinessMap.put('PL S2S','PL S2S');                
                applicationBusinessMap.put('Inbound Call','Inbound Call');
                applicationBusinessMap.put('Cards S2S','Cards S2S');                
                applicationBusinessMap.put('Outbound Call','Outbound Call');
                //applicationBusinessMap.put('Aussie Personal Loans – PL Sales (Skill 30)','Aussie Personal Loans – PL Sales (Skill 30)');
                //applicationBusinessMap.put('Aussie Personal Loan – PL Service (Skill 34)','Aussie Personal Loan – PL Service (Skill 34)');
                //applicationBusinessMap.put('Aussie Personal Loan Short Form','Aussie Personal Loan Short Form');
                //applicationBusinessMap.put('Aussie Personal Loan Long Form','Aussie Personal Loan Long Form');
                applicationBusinessMap.put('Internet','Internet');
                applicationBusinessMap.put('BROKER LOAN','BROKER LOAN');
                applicationBusinessMap.put('Broker','Broker'); 
                applicationBusinessMap.put('RateSetter','RateSetter');
                /* ADDED BY ARSHAD FOR UNIQUE 3RD PARTY URL */
                applicationBusinessMap.put('NewReferrer','NewReferrer');
                /* END BY ARSHAD*/                 
                applicationBusinessMap.put('SocietyOne','SocietyOne'); 
                applicationBusinessMap.put('Veda Quote','Veda Quote');  // Added by RCADAPAN for TQLQW-489 - new business source for Veda Application
                applicationBusinessMap.put('PicStarter','PicStarter');      //TQLQW-481 [PL - AU] PicStarter - MDAVID 
            }
            if(country=='NZ'){
                /**TXU
                applicationBusinessMap.put('Inbound Phone','Inbound Phone');
                applicationBusinessMap.put('Outbound Phone','Outbound Phone');
                applicationBusinessMap.put('Mail','Mail');
                applicationBusinessMap.put('E-mail','E-mail');
                applicationBusinessMap.put('Fax','Fax');
                applicationBusinessMap.put('Third Party Mailing','Third Party Mailing');
                applicationBusinessMap.put('Advertising','Advertising');
                applicationBusinessMap.put('Dealer Referral','Dealer Referral');
                applicationBusinessMap.put('Broker','Broker');
                applicationBusinessMap.put('Internet','Internet');
                applicationBusinessMap.put('Converted customers','Converted customers');**/
                applicationBusinessMap.put('Inbound Phone','Inbound Phone');
                applicationBusinessMap.put('Outbound Phone','Outbound Phone');
                applicationBusinessMap.put('Online Application','Online Application');
                /* ADDED BY ARSHAD FOR UNIQUE 3RD PARTY URL */
                applicationBusinessMap.put('RateSetter','RateSetter');                
                applicationBusinessMap.put('NewReferrer','NewReferrer');
                /* END BY ARSHAD*/                   
            }
        return applicationBusinessMap;
        }
        if(mapType=='AT'){
            if(country=='AU'){
                
                applicationTypeMap.put('CUSTOMER REFERRAL','CUSTOMER REFERRAL');
                applicationTypeMap.put('ALL OTHERS','ALL OTHERS');
                applicationTypeMap.put('FORMER LOAN','FORMER LOAN');
                applicationTypeMap.put('REFINANCE NO CASH','REFINANCE NO CASH');
                applicationTypeMap.put('REFINANCE CASH','REFINANCE CASH');
                applicationTypeMap.put('ADVERTISING','ADVERTISING');
                applicationTypeMap.put('60Day Certificate AU','60Day Certificate AU');
                applicationTypeMap.put('LFS CARD NEW BUSINESS','LFS CARD NEW BUSINESS');
                applicationTypeMap.put('INTERNET APPLICATION','INTERNET APPLICATION');
                applicationTypeMap.put('GE CARD NEW BUSINESS',GEN_OriginationsConstants.BRAND_NAME_GEMONEY+' CARD NEW BUSINESS');       //MLASALA: 24-MAR-16 TQLQW-127 Re-brand 
                applicationTypeMap.put('BROKER LOAN','BROKER LOAN');
               // applicationTypeMap.put('WL INTERNET APPLICATION','WL INTERNET APPLICATION');
               // applicationTypeMap.put('WL INTERNET APPLICATION - STAFF','WL INTERNET APPLICATION - STAFF');
                //applicationTypeMap.put('WL FAX APPLICATION','WL FAX APPLICATION');
               // applicationTypeMap.put('WL PHONE APPLICATION INBOUND','WL PHONE APPLICATION INBOUND');
                //applicationTypeMap.put('WL PHONE APPLICATION OUTBOUND','WL PHONE APPLICATION OUTBOUND');
                //applicationTypeMap.put('WL BROKER APPLICATION','WL BROKER APPLICATION');
                //applicationTypeMap.put('WL BROKER INTERNET REFERRAL','WL BROKER INTERNET REFERRAL');
                //applicationTypeMap.put('WL BROKER FAX REFERRAL','WL BROKER FAX REFERRAL');
                applicationTypeMap.put('PicStarter Outbound Lead','PicStarter Outbound Lead'); // Added by RCADAPAN for TQLQW-489 - new application type for Veda and PicStarter (currently turned off)
                applicationTypeMap.put('Quote Outbound Lead','Quote Outbound Lead');  // Added by RCADAPAN for TQLQW-489 - new application type for Veda and PicStarter
            }
            if(country=='NZ'){
                /*
                applicationTypeMap.put('CUSTOMER SERVICE ENQUIRY','CUSTOMER SERVICE ENQUIRY');
                applicationTypeMap.put('DIRECT MAIL','DIRECT MAIL');
                applicationTypeMap.put('PRINT','PRINT');
                applicationTypeMap.put('NAME REMOVAL REQUEST','NAME REMOVAL REQUEST');
                applicationTypeMap.put('UNPROMPTED','UNPROMPTED');
                applicationTypeMap.put('OUTBOUND CAMPAIGN EXISTING CUSTOMERS','OUTBOUND CAMPAIGN EXISTING CUSTOMERS');
                applicationTypeMap.put('RADIO','RADIO');
                applicationTypeMap.put('REFERRAL','REFERRAL');
                applicationTypeMap.put('STAFF/SUPPLIER OFFER','STAFF/SUPPLIER OFFER');*/
                applicationTypeMap.put('INTERNET','INTERNET');
                applicationTypeMap.put('TV','TELEVISION AD');
                applicationTypeMap.put('Direct Mail – Conditional Offer','Direct Mail – Conditional Offer');
                applicationTypeMap.put('Direct Mail – General Offer','Direct Mail – General Offer');     
                applicationTypeMap.put('Email enquiry','Email enquiry');        
                applicationTypeMap.put('Service to Sales','Service to Sales');
                applicationTypeMap.put('Graduate Loans','Graduate Loans');
                applicationTypeMap.put('Hardship','Hardship');
                applicationTypeMap.put('Kiwibank Branch','Kiwibank Branch');
                applicationTypeMap.put('Kiwibank Debt Elsewhere','Kiwibank Debt Elsewhere');
                applicationTypeMap.put('Marketing Other','Marketing Other');
                applicationTypeMap.put('Radio','Radio');
                applicationTypeMap.put('Spilt endz (Retention)','Spilt endz (Retention)');
                applicationTypeMap.put('Staff Loans','Staff Loans');
                applicationTypeMap.put('Third Party Mailing','Third Party Mailing');
                applicationTypeMap.put('Trade Me','Trade Me');
                applicationTypeMap.put('60 DAY CERTIFICATE','60 DAY CERTIFICATE');
            }
        return applicationTypeMap;
        }
        return null;
    }
    
    /*  Description: retrieves the static application record
     *  Author: Dan Crisologo
     *  Date Created: FEB-24-2014
     *  Input: None
     *  Return: Application__c
     */
    public static Application__c retrieveApplication(Id applicationId) {

        if(applicationId!=null) {
            if(application!=null) {
                if(application.Id==applicationId) {
                    return application;
                } else {
                    application = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
                }
            } else {
                application = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
            }
        }

        System.debug('!@#application: '+application);
        return application;
    }
    
    /*  Description: sets the new static application record
     *  Author: Dan Crisologo
     *  Date Created: MAR-11-2014
     *  Input: app -- application object to set
     *  Return: None
     */
    public static void setApplication(Application__c app) {
        application = app;
    }
    
    
    /*  Description: retrieves applicant record with all its related lists
     *  Author: Mat Isidro
     *  Date Created: March 6, 2014
     *  Input: applicationId -- Id of the application record to sQuery
     *  Return: List of Applicant__c with its related list
     */
     
    public static List<Applicant__c> retrieveApplicants(String applicationId){
        if(applicationId != null) {
            applicantList = retrieveQueryFromApplicantAndRelatedLists(applicationId); 
            system.debug('@@@applicantList: ' + applicantList);           
        }
        return applicantList;
    }    
    
    public static List<Applicant__c> retrieveQueryFromApplicantAndRelatedLists(String parentRecordId) {
        // TEST
        if (applicantList != null) {
            return applicantList;   
        }
        // END TEST
        
        String sQuery = '';
        
        sQuery += retrieveQueryFromApplicantFields();
        
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantAMLFields();
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantAssetFields();
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantExpsenseFields();
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantIncomeFields();
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantLiabilityFields();
        sQuery = sQuery + ', ' + retrieveQueryFromApplicantRelatedDocumentFields();
        
        sQuery += ' From Applicant__c where Application__c ' + '=: parentRecordId ORDER BY CreatedDate ASC';

        System.debug('###sQuery: ' + sQuery);
        return Database.query(sQuery);
    }
    
    public static String retrieveQueryFromApplicantFields() {
        String sQuery = 'SELECT ';
        for(Schema.FieldSetMember f : retrieveApplicantFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        //sQuery += ' FROM Applicant__c)';
        return sQuery;
    }    
    
    public static String retrieveQueryFromApplicantAMLFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveAMLFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM AMLs__r)';
        return sQuery;
    }
    
    public static String retrieveQueryFromApplicantAssetFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveAssetFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM Assets__r)';
        return sQuery;
    }
    
    public static String retrieveQueryFromApplicantExpsenseFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveExpenseFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM Expenses__r)';
        return sQuery;
    }        

    public static String retrieveQueryFromApplicantIncomeFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveIncomeFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM Incomes__r)';
        return sQuery;
    }
    
    public static String retrieveQueryFromApplicantLiabilityFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveLiabilityFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM Liabilities__r)';
        return sQuery;
    }
    
    public static String retrieveQueryFromApplicantRelatedDocumentFields() {
        String sQuery = '(SELECT ';
        for(Schema.FieldSetMember f : retrieveRelatedDocumentFields()) {
            sQuery += f.getFieldPath() + ',';
        }
        sQuery = sQuery.subString(0, sQuery.length() - 1); //trim last comma
        sQuery += ' FROM Related_Documents__r)';
        return sQuery;
    }
    
    public static List<Schema.FieldSetMember> retrieveApplicantFields() {
        if (applicantFieldSet == null) {
            applicantFieldSet = SObjectType.Applicant__c.FieldSets.Applicant_Commons.getFields();
        }
        return applicantFieldSet;
    }      
            
    public static List<Schema.FieldSetMember> retrieveAMLFields() {
        if (amlFieldSet == null) {
            amlFieldSet = SObjectType.AML__c.FieldSets.AML_Commons.getFields(); 
        }
        return amlFieldSet;
    }   
    
    public static List<Schema.FieldSetMember> retrieveAssetFields() {
        if (assetFieldSet == null) {
            assetFieldSet = SObjectType.Asset__c.FieldSets.Asset_Commons.getFields();   
        }
        return assetFieldSet;
    }   
    
    public static List<Schema.FieldSetMember> retrieveExpenseFields() {
        if (expenseFieldSet == null) {
            expenseFieldSet = SObjectType.Expense__c.FieldSets.Expense_Commons.getFields();
        }
        return expenseFieldSet;     
    }   
    
    public static List<Schema.FieldSetMember> retrieveIncomeFields() {
        return SObjectType.Income__c.FieldSets.Income_Commons.getFields();
    }   
    
    public static List<Schema.FieldSetMember> retrieveLiabilityFields() {
        if (liabilityFieldSet == null) {
            liabilityFieldSet = SObjectType.Liability__c.FieldSets.Liability_Commons.getFields();
        }
        return liabilityFieldSet;           
    }   
    
    public static List<Schema.FieldSetMember> retrieveRelatedDocumentFields() {
        if (relatedDocumentFieldSet == null) {
            relatedDocumentFieldSet = SObjectType.Related_Document__c.FieldSets.Income_Document_Commons.getFields();
        }
        return relatedDocumentFieldSet;     
    }    
        
        
    public static Decimal getBlendedRateSingleRefinance(Decimal dInterestFromCurrentLoan, Decimal dAmountNetPayoffDue,  Decimal dNewInterestRate, Decimal dNewCashAmount) {
        Decimal dTotalAmount = dAmountNetPayoffDue + dNewCashAmount;    
        Decimal dCurrentInterest =  dAmountNetPayoffDue * dInterestFromCurrentLoan / 100;
        Decimal dNewInterest = dNewCashAmount * dNewInterestRate / 100; 
        Decimal dTotalInterest = dCurrentInterest + dNewInterest;
        Decimal dBlendedRate = dTotalInterest / dTotalAmount;               
        return dBlendedRate;
    }  


    public class BlendedRateWrapper {
        

    }    

    
    /*  Description: retrieves the static application record
     *  Author: Dan Crisologo
     *  Date Created: FEB-24-2014
     *  Input: None
     *  Return: Application__c
     */
    /*public static Applicant__c retrieveApplicants(Id applicationId) {

        if(applicationId!=null) {
            if(application!=null) {
                if(application.Id==applicationId) {
                    return application;
                } else {
                    application = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
                }
            } else {
                application = GEN_RecordRetrievalUtility.retrieveApplication(applicationId);
            }
        }

        return application;
    }*/

}