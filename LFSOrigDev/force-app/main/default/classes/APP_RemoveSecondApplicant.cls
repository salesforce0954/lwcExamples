/**
 * @Description: Class used for removing applicant 2.
 * @Author: Fel Saliba
 * @Date Created: JANUARY-30-2014
 * @History:
   =====================================================================
        JAN-30 (Fel): Created.
        FEB-10 (Mac): Updated. Added update on Application Response and Modoified Application Type when Applicant is removed.
   =====================================================================
 */ 
 
public class APP_RemoveSecondApplicant{

    //===============================================================
    //                       PUBLIC METHODS
    //===============================================================
    
    /*  Description: Method that handles the update of the application. Deleting of applicant 2 and applicant 2 related records.
     *  Author: Fel Saliba
     *  Input: IS_ApplicationDTO
     *  Return: void
     */

    public void deleteApplicantRecord(IS_ApplicationDTO applicationDTO){
    
        //check for Applicant_CLV__c records associated with applicant 2.
        List<Applicant_CLV__c> deleteCLVList = new List<Applicant_CLV__c>();
        deleteCLVList = [Select Id from Applicant_CLV__c where Applicant__c =: applicationDTO.applicant2.Id];

        //check for Application Response record associated with the application.
        List<Application_Response__c> updApplicationResponse = new List<Application_Response__c>();
        List<Application_Response__c> updAppRes = [Select Id, Response_Code__c from Application_Response__c where Application__c =: applicationDTO.app.Id order by CreatedDate DESC Limit 1];
        if(updAppRes.size() > 0){
            for(Application_Response__c a : updAppRes){
                a.Response_Code__c = GEN_OriginationsConstants.APPLICANT_REMOVED;
                updApplicationResponse.add(a);
            }
        }
        System.debug('##### updApplicationResponse ' + updApplicationResponse);
        //check for Income__c records associated with applicant 2.
        List<Income__c> deleteIncomeList = new List<Income__c>();
        deleteIncomeList = [Select Id from Income__c where Applicant__c =: applicationDTO.applicant2.Id];
        
        //check for Expense__c records associated with applicant 2.
        List<Expense__c> deleteExpenseList = new List<Expense__c>();
        deleteExpenseList = [Select Id from Expense__c where Applicant__c =: applicationDTO.applicant2.Id];
        
        //check for AML__c records associated with applicant 2.
        List<AML__c> deleteAMLList = new List<AML__c>();
        deleteAMLList = [Select Id from  AML__c where Applicant__c =: applicationDTO.applicant2.Id];
        
        //check for Credit_File_Check__c records associated with applicant 2.
        List<Credit_File_Check__c> deleteCreditFileList = new List<Credit_File_Check__c>();
        deleteCreditFileList = [Select Id from  Credit_File_Check__c where Applicant__c =: applicationDTO.applicant2.Id];

        List<Disbursement__c> disList = new List<Disbursement__c>();
        List<Disbursement__c> updDisList = new List<Disbursement__c>();
        disList = [SELECT Id, Applicable_Party__c,Application__c,RecordTypeId,Record_Type_Name__c FROM Disbursement__c where Application__c = :applicationDTO.app.Id AND
                    (Record_Type_Name__c = :GEN_OriginationsConstants.GE_CARD_CLOSURE_INTEREST_FREE OR 
                    Record_Type_Name__c = :GEN_OriginationsConstants.GE_CARD_CLOSURE_WITHOUT_INTEREST_FREE OR
                    Record_Type_Name__c = :GEN_OriginationsConstants.NON_GE_CARD_OVERDRAFT_CLOSURE OR
                    Record_Type_Name__c = :GEN_OriginationsConstants.GE_CARD_LIMIT_REDUCTION OR
                    Record_Type_Name__c = :GEN_OriginationsConstants.NON_GE_CARD_OVERDRAFT_LIMIT_REDUCTION OR
                    Record_Type_Name__c = :GEN_OriginationsConstants.REFINANCE_GE_PERSONAL_LOAN) AND
                    (Applicable_Party__c = :GEN_OriginationsConstants.APPLICANT_2 OR
                    Applicable_Party__c = :GEN_OriginationsConstants.BOTH)];
        
        if(disList.size() > 0){
            for(Disbursement__c d : disList){
                d.Applicable_Party__c = GEN_OriginationsConstants.APPLICANT_1;
                updDisList.add(d);
            }    
        }
        
        
        /**** Check for the list size before deleting. ****/
        //Update all Disbursement Records for Applicant 2 or Both
        if(!updDisList.isEmpty()){
            try{
                update updDisList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Disbursement__c', 'Class');    
            }
        }
        //Applicant_CLV__c List
        if(!deleteCLVList.isEmpty()){            
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Applicant_CLV__c.sObjectType.getDescribe().isDeletable()){
                    delete deleteCLVList;
                }
                */
                delete deleteCLVList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Applicant_CLV__c', 'Class');    
            }
        }

        //Insert new Application Response
        try{
            if(updApplicationResponse.size()>0){
                update updApplicationResponse;    
            }            
        }
        catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'App_RemoveSecondApplicant', 'Application_Response__c', 'Class');
        }
       
        
        //Income__c List
        if(!deleteIncomeList.isEmpty()){            
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Income__c.sObjectType.getDescribe().isDeletable()){
                    delete deleteIncomeList;
                }
                */
                delete deleteIncomeList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Income__', 'Class');    
            }
        }
        
        //Expenses__c List
        if(!deleteExpenseList.isEmpty()){            
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Expense__c.sObjectType.getDescribe().isDeletable()){
                    delete deleteExpenseList;
                }
                */
                delete deleteExpenseList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Expenses__c', 'Class');    
            }
        }
        
        //AML__c List
        if(!deleteAMLList.isEmpty()){            
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(AML__c.sObjectType.getDescribe().isDeletable()){
                    delete deleteAMLList;
                }
                */
                delete deleteAMLList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'AML__c', 'Class');    
            }
        }
        
        //Credit_File_Check__c List
        if(!deleteCreditFileList.isEmpty()){            
            try{
                /*CHECKMARX
                // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
                if(Credit_File_Check__c.sObjectType.getDescribe().isDeletable()){
                    delete deleteCreditFileList;
                }
                */
                delete deleteCreditFileList;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Credit_File_Check__c', 'Class');    
            }
        }
        
        //Delete Applicant 2
        if(applicationDTO.applicant2 != null){            
            try{
                delete applicationDTO.applicant2;
            }
            catch(DMLException e){
                    ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Applicant__c', 'Class');    
            }
        }
        //Check for Asset records to update the Applicable Party        
        List<Asset__c> assetList = new List<Asset__c>();
        assetList = [Select Id, Applicable_Party__c from Asset__c where Applicant__c =: applicationDTO.applicant.Id OR Applicant__c =: applicationDTO.applicant2.Id];
        try{
            if(!assetList.isEmpty()){
                List<Asset__c> aList = new List<Asset__c>();
                for(Asset__c a : assetList){
                    a.Applicable_Party__c = '';    
                    aList.add(a);
                }            
                update aList;
            }
        }
        catch(Exception e){
             ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Applicant__c', 'Class');
        }
        

        List<Liability__c> debtList = new List<Liability__c>();
        debtList = [Select Id, Applicable_Party__c from Liability__c where Applicant__c =: applicationDTO.applicant.Id OR Applicant__c =: applicationDTO.applicant2.Id];
        try{
            if(!debtList.isEmpty()){
                List<Liability__c> liabList = new List<Liability__c>();
                for(Liability__c l : debtList){
                    l.Applicable_Party__c = '';    
                    liabList.add(l);
                }            
                update liabList;
            }
        }
        catch(Exception e){
            ErrorHandlerException.recordExceptionStack(e.getMessage(), e.getStackTraceString(), 'APP_RemoveSecondApplicant', 'Applicant__c', 'Class');
        }        

        //Update Application record        
        //Set Status to New.
        if(!updAppRes.isEmpty()){            
            applicationDTO.app.Response_Code__c = GEN_OriginationsConstants.APPLICANT_REMOVED;
        }
        applicationDTO.app.Status__c = 'New';
        applicationDTO.app.Application_Type__c = 'Single';
        applicationDTO.app.Applicant_2_Name__c = '';
        
        try{
            update applicationDTO.app;
            System.debug('***UPDATING APPLICATION' + applicationDTO.app);
        }
        catch(DMLException e){
                ErrorHandlerException.recordException(e.getMessage(), 'APP_RemoveSecondApplicant', 'Application__c', 'Class', String.valueOf(applicationDTO.app.Id));    
        }       
               
    }
}