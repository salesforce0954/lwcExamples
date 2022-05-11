public without sharing class PersonalLoanAppSubmit {
    

    /**
     * Entry point for Application submit from Broker Portal
     */
    
    @AuraEnabled
    public static String applicationSubmit(String primaryApplicantDetailsObj){
        String latitudeUid;
        Savepoint sp = Database.setSavepoint();
        try {
            System.debug('APEX ENTER '+primaryApplicantDetailsObj);
            PrimaryApplicantDetailsWrapper padw = new PrimaryApplicantDetailsWrapper();
            String applicants;
            if(!String.isBlank(primaryApplicantDetailsObj)){
                padw = (PrimaryApplicantDetailsWrapper)JSON.deserialize(primaryApplicantDetailsObj, PrimaryApplicantDetailsWrapper.class);
            }
            
            System.debug('APEX A '+padw.personalDetails.QuoteId);
            System.debug('APEX B '+padw.loanDetails);
            System.debug('APEX C '+padw.personalDetails);
            System.debug('APEX C1 '+padw.personalDetailsJoint);
            System.debug('APEX D '+padw.employmentDetails);
            System.debug('APEX D1 '+padw.employmentDetailsJoint);
            System.debug('APEX E '+padw.employmentDetails.IncomeInfo);
            System.debug('APEX E1 '+padw.employmentDetailsJoint.IncomeInfo);
            System.debug('APEX F '+padw.expenseDetails);
            System.debug('APEX F1 '+padw.expenseDetailsJoint);
            
            
            
            if(padw != null && padw.personalDetails != null && padw.personalDetails.LatitudeUid != null){
                latitudeUid = padw.personalDetails.LatitudeUid;  
                applicants = padw.loanDetails.Applicants;
                System.debug('APPLICANTS: '+applicants);
            }

            //Application & Product Item
            String applicationId = PL_AppSubmit_AppCreate.createApplicationRecord(padw);
            System.debug('DONE APP ID: '+applicationId);

            //Objectives & Requirements
            String onrId = PL_AppSubmit_AppCreate.createONRRecord(padw,applicationId); 

             //Loan Purpose
            PL_AppSubmit_AppCreate.createLoanPurposeRecord(padw,applicationId,onrId);

            // //Applicant, Income, Expense
            List<Applicant__c> applicantList = PL_AppSubmit_ApplicantCreate.createApplicantRecord(padw,applicationId,applicants);
            //Get the Primary & Joint Applicant Ids
            String primaryApplicantId;
            String jointApplicantId;
            for(Applicant__c appObj : applicantList){
                System.debug('IPA: '+appObj.Is_Primary_Applicant__c);
                if(appObj.Is_Primary_Applicant__c){
                    primaryApplicantId = appObj.Id;
                }else{
                    jointApplicantId = appObj.Id;
                }
            }
            System.debug('primaryApplicantId '+primaryApplicantId);
            System.debug('jointApplicantId '+jointApplicantId);

            // Income for Primary Applicant
            PL_AppSubmit_ApplicantCreate.createIncomeRecord(padw.employmentDetails.IncomeInfo, primaryApplicantId);
            // Expense for Primary Applicant
            PL_AppSubmit_ApplicantCreate.createExpenseRecord(padw.expenseDetails,primaryApplicantId);

            if(applicants == '2'){
                System.debug('INSIDE 2 APPLICANTS INCOME EXPENSE');
                //Income for Joint Applicant
                PL_AppSubmit_ApplicantCreate.createIncomeRecord(padw.employmentDetailsJoint.IncomeInfo, jointApplicantId);

                //Expense for Joint Applicant (Dummy record post RL changes):
                    PL_AppSubmit_ApplicantCreate.createExpenseRecordJoint(jointApplicantId);

            }

            //Asset
            PL_AppSubmit_ApplicantCreate.createAssetRecord(padw,primaryApplicantId);

            //Debt 
            PL_AppSubmit_ApplicantCreate.createDebtRecord(padw,primaryApplicantId);

            //Disbursement
            PL_AppSubmit_AppCreate.createDisbursementRecord(padw,applicationId);

            //Create Person Account & Update Application & Applicant
            //PL_AppSubmit_ApplicantCreate.createAndLinkAccount(applicationId, applicantId,padw);

            //Change Quote Status to Converted to Application
            changeQuoteStatus(padw.personalDetails.QuoteId,applicationId);

            //Submit Application to Activate
            submitAppToDatapower(applicationId);


            return latitudeUid;


        } catch (Exception e) {
            Database.rollback(sp);
            ErrorHandlerException.recordException(e.getMessage() + ': ' + e.getStackTraceString(), 'applicationSubmit', 'Application', 'PersonalLoanAppSubmit', null); 
            throw new AppSubmitException(e.getMessage());
            
        }
    }

    /**
     * Submit the Application created in Salesforce to Datapower.
     */
    @future(callout=true)
    private static void submitAppToDatapower(String applicationId){
        String requestedName =  Web_Service_Settings__c.getValues('Requested Name Customer').Value__c;
        List<IS_ValidationError> validationErrors = IS_ApplicationSubmit.applicationSubmitRequest(applicationId,false, requestedName, null);
        System.debug('ERRORS LIST: '+validationErrors);
    }

    /**
     * Change the Quote status
     */
    private static void changeQuoteStatus(String encryptedQuoteId, String applicationId){
        try{
            if(!String.isBlank(encryptedQuoteId)){
                Quote__c q = [SELECT Date_Of_Birth__c FROM Quote__c WHERE Id =:encryptedQuoteId];
                System.debug('XDOB: '+q);
                //String quoteId = EncryptionManager.decryptQuoteId(encryptedQuoteId);
                Quote__c quoteObj = new Quote__c();
                quoteObj.Id = encryptedQuoteId;
                quoteObj.Quote_Stage__c = 'Converted to Application';
                quoteObj.Application__c = applicationId;
                update quoteObj;
            }
        }catch(Exception e){
            throw new AppSubmitException('Error encountered while updating Quote status. Error Details: '+e.getMessage());
        }
        
    }
    
}