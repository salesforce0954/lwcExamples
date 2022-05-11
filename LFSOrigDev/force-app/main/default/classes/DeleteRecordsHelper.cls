/**
 * @Description: Class that handles all the queries to delete data.
 * @Author: Fahad Akhtar (Cloud Sherpas)
 * @Date Created: 29-05-2014
 * @History:
    =====================================================================
       29-05-2014: Created. - Fahad Akhtar
       11-02-2015: Modified. - Lavanya Kavuri - Added Lines 31, 32 (Two new queries to delete records)
       
    =====================================================================
**/
//@istest
public with sharing class DeleteRecordsHelper {
    
    public List<String> queryStringList {get; set;} 
    //public String op {get;set;}

    public DeleteRecordsHelper(String operation) {
        system.debug('operation: '+operation);
        Data_Perge_Settings__c auBillingData = Data_Perge_Settings__c.getValues('AU Billing Data');
        Data_Perge_Settings__c draftDoc = Data_Perge_Settings__c.getValues('Draft Document');
        Data_Perge_Settings__c evolveDraftDoc = Data_Perge_Settings__c.getValues('Evolve Draft Document');
        Data_Perge_Settings__c exceptionLog = Data_Perge_Settings__c.getValues('Exception log');
        Data_Perge_Settings__c nzBillingData = Data_Perge_Settings__c.getValues('NZ Billing Data');
        Data_Perge_Settings__c resolvedAppWSL = Data_Perge_Settings__c.getValues('Resolved App WSL');
        Data_Perge_Settings__c applicantSearch = Data_Perge_Settings__c.getValues('Applicant Search');
        Data_Perge_Settings__c applicantCLV = Data_Perge_Settings__c.getValues('Applicant CLV'); 
        Data_Perge_Settings__c applicantAccount = Data_Perge_Settings__c.getValues('Applicant Account'); 
        Data_Perge_Settings__c submittedApplicationsAU = Data_Perge_Settings__c.getValues('Submitted Applications AU');
        Data_Perge_Settings__c submittedApplicationsNZ = Data_Perge_Settings__c.getValues('Submitted Applications NZ');
        Data_Perge_Settings__c unsubmittedApplicationsAU = Data_Perge_Settings__c.getValues('Un-submitted Applications AU'); 
        Data_Perge_Settings__c unsubmittedApplicationsNZ = Data_Perge_Settings__c.getValues('Un-submitted Applications NZ');
        Data_Perge_Settings__c deactivateUser = Data_Perge_Settings__c.getValues('Deactivate User');
        
        Set<String> appStatus = new Set<String>();
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_CLOSED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_DECLINED);
        appStatus.add(GEN_OriginationsConstants.APP_STATUS_FINALIZED);
        
        String docStatusDraft = GEN_OriginationsConstants.RELATED_DOCUMENT_STATUS_DRAFT;
        String linkTypeEvolve = GEN_OriginationsConstants.RELATED_DOCUMENT_LINKTYPE_EVOLVE;
        String auRegion = GEN_OriginationsConstants.AU_REGION;
        String nzRegion = GEN_OriginationsConstants.NZ_REGION;
        String newAppStatus = GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW;

        queryStringList = new List<String>();

        if(Test.isRunningTest()){
            if(operation == 'New'){
                 queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c, (SELECT id, Email_Address__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),'+
                                            '(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),'+
                                            '(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),'+
                                            '(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),(SELECT id,Title__c FROM Related_Documents__r),'+
                                            '(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r)', 
                                            'Application__c', 
                                            'Status__c =: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: auRegion'));
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c, (SELECT id, Email_Address__c FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),'+
                                            '(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),'+
                                            '(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),'+
                                            '(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),(SELECT id,Title__c FROM Related_Documents__r),'+
                                            '(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r)', 
                                            'Application__c', 
                                            'Status__c =: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: nzRegion'));
            
            }else if(operation == 'Submitted'){
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c',
                                            'Application__c', 
                                            'Status__c !=: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: auRegion'));
            
            
            
                 queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c',
                                            'Application__c',
                                            'Status__c !=: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: nzRegion'));

            }else if(operation == 'Billing'){
                queryStringList.add(queryString('id', 'Related_Document__c', 'Status__c =: docStatusDraft'));
                queryStringList.add(queryString('id', 'Web_Service_Log__c', 'Application__r.Status__c IN: appStatus'));
                queryStringList.add(queryString('id', 'Related_Document__c', 'Status__c =: docStatusDraft AND GE_Link_Type__c =: linkTypeEvolve'));
                queryStringList.add(queryString('id', 'ExceptionLog__c', ''));
                queryStringList.add(queryString('id', 'Applicant_Account__c  ', 'Applicant_CLV__c IN ( SELECT Id FROM Applicant_CLV__C WHERE Applicant__c = null)'));
                //queryStringList.add(queryString('id', 'Applicant_CLV__C ', 'SELECT Id FROM Applicant_CLV__C WHERE Applicant__c = null AND applicant_search__r.CreatedDate < YESTERDAY'));
                queryStringList.add(queryString('id', 'Applicant_CLV__C ', 'Applicant__c = null'));
                queryStringList.add(queryString('id', 'Billing_Genesis__c', 'Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_ICBS__c', 'Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_Vision_Plus__c', 'Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_Genesis__c', 'Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Billing_ICBS__c', 'Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Billing_Vision_Plus__c', 'Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Applicant_Search__c', ''));                                               
                queryStringList.add(queryString('id', 'Applicant_CLV__c', 'Applicant__c != null'));
                queryStringList.add(queryString('id', 'Applicant_Account__c', 'Applicant_CLV__r.Applicant__c != null'));
                //queryStringList.add(queryString('id', 'Billing_Vision_Plus__c', 'Region__c=: nzRegion'));
            }
            
        
        } else {

            if(operation == 'New'){
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c, (SELECT id, Email_Address__c, Account__r.PersonContactId, Account__c, CreatedById FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),'+
                                            '(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),'+
                                            '(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),'+
                                            '(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),(SELECT id,Title__c FROM Related_Documents__r),'+
                                            '(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r)', 
                                            'Application__c', 
                                            'LastModifiedDate < LAST_N_DAYS:'+Integer.ValueOf(unsubmittedApplicationsAU.value__c)+' AND Status__c =: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: auRegion'));
            
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c, (SELECT id, Email_Address__c, Account__r.PersonContactId, Account__c, CreatedById FROM Applicant__r),(SELECT id,Comments__c FROM Credit_File_Checks__r),'+
                                            '(SELECT id,Account_Conduct__c,Collateral__c,Company__c,Contract_Account_No__c,Name_on_Contract__c,Spoke_with__c FROM Credit_Ref_Check__r),'+
                                            '(SELECT id,Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),'+
                                            '(SELECT id,Name__c,Phone_Number__c,Relationship__c FROM Personal_Reference_Checks__r),(SELECT id,Title__c FROM Related_Documents__r),'+
                                            '(SELECT id,Collateral_Eng_No__c,Collateral_HIN_Number__c,Collateral_Insurance_Policy_number__c,Collateral_Insurance_company_name__c,Collateral_NVIC__c,Collateral_Reg_No__c,Collateral_State_of_Registration__c,Collateral_VIN_No__c FROM Collaterals__r)', 
                                            'Application__c', 
                                            'LastModifiedDate < LAST_N_DAYS:'+Integer.ValueOf(unsubmittedApplicationsNZ.value__c)+' AND Status__c =: newAppStatus '+
                                            'AND Brand_Lookup__r.Country__c =: nzRegion'));
            }else if(operation == 'Submitted'){

               
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c',
                                                'Application__c',
                                                'LastModifiedDate < LAST_N_DAYS:'+Integer.ValueOf(submittedApplicationsAU.value__c)+' AND Status__c !=: newAppStatus '+
                                                'AND Brand_Lookup__r.Country__c =: auRegion'));
                
               
                
                queryStringList.add(queryString('id, LastModifiedDate, Status__c, Brand_Lookup__r.Country__c',
                                                'Application__c',
                                                'LastModifiedDate < LAST_N_DAYS:'+Integer.ValueOf(submittedApplicationsNZ.value__c)+' AND Status__c !=: newAppStatus '+
                                                'AND Brand_Lookup__r.Country__c =: nzRegion'));

            }else if(operation == 'Billing'){
                queryStringList.add(queryString('id', 'Related_Document__c', 'CreatedDate < LAST_N_DAYS:'       + Integer.ValueOf(draftDoc.value__c)        +' AND Status__c =: docStatusDraft'));
                queryStringList.add(queryString('id', 'Web_Service_Log__c', 'CreatedDate < LAST_N_DAYS:'        + Integer.ValueOf(resolvedAppWSL.value__c)  +' AND Application__r.Status__c IN: appStatus'));
                queryStringList.add(queryString('id', 'Related_Document__c', 'CreatedDate < LAST_N_DAYS:'       + Integer.ValueOf(evolveDraftDoc.value__c)  +' AND Status__c =: docStatusDraft AND GE_Link_Type__c =: linkTypeEvolve'));
                queryStringList.add(queryString('id', 'ExceptionLog__c', 'CreatedDate < LAST_N_DAYS:'           + Integer.ValueOf(exceptionLog.value__c)    + ''));
                queryStringList.add(queryString('id', 'Applicant_Account__c  ', 'Applicant_CLV__c IN ( SELECT Id FROM Applicant_CLV__C WHERE Applicant__c = null AND applicant_search__r.CreatedDate < YESTERDAY )'));
                queryStringList.add(queryString('id', 'Applicant_CLV__C ', 'Applicant__c = null AND applicant_search__r.CreatedDate < YESTERDAY'));
                queryStringList.add(queryString('id', 'Billing_Genesis__c', 'LastModifiedDate < LAST_N_DAYS:'        + Integer.ValueOf(auBillingData.value__c)   + ' AND Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_ICBS__c', 'LastModifiedDate < LAST_N_DAYS:'           + Integer.ValueOf(auBillingData.value__c)   + ' AND Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_Vision_Plus__c', 'LastModifiedDate < LAST_N_DAYS:'    + Integer.ValueOf(auBillingData.value__c)   + ' AND Region__c=: auRegion'));
                queryStringList.add(queryString('id', 'Billing_Genesis__c', 'LastModifiedDate < LAST_N_DAYS:'        + Integer.ValueOf(nzBillingData.value__c)   + ' AND Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Billing_ICBS__c', 'LastModifiedDate < LAST_N_DAYS:'           + Integer.ValueOf(nzBillingData.value__c)   + ' AND Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Billing_Vision_Plus__c', 'LastModifiedDate < LAST_N_DAYS:'    + Integer.ValueOf(nzBillingData.value__c)   + ' AND Region__c=: nzRegion'));
                queryStringList.add(queryString('id', 'Applicant_Search__c', 'LastModifiedDate < LAST_N_DAYS:'       + Integer.ValueOf(applicantSearch.value__c) + ''));                                               
                queryStringList.add(queryString('id', 'Applicant_CLV__c', '(Applicant__c != null and Applicant__r.Application__r.LastModifiedDate < LAST_N_DAYS:'+ Integer.ValueOf(applicantCLV.value__c)    +')  OR LastModifiedDate < LAST_N_DAYS:'          + Integer.ValueOf(applicantCLV.value__c)    + ''));
                queryStringList.add(queryString('id', 'Applicant_Account__c', '(Applicant_CLV__r.Applicant__c != null and Applicant_CLV__r.Applicant__r.Application__r.LastModifiedDate < LAST_N_DAYS:'+ Integer.ValueOf(applicantCLV.value__c)    +') OR LastModifiedDate < LAST_N_DAYS:'      + Integer.ValueOf(applicantAccount.value__c)    + ''));
            
            }
        }

        for(String s : queryStringList){
            system.debug('Query String ' + s);
                
        }
    }

    /*  Description: return a query from the list
     *  Author: Fahad Akhtar
     *  Date Created: 30-05-2014
     *  Input: index -
     *  Return: String 
     */
    public string getQuery(integer index) {
        return queryStringList[index];
    }

    /*  Description: Generic method to create queries as query strings.
     *  Author: Fahad Akhtar
     *  Date Created: 29-05-2014
     *  Input: id -
               objectName -
               filter -
     *  Return: String 
     */
    private string queryString (String id, String objectName, String filter) {
        String query = 'SELECT ';
        query += id;

        if(filter != ''){
            query += ' FROM ' + objectName + ' WHERE '  + filter;
        } else {
            query += ' FROM ' + objectName;
        }
        return query;
    }

}