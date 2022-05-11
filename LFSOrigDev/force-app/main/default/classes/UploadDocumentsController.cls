/**
 * @Description: Controller class for fileUploadCmp Lightning Web Component
 * @Author: William Putra - VISEO Asia PTE Ltd
 * @Date Created: 28/07/2021
 * @History:
   =====================================================================
       28-07-21: Created - William Putra
   =====================================================================
 */

public without sharing class UploadDocumentsController {
    @AuraEnabled
    public static UDWrapper  getApplicationDetail(Id applicationId){
        try {
            Application__c application =  [SELECT Id, UID__c, 
                (SELECT ID, First_Name__c, Last_Name__c, Primary_Employment_Status__c, Is_Primary_Applicant__c from Applicant__r),
                (SELECT ID from Loan_Purpose__r WHERE Loan_Purpose_Value_Code__c = 'DC') 
                FROM Application__c 
                WHERE Id = :applicationId LIMIT 1];
            
            //put into wrapper
            UDWrapper udw = new UDWrapper();
            udw.application = application;
            udw.applicants = application.Applicant__r;
            udw.isDebtConsolidation = false;
            if(application.Loan_Purpose__r.size() > 0) {
                udw.isDebtConsolidation = true;
            }

            List<Income__c> listIncome = [SELECT ID, Applicant__c, Income_Source__c 
                                        FROM Income__c
                                        WHERE Applicant__c IN :udw.applicants];
            for(Income__c income: listIncome) {
                if(udw.mapApplicantIncome.get(income.Applicant__c) == null) {
                    udw.mapApplicantIncome.put(income.Applicant__c, new List<Income__c>{income});
                } else {
                    udw.mapApplicantIncome.get(income.Applicant__c).add(income);
                }
            }

            return udw;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class UDWrapper {
        @AuraEnabled public Application__c application{get;set;}
        @AuraEnabled public List<Applicant__c> applicants{get;set;}
        @AuraEnabled public boolean isDebtConsolidation {get;set;}
        @AuraEnabled public Map<Id, List<Income__c>> mapApplicantIncome {get;set;}

        public UDWrapper() {
            this.applicants = new List<Applicant__c>();
            this.mapApplicantIncome = new Map<Id, List<Income__c>>();
        }
    }
}