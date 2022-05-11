/**
 * @Description: Class to perge applicaiton data
 * @Author: Fahad Akhtar (Cloud Sherpas)
 * @Date Created: 06-03-2015
 * @History: Added Sales & leads billing object Queries with Custom Settings for number of days      
    =====================================================================
       29-05-2014: Created. - Fahad Akhtar
    =====================================================================
**/
public with sharing class AppDataPergeHandler{
    /*  Description: Generic method to create queries as query strings.
     *  Author: Fahad Akhtar
     *  Date Created: 06-03-2015
     *  Input: list<Application>
     *  Return:  
     */ 
    public static void AppDataPergeHandler(List<Application__c> lst_App){
        List<Application__c> lst_NotSubmittedApplicaitonsToDelete =  new List<Application__c>();
        List<Application__c> lst_ApplicationToProcess = new List<Application__c>();
        List<String> lst_Username = new List<String>();
        List<Applicant__c> lst_applicantUnsubmitted = new List<Applicant__c>();
        List<Applicant__c> lst_applicantSubmitted = new List<Applicant__c>();
        Set<Id> newApplicationIds = new Set<Id>();
        Set<Id> processApplicationIds = new Set<Id>();

        Data_Perge_Settings__c deactivateUser = Data_Perge_Settings__c.getValues('Deactivate User');

        Application__c app;
        //Seprate not submitted record and delete
        for(Sobject a : lst_App){
            app = (Application__c)a;
            //Check if the application is not submitted and delete application and its data.
            if(app.Status__c == GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
                lst_NotSubmittedApplicaitonsToDelete.add(app);  
            }
            //Check if the applicattion is submmited and has been inactive for a long time.
            if(app.Status__c != GEN_OriginationsConstants.APP_RESPONSE_CODE_NEW){
                lst_ApplicationToProcess.add(app);
            }
        }
        

        //Delete non submitted data
        if(lst_NotSubmittedApplicaitonsToDelete.size() > 0){
            deleteApplicaitonAndRelatedData(lst_NotSubmittedApplicaitonsToDelete);
        }
        
        //Update submitted data
        if(lst_ApplicationToProcess.size() > 0){
            flushTokenizedData(lst_ApplicationToProcess);
        }

    }
    
    /*  Description: Delete applications which are not submitted.
     *  Author: Fahad Akhtar
     *  Date Created: 10-03-2015
     *  Input: list<Application>
     *  Return:  
     */     
    public static void deleteApplicaitonAndRelatedData(List<Application__c> lst_app){

        /*  
            Deletion of the application object will delete, the following
            *Applicant -- > AML,Applicant Account Customer,Asset,Contract Acceptance,Expense,(Income --> Income Capacity),Liability
            *Application Response
            *Compliance Check
            *Credit File Check
            *Credit Ref Check
            *Debit
            *Decision
            *Disbursement -- > Disbursement Plan
            *Loan Purpose
            *Outbound Communication
            *Personal Reference Check
            *Related Document
            *Requested Document
            *Security
            *Workflow
        */                                  

        List<Offer_Presented__c> lst_OfferPresented = [
                                                            SELECT 
                                                                    id
                                                            FROM 
                                                                    Offer_Presented__c
                                                            WHERE
                                                                    Application_Response__r.Application__c IN:lst_app   
                                                        ];

        List<Audit_Log__c> lst_auditLog = [
                                                SELECT 
                                                        id
                                                FROM
                                                        Audit_Log__c
                                                WHERE
                                                        Audit_Application__c IN:lst_app                                                         
                                            ];


        List<Debug_Log__c> lst_debugLog = [
                                                SELECT 
                                                        id
                                                FROM
                                                        Debug_Log__c
                                                WHERE
                                                        Application__c IN:lst_app                                                       
                                            ];

        
        delete  lst_app;
        if(lst_OfferPresented.size() > 0)
            delete lst_OfferPresented;
        if(lst_auditLog.size() > 0)
            delete lst_auditLog;
        if(lst_debugLog.size() > 0)
            delete lst_debugLog;                                                        
    }

    /*  Description: update applications and its related data which submitted and above
     *  Author: Fahad Akhtar
     *  Date Created: 10-03-2015
     *  Input: list<Application>
     *  Return:  
     */
    public static void flushTokenizedData(list<application__c> lst_application){
        //Generic list update record of application and applicant.
        List<Sobject> lst_recordsToUpdate = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate2 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate3 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate4 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate5 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate6 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate7 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate8 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate9 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate10 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate11 = new List<Sobject>();
        List<Sobject> lst_recordsToUpdate12 = new List<Sobject>();
        
        //Query child records
        List<Application__c> lst_application2 = [SELECT id, Status__c, Brand_Lookup__r.Country__c, 
        (SELECT id, Email_Address__c FROM Applicant__r),
        (SELECT id, Comments__c FROM Credit_File_Checks__r),
        (SELECT id, Account_Conduct__c, Collateral__c, Company__c, Contract_Account_No__c, Name_on_Contract__c, Spoke_with__c FROM Credit_Ref_Check__r),
        (SELECT id, Account_Holders__c FROM Debits__r),(SELECT id,Bank_Acc_No__c,Payee__c FROM Disbursements__r),
        (SELECT id, Name__c, Phone_Number__c, Relationship__c FROM Personal_Reference_Checks__r),
        (SELECT id, Title__c FROM Related_Documents__r),
        (SELECT id, Collateral_Eng_No__c, Collateral_HIN_Number__c, Collateral_Insurance_Policy_number__c, Collateral_Insurance_company_name__c, Collateral_NVIC__c, Collateral_Reg_No__c, Collateral_State_of_Registration__c, Collateral_VIN_No__c FROM Collaterals__r) 
        FROM Application__c WHERE id IN: lst_application];
        
        //List of applicant
        List<Applicant__c> lst_Applicant = [
                                            SELECT 
                                                    id,
                                                    (SELECT id,ID_No__c,Staff_ID_Sighted_By__c FROM AMLs__r),
                                                    (SELECT id, Agent_Landlord_Name__c, Agent_Landlord_Phone_Number__c FROM Expenses__r), 
                                                    (SELECT id, Emp_Bus_Contact_No__c, Emp_Bus_Name__c FROM Incomes__r)
                                            FROM 
                                                    Applicant__c 
                                            WHERE 
                                                    Application__c IN: lst_application
                                            ];
        
        for(application__c a : lst_application2){
            //Remove tokenized data on applicaiton fields.
            a.Applicant_2_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            a.Applicant_1_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            a.FP_IP_Address__c =    GEN_OriginationsConstants.TOKEN_VALUE;
            a.Status__c = GEN_OriginationsConstants.APPLICATION_WORKFLOW_ARCHIVED;
            a.Response_Code__c = GEN_OriginationsConstants.APPLICATION_RESPONSE_PURGED;
            lst_recordsToUpdate.add(a);

            //Remove tokenized data on credit file ckecks.
            for(Credit_File_Check__c creditFileCheck : a.Credit_File_Checks__r){            
                creditFileCheck.Comments__c = GEN_OriginationsConstants.TOKEN_VALUE;
                lst_recordsToUpdate2.add(creditFileCheck);   
            }
            //Remove tokenized data on credit reference check.
            for(Credit_Ref_Check__c creditRefCheck : a.Credit_Ref_Check__r){            
                creditRefCheck.Account_Conduct__c = GEN_OriginationsConstants.TOKEN_VALUE;
                creditRefCheck.Collateral__c = GEN_OriginationsConstants.TOKEN_VALUE;
                creditRefCheck.Company__c = GEN_OriginationsConstants.TOKEN_VALUE;
                creditRefCheck.Contract_Account_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                creditRefCheck.Name_on_Contract__c = GEN_OriginationsConstants.TOKEN_VALUE;
                creditRefCheck.Spoke_with__c = GEN_OriginationsConstants.TOKEN_VALUE;               
                lst_recordsToUpdate3.add(creditRefCheck);    
            }
            //Remove tokenized data on Debit
            for(Debit__c debit : a.Debits__r){          
                debit.Account_Holders__c = GEN_OriginationsConstants.TOKEN_VALUE;               
                lst_recordsToUpdate4.add(debit); 
            }           
            //Remove tokenized data on Disbursments
            for(Disbursement__c disbursement : a.Disbursements__r){         
                if(disbursement.Bank_Acc_No__c != '')
                    disbursement.Bank_Acc_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                if(disbursement.Bank_Acc_No_NZ__c != '')
                    disbursement.Bank_Acc_No_NZ__c = GEN_OriginationsConstants.TOKEN_VALUE;
                disbursement.Payee__c = GEN_OriginationsConstants.TOKEN_VALUE;              
                lst_recordsToUpdate5.add(disbursement);  
            }

            //Remove tokenized data on Personal Refrence Check
            for(Personal_Reference_Check__c perRefCheck : a.Personal_Reference_Checks__r){          
                perRefCheck.Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
                perRefCheck.Phone_Number__c = GEN_OriginationsConstants.TOKEN_VALUE;
                perRefCheck.Relationship__c = GEN_OriginationsConstants.TOKEN_VALUE;                                
                lst_recordsToUpdate6.add(perRefCheck);  
            }

            //Remove tokenized data on related documents.
            for(Related_Document__c relatedDocument : a.Related_Documents__r){          
                relatedDocument.Title__c = GEN_OriginationsConstants.TOKEN_VALUE;                               
                lst_recordsToUpdate7.add(relatedDocument);  
            }

            //Remove tokenized data on security.
            for(Collateral__c security : a.Collaterals__r){         
                security.Collateral_Eng_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_HIN_Number__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_Insurance_Policy_number__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_Insurance_company_name__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_NVIC__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_Reg_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_State_of_Registration__c = GEN_OriginationsConstants.TOKEN_VALUE;
                security.Collateral_VIN_No__c = GEN_OriginationsConstants.TOKEN_VALUE;                                                                                                                                                                                  
                lst_recordsToUpdate8.add(security); 
            }                                               
        }
 
        // Put XXXXX on children of applicants
        for(Applicant__c app : lst_Applicant){
            app.Date_of_Birth_WS__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Date_of_Birth__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Drivers_Lic_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Email_Address__c = app.id + GEN_OriginationsConstants.EMAIL_TOKEN_VALUE;
            app.First_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Home_Area_Code__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Home_WS__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Home__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Last_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Middle_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Mobile__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Previous_Property_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Residential_Property_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Street_No_Pos__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Street_No_Pre__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Street_Res__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Unit_No_Pos__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Unit_No_Pre__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Unit_No_Res__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Work_Area_Code__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Work_WS__c = GEN_OriginationsConstants.TOKEN_VALUE;
            app.Work__c = GEN_OriginationsConstants.TOKEN_VALUE;                                                                                                                                                            
            lst_recordsToUpdate9.add(app);                                                                                                      
            
            //Remove the tokenized data from AML and put XXXXXX.
            for(AML__c aml : app.AMLs__r){
                aml.ID_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                aml.Staff_ID_Sighted_By__c = GEN_OriginationsConstants.TOKEN_VALUE;                                             
                lst_recordsToUpdate10.add(aml);
            }
            
            //Remove the tokenized data from Expense and put XXXXXX.
            for(Expense__c exp : app.Expenses__r){
                exp.Agent_Landlord_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
                exp.Agent_Landlord_Phone_Number__c = GEN_OriginationsConstants.TOKEN_VALUE;
                lst_recordsToUpdate11.add(exp);
            }
            
            //Remove the tokenized data from Income and put XXXXXX.
            for(Income__c income : app.Incomes__r){
                income.Emp_Bus_Contact_No__c = GEN_OriginationsConstants.TOKEN_VALUE;
                income.Emp_Bus_Name__c = GEN_OriginationsConstants.TOKEN_VALUE;
                lst_recordsToUpdate12.add(income);
            }
        }
        
        lst_recordsToUpdate.sort(); 
        lst_recordsToUpdate2.sort(); 
        lst_recordsToUpdate3.sort(); 
        lst_recordsToUpdate4.sort(); 
        lst_recordsToUpdate5.sort(); 
        lst_recordsToUpdate6.sort(); 
        lst_recordsToUpdate7.sort(); 
        lst_recordsToUpdate8.sort(); 
        lst_recordsToUpdate9.sort(); 
        lst_recordsToUpdate10.sort(); 
        lst_recordsToUpdate11.sort(); 
        lst_recordsToUpdate12.sort(); 
        
        //Update activities, boolean parameter set to false so success records will update
        List<Database.SaveResult> dsrs = Database.Update(lst_recordsToUpdate, false);
        List<Database.SaveResult> dsrs2 = Database.Update(lst_recordsToUpdate2, false);
        List<Database.SaveResult> dsrs3 = Database.Update(lst_recordsToUpdate3, false);
        List<Database.SaveResult> dsrs4 = Database.Update(lst_recordsToUpdate4, false);
        List<Database.SaveResult> dsrs5 = Database.Update(lst_recordsToUpdate5, false);
        List<Database.SaveResult> dsrs6 = Database.Update(lst_recordsToUpdate6, false);
        List<Database.SaveResult> dsrs7 = Database.Update(lst_recordsToUpdate7, false);
        List<Database.SaveResult> dsrs8 = Database.Update(lst_recordsToUpdate8, false);
        List<Database.SaveResult> dsrs9 = Database.Update(lst_recordsToUpdate9, false);
        List<Database.SaveResult> dsrs10 = Database.Update(lst_recordsToUpdate10, false);
        List<Database.SaveResult> dsrs11 = Database.Update(lst_recordsToUpdate11, false);
        List<Database.SaveResult> dsrs12 = Database.Update(lst_recordsToUpdate12, false);
    }
}